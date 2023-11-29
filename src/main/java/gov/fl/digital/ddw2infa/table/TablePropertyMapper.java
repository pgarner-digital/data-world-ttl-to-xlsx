package gov.fl.digital.ddw2infa.table;

import gov.fl.digital.ddw2infa.MetadataMapper;
import gov.fl.digital.ddw2infa.Util;
import org.apache.jena.query.QuerySolution;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

enum TablePropertyMapper implements MetadataMapper {
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
            com.infa.odin.models.relational.Location
            com.infa.odin.models.relational.NumberOfRows
            com.infa.odin.models.relational.Owner
            com.infa.odin.models.relational.Partitioned
            com.infa.odin.models.relational.Provider
            com.infa.odin.models.relational.TableType
            custom.data.world.import.businessSummary
            custom.data.world.import.restrictedToPublic
            custom.data.world.import.sensitiveData
            custom.data.world.import.dataSharingAgreement
            custom.data.world.import.programOffice
            custom.data.world.import.dataSteward
            custom.data.world.import.technicalSteward
            custom.data.world.import.contactEmail
            custom.data.world.import.status

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
    owner("com.infa.odin.models.relational.Owner", "schema"),
    businessSummary("custom.data.world.import.businessSummary", "business_summary"),
    contactEmail("custom.data.world.import.contactEmail", "contact_email"),
    dataSharingAgreement("custom.data.world.import.dataSharingAgreement", "data_sharing_agreement"),
    dataSteward("custom.data.world.import.dataSteward", "data_steward"),
    programOffice("custom.data.world.import.programOffice", "program_office"),
    restrictedToPublic("custom.data.world.import.restrictedToPublic", "restricted_to_public_disclosure_per_federal_or_state_law"),
    sensitiveData("custom.data.world.import.sensitiveData", "sensitive_data"),
    status("custom.data.world.import.status", "status"),
    tableType("com.infa.odin.models.relational.TableType", "type"),
    technicalSteward("custom.data.world.import.technicalSteward", "technical_steward"),
    dataOwner("custom.data.world.import.dataOwner", "data_ownner"),

    // The following DDW fields are used to link a table to its parent in the hierarchy
    databaseName(null, "database_name"),

    // The following INFA fields are not used by DDW
    comment("com.infa.odin.models.relational.Comment", null),
    location("com.infa.odin.models.relational.Location", null),
    numberOfRows("com.infa.odin.models.relational.NumberOfRows", null),
    partitioned("com.infa.odin.models.relational.Partitioned", null),
    provider("com.infa.odin.models.relational.Provider", null);

    static final MetadataMapper[] MAPPERS;

    static {
        MAPPERS = Arrays.stream(TablePropertyMapper.values())
                // Remove DW columns that don't have matching INFA columns because they aren't used
                .filter(i -> null != i.infaColumnName)
                .toArray(MetadataMapper[]::new);
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

    @Override public String getDdwColumnName() { return ddwColumnName; }

    @Override public String getInfaColumnName() { return infaColumnName; }

}
