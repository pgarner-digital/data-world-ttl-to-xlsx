import org.apache.jena.rdf.model.RDFNode;

public class Util {

    public static String stringValueOf(RDFNode rdfNode) { return null == rdfNode ? "" : rdfNode.toString(); }

}
