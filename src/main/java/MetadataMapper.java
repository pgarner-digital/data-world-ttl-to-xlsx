import org.apache.jena.query.QuerySolution;

public interface MetadataMapper {
    String getCSV();
    String getLabel();
    String getQueryFilePath();
    String getOutputFilePath();
}
