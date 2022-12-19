import gov.fl.digital.ddw2infa.MetadataCache;
import gov.fl.digital.ddw2infa.MetadataMapper;
import gov.fl.digital.ddw2infa.Util;
import gov.fl.digital.ddw2infa.column.ColumnsMetadata;
import gov.fl.digital.ddw2infa.database.DatabasesMetadata;
import gov.fl.digital.ddw2infa.link.LinksMetadata;
import gov.fl.digital.ddw2infa.schema.SchemasMetadata;
import gov.fl.digital.ddw2infa.table.TablesMetadata;
import org.apache.jena.query.*;
import org.apache.jena.rdf.model.Model;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URL;
import java.nio.file.Files;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

public class Ddw2InfaCustomMetaModelProcessor {

    /************************************************  INPUTS  ********************************************************/
    private static final String OWNER = "APD";
    private static final String FULL_GRAPH_TTL_FILE_PATH = "fl-apd-full-graph.ttl";
    /******************************************************************************************************************/

    private static final Logger logger = LogManager.getLogger(Ddw2InfaCustomMetaModelProcessor.class);
    public static final String OUTPUT_DIRECTORY_PATH = "./output/" + OWNER + "/informatica_import/";

    public static void main(String[] args) throws IOException {

        LocalDateTime begin = LocalDateTime.now();
        Model model = Util.loadModelFrom(FULL_GRAPH_TTL_FILE_PATH);

        DatabasesMetadata databasesMetadata = new DatabasesMetadata();
        SchemasMetadata schemasMetadata = new SchemasMetadata();
        TablesMetadata tablesMetadata = new TablesMetadata();
        ColumnsMetadata columnsMetadata = new ColumnsMetadata();
        LinksMetadata linksMetadata = new LinksMetadata();

        logger.info("Extracting database metadata");
        executeQueryAndGenerateCSV(model, databasesMetadata, schemasMetadata, linksMetadata, 100, ChronoUnit.SECONDS);
        logger.info("Extracting table metadata");
        executeQueryAndGenerateCSV(model, tablesMetadata, schemasMetadata, linksMetadata, 100, ChronoUnit.SECONDS);
        logger.info("Extracting column metadata");
        executeQueryAndGenerateCSV(model, columnsMetadata, schemasMetadata, linksMetadata, 10000, ChronoUnit.MINUTES);

        // TODO: Future work: to implement business glossary term, the INFA custom metamodel needs to be updated.
        /*
        BusinessGlossaryTermMetadata businessGlossaryTermMetadata = new BusinessGlossaryTermMetadata();
        executeQueryAndGenerateCSV(model, businessGlossaryTermMetadata, schemasMetadata, linksMetadata, 100, ChronoUnit.SECONDS);
        */

        schemasMetadata.generateCsvFile(OUTPUT_DIRECTORY_PATH);
        linksMetadata.generateCsvFile(OUTPUT_DIRECTORY_PATH);

        logger.info("Total processing time: " + begin.until(LocalDateTime.now(), ChronoUnit.MINUTES) +
                " minutes).");
    }

    private static <X extends MetadataMapper<X>> void executeQueryAndGenerateCSV(
        Model model,
        MetadataCache<X> metadataCache,
        SchemasMetadata schemasMetadata,
        LinksMetadata linksMetadata,
        int rowCountDisplayFrequency,
        ChronoUnit logEntryTimeUnit
    ) throws IOException {

        URL url = Ddw2InfaCustomMetaModelProcessor.class.getClassLoader().getResource(metadataCache.getQueryFilePath());
        if(null == url) { throw new IllegalArgumentException(metadataCache.getQueryFilePath() + " is not found."); }
        File file = new File(url.getFile());
        String queryString = new String(Files.readAllBytes(file.toPath()));
        int rowCount = 1;
        Query query = QueryFactory.create(queryString);
        try (QueryExecution queryExecution = QueryExecutionFactory.create(query, model)) {
            ResultSet results = queryExecution.execSelect() ;
            LocalDateTime localDateTime = LocalDateTime.now();
            while (results.hasNext()) {
                if(rowCount % rowCountDisplayFrequency == 0) {
                    logger.info("Processing " + metadataCache.getLabel() + " record: " + (rowCount + 1) +
                            "(" + localDateTime.until(LocalDateTime.now(), logEntryTimeUnit) + " " +
                            logEntryTimeUnit.name().toLowerCase() + ").");
                }
                QuerySolution querySolution = results.nextSolution();
                metadataCache.addRecord(querySolution, schemasMetadata, linksMetadata);
                rowCount++;
            }
        }
        try (PrintWriter out = new PrintWriter(OUTPUT_DIRECTORY_PATH + metadataCache.getOutputFileName())) {
            out.println(metadataCache.getCSV());
        }
    }
}
