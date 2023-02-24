--- kendi tablomda update sonrasý rollback çalýþmasý, tablonun 50 dk öncesine giderek sorunu çözebildik.
rollback;
;

select * from tcmeygi.queries

;

create table tcmeygi.queries_backup_20211203 as select * from tcmeygi.queries as of timestamp(sysdate-(50/1440));

select * from tcmeygi.queries_backup_20211203
order by create_date desc
;
create table tcmeygi.queries_broken as select * from tcmeygi.queries
;
select *  from tcmeygi.queries_broken;

drop table tcmeygi.queries
;

create table tcmeygi.queries as select * from tcmeygi.queries_backup_20211203
;
select * from tcmeygi.queries
;
commit;