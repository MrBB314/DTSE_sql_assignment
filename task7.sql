--- Point to parts that could be optimized
--- Feel free to comment any row that you think could be optimize/adjusted in some way!
--- The following query is from SAP HANA but applies to any DB
--- Do not worry if the tables/columns are not familiar to you 
----   -> you do not need to interpret the result (in fact the query does not reflect actual DB content)

--GENERAL OBSERVATIONS
-- - As the first LEFT (OUTER) JOIN is followed by INNER JOINs, it seems to me unnecessary for the first join to be OUTER.

SELECT 
	RSEG.EBELN,
	RSEG.EBELP,
    RSEG.BELNR,
    RSEG.AUGBL AS AUGBL_W,
    LPAD(EKPO.BSART,6,0) as BSART,
	BKPF.GJAHR,
	BSEG.BUKRS,
	BSEG.BUZEI,
	BSEG.BSCHL,
	BSEG.SHKZG,
    CASE WHEN BSEG.SHKZG = 'H' THEN (-1) * BSEG.DMBTR ELSE BSEG.DMBTR END AS DMBTR,
    COALESCE(BSEG.AUFNR, 'Kein SM-A Zuordnung') AS AUFNR,
    COALESCE(LFA1.LAND1, 'Andere') AS LAND1, 
    LFA1.LIFNR,
    LFA1.ZSYSNAME,
    BKPF.BLART as BLART,
    BKPF.BUDAT as BUDAT,
    BKPF.CPUDT as CPUDT
FROM "DTAG_DEV_CSBI_CELONIS_DATA"."dtag.dev.csbi.celonis.data.elog::V_RSEG" AS RSEG
LEFT JOIN "DTAG_DEV_CSBI_CELONIS_WORK"."dtag.dev.csbi.celonis.app.p2p_elog::__P2P_REF_CASES" AS EKPO ON 1=1 
--(1)
-- The additional 1=1 condition makes it easier for the user to add/remove the following conditions and I think it should 
-- not have any impact on execution performance as execution planners of all RDBMSs should be smart enough to ignore it
-- as per e.g. https://stackoverflow.com/questions/1264681/what-is-the-purpose-of-using-where-1-1-in-sql-statements
-- (though this thread relates to where clause).
    AND RSEG.ZSYSNAME = EKPO.SOURCE_SYSTEM
    AND RSEG.MANDT = EKPO.MANDT
    AND RSEG.EBELN || RSEG.EBELP = EKPO.EBELN || EKPO.EBELP 
--(2) 
-- Unless there is a semantic reason for checking the concatenation of these two columns, I would rather split them into 2 conditions
-- AND RSEG.EBELN = EKPO.EBELN
-- AND RSEG.EBELP = EKPO.EBELP
-- which will have almost the same meaning as the above.
INNER JOIN "DTAG_DEV_CSBI_CELONIS_DATA"."dtag.dev.csbi.celonis.data.elog::V_BKPF" AS BKPF ON 1=1 --(1) see above
    AND BKPF.AWKEY = RSEG.AWKEY
    AND RSEG.ZSYSNAME = BKPF.ZSYSNAME
    AND RSEG.MANDT in ('200') --(4) see below
--(3) Unnecessary to use IN statement for 1 value, but I think it should not have impact on execution performance.
--(4) Conditions likes this one can be included in the ON statement, but in case of INNER JOINs it should give the same results
-- as having these conditions in the subsequent WHERE clause. In terms of readability it might be better to have them separately
-- in a WHERE clause? I am not quite sure about the execution performance though.
INNER JOIN "DTAG_DEV_CSBI_CELONIS_DATA"."dtag.dev.csbi.celonis.data.elog::V_BSEG" AS BSEG ON 1=1 --(1) see above
    AND DATS_IS_VALID(BSEG.ZFBDT) = 1 --(4) see above
    AND BSEG.KOART = 'K' --(4) see above
    AND CAST(BSEG.GJAHR AS INT) = 2020 --(4) see above
    AND BKPF.ZSYSNAME = BSEG.ZSYSNAME
    AND BKPF.MANDT = BSEG.MANDT
    AND BKPF.BUKRS = BSEG.BUKRS
    AND BKPF.GJAHR = BSEG.GJAHR
    AND BKPF.BELNR = BSEG.BELNR
    AND BSEG.DMBTR*-1 >= 0 --(4) see above
--(5) is effectively the same as BSEG.DMBTR <= 0, multiplying by "-1" and inverting the operator is just more confusing I think
INNER JOIN (SELECT * FROM "DTAG_DEV_CSBI_CELONIS_DATA"."dtag.dev.csbi.celonis.data.elog::V_LFA1" AS TEMP 
            WHERE TEMP.LIFNR > '020000000') AS LFA1 ON 1=1 --(1) see above
--(6) Using the above subquery seems unnecessarily confusing to me and I suspect it has no benefits in terms of execution perfomance.
-- It includes only one condition in the WHERE clause. Subqueries are executed beforehand, but the FROM and JOIN clauses 
-- are executed as first ones anyway. I think the effect would be the same if this condition was included simply 
-- in the subsequent ON clause (just like all conditions I mention in point (4)).
    AND BSEG.ZSYSNAME = LFA1.ZSYSNAME
    AND BSEG.LIFNR=LFA1.LIFNR
    AND BSEG.MANDT=LFA1.MANDT
    AND LFA1.LAND1 in ('DE','SK') --(4) see above
;