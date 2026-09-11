@id("4abf6f30-24b7-4a9a-bae6-bfc36dd11dd7")
@nodeType("SQLNodes:::707")
SELECT
     "P_PARTKEY" AS "P_PARTKEY",
     "P_NAME" AS "P_NAME",
     "P_MFGR" AS "P_MFGR",
     "P_BRAND" AS "P_BRAND",
     "P_TYPE" AS "P_TYPE",
     "P_SIZE" AS "P_SIZE",
     "P_CONTAINER" AS "P_CONTAINER",
     "P_RETAILPRICE" AS "P_RETAILPRICE",
     "P_COMMENT" AS "P_COMMENT"
FROM {{ ref('SRC', 'PART') }} "PART"