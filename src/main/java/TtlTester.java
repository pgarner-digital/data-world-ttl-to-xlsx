import gov.fl.digital.ddw2infa.Util;
import org.apache.jena.query.*;
import org.apache.jena.rdf.model.Model;
import org.apache.jena.rdf.model.ModelFactory;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.nio.file.Files;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDateTime;

public class TtlTester {
    private static final Logger logger = LogManager.getLogger(TtlTester.class);

    private static String queryString = """
            PREFIX walls: <http://wallscope.co.uk/ontology/olympics/>
            PREFIX rdfs:  <http://www.w3.org/2000/01/rdf-schema#>
            SELECT DISTINCT ?name
            WHERE {
             ?instance walls:athlete ?athlete ;
             walls:medal <http://wallscope.co.uk/resource/olympics/medal/Gold> .
             ?athlete rdfs:label ?name .
            }""";


    public static void main (String[] args) {
        Query query = QueryFactory.create(queryString);
        Model model = ModelFactory.createDefaultModel();
        model.read("./src/main/resources/olympics.ttl");
        try (QueryExecution queryExecution = QueryExecutionFactory.create(query, model)) {
            ResultSet results = queryExecution.execSelect();
            logger.info("Begin extracting results ...");
            LocalDateTime localDateTime = LocalDateTime.now();
            int rowCount = 1, colCount;
            PreparedStatement tempPreparedStatement;
            while (results.hasNext()) {
                QuerySolution querySolution = results.nextSolution();
                String entityValue = Util.stringValueOf(querySolution.get("entity"));
                String nameValue = Util.stringValueOf(querySolution.get("name"));
                System.out.printf("Entity: %s, Name: %s%n", entityValue, nameValue);
            }
        }
    }
}
