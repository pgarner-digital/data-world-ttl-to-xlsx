package gov.fl.digital.ddw2infa.link;

import gov.fl.digital.ddw2infa.Util;

import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

public class LinksMetadata {

    public static final String INFA_FILE_NAME = "links.csv";

    private final Map<
        String,                     // database name. TTL result sets use names -- not IDs -- so key by database name.
        IdAndChildren<              // database (contains database ID and the database's child schemas).
            IdAndChildren<          // schema (contains schema ID and the schema's child tables).
                IdAndChildren<      // table (contains table ID and the table's child tables).
                      String        // column (which has no children, therefore just the column's ID)
                >
            >
        >
    > links = new HashMap<>();

    public void generateCsvFile(String outputDirectoryPath) throws FileNotFoundException {
        try (PrintWriter out = new PrintWriter(outputDirectoryPath + INFA_FILE_NAME)) { out.println(getCSV()); }
    }

    public String getCSV() {
        StringBuilder result = new StringBuilder();
        for(Map.Entry<String,
                IdAndChildren<          // database
                    IdAndChildren<      // schema
                        IdAndChildren<  // table
                            String      // column (Column has no children; the children of table are String column IDs)
                        >
                    >
                >

            > linkEntry : links.entrySet()) {
            //String dbName = linkEntry.getKey();
            IdAndChildren<IdAndChildren<IdAndChildren<String>>> dbIdAndChildren = linkEntry.getValue();
            String dbId = dbIdAndChildren.id;
            result.append("\n\"");
            result.append("$resource"); // each database is a child of the root: $resource
            result.append("\",\"");
            result.append(dbId);
            result.append("\",\"");
            result.append(LinkAssociation.Root);
            result.append("\"");
            for(Map.Entry<String,IdAndChildren<IdAndChildren<String>>> schemaEntry :
                    dbIdAndChildren.getChildrenByName().entrySet()) {
                //String schemaName = schemaEntry.getKey();
                IdAndChildren<IdAndChildren<String>> schemaIdAndChildren = schemaEntry.getValue();
                String schemaId = schemaIdAndChildren.id;
                result.append("\n\"");
                result.append("\n");
                result.append(dbId);
                result.append("\",\"");
                result.append(",");
                result.append(schemaId);
                result.append("\",\"");
                result.append(",");
                result.append(LinkAssociation.DatabaseToSchema.association);
                result.append("\"");
                for(Map.Entry<String,IdAndChildren<String>> tableEntry :
                        schemaIdAndChildren.getChildrenByName().entrySet()) {
                    //String tableName = tableEntry.getKey();
                    IdAndChildren<String> tableIdAndChildren = tableEntry.getValue();
                    String tableId = tableIdAndChildren.id;
                    result.append("\n\"");
                    result.append(schemaId);
                    result.append("\",\"");
                    result.append(tableId);
                    result.append("\",\"");
                    result.append(LinkAssociation.SchemaToTable.association);
                    result.append("\"");
                    for(Map.Entry<String,String> columnEntry : tableIdAndChildren.getChildrenByName().entrySet()) {
                        //String columnName = columnEntry.getKey();
                        String columnId = columnEntry.getValue();
                        result.append("\n\"");
                        result.append(tableId);
                        result.append("\",\"");
                        result.append(columnId);
                        result.append("\",\"");
                        result.append(LinkAssociation.TableToColumn.association);
                        result.append("\"");
                    }
                }
            }
        }
        return LinkAssociation.CSV_HEADER + result;
    }

    // This design assumes there are no duplicate database names within an organization.
    public void addDatabase(String dbName, String dbId) {
        Util.checkNullOrEmpty("dbName", dbName);
        Util.checkNullOrEmpty("dbId", dbId);
        if(!links.containsKey(dbName)) {
            links.put(dbName, new IdAndChildren<>(dbId));
        }
    }

    public void addSchema(String dbName, String schemaName, String schemaId) {
        Util.checkNullOrEmpty("dbName", dbName);
        // Some schema info is redacted, such as the schema for People First (PF3) database in DMS.
        //Util.checkNullOrEmpty("schemaName", schemaName);
        Util.checkNullOrEmpty("schemaId", schemaId);
        if(!links.containsKey(dbName)) {
            throw new IllegalStateException("Attempting to add schema to database that does not exist.");
        }
        IdAndChildren<IdAndChildren<IdAndChildren<String>>> dbIdAndChildren = links.get(dbName);
        if(dbIdAndChildren.doesNotContainsChild(schemaName)) {
            dbIdAndChildren.addChild(schemaName, new IdAndChildren<>(schemaId));
        }
    }

    public void addTable(String dbName, String schemaName, String tableName, String tableId) {
        Util.checkNullOrEmpty("dbName", dbName);
        // Some schema info is redacted, such as the schema for People First (PF3) database in DMS.
        //Util.checkNullOrEmpty("schemaName", schemaName);
        Util.checkNullOrEmpty("tableName", tableName);
        Util.checkNullOrEmpty("tableId", tableId);
        if(!links.containsKey(dbName)) {
            throw new IllegalStateException("Attempting to add table to schema but schema's database does not exist.");
        }
        IdAndChildren<IdAndChildren<IdAndChildren<String>>> dbIdAndChildren = links.get(dbName);
        if(dbIdAndChildren.doesNotContainsChild(schemaName)) {
            throw new IllegalStateException("Attempting to add table to schema that does not exist");
        }
        IdAndChildren<IdAndChildren<String>> schemaIdAndChildren = dbIdAndChildren.getChild(schemaName);
        if(schemaIdAndChildren.doesNotContainsChild(tableName)) {
            schemaIdAndChildren.addChild(tableName, new IdAndChildren<>(tableId));
        }
    }

    public void addColumn(String dbName, String schemaName, String tableName, String columnName, String columnId) {
        Util.checkNullOrEmpty("dbName", dbName);
        // Some schema info is redacted, such as the schema for People First (PF3) database in DMS.
        //Util.checkNullOrEmpty("schemaName", schemaName);
        Util.checkNullOrEmpty("tableName", tableName);
        Util.checkNullOrEmpty("columnName", columnName);
        Util.checkNullOrEmpty("columnId", columnId);
        if(!links.containsKey(dbName)) {
            throw new IllegalStateException("Attempting to add column to table but table's database does not exist.");
        }
        IdAndChildren<IdAndChildren<IdAndChildren<String>>> dbIdAndChildren = links.get(dbName);
        if(dbIdAndChildren.doesNotContainsChild(schemaName)) {
            throw new IllegalStateException("Attempting to add column to table but table's schema does not exist");
        }
        IdAndChildren<IdAndChildren<String>> schemaIdAndChildren = dbIdAndChildren.getChild(schemaName);
        if(schemaIdAndChildren.doesNotContainsChild(tableName)) {
            throw new IllegalStateException("Attempting to add column to table but table does not exist");
        }
        IdAndChildren<String> tableIdAndChildren = schemaIdAndChildren.getChild(tableName);
        if(tableIdAndChildren.doesNotContainsChild(columnName)) {
            tableIdAndChildren.addChild(columnName, columnId);
        }
    }

    private enum LinkAssociation {
        Root("core.ResourceParentChild"),
        DatabaseToSchema("custom.data.world.DatabaseToSchema"),
        SchemaToTable("custom.data.world.SchemaToTable"),
        TableToColumn("custom.data.world.TableToColumn");

        final String association;

        LinkAssociation(String association) { this.association = association; }

        //private static final String CSV_HEADER =  "\"Source\",\"Target\",\"Association\"";
        private static final String CSV_HEADER =  "Source,Target,Association";
    }

    private static class IdAndChildren<X> {
        private final String id;
        private final Map<String,X> childrenByName = new HashMap<>();

        private IdAndChildren(String id) { this.id = id; }

        private void addChild(String name, X child) { childrenByName.put(name, child); }
        private boolean doesNotContainsChild(String name) { return !childrenByName.containsKey(name); }
        private X getChild(String name) { return childrenByName.get(name); }
        private Map<String,X> getChildrenByName() { return childrenByName; }
    }
}
