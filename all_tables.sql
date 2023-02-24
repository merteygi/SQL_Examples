select 
    a.OWNER ||'.'||a.table_name OWNER_TABLENAME,
    a.COLUMN_ID,a.COLUMN_NAME,a.DATA_TYPE,a.DATA_LENGTH,a.SAMPLE_SIZE,a.NUM_DISTINCT,a.LOW_VALUE,a.HIGH_VALUE,a.LAST_ANALYZED
from all_tab_columns a
where 1 = 1
    --and UPPER(column_name)  = 'SCHEDULE_TYPE'---
    and UPPER(column_name) like ('%TRANSACTION_ID%')--('TOPLAM_DONDURULMUS_GUN')--('KESINTISIZ_GUN')
    --AND TABLE_NAME like '%ILCE%'
    AND LAST_ANALYZED IS NOT NULL
    and TRUNC(LAST_ANALYZED) >= trunc(sysdate-1)
ORDER BY 1,a.COLUMN_ID
;
 