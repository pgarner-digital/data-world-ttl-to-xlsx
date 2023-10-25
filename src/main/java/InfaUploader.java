import gov.fl.digital.ddw2infa.AgencyAndTtlFileName;
import gov.fl.digital.ddw2infa.Util;
import org.apache.jena.query.*;
import org.apache.jena.rdf.model.Model;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.*;
import java.net.URL;
import java.nio.file.Files;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Properties;
import java.util.stream.Stream;

public class InfaUploader {

    private static final Logger logger = LogManager.getLogger(InfaUploader.class);
    private static final String QUERY_FILE_PATH = "business-metadata-export.rq";
    private static final String[] FIELD_NAMES = {
        "iri",
        "rdf_type",
        "name_id",
        "description",
        "business_summary",
        "data_owner",
        "data_steward",
        "contact_email",
        "program_office",
        "technical_steward",
        "status",
        "restricted_to_public_disclosure",
        "data_sharing_agreement_required",
        "contains_sensitive_data"
    };

    /**
     *  RDF_TYPES is used to filter unneeded kinds of metadata records
     *  out of the result set.  For example, software agents, metadata
     *  profiles, exceptions, etc. are not needed.  All that's needed
     *  are databases, schemas, tables, views, columns.
     */
    private static final List<String> RDF_TYPES = List.of(
            // Comments, below, allow one to control what types of records should be stored in Snowflake
            //"http://www.w3.org/2000/01/rdf-schema#Class",
            //"http://www.w3.org/2004/02/skos/core#Concept",
            //"http://www.w3.org/2004/02/skos/core#ConceptScheme",
            //"http://www.w3.org/ns/csvw#ForeignKey",
            //"http://www.w3.org/ns/csvw#Schema",
            //"http://www.w3.org/ns/csvw#TableReference",
            //"http://www.w3.org/ns/dcat#CatalogRecord",
            //"http://www.w3.org/ns/prov#Entity",
            //"http://www.w3.org/ns/prov#SoftwareAgent",
            //"https://dwcc.data.world/v0/exceptions/Exception",
            //"https://dwec.data.world/v0/Catalog",
            "https://dwec.data.world/v0/Database",
            "https://dwec.data.world/v0/DatabaseColumn",
            //"https://dwec.data.world/v0/DatabaseConnectionInfo",
            "https://dwec.data.world/v0/DatabaseSchema",
            "https://dwec.data.world/v0/DatabaseTable",
            "https://dwec.data.world/v0/DatabaseView"
            //"https://dwec.data.world/v0/Disposition",
            //"https://dwec.data.world/v0/DwDataset",
            //"https://dwec.data.world/v0/DwProject",
            //"https://dwec.data.world/v0/Facetable",
            //"https://dwec.data.world/v0/Mandatory",
            //"https://dwec.data.world/v0/MetadataPresentation",
            //"https://dwec.data.world/v0/MetadataProfile",
            //"https://dwec.data.world/v0/MetadataSection",
            //"https://dwec.data.world/v0/Multiline",
            //"https://dwec.data.world/v0/Multivalued",
            //"https://fl-deo.linked.data.world/d/ddw-catalogs/ApprovalStatus"
    );
    private final static String INSERT_DATABASE_STATEMENT;
    private final static String INSERT_SCHEMA_STATEMENT;
    private final static String INSERT_TABLE_STATEMENT;
    private final static String INSERT_VIEW_STATEMENT;
    private final static String INSERT_COLUMN_STATEMENT;

    static {
        StringBuilder insertDatabaseQueryBuilder = new StringBuilder("INSERT INTO DATABASE_BUSINESS_METADATA (ORG_ID");
        StringBuilder insertSchemaQueryBuilder = new StringBuilder("INSERT INTO SCHEMA_BUSINESS_METADATA (ORG_ID");
        StringBuilder insertTableQueryBuilder = new StringBuilder("INSERT INTO TABLE_BUSINESS_METADATA (ORG_ID");
        StringBuilder insertViewQueryBuilder = new StringBuilder("INSERT INTO VIEW_BUSINESS_METADATA (ORG_ID");
        StringBuilder insertColumnQueryBuilder = new StringBuilder("INSERT INTO COLUMN_BUSINESS_METADATA (ORG_ID");
        StringBuilder valuesQueryBuilder = new StringBuilder(") values (?");
        for(String propertyName : FIELD_NAMES) {
            insertDatabaseQueryBuilder.append(", ").append(propertyName);
            insertSchemaQueryBuilder.append(", ").append(propertyName);
            insertTableQueryBuilder.append(", ").append(propertyName);
            insertViewQueryBuilder.append(", ").append(propertyName);
            insertColumnQueryBuilder.append(", ").append(propertyName);
            valuesQueryBuilder.append(", ?");
        }
        valuesQueryBuilder.append(")");
        INSERT_DATABASE_STATEMENT = String.format("%s%s",insertDatabaseQueryBuilder, valuesQueryBuilder);
        INSERT_SCHEMA_STATEMENT = String.format("%s%s",insertSchemaQueryBuilder, valuesQueryBuilder);
        INSERT_TABLE_STATEMENT = String.format("%s%s",insertTableQueryBuilder, valuesQueryBuilder);
        INSERT_VIEW_STATEMENT = String.format("%s%s",insertViewQueryBuilder, valuesQueryBuilder);
        INSERT_COLUMN_STATEMENT = String.format("%s%s",insertColumnQueryBuilder, valuesQueryBuilder);
/*
        System.out.println(INSERT_DATABASE_STATEMENT);
        System.out.println(INSERT_SCHEMA_STATEMENT);
        System.out.println(INSERT_TABLE_STATEMENT);
        System.out.println(INSERT_VIEW_STATEMENT);
        System.out.println(INSERT_COLUMN_STATEMENT);
*/
    }

    public static void main(String[] args) throws SQLException, IOException {
        if (args.length < 2 || Stream.of(args).anyMatch(s -> s == null || s.isEmpty())) {
            System.out.println("Run Usage: java -jar InfaUploader.jar <Snowflake User> <Snowflake Password>");
            System.exit(1);
        }
        processTTL(Util.getConnection(args[0], args[1]));
    }

    private static void processTTL(Connection connection) throws IOException, SQLException {

        for(AgencyAndTtlFileName agencyAndTtlFileName : AgencyAndTtlFileName.values()) {

            Model model = Util.loadModelFrom(agencyAndTtlFileName.getFileName());

            PreparedStatement psDatabase = connection.prepareStatement(INSERT_DATABASE_STATEMENT);
            PreparedStatement psSchema = connection.prepareStatement(INSERT_SCHEMA_STATEMENT);
            PreparedStatement psTable = connection.prepareStatement(INSERT_TABLE_STATEMENT);
            PreparedStatement psView = connection.prepareStatement(INSERT_VIEW_STATEMENT);
            PreparedStatement psColumn = connection.prepareStatement(INSERT_COLUMN_STATEMENT);
            Query query = QueryFactory.create(
                Util.getSparqlQueryForOrg(agencyAndTtlFileName.getOrgId(), QUERY_FILE_PATH)
            );

            // Align query prefixes with TTL prefixes

            try (QueryExecution queryExecution = QueryExecutionFactory.create(query, model)) {
                ResultSet results = queryExecution.execSelect();
                logger.info("Begin extracting results ...");
                LocalDateTime localDateTime = LocalDateTime.now();
                int rowCount = 1, colCount;
                PreparedStatement tempPreparedStatement;
                while (results.hasNext()) {
                    QuerySolution querySolution = results.nextSolution();
                    colCount = 1; // Column #1, ORG_ID, is not in the result set.  It's set manually.
                    String rdfType = Util.stringValueOf(querySolution.get("rdf_type"));
                    if (RDF_TYPES.contains(rdfType)) {
                        // All the records whose RDF types are not database, schema, table, column have been removed.
                        switch (rdfType) {
                            case "https://dwec.data.world/v0/Database"          -> tempPreparedStatement = psDatabase;
                            case "https://dwec.data.world/v0/DatabaseSchema"    -> tempPreparedStatement = psSchema;
                            case "https://dwec.data.world/v0/DatabaseTable"     -> tempPreparedStatement = psTable;
                            case "https://dwec.data.world/v0/DatabaseView"      -> tempPreparedStatement = psView;
                            case "https://dwec.data.world/v0/DatabaseColumn"    -> tempPreparedStatement = psColumn;
                            default -> throw new RuntimeException("Unknown RDF Type: " + rdfType);
                        }
                        tempPreparedStatement.setString(colCount++, agencyAndTtlFileName.getOrgId());
                        for(String propertyName : FIELD_NAMES) {
                            String propertyValue = Util.stringValueOf(querySolution.get(propertyName));
                            tempPreparedStatement.setString(colCount++, propertyValue);
                        }
                        switch (rdfType) {
                            case "https://dwec.data.world/v0/Database"          -> psDatabase.addBatch();
                            case "https://dwec.data.world/v0/DatabaseSchema"    -> psSchema.addBatch();
                            case "https://dwec.data.world/v0/DatabaseTable"     -> psTable.addBatch();
                            case "https://dwec.data.world/v0/DatabaseView"      -> psView.addBatch();
                            case "https://dwec.data.world/v0/DatabaseColumn"    -> psColumn.addBatch();
                            default -> throw new RuntimeException("Unknown RDF Type: " + rdfType);
                        }
                        logRecordIsProcessed(rowCount++, localDateTime);
                    }
                }
                psDatabase.executeBatch();
                psSchema.executeBatch();
                psTable.executeBatch();
                psView.executeBatch();
                psColumn.executeBatch();
                System.out.println("Committing changes to snowflake.\n");
                connection.commit();
            }
            catch (SQLException e) {
                System.err.println("Unable to execute SQL. Rolling back snowflake import.");
                connection.rollback();
                throw e;
            }
        }
    }

    private static void logRecordIsProcessed(int rowCount, LocalDateTime localDateTime) {
        logger.info("Processing record: " + rowCount + "(" +
                localDateTime.until(LocalDateTime.now(), ChronoUnit.SECONDS) + " " +
                ChronoUnit.SECONDS.name().toLowerCase() + ").");
    }

}
