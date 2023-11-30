package gov.fl.digital.ddw2infa.view;

import gov.fl.digital.ddw2infa.DdwMetadata;
import gov.fl.digital.ddw2infa.MetadataMapper;
import gov.fl.digital.ddw2infa.link.LinksMetadataCache;
import gov.fl.digital.ddw2infa.schema.SchemasMetadataCache;
import gov.fl.digital.ddw2infa.viewcolumn.ViewColumnsDdwMetadata;
import org.apache.jena.query.QuerySolution;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.List;

public class ViewsDdwMetadata extends DdwMetadata {
    private static final Logger logger = LogManager.getLogger(ViewsDdwMetadata.class);

    public static final String INFA_FILE_NAME = "com.infa.odin.models.relational.View.csv";
    public static final String INFA_TABLE_NAME = "VIEW_METADATA";

    @Override public String getQueryFilePath() { return "view-export.csv.rq"; }

    @Override public String getInfaTableName() { return INFA_TABLE_NAME; }

    @Override protected MetadataMapper[] getPropertyMappers() { return ViewPropertyMapper.MAPPERS; }

    @Override public String getLabel() { return "view"; }

    @Override protected void updateSchemas(
        QuerySolution querySolution,
        SchemasMetadataCache schemasMetadataCache,
        LinksMetadataCache linksMetadataCache
    ) {
        String databaseIRI = ViewPropertyMapper.databaseIRI.getPropertyValueFrom(querySolution);
        String schemaName = ViewPropertyMapper.owner.getPropertyValueFrom(querySolution);
        schemasMetadataCache.addRecord(databaseIRI, schemaName, linksMetadataCache);
    }

    @Override protected void updateLinks(QuerySolution querySolution, LinksMetadataCache linksMetadataCache) {
        String databaseIRI = ViewPropertyMapper.databaseIRI.getPropertyValueFrom(querySolution);
        String schemaName = ViewPropertyMapper.owner.getPropertyValueFrom(querySolution);
        String viewName = ViewPropertyMapper.name.getPropertyValueFrom(querySolution);
        String viewId = ViewPropertyMapper.externalId.getPropertyValueFrom(querySolution);
        linksMetadataCache.addTableOrView(LinksMetadataCache.TableOrView.view, databaseIRI, schemaName, viewName, viewId);
    }

    @Override protected Logger getLogger() { return logger; }
}
