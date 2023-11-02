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

select * from DATABASE_METADATA where "orgId" = 'DMS';
select * from SCHEMA_METADATA where "orgId" = 'DMS';
select * from TABLE_METADATA where "orgId" = 'DMS';
select * from COLUMN_METADATA where "orgId" = 'DMS';
select * from VIEW_METADATA where "orgId" = 'DMS';
select * from VIEW_COLUMN_METADATA where "orgId" = 'DMS';
select * from LINKS_METADATA where orgId = 'DMS';

select "orgId", count(*) from DATABASE_METADATA group by "orgId" order by "orgId";
select "orgId", count(*) from SCHEMA_METADATA group by "orgId" order by "orgId";
select "orgId", count(*) from TABLE_METADATA group by "orgId" order by "orgId";
select "orgId", count(*) from COLUMN_METADATA group by "orgId" order by "orgId";
select "orgId", count(*) from VIEW_METADATA group by "orgId" order by "orgId";
select "orgId", count(*) from VIEW_COLUMN_METADATA group by "orgId" order by "orgId";
select orgid, count(*) from LINKS_METADATA group by orgid order by OrgId;

select "orgId", count(*) from DATABASE_METADATA_PROD group by "orgId" order by "orgId";
select "orgId", count(*) from SCHEMA_METADATA_PROD group by "orgId" order by "orgId";
select "orgId", count(*) from TABLE_METADATA_PROD group by "orgId" order by "orgId";
select "orgId", count(*) from COLUMN_METADATA_PROD group by "orgId" order by "orgId";
select "orgId", count(*) from VIEW_METADATA_PROD group by "orgId" order by "orgId";
select "orgId", count(*) from VIEW_COLUMN_METADATA_PROD group by "orgId" order by "orgId";
select orgid, count(*) from LINKS_METADATA_PROD group by orgid order by OrgId;


-- delete from DATABASE_METADATA where "orgId" = 'DHSMV';
-- delete from SCHEMA_METADATA where "orgId" = 'DHSMV';
-- delete from TABLE_METADATA where "orgId" = 'DHSMV';
-- delete from COLUMN_METADATA where "orgId" = 'DHSMV';
-- delete from VIEW_METADATA where "orgId" = 'DHSMV';
-- delete from VIEW_COLUMN_METADATA where "orgId" = 'DHSMV';
-- delete from LINKS_METADATA where OrgId = 'DHSMV';

select "com.infa.odin.models.relational.PrimaryKeyColumn", count(*)
from COLUMN_METADATA
group by "com.infa.odin.models.relational.PrimaryKeyColumn";

select count(*)
from COLUMN_METADATA
where "com.infa.odin.models.relational.PrimaryKeyColumn" = "core.name";
-- 2185

select count(*)
from COLUMN_METADATA
where "com.infa.odin.models.relational.PrimaryKeyColumn" = 'Yes';


update COLUMN_METADATA_PROD
    set "com.infa.odin.models.relational.PrimaryKeyColumn" = 'Yes'
where
    "com.infa.odin.models.relational.PrimaryKeyColumn" = "core.name";
update COLUMN_METADATA_PROD
    set "com.infa.odin.models.relational.PrimaryKeyColumn" = null
where
    "com.infa.odin.models.relational.PrimaryKeyColumn" <> 'Yes';


select "orgId", count(*) from SCHEMA_METADATA_PROD where "core.name" like '%PF3%' group by "orgId" order by "orgId";
--update SCHEMA_METADATA_PROD set "core.name" = '(unavailable)' where "core.name" like '%PF3%';
select "orgId", count(*) from SCHEMA_METADATA_PROD where "core.name" = '(unavailable)' group by "orgId" order by "orgId";
select * from SCHEMA_METADATA_PROD where "core.name" = '(unavailable)';


select * from COLUMN_METADATA_PROD where "com.infa.odin.models.relational.PrimaryKeyColumn" is not null;
select * from COLUMN_METADATA where "com.infa.odin.models.relational.PrimaryKeyColumn" = 'Yes';
select count(*) from COLUMN_METADATA_PROD where "com.infa.odin.models.relational.PrimaryKeyColumn" is not null;
select count(*) from COLUMN_METADATA_PROD where "com.infa.odin.models.relational.PrimaryKeyColumn" is not null;


-- SELECT COUNT(DISTINCT t1.SOURCE)
-- FROM LINKS_METADATA_PROD t1
--          INNER JOIN VIEW_METADATA_PROD t2
--                     ON t1.SOURCE = t2."core.externalId";
-- 4118

-- SELECT COUNT(DISTINCT t1.TARGET)
-- FROM LINKS_METADATA_PROD t1
--          INNER JOIN VIEW_COLUMN_METADATA_PROD t2
--                     ON t1.TARGET = t2."core.externalId";
--65012

-- create or replace table DATABASE_METADATA_PROD as SELECT * FROM DATABASE_METADATA_BAK where "orgId" <> 'DOE';
-- create or replace table SCHEMA_METADATA_PROD as SELECT * FROM SCHEMA_METADATA_BAK where "orgId" <> 'DOE';
-- create or replace table TABLE_METADATA_PROD as SELECT * FROM TABLE_METADATA_BAK where "orgId" <> 'DOE';
-- create or replace table COLUMN_METADATA_PROD as SELECT * FROM COLUMN_METADATA_BAK where "orgId" <> 'DOE';
-- create or replace table VIEW_METADATA_PROD as SELECT * FROM VIEW_METADATA_BAK where "orgId" <> 'DOE';
-- create or replace table VIEW_COLUMN_METADATA_PROD as SELECT * FROM VIEW_COLUMN_METADATA_BAK where "orgId" <> 'DOE';
-- create or replace table LINKS_METADATA_PROD as SELECT * FROM LINKS_METADATA_BAK where orgId <> 'DOE';

select * from DATABASE_METADATA;
select * from SCHEMA_METADATA;
select * from TABLE_METADATA;
select * from COLUMN_METADATA;
select * from VIEW_METADATA;
select * from VIEW_COLUMN_METADATA;
select * from LINKS_METADATA;

select count(*) from DATABASE_METADATA;
select count(*) from SCHEMA_METADATA;
select count(*) from TABLE_METADATA;
select count(*) from COLUMN_METADATA;
select count(*) from VIEW_METADATA;
select count(*) from VIEW_COLUMN_METADATA;
select count(*) from LINKS_METADATA;


select * from DATABASE_METADATA_PROD;
select * from SCHEMA_METADATA_PROD;
select * from TABLE_METADATA_PROD;
select * from COLUMN_METADATA_PROD;
select * from VIEW_METADATA_PROD;
select * from VIEW_COLUMN_METADATA_PROD;
select * from LINKS_METADATA_PROD;

select count(*) from DATABASE_METADATA_PROD;
select count(*) from SCHEMA_METADATA_PROD;
select count(*) from TABLE_METADATA_PROD;
select count(*) from COLUMN_METADATA_PROD;
select count(*) from LINKS_METADATA_PROD;
select count(*) from VIEW_METADATA_PROD;
select count(*) from VIEW_COLUMN_METADATA_PROD;

-- SELECT t1.*
-- FROM TABLE_METADATA_PROD t1
--          INNER JOIN VIEW_METADATA_PROD t2
--                     ON t1."core.externalId" = t2."core.externalId";
--
-- SELECT t1.*
-- FROM COLUMN_METADATA_PROD t1
--          INNER JOIN VIEW_COLUMN_METADATA_PROD t2
--                     ON t1."core.externalId" = t2."core.externalId";

select distinct "com.infa.odin.models.relational.Datatype" from VIEW_COLUMN_METADATA;

-----------------------------------------------------------
select count(*) from DATABASE_METADATA_PROD where

select *
from TABLE_METADATA
where
    "com.infa.odin.models.relational.Owner" is not null and
    "com.infa.odin.models.relational.Owner" <> '' and
    "orgId" = 'DMS';
-----------------------------------------------------------
select count(*)
from TABLE_METADATA
where
    "custom.data.world.import.dataSteward" is not null and
    "com.infa.odin.models.relational.Owner" is not null;
select distinct "custom.data.world.import.dataSteward" from TABLE_METADATA where "custom.data.world.import.dataSteward" is not null order by "custom.data.world.import.dataSteward";



create or replace table TESTING123
(
    first text,
    second text,
    primaryKey text
);
select * from TESTING123;
insert into TESTING123 (first, second) VALUES ('id', 'id');
insert into TESTING123 (first, second) VALUES ('id1', 'id2');
insert into TESTING123 (first, second) VALUES ('id1', 'id1 id2');
select * from TESTING123 where TESTING123.first <> TESTING123.second;
update TESTING123 set primaryKey = 'Yes' where first = second;
update TESTING123 set primaryKey = null where primaryKey <> 'Yes';
