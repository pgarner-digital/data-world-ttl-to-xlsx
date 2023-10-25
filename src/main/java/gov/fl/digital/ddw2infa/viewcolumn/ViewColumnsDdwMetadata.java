package gov.fl.digital.ddw2infa.viewcolumn;

import gov.fl.digital.ddw2infa.DdwMetadata;
import gov.fl.digital.ddw2infa.link.LinksMetadataCache;
import gov.fl.digital.ddw2infa.schema.SchemasMetadataCache;
import org.apache.jena.query.QuerySolution;

import java.util.List;

public class ViewColumnsDdwMetadata extends DdwMetadata<ViewColumnPropertyMapper> {
    public static final String INFA_FILE_NAME = "com.infa.odin.models.relational.ViewColumn.csv";
    public static final String INFA_TABLE_NAME = "VIEW_COLUMN_METADATA";

    @Override public String getQueryFilePath() { return "view-columns-export.csv.rq"; }

    @Override public String getInfaTableName() { return INFA_TABLE_NAME; }

    @Override protected List<ViewColumnPropertyMapper> getPropertyMappers() {
        return ViewColumnPropertyMapper.MAPPERS;
    }

    @Override public String getLabel() { return "view-column"; }

    @Override protected void updateSchemas(
        QuerySolution querySolution,
        SchemasMetadataCache schemasMetadataCache,
        LinksMetadataCache linksMetadataCache
    ) {
        String dbName = ViewColumnPropertyMapper.databaseName.getPropertyValueFrom(querySolution);
        String schemaName = ViewColumnPropertyMapper.schema.getPropertyValueFrom(querySolution);
        schemasMetadataCache.addRecord(dbName, schemaName, linksMetadataCache);
    }

    @Override protected void updateLinks(QuerySolution querySolution, LinksMetadataCache linksMetadataCache) {
        String dbName = ViewColumnPropertyMapper.databaseName.getPropertyValueFrom(querySolution);
        String schemaName = ViewColumnPropertyMapper.schema.getPropertyValueFrom(querySolution);
        String tableName = ViewColumnPropertyMapper.tableName.getPropertyValueFrom(querySolution);
        String columnName = ViewColumnPropertyMapper.name.getPropertyValueFrom(querySolution);
        String columnId = ViewColumnPropertyMapper.externalId.getPropertyValueFrom(querySolution);
        linksMetadataCache.addColumnOrViewColumn(
            LinksMetadataCache.TableOrView.view,
            dbName,
            schemaName,
            tableName,
            columnName,
            columnId
        );
    }
}
