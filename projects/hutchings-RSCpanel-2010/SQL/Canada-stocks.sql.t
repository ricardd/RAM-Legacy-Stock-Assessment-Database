-- usage psql srdb -f Canada-stocks.sql -F "," -A -o Canadian-stock-list.csv
select aa.assessid, aa.recorder, s.stocklong, t.scientificname, min(ts.tsyear) || '-' || max(ts.tsyear) as years, a.assessorid, m.mgmt, lr.lme_name from srdb.management m, srdb.assessor a, srdb.assessment aa, srdb.stock s, srdb.taxonomy t, srdb.timeseries ts, srdb.lmerefs lr, srdb.lmetostocks lts where lr.lme_number=lts.lme_number and lts.stockid = s.stockid and lts.stocktolmerelation='primary' and ts.assessid = aa.assessid and t.tsn=s.tsn and s.stockid=aa.stockid and aa.assessorid=a.assessorid and a.mgmt=m.mgmt and a.mgmt in ('DFO','NAFO','ICCAT','TRAC') and lts.lme_number in (2,7,8,9,18,-98) group by aa.assessid, aa.recorder, s.stocklong, t.scientificname, a.assessorid, m.mgmt, lr.lme_name order by mgmt, assessorid, scientificname ;



