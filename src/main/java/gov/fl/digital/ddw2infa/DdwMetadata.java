package gov.fl.digital.ddw2infa;

import gov.fl.digital.ddw2infa.link.LinksMetadataCache;
import gov.fl.digital.ddw2infa.schema.SchemasMetadataCache;
import org.apache.jena.query.QuerySolution;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.LinkedList;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

public abstract class DdwMetadata<X extends MetadataMapper> {
    private static final Logger logger = LogManager.getLogger(DdwMetadata.class);
    private final List<String[]> fieldRecords = new LinkedList<>();

    public final void obtainAndCacheRecord(
        QuerySolution querySolution,
        SchemasMetadataCache schemasMetadataCache,
        LinksMetadataCache linksMetadataCache
    ) {
        fieldRecords.add(
            getPropertyMappers().stream().map(mapper -> mapper.getPropertyValueFrom(querySolution))
                .toArray(String[]::new)
        );
        manageLinksAndSchemas(querySolution, schemasMetadataCache, linksMetadataCache);
    }

    public final void insertRecords(
        Connection connection,
        String orgId,
        LocalDateTime localDateTime
    )
        throws SQLException {
        Objects.requireNonNull(connection);
        Objects.requireNonNull(orgId);
        Objects.requireNonNull(localDateTime);
        String insertStatement = String.format(
            "INSERT INTO %s (\"orgId\"%s) VALUES (?%s)",
            getInfaTableName(),
            getPropertyMappers().stream().filter(MetadataMapper::hasDdwColumnName).map(mapper -> ", \"" + mapper.getInfaColumnName() + "\"").collect(Collectors.joining()),
            getPropertyMappers().stream().filter(MetadataMapper::hasDdwColumnName).map(mapper -> ", ?").collect(Collectors.joining())
        );
        //logger.info(insertStatement);
        try (PreparedStatement preparedStatement = connection.prepareStatement(insertStatement)) {
            int rowCount = 1, colCount;
            logger.info("Begin extracting results ...");
            for (String[] values : fieldRecords) {
                logger.info("Adding " + getLabel() + " record batch to prepared statement: " + rowCount++ + "(" +
                        localDateTime.until(LocalDateTime.now(), ChronoUnit.SECONDS) + " " +
                        ChronoUnit.SECONDS.name().toLowerCase() + ").");
                // Column #1, ORG_ID, is not in the result set.  It's set manually.
                colCount = 1;
                preparedStatement.setString(colCount++, orgId);

                for (String value : values) { preparedStatement.setString(colCount++, value); }
                preparedStatement.addBatch();
            }
            preparedStatement.executeBatch();
            logger.info("Committing " + getLabel() + " changes to snowflake.\n");
            connection.commit();
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

    protected abstract List<X> getPropertyMappers();
    protected abstract void updateSchemas(
        QuerySolution querySolution,
        SchemasMetadataCache schemasMetadataCache,
        LinksMetadataCache linksMetadataCache
    );

    protected abstract void updateLinks(QuerySolution querySolution, LinksMetadataCache linksMetadataCache);
}
