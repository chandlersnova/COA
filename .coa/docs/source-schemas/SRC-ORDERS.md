# ORDERS

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
| O_ORDERKEY | NUMBER(38,0) | NUMBER(38,0) | Yes | Yes | No | SF*1,500,000 are sparsely populated |
| O_CUSTKEY | NUMBER(38,0) | NUMBER(38,0) | Yes | Yes | No | Foreign Key to C_CUSTKEY |
| O_ORDERSTATUS | VARCHAR(1) | VARCHAR(1) | Yes | No | No |  |
| O_TOTALPRICE | NUMBER(12,2) | NUMBER(12,2) | Yes | No | No |  |
| O_ORDERDATE | DATE | DATE | Yes | No | No |  |
| O_ORDERPRIORITY | VARCHAR(15) | VARCHAR(15) | Yes | No | No |  |
| O_CLERK | VARCHAR(15) | VARCHAR(15) | Yes | No | No |  |
| O_SHIPPRIORITY | NUMBER(38,0) | NUMBER(38,0) | Yes | No | No |  |
| O_COMMENT | VARCHAR(79) | VARCHAR(79) | Yes | No | No |  |
