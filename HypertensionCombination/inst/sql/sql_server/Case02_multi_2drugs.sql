{DEFAULT @CDM_schema = 'Alligator_CDM4_All'}
{DEFAULT @HTN_Combi = 'SJ_HTN_combi'}
{DEFAULT @HTN_Combi_code = 'Chan_HTN_Combi'}

USE [@HTN_combi];

-- LIST UP ALL THE DATES OF DATE RANGE IN DRUG_HISTORY_S7D_G14D_C90D
--(6773 row(s) affected)
IF OBJECT_ID('[@HTN_combi].[dbo].ALL_DATES', 'U') IS NOT NULL
	DROP TABLE ALL_DATES;
WITH
DATERANGE(MIN_DATE,MAX_DATE)
AS(
	SELECT MIN(MIN_START_DATE) MIN_DATE, MAX(LAST_FU_DATE) MAX_DATE
	FROM DRUG_HISTORY_S7D_G14D_C90D_FU
),
ALLDATES AS (
	SELECT (SELECT MIN_DATE FROM DATERANGE) AS DATES, 1 AS SEQ
	UNION ALL
	SELECT DATEADD(DAY, 1, DATES), SEQ + 1
	FROM ALLDATES
	WHERE DATES < (SELECT MAX_DATE FROM DATERANGE)
)
SELECT	*
INTO ALL_DATES
FROM ALLDATES
OPTION (MAXRECURSION 0)

SELECT * FROM ALL_DATES

-- OVERLAP DATE OF DRUG A AND DRUG B
--(6268066 row(s) affected)
IF OBJECT_ID('[@HTN_combi].[dbo].OVERLAP_DATE_AB', 'U') IS NOT NULL
	DROP TABLE OVERLAP_DATE_AB;
SELECT A.DATES, B.PERSON_ID, B.LAST_FU_DATE
	, B.DRUG_CLASS_SIMPLE DRUG_CLASS_SIMPLE_1, B.DRUG_FU_SEQ DRUG_FU_SEQ_1
	, C.DRUG_CLASS_SIMPLE DRUG_CLASS_SIMPLE_2, C.DRUG_FU_SEQ DRUG_FU_SEQ_2
INTO OVERLAP_DATE_AB
FROM ALL_DATES A
	INNER JOIN (
		SELECT PERSON_ID, DRUG_CLASS_SIMPLE, MIN_START_DATE, MAX_END_DATE, LAST_FU_DATE, DRUG_FU_SEQ FROM DRUG_HISTORY_S7D_G14D_C90D_FU WHERE DRUG_CLASS_SIMPLE IN ('A')
	) B
	ON A.DATES BETWEEN B.MIN_START_DATE AND B.MAX_END_DATE
	INNER JOIN (
		SELECT PERSON_ID, DRUG_CLASS_SIMPLE, MIN_START_DATE, MAX_END_DATE, LAST_FU_DATE, DRUG_FU_SEQ FROM DRUG_HISTORY_S7D_G14D_C90D_FU WHERE DRUG_CLASS_SIMPLE IN ('B')
	) C
	ON B.PERSON_ID = C.PERSON_ID
		AND A.DATES BETWEEN C.MIN_START_DATE AND C.MAX_END_DATE

SELECT * FROM OVERLAP_DATE_AB ORDER BY PERSON_ID, DATES, DRUG_CLASS_SIMPLE_1, DRUG_FU_SEQ_1, DRUG_CLASS_SIMPLE_2, DRUG_FU_SEQ_2

-- OVERLAP DATE OF DRUG A AND DRUG C
--(13156317 row(s) affected)
IF OBJECT_ID('[@HTN_combi].[dbo].OVERLAP_DATE_AC', 'U') IS NOT NULL
	DROP TABLE OVERLAP_DATE_AC;
SELECT A.DATES, B.PERSON_ID, B.LAST_FU_DATE
	, B.DRUG_CLASS_SIMPLE DRUG_CLASS_SIMPLE_1, B.DRUG_FU_SEQ DRUG_FU_SEQ_1
	, C.DRUG_CLASS_SIMPLE DRUG_CLASS_SIMPLE_2, C.DRUG_FU_SEQ DRUG_FU_SEQ_2
INTO OVERLAP_DATE_AC
FROM ALL_DATES A
	INNER JOIN (
		SELECT PERSON_ID, DRUG_CLASS_SIMPLE, MIN_START_DATE, MAX_END_DATE, LAST_FU_DATE, DRUG_FU_SEQ FROM DRUG_HISTORY_S7D_G14D_C90D_FU WHERE DRUG_CLASS_SIMPLE IN ('A')
	) B
	ON A.DATES BETWEEN B.MIN_START_DATE AND B.MAX_END_DATE
	INNER JOIN (
		SELECT PERSON_ID, DRUG_CLASS_SIMPLE, MIN_START_DATE, MAX_END_DATE, LAST_FU_DATE, DRUG_FU_SEQ FROM DRUG_HISTORY_S7D_G14D_C90D_FU WHERE DRUG_CLASS_SIMPLE IN ('C')
	) C
	ON B.PERSON_ID = C.PERSON_ID
		AND A.DATES BETWEEN C.MIN_START_DATE AND C.MAX_END_DATE

SELECT * FROM OVERLAP_DATE_AC ORDER BY PERSON_ID, DATES, DRUG_CLASS_SIMPLE_1, DRUG_FU_SEQ_1, DRUG_CLASS_SIMPLE_2, DRUG_FU_SEQ_2

-- OVERLAP DATE OF DRUG A AND DRUG D
--(15608438 row(s) affected)
IF OBJECT_ID('[@HTN_combi].[dbo].OVERLAP_DATE_AD', 'U') IS NOT NULL
	DROP TABLE OVERLAP_DATE_AD;
SELECT A.DATES, B.PERSON_ID, B.LAST_FU_DATE
	, B.DRUG_CLASS_SIMPLE DRUG_CLASS_SIMPLE_1, B.DRUG_FU_SEQ DRUG_FU_SEQ_1
	, C.DRUG_CLASS_SIMPLE DRUG_CLASS_SIMPLE_2, C.DRUG_FU_SEQ DRUG_FU_SEQ_2
INTO OVERLAP_DATE_AD
FROM ALL_DATES A
	INNER JOIN (
		SELECT PERSON_ID, DRUG_CLASS_SIMPLE, MIN_START_DATE, MAX_END_DATE, LAST_FU_DATE, DRUG_FU_SEQ FROM DRUG_HISTORY_S7D_G14D_C90D_FU WHERE DRUG_CLASS_SIMPLE IN ('A')
	) B
	ON A.DATES BETWEEN B.MIN_START_DATE AND B.MAX_END_DATE
	INNER JOIN (
		SELECT PERSON_ID, DRUG_CLASS_SIMPLE, MIN_START_DATE, MAX_END_DATE, LAST_FU_DATE, DRUG_FU_SEQ FROM DRUG_HISTORY_S7D_G14D_C90D_FU WHERE DRUG_CLASS_SIMPLE IN ('D')
	) C
	ON B.PERSON_ID = C.PERSON_ID
		AND A.DATES BETWEEN C.MIN_START_DATE AND C.MAX_END_DATE

SELECT * FROM OVERLAP_DATE_AD ORDER BY PERSON_ID, DATES, DRUG_CLASS_SIMPLE_1, DRUG_FU_SEQ_1, DRUG_CLASS_SIMPLE_2, DRUG_FU_SEQ_2

-- MULTI DRUG DATE OF DRUG A AND DRUG B
--(14682 row(s) affected)
IF OBJECT_ID('[@HTN_combi].[dbo].MULTI_2_DRUG_DATE_AB', 'U') IS NOT NULL
	DROP TABLE MULTI_2_DRUG_DATE_AB;
SELECT PERSON_ID, LAST_FU_DATE, DRUG_CLASS_SIMPLE_1, DRUG_FU_SEQ_1, DRUG_CLASS_SIMPLE_2, DRUG_FU_SEQ_2
	, MIN(DATES) MIN_DATE
	, MAX(DATES) MAX_DATE
INTO MULTI_2_DRUG_DATE_AB
FROM OVERLAP_DATE_AB
GROUP BY PERSON_ID, LAST_FU_DATE, DRUG_CLASS_SIMPLE_1, DRUG_FU_SEQ_1, DRUG_CLASS_SIMPLE_2, DRUG_FU_SEQ_2
--ORDER BY PERSON_ID, DRUG_CLASS_SIMPLE_1, DRUG_FU_SEQ_1, DRUG_CLASS_SIMPLE_2, DRUG_FU_SEQ_2

SELECT * FROM MULTI_2_DRUG_DATE_AB ORDER BY PERSON_ID, DRUG_CLASS_SIMPLE_1, DRUG_FU_SEQ_1, DRUG_CLASS_SIMPLE_2, DRUG_FU_SEQ_2

-- MULTI DRUG DATE OF DRUG A AND DRUG C
--(32709 row(s) affected)
IF OBJECT_ID('[@HTN_combi].[dbo].MULTI_2_DRUG_DATE_AC', 'U') IS NOT NULL
	DROP TABLE MULTI_2_DRUG_DATE_AC;
SELECT PERSON_ID, LAST_FU_DATE, DRUG_CLASS_SIMPLE_1, DRUG_FU_SEQ_1, DRUG_CLASS_SIMPLE_2, DRUG_FU_SEQ_2
	, MIN(DATES) MIN_DATE
	, MAX(DATES) MAX_DATE
INTO MULTI_2_DRUG_DATE_AC
FROM OVERLAP_DATE_AC
GROUP BY PERSON_ID, LAST_FU_DATE, DRUG_CLASS_SIMPLE_1, DRUG_FU_SEQ_1, DRUG_CLASS_SIMPLE_2, DRUG_FU_SEQ_2
--ORDER BY PERSON_ID, DRUG_CLASS_SIMPLE_1, DRUG_FU_SEQ_1, DRUG_CLASS_SIMPLE_2, DRUG_FU_SEQ_2

SELECT * FROM MULTI_2_DRUG_DATE_AC ORDER BY PERSON_ID, DRUG_CLASS_SIMPLE_1, DRUG_FU_SEQ_1, DRUG_CLASS_SIMPLE_2, DRUG_FU_SEQ_2

-- MULTI DRUG DATE OF DRUG A AND DRUG D
--(37815 row(s) affected)
IF OBJECT_ID('[@HTN_combi].[dbo].MULTI_2_DRUG_DATE_AD', 'U') IS NOT NULL
	DROP TABLE MULTI_2_DRUG_DATE_AD;
SELECT PERSON_ID, LAST_FU_DATE, DRUG_CLASS_SIMPLE_1, DRUG_FU_SEQ_1, DRUG_CLASS_SIMPLE_2, DRUG_FU_SEQ_2
	, MIN(DATES) MIN_DATE
	, MAX(DATES) MAX_DATE
INTO MULTI_2_DRUG_DATE_AD
FROM OVERLAP_DATE_AD
GROUP BY PERSON_ID, LAST_FU_DATE, DRUG_CLASS_SIMPLE_1, DRUG_FU_SEQ_1, DRUG_CLASS_SIMPLE_2, DRUG_FU_SEQ_2
--ORDER BY PERSON_ID, DRUG_CLASS_SIMPLE_1, DRUG_FU_SEQ_1, DRUG_CLASS_SIMPLE_2, DRUG_FU_SEQ_2

SELECT * FROM MULTI_2_DRUG_DATE_AD ORDER BY PERSON_ID, DRUG_CLASS_SIMPLE_1, DRUG_FU_SEQ_1, DRUG_CLASS_SIMPLE_2, DRUG_FU_SEQ_2

-- MULTI DRUG DATE DAYS OF DRUG A AND DRUG B
--(14682 row(s) affected)
IF OBJECT_ID('[@HTN_combi].[dbo].MULTI_2_DRUG_DATE_DAYS_AB', 'U') IS NOT NULL
	DROP TABLE MULTI_2_DRUG_DATE_DAYS_AB;
SELECT *, DATEDIFF(DAY, MIN_DATE, MAX_DATE) CONT_DAYS
INTO MULTI_2_DRUG_DATE_DAYS_AB
FROM MULTI_2_DRUG_DATE_AB
--ORDER BY PERSON_ID, DRUG_CLASS_SIMPLE_1, DRUG_FU_SEQ_1, DRUG_CLASS_SIMPLE_2, DRUG_FU_SEQ_2

SELECT * FROM MULTI_2_DRUG_DATE_DAYS_AB ORDER BY PERSON_ID, DRUG_CLASS_SIMPLE_1, DRUG_FU_SEQ_1, DRUG_CLASS_SIMPLE_2, DRUG_FU_SEQ_2

-- MULTI DRUG DATE DAYS OF DRUG A AND DRUG C
--(32709 row(s) affected)
IF OBJECT_ID('[@HTN_combi].[dbo].MULTI_2_DRUG_DATE_DAYS_AC', 'U') IS NOT NULL
	DROP TABLE MULTI_2_DRUG_DATE_DAYS_AC;
SELECT *, DATEDIFF(DAY, MIN_DATE, MAX_DATE) CONT_DAYS
INTO MULTI_2_DRUG_DATE_DAYS_AC
FROM MULTI_2_DRUG_DATE_AC
--ORDER BY PERSON_ID, DRUG_CLASS_SIMPLE_1, DRUG_FU_SEQ_1, DRUG_CLASS_SIMPLE_2, DRUG_FU_SEQ_2

SELECT * FROM MULTI_2_DRUG_DATE_DAYS_AC ORDER BY PERSON_ID, DRUG_CLASS_SIMPLE_1, DRUG_FU_SEQ_1, DRUG_CLASS_SIMPLE_2, DRUG_FU_SEQ_2

-- MULTI DRUG DATE DAYS OF DRUG A AND DRUG D
--(37815 row(s) affected)
IF OBJECT_ID('[@HTN_combi].[dbo].MULTI_2_DRUG_DATE_DAYS_AD', 'U') IS NOT NULL
	DROP TABLE MULTI_2_DRUG_DATE_DAYS_AD;
SELECT *, DATEDIFF(DAY, MIN_DATE, MAX_DATE) CONT_DAYS
INTO MULTI_2_DRUG_DATE_DAYS_AD
FROM MULTI_2_DRUG_DATE_AD
--ORDER BY PERSON_ID, DRUG_CLASS_SIMPLE_1, DRUG_FU_SEQ_1, DRUG_CLASS_SIMPLE_2, DRUG_FU_SEQ_2

SELECT * FROM MULTI_2_DRUG_DATE_DAYS_AD ORDER BY PERSON_ID, DRUG_CLASS_SIMPLE_1, DRUG_FU_SEQ_1, DRUG_CLASS_SIMPLE_2, DRUG_FU_SEQ_2

-- MULTI DRUG DATE CONTINUOUS 90 DAYS OF DRUG A AND DRUG B
--(14205 row(s) affected)
IF OBJECT_ID('[@HTN_combi].[dbo].MULTI_2_DRUG_DATE_DAYS_C90D', 'U') IS NOT NULL
	DROP TABLE MULTI_2_DRUG_DATE_DAYS_C90D_AB;
SELECT *
INTO MULTI_2_DRUG_DATE_DAYS_C90D_AB
FROM MULTI_2_DRUG_DATE_DAYS_AB
WHERE CONT_DAYS>=90
--ORDER BY PERSON_ID, DRUG_CLASS_SIMPLE_1, DRUG_FU_SEQ_1, DRUG_CLASS_SIMPLE_2, DRUG_FU_SEQ_2

SELECT * FROM MULTI_2_DRUG_DATE_DAYS_C90D_AB ORDER BY PERSON_ID, DRUG_CLASS_SIMPLE_1, DRUG_FU_SEQ_1, DRUG_CLASS_SIMPLE_2, DRUG_FU_SEQ_2

-- MULTI DRUG DATE CONTINUOUS 90 DAYS OF DRUG A AND DRUG C
--(31412 row(s) affected)
IF OBJECT_ID('[@HTN_combi].[dbo].MULTI_2_DRUG_DATE_DAYS_C90D_AC', 'U') IS NOT NULL
	DROP TABLE MULTI_2_DRUG_DATE_DAYS_C90D_AC;
SELECT *
INTO MULTI_2_DRUG_DATE_DAYS_C90D_AC
FROM MULTI_2_DRUG_DATE_DAYS_AC
WHERE CONT_DAYS>=90
--ORDER BY PERSON_ID, DRUG_CLASS_SIMPLE_1, DRUG_FU_SEQ_1, DRUG_CLASS_SIMPLE_2, DRUG_FU_SEQ_2

SELECT * FROM MULTI_2_DRUG_DATE_DAYS_C90D_AC ORDER BY PERSON_ID, DRUG_CLASS_SIMPLE_1, DRUG_FU_SEQ_1, DRUG_CLASS_SIMPLE_2, DRUG_FU_SEQ_2

-- MULTI DRUG DATE CONTINUOUS 90 DAYS OF DRUG A AND DRUG D
--(37408 row(s) affected)
IF OBJECT_ID('[@HTN_combi].[dbo].MULTI_2_DRUG_DATE_DAYS_C90D_AD', 'U') IS NOT NULL
	DROP TABLE MULTI_2_DRUG_DATE_DAYS_C90D_AD;
SELECT *
INTO MULTI_2_DRUG_DATE_DAYS_C90D_AD
FROM MULTI_2_DRUG_DATE_DAYS_AD
WHERE CONT_DAYS>=90
--ORDER BY PERSON_ID, DRUG_CLASS_SIMPLE_1, DRUG_FU_SEQ_1, DRUG_CLASS_SIMPLE_2, DRUG_FU_SEQ_2

SELECT * FROM MULTI_2_DRUG_DATE_DAYS_C90D_AD ORDER BY PERSON_ID, DRUG_CLASS_SIMPLE_1, DRUG_FU_SEQ_1, DRUG_CLASS_SIMPLE_2, DRUG_FU_SEQ_2


-----------------------------------------------------------------------------
USE [SJ_CASE02];

DROP TABLE TMP_1;
DROP TABLE TMP_2;
DROP TABLE TMP_3;
DROP TABLE TMP_4;
DROP TABLE TMP;
CREATE TABLE TMP(
	CODE		VARCHAR(2),
	SEQ			INT,
	STARTDATE	DATE,
	ENDDATE		DATE
);
TRUNCATE TABLE TMP;

INSERT TMP VALUES('A0','1','2011-01-01','2011-05-31')
INSERT TMP VALUES('A0','2','2011-02-01','2011-02-10')
INSERT TMP VALUES('A0','3','2011-02-21','2011-02-23')
INSERT TMP VALUES('A0','4','2011-02-21','2011-04-10')
INSERT TMP VALUES('A0','5','2011-03-30','2011-03-30')
INSERT TMP VALUES('A0','6','2011-03-31','2011-04-05')
INSERT TMP VALUES('A0','7','2011-05-30','2011-05-30')
INSERT TMP VALUES('A0','8','2011-03-01','2011-06-20')
INSERT TMP VALUES('A0','9','2011-04-01','2011-05-20')
INSERT TMP VALUES('A0','10','2011-06-10','2011-06-30')
INSERT TMP VALUES('A0','11','2011-06-20','2011-06-25')
INSERT TMP VALUES('A0','12','2011-07-10','2011-07-30')
INSERT TMP VALUES('A0','13','2011-09-01','2011-10-31')
INSERT TMP VALUES('A0','14','2011-11-01','2011-12-10')
INSERT TMP VALUES('A0','15','2011-12-21','2011-12-23')
INSERT TMP VALUES('A0','16','2011-12-21','2011-12-10')
INSERT TMP VALUES('A1','1','2011-03-01','2011-03-31')
INSERT TMP VALUES('A1','2','2011-03-01','2011-04-10')
INSERT TMP VALUES('A1','3','2011-03-21','2011-05-23')
INSERT TMP VALUES('A1','4','2011-07-10','2011-07-20')
INSERT TMP VALUES('A1','5','2011-07-22','2011-07-25')
INSERT TMP VALUES('A1','6','2011-07-23','2011-07-23')
INSERT TMP VALUES('A1','7','2011-12-21','2011-12-23')
INSERT TMP VALUES('A1','8','2011-12-21','2011-12-10')
INSERT TMP VALUES('A2','1','2011-02-01','2011-05-31')
INSERT TMP VALUES('A2','2','2011-06-01','2012-12-10')

SELECT * FROM TMP

-- CASE01
SELECT T1.*, ISNULL(T2.ENDDATE,T1.ENDDATE) EXTENDDATE
INTO TMP_1
FROM TMP T1
	OUTER APPLY(
		SELECT TOP 1 *
		FROM TMP
		WHERE CODE=T1.CODE AND SEQ<=T1.SEQ AND ENDDATE>T1.ENDDATE
		ORDER BY ENDDATE DESC
	) T2

SELECT * FROM TMP_1

SELECT A.CODE, A.SEQ, A.STARTDATE, A.EXTENDDATE,
		DATEDIFF(DAY, B.EXTENDDATE, A.STARTDATE) AS DAYDIFF_ENDSTART
INTO TMP_2
FROM TMP_1 A LEFT JOIN TMP_1 B
	ON A.CODE=B.CODE AND A.SEQ = CAST(B.SEQ AS INT) +1

SELECT * FROM TMP_2

SELECT *, CASE
	WHEN SEQ=1 THEN 1
	ELSE SUM(CASE WHEN DAYDIFF_ENDSTART>30 THEN 1 ELSE 0 END) OVER(PARTITION BY CODE ORDER BY SEQ ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)+1
	END AS FGSEQ
INTO TMP_3
FROM TMP_2
ORDER BY CODE, SEQ

SELECT * FROM TMP_3 ORDER BY CODE, SEQ

SELECT CODE, FGSEQ,
	MIN(STARTDATE) AS MINSTARTDATE,
	MAX(EXTENDDATE) AS MAXENDDATE
INTO TMP_4
FROM TMP_3
GROUP BY CODE, FGSEQ

SELECT * FROM TMP_4 ORDER BY CODE, FGSEQ

-- CASE01 END
-------------------------------------
-- CASE02
DROP TABLE DATERANGE;
DROP TABLE OVERLAPDATE;
DROP TABLE MULTI2DRUG_DATE;

SELECT * FROM TMP_4 ORDER BY CODE, FGSEQ

WITH
DATERANGE(MINDATE,MAXDATE)
AS(
	SELECT MIN(MINSTARTDATE) MINDATE, MAX(MAXENDDATE) MAXDATE FROM TMP_4
)
SELECT DATEADD(DAY, NBR-1, (SELECT MINDATE FROM DATERANGE)) AS DATES
INTO DATERANGE
FROM (
	SELECT ROW_NUMBER() OVER (ORDER BY c.object_id) AS NBR
	FROM sys.columns c
) NBRS
WHERE NBR-1 <= DATEDIFF(DAY, (SELECT MINDATE FROM DATERANGE), (SELECT MAXDATE FROM DATERANGE))

SELECT * FROM DATERANGE

--SELECT *
SELECT A.*, B.A0, B.FGSEQ A0SEQ, C.A1, C.FGSEQ A1SEQ
INTO OVERLAPDATE
FROM DATERANGE A
	LEFT JOIN (SELECT 'Y' A0,* FROM TMP_4 WHERE CODE IN ('A0')) B
	ON A.DATES BETWEEN B.MINSTARTDATE AND B.MAXENDDATE
	LEFT JOIN (SELECT 'Y' A1,* FROM TMP_4 WHERE CODE IN ('A1')) C
	ON A.DATES BETWEEN C.MINSTARTDATE AND C.MAXENDDATE
WHERE A0 IS NOT NULL AND A1 IS NOT NULL

SELECT * FROM OVERLAPDATE
SELECT * FROM TMP_4

SELECT DISTINCT A0SEQ, A1SEQ, MIN(DATES) OVER(PARTITION BY A0SEQ, A1SEQ) MINDATE, MAX(DATES) OVER(PARTITION BY A0SEQ, A1SEQ) MAXDATE 
INTO MULTI2DRUG_DATE
FROM OVERLAPDATE

SELECT * FROM MULTI2DRUG_DATE
