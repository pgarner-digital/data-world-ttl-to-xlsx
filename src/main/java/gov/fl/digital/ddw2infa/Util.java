package gov.fl.digital.ddw2infa;

import gov.fl.digital.ddw2infa.schema.SchemasMetadataCache;
import org.apache.jena.rdf.model.Model;
import org.apache.jena.rdf.model.ModelFactory;
import org.apache.jena.rdf.model.RDFNode;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.nio.file.Files;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.Properties;

public class Util {

    private static final Logger logger = LogManager.getLogger(Util.class);

    //private static final String firstPrefix = "PREFIX : <https://fl-%s.linked.data.world/d/ddw-catalog-build/>\n";
    private static final String firstPrefix = "PREFIX : <https://fl-%s.linked.data.world/d/ddw-catalogs/>\n";
    private static final String secondPrefix = "PREFIX orgprofile: <https://fl-%s.linked.data.world/d/ddw-catalogs/>\n";

    public static String stringValueOf(RDFNode rdfNode) { return null == rdfNode ? "" : rdfNode.toString().trim(); }

    public static String encapsulateDoubleQuotes(String value) { return null == value ? "" : "\"" + value + "\""; }

    public static String removeSpecialCharacters(String value) {
        return null == value ? "" : value.replaceAll("[,|\"|\r|\n|\\\\]", "");
    }
    public static void checkNullOrEmpty(String name, String id) {
        if(id == null || id.trim().isBlank()) throw new IllegalArgumentException(name + " is blank.");
    }

    public static Model loadModelFrom(String ttlFilePath) {
        LocalDateTime begin = LocalDateTime.now();
        Model model = ModelFactory.createDefaultModel();
        logger.info("Begin loading " + ttlFilePath + " into model ...");
        model.read("./src/main/resources/" + ttlFilePath);
        logger.info("\nModel loaded (" + begin.until(LocalDateTime.now(), ChronoUnit.SECONDS) + " seconds).");
        return model;
    }

    public static Connection getConnection(String username, String password) throws SQLException {
        Properties props = new Properties();
        props.put("warehouse", "COMPUTE_WH");
        props.put("db", "INFA_METRICS");
        props.put("schema", "PUBLIC");
        props.put("role", "INFORMATICA_METRICS_ANALYST");
        props.put("user", username);
        props.put("password", password);
        return DriverManager.getConnection(
                "jdbc:snowflake://cw33570.us-east-1-gov.aws.snowflakecomputing.com:443/",
                props
        );
    }

    public static String getSparqlQueryForOrg(String orgId, String queryFilePath) throws IOException {
        String _orgId = orgId.toLowerCase();
        URL _queryFilePath = Util.class.getClassLoader().getResource(queryFilePath);
        if(null == _queryFilePath) { throw new IllegalArgumentException(queryFilePath + " is not found."); }
        File queryFile = new File(_queryFilePath.getFile());
        String oldContent = new String(Files.readAllBytes(queryFile.toPath()));
        String _firstPrefix = String.format(firstPrefix, _orgId);
        String _secondPrefix = String.format(secondPrefix, _orgId);
        return _firstPrefix + _secondPrefix + oldContent;
    }

    public static String getSchemaNameHack(String schemaName) {
        return (null == schemaName || schemaName.isEmpty())
                ? SchemasMetadataCache.PEOPLE_FIRST_SCHEMA_NAME
                : schemaName.trim();
    }
}
