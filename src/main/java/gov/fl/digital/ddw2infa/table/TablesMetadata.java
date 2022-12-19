package gov.fl.digital.ddw2infa.table;

import gov.fl.digital.ddw2infa.link.LinksMetadata;
import gov.fl.digital.ddw2infa.MetadataCache;
import gov.fl.digital.ddw2infa.schema.SchemasMetadata;
import org.apache.jena.query.QuerySolution;

import java.util.List;

public class TablesMetadata extends MetadataCache<TablePropertyMapper> {

    private static final String TABLES_QUERY_FILE_PATH = "table-export.csv.rq";
    public static final String INFA_FILE_NAME = "custom.data.world.TableName.csv";

    @Override public String getOutputFileName() { return INFA_FILE_NAME; }

    @Override public String getQueryFilePath() { return TABLES_QUERY_FILE_PATH; }

    @Override protected String getCsvHeader() { return TablePropertyMapper.CSV_HEADER; }

    @Override protected List<TablePropertyMapper> getFieldMappers() { return TablePropertyMapper.MAPPERS; }

    @Override public String getLabel() { return "table"; }

    @Override protected void updateSchemas(
        QuerySolution querySolution,
        SchemasMetadata schemasMetadata,
        LinksMetadata linksMetadata
    ) {
        String dbName = TablePropertyMapper.databaseName.getPropertyValueFrom(querySolution);
        String schemaName = TablePropertyMapper.schema.getPropertyValueFrom(querySolution);
        schemasMetadata.addRecord(dbName, schemaName, linksMetadata);
    }

    @Override protected void updateLinks(QuerySolution querySolution, LinksMetadata linksMetadata) {
        String dbName = TablePropertyMapper.databaseName.getPropertyValueFrom(querySolution);
        String schemaName = TablePropertyMapper.schema.getPropertyValueFrom(querySolution);
        String tableName = TablePropertyMapper.name.getPropertyValueFrom(querySolution);
        String tableId = TablePropertyMapper.externalId.getPropertyValueFrom(querySolution);
        linksMetadata.addTable(dbName, schemaName, tableName, tableId);
    }
}
