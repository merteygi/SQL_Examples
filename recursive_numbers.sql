with numbers(n) as(
    SELECT 1 as n FROM DUAL
    union all
    select n+1 as n
    from numbers
    where n<=10
)
select * from numbers 
    