package gov.fl.digital.ddw2infa;

import gov.fl.digital.ddw2infa.link.LinksMetadataCache;
import gov.fl.digital.ddw2infa.schema.SchemasMetadataCache;
import org.apache.jena.query.QuerySolution;
import org.apache.logging.log4j.Logger;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.stream.Collectors;

public abstract class DdwMetadata {
    private final Map<String,Record> fieldRecords = new HashMap<>();

    public final void obtainAndCacheRecord(
        QuerySolution querySolution,
        SchemasMetadataCache schemasMetadataCache,
        LinksMetadataCache linksMetadataCache
    ) {
        MetadataMapper[] propertyMappers = getPropertyMappers();
        String[] recordValues = Arrays.stream(propertyMappers)
                .map(mapper -> mapper.removeSpecialCharacters(querySolution))
                .toArray(String[]::new);
        Record newOrDuplicateRecord = new Record(recordValues, propertyMappers);
        if(fieldRecords.containsKey(newOrDuplicateRecord.primaryKey)) {
            Record record = fieldRecords.get(newOrDuplicateRecord.primaryKey);
            record.addDuplicate(newOrDuplicateRecord);
        }
        else {
            fieldRecords.put(newOrDuplicateRecord.primaryKey, newOrDuplicateRecord);
        }

/*      TODO: For testing

        List<X> propertyMappers = getPropertyMappers();
        int colNum = 0;
        getLogger().info("\n\n");
        for(String fieldRecord: fieldRecords.get(fieldRecords.size()-1)) {
            X propertyMapper = propertyMappers.get(colNum++);
            String infaColumnName = propertyMapper.getInfaColumnName();

            getLogger().info(String.format("%s.%s = '%s'", getLabel(), infaColumnName, fieldRecord));
        }
        getLogger().info("\n");
*/

        manageLinksAndSchemas(querySolution, schemasMetadataCache, linksMetadataCache);
    }

    public final void insertRecords(
        Connection connection,
        String orgId,
        LocalDateTime localDateTime,
        int rowCountDisplayFrequency
    )
        throws SQLException {
        Objects.requireNonNull(connection);
        Objects.requireNonNull(orgId);
        Objects.requireNonNull(localDateTime);
        String nonDuplicateInsertStatement = getInsertStatement(false);
        getLogger().info(nonDuplicateInsertStatement);
        final List<Record> duplicates = new ArrayList<>();
        try (PreparedStatement preparedStatement = connection.prepareStatement(nonDuplicateInsertStatement)) {
            int rowCount = 1, colCount;
            getLogger().info("Begin extracting " + getLabel() + " results ...");
            for(Record record: fieldRecords.values()) {
                if(rowCount % rowCountDisplayFrequency == 0) {
                    getLogger().info(
                        "Adding " + getLabel() + " record batch to prepared statement: " + rowCount++ + "(" +
                        localDateTime.until(LocalDateTime.now(), ChronoUnit.SECONDS) + " " +
                        ChronoUnit.SECONDS.name().toLowerCase() + ")."
                    );
                }
                if(record.hasDuplicates()) { duplicates.add(record); }
                // Column #1, ORG_ID, is not in the result set.  It's set manually.
                colCount = 1;
                preparedStatement.setString(colCount++, orgId);
                for (String value : record.rowValues) { preparedStatement.setString(colCount++, value); }
                preparedStatement.addBatch();
            }
            preparedStatement.executeBatch();
            getLogger().info("Committing " + getLabel() + " metadata changes to snowflake.\n");
            connection.commit();
        }
        if(!duplicates.isEmpty()) {
            String duplicateInsertStatement = getInsertStatement(true);
            try (PreparedStatement preparedStatement = connection.prepareStatement(duplicateInsertStatement)) {
                int rowCount = 1, colCount;
                getLogger().info("Begin extracting " + getLabel() + " duplicate results ...");
                for(Record record: duplicates) {
                    if(rowCount % rowCountDisplayFrequency == 0) {
                        getLogger().info(
                            "Adding " + getLabel() + " duplicate record batch to prepared statement: " + rowCount++ + "(" +
                                localDateTime.until(LocalDateTime.now(), ChronoUnit.SECONDS) + " " +
                                ChronoUnit.SECONDS.name().toLowerCase() + ")."
                        );
                    }
                    // Column #1, ORG_ID, is not in the result set.  It's set manually.
                    for(String[] row : record.getOriginalRowPlusDuplicateRows()) {
                        colCount = 1;
                        preparedStatement.setString(colCount++, orgId);
                        for (String value : row) { preparedStatement.setString(colCount++, value); }
                        preparedStatement.addBatch();
                    }
                }
                preparedStatement.executeBatch();
                getLogger().info("Committing " + getLabel() + " duplicate metadata changes to snowflake.\n");
                connection.commit();
            }
        }
    }

    public abstract String getLabel();
    public abstract String getQueryFilePath();

    protected void manageLinksAndSchemas(
        QuerySolution querySolution,
        SchemasMetadataCache schemasMetadataCache,
        LinksMetadataCache linksMetadataCache
    ) {
        /*
            Normally, metadata objects need to update schemas first because schemas are higher in the hierarchy
            and must exist before adding this metadata object to the tree.  Links for this metadata object are
            created second because this object is lower in the tree.

            For databases, it's different.  Databases are higher than schemas in the tree hierarchy.  So
            DatabasesMetadata overrides this method, updating links first and schemas second.
         */
        updateSchemas(querySolution, schemasMetadataCache, linksMetadataCache);
        updateLinks(querySolution, linksMetadataCache);
    }

    public abstract String getInfaTableName();

    protected abstract MetadataMapper[] getPropertyMappers();

    protected abstract void updateSchemas(
        QuerySolution querySolution,
        SchemasMetadataCache schemasMetadataCache,
        LinksMetadataCache linksMetadataCache
    );

    protected abstract void updateLinks(QuerySolution querySolution, LinksMetadataCache linksMetadataCache);

    protected abstract Logger getLogger();

    private String getInsertStatement(boolean isDuplicate) {
        String tableName = getInfaTableName();
        if(isDuplicate) { tableName += "_duplicates"; }
        return String.format(
            "INSERT INTO %s (\"orgId\"%s) VALUES (?%s)",
            tableName,
            Arrays.stream(getPropertyMappers()).filter(MetadataMapper::hasDdwColumnName).
                map(mapper -> ", \"" + mapper.getInfaColumnName() + "\"").collect(Collectors.joining()),
            Arrays.stream(getPropertyMappers()).filter(MetadataMapper::hasDdwColumnName).
                map(mapper -> ", ?").collect(Collectors.joining())
        );
    }

    private static class Record implements Comparable<Record> {
        private final String primaryKey;
        private final String[] rowValues;
        private final List<String[]> duplicateRecords = new LinkedList<>();

        Record(String[] rowValues, MetadataMapper[] mappers) {
            Objects.requireNonNull(rowValues);
            Objects.requireNonNull(mappers);
            if(
                mappers.length > 0 &&
                mappers.length == rowValues.length &&   // mappers were used to obtain row-values, so length must be same
                mappers[0].name().equals("externalId")  // the first mapper MUST be the externalId mapper
            ) {
                this.primaryKey = rowValues[0];
                this.rowValues = rowValues;
            }
            else {
                throw new IllegalArgumentException("The first metadata mapper MUST be externalId");
            }
        }

        void addDuplicate(Record duplicateRecord) {
            Objects.requireNonNull(duplicateRecord);
            if(this.primaryKey.equals(duplicateRecord.primaryKey)) {
                duplicateRecords.add(rowValues);
            }
            else {
                throw new IllegalArgumentException("Attempt to add duplicate record having different primary key.");
            }
        }

        boolean hasDuplicates() { return duplicateRecords.size() > 1; }

        List<String[]> getOriginalRowPlusDuplicateRows() {
            List<String[]> temp = duplicateRecords;
            temp.add(rowValues);
            return temp;
        }

        @Override public int compareTo(Record that) { return this.primaryKey.compareTo(that.primaryKey); }

        @Override public boolean equals(Object that) {
            if (this == that) return true;
            if (that == null || getClass() != that.getClass()) return false;
            Record thatRecord = (Record) that;
            return this.primaryKey.equals(thatRecord.primaryKey);
        }

        @Override public int hashCode() { return Objects.hash(primaryKey); }

        public String[] getRowValues() { return rowValues; }
    }
}
