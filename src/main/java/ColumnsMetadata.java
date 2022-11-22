import org.apache.jena.query.QuerySolution;

import java.util.*;
import java.util.stream.Collectors;

public class ColumnsMetadata implements MetadataMapper {

    private static final String COLUMNS_QUERY_FILE_PATH = "columns-export.csv.rq";

    public static final String INFA_FILE_NAME = "custom.data.world.ColumnName.csv";

    private String values = "";

    private final Map<String,String> columnIriByDatabaseNameSchemaNameAndTableName = new HashMap<>();

    public void addRecord(QuerySolution querySolution) {

        values += "\n" + "\"" +
                Infa2DdwColumnPropertyMapper.QUERYABLE.stream()
                        .map(mapper -> mapper.getPropertyValueFrom(querySolution))
                        .map(val -> { if (null == val) val = "\"\""; return "\"" + val + "\""; })
                        // Escape double quotes for proper CSV see https://stackoverflow.com/a/17808731/984932, and also
                        // note that because data.world backslash-escapes double quotes, the backslashes are also
                        // removed as part of the replace operation. Example: \"foo\" gets replaced with ""foo""
                        .map(val -> val.replace("\\\"", "\"\""))
                        .collect(Collectors.joining("\",\"")) // Concat all the values into a double-pipe-separated string
                + "\"";

        columnIriByDatabaseNameSchemaNameAndTableName.put(
                Infa2DdwColumnPropertyMapper.databaseName.getPropertyValueFrom(querySolution) +
                        Infa2DdwColumnPropertyMapper.schema.getPropertyValueFrom(querySolution) +
                        Infa2DdwColumnPropertyMapper.tableName.getPropertyValueFrom(querySolution),
                Infa2DdwColumnPropertyMapper.name.getPropertyValueFrom(querySolution)
        );
    }

    @Override public String getCSV() { return Infa2DdwColumnPropertyMapper.CSV_HEADER + values; }

    @Override public String getLabel() { return "column"; }

    @Override public String getQueryFilePath() { return COLUMNS_QUERY_FILE_PATH; }

    @Override public String getOutputFilePath() { return INFA_FILE_NAME; }

    private enum Infa2DdwColumnPropertyMapper {

    /*
        DDW:
            type_prefix
            database_name
            table_name
            schema
            type
            column_name
            column_IRI
            description
            business_summary
            restricted_to_public_disclosure_per_federal_or_state_law
            sensitive_data
            data_ownner
            data_steward
            technical_steward
            status

        INFA:
            core.externalId
            custom.data.world.iri
            core.name
            core.description
            core.businessDescription
            core.businessName
            custom.data.world.businessSummary
            custom.data.world.columnTypeName
            custom.data.world.typePrefix
            custom.data.world.dataOwner
            custom.data.world.dataSteward
            custom.data.world.technicalSteward
            custom.data.world.restrictedToPublic
            custom.data.world.sensitiveData
            custom.data.world.status
            core.reference
            
    */

        externalId("core.externalId", "column_IRI"),
        iri("custom.data.world.iri", "column_IRI"),
        name("core.name", "column_name"),
        description("core.description", "description"),
        businessDescription("core.businessDescription", null),
        businessName("core.businessName", null),
        businessSummary("custom.data.world.businessSummary", "business_summary"),
        columnType("custom.data.world.columnTypeName", "type"),
        typePrefix("custom.data.world.typePrefix", "type_prefix"),

        // TODO: Steve Hill uses custom.data.world.owner for Table

        dataOwner("custom.data.world.dataOwner", "data_ownner"),
        dataSteward("custom.data.world.dataSteward", "data_steward"),
        technicalSteward("custom.data.world.technicalSteward", "technical_steward"),
        restrictedToPublic("custom.data.world.restrictedToPublic",
                "restricted_to_public_disclosure_per_federal_or_state_law"),
        sensitiveData("custom.data.world.sensitiveData", "sensitive_data"),
        status("custom.data.world.status", "status"),
        reference("core.reference", null),

        databaseName(null, "database_name"),
        tableName(null, "table_name"),
        schema(null, "schema");

        private static final List<Infa2DdwColumnPropertyMapper> QUERYABLE;
        private static final String CSV_HEADER;

        static {

            QUERYABLE = Arrays.stream(Infa2DdwColumnPropertyMapper.values())
                    // Remove DW columns that don't have matching INFA columns and vice versa because they aren't used
                    .filter(i -> null != i.ddwColumnName && null != i.infaColumnName)
                    .collect(Collectors.toList());

            CSV_HEADER = QUERYABLE.stream()
                    .map(mapper -> mapper.infaColumnName)
                    .collect(Collectors.joining(","));
        }

        final String infaColumnName;
        final String ddwColumnName;

        Infa2DdwColumnPropertyMapper(String infaColumnName, String ddwColumnName) {
            this.infaColumnName = infaColumnName;
            this.ddwColumnName = ddwColumnName;
        }

        public String getPropertyValueFrom(QuerySolution querySolution) {
            return Util.stringValueOf(querySolution.get(ddwColumnName));
        }
    }
}
