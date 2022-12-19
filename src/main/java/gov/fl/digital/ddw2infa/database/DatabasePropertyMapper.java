package gov.fl.digital.ddw2infa.database;

import gov.fl.digital.ddw2infa.MetadataMapper;
import gov.fl.digital.ddw2infa.Util;
import org.apache.jena.query.QuerySolution;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

enum DatabasePropertyMapper implements MetadataMapper<DatabasePropertyMapper> {

    /*
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
            core.description
            core.assignable
            core.businessDescription
            core.businessName
            custom.data.world.owner
            core.reference

        NOTE: core.externalId and core.name are mandatory fields
        https://onlinehelp.informatica.com/IICS/prod/MCC/en/index.htm#page/cloud-metadata-command-center-catalog-source-configuration/Example_Ingest_metadata_from_Microsoft_Access_database.html
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
    description("core.description", null),
    assignable("core.assignable", null),
    businessDescription("core.businessDescription", null),
    businessName("core.businessName", null),
    reference("core.reference", null),
    owner("custom.data.world.owner", null),
    jdbcUrl("custom.data.world.jdbcURL", "jdbcURL"),
    databaseServer("custom.data.world.databaseServer", "databaseServer"),
    databasePort("custom.data.world.databasePort", "databasePort"),

    // Schemas are displayed in DDW but are not displayed as attributes in INFA.  INFA's hierarchy view
    // documents the attributes by displaying the progression from database to schema to table to column
    // so no need to document schemas as an attribute of database.
    schemas(null, "schemas");

    static final List<DatabasePropertyMapper> MAPPERS;
    static final String CSV_HEADER;

    static {

        MAPPERS = Arrays.stream(DatabasePropertyMapper.values())
                // Remove DW columns that don't have matching INFA columns because they aren't used
                .filter(databasePropertyMapper -> null != databasePropertyMapper.infaColumnName)
                .collect(Collectors.toList());

        // TODO: header with quotes
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

    DatabasePropertyMapper(String infaColumnName, String ddwColumnName) {
        this.infaColumnName = infaColumnName;
        this.ddwColumnName = ddwColumnName;
    }

    @Override public String getPropertyValueFrom(QuerySolution querySolution) {
        return (null == ddwColumnName) ? "" : Util.stringValueOf(querySolution.get(ddwColumnName));
    }
}
