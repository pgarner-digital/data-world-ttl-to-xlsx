use role INFORMATICA_METRICS_ANALYST;
use database INFA_METRICS;
use schema INFA_METRICS.PUBLIC;
create or replace table DATABASE_METADATA
(
    "orgId" text,
    "core.externalId" text,
    "core.name" text,
    "custom.data.world.import.jdbcURL" text,
    "custom.data.world.import.databaseServer" text,
    "custom.data.world.import.databasePort" text
);
create or replace table SCHEMA_METADATA
(
    "orgId" text,
    "core.externalId" text,
    "core.name" text,
    "core.description" text,
    "com.infa.odin.models.relational.Comment" text,
    "com.infa.odin.models.relational.Owner" text
);
create or replace table TABLE_METADATA
(
    "orgId" text,
    "core.externalId" text,
    "core.name" text,
    "core.description" text,
    "com.infa.odin.models.relational.Owner" text,
    "custom.data.world.import.businessSummary" text,
    "custom.data.world.import.contactEmail" text,
    "custom.data.world.import.dataSharingAgreement" text,
    "custom.data.world.import.dataSteward" text,
    "custom.data.world.import.programOffice" text,
    "custom.data.world.import.restrictedToPublic" text,
    "custom.data.world.import.sensitiveData" text,
    "custom.data.world.import.status" text,
    "com.infa.odin.models.relational.TableType" text,
    "custom.data.world.import.technicalSteward" text
);
create or replace table COLUMN_METADATA
(
    "orgId" text,
    "core.externalId" text,
    "custom.data.world.import.businessSummary" text,
    "custom.data.world.import.dataSteward" text,
    "com.infa.odin.models.relational.Datatype" text,
    "com.infa.odin.models.relational.DatatypeLength" text,
    "core.description" text,
    "core.name" text,
    "com.infa.odin.models.relational.PrimaryKeyColumn" text,
    "com.infa.odin.models.relational.Nullable" text,
    "com.infa.odin.models.relational.Position" text,
    "custom.data.world.import.restrictedToPublic" text,
    "custom.data.world.import.sensitiveData" text,
    "custom.data.world.import.status" text,
    "custom.data.world.import.technicalSteward" text
);
create or replace table VIEW_METADATA
(
    "orgId" text,
    "core.externalId" text,
    "core.name" text,
    "core.description" text,
    "com.infa.odin.models.relational.Owner" text,
    "com.infa.odin.models.relational.ViewType" text,
    "custom.data.world.import.businessSummary" text,
    "custom.data.world.import.restrictedToPublic" text,
    "custom.data.world.import.sensitiveData" text,
    "custom.data.world.import.dataSharingAgreement" text,
    "custom.data.world.import.programOffice" text,
    "custom.data.world.import.dataSteward" text,
    "custom.data.world.import.technicalSteward" text,
    "custom.data.world.import.contactEmail" text,
    "custom.data.world.import.status" text
);
create or replace table VIEW_COLUMN_METADATA
(
    "orgId" text,
    "core.externalId" text,
    "core.name" text,
    "core.description" text,
    "com.infa.odin.models.relational.Datatype" text,
    "com.infa.odin.models.relational.DatatypeLength" text,
    "com.infa.odin.models.relational.DatatypeScale" text,
    "com.infa.odin.models.relational.Nullable" text,
    "com.infa.odin.models.relational.Position" text,
    "com.infa.odin.models.relational.calculationComplexity" text,
    "com.infa.odin.models.relational.controlConditions" text,
    "com.infa.odin.models.relational.expression" text,
    "custom.data.world.import.businessSummary" text,
    "custom.data.world.import.sensitiveData" text,
    "custom.data.world.import.dataSteward" text,
    "custom.data.world.import.status" text,
    "custom.data.world.import.restrictedToPublic" text,
    "custom.data.world.import.technicalSteward" text
);
create or replace table LINKS_METADATA
(
    OrgId text,
    Source text,
    Target text,
    Association text
);

--truncate table DATABASE_METADATA;
--truncate table SCHEMA_METADATA;
--truncate table TABLE_METADATA;
--truncate table COLUMN_METADATA;
--truncate table VIEW_METADATA;
--truncate table VIEW_COLUMN_METADATA;

-- select count(*) from DATABASE_METADATA;
-- select count(*) from SCHEMA_METADATA;
-- select count(*) from TABLE_METADATA;
-- select count(*) from COLUMN_METADATA;
-- select count(*) from VIEW_METADATA;
-- select count(*) from VIEW_COLUMN_METADATA;
-- select count(*) from LINKS_METADATA;

select * from DATABASE_METADATA;
select * from SCHEMA_METADATA;
select * from TABLE_METADATA;
select * from COLUMN_METADATA;
select * from VIEW_METADATA;
select * from VIEW_COLUMN_METADATA;
select * from LINKS_METADATA;

select * from TABLE_METADATA where "core.name" = 'TMP_20200918_LOAD_DOB';
select * from COLUMN_METADATA where "core.description" like '%,%';
select * from LINKS_METADATA where Source = 'sch.72624a0ca14946ee918a4f916f435b09';
select distinct OrgId from LINKS_METADATA;

select COUNT(DISTINCT SOURCE) from LINKS_METADATA_BAK WHERE orgId = 'DMS' and ASSOCIATION = 'com.infa.odin.models.relational.ViewToViewColumn';
-- 4118

-- SELECT COUNT(DISTINCT t1.SOURCE)
-- FROM LINKS_METADATA_BAK t1
--          INNER JOIN VIEW_METADATA_BAK t2
--                     ON t1.SOURCE = t2."core.externalId";
-- 4118

-- SELECT COUNT(DISTINCT t1.TARGET)
-- FROM LINKS_METADATA_BAK t1
--          INNER JOIN VIEW_COLUMN_METADATA_BAK t2
--                     ON t1.TARGET = t2."core.externalId";
--65012

select * from TABLE_METADATA WHERE "core.description" like '%,%';



select distinct "custom.data.world.import.sensitiveData" from VIEW_METADATA_BAK;
select distinct "custom.data.world.import.sensitiveData" from VIEW_COLUMN_METADATA_BAK;
select distinct "custom.data.world.import.restrictedToPublic" from VIEW_METADATA_BAK;
select distinct "custom.data.world.import.restrictedToPublic" from VIEW_COLUMN_METADATA_BAK;

desc table VIEW_COLUMN_METADATA;
desc table VIEW_METADATA;


create or replace table DATABASE_METADATA_BAK as SELECT * FROM DATABASE_METADATA;
create or replace table SCHEMA_METADATA_BAK as SELECT * FROM SCHEMA_METADATA;
create or replace table TABLE_METADATA_BAK as SELECT * FROM TABLE_METADATA;
create or replace table COLUMN_METADATA_BAK as SELECT * FROM COLUMN_METADATA;
create or replace table LINKS_METADATA_BAK as SELECT * FROM LINKS_METADATA;
create or replace table VIEW_METADATA_BAK as SELECT * FROM VIEW_METADATA;
create or replace table VIEW_COLUMN_METADATA_BAK as SELECT * FROM VIEW_COLUMN_METADATA;

select * from DATABASE_METADATA_BAK;
select * from SCHEMA_METADATA_BAK;
select * from TABLE_METADATA_BAK;
select * from COLUMN_METADATA_BAK;
select * from LINKS_METADATA_BAK;
select * from VIEW_METADATA_BAK;
select * from VIEW_COLUMN_METADATA_BAK;

select * from DATABASE_METADATA_BAK WHERE "orgId" = 'DMS';
select * from SCHEMA_METADATA_BAK WHERE "orgId" = 'DMS';
select * from TABLE_METADATA_BAK WHERE "orgId" = 'DMS';
select * from COLUMN_METADATA_BAK WHERE "orgId" = 'DMS';
select * from VIEW_METADATA_BAK WHERE "orgId" = 'DMS';
select * from VIEW_COLUMN_METADATA_BAK WHERE "orgId" = 'DMS';
select * from LINKS_METADATA_BAK WHERE orgId = 'DMS';
select distinct ASSOCIATION from LINKS_METADATA_BAK;

-- SELECT t1.*
-- FROM TABLE_METADATA_BAK t1
--          INNER JOIN VIEW_METADATA_BAK t2
--                     ON t1."core.externalId" = t2."core.externalId";
--
-- SELECT t1.*
-- FROM COLUMN_METADATA_BAK t1
--          INNER JOIN VIEW_COLUMN_METADATA_BAK t2
--                     ON t1."core.externalId" = t2."core.externalId";

select distinct "com.infa.odin.models.relational.Datatype" from VIEW_COLUMN_METADATA;

select org_id, count(org_id) from DATABASE_METADATA
where (
    LENGTH(TRIM(description)) > 0 or
    LENGTH(TRIM(business_summary)) > 0 or
    LENGTH(TRIM(data_owner)) > 0 or
    LENGTH(TRIM(data_steward)) > 0 or
    LENGTH(TRIM(contact_email)) > 0 or
    LENGTH(TRIM(program_office)) > 0 or
    LENGTH(TRIM(technical_steward)) > 0 or
    LENGTH(TRIM(status)) > 0 or
    LENGTH(TRIM(restricted_to_public_disclosure)) > 0 or
    LENGTH(TRIM(data_sharing_agreement_required)) > 0 or
    LENGTH(TRIM(contains_sensitive_data)) > 0
)
group by org_id
order by org_id;

select org_id, count(org_id) from SCHEMA_METADATA
where (
    LENGTH(TRIM(description)) > 0 or
    LENGTH(TRIM(business_summary)) > 0 or
    LENGTH(TRIM(data_owner)) > 0 or
    LENGTH(TRIM(data_steward)) > 0 or
    LENGTH(TRIM(contact_email)) > 0 or
    LENGTH(TRIM(program_office)) > 0 or
    LENGTH(TRIM(technical_steward)) > 0 or
    LENGTH(TRIM(status)) > 0 or
    LENGTH(TRIM(restricted_to_public_disclosure)) > 0 or
    LENGTH(TRIM(data_sharing_agreement_required)) > 0 or
    LENGTH(TRIM(contains_sensitive_data)) > 0
)
group by org_id
order by org_id;

select org_id, count(org_id) from TABLE_METADATA
where (
    LENGTH(TRIM(description)) > 0 or
    LENGTH(TRIM(business_summary)) > 0 or
    LENGTH(TRIM(data_owner)) > 0 or
    LENGTH(TRIM(data_steward)) > 0 or
    LENGTH(TRIM(contact_email)) > 0 or
    LENGTH(TRIM(program_office)) > 0 or
    LENGTH(TRIM(technical_steward)) > 0 or
    LENGTH(TRIM(status)) > 0 or
    LENGTH(TRIM(restricted_to_public_disclosure)) > 0 or
    LENGTH(TRIM(data_sharing_agreement_required)) > 0 or
    LENGTH(TRIM(contains_sensitive_data)) > 0
)
group by org_id
order by org_id;

select org_id, count(org_id) from VIEW_METADATA
where (
    LENGTH(TRIM(description)) > 0 or
    LENGTH(TRIM(business_summary)) > 0 or
    LENGTH(TRIM(data_owner)) > 0 or
    LENGTH(TRIM(data_steward)) > 0 or
    LENGTH(TRIM(contact_email)) > 0 or
    LENGTH(TRIM(program_office)) > 0 or
    LENGTH(TRIM(technical_steward)) > 0 or
    LENGTH(TRIM(status)) > 0 or
    LENGTH(TRIM(restricted_to_public_disclosure)) > 0 or
    LENGTH(TRIM(data_sharing_agreement_required)) > 0 or
    LENGTH(TRIM(contains_sensitive_data)) > 0
)
group by org_id
order by org_id;

select org_id, count(org_id) from COLUMN_METADATA
where (
    LENGTH(TRIM(description)) > 0 or
    LENGTH(TRIM(business_summary)) > 0 or
    LENGTH(TRIM(data_owner)) > 0 or
    LENGTH(TRIM(data_steward)) > 0 or
    LENGTH(TRIM(contact_email)) > 0 or
    LENGTH(TRIM(program_office)) > 0 or
    LENGTH(TRIM(technical_steward)) > 0 or
    LENGTH(TRIM(status)) > 0 or
    LENGTH(TRIM(restricted_to_public_disclosure)) > 0 or
    LENGTH(TRIM(data_sharing_agreement_required)) > 0 or
    LENGTH(TRIM(contains_sensitive_data)) > 0
)
group by org_id
order by org_id;

select distinct rdf_type from DATABASE_METADATA;
select distinct rdf_type from SCHEMA_METADATA;
select distinct rdf_type from TABLE_METADATA;
select distinct rdf_type from VIEW_METADATA;
select distinct rdf_type from COLUMN_METADATA;

select distinct org_id, count(org_id) from DATABASE_METADATA group by org_id order by org_id;
select distinct org_id, count(org_id) from SCHEMA_METADATA group by org_id order by org_id;
select distinct org_id, count(org_id) from TABLE_METADATA group by org_id order by org_id;
select distinct org_id, count(org_id) from VIEW_METADATA group by org_id order by org_id;
select distinct org_id, count(org_id) from COLUMN_METADATA group by org_id order by org_id;

-- Power BI queries
select
    org_id,
    iri,
    rdf_type,
    name_id,
    description,
    business_summary,
    data_owner,
    data_steward,
    contact_email,
    program_office,
    technical_steward,
    status,
    restricted_to_public_disclosure,
    data_sharing_agreement_required,
    contains_sensitive_data
from DATABASE_METADATA
where (
    LENGTH(TRIM(description)) > 0 or
    LENGTH(TRIM(business_summary)) > 0 or
    LENGTH(TRIM(data_owner)) > 0 or
    LENGTH(TRIM(data_steward)) > 0 or
    LENGTH(TRIM(contact_email)) > 0 or
    LENGTH(TRIM(program_office)) > 0 or
    LENGTH(TRIM(technical_steward)) > 0 or
    LENGTH(TRIM(status)) > 0 or
    LENGTH(TRIM(restricted_to_public_disclosure)) > 0 or
    LENGTH(TRIM(data_sharing_agreement_required)) > 0 or
    LENGTH(TRIM(contains_sensitive_data)) > 0
);

select
    org_id,
    iri,
    rdf_type,
    name_id,
    description,
    business_summary,
    data_owner,
    data_steward,
    contact_email,
    program_office,
    technical_steward,
    status,
    restricted_to_public_disclosure,
    data_sharing_agreement_required,
    contains_sensitive_data
from SCHEMA_METADATA
where (
    LENGTH(TRIM(description)) > 0 or
    LENGTH(TRIM(business_summary)) > 0 or
    LENGTH(TRIM(data_owner)) > 0 or
    LENGTH(TRIM(data_steward)) > 0 or
    LENGTH(TRIM(contact_email)) > 0 or
    LENGTH(TRIM(program_office)) > 0 or
    LENGTH(TRIM(technical_steward)) > 0 or
    LENGTH(TRIM(status)) > 0 or
    LENGTH(TRIM(restricted_to_public_disclosure)) > 0 or
    LENGTH(TRIM(data_sharing_agreement_required)) > 0 or
    LENGTH(TRIM(contains_sensitive_data)) > 0
);

select
    org_id,
    iri,
    rdf_type,
    name_id,
    description,
    business_summary,
    data_owner,
    data_steward,
    contact_email,
    program_office,
    technical_steward,
    status,
    restricted_to_public_disclosure,
    data_sharing_agreement_required,
    contains_sensitive_data
from TABLE_METADATA
where (
    LENGTH(TRIM(description)) > 0 or
    LENGTH(TRIM(business_summary)) > 0 or
    LENGTH(TRIM(data_owner)) > 0 or
    LENGTH(TRIM(data_steward)) > 0 or
    LENGTH(TRIM(contact_email)) > 0 or
    LENGTH(TRIM(program_office)) > 0 or
    LENGTH(TRIM(technical_steward)) > 0 or
    LENGTH(TRIM(status)) > 0 or
    LENGTH(TRIM(restricted_to_public_disclosure)) > 0 or
    LENGTH(TRIM(data_sharing_agreement_required)) > 0 or
    LENGTH(TRIM(contains_sensitive_data)) > 0
) and org_id='APD';

select
    org_id,
    iri,
    rdf_type,
    name_id,
    description,
    business_summary,
    data_owner,
    data_steward,
    contact_email,
    program_office,
    technical_steward,
    status,
    restricted_to_public_disclosure,
    data_sharing_agreement_required,
    contains_sensitive_data
from VIEW_METADATA
where (
    LENGTH(TRIM(description)) > 0 or
    LENGTH(TRIM(business_summary)) > 0 or
    LENGTH(TRIM(data_owner)) > 0 or
    LENGTH(TRIM(data_steward)) > 0 or
    LENGTH(TRIM(contact_email)) > 0 or
    LENGTH(TRIM(program_office)) > 0 or
    LENGTH(TRIM(technical_steward)) > 0 or
    LENGTH(TRIM(status)) > 0 or
    LENGTH(TRIM(restricted_to_public_disclosure)) > 0 or
    LENGTH(TRIM(data_sharing_agreement_required)) > 0 or
    LENGTH(TRIM(contains_sensitive_data)) > 0
);

select
    org_id,
    iri,
    rdf_type,
    name_id,
    description,
    business_summary,
    data_owner,
    data_steward,
    contact_email,
    program_office,
    technical_steward,
    status,
    restricted_to_public_disclosure,
    data_sharing_agreement_required,
    contains_sensitive_data
from COLUMN_METADATA
where (
    LENGTH(TRIM(description)) > 0 or
    LENGTH(TRIM(business_summary)) > 0 or
    LENGTH(TRIM(data_owner)) > 0 or
    LENGTH(TRIM(data_steward)) > 0 or
    LENGTH(TRIM(contact_email)) > 0 or
    LENGTH(TRIM(program_office)) > 0 or
    LENGTH(TRIM(technical_steward)) > 0 or
    LENGTH(TRIM(status)) > 0 or
    LENGTH(TRIM(restricted_to_public_disclosure)) > 0 or
    LENGTH(TRIM(data_sharing_agreement_required)) > 0 or
    LENGTH(TRIM(contains_sensitive_data)) > 0
);

select * from DATABASE_METADATA where LENGTH(TRIM(business_summary)) > 0;
select * from SCHEMA_METADATA where LENGTH(TRIM(business_summary)) > 0;
select * from TABLE_METADATA where LENGTH(TRIM(restricted_to_public_disclosure)) > 0;
select * from VIEW_METADATA where LENGTH(TRIM(business_summary)) > 0;
select * from COLUMN_METADATA where LENGTH(TRIM(data_sharing_agreement_required)) > 0;
select * from TABLE_METADATA where org_id = 'APD';
