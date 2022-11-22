import org.apache.jena.query.QuerySolution;

import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class SchemasMetadata implements MetadataMapper {

    public static final String INFA_FILE_NAME = "custom.data.world.SchemaName.csv";
    public static final String NO_NAME_LABEL = "(Schema name unavailable)";

    private String values = "";

    private final Map<String,String> schemaIriBySchemaName = new HashMap<>();

    /**
     * This method is the only means to add column metadata to this object.  Clients invoke this method
     * repeatedly, once for each "query solution" record in an RDF result set.
     */
    public void addRecord(String externalID, String name, String owner) {

        if(null == name || name.equalsIgnoreCase("")) {
            throw new IllegalStateException("No schema name for externalID: " + externalID + " and owner: " + owner);
        }
        values += ("\n" + "\"" + externalID + "\",\"" + name + "\",\"" + owner + "\"");

        schemaIriBySchemaName.put(name, externalID);
    }

    /**
     * This method is the only means to retrieve output, CSV as a string, from this object.
     *
     * @return A string containing newline (\n) character separated column metadata records in CSV format.
     */
    @Override public String getCSV() { return Infa2DdwSchemaMapper.CSV_HEADER + values; }

    @Override public String getLabel() { return "schema"; }

    @Override public String getQueryFilePath() {
        // TODO: determine if SchemaMetadata even needs to implement MetadataMapper
        throw new UnsupportedOperationException();
    }

    public String getSchemaIriUsing(String schemaName) { return schemaIriBySchemaName.get(schemaName); }

    @Override
    public String getOutputFilePath() { return INFA_FILE_NAME; }

    private enum Infa2DdwSchemaMapper {
        externalId("core.externalId"),
        name("core.name"),

        // TODO: Steve Hill uses custom.data.world.dataOwner for Column
        dataOwner("custom.data.world.owner"),

        description("core.description"),
        assignable("core.assignable"),
        businessDescription("core.businessDescription"),
        businessName("core.businessName"),
        reference("core.reference");

        final String infaColumnName;

        Infa2DdwSchemaMapper(String infaColumnName) { this.infaColumnName = infaColumnName; }

        private static final String CSV_HEADER;

        static {
            CSV_HEADER = Stream.of(values())
                    .map(mapper -> mapper.infaColumnName)
                    .collect(Collectors.joining(","));
        }
    }
}
