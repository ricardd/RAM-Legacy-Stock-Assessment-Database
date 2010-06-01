
-- extract the count of assements with particular data for a given year

select ordername, count( distinct family) from srdb.taxonomy where classname = 'Actinopterygii' group by ordername order by count desc;

select distinct(stockid) from srdb.assessment where assessid not like '%MYERS%';

-- note 327 in first query, 324 in this one

select tsn from srdb.stock where stockid in (select stockid from srdb.assessment where assessid not like '%MYERS%');


select * from srdb.taxonomy as aa, (select tsn from srdb.stock where stockid in (select stockid from srdb.assessment where assessid not like '%MYERS%')) as bb where aa.tsn=bb.tsn;
