create or replace role dataworldanalyst;
grant usage on database data_world_metadata to role dataworldanalyst;
grant usage on schema data_world_metadata.public to role dataworldanalyst;
grant usage on warehouse compute_wh to role dataworldanalyst;
grant UPDATE on table DDW_BUSINESS_TERM to role dataworldanalyst;
grant UPDATE on table DDW_COLUMN to role dataworldanalyst;
grant UPDATE on table DDW_TABLE to role dataworldanalyst;
grant UPDATE on table DDW_DATASOURCE to role dataworldanalyst;
grant SELECT on table DDW_BUSINESS_TERM to role dataworldanalyst;
grant SELECT on table DDW_COLUMN to role dataworldanalyst;
grant SELECT on table DDW_TABLE to role dataworldanalyst;
grant SELECT on table DDW_DATASOURCE to role dataworldanalyst;
grant INSERT on table DDW_BUSINESS_TERM to role dataworldanalyst;
grant INSERT on table DDW_COLUMN to role dataworldanalyst;
grant INSERT on table DDW_TABLE to role dataworldanalyst;
grant INSERT on table DDW_DATASOURCE to role dataworldanalyst;
grant TRUNCATE on table DDW_BUSINESS_TERM to role dataworldanalyst;
grant TRUNCATE on table DDW_COLUMN to role dataworldanalyst;
grant TRUNCATE on table DDW_TABLE to role dataworldanalyst;
grant TRUNCATE on table DDW_DATASOURCE to role dataworldanalyst;
-- Regarding internal stages:
--   1. READ must come before WRITE
--   2. Also, operating on a stage also requires the USAGE privilege on the parent database and schema (I did this already, see above)
--   See https://docs.snowflake.com/en/user-guide/security-access-control-privileges.html#stage-privileges
grant READ on stage dwcsv2sfdb_stage to role dataworldanalyst;
grant WRITE on stage dwcsv2sfdb_stage to role dataworldanalyst;
grant role dataworldanalyst to user DATAMGTSVC;
show grants to user DATAMGTSVC;
show grants to role dataworldanalyst;
use database data_world_metadata;
use schema data_world_metadata.public;
create or replace stage dwcsv2sfdb_stage directory = (enable = true) encryption = (type = 'snowflake_sse');
ls @dwcsv2sfdb_stage;
create or replace table  "DATA_WORLD_METADATA"."PUBLIC"."DDW_BUSINESS_TERM"
(
    org text,
    collections text,
    businesstermiri text,
    business_term text,
    description text,
    summary text,
    data_ownner text,
    data_steward text,
    program_officer text,
    technical_steward text,
    status text
);

create or replace table  "DATA_WORLD_METADATA"."PUBLIC"."DDW_COLUMN"
(
    org text,
    collections text,
    type_prefix text,
    database_name text,
    table_name text,
    schema text,
    type text,
    column_name text,
    column_IRI text,
    description text,
    business_summary text,
    restricted_to_public_disclosure_per_federal_or_state_law text,
    sensitive_data text,
    data_ownner text,
    data_steward text,
    technical_steward text,
    status text
);

create or replace table  "DATA_WORLD_METADATA"."PUBLIC"."DDW_TABLE"
(
    org text,
    collections text,
    type_prefix text,
    database_name text,
    schema text,
    type text,
    table_name text,
    table_IRI text,
    description text,
    business_summary text,
    restricted_to_public_disclosure_per_federal_or_state_law text,
    sensitive_data text,
    data_sharing_agreement text,
    program_office text,
    data_steward text,
    data_ownner text,
    technical_steward text,
    contact_email text,
    status text
);

create or replace table  "DATA_WORLD_METADATA"."PUBLIC"."DDW_DATASOURCE"
(
    org text,
    collections text,
    databaseiri text,
    databaseName text,
    jdbcURL text,
    databaseServer text,
    databasePort text,
    schemas text
);

----------------------------------------------------------------------------------------------
-- After setting up database objects, use PUT command to move files to named internal stage.
-- The following commands are executed remotely using a non-SSO-validated user account.
----------------------------------------------------------------------------------------------

PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\AHCA\ddw_dictionary_dump\BusinessTerms.csv @dwcsv2sfdb_stage/AHCA;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\APD\ddw_dictionary_dump\BusinessTerms.csv @dwcsv2sfdb_stage/APD;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\BOG\ddw_dictionary_dump\BusinessTerms.csv @dwcsv2sfdb_stage/BOG;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DBPR\ddw_dictionary_dump\BusinessTerms.csv @dwcsv2sfdb_stage/DBPR;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DBS\ddw_dictionary_dump\BusinessTerms.csv @dwcsv2sfdb_stage/DBS;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DCF\ddw_dictionary_dump\BusinessTerms.csv @dwcsv2sfdb_stage/DCF;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DEO\ddw_dictionary_dump\BusinessTerms.csv @dwcsv2sfdb_stage/DEO;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DHSMV\ddw_dictionary_dump\BusinessTerms.csv @dwcsv2sfdb_stage/DHSMV;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DMS\ddw_dictionary_dump\BusinessTerms.csv @dwcsv2sfdb_stage/DMS;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOE\ddw_dictionary_dump\BusinessTerms.csv @dwcsv2sfdb_stage/DOE;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOEA\ddw_dictionary_dump\BusinessTerms.csv @dwcsv2sfdb_stage/DOEA;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOH\ddw_dictionary_dump\BusinessTerms.csv @dwcsv2sfdb_stage/DOH;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOL\ddw_dictionary_dump\BusinessTerms.csv @dwcsv2sfdb_stage/DOL;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOR\ddw_dictionary_dump\BusinessTerms.csv @dwcsv2sfdb_stage/DOR;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOT\ddw_dictionary_dump\BusinessTerms.csv @dwcsv2sfdb_stage/DOT;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\VR\ddw_dictionary_dump\BusinessTerms.csv @dwcsv2sfdb_stage/VR;

PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\AHCA\ddw_dictionary_dump\Columns.csv @dwcsv2sfdb_stage/AHCA;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\APD\ddw_dictionary_dump\Columns.csv @dwcsv2sfdb_stage/APD;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\BOG\ddw_dictionary_dump\Columns.csv @dwcsv2sfdb_stage/BOG;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DBPR\ddw_dictionary_dump\Columns.csv @dwcsv2sfdb_stage/DBPR;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DBS\ddw_dictionary_dump\Columns.csv @dwcsv2sfdb_stage/DBS;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DCF\ddw_dictionary_dump\Columns.csv @dwcsv2sfdb_stage/DCF;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DEO\ddw_dictionary_dump\Columns.csv @dwcsv2sfdb_stage/DEO;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DHSMV\ddw_dictionary_dump\Columns.csv @dwcsv2sfdb_stage/DHSMV;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DMS\ddw_dictionary_dump\Columns.csv @dwcsv2sfdb_stage/DMS;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOE\ddw_dictionary_dump\Columns.csv @dwcsv2sfdb_stage/DOE;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOEA\ddw_dictionary_dump\Columns.csv @dwcsv2sfdb_stage/DOEA;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOH\ddw_dictionary_dump\Columns.csv @dwcsv2sfdb_stage/DOH;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOL\ddw_dictionary_dump\Columns.csv @dwcsv2sfdb_stage/DOL;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOR\ddw_dictionary_dump\Columns.csv @dwcsv2sfdb_stage/DOR;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOT\ddw_dictionary_dump\Columns.csv @dwcsv2sfdb_stage/DOT;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\VR\ddw_dictionary_dump\Columns.csv @dwcsv2sfdb_stage/VR;

PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\AHCA\ddw_dictionary_dump\DataSources.csv @dwcsv2sfdb_stage/AHCA;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\APD\ddw_dictionary_dump\DataSources.csv @dwcsv2sfdb_stage/APD;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\BOG\ddw_dictionary_dump\DataSources.csv @dwcsv2sfdb_stage/BOG;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DBPR\ddw_dictionary_dump\DataSources.csv @dwcsv2sfdb_stage/DBPR;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DBS\ddw_dictionary_dump\DataSources.csv @dwcsv2sfdb_stage/DBS;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DCF\ddw_dictionary_dump\DataSources.csv @dwcsv2sfdb_stage/DCF;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DEO\ddw_dictionary_dump\DataSources.csv @dwcsv2sfdb_stage/DEO;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DHSMV\ddw_dictionary_dump\DataSources.csv @dwcsv2sfdb_stage/DHSMV;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DMS\ddw_dictionary_dump\DataSources.csv @dwcsv2sfdb_stage/DMS;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOE\ddw_dictionary_dump\DataSources.csv @dwcsv2sfdb_stage/DOE;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOEA\ddw_dictionary_dump\DataSources.csv @dwcsv2sfdb_stage/DOEA;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOH\ddw_dictionary_dump\DataSources.csv @dwcsv2sfdb_stage/DOH;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOL\ddw_dictionary_dump\DataSources.csv @dwcsv2sfdb_stage/DOL;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOR\ddw_dictionary_dump\DataSources.csv @dwcsv2sfdb_stage/DOR;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOT\ddw_dictionary_dump\DataSources.csv @dwcsv2sfdb_stage/DOT;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\VR\ddw_dictionary_dump\DataSources.csv @dwcsv2sfdb_stage/VR;

PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\AHCA\ddw_dictionary_dump\Tables.csv @dwcsv2sfdb_stage/AHCA;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\APD\ddw_dictionary_dump\Tables.csv @dwcsv2sfdb_stage/APD;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\BOG\ddw_dictionary_dump\Tables.csv @dwcsv2sfdb_stage/BOG;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DBPR\ddw_dictionary_dump\Tables.csv @dwcsv2sfdb_stage/DBPR;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DBS\ddw_dictionary_dump\Tables.csv @dwcsv2sfdb_stage/DBS;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DCF\ddw_dictionary_dump\Tables.csv @dwcsv2sfdb_stage/DCF;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DEO\ddw_dictionary_dump\Tables.csv @dwcsv2sfdb_stage/DEO;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DHSMV\ddw_dictionary_dump\Tables.csv @dwcsv2sfdb_stage/DHSMV;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DMS\ddw_dictionary_dump\Tables.csv @dwcsv2sfdb_stage/DMS;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOE\ddw_dictionary_dump\Tables.csv @dwcsv2sfdb_stage/DOE;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOEA\ddw_dictionary_dump\Tables.csv @dwcsv2sfdb_stage/DOEA;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOH\ddw_dictionary_dump\Tables.csv @dwcsv2sfdb_stage/DOH;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOL\ddw_dictionary_dump\Tables.csv @dwcsv2sfdb_stage/DOL;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOR\ddw_dictionary_dump\Tables.csv @dwcsv2sfdb_stage/DOR;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\DOT\ddw_dictionary_dump\Tables.csv @dwcsv2sfdb_stage/DOT;
PUT file://C:\Workarea\data.world\data-world-ttl-to-xlsx\output\VR\ddw_dictionary_dump\Tables.csv @dwcsv2sfdb_stage/VR;

-- COPY INTO appends by default, which is nice.
COPY INTO DDW_COLUMN(org, collections, type_prefix, database_name, table_name, schema, type, column_name, column_iri, description, business_summary, restricted_to_public_disclosure_per_federal_or_state_law, sensitive_data, data_ownner, data_steward, technical_steward, status)
    FROM (SELECT 'AHCA' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16 from @dwcsv2sfdb_stage/AHCA/Columns.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_COLUMN(org, collections, type_prefix, database_name, table_name, schema, type, column_name, column_iri, description, business_summary, restricted_to_public_disclosure_per_federal_or_state_law, sensitive_data, data_ownner, data_steward, technical_steward, status)
    FROM (SELECT 'APD' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16 from @dwcsv2sfdb_stage/APD/Columns.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_COLUMN(org, collections, type_prefix, database_name, table_name, schema, type, column_name, column_iri, description, business_summary, restricted_to_public_disclosure_per_federal_or_state_law, sensitive_data, data_ownner, data_steward, technical_steward, status)
    FROM (SELECT 'BOG' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16 from @dwcsv2sfdb_stage/BOG/Columns.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_COLUMN(org, collections, type_prefix, database_name, table_name, schema, type, column_name, column_iri, description, business_summary, restricted_to_public_disclosure_per_federal_or_state_law, sensitive_data, data_ownner, data_steward, technical_steward, status)
    FROM (SELECT 'DBPR' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16 from @dwcsv2sfdb_stage/DBPR/Columns.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_COLUMN(org, collections, type_prefix, database_name, table_name, schema, type, column_name, column_iri, description, business_summary, restricted_to_public_disclosure_per_federal_or_state_law, sensitive_data, data_ownner, data_steward, technical_steward, status)
    FROM (SELECT 'DBS' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16 from @dwcsv2sfdb_stage/DBS/Columns.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_COLUMN(org, collections, type_prefix, database_name, table_name, schema, type, column_name, column_iri, description, business_summary, restricted_to_public_disclosure_per_federal_or_state_law, sensitive_data, data_ownner, data_steward, technical_steward, status)
    FROM (SELECT 'DCF' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16 from @dwcsv2sfdb_stage/DCF/Columns.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_COLUMN(org, collections, type_prefix, database_name, table_name, schema, type, column_name, column_iri, description, business_summary, restricted_to_public_disclosure_per_federal_or_state_law, sensitive_data, data_ownner, data_steward, technical_steward, status)
    FROM (SELECT 'DEO' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16 from @dwcsv2sfdb_stage/DEO/Columns.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_COLUMN(org, collections, type_prefix, database_name, table_name, schema, type, column_name, column_iri, description, business_summary, restricted_to_public_disclosure_per_federal_or_state_law, sensitive_data, data_ownner, data_steward, technical_steward, status)
    FROM (SELECT 'DHSMV' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16 from @dwcsv2sfdb_stage/DHSMV/Columns.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_COLUMN(org, collections, type_prefix, database_name, table_name, schema, type, column_name, column_iri, description, business_summary, restricted_to_public_disclosure_per_federal_or_state_law, sensitive_data, data_ownner, data_steward, technical_steward, status)
    FROM (SELECT 'DMS' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16 from @dwcsv2sfdb_stage/DMS/Columns.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_COLUMN(org, collections, type_prefix, database_name, table_name, schema, type, column_name, column_iri, description, business_summary, restricted_to_public_disclosure_per_federal_or_state_law, sensitive_data, data_ownner, data_steward, technical_steward, status)
    FROM (SELECT 'DOE' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16 from @dwcsv2sfdb_stage/DOE/Columns.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_COLUMN(org, collections, type_prefix, database_name, table_name, schema, type, column_name, column_iri, description, business_summary, restricted_to_public_disclosure_per_federal_or_state_law, sensitive_data, data_ownner, data_steward, technical_steward, status)
    FROM (SELECT 'DOEA' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16 from @dwcsv2sfdb_stage/DOEA/Columns.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_COLUMN(org, collections, type_prefix, database_name, table_name, schema, type, column_name, column_iri, description, business_summary, restricted_to_public_disclosure_per_federal_or_state_law, sensitive_data, data_ownner, data_steward, technical_steward, status)
    FROM (SELECT 'DOH' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16 from @dwcsv2sfdb_stage/DOH/Columns.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_COLUMN(org, collections, type_prefix, database_name, table_name, schema, type, column_name, column_iri, description, business_summary, restricted_to_public_disclosure_per_federal_or_state_law, sensitive_data, data_ownner, data_steward, technical_steward, status)
    FROM (SELECT 'DOL' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16 from @dwcsv2sfdb_stage/DOL/Columns.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_COLUMN(org, collections, type_prefix, database_name, table_name, schema, type, column_name, column_iri, description, business_summary, restricted_to_public_disclosure_per_federal_or_state_law, sensitive_data, data_ownner, data_steward, technical_steward, status)
    FROM (SELECT 'DOR' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16 from @dwcsv2sfdb_stage/DOR/Columns.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_COLUMN(org, collections, type_prefix, database_name, table_name, schema, type, column_name, column_iri, description, business_summary, restricted_to_public_disclosure_per_federal_or_state_law, sensitive_data, data_ownner, data_steward, technical_steward, status)
    FROM (SELECT 'DOT' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16 from @dwcsv2sfdb_stage/DOT/Columns.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_COLUMN(org, collections, type_prefix, database_name, table_name, schema, type, column_name, column_iri, description, business_summary, restricted_to_public_disclosure_per_federal_or_state_law, sensitive_data, data_ownner, data_steward, technical_steward, status)
    FROM (SELECT 'VR' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16 from @dwcsv2sfdb_stage/VR/Columns.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;

COPY INTO DDW_TABLE(org, collections, type_prefix, database_name, schema, type, table_name, table_IRI, description, business_summary, restricted_to_public_disclosure_per_federal_or_state_law, sensitive_data, data_sharing_agreement, program_office, data_steward, data_ownner, technical_steward, contact_email, status)
    FROM (SELECT 'AHCA' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16, t.$17, t.$18 from @dwcsv2sfdb_stage/AHCA/Tables.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_TABLE(org, collections, type_prefix, database_name, schema, type, table_name, table_IRI, description, business_summary, restricted_to_public_disclosure_per_federal_or_state_law, sensitive_data, data_sharing_agreement, program_office, data_steward, data_ownner, technical_steward, contact_email, status)
    FROM (SELECT 'APD' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16, t.$17, t.$18 from @dwcsv2sfdb_stage/APD/Tables.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_TABLE(org, collections, type_prefix, database_name, schema, type, table_name, table_IRI, description, business_summary, restricted_to_public_disclosure_per_federal_or_state_law, sensitive_data, data_sharing_agreement, program_office, data_steward, data_ownner, technical_steward, contact_email, status)
    FROM (SELECT 'BOG' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16, t.$17, t.$18 from @dwcsv2sfdb_stage/BOG/Tables.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_TABLE(org, collections, type_prefix, database_name, schema, type, table_name, table_IRI, description, business_summary, restricted_to_public_disclosure_per_federal_or_state_law, sensitive_data, data_sharing_agreement, program_office, data_steward, data_ownner, technical_steward, contact_email, status)
    FROM (SELECT 'DBPR' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16, t.$17, t.$18 from @dwcsv2sfdb_stage/DBPR/Tables.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_TABLE(org, collections, type_prefix, database_name, schema, type, table_name, table_IRI, description, business_summary, restricted_to_public_disclosure_per_federal_or_state_law, sensitive_data, data_sharing_agreement, program_office, data_steward, data_ownner, technical_steward, contact_email, status)
    FROM (SELECT 'DBS' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16, t.$17, t.$18 from @dwcsv2sfdb_stage/DBS/Tables.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_TABLE(org, collections, type_prefix, database_name, schema, type, table_name, table_IRI, description, business_summary, restricted_to_public_disclosure_per_federal_or_state_law, sensitive_data, data_sharing_agreement, program_office, data_steward, data_ownner, technical_steward, contact_email, status)
    FROM (SELECT 'DCF' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16, t.$17, t.$18 from @dwcsv2sfdb_stage/DCF/Tables.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_TABLE(org, collections, type_prefix, database_name, schema, type, table_name, table_IRI, description, business_summary, restricted_to_public_disclosure_per_federal_or_state_law, sensitive_data, data_sharing_agreement, program_office, data_steward, data_ownner, technical_steward, contact_email, status)
    FROM (SELECT 'DEO' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16, t.$17, t.$18 from @dwcsv2sfdb_stage/DEO/Tables.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_TABLE(org, collections, type_prefix, database_name, schema, type, table_name, table_IRI, description, business_summary, restricted_to_public_disclosure_per_federal_or_state_law, sensitive_data, data_sharing_agreement, program_office, data_steward, data_ownner, technical_steward, contact_email, status)
    FROM (SELECT 'DHSMV' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16, t.$17, t.$18 from @dwcsv2sfdb_stage/DHSMV/Tables.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_TABLE(org, collections, type_prefix, database_name, schema, type, table_name, table_IRI, description, business_summary, restricted_to_public_disclosure_per_federal_or_state_law, sensitive_data, data_sharing_agreement, program_office, data_steward, data_ownner, technical_steward, contact_email, status)
    FROM (SELECT 'DMS' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16, t.$17, t.$18 from @dwcsv2sfdb_stage/DMS/Tables.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_TABLE(org, collections, type_prefix, database_name, schema, type, table_name, table_IRI, description, business_summary, restricted_to_public_disclosure_per_federal_or_state_law, sensitive_data, data_sharing_agreement, program_office, data_steward, data_ownner, technical_steward, contact_email, status)
    FROM (SELECT 'DOE' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16, t.$17, t.$18 from @dwcsv2sfdb_stage/DOE/Tables.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_TABLE(org, collections, type_prefix, database_name, schema, type, table_name, table_IRI, description, business_summary, restricted_to_public_disclosure_per_federal_or_state_law, sensitive_data, data_sharing_agreement, program_office, data_steward, data_ownner, technical_steward, contact_email, status)
    FROM (SELECT 'DOEA' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16, t.$17, t.$18 from @dwcsv2sfdb_stage/DOEA/Tables.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_TABLE(org, collections, type_prefix, database_name, schema, type, table_name, table_IRI, description, business_summary, restricted_to_public_disclosure_per_federal_or_state_law, sensitive_data, data_sharing_agreement, program_office, data_steward, data_ownner, technical_steward, contact_email, status)
    FROM (SELECT 'DOH' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16, t.$17, t.$18 from @dwcsv2sfdb_stage/DOH/Tables.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_TABLE(org, collections, type_prefix, database_name, schema, type, table_name, table_IRI, description, business_summary, restricted_to_public_disclosure_per_federal_or_state_law, sensitive_data, data_sharing_agreement, program_office, data_steward, data_ownner, technical_steward, contact_email, status)
    FROM (SELECT 'DOL' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16, t.$17, t.$18 from @dwcsv2sfdb_stage/DOL/Tables.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_TABLE(org, collections, type_prefix, database_name, schema, type, table_name, table_IRI, description, business_summary, restricted_to_public_disclosure_per_federal_or_state_law, sensitive_data, data_sharing_agreement, program_office, data_steward, data_ownner, technical_steward, contact_email, status)
    FROM (SELECT 'DOR' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16, t.$17, t.$18 from @dwcsv2sfdb_stage/DOR/Tables.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_TABLE(org, collections, type_prefix, database_name, schema, type, table_name, table_IRI, description, business_summary, restricted_to_public_disclosure_per_federal_or_state_law, sensitive_data, data_sharing_agreement, program_office, data_steward, data_ownner, technical_steward, contact_email, status)
    FROM (SELECT 'DOT' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16, t.$17, t.$18 from @dwcsv2sfdb_stage/DOT/Tables.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_TABLE(org, collections, type_prefix, database_name, schema, type, table_name, table_IRI, description, business_summary, restricted_to_public_disclosure_per_federal_or_state_law, sensitive_data, data_sharing_agreement, program_office, data_steward, data_ownner, technical_steward, contact_email, status)
    FROM (SELECT 'VR' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, t.$13, t.$14, t.$15, t.$16, t.$17, t.$18 from @dwcsv2sfdb_stage/VR/Tables.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;

COPY INTO DDW_DATASOURCE(org, collections, databaseiri, databaseName, jdbcURL, databaseServer, databasePort, schemas)
    FROM (SELECT 'AHCA' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7 from @dwcsv2sfdb_stage/AHCA/DataSources.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_DATASOURCE(org, collections, databaseiri, databaseName, jdbcURL, databaseServer, databasePort, schemas)
    FROM (SELECT 'APD' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7 from @dwcsv2sfdb_stage/APD/DataSources.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_DATASOURCE(org, collections, databaseiri, databaseName, jdbcURL, databaseServer, databasePort, schemas)
    FROM (SELECT 'BOG' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7 from @dwcsv2sfdb_stage/BOG/DataSources.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_DATASOURCE(org, collections, databaseiri, databaseName, jdbcURL, databaseServer, databasePort, schemas)
    FROM (SELECT 'DBPR' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7 from @dwcsv2sfdb_stage/DBPR/DataSources.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_DATASOURCE(org, collections, databaseiri, databaseName, jdbcURL, databaseServer, databasePort, schemas)
    FROM (SELECT 'DBS' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7 from @dwcsv2sfdb_stage/DBS/DataSources.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_DATASOURCE(org, collections, databaseiri, databaseName, jdbcURL, databaseServer, databasePort, schemas)
    FROM (SELECT 'DCF' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7 from @dwcsv2sfdb_stage/DCF/DataSources.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_DATASOURCE(org, collections, databaseiri, databaseName, jdbcURL, databaseServer, databasePort, schemas)
    FROM (SELECT 'DEO' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7 from @dwcsv2sfdb_stage/DEO/DataSources.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_DATASOURCE(org, collections, databaseiri, databaseName, jdbcURL, databaseServer, databasePort, schemas)
    FROM (SELECT 'DHSMV' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7 from @dwcsv2sfdb_stage/DHSMV/DataSources.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_DATASOURCE(org, collections, databaseiri, databaseName, jdbcURL, databaseServer, databasePort, schemas)
    FROM (SELECT 'DMS' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7 from @dwcsv2sfdb_stage/DMS/DataSources.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_DATASOURCE(org, collections, databaseiri, databaseName, jdbcURL, databaseServer, databasePort, schemas)
    FROM (SELECT 'DOE' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7 from @dwcsv2sfdb_stage/DOE/DataSources.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_DATASOURCE(org, collections, databaseiri, databaseName, jdbcURL, databaseServer, databasePort, schemas)
    FROM (SELECT 'DOEA' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7 from @dwcsv2sfdb_stage/DOEA/DataSources.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_DATASOURCE(org, collections, databaseiri, databaseName, jdbcURL, databaseServer, databasePort, schemas)
    FROM (SELECT 'DOH' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7 from @dwcsv2sfdb_stage/DOH/DataSources.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_DATASOURCE(org, collections, databaseiri, databaseName, jdbcURL, databaseServer, databasePort, schemas)
    FROM (SELECT 'DOL' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7 from @dwcsv2sfdb_stage/DOL/DataSources.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_DATASOURCE(org, collections, databaseiri, databaseName, jdbcURL, databaseServer, databasePort, schemas)
    FROM (SELECT 'DOR' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7 from @dwcsv2sfdb_stage/DOR/DataSources.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_DATASOURCE(org, collections, databaseiri, databaseName, jdbcURL, databaseServer, databasePort, schemas)
    FROM (SELECT 'DOT' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7 from @dwcsv2sfdb_stage/DOT/DataSources.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_DATASOURCE(org, collections, databaseiri, databaseName, jdbcURL, databaseServer, databasePort, schemas)
    FROM (SELECT 'VR' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7 from @dwcsv2sfdb_stage/VR/DataSources.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;

COPY INTO DDW_BUSINESS_TERM(org, collections, businesstermiri, business_term, description, summary, data_ownner, data_steward, program_officer, technical_steward, status)
    FROM (SELECT 'AHCA' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10 from @dwcsv2sfdb_stage/AHCA/BusinessTerms.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_BUSINESS_TERM(org, collections, businesstermiri, business_term, description, summary, data_ownner, data_steward, program_officer, technical_steward, status)
    FROM (SELECT 'APD' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10 from @dwcsv2sfdb_stage/APD/BusinessTerms.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_BUSINESS_TERM(org, collections, businesstermiri, business_term, description, summary, data_ownner, data_steward, program_officer, technical_steward, status)
    FROM (SELECT 'BOG' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10 from @dwcsv2sfdb_stage/BOG/BusinessTerms.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_BUSINESS_TERM(org, collections, businesstermiri, business_term, description, summary, data_ownner, data_steward, program_officer, technical_steward, status)
    FROM (SELECT 'DBPR' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10 from @dwcsv2sfdb_stage/DBPR/BusinessTerms.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_BUSINESS_TERM(org, collections, businesstermiri, business_term, description, summary, data_ownner, data_steward, program_officer, technical_steward, status)
    FROM (SELECT 'DBS' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10 from @dwcsv2sfdb_stage/DBS/BusinessTerms.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_BUSINESS_TERM(org, collections, businesstermiri, business_term, description, summary, data_ownner, data_steward, program_officer, technical_steward, status)
    FROM (SELECT 'DCF' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10 from @dwcsv2sfdb_stage/DCF/BusinessTerms.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_BUSINESS_TERM(org, collections, businesstermiri, business_term, description, summary, data_ownner, data_steward, program_officer, technical_steward, status)
    FROM (SELECT 'DEO' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10 from @dwcsv2sfdb_stage/DEO/BusinessTerms.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_BUSINESS_TERM(org, collections, businesstermiri, business_term, description, summary, data_ownner, data_steward, program_officer, technical_steward, status)
    FROM (SELECT 'DHSMV' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10 from @dwcsv2sfdb_stage/DHSMV/BusinessTerms.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_BUSINESS_TERM(org, collections, businesstermiri, business_term, description, summary, data_ownner, data_steward, program_officer, technical_steward, status)
    FROM (SELECT 'DMS' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10 from @dwcsv2sfdb_stage/DMS/BusinessTerms.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_BUSINESS_TERM(org, collections, businesstermiri, business_term, description, summary, data_ownner, data_steward, program_officer, technical_steward, status)
    FROM (SELECT 'DOE' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10 from @dwcsv2sfdb_stage/DOE/BusinessTerms.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_BUSINESS_TERM(org, collections, businesstermiri, business_term, description, summary, data_ownner, data_steward, program_officer, technical_steward, status)
    FROM (SELECT 'DOEA' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10 from @dwcsv2sfdb_stage/DOEA/BusinessTerms.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_BUSINESS_TERM(org, collections, businesstermiri, business_term, description, summary, data_ownner, data_steward, program_officer, technical_steward, status)
    FROM (SELECT 'DOH' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10 from @dwcsv2sfdb_stage/DOH/BusinessTerms.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_BUSINESS_TERM(org, collections, businesstermiri, business_term, description, summary, data_ownner, data_steward, program_officer, technical_steward, status)
    FROM (SELECT 'DOL' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10 from @dwcsv2sfdb_stage/DOL/BusinessTerms.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_BUSINESS_TERM(org, collections, businesstermiri, business_term, description, summary, data_ownner, data_steward, program_officer, technical_steward, status)
    FROM (SELECT 'DOR' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10 from @dwcsv2sfdb_stage/DOR/BusinessTerms.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_BUSINESS_TERM(org, collections, businesstermiri, business_term, description, summary, data_ownner, data_steward, program_officer, technical_steward, status)
    FROM (SELECT 'DOT' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10 from @dwcsv2sfdb_stage/DOT/BusinessTerms.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;
COPY INTO DDW_BUSINESS_TERM(org, collections, businesstermiri, business_term, description, summary, data_ownner, data_steward, program_officer, technical_steward, status)
    FROM (SELECT 'VR' org, t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10 from @dwcsv2sfdb_stage/VR/BusinessTerms.csv.gz t)
    FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
    ON_ERROR = 'ABORT_STATEMENT'
    PURGE = FALSE;

select count(*) FROM DDW_COLUMN;        -- 5293618
select count(*) FROM DDW_TABLE;         --  610682
select count(*) FROM DDW_DATASOURCE;    --     793
select count(*) FROM DDW_BUSINESS_TERM; --       1


