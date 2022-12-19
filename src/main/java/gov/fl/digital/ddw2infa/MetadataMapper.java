package gov.fl.digital.ddw2infa;

import org.apache.jena.query.QuerySolution;

public interface MetadataMapper<X> { // TODO: remove unused type parameter


    /**
     * INFA provides the following "core" mappings, which are available to every class
     *
     *      JSON key                INFA properties screen
     *  core.externalId             Reference ID - the ID created in the client is concatenated to other strings by INFA to comprise Reference ID
     *  core.name                   Name
     *  core.description            Description
     *  core.businessDescription    ???
     *  core.businessName
     *  core.reference
     *  custom.data.world.owner
     */







    String getPropertyValueFrom(QuerySolution querySolution);
}
