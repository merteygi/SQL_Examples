/* Formatted on 8/12/2021 16:12:06 (QP5 v5.365) */
---create table TCMEYGI.fizy_aktiflik_v2 as

INSERT INTO TCMEYGI.fizy_aktiflik_v2
    SELECT /*+ use_hash(a,b) parallel(16)*/
           DISTINCT account_id,
                    a.msisdn,
                    turkcell_flag,
                    MONTHLY_CALENDAR_ID
      FROM FIZY.FIZY_TRANSACTION_HISTORY a
     WHERE a.TRANSACTION_TYPE_ID IN (16) AND MONTHLY_CALENDAR_ID = 202203--202202
 ;

  SELECT /*+ use_hash(a,b) parallel(16)*/
         monthly_calendar_id,
         COUNT (*),
         COUNT (DISTINCT account_id),
         COUNT (DISTINCT msisdn)
    FROM TCMEYGI.fizy_aktiflik_v2
GROUP BY monthly_calendar_id
ORDER BY monthly_calendar_id DESC
;

SELECT YEARMONTH, COUNT(distinct a.SUBSCRIBER_ID) 
FROM  TCMEYGI.FIZY_std_mo a
GROUP BY YEARMONTH
ORDER BY YEARMONTH DESC
;
--fizy std abone SLCM den mobil ödeme 
insert into TCMEYGI.FIZY_STD_MO  
SELECT /*+ use_hash(a,b) parallel(16)*/  
distinct a11.DATA_SUBSCRIBER_ID subscriber_id, a11.catalog_offer_id offer_id, offer_nk, a12.offer_name,  to_char( last_day(DAY_DATE) ,'yyyymm') yearmonth
from      DATA.DATA_SERVICE_SUBSCRIPTION    a11 , supermart.offer a12 , SUPERMART.DAILY_CALENDAR a13 
where a11.catalog_offer_id=a12.offer_id 
and a12.offer_nk IN ('603745184', '603780193', '603820236', '603585161', '602960205', '602970547', '603780192', '602970161', '602970544', 
                    '602970508', '603075081', '603820232', '603950213', '603585142', '604105301', '603820233', '604110256', '56242', '56254', 
                    '58895', '59363', '603110082', '603845194', '60161', '602960203', '603845195', '63357', '601535015', '64564', '66264', 
                    '68744', '57851', '66226', '70599', '70600' ,  '70601', '70602','79235' )
and a13.day_date = to_date('31.03.2022', 'dd.mm.yyyy')
and trunc(a11.START_DATE) <=  last_day(DAY_DATE)
and trunc(a11.END_DATE)  > last_day(DAY_DATE) 
;
---fizy standalone mau 
--create table TCMEYGI.fizy_SA_MAU2 as 
INSERT INTO TCMEYGI.fizy_SA_MAU2
    SELECT DISTINCT b.msisdn, b.account_id, a.yearmonth
      FROM TCMEYGI.FIZY_std_mo       a,
           supermart.subscriber_main   b2,
           TCMEYGI.fizy_aktiflik_v2  b
     WHERE     b.msisdn = b2.msisdn
           AND a.subscriber_id = b2.subscriber_id
           AND a.yearmonth = b.monthly_calendar_id
           AND a.yearmonth = 202203--202202
           ;

  SELECT yearmonth,
         COUNT (*),
         COUNT (DISTINCT account_id),
         COUNT (DISTINCT msisdn)
    FROM TCMEYGI.fizy_SA_MAU2
GROUP BY yearmonth
ORDER BY yearmonth DESC;
;
;
--Retention COHORT - Fizy ALL AKTIF USER
----all aktiflik cohort 

WITH
    fizy_activity_
    AS
        (  SELECT COUNT (DISTINCT b.account_id)     retent_users,
                  a.monthly_calendar_id             yearmonth_1,
                  b.monthly_calendar_id             yearmonth_2
             FROM TCMEYGI.fizy_aktiflik_v2 a
                  LEFT JOIN TCMEYGI.fizy_aktiflik_v2 b
                      ON a.account_id = b.account_id
            WHERE     a.monthly_calendar_id <= b.monthly_calendar_id
                  AND a.monthly_calendar_id >= 202103 -- 1 arttýr
         GROUP BY a.monthly_calendar_id, b.monthly_calendar_id),
    fizy_activity_total_count
    AS
        (  SELECT COUNT (DISTINCT account_id)     total_count,
                  monthly_calendar_id             yearmonth
             FROM TCMEYGI.fizy_aktiflik_v2
         GROUP BY monthly_calendar_id)
(SELECT yearmonth_1,
        yearmonth_2,
        retent_users,
        total_count,
        ROUND ((retent_users / total_count) * 100, 0)     rate
   FROM fizy_activity_total_count A, fizy_activity_ B
  WHERE A.yearmonth = B.yearmonth_1)
ORDER BY yearmonth_1, yearmonth_2
;

 --Retention COHORT - Fizy STANDALONE AKTIF USER
---cohort 

WITH
    fizy_standalone_r
    AS
        (  SELECT COUNT (DISTINCT b.account_id)     retent_user,
                  a.yearmonth                       yearmonth_1,
                  b.yearmonth                       yearmonth_2
             FROM TCMEYGI.fizy_SA_MAU2 a
                  LEFT JOIN TCMEYGI.fizy_SA_MAU2 b
                      ON a.account_id = b.account_id
            WHERE a.yearmonth <= b.yearmonth AND a.yearmonth >= 202103 -- 1 arttýr
         GROUP BY a.yearmonth, b.yearmonth),
    fizy_std_total_count
    AS
        (  SELECT COUNT (DISTINCT account_id) total_count, yearmonth
             FROM TCMEYGI.fizy_SA_MAU2
         GROUP BY yearmonth)
(SELECT yearmonth_1,
        yearmonth_2,
        retent_user,
        total_count,
        ROUND ((retent_user / total_count) * 100, 0)     rate
   FROM fizy_std_total_count A, fizy_standalone_r B
  WHERE A.yearmonth = B.yearmonth_1)
ORDER BY yearmonth_1, yearmonth_2;

--CHURN COHORT
--- subscription churn cohort

WITH
    fizy_standalone_r
    AS
        (  SELECT COUNT (DISTINCT b.subscriber_id)     retent_user,
                  a.yearmonth                          yearmonth_1,
                  b.yearmonth                          yearmonth_2
             FROM TCMEYGI.FIZY_std_mo a
                  LEFT JOIN TCMEYGI.FIZY_std_mo b
                      ON a.subscriber_id = b.subscriber_id
            WHERE     a.yearmonth <= b.yearmonth
                  AND a.yearmonth >= 202001 -- sabit kalabilir
                  AND b.yearmonth = 202203 -- 1 arttýr
         GROUP BY a.yearmonth, b.yearmonth),
    fizy_std_total_count
    AS
        (  SELECT COUNT (DISTINCT subscriber_id) total_count, yearmonth
             FROM TCMEYGI.FIZY_std_mo
         GROUP BY yearmonth)
(SELECT yearmonth_1,
        yearmonth_2,
        retent_user,
        total_count,
        ROUND ((retent_user / total_count) * 100, 1)     rate
   FROM fizy_std_total_count A, fizy_standalone_r B
  WHERE A.yearmonth = B.yearmonth_1)
ORDER BY yearmonth_1, yearmonth_2;