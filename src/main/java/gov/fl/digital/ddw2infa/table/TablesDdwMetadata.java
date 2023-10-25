package gov.fl.digital.ddw2infa.table;

import gov.fl.digital.ddw2infa.link.LinksMetadataCache;
import gov.fl.digital.ddw2infa.DdwMetadata;
import gov.fl.digital.ddw2infa.schema.SchemasMetadataCache;
import org.apache.jena.query.QuerySolution;

import java.util.List;

public class TablesDdwMetadata extends DdwMetadata<TablePropertyMapper> {
    public static final String INFA_FILE_NAME = "com.infa.odin.models.relational.Table.csv";
    public static final String INFA_TABLE_NAME = "TABLE_METADATA";

    @Override public String getQueryFilePath() { return "table-export.csv.rq"; }

    @Override public String getInfaTableName() { return INFA_TABLE_NAME; }

    @Override protected List<TablePropertyMapper> getPropertyMappers() { return TablePropertyMapper.MAPPERS; }

    @Override public String getLabel() { return "table"; }

    @Override protected void updateSchemas(
        QuerySolution querySolution,
        SchemasMetadataCache schemasMetadataCache,
        LinksMetadataCache linksMetadataCache
    ) {
        String dbName = TablePropertyMapper.databaseName.getPropertyValueFrom(querySolution);
        String schemaName = TablePropertyMapper.schema.getPropertyValueFrom(querySolution);
        schemasMetadataCache.addRecord(dbName, schemaName, linksMetadataCache);
    }

    @Override protected void updateLinks(QuerySolution querySolution, LinksMetadataCache linksMetadataCache) {
        String dbName = TablePropertyMapper.databaseName.getPropertyValueFrom(querySolution);
        String schemaName = TablePropertyMapper.schema.getPropertyValueFrom(querySolution);
        String tableName = TablePropertyMapper.name.getPropertyValueFrom(querySolution);
        String tableId = TablePropertyMapper.externalId.getPropertyValueFrom(querySolution);
        linksMetadataCache.addTableOrView(LinksMetadataCache.TableOrView.table, dbName, schemaName, tableName, tableId);
    }
}
