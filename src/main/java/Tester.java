import gov.fl.digital.ddw2infa.Util;
import org.apache.jena.query.*;
import org.apache.jena.rdf.model.Model;
import org.apache.jena.rdf.model.ModelFactory;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.sql.PreparedStatement;
import java.time.LocalDateTime;

public class Tester {
    private static final Logger logger = LogManager.getLogger(Tester.class);

    private static String queryString = """
            PREFIX walls: <http://wallscope.co.uk/ontology/olympics/>
            PREFIX rdfs:  <http://www.w3.org/2000/01/rdf-schema#>
            SELECT DISTINCT ?name
            WHERE {
             ?instance walls:athlete ?athlete ;
             walls:medal <http://wallscope.co.uk/resource/olympics/medal/Gold> .
             ?athlete rdfs:label ?name .
            }""";

    public static void main(String[] args) {
        String[] test1 = "1,2".split(",");
        logger.info(test1.length);
        String[] test2 = "1".split(",");
        logger.info(test2.length);
    }

    public static void main2(String[] args) {
        String test = "\"this,\r\n that, the\n other \\ thing\"";
        logger.info(test);
        logger.info(Util.removeSpecialCharacters(test));
    }

    public static void main1(String[] args) {
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
