import gov.fl.digital.ddw2infa.AgencyAndTtlFileName;
import gov.fl.digital.ddw2infa.DdwMetadata;
import gov.fl.digital.ddw2infa.MetadataMapper;
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

        // Note: try with resources auto closes connection, so no need to explicitly close it.
        try (Connection connection = Util.getConnection(args[0], args[1])) {

            //truncateTables(connection);

            AgencyAndTtlFileName[] agencyAndTtlFileNames = new AgencyAndTtlFileName[] {
/*
                    DJJ,
                    DLA,
                    DMA,
                    DMS,
                    DOACS,
                    DOAH,
                    DOE,
                    DOEA,
*/
                    DOH/*,
                    DOL,
                    DOR,
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

            for (AgencyAndTtlFileName agencyAndTtlFileName : agencyAndTtlFileNames) {
//            for (AgencyAndTtlFileName agencyAndTtlFileName : AgencyAndTtlFileName.values()) {
                Model model = Util.loadModelFrom(agencyAndTtlFileName.getFileName());
                SchemasMetadataCache schemasMetadataCache = new SchemasMetadataCache();
                LinksMetadataCache linksMetadataCache = new LinksMetadataCache();
                String orgId = agencyAndTtlFileName.getOrgId();
                try {

                    logger.info("\nExtracting database metadata");
                    pushToSnowflake(
                        model,
                        new DatabaseDdwMetadata(),
                        schemasMetadataCache,
                        linksMetadataCache,
                        1,
                        ChronoUnit.SECONDS,
                        connection,
                        orgId,
                        begin
                    );

                    logger.info("Extracting table metadata");
                    pushToSnowflake(
                        model,
                        new TablesDdwMetadata(),
                        schemasMetadataCache,
                        linksMetadataCache,
                        100,
                        ChronoUnit.SECONDS,
                        connection,
                        orgId,
                        begin
                    );

                    logger.info("Extracting view metadata");
                    pushToSnowflake(
                        model,
                        new ViewsDdwMetadata(),
                        schemasMetadataCache,
                        linksMetadataCache,
                        100,
                        ChronoUnit.SECONDS,
                        connection,
                        orgId,
                        begin
                    );

                    logger.info("Extracting column metadata");
                    pushToSnowflake(
                        model,
                        new ColumnsDdwMetadata(),
                        schemasMetadataCache,
                        linksMetadataCache,
                        10000,
                        ChronoUnit.MINUTES,
                        connection,
                        orgId,
                        begin
                    );

                    logger.info("Extracting view-column metadata");
                    pushToSnowflake(
                        model,
                        new ViewColumnsDdwMetadata(),
                        schemasMetadataCache,
                        linksMetadataCache,
                        10000,
                        ChronoUnit.MINUTES,
                        connection,
                        orgId,
                        begin
                    );

                    logger.info("Extracting schema metadata");
                    schemasMetadataCache.pushToSnowflake(connection, begin, ChronoUnit.SECONDS, orgId);

                    logger.info("Extracting links metadata");
                    linksMetadataCache.pushToSnowflake(connection, begin, ChronoUnit.SECONDS, orgId);

                } catch (SQLException e) {
                    System.err.println("Unable to execute SQL. Rolling back snowflake import.");
                    connection.rollback();
                    throw e;
                }
                logger.info("Total processing time: " + begin.until(LocalDateTime.now(), ChronoUnit.MINUTES) + " minutes.");
            }

            //updatePrimaryKeyColumn(connection);
        }
    }

    private static <X extends MetadataMapper> void pushToSnowflake(
        Model model,
        DdwMetadata<X> ddwMetadata,
        SchemasMetadataCache schemasMetadataCache,
        LinksMetadataCache linksMetadataCache,
        int rowCountDisplayFrequency,
        ChronoUnit logEntryTimeUnit,
        Connection connection,
        String orgId,
        LocalDateTime localDateTime
    ) throws IOException, SQLException {
        String queryString = Util.getSparqlQueryForOrg(orgId, ddwMetadata.getQueryFilePath());
        int rowCount = 1;
        Query query = QueryFactory.create(queryString);
        try (QueryExecution queryExecution = QueryExecutionFactory.create(query, model)) {
            ResultSet results = queryExecution.execSelect() ;
            while (results.hasNext()) {
                if(rowCount % rowCountDisplayFrequency == 0) {
                    logger.info("Obtaining " + ddwMetadata.getLabel() + " record from TTL: " + (rowCount + 1) +
                            "(" + localDateTime.until(LocalDateTime.now(), logEntryTimeUnit) + " " +
                            logEntryTimeUnit.name().toLowerCase() + ").");
                }
                QuerySolution querySolution = results.nextSolution();
                ddwMetadata.obtainAndCacheRecord(querySolution, schemasMetadataCache, linksMetadataCache);
                rowCount++;
            }
        }
        ddwMetadata.insertRecords(connection, orgId, localDateTime, rowCountDisplayFrequency);
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

    private static void updatePrimaryKeyColumn(Connection connection) throws SQLException {
        String setPkYesStatementText = "update %s set \"com.infa.odin.models.relational.PrimaryKeyColumn\" = 'Yes' " +
                "where \"com.infa.odin.models.relational.PrimaryKeyColumn\" = \"core.name\"";
        String setPkNonYesToNullStatementText = "update %s set \"com.infa.odin.models.relational.PrimaryKeyColumn\" = " +
                "null where \"com.infa.odin.models.relational.PrimaryKeyColumn\" <> 'Yes'";
        try (Statement truncateStatement = connection.createStatement()) {
            truncateStatement.execute(String.format(setPkYesStatementText, ColumnsDdwMetadata.INFA_TABLE_NAME));
            truncateStatement.execute(String.format(setPkNonYesToNullStatementText, ColumnsDdwMetadata.INFA_TABLE_NAME));
        }
    }
}
