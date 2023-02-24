SELECT 
    to_char(add_months(to_date('202203','YYYYMM'),1),'YYYYMM'),
    to_date('20211101','yyyymmdd'),
    last_day(to_date('202111','yyyymm')),
    TO_DATE ('2021-11-23 11:50:00', 'yyyy/mm/dd hh24:mi:ss') "0",
    sysdate as "1", --31/08/2021 15:08:16
    null as "na",
    last_day(to_date(add_months(to_date(SYSDATE-2,'dd.mm.yy'),-1),'dd.mm.yy')) "na",
    --to_char('20210830','YYYYMM'),
    last_day(add_months(to_date(SYSDATE-2,'dd.mm.yy'),-1)) GECEN_AY_SONU,
    to_number(to_char(to_date(to_char(SYSDATE-2,'YYYYMM'),'YYYYMM'),'YYYYMMDD')) FIRST_DAY_OF_MONTH,
    to_number(to_char(last_day(to_date(SYSDATE-2,'dd.mm.yy')),'YYYYMMDD')) LAST_DAY_OF_MONTH,
    to_number(to_char(to_date(to_char(add_months(to_date(SYSDATE-2,'dd.mm.yy'),-2),'YYYYMM'),'YYYYMM'),'YYYYMMDD')) FIRST_DAY_OF_THE_MONTH,
    to_number(to_char(last_day(to_date(add_months(to_date(SYSDATE-2,'dd.mm.yy'),-2),'dd.mm.yy')),'YYYYMMDD')) LAST_DAY_OF_THE_MONTH,
    TO_NUMBER(TO_CHAR(SYSDATE-2,'YYYYMMDD')) CCC,
    to_number(to_char(last_day(add_months(to_date(SYSDATE-2,'dd.mm.yy'),-1))-365,'YYYYMMDD')) GECEN_YIL_AY_SONU,
    to_number(to_char(last_day(add_months(to_date(SYSDATE-2,'dd.mm.yy'),-1)),'YYYYMMDD')) GECEN_AY_SONU,
    last_day(to_date('202108','YYYYMM')) as "1", --31/08/2021
    TO_DATE(sysdate) as "1",--31/08/2021
    TO_CHAR(sysdate,'YYYYMMDD') as "1", --20210831
    TO_CHAR(sysdate,'MM') as "1", --08
    TO_CHAR(sysdate,'YYYY.MM.DD') as "1", --2021.08.31
    TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') as "1",--2021-08-31 15:09:38
    TO_DATE('2012-07-18', 'YYYY-MM-DD') as "1", --18/07/2012
	last_day(TO_DATE('20200801', 'YYYY-MM-DD')) as "1" --31/08/2020
FROM TCMEYGI.QUERIES T1