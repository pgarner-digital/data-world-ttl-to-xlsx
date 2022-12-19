package gov.fl.digital.ddw2infa;

import gov.fl.digital.ddw2infa.link.LinksMetadata;
import gov.fl.digital.ddw2infa.schema.SchemasMetadata;
import org.apache.jena.query.QuerySolution;

import java.util.List;
import java.util.stream.Collectors;

public abstract class MetadataCache<X extends MetadataMapper<X>> {

    protected String values = "";

    public final void addRecord(
        QuerySolution querySolution,
        SchemasMetadata schemasMetadata,
        LinksMetadata linksMetadata
    ) {
        values += "\n" +
            getFieldMappers().stream()
                .map(mapper -> mapper.getPropertyValueFrom(querySolution))

                .map(fieldValue -> { if (fieldValue.isBlank()) fieldValue = ""; return "\"" + fieldValue + "\""; })

                // TODO: remove double quote "wrappers"
                //.map(fieldValue -> { if (fieldValue.isBlank()) fieldValue = ""; return fieldValue; })

                // Escape double quotes for proper CSV see https://stackoverflow.com/a/17808731/984932,
                // and note that because data.world backslash-escapes double quotes, the backslashes are
                // removed as part of the replace operation. Example: \"foo\" gets replaced with ""foo""
                .map(fieldValue -> fieldValue.replace("\\\"", "\"\""))

                // TODO: get rid of double quotes in metadata
                //.map(fieldValue -> fieldValue.replaceAll("\\\"", ""))

                // TODO: get rid of commas in metadata
                //.map(fieldValue -> fieldValue.replaceAll(",", ""))

                .collect(Collectors.joining(","));

        manageLinksAndSchemas(querySolution, schemasMetadata, linksMetadata);
    }

    public final String getCSV() { return getCsvHeader() + values; }
    public abstract String getLabel();
    public abstract String getQueryFilePath();
    public abstract String getOutputFileName();

    protected void manageLinksAndSchemas(
            QuerySolution querySolution,
            SchemasMetadata schemasMetadata,
            LinksMetadata linksMetadata
    ) {
        /*
            Normally, metadata objects need to update schemas first because schemas are higher in the hierarchy
            and must exist before adding this metadata object to the tree.  Links for this metadata object are
            created second because this object is lower in the tree.

            For databases, it's different.  Databases are higher than schemas in the tree hierarchy.  So
            DatabasesMetadata overrides this method, updating links first and schemas second.
         */
        updateSchemas(querySolution, schemasMetadata, linksMetadata);
        updateLinks(querySolution, linksMetadata);
    }

    protected abstract String getCsvHeader();
    protected abstract List<X> getFieldMappers();
    protected abstract void updateSchemas(
            QuerySolution querySolution,
            SchemasMetadata schemasMetadata,
            LinksMetadata linksMetadata
    );
    protected abstract void updateLinks(QuerySolution querySolution, LinksMetadata linksMetadata);
}
