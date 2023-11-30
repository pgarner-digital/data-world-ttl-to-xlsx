package gov.fl.digital.ddw2infa.viewcolumn;

import gov.fl.digital.ddw2infa.MetadataMapper;
import gov.fl.digital.ddw2infa.Util;
import org.apache.jena.query.QuerySolution;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

enum ViewColumnPropertyMapper implements MetadataMapper {

/*
    DDW:
        business_summary
        column_IRI
        column_name
        data_ownner
        data_steward
        database_name
        databaseIRI
        description
        restricted_to_public_disclosure_per_federal_or_state_law
        schema
        sensitive_data
        status
        table_name
        technical_steward
        type
        type_prefix

    INFA:

        core.externalId
        core.name
        core.description
        com.infa.odin.models.relational.Comment
        com.infa.odin.models.relational.Datatype
        com.infa.odin.models.relational.DatatypeLength
        com.infa.odin.models.relational.DatatypeScale
        com.infa.odin.models.relational.Nullable
        com.infa.odin.models.relational.Position
        com.infa.odin.models.relational.calculationComplexity
        com.infa.odin.models.relational.controlConditions
        com.infa.odin.models.relational.expression
        custom.data.world.import.businessSummary
        custom.data.world.import.sensitiveData
        custom.data.world.import.dataSteward
        custom.data.world.import.status
        custom.data.world.import.restrictedToPublic
        custom.data.world.import.technicalSteward

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
    dataType("com.infa.odin.models.relational.Datatype", "columnTypeName"),
    dataTypeLength("com.infa.odin.models.relational.DatatypeLength", "columnSize") {
        @Override public String getPropertyValueFrom(QuerySolution querySolution) {
            String result = "";
            if(null != ddwColumnName) {
                String[] stringArray = Util.stringValueOf(querySolution.get(ddwColumnName)).split("\\^\\^");
                result = (null != stringArray[0]) ? stringArray[0] : "";
            }
            return result;
        }
    },
    nullable("com.infa.odin.models.relational.Nullable", "columnIsNullable") {
        @Override public String getPropertyValueFrom(QuerySolution querySolution) {
            String result = "";
            if(null != ddwColumnName) {
                String[] stringArray = Util.stringValueOf(querySolution.get(ddwColumnName)).split("\\^\\^");
                result = (null != stringArray[0]) ? stringArray[0] : "";
            }
            return result;
        }
    },
    position("com.infa.odin.models.relational.Position", "columnIndex") {
        @Override public String getPropertyValueFrom(QuerySolution querySolution) {
            String result = "";
            if(null != ddwColumnName) {
                String[] stringArray = Util.stringValueOf(querySolution.get(ddwColumnName)).split("\\^\\^");
                result = (null != stringArray[0]) ? stringArray[0] : "";
            }
            return result;
        }
    },
    businessSummary("custom.data.world.import.businessSummary", "business_summary"),
    sensitiveData("custom.data.world.import.sensitiveData", "sensitive_data"),
    dataSteward("custom.data.world.import.dataSteward", "data_steward"),
    status("custom.data.world.import.status", "status"),
    restrictedToPublic("custom.data.world.import.restrictedToPublic", "restricted_to_public_disclosure_per_federal_or_state_law"),
    technicalSteward("custom.data.world.import.technicalSteward", "technical_steward"),
    dataOwner("custom.data.world.import.dataOwner", "data_ownner"),

    // The following INFA fields are not used by DDW,
    comment("com.infa.odin.models.relational.Comment", null),
    dataTypeScale("com.infa.odin.models.relational.DatatypeScale", null),
    calculationComplexity("com.infa.odin.models.relational.calculationComplexity", null),
    controlConditions("com.infa.odin.models.relational.controlConditions", null),
    expression("com.infa.odin.models.relational.expression", null),

    // The following fields are displayed in DDW but are not displayed as attributes in INFA.  INFA's
    // hierarchy view documents the attributes by displaying the progression from database to schema
    // to table to column so no need to document the fields as properties of column.
    databaseName(null, "database_name"),
    databaseIRI(null, "databaseIRI") {
        @Override public String getPropertyValueFrom(QuerySolution querySolution) {
            String result = "";
            if(null != ddwColumnName) {
                String[] stringArray = Util.stringValueOf(querySolution.get(ddwColumnName)).split("ddw-catalogs/");
                result = stringArray[stringArray.length - 1];
            }
            return result;
        }
    },
    schema(null, "schema"),
    tableName(null, "table_name"),
    typePrefix(null, "type_prefix");

    static final MetadataMapper[] MAPPERS;

    static {
        MAPPERS = Arrays.stream(ViewColumnPropertyMapper.values())
            // Remove DW columns that don't have matching INFA columns and vice versa because they aren't used
            .filter(i -> null != i.infaColumnName)
            .toArray(MetadataMapper[]::new);
    }

    final String infaColumnName;
    final String ddwColumnName;

    ViewColumnPropertyMapper(String infaColumnName, String ddwColumnName) {
        this.infaColumnName = infaColumnName;
        this.ddwColumnName = ddwColumnName;
    }

    @Override public String getPropertyValueFrom(QuerySolution querySolution) {
        return (null == ddwColumnName) ? "" : Util.stringValueOf(querySolution.get(ddwColumnName));
    }

    @Override public String getDdwColumnName() { return ddwColumnName; }

    @Override public String getInfaColumnName() { return infaColumnName; }
}
