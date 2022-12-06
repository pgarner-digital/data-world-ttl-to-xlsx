package gov.fl.digital.ddw2infa.database;

import gov.fl.digital.ddw2infa.link.LinksMetadata;
import gov.fl.digital.ddw2infa.MetadataCache;
import gov.fl.digital.ddw2infa.schema.SchemasMetadata;
import org.apache.jena.query.QuerySolution;

import java.util.List;
import java.util.stream.Stream;

public class DatabasesMetadata extends MetadataCache<DatabasePropertyMapper> {

    private static final String DATA_SOURCES_QUERY_FILE_PATH = "data-source-export.csv.rq";
    public static final String INFA_FILE_NAME = "custom.data.world.DatabaseName.csv";

    @Override public String getOutputFileName() { return INFA_FILE_NAME; }

    @Override public String getQueryFilePath() { return DATA_SOURCES_QUERY_FILE_PATH; }

    @Override protected String getCsvHeader() { return DatabasePropertyMapper.CSV_HEADER; }

    @Override protected List<DatabasePropertyMapper> getFieldMappers() { return DatabasePropertyMapper.MAPPERS; }

    @Override public String getLabel() { return "database"; }

    @Override protected void updateSchemas(
        QuerySolution querySolution,
        SchemasMetadata schemasMetadata,
        LinksMetadata linksMetadata) {
        String dbName = DatabasePropertyMapper.name.getPropertyValueFrom(querySolution);
        String commaSeparatedSchemaNames = DatabasePropertyMapper.schemas.getPropertyValueFrom(querySolution);
        if(!commaSeparatedSchemaNames.isBlank()) {
            String[] schemaNames = commaSeparatedSchemaNames.split("\\s*,\\s*");
            Stream.of(schemaNames)
                .filter(schemaName -> !schemaName.isBlank())
                    .forEach(schemaName -> schemasMetadata.addRecord(dbName, schemaName, linksMetadata));
        }
    }

    @Override protected void updateLinks(QuerySolution querySolution, LinksMetadata linksMetadata) {
        String dbId = DatabasePropertyMapper.externalId.getPropertyValueFrom(querySolution);
        String dbName = DatabasePropertyMapper.name.getPropertyValueFrom(querySolution);
        linksMetadata.addDatabase(dbName, dbId);
    }
}