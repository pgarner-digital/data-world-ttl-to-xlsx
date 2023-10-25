package gov.fl.digital.ddw2infa;

import org.apache.jena.query.QuerySolution;

public interface MetadataMapper {
    String getPropertyValueFrom(QuerySolution querySolution);

    String getInfaColumnName();

    String getDdwColumnName();

    default boolean hasDdwColumnName() { return null != getDdwColumnName() && !getDdwColumnName().isEmpty(); }
}
