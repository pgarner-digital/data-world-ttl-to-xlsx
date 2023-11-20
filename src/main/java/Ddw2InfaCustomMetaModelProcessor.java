import gov.fl.digital.ddw2infa.AgencyAndTtlFileName;
import gov.fl.digital.ddw2infa.DdwMetadata;
import gov.fl.digital.ddw2infa.Util;
import gov.fl.digital.ddw2infa.column.ColumnsDdwMetadata;
import gov.fl.digital.ddw2infa.database.DatabaseDdwMetadata;
import gov.fl.digital.ddw2infa.link.LinksMetadataCache;
import gov.fl.digital.ddw2infa.schema.SchemasMetadataCache;
import gov.fl.digital.ddw2infa.table.TablesDdwMetadata;
import gov.fl.digital.ddw2infa.view.ViewsDdwMetadata;
import gov.fl.digital.ddw2infa.viewcolumn.ViewColumnsDdwMetadata;
import org.apache.jena.query.*;
import org.apache.jena.rdf.model.Model;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

import static gov.fl.digital.ddw2infa.AgencyAndTtlFileName.*;

public class Ddw2InfaCustomMetaModelProcessor {

    private static final Logger logger = LogManager.getLogger(Ddw2InfaCustomMetaModelProcessor.class);

    public static void main(String[] args) throws IOException, SQLException {

        LocalDateTime begin = LocalDateTime.now();

        AgencyAndTtlFileName[] agencyAndTtlFileNames = new AgencyAndTtlFileName[]{
/*                    AHCA,
                APD,
                BOG,
                CHS,
                CITRUS,
                DBPR,
                DBS,
                DCF,
                DEM,
                DEO,
                DEP,
                DFS,
                DHSMV,
                DJJ,
                DLA,
                DMA,
                DMS,
                DOACS,
                DOAH,
                DOE,
                DOEA,
                DOH,
                DOL,*/
                DOR/*,
                DOS,
                DOT,
                DVA,
                EOG,
                FCHR,
                FCOR,
                FDC,
                FDLE,
                FSDB,
                FWC,
                GAL,
                HOUSE,
                JAC,
                NFWMD,
                OEL,
                OLITS,
                PERC,
                PSC,
                SCS,
                SENATE,
                SRWMD,
                VR*/
        };

        try {
            for (AgencyAndTtlFileName agencyAndTtlFileName : agencyAndTtlFileNames) {
                Model model = Util.loadModelFrom(agencyAndTtlFileName.getFileName());
                DatabaseDdwMetadata databaseDdwMetadata = new DatabaseDdwMetadata();
                TablesDdwMetadata tablesDdwMetadata = new TablesDdwMetadata();
                ViewsDdwMetadata viewsDdwMetadata = new ViewsDdwMetadata();
                ColumnsDdwMetadata columnsDdwMetadata = new ColumnsDdwMetadata();
                ViewColumnsDdwMetadata viewColumnsDdwMetadata = new ViewColumnsDdwMetadata();
                SchemasMetadataCache schemasMetadataCache = new SchemasMetadataCache();
                LinksMetadataCache linksMetadataCache = new LinksMetadataCache();
                String orgId = agencyAndTtlFileName.getOrgId();

                // Note: try-with-resources auto closes connection, so no need to explicitly close it.
                // Don't want to keep connection idle too long (max is 4 hours before token expires).
                // Databases, tables, and views all together take < 4 hours so they are grouped
                // under one try-with-resources.
                try (Connection connection = Util.getConnection(args[0], args[1])) {
                    connection.setAutoCommit(false);
                    truncateTables(connection);

                    logger.info("\nExtracting database metadata");
                    loadMetadata(
                        model,
                        databaseDdwMetadata,
                        schemasMetadataCache,
                        linksMetadataCache,
                        1,
                        ChronoUnit.SECONDS,
                        orgId,
                        begin
                    );
                    databaseDdwMetadata.insertRecords(connection, orgId, begin, 1);

                    logger.info("Extracting table metadata");
                    loadMetadata(
                        model,
                        tablesDdwMetadata,
                        schemasMetadataCache,
                        linksMetadataCache,
                        100,
                        ChronoUnit.SECONDS,
                        orgId,
                        begin
                    );
                    tablesDdwMetadata.insertRecords(connection, orgId, begin, 100);

                    logger.info("Extracting view metadata");
                    loadMetadata(
                        model,
                        viewsDdwMetadata,
                        schemasMetadataCache,
                        linksMetadataCache,
                        100,
                        ChronoUnit.SECONDS,
                        orgId,
                        begin
                    );
                    viewsDdwMetadata.insertRecords(connection, orgId, begin, 100);
                }

                logger.info("Extracting column metadata");
                loadMetadata(
                    model,
                    columnsDdwMetadata,
                    schemasMetadataCache,
                    linksMetadataCache,
                    10000,
                    ChronoUnit.MINUTES,
                    orgId,
                    begin
                );

                // Columns take a long time to extract.  Don't want to keep connection
                // idle too long (max is 4 hours before token expires).  So create
                // new connection. Note: try with resources auto closes connection,
                // so no need to explicitly close it.
                try (Connection connection = Util.getConnection(args[0], args[1])) {
                    connection.setAutoCommit(false);
                    columnsDdwMetadata.insertRecords(connection, orgId, begin, 10000);
                }

                logger.info("Extracting view-column metadata");
                loadMetadata(
                    model,
                    viewColumnsDdwMetadata,
                    schemasMetadataCache,
                    linksMetadataCache,
                    10000,
                    ChronoUnit.MINUTES,
                    orgId,
                    begin
                );

                // Columns take a long time to extract.  Don't want to keep connection
                // idle too long (max is 4 hours before token expires).  So create
                // new connection.  Note: try with resources auto closes connection,
                // so no need to explicitly close it.
                try (Connection connection = Util.getConnection(args[0], args[1])) {
                    connection.setAutoCommit(false);
                    viewColumnsDdwMetadata.insertRecords(connection, orgId, begin, 10000);
                }

                logger.info("Extracting schema metadata");
                // Note: try with resources auto closes connection, so no need to explicitly close it.
                try (Connection connection = Util.getConnection(args[0], args[1])) {
                    connection.setAutoCommit(false);
                    schemasMetadataCache.pushToSnowflake(connection, begin, ChronoUnit.SECONDS, orgId);
                }

                logger.info("Extracting links metadata");
                // Note: try with resources auto closes connection, so no need to explicitly close it.
                try (Connection connection = Util.getConnection(args[0], args[1])) {
                    connection.setAutoCommit(false);
                    linksMetadataCache.pushToSnowflake(connection, begin, ChronoUnit.SECONDS, orgId);
                }
            }
        } catch (SQLException e) {
            logger.error("Unable to execute SQL. Total time: " +
                    begin.until(LocalDateTime.now(), ChronoUnit.HOURS) +
                    " " +
                    ChronoUnit.HOURS.name().toLowerCase());
            throw e;
        }
        logger.info("Completed all processing.  Current time: " +
                begin.until(LocalDateTime.now(), ChronoUnit.HOURS) + " hours.");
    }

    private static void loadMetadata(
            Model model,
            DdwMetadata ddwMetadata,
            SchemasMetadataCache schemasMetadataCache,
            LinksMetadataCache linksMetadataCache,
            int rowCountDisplayFrequency,
            ChronoUnit logEntryTimeUnit,
            String orgId,
            LocalDateTime localDateTime
    ) throws IOException, SQLException {
        String queryString = Util.getSparqlQueryForOrg(orgId, ddwMetadata.getQueryFilePath());
        int rowCount = 1;
        Query query = QueryFactory.create(queryString);
        try (QueryExecution queryExecution = QueryExecutionFactory.create(query, model)) {
            ResultSet results = queryExecution.execSelect();
            while (results.hasNext()) {
                if (rowCount % rowCountDisplayFrequency == 0) {
                    logger.info("Obtaining " + ddwMetadata.getLabel() + " record from TTL: " + (rowCount + 1) +
                        "(" + localDateTime.until(LocalDateTime.now(), logEntryTimeUnit) + " " +
                        logEntryTimeUnit.name().toLowerCase() + ").");
                }
                QuerySolution querySolution = results.nextSolution();
                ddwMetadata.obtainAndCacheRecord(querySolution, schemasMetadataCache, linksMetadataCache);
                rowCount++;
            }
        }
    }

    private static void truncateTables(Connection connection) throws SQLException {
        String truncateStatementText = "truncate table %s";
        try (Statement truncateStatement = connection.createStatement()) {
            truncateStatement.execute(String.format(truncateStatementText, DatabaseDdwMetadata.INFA_TABLE_NAME));
            truncateStatement.execute(String.format(truncateStatementText, SchemasMetadataCache.INFA_TABLE_NAME));
            truncateStatement.execute(String.format(truncateStatementText, TablesDdwMetadata.INFA_TABLE_NAME));
            truncateStatement.execute(String.format(truncateStatementText, ColumnsDdwMetadata.INFA_TABLE_NAME));
            truncateStatement.execute(String.format(truncateStatementText, ViewsDdwMetadata.INFA_TABLE_NAME));
            truncateStatement.execute(String.format(truncateStatementText, ViewColumnsDdwMetadata.INFA_TABLE_NAME));
            truncateStatement.execute(String.format(truncateStatementText, LinksMetadataCache.INFA_TABLE_NAME));
        }
    }
}
