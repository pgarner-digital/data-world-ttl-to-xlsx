import org.apache.jena.query.*;
import org.apache.jena.rdf.model.Model;
import org.apache.jena.rdf.model.ModelFactory;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

public class Ddw2InfaCustomMetaModelProcessor {

    /************************************************  INPUTS  ********************************************************/
    private static final String OWNER = "FL-APD";

    private static final String FULL_GRAPH_TTL_FILE_PATH = "fl-apd-full-graph.ttl";

    /******************************************************************************************************************/

    private static final Logger logger = LogManager.getLogger(Ddw2InfaCustomMetaModelProcessor.class);

    public static void main(String[] args) throws IOException {

        LocalDateTime begin = LocalDateTime.now();
        Model model = loadModelFrom(FULL_GRAPH_TTL_FILE_PATH);

        DatabasesMetadata databasesMetadata = new DatabasesMetadata();
        SchemasMetadata schemasMetadata = new SchemasMetadata();
        TablesMetadata tablesMetadata = new TablesMetadata();
        ColumnsMetadata columnsMetadata = new ColumnsMetadata();
        LinksMetadata linksMetadata = new LinksMetadata();

        // TODO: in order to implement business glossary term, the INFA custom metamodel needs to be created.
        //BusinessGlossaryTermMetadata businessGlossaryTermMetadata = new BusinessGlossaryTermMetadata();

        executeQueriesAndGenerateCSV(model, columnsMetadata, 10000, ChronoUnit.MINUTES);
        logger.info("Total processing time: " + begin.until(LocalDateTime.now(), ChronoUnit.MINUTES) +
                " minutes).");
    }

    private static Model loadModelFrom(String ttlFilePath) {
        LocalDateTime begin = LocalDateTime.now();
        Model model = ModelFactory.createDefaultModel();
        logger.info("Begin loading " + ttlFilePath + " into model...");
        model.read(ttlFilePath);
        logger.info("Model loaded (" + begin.until(LocalDateTime.now(), ChronoUnit.SECONDS) + " seconds).");
        return model;
    }

    private static void executeQueriesAndGenerateCSV(
            Model model,
            MetadataMapper metadataMapper,
            int rowCountDisplayFrequency,
            ChronoUnit logEntryTimeUnit
    ) throws IOException {
        String queryString = Files.readString(Paths.get(metadataMapper.getQueryFilePath()));
        int rowCount = 1;
        Query query = QueryFactory.create(queryString);
        try (QueryExecution queryExecution = QueryExecutionFactory.create(query, model)) {
            ResultSet results = queryExecution.execSelect() ;
            LocalDateTime localDateTime = LocalDateTime.now();
            while (results.hasNext()) {
                if(rowCount % rowCountDisplayFrequency == 0) {
                    logger.info("Processing " + metadataMapper.getLabel() + " record: " + (rowCount + 1) +
                            "(" + localDateTime.until(LocalDateTime.now(), logEntryTimeUnit) + " " +
                            logEntryTimeUnit.name().toLowerCase() + ").");
                }
                QuerySolution querySolution = results.nextSolution();
                //TODO: metadataMapper.addRecord(querySolution);
            }
        }
        try (PrintWriter out = new PrintWriter(metadataMapper.getOutputFilePath())) {
            out.println(metadataMapper.getCSV());
        }
    }
}
