package gov.fl.digital.ddw2infa.schema;

import gov.fl.digital.ddw2infa.link.LinksMetadata;

import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class SchemasMetadata {

    public static final String INFA_FILE_NAME = "custom.data.world.SchemaName.csv";

    private final Map<String,Map<String,String>> schemaIdByDatabaseNameAndSchemaName = new HashMap<>();

    public void addRecord(String databaseName, String schemaName, LinksMetadata linksMetadata) {
        databaseName = databaseName.trim();
        schemaName = schemaName.trim();
        String schemaId = "sch." + UUID.randomUUID().toString().replace("-", "");
        Map<String,String> schemaIdBySchemaName = schemaIdByDatabaseNameAndSchemaName.get(databaseName);
        if(null == schemaIdBySchemaName) {
            schemaIdBySchemaName = new HashMap<>();
            schemaIdByDatabaseNameAndSchemaName.put(databaseName, schemaIdBySchemaName);
            schemaIdBySchemaName.put(schemaName, schemaId);
        }
        else {
            if(!schemaIdBySchemaName.containsKey(schemaName)) { schemaIdBySchemaName.put(schemaName, schemaId); }
        }

        // Links management
        linksMetadata.addSchema(databaseName, schemaName, schemaId);
    }

    public void generateCsvFile(String outputDirectoryPath) throws FileNotFoundException {
        try (PrintWriter out = new PrintWriter(outputDirectoryPath + INFA_FILE_NAME)) { out.println(getCSV()); }
    }

    private String getCSV() {
        StringBuilder result = new StringBuilder();
        for(Map<String,String> schemaIdBySchemaName : schemaIdByDatabaseNameAndSchemaName.values()) {
            for(Map.Entry<String,String> entry : schemaIdBySchemaName.entrySet()) {
                String schemaName = entry.getKey();
                String schemaId = entry.getValue();
                result.append("\n");
                result.append(Stream.of(Infa2DdwSchemaMapper.values())
                        .map(mapper -> mapper.processExternalIdAndSchemaName(schemaId, schemaName))
                        .collect(Collectors.joining("|||")));
            }
        }
        return Infa2DdwSchemaMapper.CSV_HEADER + result;
    }

    private enum Infa2DdwSchemaMapper {

        /*
            NOTE: core.externalId and core.name are mandatory fields
            https://onlinehelp.informatica.com/IICS/prod/MCC/en/index.htm#page/cloud-metadata-command-center-catalog-source-configuration/Example_Ingest_metadata_from_Microsoft_Access_database.html
         */
        externalId("core.externalId") {
            @Override String processExternalIdAndSchemaName(String schemaId, String schemaName) {
                return schemaId;
            }
        },
        name("core.name") {
            @Override String processExternalIdAndSchemaName(String schemaId, String schemaName) {
                return (null == schemaName || schemaName.isBlank())
                ?   "(unavailable)"
                :   schemaName;
            }
        },
        description("core.description"),
        assignable("core.assignable"),
        businessDescription("core.businessDescription"),
        businessName("core.businessName"),
        reference("core.reference"),
        owner("custom.data.world.owner");

        final String infaColumnName;

        Infa2DdwSchemaMapper(String infaColumnName) { this.infaColumnName = infaColumnName; }

        private static final String CSV_HEADER;

        String processExternalIdAndSchemaName(String schemaId, String schemaName) { return ""; }

        static {
            CSV_HEADER = Stream.of(values()).map(mapper -> mapper.infaColumnName).collect(Collectors.joining("|||"));
        }
    }
}
