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
    "custom.data.world.import.technicalSteward" text,
    "custom.data.world.import.dataOwner" text
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
    "custom.data.world.import.technicalSteward" text,
    "custom.data.world.import.dataOwner" text
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
    "custom.data.world.import.status" text,
    "custom.data.world.import.dataOwner" text
);
create or replace table VIEW_COLUMN_METADATA
(
    "orgId" text,
    "core.externalId" text,
    "core.name" text,
    "core.description" text,
    "com.infa.odin.models.relational.Datatype" text,
    "com.infa.odin.models.relational.DatatypeLength" text,
    "com.infa.odin.models.relational.Nullable" text,
    "com.infa.odin.models.relational.Position" text,
    "custom.data.world.import.businessSummary" text,
    "custom.data.world.import.sensitiveData" text,
    "custom.data.world.import.dataSteward" text,
    "custom.data.world.import.status" text,
    "custom.data.world.import.restrictedToPublic" text,
    "custom.data.world.import.technicalSteward" text,
    "custom.data.world.import.dataOwner" text
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

select count(*) from DATABASE_METADATA;
select count(*) from SCHEMA_METADATA;
select count(*) from TABLE_METADATA;
select count(*) from COLUMN_METADATA;
select count(*) from VIEW_METADATA;
select count(*) from VIEW_COLUMN_METADATA;
select count(*) from LINKS_METADATA;

select * from DATABASE_METADATA;
select * from SCHEMA_METADATA;
select * from TABLE_METADATA;
select * from COLUMN_METADATA;
select * from VIEW_METADATA;
select * from VIEW_COLUMN_METADATA;
select * from LINKS_METADATA;

select * from DATABASE_METADATA_BAK;
select * from SCHEMA_METADATA_BAK;
select * from TABLE_METADATA_BAK;
select * from COLUMN_METADATA_BAK;
select * from VIEW_METADATA_BAK;
select * from VIEW_COLUMN_METADATA_BAK;
select * from LINKS_METADATA_BAK;

-- truncate table DATABASE_METADATA_BAK;
-- truncate table SCHEMA_METADATA_BAK;
-- truncate table TABLE_METADATA_BAK;
-- truncate table COLUMN_METADATA_BAK;
-- truncate table VIEW_METADATA_BAK;
-- truncate table VIEW_COLUMN_METADATA_BAK;
-- truncate table LINKS_METADATA_BAK;

INSERT INTO DATABASE_METADATA_BAK (
    "orgId",
    "core.externalId",
    "core.name",
    "custom.data.world.import.jdbcURL",
    "custom.data.world.import.databaseServer",
    "custom.data.world.import.databasePort"
) SELECT
    "orgId",
    "core.externalId",
    "core.name",
    "custom.data.world.import.jdbcURL",
    "custom.data.world.import.databaseServer",
    "custom.data.world.import.databasePort"
FROM DATABASE_METADATA
WHERE "orgId"='DOH';

INSERT INTO SCHEMA_METADATA_BAK (
    "orgId",
    "core.externalId",
    "core.name",
    "core.description",
    "com.infa.odin.models.relational.Comment",
    "com.infa.odin.models.relational.Owner"
) SELECT
      "orgId",
      "core.externalId",
      "core.name",
      "core.description",
      "com.infa.odin.models.relational.Comment",
      "com.infa.odin.models.relational.Owner"
FROM SCHEMA_METADATA
WHERE "orgId"='DOH';

INSERT INTO TABLE_METADATA_BAK (
    "orgId",
    "core.externalId",
    "core.name",
    "core.description",
    "com.infa.odin.models.relational.Owner",
    "custom.data.world.import.businessSummary",
    "custom.data.world.import.contactEmail",
    "custom.data.world.import.dataSharingAgreement",
    "custom.data.world.import.dataSteward",
    "custom.data.world.import.programOffice",
    "custom.data.world.import.restrictedToPublic",
    "custom.data.world.import.sensitiveData",
    "custom.data.world.import.status",
    "com.infa.odin.models.relational.TableType",
    "custom.data.world.import.technicalSteward",
    "custom.data.world.import.dataOwner"
) SELECT
      "orgId",
      "core.externalId",
      "core.name",
      "core.description",
      "com.infa.odin.models.relational.Owner",
      "custom.data.world.import.businessSummary",
      "custom.data.world.import.contactEmail",
      "custom.data.world.import.dataSharingAgreement",
      "custom.data.world.import.dataSteward",
      "custom.data.world.import.programOffice",
      "custom.data.world.import.restrictedToPublic",
      "custom.data.world.import.sensitiveData",
      "custom.data.world.import.status",
      "com.infa.odin.models.relational.TableType",
      "custom.data.world.import.technicalSteward",
      "custom.data.world.import.dataOwner"
FROM TABLE_METADATA
WHERE "orgId"='DOH';

INSERT INTO COLUMN_METADATA_BAK (
    "orgId",
    "core.externalId",
    "custom.data.world.import.businessSummary",
    "custom.data.world.import.dataSteward",
    "com.infa.odin.models.relational.Datatype",
    "com.infa.odin.models.relational.DatatypeLength",
    "core.description",
    "core.name",
    "com.infa.odin.models.relational.PrimaryKeyColumn",
    "com.infa.odin.models.relational.Nullable",
    "com.infa.odin.models.relational.Position",
    "custom.data.world.import.restrictedToPublic",
    "custom.data.world.import.sensitiveData",
    "custom.data.world.import.status",
    "custom.data.world.import.technicalSteward",
    "custom.data.world.import.dataOwner"
) SELECT
      "orgId",
      "core.externalId",
      "custom.data.world.import.businessSummary",
      "custom.data.world.import.dataSteward",
      "com.infa.odin.models.relational.Datatype",
      "com.infa.odin.models.relational.DatatypeLength",
      "core.description",
      "core.name",
      "com.infa.odin.models.relational.PrimaryKeyColumn",
      "com.infa.odin.models.relational.Nullable",
      "com.infa.odin.models.relational.Position",
      "custom.data.world.import.restrictedToPublic",
      "custom.data.world.import.sensitiveData",
      "custom.data.world.import.status",
      "custom.data.world.import.technicalSteward",
      "custom.data.world.import.dataOwner"
FROM COLUMN_METADATA
WHERE "orgId"='DOH';

INSERT INTO VIEW_METADATA_BAK (
    "orgId",
    "core.externalId",
    "core.name",
    "core.description",
    "com.infa.odin.models.relational.Owner",
    "com.infa.odin.models.relational.ViewType",
    "custom.data.world.import.businessSummary",
    "custom.data.world.import.restrictedToPublic",
    "custom.data.world.import.sensitiveData",
    "custom.data.world.import.dataSharingAgreement",
    "custom.data.world.import.programOffice",
    "custom.data.world.import.dataSteward",
    "custom.data.world.import.technicalSteward",
    "custom.data.world.import.contactEmail",
    "custom.data.world.import.status",
    "custom.data.world.import.dataOwner"
) SELECT
      "orgId",
      "core.externalId",
      "core.name",
      "core.description",
      "com.infa.odin.models.relational.Owner",
      "com.infa.odin.models.relational.ViewType",
      "custom.data.world.import.businessSummary",
      "custom.data.world.import.restrictedToPublic",
      "custom.data.world.import.sensitiveData",
      "custom.data.world.import.dataSharingAgreement",
      "custom.data.world.import.programOffice",
      "custom.data.world.import.dataSteward",
      "custom.data.world.import.technicalSteward",
      "custom.data.world.import.contactEmail",
      "custom.data.world.import.status",
      "custom.data.world.import.dataOwner"
FROM VIEW_METADATA
WHERE "orgId"='DOH';

INSERT INTO VIEW_COLUMN_METADATA_BAK (
    "orgId",
    "core.externalId",
    "core.name",
    "core.description",
    "com.infa.odin.models.relational.Datatype",
    "com.infa.odin.models.relational.DatatypeLength",
    "com.infa.odin.models.relational.Nullable",
    "com.infa.odin.models.relational.Position",
    "custom.data.world.import.businessSummary",
    "custom.data.world.import.sensitiveData",
    "custom.data.world.import.dataSteward",
    "custom.data.world.import.status",
    "custom.data.world.import.restrictedToPublic",
    "custom.data.world.import.technicalSteward",
    "custom.data.world.import.dataOwner"
) SELECT
      "orgId",
      "core.externalId",
      "core.name",
      "core.description",
      "com.infa.odin.models.relational.Datatype",
      "com.infa.odin.models.relational.DatatypeLength",
      "com.infa.odin.models.relational.Nullable",
      "com.infa.odin.models.relational.Position",
      "custom.data.world.import.businessSummary",
      "custom.data.world.import.sensitiveData",
      "custom.data.world.import.dataSteward",
      "custom.data.world.import.status",
      "custom.data.world.import.restrictedToPublic",
      "custom.data.world.import.technicalSteward",
      "custom.data.world.import.dataOwner"
FROM VIEW_COLUMN_METADATA
WHERE "orgId"='DOH';

INSERT INTO LINKS_METADATA_BAK
(
    ORGID,
    SOURCE,
    TARGET,
    ASSOCIATION
) SELECT
    ORGID,
    SOURCE,
    TARGET,
    ASSOCIATION
FROM LINKS_METADATA
WHERE ORGID='DOH';


select "orgId", count(*) from DATABASE_METADATA group by "orgId" order by "orgId";
select "orgId", count(*) from SCHEMA_METADATA group by "orgId" order by "orgId";
select "orgId", count(*) from TABLE_METADATA group by "orgId" order by "orgId";
select "orgId", count(*) from COLUMN_METADATA group by "orgId" order by "orgId";
select "orgId", count(*) from VIEW_METADATA group by "orgId" order by "orgId";
select "orgId", count(*) from VIEW_COLUMN_METADATA group by "orgId" order by "orgId";
select orgid, count(*) from LINKS_METADATA group by orgid order by OrgId;

select "orgId", count(*) from DATABASE_METADATA_BAK group by "orgId" order by "orgId";
select "orgId", count(*) from SCHEMA_METADATA_BAK group by "orgId" order by "orgId";
select "orgId", count(*) from TABLE_METADATA_BAK group by "orgId" order by "orgId";
select "orgId", count(*) from COLUMN_METADATA_BAK group by "orgId" order by "orgId";
select "orgId", count(*) from VIEW_METADATA_BAK group by "orgId" order by "orgId";
select "orgId", count(*) from VIEW_COLUMN_METADATA_BAK group by "orgId" order by "orgId";
select orgid, count(*) from LINKS_METADATA_BAK group by orgid order by OrgId;

-- create or replace table DATABASE_METADATA_PROD as SELECT * FROM DATABASE_METADATA_BAK;
-- create or replace table SCHEMA_METADATA_PROD as SELECT * FROM SCHEMA_METADATA_BAK;
-- create or replace table TABLE_METADATA_PROD as SELECT * FROM TABLE_METADATA_BAK;
-- create or replace table COLUMN_METADATA_PROD as SELECT * FROM COLUMN_METADATA_BAK;
-- create or replace table VIEW_METADATA_PROD as SELECT * FROM VIEW_METADATA_BAK;
-- create or replace table VIEW_COLUMN_METADATA_PROD as SELECT * FROM VIEW_COLUMN_METADATA_BAK;
-- create or replace table LINKS_METADATA_PROD as SELECT * FROM LINKS_METADATA_BAK;

select "orgId", count(*) from DATABASE_METADATA_PROD group by "orgId" order by "orgId";
select "orgId", count(*) from SCHEMA_METADATA_PROD group by "orgId" order by "orgId";
select "orgId", count(*) from TABLE_METADATA_PROD group by "orgId" order by "orgId";
select "orgId", count(*) from COLUMN_METADATA_PROD group by "orgId" order by "orgId";
select "orgId", count(*) from VIEW_METADATA_PROD group by "orgId" order by "orgId";
select "orgId", count(*) from VIEW_COLUMN_METADATA_PROD group by "orgId" order by "orgId";
select orgid, count(*) from LINKS_METADATA_PROD group by orgid order by OrgId;

select * from DATABASE_METADATA_PROD where "orgId"='DOR';
select * from SCHEMA_METADATA_PROD where "orgId"='DOR';
select * from TABLE_METADATA_PROD where "orgId"='DOR';
select * from COLUMN_METADATA_PROD where "orgId"='DOR';
select * from VIEW_METADATA_PROD where "orgId"='DOR';
select * from VIEW_COLUMN_METADATA_PROD where "orgId"='DOR';
select * from LINKS_METADATA_PROD where orgId='DOR';

select count(*) from DATABASE_METADATA_PROD;
select count(*) from SCHEMA_METADATA_PROD;
select count(*) from TABLE_METADATA_PROD;
select count(*) from COLUMN_METADATA_PROD;
select count(*) from VIEW_METADATA_PROD;
select count(*) from VIEW_COLUMN_METADATA_PROD;
select count(*) from LINKS_METADATA_PROD;


SELECT "orgId", count(*) FROM DATABASE_METADATA_DUPLICATES group by "orgId";
SELECT "orgId", count(*) FROM SCHEMA_METADATA_DUPLICATES group by "orgId";
SELECT "orgId", count(*) FROM TABLE_METADATA_DUPLICATES group by "orgId";
SELECT "orgId", count(*) FROM COLUMN_METADATA_DUPLICATES group by "orgId";
SELECT "orgId", count(*) FROM VIEW_METADATA_DUPLICATES group by "orgId";
SELECT "orgId", count(*) FROM VIEW_COLUMN_METADATA_DUPLICATES group by "orgId";

SELECT * FROM DATABASE_METADATA_DUPLICATES;
SELECT * FROM SCHEMA_METADATA_DUPLICATES;
SELECT * FROM TABLE_METADATA_DUPLICATES;
SELECT * FROM COLUMN_METADATA_DUPLICATES;
SELECT * FROM VIEW_METADATA_DUPLICATES;
SELECT * FROM VIEW_COLUMN_METADATA_DUPLICATES;

SELECT COUNT(*) FROM DATABASE_METADATA_DUPLICATES;
SELECT COUNT(*) FROM SCHEMA_METADATA_DUPLICATES;
SELECT COUNT(*) FROM TABLE_METADATA_DUPLICATES;
SELECT COUNT(*) FROM COLUMN_METADATA_DUPLICATES;
SELECT COUNT(*) FROM VIEW_METADATA_DUPLICATES;
SELECT COUNT(*) FROM VIEW_COLUMN_METADATA_DUPLICATES;

SELECT "orgId", count(*) FROM DATABASE_METADATA_DUPLICATES_BAK group by "orgId";
SELECT "orgId", count(*) FROM SCHEMA_METADATA_DUPLICATES_BAK group by "orgId";
SELECT "orgId", count(*) FROM TABLE_METADATA_DUPLICATES_BAK group by "orgId";
SELECT "orgId", count(*) FROM COLUMN_METADATA_DUPLICATES_BAK group by "orgId";
SELECT "orgId", count(*) FROM VIEW_METADATA_DUPLICATES_BAK group by "orgId";
SELECT "orgId", count(*) FROM VIEW_COLUMN_METADATA_DUPLICATES_BAK group by "orgId";

-- create or replace table DATABASE_METADATA_DUPLICATES_BAK as SELECT * FROM DATABASE_METADATA_DUPLICATES;
-- create or replace table SCHEMA_METADATA_DUPLICATES_BAK as SELECT * FROM SCHEMA_METADATA_DUPLICATES;
-- create or replace table TABLE_METADATA_DUPLICATES_BAK as SELECT * FROM TABLE_METADATA_DUPLICATES;
-- create or replace table COLUMN_METADATA_DUPLICATES_BAK as SELECT * FROM COLUMN_METADATA_DUPLICATES;
-- create or replace table VIEW_METADATA_DUPLICATES_BAK as SELECT * FROM VIEW_METADATA_DUPLICATES;
-- create or replace table VIEW_COLUMN_METADATA_DUPLICATES_BAK as SELECT * FROM VIEW_COLUMN_METADATA_DUPLICATES;

SELECT * FROM DATABASE_METADATA_DUPLICATES_BAK;
SELECT * FROM SCHEMA_METADATA_DUPLICATES_BAK;
SELECT * FROM TABLE_METADATA_DUPLICATES_BAK;
SELECT * FROM COLUMN_METADATA_DUPLICATES_BAK;
SELECT * FROM VIEW_METADATA_DUPLICATES_BAK;
SELECT * FROM VIEW_COLUMN_METADATA_DUPLICATES_BAK;

-- Scratch:
desc table VIEW_METADATA_DUPLICATES_BAK;
desc table VIEW_METADATA_DUPLICATES;

-- select "core.externalId", count(*) from COLUMN_METADATA group by "core.externalId" having count(*) > 1;
-- select "core.externalId", count(*) from VIEW_COLUMN_METADATA group by "core.externalId" having count(*) > 1;
-- select * from COLUMN_METADATA where "core.externalId" = 'col.7f9e2096a07913364f259753b0a8ac61';
-- select SOURCE, Target, count(*) from LINKS_METADATA group by SOURCE, Target having count(*) > 1;
-- select * from LINKS_METADATA where SOURCE = 'tbl.ad87c804fa677436b6486b6a25872a6e' or Target = 'tbl.ad87c804fa677436b6486b6a25872a6e';
--col.7f9e2096a07913364f259753b0a8ac61
--tbl.ad87c804fa677436b6486b6a25872a6e


-- select * from TABLE_METADATA where "core.name" = 'TMP_20200918_LOAD_DOB';
-- select * from COLUMN_METADATA where "core.description" like '%,%';
-- select * from LINKS_METADATA where Source = 'sch.72624a0ca14946ee918a4f916f435b09';
-- select distinct OrgId from LINKS_METADATA;
-- select * from COLUMN_METADATA where "com.infa.odin.models.relational.PrimaryKeyColumn" is not null;
-- select * from COLUMN_METADATA where "com.infa.odin.models.relational.PrimaryKeyColumn" = "core.name" order by "core.name" ;
-- select COUNT(DISTINCT SOURCE) from LINKS_METADATA_BAK WHERE orgId = 'DMS' and ASSOCIATION = 'com.infa.odin.models.relational.ViewToViewColumn';
-- update COLUMN_METADATA set "com.infa.odin.models.relational.PrimaryKeyColumn" = 'Yes' where "com.infa.odin.models.relational.PrimaryKeyColumn" = "core.name";
-- update COLUMN_METADATA set "com.infa.odin.models.relational.PrimaryKeyColumn" = null where "com.infa.odin.models.relational.PrimaryKeyColumn" <> 'Yes';
-- select * from COLUMN_METADATA where "com.infa.odin.models.relational.PrimaryKeyColumn" is not null;
-- select count(*) from COLUMN_METADATA;
-- select count(*) from COLUMN_METADATA_BAK;

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

-- select * from TABLE_METADATA WHERE "core.description" like '%,%';
--
-- select distinct "custom.data.world.import.sensitiveData" from VIEW_METADATA_BAK;
-- select distinct "custom.data.world.import.sensitiveData" from VIEW_COLUMN_METADATA_BAK;
-- select distinct "custom.data.world.import.restrictedToPublic" from VIEW_METADATA_BAK;
-- select distinct "custom.data.world.import.restrictedToPublic" from VIEW_COLUMN_METADATA_BAK;


-- TRUNCATE TABLE DATABASE_METADATA_DUPLICATES;
-- TRUNCATE TABLE SCHEMA_METADATA_DUPLICATES;
-- TRUNCATE TABLE TABLE_METADATA_DUPLICATES;
-- TRUNCATE TABLE COLUMN_METADATA_DUPLICATES;
-- TRUNCATE TABLE VIEW_METADATA_DUPLICATES;
-- TRUNCATE TABLE VIEW_COLUMN_METADATA_DUPLICATES;

-- TRUNCATE TABLE DATABASE_METADATA_DUPLICATES_BAK;
-- TRUNCATE TABLE SCHEMA_METADATA_DUPLICATES_BAK;
-- TRUNCATE TABLE TABLE_METADATA_DUPLICATES_BAK;
-- TRUNCATE TABLE COLUMN_METADATA_DUPLICATES_BAK;
-- TRUNCATE TABLE VIEW_METADATA_DUPLICATES_BAK;
-- TRUNCATE TABLE VIEW_COLUMN_METADATA_DUPLICATES_BAK;


SELECT t1.*
FROM TABLE_METADATA_BAK t1
         INNER JOIN VIEW_METADATA_BAK t2
                    ON t1."core.externalId" = t2."core.externalId";
--
SELECT t1.*
FROM COLUMN_METADATA_BAK t1
         INNER JOIN VIEW_COLUMN_METADATA_BAK t2
                    ON t1."core.externalId" = t2."core.externalId";

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


SELECT
    A.orgId,
    (SELECT COUNT(*) FROM SCHEMA_METADATA_PROD B WHERE A.orgId = B."orgId") SCHEMA_CNT,
    (SELECT COUNT(*) FROM TABLE_METADATA_PROD C WHERE A.orgId = C."orgId") TABLE_CNT,
    (SELECT COUNT(*) FROM VIEW_METADATA_PROD D WHERE A.orgId = D."orgId") VIEW_CNT,
    (SELECT COUNT(*) FROM COLUMN_METADATA_PROD E WHERE A.orgId = E."orgId") COLUMN_CNT,
    (SELECT COUNT(*) FROM VIEW_COLUMN_METADATA_PROD F WHERE A.orgId = F."orgId") VIEW_COL_CNT,
    (SELECT COUNT(*) FROM DATABASE_METADATA_PROD G WHERE A.orgId = G."orgId") DB_CNT,
    COUNT(*) LINKS_CNT
FROM LINKS_METADATA_PROD A
WHERE A.orgID='DOR'
GROUP BY A.orgId
ORDER BY A.orgId;

SELECT
    A.orgId,
    (SELECT COUNT(*) FROM SCHEMA_METADATA_DUPLICATES B WHERE A.orgId = B."orgId") SCHEMA_CNT,
    (SELECT COUNT(*) FROM TABLE_METADATA_DUPLICATES C WHERE A.orgId = C."orgId") TABLE_CNT,
    (SELECT COUNT(*) FROM VIEW_METADATA_DUPLICATES D WHERE A.orgId = D."orgId") VIEW_CNT,
    (SELECT COUNT(*) FROM COLUMN_METADATA_DUPLICATES E WHERE A.orgId = E."orgId") COLUMN_CNT,
    (SELECT COUNT(*) FROM VIEW_COLUMN_METADATA_DUPLICATES F WHERE A.orgId = F."orgId") VIEW_COL_CNT,
    (SELECT COUNT(*) FROM DATABASE_METADATA_DUPLICATES G WHERE A.orgId = G."orgId") DB_CNT
FROM LINKS_METADATA_PROD A
GROUP BY A.orgId
ORDER BY A.orgId;