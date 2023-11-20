package gov.fl.digital.ddw2infa;

import org.apache.jena.query.QuerySolution;

public interface MetadataMapper {

    String getInfaColumnName();

    String getDdwColumnName();

    String name();

    default boolean isUsedOnlyByDDW() {
        return null != getDdwColumnName() && null == getInfaColumnName();
    }

    default boolean isUsedOnlyByINFA() {
        return null == getDdwColumnName() && null != getInfaColumnName();
    }

    default boolean isUsedByBothDdwAndInfa() {
        return null != getDdwColumnName() && null != getInfaColumnName();
    }

    String getPropertyValueFrom(QuerySolution querySolution);

    default String getDoubleQuoteEncapsulatedPropertyValueFrom(QuerySolution querySolution) {
        return Util.encapsulateDoubleQuotes(getPropertyValueFrom(querySolution));
    }

    default String removeSpecialCharacters(QuerySolution querySolution) {
        return Util.removeSpecialCharacters(getPropertyValueFrom(querySolution));
    }

    default boolean hasDdwColumnName() { return null != getDdwColumnName() && !getDdwColumnName().isEmpty(); }
}
