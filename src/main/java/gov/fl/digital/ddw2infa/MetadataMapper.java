package gov.fl.digital.ddw2infa;

import org.apache.jena.query.QuerySolution;

public interface MetadataMapper<X> { // TODO: remove unused type parameter
    String getPropertyValueFrom(QuerySolution querySolution);
}
