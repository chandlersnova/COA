# CUSTOMER

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
| C_CUSTKEY | NUMBER(38,0) | NUMBER(38,0) | Yes | No | No | SF*150,000 are populated |
| C_NAME | VARCHAR(25) | VARCHAR(25) | Yes | No | No |  |
| C_ADDRESS | VARCHAR(40) | VARCHAR(40) | Yes | No | No |  |
| C_NATIONKEY | NUMBER(38,0) | NUMBER(38,0) | Yes | No | No | Foreign Key to N_NATIONKEY |
| C_PHONE | VARCHAR(15) | VARCHAR(15) | Yes | No | No |  |
| C_ACCTBAL | NUMBER(12,2) | NUMBER(12,2) | Yes | No | No |  |
| C_MKTSEGMENT | VARCHAR(10) | VARCHAR(10) | Yes | Yes | No |  |
| C_COMMENT | VARCHAR(117) | VARCHAR(117) | Yes | Yes | No |  |
