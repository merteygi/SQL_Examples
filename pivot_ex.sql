WITH acq_users AS
(
SELECT
	a.YEARMONTH,
	a.user_id,
	to_char(a.CONTRACT_START_DATE,
	'YYYYMM') CONTRACT_MONTH
FROM
	DWH.EOM_users a
WHERE
	1 = 1
	AND a.YEARMONTH >= 202106
	AND a.YEARMONTH IN (to_char(a.CONTRACT_START_DATE, 'YYYYMM') , to_char(add_months(a.CONTRACT_START_DATE,-1), 'YYYYMM') )
	AND NOT EXISTS (
	SELECT
		1
	FROM
		DWH.EOM_users b
	WHERE
		b.yearmonth = TO_CHAR(ADD_MONTHS( to_date(a.YEARMONTH,
		'YYYYMM'),
		-1),
		'YYYYMM')
			AND b.USER_ID = a.USER_ID )
GROUP BY
	a.user_id,
	a.YEARMONTH,
	to_char(a.CONTRACT_START_DATE,
	'YYYYMM')
	--,a.CONTRACT_START_DATE,a.CONTRACT_END_DATE
ORDER BY
	a.YEARMONTH,
	a.user_id
)
SELECT
	*
FROM
	(
	SELECT
		*
	FROM
		acq_users

    pivot ( 
      count ( DISTINCT user_id ) 
      FOR CONTRACT_MONTH IN (202106, 202107, 202108, 202109, 202110, 202111, 202112, 202201, 202202, 202203, 202204)
    )
	WHERE
		1 = 1
	ORDER BY
		YEARMONTH
)