package gov.fl.digital.ddw2infa.table;

import gov.fl.digital.ddw2infa.MetadataMapper;
import gov.fl.digital.ddw2infa.link.LinksMetadataCache;
import gov.fl.digital.ddw2infa.DdwMetadata;
import gov.fl.digital.ddw2infa.schema.SchemasMetadataCache;
import gov.fl.digital.ddw2infa.view.ViewsDdwMetadata;
import org.apache.jena.query.QuerySolution;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.List;

public class TablesDdwMetadata extends DdwMetadata {
    private static final Logger logger = LogManager.getLogger(TablesDdwMetadata.class);

    public static final String INFA_FILE_NAME = "com.infa.odin.models.relational.Table.csv";
    public static final String INFA_TABLE_NAME = "TABLE_METADATA";

    @Override public String getQueryFilePath() { return "table-export.csv.rq"; }

    @Override public String getInfaTableName() { return INFA_TABLE_NAME; }

    @Override protected MetadataMapper[] getPropertyMappers() { return TablePropertyMapper.MAPPERS; }

    @Override public String getLabel() { return "table"; }

    @Override protected void updateSchemas(
        QuerySolution querySolution,
        SchemasMetadataCache schemasMetadataCache,
        LinksMetadataCache linksMetadataCache
    ) {
        String dbName = TablePropertyMapper.databaseName.getPropertyValueFrom(querySolution);
        String schemaName = TablePropertyMapper.owner.getPropertyValueFrom(querySolution);
        schemasMetadataCache.addRecord(dbName, schemaName, linksMetadataCache);
    }

    @Override protected void updateLinks(QuerySolution querySolution, LinksMetadataCache linksMetadataCache) {
        String dbName = TablePropertyMapper.databaseName.getPropertyValueFrom(querySolution);
        String schemaName = TablePropertyMapper.owner.getPropertyValueFrom(querySolution);
        String tableName = TablePropertyMapper.name.getPropertyValueFrom(querySolution);
        String tableId = TablePropertyMapper.externalId.getPropertyValueFrom(querySolution);
        linksMetadataCache.addTableOrView(LinksMetadataCache.TableOrView.table, dbName, schemaName, tableName, tableId);
    }

    @Override protected Logger getLogger() { return logger; }
}
