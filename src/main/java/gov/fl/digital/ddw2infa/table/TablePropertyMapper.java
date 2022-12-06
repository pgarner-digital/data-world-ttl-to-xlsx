package gov.fl.digital.ddw2infa.table;

import gov.fl.digital.ddw2infa.MetadataMapper;
import gov.fl.digital.ddw2infa.Util;
import org.apache.jena.query.QuerySolution;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

enum TablePropertyMapper implements MetadataMapper<TablePropertyMapper> {
    /*
        DDW:
            table_IRI
            table_name
            description
            data_ownner
            database_name
            schema

            // TODO: the following DDW fields are not yet captured by the INFA custom data.world metamodel
            type_prefix
            type
            business_summary
            restricted_to_public_disclosure_per_federal_or_state_law
            sensitive_data
            data_sharing_agreement
            program_office
            data_steward
            technical_steward
            contact_email
            status

        INFA:
            core.externalId
            core.name
            core.description
            core.businessDescription
            core.businessName
            custom.data.world.owner
            core.reference
     */

    externalId("core.externalId", "table_IRI") {
        @Override public String getPropertyValueFrom(QuerySolution querySolution) {
            String result = "";
            if(null != ddwColumnName) {
                String[] stringArray = Util.stringValueOf(querySolution.get(ddwColumnName)).split("ddw-catalogs/");
                result = stringArray[stringArray.length - 1];
            }
            return result;
        }
    },
    name("core.name", "table_name"),
    description("core.description", "description"),

    // TODO drop business description because we already have a description field
    businessDescription("core.businessDescription", null),
    businessName("core.businessName", null),

    // TODO: Steve Hill uses custom.data.world.dataOwner for Column
    dataOwner("custom.data.world.owner", "data_ownner"),
    reference("core.reference", null),

    // TODO: The following DDW fields may be added to the INFA custom metamodel.
    typePrefix(null, "type_prefix"),
    type(null, "type"),
    businessSummary(null, "business_summary"),
    restrictedToPublic(null, "restricted_to_public_disclosure_per_federal_or_state_law"),
    sensitiveData(null, "sensitive_data"),
    dataSharingAgreement(null, "data_sharing_agreement"),
    programOffice(null, "program_office"),
    dataSteward(null, "data_steward"),
    technicalSteward(null, "technical_steward"),
    contactEmail(null, "contact_email"),
    status(null, "status"),

    // TODO: the following DDW fields are used to link a table to its parent in the hierarchy
    databaseName(null, "database_name"),
    schema(null, "schema");

    static final List<TablePropertyMapper> MAPPERS;
    static final String CSV_HEADER;

    static {

        MAPPERS = Arrays.stream(TablePropertyMapper.values())
                // Remove DW columns that don't have matching INFA columns because they aren't used
                .filter(i -> null != i.infaColumnName)
                .collect(Collectors.toList());

        CSV_HEADER = "\"" +
                MAPPERS.stream()
                        .map(mapper -> mapper.infaColumnName)
                        .collect(Collectors.joining("\",\"")) +
                "\"";
    }

    final String infaColumnName;
    final String ddwColumnName;

    TablePropertyMapper(String infaColumnName, String ddwColumnName) {
        this.infaColumnName = infaColumnName;
        this.ddwColumnName = ddwColumnName;
    }

    @Override public String getPropertyValueFrom(QuerySolution querySolution) {
        return (null == ddwColumnName) ? "" : Util.stringValueOf(querySolution.get(ddwColumnName));
    }
}
