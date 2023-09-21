package gov.fl.digital.ddw2infa.column;

import gov.fl.digital.ddw2infa.MetadataMapper;
import gov.fl.digital.ddw2infa.Util;
import org.apache.jena.query.QuerySolution;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

enum ColumnPropertyMapper implements MetadataMapper<ColumnPropertyMapper> {

/*
    DDW:
        type_prefix
        database_name
        table_name
        schema
        type
        column_name
        column_IRI
        description
        business_summary
        restricted_to_public_disclosure_per_federal_or_state_law
        sensitive_data
        data_ownner
        data_steward
        technical_steward
        status

    INFA:
        core.externalId
        custom.data.world.iri
        core.name
        core.description
        core.businessDescription
        core.businessName
        custom.data.world.businessSummary
        custom.data.world.columnTypeName
        custom.data.world.typePrefix
        custom.data.world.owner
        custom.data.world.dataSteward
        custom.data.world.technicalSteward
        custom.data.world.restrictedToPublic
        custom.data.world.sensitiveData
        custom.data.world.status
        core.reference

        NOTE: core.externalId and core.name are mandatory fields
        https://onlinehelp.informatica.com/IICS/prod/MCC/en/index.htm#page/cloud-metadata-command-center-catalog-source-configuration/Example_Ingest_metadata_from_Microsoft_Access_database.html

*/

    externalId("core.externalId", "column_IRI") {
        @Override public String getPropertyValueFrom(QuerySolution querySolution) {
            String result = "";
            if(null != ddwColumnName) {
                String[] stringArray = Util.stringValueOf(querySolution.get(ddwColumnName)).split("ddw-catalogs/");
                result = stringArray[stringArray.length - 1];
            }
            return result;
        }
    },
    name("core.name", "column_name"),
    description("core.description", "description"),
    businessSummary("custom.data.world.businessSummary", "business_summary"),
    iri("custom.data.world.iri", "column_IRI") {
        @Override public String getPropertyValueFrom(QuerySolution querySolution) {
            String result = "";
            if(null != ddwColumnName) {
                String[] stringArray = Util.stringValueOf(querySolution.get(ddwColumnName)).split("ddw-catalogs/");
                result = stringArray[stringArray.length - 1];
            }
            return result;
        }
    },
    columnType("custom.data.world.columnTypeName", "type"),
    owner("custom.data.world.owner", "data_ownner"),
    dataSteward("custom.data.world.dataSteward", "data_steward"),
    restrictedToPublic("custom.data.world.restrictedToPublic",
            "restricted_to_public_disclosure_per_federal_or_state_law"),
    sensitiveData("custom.data.world.sensitiveData", "sensitive_data"),
    status("custom.data.world.status", "status"),
    technicalSteward("custom.data.world.technicalSteward", "technical_steward"),
    typePrefix("custom.data.world.typePrefix", "type_prefix"),

    // The following INFA fields are not used by DDW
    businessDescription("core.businessDescription", null),
    businessName("core.businessName", null),
    reference("core.reference", null),

    //  are displayed by DDW but are not displayed as attributes INFA.  INFA's hierarchy view
    // documents the attributes by displaying the progression from database to schema to table to column.

    // The following fields are displayed in DDW but are not displayed as attributes in INFA.  INFA's
    // hierarchy view documents the attributes by displaying the progression from database to schema
    // to table to column so no need to document the fields as properties of column.
    databaseName(null, "database_name"),
    tableName(null, "table_name"),
    schema(null, "schema");

    static final List<ColumnPropertyMapper> MAPPERS;
    static final String CSV_HEADER;

    static {
        MAPPERS = Arrays.stream(ColumnPropertyMapper.values())
            // Remove DW columns that don't have matching INFA columns and vice versa because they aren't used
            .filter(i -> null != i.infaColumnName)
            .collect(Collectors.toList());
        CSV_HEADER = MAPPERS.stream()
            .map(mapper -> mapper.infaColumnName)
            .collect(Collectors.joining("|||"));
    }

    final String infaColumnName;
    final String ddwColumnName;

    ColumnPropertyMapper(String infaColumnName, String ddwColumnName) {
        this.infaColumnName = infaColumnName;
        this.ddwColumnName = ddwColumnName;
    }

    @Override public String getPropertyValueFrom(QuerySolution querySolution) {
        return (null == ddwColumnName) ? "" : Util.stringValueOf(querySolution.get(ddwColumnName));
    }
}
