package gov.fl.digital.ddw2infa.view;

import gov.fl.digital.ddw2infa.MetadataMapper;
import gov.fl.digital.ddw2infa.Util;
import org.apache.jena.query.QuerySolution;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

enum ViewPropertyMapper implements MetadataMapper {
    /*
        DDW:
            table_IRI
            table_name
            description
            data_ownner
            database_name
            schema
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
            com.infa.odin.models.relational.Comment
            com.infa.odin.models.relational.Owner
            com.infa.odin.models.relational.ViewType
            com.infa.odin.models.relational.errorMessage
            com.infa.odin.models.relational.htmlLink
            com.infa.odin.models.relational.sourceStatementText
            custom.data.world.test.businessSummary
            custom.data.world.test.restrictedToPublic
            custom.data.world.test.sensitiveData
            custom.data.world.test.dataSharingAgreement
            custom.data.world.test.programOffice
            custom.data.world.test.dataSteward
            custom.data.world.test.technicalSteward
            custom.data.world.test.contactEmail
            custom.data.world.test.status

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
    owner("com.infa.odin.models.relational.Owner", "data_ownner"),
    viewType("com.infa.odin.models.relational.ViewType", "type"),
    businessSummary("custom.data.world.import.businessSummary", "business_summary"),
    restrictedToPublic("custom.data.world.import.restrictedToPublic", "restricted_to_public_disclosure_per_federal_or_state_law"),
    sensitiveData("custom.data.world.import.sensitiveData", "sensitive_data"),
    dataSharingAgreement("custom.data.world.import.dataSharingAgreement", "data_sharing_agreement"),
    programOffice("custom.data.world.import.programOffice", "program_office"),
    dataSteward("custom.data.world.import.dataSteward", "data_steward"),
    technicalSteward("custom.data.world.import.technicalSteward", "technical_steward"),
    contactEmail("custom.data.world.import.contactEmail", "contact_email"),
    status("custom.data.world.import.status", "status"),

    // The following DDW fields are used to link a table to its parent in the hierarchy
    databaseName(null, "database_name"),
    schema(null, "schema"),

    // The following INFA fields are not used by DDW
    comment("com.infa.odin.models.relational.Comment", null),
    location("com.infa.odin.models.relational.Location", null),
    numberOfRows("com.infa.odin.models.relational.NumberOfRows", null),
    partitioned("com.infa.odin.models.relational.Partitioned", null),
    provider("com.infa.odin.models.relational.Provider", null);

    static final List<ViewPropertyMapper> MAPPERS;

    static {

        MAPPERS = Arrays.stream(ViewPropertyMapper.values())
                // Remove DW columns that don't have matching INFA columns because they aren't used
                .filter(i -> null != i.infaColumnName)
                .collect(Collectors.toList());
    }

    final String infaColumnName;
    final String ddwColumnName;

    ViewPropertyMapper(String infaColumnName, String ddwColumnName) {
        this.infaColumnName = infaColumnName;
        this.ddwColumnName = ddwColumnName;
    }

    @Override public String getPropertyValueFrom(QuerySolution querySolution) {
        return (null == ddwColumnName) ? "" : Util.stringValueOf(querySolution.get(ddwColumnName));
    }

    @Override public String getDdwColumnName() { return ddwColumnName; }

    @Override public String getInfaColumnName() { return infaColumnName; }

}
