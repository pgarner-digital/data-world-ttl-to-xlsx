                        -- The following comments indicate that it was already done, no need to do it again
-- create or replace role dataworldanalyst;
grant usage on database data_world_metadata to role dataworldanalyst;
grant usage on schema data_world_metadata.public to role dataworldanalyst;
grant usage on warehouse compute_wh to role dataworldanalyst;
create or replace table "DATA_WORLD_METADATA"."PUBLIC"."DDW2INFA_DATABASE"
(
    "org" text,
    "core.externalId" text,
    "core.name" text,
    "core.description" text,
    "core.assignable" text,
    "core.businessDescription" text,
    "core.businessName" text,
    "core.reference" text,
    "custom.data.world.owner" text,
    "custom.data.world.jdbcURL" text,
    "custom.data.world.databaseServer" text,
    "custom.data.world.databasePort" text
);
create or replace table  "DATA_WORLD_METADATA"."PUBLIC"."DDW2INFA_SCHEMA"
(
    "org" text,
    "core.externalId" text,
    "core.name" text,
    "core.description" text,
    "core.assignable" text,
    "core.businessDescription" text,
    "core.businessName" text,
    "core.reference" text,
    "custom.data.world.owner" text
);
create or replace table  "DATA_WORLD_METADATA"."PUBLIC"."DDW2INFA_TABLE"
(
    "org" text,
    "core.externalId" text,
    "core.name" text,
    "core.description" text,
    "custom.data.world.owner" text,
    "custom.data.world.typePrefix" text,
    "custom.data.world.tableType" text,
    "custom.data.world.businessSummary" text,
    "custom.data.world.restrictedToPublic" text,
    "custom.data.world.sensitiveData" text,
    "custom.data.world.dataSharingAgreement" text,
    "custom.data.world.programOffice" text,
    "custom.data.world.dataSteward" text,
    "custom.data.world.technicalSteward" text,
    "custom.data.world.contactEmail" text,
    "custom.data.world.status" text,
    "core.businessDescription" text,
    "core.businessName" text,
    "core.reference" text
);
create or replace table  "DATA_WORLD_METADATA"."PUBLIC"."DDW2INFA_COLUMN"
(
    "org" text,
    "core.externalId" text,
    "core.name" text,
    "core.description" text,
    "custom.data.world.businessSummary" text,
    "custom.data.world.iri" text,
    "custom.data.world.columnTypeName" text,
    "custom.data.world.owner" text,
    "custom.data.world.dataSteward" text,
    "custom.data.world.restrictedToPublic" text,
    "custom.data.world.sensitiveData" text,
    "custom.data.world.status" text,
    "custom.data.world.technicalSteward" text,
    "custom.data.world.typePrefix" text,
    "core.businessDescription" text,
    "core.businessName" text,
    "core.reference" text
);
create or replace table "DATA_WORLD_METADATA"."PUBLIC"."DDW2INFA_LINK"
(
    org text,
    source text,
    target text,
    association text
);
grant UPDATE on table DDW2INFA_DATABASE to role dataworldanalyst;
grant UPDATE on table DDW2INFA_SCHEMA to role dataworldanalyst;
grant UPDATE on table DDW2INFA_TABLE to role dataworldanalyst;
grant UPDATE on table DDW2INFA_COLUMN to role dataworldanalyst;
grant UPDATE on table DDW2INFA_LINK to role dataworldanalyst;
grant SELECT on table DDW2INFA_DATABASE to role dataworldanalyst;
grant SELECT on table DDW2INFA_SCHEMA to role dataworldanalyst;
grant SELECT on table DDW2INFA_TABLE to role dataworldanalyst;
grant SELECT on table DDW2INFA_COLUMN to role dataworldanalyst;
grant SELECT on table DDW2INFA_LINK to role dataworldanalyst;
grant INSERT on table DDW2INFA_DATABASE to role dataworldanalyst;
grant INSERT on table DDW2INFA_SCHEMA to role dataworldanalyst;
grant INSERT on table DDW2INFA_TABLE to role dataworldanalyst;
grant INSERT on table DDW2INFA_COLUMN to role dataworldanalyst;
grant INSERT on table DDW2INFA_LINK to role dataworldanalyst;
grant TRUNCATE on table DDW2INFA_DATABASE to role dataworldanalyst;
grant TRUNCATE on table DDW2INFA_SCHEMA to role dataworldanalyst;
grant TRUNCATE on table DDW2INFA_TABLE to role dataworldanalyst;
grant TRUNCATE on table DDW2INFA_COLUMN to role dataworldanalyst;
grant TRUNCATE on table DDW2INFA_LINK to role dataworldanalyst;
create or replace stage dw2infametamodel_stage directory = (enable = true) encryption = (type = 'snowflake_sse');
-- Regarding internal stages:
--   1. READ permission must come before WRITE
--   2. Also, operating on a stage also requires the USAGE privilege on the parent database and schema (I did this already, see above)
--   See https://docs.snowflake.com/en/user-guide/security-access-control-privileges.html#stage-privileges
grant READ on stage dw2infametamodel_stage to role dataworldanalyst;
grant WRITE on stage dw2infametamodel_stage to role dataworldanalyst;
-- The following comment indicates that role was already granted, no need to do it again
-- grant role dataworldanalyst to user DATAMGTSVC;
show grants to user DATAMGTSVC;
show grants to role dataworldanalyst;
use database data_world_metadata;
use schema data_world_metadata.public;
ls @dw2infametamodel_stage;

----------------------------------------------------------------------------------------------
-- After setting up database objects, use PUT command to move files to named internal stage.
-- The following commands are executed remotely using a non-SSO-validated user account.
----------------------------------------------------------------------------------------------
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\AHCA\informatica_import\custom.data.world.ColumnName.csv @dw2infametamodel_stage/AHCA;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\APD\informatica_import\custom.data.world.ColumnName.csv @dw2infametamodel_stage/APD;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\BOG\informatica_import\custom.data.world.ColumnName.csv @dw2infametamodel_stage/BOG;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DBPR\informatica_import\custom.data.world.ColumnName.csv @dw2infametamodel_stage/DBPR;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DBS\informatica_import\custom.data.world.ColumnName.csv @dw2infametamodel_stage/DBS;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DCF\informatica_import\custom.data.world.ColumnName.csv @dw2infametamodel_stage/DCF;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DEO\informatica_import\custom.data.world.ColumnName.csv @dw2infametamodel_stage/DEO;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DHSMV\informatica_import\custom.data.world.ColumnName.csv @dw2infametamodel_stage/DHSMV;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DMS\informatica_import\custom.data.world.ColumnName.csv @dw2infametamodel_stage/DMS;
--PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOE\informatica_import\custom.data.world.ColumnName.csv @dw2infametamodel_stage/DOE;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOEA\informatica_import\custom.data.world.ColumnName.csv @dw2infametamodel_stage/DOEA;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOH\informatica_import\custom.data.world.ColumnName.csv @dw2infametamodel_stage/DOH;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOL\informatica_import\custom.data.world.ColumnName.csv @dw2infametamodel_stage/DOL;
--PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOR\informatica_import\custom.data.world.ColumnName.csv @dw2infametamodel_stage/DOR;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOT\informatica_import\custom.data.world.ColumnName.csv @dw2infametamodel_stage/DOT;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\VR\informatica_import\custom.data.world.ColumnName.csv @dw2infametamodel_stage/VR;

PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\AHCA\informatica_import\custom.data.world.TableName.csv @dw2infametamodel_stage/AHCA;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\APD\informatica_import\custom.data.world.TableName.csv @dw2infametamodel_stage/APD;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\BOG\informatica_import\custom.data.world.TableName.csv @dw2infametamodel_stage/BOG;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DBPR\informatica_import\custom.data.world.TableName.csv @dw2infametamodel_stage/DBPR;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DBS\informatica_import\custom.data.world.TableName.csv @dw2infametamodel_stage/DBS;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DCF\informatica_import\custom.data.world.TableName.csv @dw2infametamodel_stage/DCF;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DEO\informatica_import\custom.data.world.TableName.csv @dw2infametamodel_stage/DEO;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DHSMV\informatica_import\custom.data.world.TableName.csv @dw2infametamodel_stage/DHSMV;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DMS\informatica_import\custom.data.world.TableName.csv @dw2infametamodel_stage/DMS;
--PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOE\informatica_import\custom.data.world.TableName.csv @dw2infametamodel_stage/DOE;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOEA\informatica_import\custom.data.world.TableName.csv @dw2infametamodel_stage/DOEA;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOH\informatica_import\custom.data.world.TableName.csv @dw2infametamodel_stage/DOH;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOL\informatica_import\custom.data.world.TableName.csv @dw2infametamodel_stage/DOL;
--PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOR\informatica_import\custom.data.world.TableName.csv @dw2infametamodel_stage/DOR;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOT\informatica_import\custom.data.world.TableName.csv @dw2infametamodel_stage/DOT;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\VR\informatica_import\custom.data.world.TableName.csv @dw2infametamodel_stage/VR;

PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\AHCA\informatica_import\custom.data.world.SchemaName.csv @dw2infametamodel_stage/AHCA;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\APD\informatica_import\custom.data.world.SchemaName.csv @dw2infametamodel_stage/APD;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\BOG\informatica_import\custom.data.world.SchemaName.csv @dw2infametamodel_stage/BOG;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DBPR\informatica_import\custom.data.world.SchemaName.csv @dw2infametamodel_stage/DBPR;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DBS\informatica_import\custom.data.world.SchemaName.csv @dw2infametamodel_stage/DBS;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DCF\informatica_import\custom.data.world.SchemaName.csv @dw2infametamodel_stage/DCF;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DEO\informatica_import\custom.data.world.SchemaName.csv @dw2infametamodel_stage/DEO;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DHSMV\informatica_import\custom.data.world.SchemaName.csv @dw2infametamodel_stage/DHSMV;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DMS\informatica_import\custom.data.world.SchemaName.csv @dw2infametamodel_stage/DMS;
--PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOE\informatica_import\custom.data.world.SchemaName.csv @dw2infametamodel_stage/DOE;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOEA\informatica_import\custom.data.world.SchemaName.csv @dw2infametamodel_stage/DOEA;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOH\informatica_import\custom.data.world.SchemaName.csv @dw2infametamodel_stage/DOH;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOL\informatica_import\custom.data.world.SchemaName.csv @dw2infametamodel_stage/DOL;
--PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOR\informatica_import\custom.data.world.SchemaName.csv @dw2infametamodel_stage/DOR;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOT\informatica_import\custom.data.world.SchemaName.csv @dw2infametamodel_stage/DOT;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\VR\informatica_import\custom.data.world.SchemaName.csv @dw2infametamodel_stage/VR;

PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\AHCA\informatica_import\custom.data.world.DatabaseName.csv @dw2infametamodel_stage/AHCA;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\APD\informatica_import\custom.data.world.DatabaseName.csv @dw2infametamodel_stage/APD;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\BOG\informatica_import\custom.data.world.DatabaseName.csv @dw2infametamodel_stage/BOG;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DBPR\informatica_import\custom.data.world.DatabaseName.csv @dw2infametamodel_stage/DBPR;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DBS\informatica_import\custom.data.world.DatabaseName.csv @dw2infametamodel_stage/DBS;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DCF\informatica_import\custom.data.world.DatabaseName.csv @dw2infametamodel_stage/DCF;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DEO\informatica_import\custom.data.world.DatabaseName.csv @dw2infametamodel_stage/DEO;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DHSMV\informatica_import\custom.data.world.DatabaseName.csv @dw2infametamodel_stage/DHSMV;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DMS\informatica_import\custom.data.world.DatabaseName.csv @dw2infametamodel_stage/DMS;
--PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOE\informatica_import\custom.data.world.DatabaseName.csv @dw2infametamodel_stage/DOE;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOEA\informatica_import\custom.data.world.DatabaseName.csv @dw2infametamodel_stage/DOEA;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOH\informatica_import\custom.data.world.DatabaseName.csv @dw2infametamodel_stage/DOH;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOL\informatica_import\custom.data.world.DatabaseName.csv @dw2infametamodel_stage/DOL;
--PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOR\informatica_import\custom.data.world.DatabaseName.csv @dw2infametamodel_stage/DOR;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOT\informatica_import\custom.data.world.DatabaseName.csv @dw2infametamodel_stage/DOT;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\VR\informatica_import\custom.data.world.DatabaseName.csv @dw2infametamodel_stage/VR;

PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\AHCA\informatica_import\links.csv @dw2infametamodel_stage/AHCA;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\APD\informatica_import\links.csv @dw2infametamodel_stage/APD;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\BOG\informatica_import\links.csv @dw2infametamodel_stage/BOG;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DBPR\informatica_import\links.csv @dw2infametamodel_stage/DBPR;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DBS\informatica_import\links.csv @dw2infametamodel_stage/DBS;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DCF\informatica_import\links.csv @dw2infametamodel_stage/DCF;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DEO\informatica_import\links.csv @dw2infametamodel_stage/DEO;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DHSMV\informatica_import\links.csv @dw2infametamodel_stage/DHSMV;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DMS\informatica_import\links.csv @dw2infametamodel_stage/DMS;
--PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOE\informatica_import\links.csv @dw2infametamodel_stage/DOE;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOEA\informatica_import\links.csv @dw2infametamodel_stage/DOEA;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOH\informatica_import\links.csv @dw2infametamodel_stage/DOH;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOL\informatica_import\links.csv @dw2infametamodel_stage/DOL;
--PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOR\informatica_import\links.csv @dw2infametamodel_stage/DOR;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOT\informatica_import\links.csv @dw2infametamodel_stage/DOT;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\VR\informatica_import\links.csv @dw2infametamodel_stage/VR;

COPY INTO DDW2INFA_COLUMN("org", "core.externalId", "core.name", "core.description", "custom.data.world.businessSummary", "custom.data.world.iri", "custom.data.world.columnTypeName", "custom.data.world.owner", "custom.data.world.dataSteward", "custom.data.world.restrictedToPublic", "custom.data.world.sensitiveData", "custom.data.world.status", "custom.data.world.technicalSteward", "custom.data.world.typePrefix", "core.businessDescription", "core.businessName", "core.reference")
    FROM (SELECT 'AHCA' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16 from @dw2infametamodel_stage/AHCA/custom.data.world.ColumnName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_COLUMN("org", "core.externalId", "core.name", "core.description", "custom.data.world.businessSummary", "custom.data.world.iri", "custom.data.world.columnTypeName", "custom.data.world.owner", "custom.data.world.dataSteward", "custom.data.world.restrictedToPublic", "custom.data.world.sensitiveData", "custom.data.world.status", "custom.data.world.technicalSteward", "custom.data.world.typePrefix", "core.businessDescription", "core.businessName", "core.reference")
    FROM (SELECT 'APD' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16 from @dw2infametamodel_stage/APD/custom.data.world.ColumnName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_COLUMN("org", "core.externalId", "core.name", "core.description", "custom.data.world.businessSummary", "custom.data.world.iri", "custom.data.world.columnTypeName", "custom.data.world.owner", "custom.data.world.dataSteward", "custom.data.world.restrictedToPublic", "custom.data.world.sensitiveData", "custom.data.world.status", "custom.data.world.technicalSteward", "custom.data.world.typePrefix", "core.businessDescription", "core.businessName", "core.reference")
    FROM (SELECT 'BOG' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16 from @dw2infametamodel_stage/BOG/custom.data.world.ColumnName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_COLUMN("org", "core.externalId", "core.name", "core.description", "custom.data.world.businessSummary", "custom.data.world.iri", "custom.data.world.columnTypeName", "custom.data.world.owner", "custom.data.world.dataSteward", "custom.data.world.restrictedToPublic", "custom.data.world.sensitiveData", "custom.data.world.status", "custom.data.world.technicalSteward", "custom.data.world.typePrefix", "core.businessDescription", "core.businessName", "core.reference")
    FROM (SELECT 'DBPR' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16 from @dw2infametamodel_stage/DBPR/custom.data.world.ColumnName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_COLUMN("org", "core.externalId", "core.name", "core.description", "custom.data.world.businessSummary", "custom.data.world.iri", "custom.data.world.columnTypeName", "custom.data.world.owner", "custom.data.world.dataSteward", "custom.data.world.restrictedToPublic", "custom.data.world.sensitiveData", "custom.data.world.status", "custom.data.world.technicalSteward", "custom.data.world.typePrefix", "core.businessDescription", "core.businessName", "core.reference")
    FROM (SELECT 'DBS' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16 from @dw2infametamodel_stage/DBS/custom.data.world.ColumnName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_COLUMN("org", "core.externalId", "core.name", "core.description", "custom.data.world.businessSummary", "custom.data.world.iri", "custom.data.world.columnTypeName", "custom.data.world.owner", "custom.data.world.dataSteward", "custom.data.world.restrictedToPublic", "custom.data.world.sensitiveData", "custom.data.world.status", "custom.data.world.technicalSteward", "custom.data.world.typePrefix", "core.businessDescription", "core.businessName", "core.reference")
    FROM (SELECT 'DCF' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16 from @dw2infametamodel_stage/DCF/custom.data.world.ColumnName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_COLUMN("org", "core.externalId", "core.name", "core.description", "custom.data.world.businessSummary", "custom.data.world.iri", "custom.data.world.columnTypeName", "custom.data.world.owner", "custom.data.world.dataSteward", "custom.data.world.restrictedToPublic", "custom.data.world.sensitiveData", "custom.data.world.status", "custom.data.world.technicalSteward", "custom.data.world.typePrefix", "core.businessDescription", "core.businessName", "core.reference")
    FROM (SELECT 'DEO' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16 from @dw2infametamodel_stage/DEO/custom.data.world.ColumnName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_COLUMN("org", "core.externalId", "core.name", "core.description", "custom.data.world.businessSummary", "custom.data.world.iri", "custom.data.world.columnTypeName", "custom.data.world.owner", "custom.data.world.dataSteward", "custom.data.world.restrictedToPublic", "custom.data.world.sensitiveData", "custom.data.world.status", "custom.data.world.technicalSteward", "custom.data.world.typePrefix", "core.businessDescription", "core.businessName", "core.reference")
    FROM (SELECT 'DHSMV' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16 from @dw2infametamodel_stage/DHSMV/custom.data.world.ColumnName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_COLUMN("org", "core.externalId", "core.name", "core.description", "custom.data.world.businessSummary", "custom.data.world.iri", "custom.data.world.columnTypeName", "custom.data.world.owner", "custom.data.world.dataSteward", "custom.data.world.restrictedToPublic", "custom.data.world.sensitiveData", "custom.data.world.status", "custom.data.world.technicalSteward", "custom.data.world.typePrefix", "core.businessDescription", "core.businessName", "core.reference")
    FROM (SELECT 'DMS' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16 from @dw2infametamodel_stage/DMS/custom.data.world.ColumnName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
-- COPY INTO DDW2INFA_COLUMN("org", "core.externalId", "core.name", "core.description", "custom.data.world.businessSummary", "custom.data.world.iri", "custom.data.world.columnTypeName", "custom.data.world.owner", "custom.data.world.dataSteward", "custom.data.world.restrictedToPublic", "custom.data.world.sensitiveData", "custom.data.world.status", "custom.data.world.technicalSteward", "custom.data.world.typePrefix", "core.businessDescription", "core.businessName", "core.reference")
--     FROM (SELECT 'DOE' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16 from @dw2infametamodel_stage/DOE/custom.data.world.ColumnName.csv.gz t)
--     FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
--     ON_ERROR = 'ABORT_STATEMENT'
--     PURGE = FALSE;
COPY INTO DDW2INFA_COLUMN("org", "core.externalId", "core.name", "core.description", "custom.data.world.businessSummary", "custom.data.world.iri", "custom.data.world.columnTypeName", "custom.data.world.owner", "custom.data.world.dataSteward", "custom.data.world.restrictedToPublic", "custom.data.world.sensitiveData", "custom.data.world.status", "custom.data.world.technicalSteward", "custom.data.world.typePrefix", "core.businessDescription", "core.businessName", "core.reference")
    FROM (SELECT 'DOEA' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16 from @dw2infametamodel_stage/DOEA/custom.data.world.ColumnName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_COLUMN("org", "core.externalId", "core.name", "core.description", "custom.data.world.businessSummary", "custom.data.world.iri", "custom.data.world.columnTypeName", "custom.data.world.owner", "custom.data.world.dataSteward", "custom.data.world.restrictedToPublic", "custom.data.world.sensitiveData", "custom.data.world.status", "custom.data.world.technicalSteward", "custom.data.world.typePrefix", "core.businessDescription", "core.businessName", "core.reference")
    FROM (SELECT 'DOH' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16 from @dw2infametamodel_stage/DOH/custom.data.world.ColumnName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_COLUMN("org", "core.externalId", "core.name", "core.description", "custom.data.world.businessSummary", "custom.data.world.iri", "custom.data.world.columnTypeName", "custom.data.world.owner", "custom.data.world.dataSteward", "custom.data.world.restrictedToPublic", "custom.data.world.sensitiveData", "custom.data.world.status", "custom.data.world.technicalSteward", "custom.data.world.typePrefix", "core.businessDescription", "core.businessName", "core.reference")
    FROM (SELECT 'DOL' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16 from @dw2infametamodel_stage/DOL/custom.data.world.ColumnName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
-- COPY INTO DDW2INFA_COLUMN("org", "core.externalId", "core.name", "core.description", "custom.data.world.businessSummary", "custom.data.world.iri", "custom.data.world.columnTypeName", "custom.data.world.owner", "custom.data.world.dataSteward", "custom.data.world.restrictedToPublic", "custom.data.world.sensitiveData", "custom.data.world.status", "custom.data.world.technicalSteward", "custom.data.world.typePrefix", "core.businessDescription", "core.businessName", "core.reference")
--     FROM (SELECT 'DOR' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16 from @dw2infametamodel_stage/DOR/custom.data.world.ColumnName.csv.gz t)
--     FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
--     ON_ERROR = 'ABORT_STATEMENT'
--     PURGE = FALSE;
COPY INTO DDW2INFA_COLUMN("org", "core.externalId", "core.name", "core.description", "custom.data.world.businessSummary", "custom.data.world.iri", "custom.data.world.columnTypeName", "custom.data.world.owner", "custom.data.world.dataSteward", "custom.data.world.restrictedToPublic", "custom.data.world.sensitiveData", "custom.data.world.status", "custom.data.world.technicalSteward", "custom.data.world.typePrefix", "core.businessDescription", "core.businessName", "core.reference")
    FROM (SELECT 'DOT' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16 from @dw2infametamodel_stage/DOT/custom.data.world.ColumnName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_COLUMN("org", "core.externalId", "core.name", "core.description", "custom.data.world.businessSummary", "custom.data.world.iri", "custom.data.world.columnTypeName", "custom.data.world.owner", "custom.data.world.dataSteward", "custom.data.world.restrictedToPublic", "custom.data.world.sensitiveData", "custom.data.world.status", "custom.data.world.technicalSteward", "custom.data.world.typePrefix", "core.businessDescription", "core.businessName", "core.reference")
    FROM (SELECT 'VR' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16 from @dw2infametamodel_stage/VR/custom.data.world.ColumnName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;

COPY INTO DDW2INFA_TABLE("org", "core.externalId", "core.name", "core.description", "custom.data.world.owner", "custom.data.world.typePrefix", "custom.data.world.tableType", "custom.data.world.businessSummary", "custom.data.world.restrictedToPublic", "custom.data.world.sensitiveData", "custom.data.world.dataSharingAgreement", "custom.data.world.programOffice", "custom.data.world.dataSteward", "custom.data.world.technicalSteward", "custom.data.world.contactEmail", "custom.data.world.status", "core.businessDescription", "core.businessName", "core.reference")
    FROM (SELECT 'AHCA' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16, t.$17, t.$18 from @dw2infametamodel_stage/AHCA/custom.data.world.TableName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_TABLE("org", "core.externalId", "core.name", "core.description", "custom.data.world.owner", "custom.data.world.typePrefix", "custom.data.world.tableType", "custom.data.world.businessSummary", "custom.data.world.restrictedToPublic", "custom.data.world.sensitiveData", "custom.data.world.dataSharingAgreement", "custom.data.world.programOffice", "custom.data.world.dataSteward", "custom.data.world.technicalSteward", "custom.data.world.contactEmail", "custom.data.world.status", "core.businessDescription", "core.businessName", "core.reference")
    FROM (SELECT 'APD' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16, t.$17, t.$18 from @dw2infametamodel_stage/APD/custom.data.world.TableName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_TABLE("org", "core.externalId", "core.name", "core.description", "custom.data.world.owner", "custom.data.world.typePrefix", "custom.data.world.tableType", "custom.data.world.businessSummary", "custom.data.world.restrictedToPublic", "custom.data.world.sensitiveData", "custom.data.world.dataSharingAgreement", "custom.data.world.programOffice", "custom.data.world.dataSteward", "custom.data.world.technicalSteward", "custom.data.world.contactEmail", "custom.data.world.status", "core.businessDescription", "core.businessName", "core.reference")
    FROM (SELECT 'BOG' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16, t.$17, t.$18 from @dw2infametamodel_stage/BOG/custom.data.world.TableName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_TABLE("org", "core.externalId", "core.name", "core.description", "custom.data.world.owner", "custom.data.world.typePrefix", "custom.data.world.tableType", "custom.data.world.businessSummary", "custom.data.world.restrictedToPublic", "custom.data.world.sensitiveData", "custom.data.world.dataSharingAgreement", "custom.data.world.programOffice", "custom.data.world.dataSteward", "custom.data.world.technicalSteward", "custom.data.world.contactEmail", "custom.data.world.status", "core.businessDescription", "core.businessName", "core.reference")
    FROM (SELECT 'DBPR' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16, t.$17, t.$18 from @dw2infametamodel_stage/DBPR/custom.data.world.TableName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_TABLE("org", "core.externalId", "core.name", "core.description", "custom.data.world.owner", "custom.data.world.typePrefix", "custom.data.world.tableType", "custom.data.world.businessSummary", "custom.data.world.restrictedToPublic", "custom.data.world.sensitiveData", "custom.data.world.dataSharingAgreement", "custom.data.world.programOffice", "custom.data.world.dataSteward", "custom.data.world.technicalSteward", "custom.data.world.contactEmail", "custom.data.world.status", "core.businessDescription", "core.businessName", "core.reference")
    FROM (SELECT 'DBS' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16, t.$17, t.$18 from @dw2infametamodel_stage/DBS/custom.data.world.TableName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_TABLE("org", "core.externalId", "core.name", "core.description", "custom.data.world.owner", "custom.data.world.typePrefix", "custom.data.world.tableType", "custom.data.world.businessSummary", "custom.data.world.restrictedToPublic", "custom.data.world.sensitiveData", "custom.data.world.dataSharingAgreement", "custom.data.world.programOffice", "custom.data.world.dataSteward", "custom.data.world.technicalSteward", "custom.data.world.contactEmail", "custom.data.world.status", "core.businessDescription", "core.businessName", "core.reference")
    FROM (SELECT 'DCF' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16, t.$17, t.$18 from @dw2infametamodel_stage/DCF/custom.data.world.TableName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_TABLE("org", "core.externalId", "core.name", "core.description", "custom.data.world.owner", "custom.data.world.typePrefix", "custom.data.world.tableType", "custom.data.world.businessSummary", "custom.data.world.restrictedToPublic", "custom.data.world.sensitiveData", "custom.data.world.dataSharingAgreement", "custom.data.world.programOffice", "custom.data.world.dataSteward", "custom.data.world.technicalSteward", "custom.data.world.contactEmail", "custom.data.world.status", "core.businessDescription", "core.businessName", "core.reference")
    FROM (SELECT 'DEO' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16, t.$17, t.$18 from @dw2infametamodel_stage/DEO/custom.data.world.TableName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_TABLE("org", "core.externalId", "core.name", "core.description", "custom.data.world.owner", "custom.data.world.typePrefix", "custom.data.world.tableType", "custom.data.world.businessSummary", "custom.data.world.restrictedToPublic", "custom.data.world.sensitiveData", "custom.data.world.dataSharingAgreement", "custom.data.world.programOffice", "custom.data.world.dataSteward", "custom.data.world.technicalSteward", "custom.data.world.contactEmail", "custom.data.world.status", "core.businessDescription", "core.businessName", "core.reference")
    FROM (SELECT 'DHSMV' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16, t.$17, t.$18 from @dw2infametamodel_stage/DHSMV/custom.data.world.TableName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_TABLE("org", "core.externalId", "core.name", "core.description", "custom.data.world.owner", "custom.data.world.typePrefix", "custom.data.world.tableType", "custom.data.world.businessSummary", "custom.data.world.restrictedToPublic", "custom.data.world.sensitiveData", "custom.data.world.dataSharingAgreement", "custom.data.world.programOffice", "custom.data.world.dataSteward", "custom.data.world.technicalSteward", "custom.data.world.contactEmail", "custom.data.world.status", "core.businessDescription", "core.businessName", "core.reference")
    FROM (SELECT 'DMS' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16, t.$17, t.$18 from @dw2infametamodel_stage/DMS/custom.data.world.TableName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
-- COPY INTO DDW2INFA_TABLE("org", "core.externalId", "core.name", "core.description", "custom.data.world.owner", "custom.data.world.typePrefix", "custom.data.world.tableType", "custom.data.world.businessSummary", "custom.data.world.restrictedToPublic", "custom.data.world.sensitiveData", "custom.data.world.dataSharingAgreement", "custom.data.world.programOffice", "custom.data.world.dataSteward", "custom.data.world.technicalSteward", "custom.data.world.contactEmail", "custom.data.world.status", "core.businessDescription", "core.businessName", "core.reference")
--     FROM (SELECT 'DOE' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16, t.$17, t.$18 from @dw2infametamodel_stage/DOE/custom.data.world.TableName.csv.gz t)
--     FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
--     ON_ERROR = 'ABORT_STATEMENT'
--     PURGE = FALSE;
COPY INTO DDW2INFA_TABLE("org", "core.externalId", "core.name", "core.description", "custom.data.world.owner", "custom.data.world.typePrefix", "custom.data.world.tableType", "custom.data.world.businessSummary", "custom.data.world.restrictedToPublic", "custom.data.world.sensitiveData", "custom.data.world.dataSharingAgreement", "custom.data.world.programOffice", "custom.data.world.dataSteward", "custom.data.world.technicalSteward", "custom.data.world.contactEmail", "custom.data.world.status", "core.businessDescription", "core.businessName", "core.reference")
    FROM (SELECT 'DOEA' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16, t.$17, t.$18 from @dw2infametamodel_stage/DOEA/custom.data.world.TableName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_TABLE("org", "core.externalId", "core.name", "core.description", "custom.data.world.owner", "custom.data.world.typePrefix", "custom.data.world.tableType", "custom.data.world.businessSummary", "custom.data.world.restrictedToPublic", "custom.data.world.sensitiveData", "custom.data.world.dataSharingAgreement", "custom.data.world.programOffice", "custom.data.world.dataSteward", "custom.data.world.technicalSteward", "custom.data.world.contactEmail", "custom.data.world.status", "core.businessDescription", "core.businessName", "core.reference")
    FROM (SELECT 'DOH' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16, t.$17, t.$18 from @dw2infametamodel_stage/DOH/custom.data.world.TableName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_TABLE("org", "core.externalId", "core.name", "core.description", "custom.data.world.owner", "custom.data.world.typePrefix", "custom.data.world.tableType", "custom.data.world.businessSummary", "custom.data.world.restrictedToPublic", "custom.data.world.sensitiveData", "custom.data.world.dataSharingAgreement", "custom.data.world.programOffice", "custom.data.world.dataSteward", "custom.data.world.technicalSteward", "custom.data.world.contactEmail", "custom.data.world.status", "core.businessDescription", "core.businessName", "core.reference")
    FROM (SELECT 'DOL' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16, t.$17, t.$18 from @dw2infametamodel_stage/DOL/custom.data.world.TableName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
-- COPY INTO DDW2INFA_TABLE("org", "core.externalId", "core.name", "core.description", "custom.data.world.owner", "custom.data.world.typePrefix", "custom.data.world.tableType", "custom.data.world.businessSummary", "custom.data.world.restrictedToPublic", "custom.data.world.sensitiveData", "custom.data.world.dataSharingAgreement", "custom.data.world.programOffice", "custom.data.world.dataSteward", "custom.data.world.technicalSteward", "custom.data.world.contactEmail", "custom.data.world.status", "core.businessDescription", "core.businessName", "core.reference")
--     FROM (SELECT 'DOR' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16, t.$17, t.$18 from @dw2infametamodel_stage/DOR/custom.data.world.TableName.csv.gz t)
--     FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
--     ON_ERROR = 'ABORT_STATEMENT'
--     PURGE = FALSE;
COPY INTO DDW2INFA_TABLE("org", "core.externalId", "core.name", "core.description", "custom.data.world.owner", "custom.data.world.typePrefix", "custom.data.world.tableType", "custom.data.world.businessSummary", "custom.data.world.restrictedToPublic", "custom.data.world.sensitiveData", "custom.data.world.dataSharingAgreement", "custom.data.world.programOffice", "custom.data.world.dataSteward", "custom.data.world.technicalSteward", "custom.data.world.contactEmail", "custom.data.world.status", "core.businessDescription", "core.businessName", "core.reference")
    FROM (SELECT 'DOT' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16, t.$17, t.$18 from @dw2infametamodel_stage/DOT/custom.data.world.TableName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_TABLE("org", "core.externalId", "core.name", "core.description", "custom.data.world.owner", "custom.data.world.typePrefix", "custom.data.world.tableType", "custom.data.world.businessSummary", "custom.data.world.restrictedToPublic", "custom.data.world.sensitiveData", "custom.data.world.dataSharingAgreement", "custom.data.world.programOffice", "custom.data.world.dataSteward", "custom.data.world.technicalSteward", "custom.data.world.contactEmail", "custom.data.world.status", "core.businessDescription", "core.businessName", "core.reference")
    FROM (SELECT 'VR' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16, t.$17, t.$18 from @dw2infametamodel_stage/VR/custom.data.world.TableName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;

COPY INTO DDW2INFA_DATABASE("org", "core.externalId", "core.name", "core.description", "core.assignable", "core.businessDescription", "core.businessName", "core.reference", "custom.data.world.owner", "custom.data.world.jdbcURL", "custom.data.world.databaseServer", "custom.data.world.databasePort")
    FROM (SELECT 'AHCA' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11 from @dw2infametamodel_stage/AHCA/custom.data.world.DatabaseName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_DATABASE("org", "core.externalId", "core.name", "core.description", "core.assignable", "core.businessDescription", "core.businessName", "core.reference", "custom.data.world.owner", "custom.data.world.jdbcURL", "custom.data.world.databaseServer", "custom.data.world.databasePort")
    FROM (SELECT 'APD' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11 from @dw2infametamodel_stage/APD/custom.data.world.DatabaseName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_DATABASE("org", "core.externalId", "core.name", "core.description", "core.assignable", "core.businessDescription", "core.businessName", "core.reference", "custom.data.world.owner", "custom.data.world.jdbcURL", "custom.data.world.databaseServer", "custom.data.world.databasePort")
    FROM (SELECT 'BOG' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11 from @dw2infametamodel_stage/BOG/custom.data.world.DatabaseName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_DATABASE("org", "core.externalId", "core.name", "core.description", "core.assignable", "core.businessDescription", "core.businessName", "core.reference", "custom.data.world.owner", "custom.data.world.jdbcURL", "custom.data.world.databaseServer", "custom.data.world.databasePort")
    FROM (SELECT 'DBPR' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11 from @dw2infametamodel_stage/DBPR/custom.data.world.DatabaseName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_DATABASE("org", "core.externalId", "core.name", "core.description", "core.assignable", "core.businessDescription", "core.businessName", "core.reference", "custom.data.world.owner", "custom.data.world.jdbcURL", "custom.data.world.databaseServer", "custom.data.world.databasePort")
    FROM (SELECT 'DBS' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11 from @dw2infametamodel_stage/DBS/custom.data.world.DatabaseName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_DATABASE("org", "core.externalId", "core.name", "core.description", "core.assignable", "core.businessDescription", "core.businessName", "core.reference", "custom.data.world.owner", "custom.data.world.jdbcURL", "custom.data.world.databaseServer", "custom.data.world.databasePort")
    FROM (SELECT 'DCF' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11 from @dw2infametamodel_stage/DCF/custom.data.world.DatabaseName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_DATABASE("org", "core.externalId", "core.name", "core.description", "core.assignable", "core.businessDescription", "core.businessName", "core.reference", "custom.data.world.owner", "custom.data.world.jdbcURL", "custom.data.world.databaseServer", "custom.data.world.databasePort")
    FROM (SELECT 'DEO' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11 from @dw2infametamodel_stage/DEO/custom.data.world.DatabaseName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_DATABASE("org", "core.externalId", "core.name", "core.description", "core.assignable", "core.businessDescription", "core.businessName", "core.reference", "custom.data.world.owner", "custom.data.world.jdbcURL", "custom.data.world.databaseServer", "custom.data.world.databasePort")
    FROM (SELECT 'DHSMV' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11 from @dw2infametamodel_stage/DHSMV/custom.data.world.DatabaseName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_DATABASE("org", "core.externalId", "core.name", "core.description", "core.assignable", "core.businessDescription", "core.businessName", "core.reference", "custom.data.world.owner", "custom.data.world.jdbcURL", "custom.data.world.databaseServer", "custom.data.world.databasePort")
    FROM (SELECT 'DMS' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11 from @dw2infametamodel_stage/DMS/custom.data.world.DatabaseName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
-- COPY INTO DDW2INFA_DATABASE("org", "core.externalId", "core.name", "core.description", "core.assignable", "core.businessDescription", "core.businessName", "core.reference", "custom.data.world.owner", "custom.data.world.jdbcURL", "custom.data.world.databaseServer", "custom.data.world.databasePort")
--     FROM (SELECT 'DOE' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11 from @dw2infametamodel_stage/DOE/custom.data.world.DatabaseName.csv.gz t)
--     FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
--     ON_ERROR = 'ABORT_STATEMENT'
--     PURGE = FALSE;
COPY INTO DDW2INFA_DATABASE("org", "core.externalId", "core.name", "core.description", "core.assignable", "core.businessDescription", "core.businessName", "core.reference", "custom.data.world.owner", "custom.data.world.jdbcURL", "custom.data.world.databaseServer", "custom.data.world.databasePort")
    FROM (SELECT 'DOEA' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11 from @dw2infametamodel_stage/DOEA/custom.data.world.DatabaseName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_DATABASE("org", "core.externalId", "core.name", "core.description", "core.assignable", "core.businessDescription", "core.businessName", "core.reference", "custom.data.world.owner", "custom.data.world.jdbcURL", "custom.data.world.databaseServer", "custom.data.world.databasePort")
    FROM (SELECT 'DOH' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11 from @dw2infametamodel_stage/DOH/custom.data.world.DatabaseName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_DATABASE("org", "core.externalId", "core.name", "core.description", "core.assignable", "core.businessDescription", "core.businessName", "core.reference", "custom.data.world.owner", "custom.data.world.jdbcURL", "custom.data.world.databaseServer", "custom.data.world.databasePort")
    FROM (SELECT 'DOL' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11 from @dw2infametamodel_stage/DOL/custom.data.world.DatabaseName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
-- COPY INTO DDW2INFA_DATABASE("org", "core.externalId", "core.name", "core.description", "core.assignable", "core.businessDescription", "core.businessName", "core.reference", "custom.data.world.owner", "custom.data.world.jdbcURL", "custom.data.world.databaseServer", "custom.data.world.databasePort")
--     FROM (SELECT 'DOR' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11 from @dw2infametamodel_stage/DOR/custom.data.world.DatabaseName.csv.gz t)
--     FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
--     ON_ERROR = 'ABORT_STATEMENT'
--     PURGE = FALSE;
COPY INTO DDW2INFA_DATABASE("org", "core.externalId", "core.name", "core.description", "core.assignable", "core.businessDescription", "core.businessName", "core.reference", "custom.data.world.owner", "custom.data.world.jdbcURL", "custom.data.world.databaseServer", "custom.data.world.databasePort")
    FROM (SELECT 'DOT' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11 from @dw2infametamodel_stage/DOT/custom.data.world.DatabaseName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_DATABASE("org", "core.externalId", "core.name", "core.description", "core.assignable", "core.businessDescription", "core.businessName", "core.reference", "custom.data.world.owner", "custom.data.world.jdbcURL", "custom.data.world.databaseServer", "custom.data.world.databasePort")
    FROM (SELECT 'VR' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11 from @dw2infametamodel_stage/VR/custom.data.world.DatabaseName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;

COPY INTO DDW2INFA_SCHEMA("org", "core.externalId", "core.name", "core.description", "core.assignable", "core.businessDescription", "core.businessName", "core.reference", "custom.data.world.owner")
    FROM (SELECT 'AHCA' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8 from @dw2infametamodel_stage/AHCA/custom.data.world.SchemaName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_SCHEMA("org", "core.externalId", "core.name", "core.description", "core.assignable", "core.businessDescription", "core.businessName", "core.reference", "custom.data.world.owner")
    FROM (SELECT 'APD' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8 from @dw2infametamodel_stage/APD/custom.data.world.SchemaName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_SCHEMA("org", "core.externalId", "core.name", "core.description", "core.assignable", "core.businessDescription", "core.businessName", "core.reference", "custom.data.world.owner")
    FROM (SELECT 'BOG' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8 from @dw2infametamodel_stage/BOG/custom.data.world.SchemaName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_SCHEMA("org", "core.externalId", "core.name", "core.description", "core.assignable", "core.businessDescription", "core.businessName", "core.reference", "custom.data.world.owner")
    FROM (SELECT 'DBPR' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8 from @dw2infametamodel_stage/DBPR/custom.data.world.SchemaName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_SCHEMA("org", "core.externalId", "core.name", "core.description", "core.assignable", "core.businessDescription", "core.businessName", "core.reference", "custom.data.world.owner")
    FROM (SELECT 'DBS' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8 from @dw2infametamodel_stage/DBS/custom.data.world.SchemaName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_SCHEMA("org", "core.externalId", "core.name", "core.description", "core.assignable", "core.businessDescription", "core.businessName", "core.reference", "custom.data.world.owner")
    FROM (SELECT 'DCF' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8 from @dw2infametamodel_stage/DCF/custom.data.world.SchemaName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_SCHEMA("org", "core.externalId", "core.name", "core.description", "core.assignable", "core.businessDescription", "core.businessName", "core.reference", "custom.data.world.owner")
    FROM (SELECT 'DEO' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8 from @dw2infametamodel_stage/DEO/custom.data.world.SchemaName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_SCHEMA("org", "core.externalId", "core.name", "core.description", "core.assignable", "core.businessDescription", "core.businessName", "core.reference", "custom.data.world.owner")
    FROM (SELECT 'DHSMV' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8 from @dw2infametamodel_stage/DHSMV/custom.data.world.SchemaName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_SCHEMA("org", "core.externalId", "core.name", "core.description", "core.assignable", "core.businessDescription", "core.businessName", "core.reference", "custom.data.world.owner")
    FROM (SELECT 'DMS' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8 from @dw2infametamodel_stage/DMS/custom.data.world.SchemaName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
-- COPY INTO DDW2INFA_SCHEMA("org", "core.externalId", "core.name", "core.description", "core.assignable", "core.businessDescription", "core.businessName", "core.reference", "custom.data.world.owner")
--     FROM (SELECT 'DOE' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8 from @dw2infametamodel_stage/DOE/custom.data.world.SchemaName.csv.gz t)
--     FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
--     ON_ERROR = 'ABORT_STATEMENT'
--     PURGE = FALSE;
COPY INTO DDW2INFA_SCHEMA("org", "core.externalId", "core.name", "core.description", "core.assignable", "core.businessDescription", "core.businessName", "core.reference", "custom.data.world.owner")
    FROM (SELECT 'DOEA' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8 from @dw2infametamodel_stage/DOEA/custom.data.world.SchemaName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_SCHEMA("org", "core.externalId", "core.name", "core.description", "core.assignable", "core.businessDescription", "core.businessName", "core.reference", "custom.data.world.owner")
    FROM (SELECT 'DOH' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8 from @dw2infametamodel_stage/DOH/custom.data.world.SchemaName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_SCHEMA("org", "core.externalId", "core.name", "core.description", "core.assignable", "core.businessDescription", "core.businessName", "core.reference", "custom.data.world.owner")
    FROM (SELECT 'DOL' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8 from @dw2infametamodel_stage/DOL/custom.data.world.SchemaName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
-- COPY INTO DDW2INFA_SCHEMA("org", "core.externalId", "core.name", "core.description", "core.assignable", "core.businessDescription", "core.businessName", "core.reference", "custom.data.world.owner")
--     FROM (SELECT 'DOR' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8 from @dw2infametamodel_stage/DOR/custom.data.world.SchemaName.csv.gz t)
--     FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
--     ON_ERROR = 'ABORT_STATEMENT'
--     PURGE = FALSE;
COPY INTO DDW2INFA_SCHEMA("org", "core.externalId", "core.name", "core.description", "core.assignable", "core.businessDescription", "core.businessName", "core.reference", "custom.data.world.owner")
    FROM (SELECT 'DOT' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8 from @dw2infametamodel_stage/DOT/custom.data.world.SchemaName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_SCHEMA("org", "core.externalId", "core.name", "core.description", "core.assignable", "core.businessDescription", "core.businessName", "core.reference", "custom.data.world.owner")
    FROM (SELECT 'VR' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8 from @dw2infametamodel_stage/VR/custom.data.world.SchemaName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;

COPY INTO DDW2INFA_LINK(org, source, target, association)
    FROM (SELECT 'AHCA' org, t.$1, t.$2, t.$3 from @dw2infametamodel_stage/AHCA/links.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_LINK(org, source, target, association)
    FROM (SELECT 'APD' org, t.$1, t.$2, t.$3 from @dw2infametamodel_stage/APD/links.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_LINK(org, source, target, association)
    FROM (SELECT 'BOG' org, t.$1, t.$2, t.$3 from @dw2infametamodel_stage/BOG/links.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_LINK(org, source, target, association)
    FROM (SELECT 'DBPR' org, t.$1, t.$2, t.$3 from @dw2infametamodel_stage/DBPR/links.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_LINK(org, source, target, association)
    FROM (SELECT 'DBS' org, t.$1, t.$2, t.$3 from @dw2infametamodel_stage/DBS/links.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_LINK(org, source, target, association)
    FROM (SELECT 'DCF' org, t.$1, t.$2, t.$3 from @dw2infametamodel_stage/DCF/links.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_LINK(org, source, target, association)
    FROM (SELECT 'DEO' org, t.$1, t.$2, t.$3 from @dw2infametamodel_stage/DEO/links.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_LINK(org, source, target, association)
    FROM (SELECT 'DHSMV' org, t.$1, t.$2, t.$3 from @dw2infametamodel_stage/DHSMV/links.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_LINK(org, source, target, association)
    FROM (SELECT 'DMS' org, t.$1, t.$2, t.$3 from @dw2infametamodel_stage/DMS/links.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
-- COPY INTO DDW2INFA_LINK(org, source, target, association)
--     FROM (SELECT 'DOE' org, t.$1, t.$2, t.$3 from @dw2infametamodel_stage/DOE/links.csv.gz t)
--     FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
--     ON_ERROR = 'ABORT_STATEMENT'
--     PURGE = FALSE;
COPY INTO DDW2INFA_LINK(org, source, target, association)
    FROM (SELECT 'DOEA' org, t.$1, t.$2, t.$3 from @dw2infametamodel_stage/DOEA/links.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_LINK(org, source, target, association)
    FROM (SELECT 'DOH' org, t.$1, t.$2, t.$3 from @dw2infametamodel_stage/DOH/links.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_LINK(org, source, target, association)
    FROM (SELECT 'DOL' org, t.$1, t.$2, t.$3 from @dw2infametamodel_stage/DOL/links.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
-- COPY INTO DDW2INFA_LINK(org, source, target, association)
--     FROM (SELECT 'DOR' org, t.$1, t.$2, t.$3 from @dw2infametamodel_stage/DOR/links.csv.gz t)
--     FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
--     ON_ERROR = 'ABORT_STATEMENT'
--     PURGE = FALSE;
COPY INTO DDW2INFA_LINK(org, source, target, association)
    FROM (SELECT 'DOT' org, t.$1, t.$2, t.$3 from @dw2infametamodel_stage/DOT/links.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_LINK(org, source, target, association)
    FROM (SELECT 'VR' org, t.$1, t.$2, t.$3 from @dw2infametamodel_stage/VR/links.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1)
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;

select "org", count("org") from DDW2INFA_COLUMN group by "org" order by "org";
select "org", count("org") from DDW2INFA_TABLE group by "org" order by "org";
select "org", count("org") from DDW2INFA_SCHEMA group by "org" order by "org";
select "org", count("org") from DDW2INFA_DATABASE group by "org" order by "org";
select org, count(org) from DDW2INFA_LINK group by org order by org;


select
    "org",
    "core.externalId",
    "core.name",
    "core.description",
    "custom.data.world.businessSummary",
    "custom.data.world.iri",
    "custom.data.world.columnTypeName",
    "custom.data.world.owner",
    "custom.data.world.dataSteward",
    "custom.data.world.restrictedToPublic",
    "custom.data.world.sensitiveData",
    "custom.data.world.status",
    "custom.data.world.technicalSteward",
    "custom.data.world.typePrefix",
    "core.businessDescription",
    "core.businessName",
    "core.reference"
from DDW2INFA_COLUMN;

select
    "org",
    "core.externalId",
    "core.name",
    "core.description",
    "custom.data.world.owner",
    "custom.data.world.typePrefix",
    "custom.data.world.tableType",
    "custom.data.world.businessSummary",
    "custom.data.world.restrictedToPublic",
    "custom.data.world.sensitiveData",
    "custom.data.world.dataSharingAgreement",
    "custom.data.world.programOffice",
    "custom.data.world.dataSteward",
    "custom.data.world.technicalSteward",
    "custom.data.world.contactEmail",
    "custom.data.world.status",
    "core.businessDescription",
    "core.businessName",
    "core.reference"
FROM DDW2INFA_TABLE;

SELECT
    "org",
    "core.externalId",
    "core.name",
    "core.description",
    "core.assignable",
    "core.businessDescription",
    "core.businessName",
    "core.reference",
    "custom.data.world.owner"
FROM DDW2INFA_SCHEMA;

SELECT
    "org",
    "core.externalId",
    "core.name",
    "core.description",
    "core.assignable",
    "core.businessDescription",
    "core.businessName",
    "core.reference",
    "custom.data.world.owner",
    "custom.data.world.jdbcURL",
    "custom.data.world.databaseServer",
    "custom.data.world.databasePort"
FROM DDW2INFA_DATABASE;

SELECT
    org,
    source,
    target,
    association
FROM DDW2INFA_LINK;

ls @dw2infametamodel_stage/DOH;
remove @dw2infametamodel_stage/DOH;
remove @dw2infametamodel_stage;
ls @dw2infametamodel_stage;
create or replace stage dw2infametamodel_stage directory = (enable = true) encryption = (type = 'snowflake_sse');
grant READ on stage dw2infametamodel_stage to role dataworldanalyst;
grant WRITE on stage dw2infametamodel_stage to role dataworldanalyst;

truncate table "DATA_WORLD_METADATA"."PUBLIC"."DDW2INFA_LINK";
truncate table "DATA_WORLD_METADATA"."PUBLIC"."DDW2INFA_COLUMN";
truncate table "DATA_WORLD_METADATA"."PUBLIC"."DDW2INFA_TABLE";
truncate table "DATA_WORLD_METADATA"."PUBLIC"."DDW2INFA_SCHEMA";
truncate table "DATA_WORLD_METADATA"."PUBLIC"."DDW2INFA_DATABASE";

-- SCRATCH AREA: DELETE ALL BELOW:
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\VR\informatica_import\custom.data.world.ColumnName.csv @dw2infametamodel_stage/VR;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\VR\informatica_import\custom.data.world.TableName.csv @dw2infametamodel_stage/VR;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\VR\informatica_import\custom.data.world.SchemaName.csv @dw2infametamodel_stage/VR;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\VR\informatica_import\custom.data.world.DatabaseName.csv @dw2infametamodel_stage/VR;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\VR\informatica_import\links.csv @dw2infametamodel_stage/VR;

COPY INTO DDW2INFA_COLUMN("org", "core.externalId", "core.name", "core.description", "custom.data.world.businessSummary", "custom.data.world.iri", "custom.data.world.columnTypeName", "custom.data.world.owner", "custom.data.world.dataSteward", "custom.data.world.restrictedToPublic", "custom.data.world.sensitiveData", "custom.data.world.status", "custom.data.world.technicalSteward", "custom.data.world.typePrefix", "core.businessDescription", "core.businessName", "core.reference")
    FROM (SELECT 'VR' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16 from @dw2infametamodel_stage/VR/custom.data.world.ColumnName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_TABLE("org", "core.externalId", "core.name", "core.description", "custom.data.world.owner", "custom.data.world.typePrefix", "custom.data.world.tableType", "custom.data.world.businessSummary", "custom.data.world.restrictedToPublic", "custom.data.world.sensitiveData", "custom.data.world.dataSharingAgreement", "custom.data.world.programOffice", "custom.data.world.dataSteward", "custom.data.world.technicalSteward", "custom.data.world.contactEmail", "custom.data.world.status", "core.businessDescription", "core.businessName", "core.reference")
    FROM (SELECT 'VR' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16, t.$17, t.$18 from @dw2infametamodel_stage/VR/custom.data.world.TableName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_SCHEMA("org", "core.externalId", "core.name", "core.description", "core.assignable", "core.businessDescription", "core.businessName", "core.reference", "custom.data.world.owner")
    FROM (SELECT 'VR' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8 from @dw2infametamodel_stage/VR/custom.data.world.SchemaName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_DATABASE("org", "core.externalId", "core.name", "core.description", "core.assignable", "core.businessDescription", "core.businessName", "core.reference", "custom.data.world.owner", "custom.data.world.jdbcURL", "custom.data.world.databaseServer", "custom.data.world.databasePort")
    FROM (SELECT 'VR' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11 from @dw2infametamodel_stage/VR/custom.data.world.DatabaseName.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW2INFA_LINK(org, source, target, association)
    FROM (SELECT 'VR' org, t.$1, t.$2, t.$3 from @dw2infametamodel_stage/VR/links.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = '|||')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;







