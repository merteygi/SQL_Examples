with upto_date_users as(
    select yearmonth,user_id
    FROM DWH.EOM_USERS_USAGE_STATES
    group by yearmonth,user_id
    union 
    select yearmonth,user_id
    from DWH.USER_FLAGS_MAIN
    group by yearmonth,user_id
),
monthly_opening_closing as(
    select 
        yearmonth,
        LAG (count(distinct user_id),1) OVER (ORDER BY yearmonth) AS OPENING,
        count(distinct user_id) CLOSING
    from upto_date_users
    group by yearmonth
    order by yearmonth
),
monthly_ACQUISITION as(
    SELECT 
        YEARMONTH ACQ_MONTH,
        count(distinct USER_ID ) AS ACQUISITION
    FROM upto_date_users a 
    WHERE 1=1 
        and a.YEARMONTH >= 202110
        AND not exists (SELECT 1 
                        FROM upto_date_users b 
                        where b.yearmonth = TO_CHAR(ADD_MONTHS( to_date(a.YEARMONTH,'YYYYMM'),-1),'YYYYMM') 
                            and b.USER_ID = a.USER_ID )
    GROUP BY YEARMONTH
    ORDER BY YEARMONTH
),
monthly_CHURN as(
    SELECT 
        to_char(add_months(to_date(a.yearmonth,'YYYYMM') , 1), 'YYYYMM') AS CHURN_MONTH,
        count(distinct USER_ID ) CHURN
    FROM upto_date_users a 
    WHERE 1=1 
        and a.YEARMONTH BETWEEN 202109 AND TO_CHAR(ADD_MONTHS(SYSDATE-1, -1),'YYYYMM') 
        AND not exists (SELECT 1 
                        FROM upto_date_users b 
                        WHERE b.yearmonth =to_char(add_months(to_date(a.yearmonth,'YYYYMM') , 1), 'YYYYMM')
                            and b.USER_ID = a.USER_ID )
    group by a.yearmonth 
    order by CHURN_MONTH
)
select 
    oc.yearmonth,
    oc.OPENING,
    oc.CLOSING,
    a.ACQUISITION,
    c.CHURN,
    (a.ACQUISITION - c.CHURN) NET_ADD,
    round((c.CHURN/( oc.CLOSING))*100,1) CHURN_RATE --CHURN_RATE : (df['Churn']/( df['Opening'] + df['Acquisition']/2))
from monthly_opening_closing oc
    inner join monthly_ACQUISITION a on  oc.yearmonth = a.acq_month
    inner join monthly_CHURN c on oc.yearmonth = c.churn_month
order by 1
