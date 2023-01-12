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
