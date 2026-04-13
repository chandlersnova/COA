# PARTSUPP

## Overview

| Property | Value |
| --- | --- |
| **Location** | SRC |
| **Database** | CHANDLER_DB |
| **Schema** | TEST_SOURCE |
| **Kind** | TABLE |
| **Source Node Defined** | Yes |

## Columns (Actual vs Defined)

| Column | Snowflake Type | Defined Type | Match | Nullable | PK | Comment |
| --- | --- | --- | --- | --- | --- | --- |
| PS_PARTKEY | NUMBER(38,0) | NUMBER(38,0) | Yes | No | No | Foreign Key to P_PARTKEY |
| PS_SUPPKEY | NUMBER(38,0) | NUMBER(38,0) | Yes | No | No | Foreign Key to S_SUPPKEY |
| PS_AVAILQTY | NUMBER(38,0) | NUMBER(38,0) | Yes | No | No |  |
| PS_SUPPLYCOST | NUMBER(12,2) | NUMBER(12,2) | Yes | No | No |  |
| PS_COMMENT | VARCHAR(199) | VARCHAR(199) | Yes | Yes | No |  |
