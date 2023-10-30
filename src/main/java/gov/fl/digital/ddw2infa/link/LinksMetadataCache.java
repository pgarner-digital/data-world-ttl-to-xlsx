package gov.fl.digital.ddw2infa.link;

import gov.fl.digital.ddw2infa.Util;
import gov.fl.digital.ddw2infa.schema.SchemasMetadataCache;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.*;

public class LinksMetadataCache {
    public static final String INFA_FILE_NAME = "links.csv";
    public static final String INFA_TABLE_NAME = "LINKS_METADATA";
    private static final Logger logger = LogManager.getLogger(LinksMetadataCache.class);

    private final Map<
        String,                     // database name. TTL result sets have names -- not IDs -- so key by database name.
        IdAndChildren<              // database (contains database ID and the database's child schemas).
            IdAndChildren<          // schema (contains schema ID and the two child maps, named "tables" and "views").
                Map<                // tableOrViewMap
                    String,         // Table name or view name
                    IdAndChildren<  // table or view (contains table- or view ID and the table's or view's child columns).
                        String      // column or view-column (which has no children, therefore just the column's or view's ID)
                    >
                >
            >
        >
    > links = new HashMap<>();

    public void pushToSnowflake(
        Connection connection,
        LocalDateTime localDateTime,
        ChronoUnit chronoUnit,
        String orgId
    )
        throws SQLException {
        Objects.requireNonNull(connection);
        Objects.requireNonNull(localDateTime);
        Objects.requireNonNull(chronoUnit);
        Objects.requireNonNull(orgId);
        String insertStatement = String.format(
            "INSERT INTO %s (OrgId, Source, Target, Association) VALUES (?, ?, ?, ?)",
            INFA_TABLE_NAME
        );
        try (PreparedStatement preparedStatement = connection.prepareStatement(insertStatement)) {
            int rowCount = 1;
            logger.info("Begin extracting table results ...");
            for(
                IdAndChildren<              // database (contains database ID and the database's child schemas).
                    IdAndChildren<          // schema (contains schema ID and the two child maps, named "tables" and "views").
                        Map<                // tableOrViewMap
                            String,         // Table name or view name
                            IdAndChildren<  // table or view (contains table- or view ID and the child columns or view-columns).
                                String      // the columns' or view-columns' IDs
                            >
                        >
                    >
                >
                dbIdAndChildren :
                links.values()
            ) {
                String dbId = dbIdAndChildren.id;
                batchRow(
                    preparedStatement,
                    orgId,
                    "$resource", // INFA requires that the database's parent (the root) be "$resource"
                    dbId,
                    LinkAssociation.Root.association,
                    rowCount++,
                    localDateTime,
                    chronoUnit
                );
                for(
                    IdAndChildren<Map<String, IdAndChildren<String>>> schemaIdAndChildren :
                    dbIdAndChildren.getChildrenByName().values()
                ) {
                    String schemaId = schemaIdAndChildren.id;
                    // First, batch the database-to-schema association
                    batchRow(
                        preparedStatement,
                        orgId,
                        dbId,
                        schemaId,
                        LinkAssociation.DatabaseToSchema.association,
                        rowCount++,
                        localDateTime,
                        chronoUnit
                    );
                    // Unlike other nodes in the datastructure, schemaIdAndChildren has
                    // 2 maps as children: one for tables and one for views.
                    for(
                        Map.Entry<String,Map<String,IdAndChildren<String>>> tableOrViewClassificationEntry :
                        schemaIdAndChildren.getChildrenByName().entrySet()
                    ) {
                        // NOTE:  Recall that there are only two table-to-view-classification entries.
                        // Next, navigate across the map, tableOrViewEntryMap, to access another map,
                        // which is either the tables map or views map, each of which hashes tables
                        // IdAndChildren or views IdAndChildren.
                        // tableOrView is used to provide the correct association to make
                        // between schema and child e.g., schema-to-table or schema-to-view.
                        TableOrView tableOrView = TableOrView.valueOf(tableOrViewClassificationEntry.getKey());
                        Map<String,IdAndChildren<String>> tableOrViewEntryMap =
                            tableOrViewClassificationEntry.getValue();
                        for(IdAndChildren<String> tableOrViewIdAndChildren: tableOrViewEntryMap.values()) {

                            // Next, iterate over the schema-to-table and schema-to-view associations
                            // and batch their table- and view association records.
                            String tableOrViewId = tableOrViewIdAndChildren.id;
                            batchRow(
                                preparedStatement,
                                orgId,
                                schemaId,
                                tableOrViewId,
                                tableOrView.getSchemaChildLinkAssociation().association,
                                rowCount++,
                                localDateTime,
                                chronoUnit
                            );

                            // Next, iterate over table-to-column and/or view-to-view-column associations
                            // and batch column and view-column records.
                            for(String columnIdOrViewId : tableOrViewIdAndChildren.getChildrenByName().values())
                            {
                                batchRow(
                                    preparedStatement,
                                    orgId,
                                    tableOrViewId,
                                    columnIdOrViewId,
                                    tableOrView.getTableOrViewChildLinkAssociation().association,
                                    rowCount++,
                                    localDateTime,
                                    chronoUnit
                                );
                            }
                        }
                    }
                }
            }
            preparedStatement.executeBatch();
            logger.info("Committing table links metadata changes to Snowflake.\n");
            connection.commit();
        }
    }

    private static void batchRow(
        PreparedStatement preparedStatement,
        String orgId,
        String source,
        String target,
        String association,
        int rowCount,
        LocalDateTime localDateTime,
        ChronoUnit chronoUnit
    ) throws SQLException {
        preparedStatement.setString(1, orgId);
        preparedStatement.setString(2, source);
        preparedStatement.setString(3, target);
        preparedStatement.setString(4, association);
        preparedStatement.addBatch();
/*
        logger.info("Processing link record: " + rowCount + "(" +
                localDateTime.until(LocalDateTime.now(), chronoUnit) + " " +
                chronoUnit.name().toLowerCase() + ").");
*/
    }

    // This design assumes there are no duplicate database names within an organization.
    public void addDatabase(String dbName, String dbId) {
        Util.checkNullOrEmpty("dbName", dbName);
        Util.checkNullOrEmpty("dbId", dbId);
        if(!links.containsKey(dbName)) { links.put(dbName, new IdAndChildren<>(dbId)); }
    }

    public void addSchema(String dbName, String schemaName, String schemaId) {
        Util.checkNullOrEmpty("dbName", dbName);
        // PeopleFirst team decided not to provide a schema name for the PF3 database.
        // If schemaName is not provided, it's manually set because it's used to
        // populate INFA's "core.name" field, which is required and cannot be empty.
        schemaName = Util.getSchemaNameHack(schemaName);

        Util.checkNullOrEmpty("schemaId", schemaId);
        if(!links.containsKey(dbName)) {
            throw new IllegalStateException("Attempting to add schema to database that does not exist.");
        }
        IdAndChildren<IdAndChildren<Map<String, IdAndChildren<String>>>> dbIdAndChildren = links.get(dbName);
        if(dbIdAndChildren.doesNotContainChild(schemaName)) {
            dbIdAndChildren.addChild(schemaName, new IdAndChildren<>(schemaId));
        }
    }

    public void addTableOrView(
        TableOrView tableOrView,
        String dbName,
        String schemaName,
        String tableNameOrViewName,
        String tableIdOrViewId
    ) {
        Util.checkNullOrEmpty("dbName", dbName);

        // PeopleFirst team decided not to provide a schema name for the PF3 database.
        // If schemaName is not provided, it's manually set because it's used to
        // populate INFA's "core.name" field, which is required and cannot be empty.
        schemaName = Util.getSchemaNameHack(schemaName);

        // Some schema info is redacted by agency customers, such as the schema for People First (PF3) database in DMS.
        //Util.checkNullOrEmpty("schemaName", schemaName);

        Util.checkNullOrEmpty("tableNameOrViewName", tableNameOrViewName);
        Util.checkNullOrEmpty("tableIdOrViewId", tableIdOrViewId);

        if(!links.containsKey(dbName)) {
            // Method LinksMetadataCache#addDatabase must be called before this method is invoked.
            throw new IllegalStateException("Attempting to add " + tableOrView.name() + " '"+ tableNameOrViewName +
                "' to schema '"+ schemaName + "' but schema's database '" + dbName + "' does not exist.");
        }
        IdAndChildren<IdAndChildren<Map<String, IdAndChildren<String>>>> dbIdAndChildren = links.get(dbName);
        if(dbIdAndChildren.doesNotContainChild(schemaName)) {
            // Method LinksMetadataCache#addSchema must be called before this method is invoked.
            throw new IllegalStateException("Attempting to add " + tableOrView.name() + " '"+ tableNameOrViewName +
                "' to schema '"+ schemaName + "', which does not exist in database '"+ dbName + "'.");
        }
        IdAndChildren<Map<String, IdAndChildren<String>>> schemaIdAndChildren = dbIdAndChildren.getChild(schemaName);
        Map<String,IdAndChildren<String>> tableOrViewMap;
        if(schemaIdAndChildren.containsChild(tableOrView.name())) {
            tableOrViewMap = schemaIdAndChildren.getChild(tableOrView.name());
        }
        else {
            tableOrViewMap = new HashMap<>();
            schemaIdAndChildren.addChild(tableOrView.name(),tableOrViewMap);
        }

        if(!tableOrViewMap.containsKey(tableNameOrViewName)) {
            tableOrViewMap.put(tableNameOrViewName, new IdAndChildren<>(tableIdOrViewId));
        }
    }

    public void addColumnOrViewColumn(
        TableOrView tableOrView,
        String dbName,
        String schemaName,
        String tableNameOrViewName,
        String columnNameOrViewColumnName,
        String columnIdOrViewId
    ) {
        Util.checkNullOrEmpty("dbName", dbName);
        // PeopleFirst team decided not to provide a schema name for the PF3 database.
        // If schemaName is not provided, it's manually set because it's used to
        // populate INFA's "core.name" field, which is required and cannot be empty.
        schemaName = Util.getSchemaNameHack(schemaName);
        Util.checkNullOrEmpty("tableNameOrViewName", tableNameOrViewName);
        Util.checkNullOrEmpty("columnNameOrViewColumnName", columnNameOrViewColumnName);
        Util.checkNullOrEmpty("columnIdOrViewId", columnIdOrViewId);
        if(!links.containsKey(dbName)) {
            // Method LinksMetadataCache#addDatabase must be called before this method is invoked.
            throw new IllegalStateException(
                "Attempting to add "+ tableOrView.getColumnLabel() + " '"+
                    columnNameOrViewColumnName + "' to table '" + tableNameOrViewName + "' in schema '"+ schemaName +
                        "' but database '" + dbName + "' does not exist."
            );
        }
        IdAndChildren<IdAndChildren<Map<String, IdAndChildren<String>>>> dbIdAndChildren = links.get(dbName);
        if(dbIdAndChildren.doesNotContainChild(schemaName)) {
            // Method LinksMetadataCache#addSchema must be called before this method is invoked.
            throw new IllegalStateException("Attempting to add "+ tableOrView.getColumnLabel() + " '"+
                columnNameOrViewColumnName + "' to table '" + tableNameOrViewName + "' in schema '"+ schemaName +
                    "' and in database '" + dbName + "' but schema does not exist.");
        }
        IdAndChildren<Map<String, IdAndChildren<String>>> schemaIdAndChildren = dbIdAndChildren.getChild(schemaName);
        if(schemaIdAndChildren.doesNotContainChild(tableOrView.name())) {
            // Method LinksMetadataCache#addTableOrView, which puts the classification of view or label
            // into the data structure, must be called before this method is invoked.
            throw new IllegalStateException("Attempting to add "+ tableOrView.getColumnLabel() + " '"+
                columnNameOrViewColumnName + "' to table '" + tableNameOrViewName + "' in schema '"+ schemaName +
                    "' and in database '" + dbName + "' but the '" + tableOrView.name() + "' filter does not exist.");
        }
        Map<String,IdAndChildren<String>> tableOrViewMap = schemaIdAndChildren.getChild(tableOrView.name());
        if(tableOrViewMap.containsKey(tableNameOrViewName)) {
            IdAndChildren<String> tableOrViewIdAndChildren = tableOrViewMap.get(tableNameOrViewName);
            if(tableOrViewIdAndChildren.containsChild(columnNameOrViewColumnName)) {
                throw new IllegalStateException(
                    "Attempting to add " + tableOrView.getColumnLabel() + " '" +
                        columnNameOrViewColumnName + "' to table '" + tableNameOrViewName + "' in schema '" +
                            schemaName + "' and in database '" + dbName + "' but the column already exists."
                );
            }
            else {
                tableOrViewIdAndChildren.addChild(columnNameOrViewColumnName, columnIdOrViewId);
            }
        }
        else {
            throw new IllegalStateException("Attempting to add "+ tableOrView.getColumnLabel() + " '"+
                columnNameOrViewColumnName + "' to table '" + tableNameOrViewName + "' in schema '"+ schemaName +
                    "' and in database '" + dbName + "' in the '" + tableOrView.name() + "' filter but the " +
                        "table or view named '" + tableNameOrViewName + "' does not exist.");
        }
   }

    private enum LinkAssociation {
        Root("core.ResourceParentChild"),
        DatabaseToSchema("com.infa.odin.models.relational.DatabaseToSchema"),
        SchemaToTable("com.infa.odin.models.relational.SchemaToTable"),
        TableToColumn("com.infa.odin.models.relational.TableToColumn"),
        SchemaToView("com.infa.odin.models.relational.SchemaToView"),
        ViewToViewColumn("com.infa.odin.models.relational.ViewToViewColumn");

        final String association;

        LinkAssociation(String association) { this.association = association; }
    }

    private static class IdAndChildren<X> {
        private final String id;
        private final Map<String,X> childrenByName = new HashMap<>();

        private IdAndChildren(String id) { this.id = id; }

        private void addChild(String name, X child) {
            if(childrenByName.containsKey(name)) {
                throw new IllegalStateException("Can't add child '" + name + "' to children.  It already exists.");
            }
            childrenByName.put(name, child);
        }
        private boolean doesNotContainChild(String name) { return !containsChild(name); }
        private boolean containsChild(String name) { return childrenByName.containsKey(name); }
        private X getChild(String name) { return childrenByName.get(name); }
        private Map<String,X> getChildrenByName() { return childrenByName; }
    }

    public enum TableOrView {
        table () {
            @Override LinkAssociation getSchemaChildLinkAssociation() { return LinkAssociation.SchemaToTable; }
            @Override LinkAssociation getTableOrViewChildLinkAssociation() { return LinkAssociation.TableToColumn; }

            @Override String getColumnLabel() { return "column"; }
        },
        view () {
            @Override LinkAssociation getSchemaChildLinkAssociation() { return LinkAssociation.SchemaToView; }
            @Override LinkAssociation getTableOrViewChildLinkAssociation() { return LinkAssociation.ViewToViewColumn; }
            @Override String getColumnLabel() { return "view-column"; }
        };

        abstract LinkAssociation getSchemaChildLinkAssociation();
        abstract LinkAssociation getTableOrViewChildLinkAssociation();
        abstract String getColumnLabel();
    }
}
