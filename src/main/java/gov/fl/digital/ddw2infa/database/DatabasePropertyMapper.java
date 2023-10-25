package gov.fl.digital.ddw2infa.database;

import gov.fl.digital.ddw2infa.MetadataMapper;
import gov.fl.digital.ddw2infa.Util;
import org.apache.jena.query.QuerySolution;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

enum DatabasePropertyMapper implements MetadataMapper {
    /*
        NOTE: core.externalId and core.name are mandatory fields
        https://onlinehelp.informatica.com/IICS/prod/MCC/en/index.htm#page/cloud-metadata-command-center-catalog-source-configuration/Example_Ingest_metadata_from_Microsoft_Access_database.html

        DDW-to-INFA Mappings:

            DDW:
                databaseiri
                databaseName
                jdbcURL
                databaseServer
                databasePort
                schemas

            INFA:
                core.externalId
                core.name
                custom.data.world.import.jdbcURL
                custom.data.world.import.databaseServer
                custom.data.world.import.databasePort
                core.description
                com.infa.odin.models.relational.Comment
                com.infa.odin.models.relational.Owner
                com.infa.odin.models.relational.ProductName
                com.infa.odin.models.relational.ProductVersion

    */

    externalId("core.externalId", "databaseiri") {
        @Override public String getPropertyValueFrom(QuerySolution querySolution) {
            String result = "";
            if(null != ddwColumnName) {
                String[] stringArray = Util.stringValueOf(querySolution.get(ddwColumnName)).split("ddw-catalogs/");
                result = stringArray[stringArray.length - 1];
            }
            return result;
        }
    },
    name("core.name", "databaseName"),
    jdbcUrl("custom.data.world.import.jdbcURL", "jdbcURL"),
    databaseServer("custom.data.world.import.databaseServer", "databaseServer"),
    databasePort("custom.data.world.import.databasePort", "databasePort") {
        @Override public String getPropertyValueFrom(QuerySolution querySolution) {
            String result = "";
            if(null != ddwColumnName) {
                String[] stringArray = Util.stringValueOf(querySolution.get(ddwColumnName)).split("\\^\\^");
                result = (null != stringArray[0]) ? stringArray[0] : "";
            }
            return result;
        }
    },

    // The following INFA fields are not used by DDW,
    description("core.description", null),
    comment("com.infa.odin.models.relational.Comment", null),
    owner("com.infa.odin.models.relational.Owner", null),
    productName("com.infa.odin.models.relational.ProductName", null),
    productVersion("com.infa.odin.models.relational.ProductVersion", null),

    // Schemas are displayed in DDW but are not displayed as attributes in INFA.  INFA's hierarchy view
    // documents the attributes by displaying the progression from database to schema to table to column
    // so no need to document schemas as an attribute of database.
    schemas(null, "schemas");

    static final List<DatabasePropertyMapper> MAPPERS;

    static {
        MAPPERS = Arrays.stream(DatabasePropertyMapper.values())
            // Remove DW columns that don't have matching INFA columns because they aren't used
            .filter(databasePropertyMapper -> null != databasePropertyMapper.infaColumnName)
            .collect(Collectors.toList());
    }

    final String infaColumnName;
    final String ddwColumnName;

    DatabasePropertyMapper(String infaColumnName, String ddwColumnName) {
        this.infaColumnName = infaColumnName;
        this.ddwColumnName = ddwColumnName;
    }

    @Override public String getInfaColumnName() { return infaColumnName; }

    @Override public String getDdwColumnName() { return ddwColumnName; }

    @Override public String getPropertyValueFrom(QuerySolution querySolution) {
        return (null == ddwColumnName) ? "" : Util.stringValueOf(querySolution.get(ddwColumnName));
    }
}
