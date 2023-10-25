package gov.fl.digital.ddw2infa.link;

import gov.fl.digital.ddw2infa.Util;
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
            IdAndChildren<          // schema (contains schema ID and the schema's two children: "tables" and "views").
                Map<
                    String,         // TableOrView enum name e.g., the word "table" or "view"
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
            for(IdAndChildren<              // database (contains database ID and the database's child schemas).
                    IdAndChildren<          // schema (contains schema ID and the schema's two children: "tables" and "views").
                        Map<
                            String,         // TableOrView enum name e.g., the word "table" or "view"
                            IdAndChildren<  // table or view (contains table- or view ID and the table's or view's child columns).
                                String      // column or view-column (which has no children, therefore just the column's or view's ID)
                            >
                        >
                    >
                > dbIdAndChildren :
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
                    for(
                        Map.Entry<String, Map<String, IdAndChildren<String>>> tableOrViewEntry :
                        schemaIdAndChildren.getChildrenByName().entrySet()
                    ) {
                        TableOrView tableOrView = TableOrView.valueOf(tableOrViewEntry.getKey());
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
                        for(IdAndChildren<String> tableOrViewIdAndChildren : tableOrViewEntry.getValue().values()) {
                            String tableId = tableOrViewIdAndChildren.id;
                            batchRow(
                                preparedStatement,
                                orgId,
                                schemaId,
                                tableId,
                                tableOrView.getSchemaChildLinkAssociation().association,
                                rowCount++,
                                localDateTime,
                                chronoUnit
                            );
                            for(String columnId : tableOrViewIdAndChildren.getChildrenByName().values()) {
                                batchRow(
                                    preparedStatement,
                                    orgId,
                                    tableId,
                                    columnId,
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
        logger.info("Processing link record: " + rowCount + "(" +
                localDateTime.until(LocalDateTime.now(), chronoUnit) + " " +
                chronoUnit.name().toLowerCase() + ").");
    }

    // This design assumes there are no duplicate database names within an organization.
    public void addDatabase(String dbName, String dbId) {
        Util.checkNullOrEmpty("dbName", dbName);
        Util.checkNullOrEmpty("dbId", dbId);
        if(!links.containsKey(dbName)) { links.put(dbName, new IdAndChildren<>(dbId)); }
    }

    public void addSchema(String dbName, String schemaName, String schemaId) {
        Util.checkNullOrEmpty("dbName", dbName);
        // Some schema info is redacted, such as the schema for People First (PF3) database in DMS.
        //Util.checkNullOrEmpty("schemaName", schemaName);
        Util.checkNullOrEmpty("schemaId", schemaId);
        if(!links.containsKey(dbName)) {
            throw new IllegalStateException("Attempting to add schema to database that does not exist.");
        }
        IdAndChildren<IdAndChildren<Map<String,IdAndChildren<String>>>> dbIdAndChildren = links.get(dbName);
        if(dbIdAndChildren.doesNotContainChild(schemaName)) {
            dbIdAndChildren.addChild(schemaName, new IdAndChildren<>(schemaId));
        }
    }

    public void addTableOrView(
        TableOrView tableOrView,
        String dbName,
        String schemaName,
        String tableOrViewName,
        String tableOrViewId
    ) {
        Util.checkNullOrEmpty("dbName", dbName);
        // Some schema info is redacted, such as the schema for People First (PF3) database in DMS.
        //Util.checkNullOrEmpty("schemaName", schemaName);
        Util.checkNullOrEmpty("tableOrViewName", tableOrViewName);
        Util.checkNullOrEmpty("tableOrViewId", tableOrViewId);
        if(!links.containsKey(dbName)) {
            throw new IllegalStateException("Attempting to add " + tableOrView.name() + " '"+ tableOrViewName +
                    "' to schema '"+ schemaName + "' but schema's database '" + dbName + "' does not exist.");
        }
        IdAndChildren<IdAndChildren<Map<String,IdAndChildren<String>>>> dbIdAndChildren = links.get(dbName);
        if(dbIdAndChildren.doesNotContainChild(schemaName)) {
            throw new IllegalStateException("Attempting to add " + tableOrView.name() + " '"+ tableOrViewName +
                    "' to schema '"+ schemaName + "', which does not exist in database '"+ dbName + "'.");
        }
        IdAndChildren<Map<String,IdAndChildren<String>>> schemaIdAndChildren = dbIdAndChildren.getChild(schemaName);
        Map<String, IdAndChildren<String>> tablesOrViews;
        if(schemaIdAndChildren.doesNotContainChild(tableOrView.name())) {
            tablesOrViews = new HashMap<>();
            schemaIdAndChildren.addChild(tableOrView.name(), tablesOrViews);
        }
        else {
            tablesOrViews = schemaIdAndChildren.getChild(tableOrView.name());
        }
        tablesOrViews.put(tableOrViewName, new IdAndChildren<>(tableOrViewId));
    }

    public void addColumnOrViewColumn(
        TableOrView tableOrView,
        String dbName,
        String schemaName,
        String tableOrViewName,
        String columnOrViewColumnName,
        String columnId
    ) {
        Util.checkNullOrEmpty("dbName", dbName);
        // Some schema info is redacted, such as the schema for People First (PF3) database in DMS.
        //Util.checkNullOrEmpty("schemaName", schemaName);
        Util.checkNullOrEmpty("tableOrViewName", tableOrViewName);
        Util.checkNullOrEmpty("columnOrViewColumnName", columnOrViewColumnName);
        Util.checkNullOrEmpty("columnId", columnId);
        if(!links.containsKey(dbName)) {
            throw new IllegalStateException("Attempting to add "+ tableOrView.getColumnLabel() + " '"+
                columnOrViewColumnName + "' to table '" + tableOrViewName + "' in schema '"+ schemaName +
                    "' but database '" + dbName + "' does not exist.");
        }
        IdAndChildren<IdAndChildren<Map<String,IdAndChildren<String>>>> dbIdAndChildren = links.get(dbName);
        if(dbIdAndChildren.doesNotContainChild(schemaName)) {
            throw new IllegalStateException("Attempting to add "+ tableOrView.getColumnLabel() + " '"+
                columnOrViewColumnName + "' to table '" + tableOrViewName + "' in schema '"+ schemaName +
                    "' and in database '" + dbName + "' but schema does not exist.");
        }
        IdAndChildren<Map<String,IdAndChildren<String>>> schemaIdAndChildren = dbIdAndChildren.getChild(schemaName);
        if(schemaIdAndChildren.doesNotContainChild(tableOrView.name())) {
            throw new IllegalStateException("Attempting to add "+ tableOrView.getColumnLabel() + " '"+
                columnOrViewColumnName + "' to table '" + tableOrViewName + "' in schema '"+ schemaName +
                    "' and in database '" + dbName + "' but the " + tableOrView.name() + " filter does not exist.");
        }
        Map<String, IdAndChildren<String>> tablesOrViews = schemaIdAndChildren.getChild(tableOrView.name());
        IdAndChildren<String> tableIdAndChildren = tablesOrViews.get(tableOrViewName);
        if(tableIdAndChildren.doesNotContainChild(columnOrViewColumnName)) {
            tableIdAndChildren.addChild(columnOrViewColumnName, columnId);
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

        private void addChild(String name, X child) { childrenByName.put(name, child); }
        private boolean doesNotContainChild(String name) { return !childrenByName.containsKey(name); }
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
