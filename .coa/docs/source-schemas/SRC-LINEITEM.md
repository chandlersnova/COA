# LINEITEM

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
| L_ORDERKEY | NUMBER(38,0) | NUMBER(38,0) | Yes | No | No | Foreign Key to O_ORDERKEY |
| L_PARTKEY | NUMBER(38,0) | NUMBER(38,0) | Yes | No | No | Foreign key to P_PARTKEY, first part of the compound Foreign Key to (PS_PARTKEY, PS_SUPPKEY) with L_SUPPKEY |
| L_SUPPKEY | NUMBER(38,0) | NUMBER(38,0) | Yes | No | No | Foreign key to S_SUPPKEY, second part of the compound Foreign Key to (PS_PARTKEY,  TPC BenchmarkTM H Standard Specification Revision 2.17.1 Page 17 PS_SUPPKEY) with L_PARTKEY |
| L_LINENUMBER | NUMBER(38,0) | NUMBER(38,0) | Yes | No | No |  |
| L_QUANTITY | NUMBER(12,2) | NUMBER(12,2) | Yes | No | No |  |
| L_EXTENDEDPRICE | NUMBER(12,2) | NUMBER(12,2) | Yes | No | No |  |
| L_DISCOUNT | NUMBER(12,2) | NUMBER(12,2) | Yes | No | No |  |
| L_TAX | NUMBER(12,2) | NUMBER(12,2) | Yes | No | No |  |
| L_RETURNFLAG | VARCHAR(1) | VARCHAR(1) | Yes | No | No |  |
| L_LINESTATUS | VARCHAR(1) | VARCHAR(1) | Yes | No | No |  |
| L_SHIPDATE | DATE | DATE | Yes | No | No |  |
| L_COMMITDATE | DATE | DATE | Yes | No | No |  |
| L_RECEIPTDATE | DATE | DATE | Yes | No | No |  |
| L_SHIPINSTRUCT | VARCHAR(25) | VARCHAR(25) | Yes | No | No |  |
| L_SHIPMODE | VARCHAR(10) | VARCHAR(10) | Yes | No | No |  |
| L_COMMENT | VARCHAR(44) | VARCHAR(44) | Yes | No | No |  |
