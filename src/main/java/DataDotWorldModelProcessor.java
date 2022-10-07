import org.apache.jena.query.*;
import org.apache.jena.rdf.model.*;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

public class DataDotWorldModelProcessor {

    private static final Logger logger = LogManager.getLogger(DataDotWorldModelProcessor.class);
    private static final String SHEET_MAX_ROWS_EXCEEDED = "spreadsheet reached maximum row size: 500,000.  Aborting...";
    private static final int MAX_ROW_SIZE = 500000;
    private static final String[] COLUMN_PROPERTIES = {
        "collections",
        "columnTypeName",
        "type_prefix",
        "type",
        "database_name",
        "table_name",
        "schema",
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

    private static final String COLUMNS_QUERY_FILE_PATH = "columns-export.pgg.csv.rq";

    private static final String TABLES_QUERY_FILE_PATH = "table-export.pgg.csv.rq";

    private static final String DATASET_TTL_FILE_PATH = "fl-dms-full-graph.ttl";
    //private static final String DATASET_TTL_FILE_PATH = "fl-dms-full-graph.abbrev.ttl";

    private static final String OWNER = "FL-DMS";

    public static void main(String[] args) {

        String queryString;
        try {
            queryString = Files.readString(Paths.get(COLUMNS_QUERY_FILE_PATH));
        } catch (IOException e) {
            //TODO: No-exception logic for handling an incorrect columns query file path
            throw new RuntimeException(e);
        }

        XSSFWorkbook workbook = new XSSFWorkbook();
        XSSFSheet sheet = workbook.createSheet("Columns");
        installColumnHeader(sheet);
        int rowCount = 1;
        Model model = loadModel();
        Query query = QueryFactory.create(queryString);

        // Columns
        try (QueryExecution queryExecution = QueryExecutionFactory.create(query, model)) {
            ResultSet results = queryExecution.execSelect() ;
            logger.info("Begin extracting column results ...");
            LocalDateTime begin = LocalDateTime.now();
            while (results.hasNext()) {
                logger.info("Processing column record: " + (rowCount + 1) + "(" +
                        begin.until(LocalDateTime.now(), ChronoUnit.MINUTES) + " minutes).");
                QuerySolution querySolution = results.nextSolution();
                if(sheetCleanedDueToExceedingMaxRowSize(rowCount, sheet)) {
                    logger.error(columnsSheetExceededMaxSizeMsg());
                    break;
                }
                else {
                    processColumnCellValues(querySolution, sheet.createRow(rowCount++));
                }
            }
        }

        // Tables
        try {
            queryString = Files.readString(Paths.get(TABLES_QUERY_FILE_PATH));
        } catch (IOException e) {
            //TODO: No-exception logic for handling an incorrect tables query file path
            throw new RuntimeException(e);
        }
        sheet = workbook.createSheet("Tables");
        installColumnHeader(sheet);
        query = QueryFactory.create(queryString);
        try (QueryExecution queryExecution = QueryExecutionFactory.create(query, model)) {
            ResultSet results = queryExecution.execSelect() ;
            logger.info("Begin extracting table results ...");
            LocalDateTime begin = LocalDateTime.now();
            while (results.hasNext()) {
                logger.info("Processing table record: " + (rowCount + 1) + "(" +
                        begin.until(LocalDateTime.now(), ChronoUnit.MINUTES) + " minutes).");
                QuerySolution querySolution = results.nextSolution();
                if(sheetCleanedDueToExceedingMaxRowSize(rowCount, sheet)) {
                    logger.error(tablesSheetExceededMaxSizeMsg());
                    break;
                }
                else {
                    processTableCellValues(querySolution, sheet.createRow(rowCount++));
                }
            }
        }




        writeWorkbookToFileSystem(workbook);
    }

    private static void writeWorkbookToFileSystem(XSSFWorkbook workbook) {
        try {
            FileOutputStream out = new FileOutputStream("Data_Dictionary_" + OWNER + ".xlsx");
            workbook.write(out);
            out.close();
        } catch (IOException e) {
            throw new RuntimeException("Error writing spreadsheet workbook to file system.", e);
        }
    }

    private static String columnsSheetExceededMaxSizeMsg() {
        return "Columns " + SHEET_MAX_ROWS_EXCEEDED;
    }

    private static String tablesSheetExceededMaxSizeMsg() {
        return "Tables " + SHEET_MAX_ROWS_EXCEEDED;
    }

    private static String dataSourcesSheetExceededMaxSizeMsg() {
        return "Data sources " + SHEET_MAX_ROWS_EXCEEDED;
    }

    private static String stringValueOf(RDFNode rdfNode) {
        return null == rdfNode ? "" : rdfNode.toString();
    }

    private static void setCellValue(
        String columnName,
        int columnCount,
        QuerySolution querySolution,
        XSSFRow row
    ) {
        RDFNode cellValue = querySolution.get(columnName) ;
        XSSFCell cell = row.createCell(columnCount, CellType.STRING);
        cell.setCellValue(stringValueOf(cellValue));
    }

    private static void processColumnCellValues(QuerySolution querySolution, XSSFRow row) {
        int count = 0;
        for(String cellProperty: COLUMN_PROPERTIES) {
            setCellValue(cellProperty, count++, querySolution, row);
        }
    }

    private static void processTableCellValues(QuerySolution querySolution, XSSFRow row) {
        int count = 0;
        for(String cellProperty: TABLE_PROPERTIES) {
            setCellValue(cellProperty, count++, querySolution, row);
        }
    }

    private static void installColumnHeader(XSSFSheet sheet) {
        int columnCount = 0;
        XSSFRow row = sheet.createRow(0);
        for(String cellProperty: COLUMN_PROPERTIES) {
            XSSFCell cell = row.createCell(columnCount, CellType.STRING);
            cell.setCellValue(cellProperty);
        }
    }

    public static void cleanSheet(XSSFSheet sheet) {
        int numberOfRows = sheet.getPhysicalNumberOfRows();
        if(numberOfRows > 0) {
            for (int i = sheet.getFirstRowNum(); i <= sheet.getLastRowNum(); i++) {
                if(sheet.getRow(i) != null) {
                    sheet.removeRow( sheet.getRow(i));
                } else {
                    logger.info("Info: clean sheet='" + sheet.getSheetName() + "' ... skip line: " + i);
                }
            }
        } else {
            logger.info("Info: clean sheet='" + sheet.getSheetName() + "' ... is empty");
        }
    }

    private static boolean sheetCleanedDueToExceedingMaxRowSize(int rowCount, XSSFSheet sheet) {
        boolean conditionMetOrNot = rowCount >= MAX_ROW_SIZE;
        if(conditionMetOrNot) {
            String errMsg = columnsSheetExceededMaxSizeMsg();
            logger.error(errMsg);
            cleanSheet(sheet);
            XSSFRow row = sheet.createRow(0);
            row.createCell(0, CellType.STRING).setCellValue(errMsg);
        }
        return conditionMetOrNot;
    }

    private static Model loadModel() {
        Model model = ModelFactory.createDefaultModel();
        logger.info("Begin loading " + DATASET_TTL_FILE_PATH + " into model...");
        LocalDateTime begin = LocalDateTime.now();
        model.read(DATASET_TTL_FILE_PATH);
        logger.info("Model loaded (" + begin.until(LocalDateTime.now(), ChronoUnit.SECONDS) + " seconds).");
        return model;
    }
}
