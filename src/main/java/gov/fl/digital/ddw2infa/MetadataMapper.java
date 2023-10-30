package gov.fl.digital.ddw2infa;

import org.apache.jena.query.QuerySolution;

public interface MetadataMapper {
    String getInfaColumnName();

    String getDdwColumnName();

    String getPropertyValueFrom(QuerySolution querySolution);

    default String getDoubleQuoteEncapsulatedPropertyValueFrom(QuerySolution querySolution) {
        return Util.encapsulateDoubleQuotes(getPropertyValueFrom(querySolution));
    }

    default String removeSpecialCharacters(QuerySolution querySolution) {
        return Util.removeSpecialCharacters(getPropertyValueFrom(querySolution));
    }

    default boolean hasDdwColumnName() { return null != getDdwColumnName() && !getDdwColumnName().isEmpty(); }
}
