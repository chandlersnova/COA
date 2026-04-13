# SUPPLIER

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
| S_SUPPKEY | NUMBER(38,0) | NUMBER(38,0) | Yes | No | No | SF*10,000 are populated |
| S_NAME | VARCHAR(25) | VARCHAR(25) | Yes | No | No |  |
| S_ADDRESS | VARCHAR(40) | VARCHAR(40) | Yes | No | No |  |
| S_NATIONKEY | NUMBER(38,0) | NUMBER(38,0) | Yes | No | No | Foreign Key to N_NATIONKEY |
| S_PHONE | VARCHAR(15) | VARCHAR(15) | Yes | No | No |  |
| S_ACCTBAL | NUMBER(12,2) | NUMBER(12,2) | Yes | No | No |  |
| S_COMMENT | VARCHAR(101) | VARCHAR(101) | Yes | Yes | No |  |
