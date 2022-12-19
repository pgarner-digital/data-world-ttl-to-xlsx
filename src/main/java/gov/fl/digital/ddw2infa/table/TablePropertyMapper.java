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

        NOTE: core.externalId and core.name are mandatory fields
        https://onlinehelp.informatica.com/IICS/prod/MCC/en/index.htm#page/cloud-metadata-command-center-catalog-source-configuration/Example_Ingest_metadata_from_Microsoft_Access_database.html
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
    owner("custom.data.world.owner", "data_ownner"),
    typePrefix("custom.data.world.typePrefix", "type_prefix"),
    type("custom.data.world.tableType", "type"),
    businessSummary("custom.data.world.businessSummary", "business_summary"),
    restrictedToPublic("custom.data.world.restrictedToPublic", "restricted_to_public_disclosure_per_federal_or_state_law"),
    sensitiveData("custom.data.world.sensitiveData", "sensitive_data"),
    dataSharingAgreement("custom.data.world.dataSharingAgreement", "data_sharing_agreement"),
    programOffice("custom.data.world.programOffice", "program_office"),
    dataSteward("custom.data.world.dataSteward", "data_steward"),
    technicalSteward("custom.data.world.technicalSteward", "technical_steward"),
    contactEmail("custom.data.world.contactEmail", "contact_email"),
    status("custom.data.world.status", "status"),

    // The following DDW fields are used to link a table to its parent in the hierarchy
    databaseName(null, "database_name"),
    schema(null, "schema"),

    // The following INFA fields are not used by DDW
    businessDescription("core.businessDescription", null),
    businessName("core.businessName", null),
    reference("core.reference", null);

    static final List<TablePropertyMapper> MAPPERS;
    static final String CSV_HEADER;

    static {

        MAPPERS = Arrays.stream(TablePropertyMapper.values())
                // Remove DW columns that don't have matching INFA columns because they aren't used
                .filter(i -> null != i.infaColumnName)
                .collect(Collectors.toList());

        //TODO: header with quotes
        CSV_HEADER = "\"" +
                MAPPERS.stream()
                        .map(mapper -> mapper.infaColumnName)
                        .collect(Collectors.joining("\",\"")) +
                "\"";
        // TODO: header without quotes
        /*
        CSV_HEADER = MAPPERS.stream()
                        .map(mapper -> mapper.infaColumnName)
                        .collect(Collectors.joining(","));
        */

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
