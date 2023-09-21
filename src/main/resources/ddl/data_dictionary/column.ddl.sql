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