import org.apache.jena.query.*;
import org.apache.jena.rdf.model.Model;
import org.apache.jena.rdf.model.ModelFactory;
import org.apache.jena.rdf.model.RDFNode;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.streaming.SXSSFCell;
import org.apache.poi.xssf.streaming.SXSSFRow;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;

import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

public class DataDotWorldModelProcessor {

    /************************************************  INPUTS  ********************************************************/
    private static final String OWNER = "FL-DMS";
    //private static final String OWNER = "FL-DCF";

    private static final String FULL_GRAPH_TTL_FILE_PATH = "fl-dms-full-graph.ttl";
    //private static final String FULL_GRAPH_TTL_FILE_PATH = "fl-dcf-full-graph.ttl";

    /******************************************************************************************************************/

    private static final Logger logger = LogManager.getLogger(DataDotWorldModelProcessor.class);
    private static final int MAX_ROW_SIZE = 500000;
    private static final String SHEET_MAX_ROWS_EXCEEDED_MSG;

    static {
        SHEET_MAX_ROWS_EXCEEDED_MSG = " spreadsheet reached maximum row size: " + MAX_ROW_SIZE + ".  Aborting...";
    }

    private static final String BUSINESS_TERMS_SHEET_NAME = "Business Terms";
    private static final String DATA_SOURCES_SHEET_NAME = "Data Sources";
    private static final String TABLES_SHEET_NAME = "Tables";
    private static final String COLUMNS_SHEET_NAME = "Columns";
    private static final String BUSINESS_TERMS_QUERY_FILE_PATH = "business-term-export.csv.rq";
    private static final String DATA_SOURCES_QUERY_FILE_PATH = "data-source-export.csv.rq";
    private static final String COLUMNS_QUERY_FILE_PATH = "columns-export.csv.rq";
    private static final String TABLES_QUERY_FILE_PATH = "table-export.csv.rq";
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

    // These two fields supports singleton design pattern for reusability.
    private static CellStyle bodyCellStyle;
    private static CellStyle headerCellStyle;

    public static void main(String[] args) throws IOException {

        LocalDateTime begin = LocalDateTime.now();
        SXSSFWorkbook workbook = new SXSSFWorkbook();
        Model model = loadModel(FULL_GRAPH_TTL_FILE_PATH);

        // Columns
        processSheet(
            workbook,
            model,
            COLUMNS_QUERY_FILE_PATH,
            COLUMNS_SHEET_NAME,
            COLUMN_PROPERTIES,
            10000,
            ChronoUnit.MINUTES
        );

        // Tables
        processSheet(
            workbook,
            model,
            TABLES_QUERY_FILE_PATH,
            TABLES_SHEET_NAME,
            TABLE_PROPERTIES,
            1000,
            ChronoUnit.SECONDS
        );

        // Data sources
        processSheet(
            workbook,
            model,
            DATA_SOURCES_QUERY_FILE_PATH,
            DATA_SOURCES_SHEET_NAME,
            DATA_SOURCE_PROPERTIES,
            1,
            ChronoUnit.SECONDS
        );

        // Business glossary terms
        processSheet(
            workbook,
            model,
            BUSINESS_TERMS_QUERY_FILE_PATH,
            BUSINESS_TERMS_SHEET_NAME,
            BUSINESS_TERM_PROPERTIES,
            1,
            ChronoUnit.SECONDS
        );

        writeWorkbookToFileSystem(workbook);

        logger.info("Total processing time: " + begin.until(LocalDateTime.now(), ChronoUnit.MINUTES) +
                " minutes).");
    }

    private static Model loadModel(String filePath) {
        LocalDateTime begin = LocalDateTime.now();
        Model model = ModelFactory.createDefaultModel();
        logger.info("Begin loading " + filePath + " into model...");
        model.read(filePath);
        logger.info("Model loaded (" + begin.until(LocalDateTime.now(), ChronoUnit.SECONDS) + " seconds).");
        return model;
    }

    private static void processSheet(
        SXSSFWorkbook workbook,
        Model model,
        String queryFilePath,
        String sheetName,
        String[] propertyNames,
        int rowCountDisplayFrequency,
        ChronoUnit logEntryTimeUnit
    ) throws IOException {
        String queryString;
        queryString = Files.readString(Paths.get(queryFilePath));
        int rowCount = 1;
        SXSSFSheet sheet = workbook.createSheet(sheetName);
        configureSheet(sheet, propertyNames);
        Query query = QueryFactory.create(queryString);
        try (QueryExecution queryExecution = QueryExecutionFactory.create(query, model)) {
            ResultSet results = queryExecution.execSelect() ;
            logger.info("Begin extracting " + sheetName.toLowerCase() + " results ...");
            LocalDateTime localDateTime = LocalDateTime.now();
            while (results.hasNext()) {
                if(rowCount % rowCountDisplayFrequency == 0) {
                    logger.info("Processing " + sheetName.toLowerCase() + " record: " + (rowCount + 1) + "(" +
                            localDateTime.until(LocalDateTime.now(), logEntryTimeUnit) + " " +
                                logEntryTimeUnit.name().toLowerCase() + ").");
                }
                QuerySolution querySolution = results.nextSolution();
                if(sheetCleanedDueToExceedingMaxRowSize(rowCount, sheet)) {
                    logger.error(sheetExceededMaxSizeMsg(sheetName));
                    break;
                }
                else {
                    installBodyRow(querySolution, sheet.createRow(rowCount++), propertyNames);
                    if(rowCount % 100 == 0) {
                        sheet.flushRows(100);
                    }
                }
            }
        }
    }

    private static void configureSheet(SXSSFSheet sheet, String[] propertyNames) {
        sheet.setDisplayGridlines(false);
        sheet.setPrintGridlines(false);
        sheet.setFitToPage(true);
        sheet.setHorizontallyCenter(true);
        PrintSetup printSetup = sheet.getPrintSetup();
        printSetup.setLandscape(true);
        for(int i=0; i < propertyNames.length; i++) {
            sheet.setColumnWidth(i, 20*256);
        }
        installHeaderRow(sheet, propertyNames);
    }

    private static void installHeaderRow(SXSSFSheet sheet, String[] propertyNames) {
        sheet.createFreezePane(0, 1);
        SXSSFWorkbook workbook = sheet.getWorkbook();
        CellStyle cellStyle = getHeaderCellStyle(workbook);
        int columnCount = 0;
        SXSSFRow row = sheet.createRow(0);
        for(String cellProperty: propertyNames) {
            SXSSFCell cell = row.createCell(columnCount++, CellType.STRING);
            cell.setCellValue(cellProperty);
            cell.setCellStyle(cellStyle);
        }
    }

    private static void installBodyRow(
        QuerySolution querySolution,
        SXSSFRow row,
        String[] propertyNames
    ) {
        CellStyle cellStyle = getStandardCellStyle(row.getSheet().getWorkbook());
        cellStyle.setAlignment(HorizontalAlignment.LEFT);
        cellStyle.setWrapText(true);

        int count = 0;
        for(String cellProperty: propertyNames) {
            setCellValue(cellProperty, count++, querySolution, row, cellStyle);
        }
    }

    private static void writeWorkbookToFileSystem(SXSSFWorkbook workbook) throws IOException {
        FileOutputStream out = new FileOutputStream("Catalog_Metadata_" + OWNER + ".xlsx");
        workbook.write(out);
        out.close();
        workbook.dispose();
    }

    private static void setCellValue(
        String columnName,
        int columnCount,
        QuerySolution querySolution,
        SXSSFRow row,
        CellStyle cellStyle
    ) {
        RDFNode cellValue = querySolution.get(columnName) ;
        SXSSFCell cell = row.createCell(columnCount, CellType.STRING);
        cell.setCellValue(stringValueOf(cellValue));
        cell.setCellStyle(cellStyle);
    }

    public static void cleanSheet(SXSSFSheet sheet) {
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

    private static boolean sheetCleanedDueToExceedingMaxRowSize(int rowCount, SXSSFSheet sheet) {
        boolean conditionMetOrNot = rowCount >= MAX_ROW_SIZE;
        if(conditionMetOrNot) {
            String errMsg = sheetExceededMaxSizeMsg(sheet.getSheetName());
            logger.error(errMsg);
            cleanSheet(sheet);
            SXSSFRow row = sheet.createRow(0);
            row.createCell(0, CellType.STRING).setCellValue(errMsg);
        }
        return conditionMetOrNot;
    }

    private static String sheetExceededMaxSizeMsg(String sheetName) { return sheetName + SHEET_MAX_ROWS_EXCEEDED_MSG; }

    private static String stringValueOf(RDFNode rdfNode) { return null == rdfNode ? "" : rdfNode.toString(); }

    private static CellStyle getStandardCellStyle(SXSSFWorkbook workbook) {
        if(null == bodyCellStyle) {
            BorderStyle thin = BorderStyle.THIN;
            short black = IndexedColors.BLACK.getIndex();
            bodyCellStyle = workbook.createCellStyle();
            bodyCellStyle.setBorderRight(thin);
            bodyCellStyle.setRightBorderColor(black);
            bodyCellStyle.setBorderBottom(thin);
            bodyCellStyle.setBottomBorderColor(black);
            bodyCellStyle.setBorderLeft(thin);
            bodyCellStyle.setLeftBorderColor(black);
            bodyCellStyle.setBorderTop(thin);
            bodyCellStyle.setTopBorderColor(black);
        }
        return bodyCellStyle;
    }

    private static CellStyle getHeaderCellStyle(SXSSFWorkbook workbook) {
        if(null == headerCellStyle) {
            headerCellStyle = workbook.createCellStyle();
            headerCellStyle.cloneStyleFrom(getStandardCellStyle(workbook));
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerCellStyle.setAlignment(HorizontalAlignment.CENTER);
            headerCellStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            headerCellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            headerCellStyle.setFont(headerFont);
        }
        return headerCellStyle;
    }
}
