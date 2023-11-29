package gov.fl.digital.ddw2infa.database;

import gov.fl.digital.ddw2infa.MetadataMapper;
import gov.fl.digital.ddw2infa.column.ColumnsDdwMetadata;
import gov.fl.digital.ddw2infa.link.LinksMetadataCache;
import gov.fl.digital.ddw2infa.DdwMetadata;
import gov.fl.digital.ddw2infa.schema.SchemasMetadataCache;
import org.apache.jena.query.QuerySolution;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.List;
import java.util.stream.Stream;

public class DatabaseDdwMetadata extends DdwMetadata {
    private static final Logger logger = LogManager.getLogger(DatabaseDdwMetadata.class);
    public static final String INFA_FILE_NAME = "com.infa.odin.models.relational.Database.csv";
    public static final String INFA_TABLE_NAME = "DATABASE_METADATA";

    @Override public String getQueryFilePath() { return "data-source-export.csv.rq"; }

    @Override public String getInfaTableName() { return INFA_TABLE_NAME; }

    @Override protected MetadataMapper[] getPropertyMappers() { return DatabasePropertyMapper.MAPPERS; }

    @Override public String getLabel() { return "database"; }

    @Override protected void updateSchemas(
        QuerySolution querySolution,
        SchemasMetadataCache schemasMetadataCache,
        LinksMetadataCache linksMetadataCache
    ) {
        String dbName = DatabasePropertyMapper.name.getPropertyValueFrom(querySolution);
        String commaSeparatedSchemaNames = DatabasePropertyMapper.schemas.getPropertyValueFrom(querySolution);
        if(!commaSeparatedSchemaNames.isBlank()) {
            String[] schemaNames = commaSeparatedSchemaNames.split("\\s*,\\s*");
            Stream.of(schemaNames)
                .filter(schemaName -> !schemaName.isBlank())
                    .forEach(schemaName -> schemasMetadataCache.addRecord(dbName, schemaName, linksMetadataCache));
        }
    }

    @Override protected void updateLinks(QuerySolution querySolution, LinksMetadataCache linksMetadataCache) {
        String dbId = DatabasePropertyMapper.externalId.getPropertyValueFrom(querySolution);
        String dbName = DatabasePropertyMapper.name.getPropertyValueFrom(querySolution);
        linksMetadataCache.addDatabase(dbName, dbId);
    }

    @Override protected void manageLinksAndSchemas(
        QuerySolution querySolution,
        SchemasMetadataCache schemasMetadataCache,
        LinksMetadataCache linksMetadataCache
    ) {
        /*
            Normally, metadata objects need to update schemas first because schemas are higher in the hierarchy
            and must exist before adding this metadata object to the tree.

            For databases, it's different.  Databases are higher than schemas in the tree hierarchy.  So
            DatabasesMetadata overrides this method, updating links first and schemas second.
         */
        updateLinks(querySolution, linksMetadataCache);
        updateSchemas(querySolution, schemasMetadataCache, linksMetadataCache);
    }

    @Override protected Logger getLogger() { return logger; }
}