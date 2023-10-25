package gov.fl.digital.ddw2infa.view;

import gov.fl.digital.ddw2infa.DdwMetadata;
import gov.fl.digital.ddw2infa.link.LinksMetadataCache;
import gov.fl.digital.ddw2infa.schema.SchemasMetadataCache;
import org.apache.jena.query.QuerySolution;

import java.util.List;

public class ViewsDdwMetadata extends DdwMetadata<ViewPropertyMapper> {
    public static final String INFA_FILE_NAME = "com.infa.odin.models.relational.View.csv";
    public static final String INFA_TABLE_NAME = "VIEW_METADATA";

    @Override public String getQueryFilePath() { return "view-export.csv.rq"; }

    @Override public String getInfaTableName() { return INFA_TABLE_NAME; }

    @Override protected List<ViewPropertyMapper> getPropertyMappers() { return ViewPropertyMapper.MAPPERS; }

    @Override public String getLabel() { return "view"; }

    @Override protected void updateSchemas(
        QuerySolution querySolution,
        SchemasMetadataCache schemasMetadataCache,
        LinksMetadataCache linksMetadataCache
    ) {
        String dbName = ViewPropertyMapper.databaseName.getPropertyValueFrom(querySolution);
        String schemaName = ViewPropertyMapper.schema.getPropertyValueFrom(querySolution);
        schemasMetadataCache.addRecord(dbName, schemaName, linksMetadataCache);
    }

    @Override protected void updateLinks(QuerySolution querySolution, LinksMetadataCache linksMetadataCache) {
        String dbName = ViewPropertyMapper.databaseName.getPropertyValueFrom(querySolution);
        String schemaName = ViewPropertyMapper.schema.getPropertyValueFrom(querySolution);
        String viewName = ViewPropertyMapper.name.getPropertyValueFrom(querySolution);
        String viewId = ViewPropertyMapper.externalId.getPropertyValueFrom(querySolution);
        linksMetadataCache.addTableOrView(LinksMetadataCache.TableOrView.view, dbName, schemaName, viewName, viewId);
    }
}
