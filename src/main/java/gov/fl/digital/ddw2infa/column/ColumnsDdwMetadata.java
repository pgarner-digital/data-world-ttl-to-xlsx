package gov.fl.digital.ddw2infa.column;

import gov.fl.digital.ddw2infa.MetadataMapper;
import gov.fl.digital.ddw2infa.link.LinksMetadataCache;
import gov.fl.digital.ddw2infa.DdwMetadata;
import gov.fl.digital.ddw2infa.schema.SchemasMetadataCache;
import gov.fl.digital.ddw2infa.viewcolumn.ViewColumnsDdwMetadata;
import org.apache.jena.query.QuerySolution;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.List;

public class ColumnsDdwMetadata extends DdwMetadata {
    private static final Logger logger = LogManager.getLogger(ColumnsDdwMetadata.class);

    public static final String INFA_FILE_NAME = "com.infa.odin.models.relational.Column.csv";
    public static final String INFA_TABLE_NAME = "COLUMN_METADATA";

    @Override public String getQueryFilePath() { return "columns-export.csv.rq"; }

    @Override public String getInfaTableName() { return INFA_TABLE_NAME; }

    @Override protected MetadataMapper[] getPropertyMappers() {
        return ColumnPropertyMapper.MAPPERS;
    }

    @Override public String getLabel() { return "column"; }

    @Override protected void updateSchemas(
        QuerySolution querySolution,
        SchemasMetadataCache schemasMetadataCache,
        LinksMetadataCache linksMetadataCache
    ) {
        String dbName = ColumnPropertyMapper.databaseName.getPropertyValueFrom(querySolution);
        String schemaName = ColumnPropertyMapper.schema.getPropertyValueFrom(querySolution);
        schemasMetadataCache.addRecord(dbName, schemaName, linksMetadataCache);
    }

    @Override protected void updateLinks(QuerySolution querySolution, LinksMetadataCache linksMetadataCache) {
        String dbName = ColumnPropertyMapper.databaseName.getPropertyValueFrom(querySolution);
        String schemaName = ColumnPropertyMapper.schema.getPropertyValueFrom(querySolution);
        String tableName = ColumnPropertyMapper.tableName.getPropertyValueFrom(querySolution);
        String columnName = ColumnPropertyMapper.name.getPropertyValueFrom(querySolution);
        String columnId = ColumnPropertyMapper.externalId.getPropertyValueFrom(querySolution);
        linksMetadataCache.addColumnOrViewColumn(
            LinksMetadataCache.TableOrView.table,
            dbName,
            schemaName,
            tableName,
            columnName,
            columnId
        );
    }

    @Override protected Logger getLogger() { return logger; }
}
