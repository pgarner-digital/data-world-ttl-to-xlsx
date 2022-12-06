package gov.fl.digital.ddw2infa.column;

import gov.fl.digital.ddw2infa.link.LinksMetadata;
import gov.fl.digital.ddw2infa.MetadataCache;
import gov.fl.digital.ddw2infa.schema.SchemasMetadata;
import org.apache.jena.query.QuerySolution;

import java.util.List;

public class ColumnsMetadata extends MetadataCache<ColumnPropertyMapper> {

    private static final String COLUMNS_QUERY_FILE_PATH = "columns-export.csv.rq";
    public static final String INFA_FILE_NAME = "custom.data.world.ColumnName.csv";

    @Override public String getOutputFileName() { return INFA_FILE_NAME; }

    @Override public String getQueryFilePath() { return COLUMNS_QUERY_FILE_PATH; }

    @Override protected String getCsvHeader() { return ColumnPropertyMapper.CSV_HEADER; }

    @Override protected List<ColumnPropertyMapper> getFieldMappers() {
        return ColumnPropertyMapper.MAPPERS;
    }

    @Override public String getLabel() { return "column"; }

    @Override protected void updateSchemas(
        QuerySolution querySolution,
        SchemasMetadata schemasMetadata,
        LinksMetadata linksMetadata
    ) {
        String dbName = ColumnPropertyMapper.databaseName.getPropertyValueFrom(querySolution);
        String schemaName = ColumnPropertyMapper.schema.getPropertyValueFrom(querySolution);
        schemasMetadata.addRecord(dbName, schemaName, linksMetadata);
    }

    @Override protected void updateLinks(QuerySolution querySolution, LinksMetadata linksMetadata) {
        String dbName = ColumnPropertyMapper.databaseName.getPropertyValueFrom(querySolution);
        String schemaName = ColumnPropertyMapper.schema.getPropertyValueFrom(querySolution);
        String tableName = ColumnPropertyMapper.tableName.getPropertyValueFrom(querySolution);
        String columnName = ColumnPropertyMapper.name.getPropertyValueFrom(querySolution);
        String columnId = ColumnPropertyMapper.iri.getPropertyValueFrom(querySolution);
        linksMetadata.addColumn(dbName, schemaName, tableName, columnName, columnId);
    }
}
