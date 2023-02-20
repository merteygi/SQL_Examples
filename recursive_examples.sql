select * from DWH.MERT_REC_EX_1
;

with emp_hierarchy(id,name,manager_id,designation,lvl) as (
    select 
        id,name,manager_id,designation, 1 as lvl 
    from DWH.MERT_REC_EX_1 where name ='Taner'
    union all
    select 
        E.id,E.name,E.manager_id,E.designation, lvl+1 as lvl
    from emp_hierarchy H
        join DWH.MERT_REC_EX_1 E on H.id = E.manager_id 
)
select H2.ID AS EMP_ID,H2.NAME AS EMP_NAME, E2.NAME AS MANAGER_NAME,H2.LVL
from emp_hierarchy H2 
    JOIN DWH.MERT_REC_EX_1 E2 on E2.ID = H2.MANAGER_ID
;

with emp_hierarchy(id,name,manager_id,designation,lvl) as (
    select 
        id,name,manager_id,designation, 1 as lvl 
    from DWH.MERT_REC_EX_1 where name ='Veli'
    union all
    select 
        E.id,E.name,E.manager_id,E.designation, lvl+1 as lvl
    from emp_hierarchy H
        join DWH.MERT_REC_EX_1 E on H.manager_id = E.id 
)
select
    *
from emp_hierarchy
/*
select 
    H2.ID AS EMP_ID,H2.NAME AS EMP_NAME, E2.NAME AS MANAGER_NAME,H2.LVL
from emp_hierarchy H2 
    JOIN DWH.MERT_REC_EX_1 E2 on E2.ID = H2.MANAGER_ID
order by lvl
*/
;