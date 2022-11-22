import java.util.stream.Collectors;
import java.util.stream.Stream;

public class LinksMetadata implements MetadataMapper {

    public static final String INFA_FILE_NAME = "links.csv";

    private String values = "";

    /**
     * This method is the only means to add column metadata to this object.  Clients invoke this method
     * repeatedly, once for each "query solution" record in an RDF result set.
     */
    public void addRecord(String source, String target, Infa2DdwLinkPropertyMapper infa2DdwLinkPropertyMapper) {
        values += ("\n" + "\"" + source + "\",\"" + target + "\",\"" + infa2DdwLinkPropertyMapper.association + "\"");
    }

    /**
     * This method is the only means to retrieve output, CSV as a string, from this object.
     *
     * @return A string containing newline (\n) character separated column metadata records in CSV format.
     */
    @Override
    public String getCSV() { return Infa2DdwLinkPropertyMapper.CSV_HEADER + values; }

    @Override
    public String getLabel() { return "link"; }

    @Override
    public String getQueryFilePath() {
        // TODO: determine if SchemaMetadata even needs to implement MetadataMapper
        throw new UnsupportedOperationException();
    }

    @Override
    public String getOutputFilePath() { return INFA_FILE_NAME; }

    public enum Infa2DdwLinkPropertyMapper {

        Root("core.ResourceParentChild"),
        DatabaseToSchema("custom.data.world.DatabaseToSchema"),
        SchemaToTable("custom.data.world.SchemaToTable"),
        TableToColumn("custom.data.world.TableToColumn");

        final String association;

        Infa2DdwLinkPropertyMapper(String association) { this.association = association; }

        private static final String CSV_HEADER;

        static {
            CSV_HEADER = Stream.of(values())
                    .map(mapper -> mapper.association)
                    .collect(Collectors.joining(","));
        }
    }
}
