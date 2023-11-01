package gov.fl.digital.ddw2infa.schema;

import gov.fl.digital.ddw2infa.Util;
import gov.fl.digital.ddw2infa.link.LinksMetadataCache;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.UUID;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class SchemasMetadataCache {
    public static final String INFA_FILE_NAME = "com.infa.odin.models.relational.Schema.csv";
    public static final String INFA_TABLE_NAME = "SCHEMA_METADATA";

    public static final String SCHEMA_NAME_UNAVAILABLE = "(unavailable)";
    private static final Logger logger = LogManager.getLogger(SchemasMetadataCache.class);

    private final Map<String,Map<String,String>> schemaIdByDatabaseNameAndSchemaName = new HashMap<>();

    public void addRecord(String databaseName, String schemaName, LinksMetadataCache linksMetadataCache) {
        databaseName = databaseName.trim();

        // PeopleFirst team decided not to provide a schema name for the PF3 database.
        // If schemaName is not provided, it's manually set because it's used to
        // populate INFA's "core.name" field, which is required and cannot be empty.
        schemaName = Util.getSchemaNameHack(schemaName);

        String schemaId = "sch." + UUID.randomUUID().toString().replace("-", "");
        Map<String,String> schemaIdBySchemaName = schemaIdByDatabaseNameAndSchemaName.get(databaseName);
        if(null == schemaIdBySchemaName) {
            schemaIdBySchemaName = new HashMap<>();
            schemaIdByDatabaseNameAndSchemaName.put(databaseName, schemaIdBySchemaName);
            schemaIdBySchemaName.put(schemaName, schemaId);
        }
        else {
            if(!schemaIdBySchemaName.containsKey(schemaName)) { schemaIdBySchemaName.put(schemaName, schemaId); }
        }

        // Links management
        linksMetadataCache.addSchema(databaseName, schemaName, schemaId);
    }

    public void pushToSnowflake(
        Connection connection,
        LocalDateTime localDateTime,
        ChronoUnit chronoUnit,
        String orgId
    )
        throws SQLException {
        Objects.requireNonNull(connection);
        Objects.requireNonNull(localDateTime);
        Objects.requireNonNull(chronoUnit);

        //Data.world does not contain metadata for any INFA columns except for external ID and name.
        Infa2DdwSchemaMapper[] infa2DdwSchemaMappers = new Infa2DdwSchemaMapper[] {
            Infa2DdwSchemaMapper.externalId,
            Infa2DdwSchemaMapper.name,
            Infa2DdwSchemaMapper.description,
            Infa2DdwSchemaMapper.comment,
            Infa2DdwSchemaMapper.owner
        };
        String insertStatement = String.format(
            "INSERT INTO %s (\"orgId\"%s) VALUES (?%s)",
            INFA_TABLE_NAME,
            Stream.of(infa2DdwSchemaMappers).map(mapper -> ", \"" + mapper.infaColumnName + "\"").collect(Collectors.joining()),
            Stream.of(infa2DdwSchemaMappers).map(mapper -> ", ?").collect(Collectors.joining())
        );
        try (PreparedStatement preparedStatement = connection.prepareStatement(insertStatement)) {
            int rowCount = 1;
            logger.info("Begin extracting schemas from cache ...");
            for(Map<String,String> schemaIdBySchemaName : schemaIdByDatabaseNameAndSchemaName.values()) {
                for(Map.Entry<String,String> schemaNameAndId : schemaIdBySchemaName.entrySet()) {
                    logger.info("Adding schema record batch to prepared statement: " + rowCount++ + "(" +
                        localDateTime.until(LocalDateTime.now(), chronoUnit) + " " +
                        chronoUnit.name().toLowerCase() + ").");
                    String schemaName = schemaNameAndId.getKey();
                    String schemaId = schemaNameAndId.getValue();
                    // Column #1, ORG_ID, is not in the result set.  It's set manually.
                    preparedStatement.setString(1, orgId);
                    preparedStatement.setString(2, schemaId);
                    preparedStatement.setString(3, schemaName);
                    preparedStatement.setString(4, "");
                    preparedStatement.setString(5, "");
                    preparedStatement.setString(6, "");
                    preparedStatement.addBatch();
                }
            }
            preparedStatement.executeBatch();
            logger.info("Committing schema metadata changes to snowflake.\n");
            connection.commit();
        }
    }

    private enum Infa2DdwSchemaMapper {
    /*
        NOTE: core.externalId and core.name are mandatory fields
        https://onlinehelp.informatica.com/IICS/prod/MCC/en/index.htm#page/cloud-metadata-command-center-catalog-source-configuration/Example_Ingest_metadata_from_Microsoft_Access_database.html
     */
        externalId("core.externalId"),
        name("core.name"),
        description("core.description"),
        comment("com.infa.odin.models.relational.Comment"),
        owner("com.infa.odin.models.relational.Owner");

        final String infaColumnName;

        Infa2DdwSchemaMapper(String infaColumnName) { this.infaColumnName = infaColumnName; }
    }
}
