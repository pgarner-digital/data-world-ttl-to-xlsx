import org.apache.jena.query.QuerySolution;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class TablesMetadata implements MetadataMapper {

    private static final String TABLES_QUERY_FILE_PATH = "table-export.csv.rq";

    public static final String INFA_FILE_NAME = "custom.data.world.TableName.csv";

    private String values = "";

    private final Map<String,String> tableIriByDatabaseNameSchemaNameAndTableName = new HashMap<>();

    public void addRecord(QuerySolution querySolution) {

        values += "\n" + "\"" +
                Infa2DdwTablePropertyMapper.QUERYABLE.stream()
                        .map(mapper -> mapper.getPropertyValueFrom(querySolution))
                        .map(val -> { if (null == val) val = "\"\""; return "\"" + val + "\""; })
                        // Escape double quotes for proper CSV see https://stackoverflow.com/a/17808731/984932,
                        // and note that because data.world backslash-escapes double quotes, the backslashes are
                        // removed as part of the replace operation. Example: \"foo\" gets replaced with ""foo""
                        .map(val -> val.replace("\\\"", "\"\""))
                        .collect(Collectors.joining("\",\""))
                + "\"";

        tableIriByDatabaseNameSchemaNameAndTableName.put(
                Infa2DdwTablePropertyMapper.databaseName.getPropertyValueFrom(querySolution) +
                        Infa2DdwTablePropertyMapper.schema.getPropertyValueFrom(querySolution) +
                        Infa2DdwTablePropertyMapper.name.getPropertyValueFrom(querySolution),
                Infa2DdwTablePropertyMapper.externalId.getPropertyValueFrom(querySolution)
        );
    }

    public String getCSV() { return Infa2DdwTablePropertyMapper.CSV_HEADER + values; }

    public String getLabel() { return "table"; }

    @Override public String getQueryFilePath() { return TABLES_QUERY_FILE_PATH; }

    @Override public String getOutputFilePath() { return INFA_FILE_NAME; }

    public String getTableIriUsing(String databaseNameSchemaNameAndTableName) {
        return tableIriByDatabaseNameSchemaNameAndTableName.get(databaseNameSchemaNameAndTableName);
    }

    private enum Infa2DdwTablePropertyMapper {
        /*
            DDW:
                table_IRI
                table_name
                description
                data_ownner

                // TODO: the following DDW fields are used to link a table to its parent in the hierarchy
                database_name
                schema

                // TODO: the following DDW fields are not yet captured by the INFA custom data.world metamodel
                type_prefix
                type
                business_summary
                restricted_to_public_disclosure_per_federal_or_state_law
                sensitive_data
                data_sharing_agreement
                program_office
                data_steward
                technical_steward
                contact_email
                status

            INFA:

                core.externalId
                core.name
                core.description
                core.businessDescription
                core.businessName
                custom.data.world.owner
                core.reference
         */

        externalId("core.externalId", "table_IRI"),
        name("core.name", "table_name"),
        description("core.description", "description"),

        // TODO drop business description because we already have a description field
        businessDescription("core.businessDescription", null),
        businessName("core.businessName", null),

        // TODO: Steve Hill uses custom.data.world.dataOwner for Column
        dataOwner("custom.data.world.owner", "data_ownner"),
        reference("core.reference", null),

        // TODO: The following DDW fields may be added to the INFA custom metamodel.
        typePrefix(null, "type_prefix"),
        type(null, "type"),
        businessSummary(null, "business_summary"),
        restrictedToPublic(null, "restricted_to_public_disclosure_per_federal_or_state_law"),
        sensitiveData(null, "sensitive_data"),
        dataSharingAgreement(null, "data_sharing_agreement"),
        programOffice(null, "program_office"),
        dataSteward(null, "data_steward"),
        technicalSteward(null, "technical_steward"),
        contactEmail(null, "contact_email"),
        status(null, "status"),

        // TODO: the following DDW fields are used to link a table to its parent in the hierarchy
        databaseName(null, "database_name"),
        schema(null,"schema");

        private static final List<Infa2DdwTablePropertyMapper> QUERYABLE;
        private static final String CSV_HEADER;

        static {

            QUERYABLE = Arrays.stream(Infa2DdwTablePropertyMapper.values())
                    // Remove DW columns that don't have matching INFA columns because they aren't used
                    .filter(i -> null != i.ddwColumnName && null != i.infaColumnName)
                    .collect(Collectors.toList());

            CSV_HEADER = QUERYABLE.stream()
                    .map(mapper -> mapper.infaColumnName)
                    .collect(Collectors.joining(","));
        }

        final String infaColumnName;
        final String ddwColumnName;

        Infa2DdwTablePropertyMapper(String infaColumnName, String ddwColumnName) {
            this.infaColumnName = infaColumnName;
            this.ddwColumnName = ddwColumnName;
        }

        public String getPropertyValueFrom(QuerySolution querySolution) {
            return Util.stringValueOf(querySolution.get(ddwColumnName));
        }
    }
}
