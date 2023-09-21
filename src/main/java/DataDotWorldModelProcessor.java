import gov.fl.digital.ddw2infa.Util;
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
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class DataDotWorldModelProcessor {

    /************************************************  INPUTS  ********************************************************/
    private static final String OWNER = "TEMPLATE";
    private static final String FULL_GRAPH_TTL_FILE_PATH = "fl-template.ttl";
    /******************************************************************************************************************/

    private static final Logger logger = LogManager.getLogger(DataDotWorldModelProcessor.class);

    public static final String OUTPUT_DIRECTORY_PATH = "./output/" + OWNER + "/ddw_dictionary_dump/";

    // Names of the metadata objects for which the SPARQL queries retrieve information
    private static final String BUSINESS_TERMS_SHEET_NAME = "BusinessTerms";
    private static final String DATA_SOURCES_SHEET_NAME = "DataSources";
    private static final String TABLES_SHEET_NAME = "Tables";
    private static final String COLUMNS_SHEET_NAME = "Columns";

    // SPARQL query files
    private static final String BUSINESS_TERMS_QUERY_FILE_PATH = "business-term-export.csv.rq";
    private static final String DATA_SOURCES_QUERY_FILE_PATH = "data-source-export.csv.rq";
    private static final String COLUMNS_QUERY_FILE_PATH = "columns-export.csv.rq";
    private static final String TABLES_QUERY_FILE_PATH = "table-export.csv.rq";

    // SPARQL query field names
    private static final String[] BUSINESS_TERM_PROPERTIES = {
        "collections",
        "businesstermiri",
        "business_term",
        "description",
        "summary",
        "data_ownner",
        "data_steward",
        "program_officer",
        "technical_steward",
        "status"
    };
    private static final String[] DATA_SOURCE_PROPERTIES = {
        "collections",
        "databaseiri",
        "databaseName",
        "jdbcURL",
        "databaseServer",
        "databasePort",
        "schemas"
    };
    private static final String[] TABLE_PROPERTIES = {
        "collections",
        "type_prefix",
        "database_name",
        "schema",
        "type",
        "table_name",
        "table_IRI",
        "description",
        "business_summary",
        "restricted_to_public_disclosure_per_federal_or_state_law",
        "sensitive_data",
        "data_sharing_agreement",
        "program_office",
        "data_steward",
        "data_ownner",
        "technical_steward",
        "contact_email",
        "status"
    };
    private static final String[] COLUMN_PROPERTIES = {
            "collections",
            "type_prefix",
            "database_name",
            "table_name",
            "schema",
            "type",
            "column_name",
            "column_IRI",
            "description",
            "business_summary",
            "restricted_to_public_disclosure_per_federal_or_state_law",
            "sensitive_data",
            "data_ownner",
            "data_steward",
            "technical_steward",
            "status"
    };

    public static void main(String[] args) throws IOException {

        LocalDateTime begin = LocalDateTime.now();
        Model model = Util.loadModelFrom(FULL_GRAPH_TTL_FILE_PATH);

        // Data sources
        generateSpreadsheet(
                model,
                DATA_SOURCES_QUERY_FILE_PATH,
                DATA_SOURCES_SHEET_NAME,
                DATA_SOURCE_PROPERTIES,
                1,
                ChronoUnit.SECONDS
        );

        // Tables
        generateSpreadsheet(
                model,
                TABLES_QUERY_FILE_PATH,
                TABLES_SHEET_NAME,
                TABLE_PROPERTIES,
                1000,
                ChronoUnit.SECONDS
        );

        // Columns
        generateSpreadsheet(
                model,
                COLUMNS_QUERY_FILE_PATH,
                COLUMNS_SHEET_NAME,
                COLUMN_PROPERTIES,
                10000,
                ChronoUnit.MINUTES
        );

        // Business glossary terms
        generateSpreadsheet(
                model,
                BUSINESS_TERMS_QUERY_FILE_PATH,
                BUSINESS_TERMS_SHEET_NAME,
                BUSINESS_TERM_PROPERTIES,
                1,
                ChronoUnit.SECONDS
        );

        logger.info("Total processing time: " + begin.until(LocalDateTime.now(), ChronoUnit.MINUTES) + " minutes).");
    }

    private static void generateSpreadsheet(
        Model model,
        String queryFilePath,
        String sheetName,
        String[] propertyNames,
        int rowCountDisplayFrequency,
        ChronoUnit logEntryTimeUnit
    ) throws IOException {
        URL url = Ddw2InfaCustomMetaModelProcessor.class.getClassLoader().getResource(queryFilePath);
        if(null == url) { throw new IllegalArgumentException(queryFilePath + " is not found."); }
        File file = new File(url.getFile());
        String queryString = new String(Files.readAllBytes(file.toPath()));
        int rowCount = 1;
        StringBuilder sb = new StringBuilder();

        // Create CSV spreadsheet header
        sb.append("\"");
        sb.append(String.join("\",\"", propertyNames));
        sb.append("\"");

        Query query = QueryFactory.create(queryString);
        try (QueryExecution queryExecution = QueryExecutionFactory.create(query, model)) {
            ResultSet results = queryExecution.execSelect();
            logger.info("Begin extracting " + sheetName.toLowerCase() + " results ...");
            LocalDateTime localDateTime = LocalDateTime.now();
            while (results.hasNext()) {
                if(rowCount % rowCountDisplayFrequency == 0) {
                    logger.info("Processing " + sheetName.toLowerCase() + " record: " + rowCount + "(" +
                        localDateTime.until(LocalDateTime.now(), logEntryTimeUnit) + " " +
                            logEntryTimeUnit.name().toLowerCase() + ").");
                }
                QuerySolution querySolution = results.nextSolution();
                // Create one row of metadata
                sb.append("\n\"");
                sb.append(Stream.of(propertyNames)
                    .map(propertyName -> Util.stringValueOf(querySolution.get(propertyName)))
                    .map(fieldValue -> { if (fieldValue.isBlank()) fieldValue = ""; return fieldValue; })
                    // Escape double quotes for proper CSV see https://stackoverflow.com/a/17808731/984932,
                    // and note that because data.world backslash-escapes double quotes, the backslashes are
                    // removed as part of the replace operation. Example: \"foo\" gets replaced with ""foo""
                    .map(fieldValue -> fieldValue.replace("\\\"", "\"\""))
                    .collect(Collectors.joining("\",\"")));
                sb.append("\"");
                rowCount++;
            }
            logger.info("Total " + sheetName.toLowerCase() + " records: " + rowCount);
        }
        try (PrintWriter out = new PrintWriter(OUTPUT_DIRECTORY_PATH + sheetName + ".csv")) { out.println(sb); }
    }
}
