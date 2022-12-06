package gov.fl.digital.ddw2infa;

import org.apache.jena.rdf.model.Model;
import org.apache.jena.rdf.model.ModelFactory;
import org.apache.jena.rdf.model.RDFNode;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

public class Util {

    private static final Logger logger = LogManager.getLogger(Util.class);

    public static String stringValueOf(RDFNode rdfNode) { return null == rdfNode ? "" : rdfNode.toString().trim(); }

    public static void checkNullOrEmpty(String name, String id) {
        if(id == null || id.trim().isBlank()) throw new IllegalArgumentException(name + " is blank.");
    }

    public static Model loadModelFrom(String ttlFilePath) {
        LocalDateTime begin = LocalDateTime.now();
        Model model = ModelFactory.createDefaultModel();
        logger.info("Begin loading " + ttlFilePath + " into model...");
        model.read(ttlFilePath);
        logger.info("Model loaded (" + begin.until(LocalDateTime.now(), ChronoUnit.SECONDS) + " seconds).");
        return model;
    }
}
