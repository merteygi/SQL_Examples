--ACQ  (for paid subscriptions)
SELECT 
    YEARMONTH ACQ_MONTH,
    count(distinct USER_ID ) AS DISTINCT_USER,
    sum(a.FREE_MEMBER_FLG)
FROM DWH.EOM_USERS a 
WHERE 1=1 
    and a.YEARMONTH = 202205
    and a.FREE_MEMBER_FLG = 0 -- 0: UCRETLI ABONELIK, 1:FREE ABONELIK
    AND not exists (SELECT 1 
                    FROM DWH.EOM_USERS b 
                    where b.yearmonth = TO_CHAR(ADD_MONTHS( to_date(a.YEARMONTH,'YYYYMM'),-1),'YYYYMM') 
                        and b.FREE_MEMBER_FLG = 0 -- 0: UCRETLI ABONELIK, 1:FREE ABONELIK
                        and b.USER_ID = a.USER_ID )
GROUP BY YEARMONTH
ORDER BY YEARMONTH
;

--CHURN (for paid subscriptions)
SELECT 
    to_char(add_months(to_date(a.yearmonth,'YYYYMM') , 1), 'YYYYMM') AS CHURN_MONTH,
    count(distinct USER_ID ) DISTINCT_USER
FROM DWH.EOM_USERS a 
WHERE 1=1 
    and a.YEARMONTH BETWEEN 202106 AND TO_CHAR(ADD_MONTHS(SYSDATE, -1),'YYYYMM') 
    and a.FREE_MEMBER_FLG = 0 -- 0: UCRETLI ABONELIK, 1:FREE ABONELIK
    AND not exists (SELECT 1 
                    FROM DWH.EOM_USERS b 
                    WHERE b.yearmonth =to_char(add_months(to_date(a.yearmonth,'YYYYMM') , 1), 'YYYYMM')
                        and b.FREE_MEMBER_FLG = 0 -- 0: UCRETLI ABONELIK, 1:FREE ABONELIK
                        and b.USER_ID = a.USER_ID )
group by a.yearmonth 
order by CHURN_MONTH
;