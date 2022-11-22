import org.apache.jena.query.QuerySolution;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class DatabasesMetadata implements MetadataMapper {

    private static final String DATA_SOURCES_QUERY_FILE_PATH = "data-source-export.csv.rq";

    public static final String INFA_FILE_NAME = "custom.data.world.DatabaseName.csv";

    private String values = "";

    private final Map<String,String> databaseIriByDbName = new HashMap<>();

    public void addRecord(QuerySolution querySolution) {

        values += "\n" + "\"" +
                Infa2DdwDatabasePropertyMapper.QUERYABLE.stream()
                        .map(mapper -> mapper.getPropertyValueFrom(querySolution))
                        .map(val -> { if (null == val) val = "\"\""; return "\"" + val + "\""; })
                        // Escape double quotes for proper CSV see https://stackoverflow.com/a/17808731/984932,
                        // and note that because data.world backslash-escapes double quotes, the backslashes are
                        // removed as part of the replace operation. Example: \"foo\" gets replaced with ""foo""
                        .map(val -> val.replace("\\\"", "\"\""))
                        .collect(Collectors.joining("\",\""))
                + "\"";

        Stream.of(Infa2DdwDatabasePropertyMapper.schemas.getPropertyValueFrom(querySolution).split("\\s*,\\s*"))
                .map(schemaName -> {
                    if(null == schemaName || "".equalsIgnoreCase(schemaName)) {
                        throw new IllegalStateException("No schema name for database");
                    }
                    else return schemaName;
                })
                .map(String::trim)
                .forEach(schemaName ->
                    databaseIriByDbName.put(
                            Infa2DdwDatabasePropertyMapper.name.getPropertyValueFrom(querySolution),
                            Infa2DdwDatabasePropertyMapper.externalId.getPropertyValueFrom(querySolution)
                    )
                );
    }

    @Override public String getCSV() { return Infa2DdwDatabasePropertyMapper.CSV_HEADER + values; }

    @Override public String getLabel() { return "database"; }

    @Override public String getQueryFilePath() { return DATA_SOURCES_QUERY_FILE_PATH; }

    @Override public String getOutputFilePath() { return INFA_FILE_NAME; }

    public String getDatabaseIriUsing(String databaseNameAndSchemaName) {
        return databaseIriByDbName.get(databaseNameAndSchemaName);
    }

    private enum Infa2DdwDatabasePropertyMapper {

        /*
            DDW:
                databaseiri
                databaseName
                jdbcURL
                databaseServer
                databasePort
                schemas

            INFA:
                core.externalId
                core.name
                core.description
                core.assignable
                core.businessDescription
                core.businessName
                custom.data.world.owner
                core.reference
        */

        externalId("core.externalId", "databaseiri"),
        name("core.name", "databaseName"),
        description("core.description", null),
        assignable("core.assignable", null),
        businessDescription("core.businessDescription", null),
        businessName("core.businessName", null),

        // TODO: Steve Hill uses custom.data.world.dataOwner for Column

        dataOwner("custom.data.world.owner", null),
        reference("core.reference", null),

        // TODO: The following DDW fields may be added to the INFA custom metamodel.
        jdbcUrl(null,"jdbcURL"),
        databaseServer(null,"databaseServer"),
        databasePort(null,"databasePort"),
        schemas(null,"schemas");

        private static final List<Infa2DdwDatabasePropertyMapper> QUERYABLE;
        private static final String CSV_HEADER;

        static {
            QUERYABLE = Arrays.stream(Infa2DdwDatabasePropertyMapper.values())
                    // Remove DW columns that don't have matching INFA columns because they aren't used
                    .filter(i -> null != i.ddwColumnName && null != i.infaColumnName)
                    .collect(Collectors.toList());
            CSV_HEADER = QUERYABLE.stream()
                    .map(mapper -> mapper.infaColumnName)
                    .collect(Collectors.joining(","));
        }

        final String infaColumnName;
        final String ddwColumnName;

        Infa2DdwDatabasePropertyMapper(String infaColumnName, String ddwColumnName) {
            this.infaColumnName = infaColumnName;
            this.ddwColumnName = ddwColumnName;
        }

        public String getPropertyValueFrom(QuerySolution querySolution) {
            return Util.stringValueOf(querySolution.get(ddwColumnName));
        }
    }
}
