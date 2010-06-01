-- some SQL code to see how many stocks in srdb are of likely interest for Steve Murawski's request
-- Time-stamp: <Last modified: 11 FEBRUARY   (srdbadmin)>
--
-- this data request is handled by a Poi issue on RAMlegacy:
-- http://www.marinebiodiversity.ca/RAMlegacy/ramlegacy-bug-reporting/441
-- Murawski: "I am looking for stocks where the biomass decline (in assessments) is 50% or more, followed by a sustained cut in F of 25% or more."

-- stocks with a SSB reduction of more than 50% between SSBmax and SSBmin
SELECT s.stocklong, assessid, ((maxssb-minssb)/maxssb)*100 as percentreduction
FROM
(SELECT v.assessid, a.stockid, min(v.ssb) as minssb, max(v.ssb) as maxssb from srdb.newtimeseries_values_view v, srdb.assessment a WHERE a.assessid = v.assessid and v.ssb IS NOT NULL GROUP BY v.assessid, a.stockid) as a, srdb.stock s
WHERE 
a.stockid=s.stockid AND
minssb/maxssb <= 0.5 ;

-- stocks with a SSB reduction of more than 50% between SSBfirstyear and SSBmin
select aa.assessid, aa.ssbfirstyear, bb.minssb,  ((aa.ssbfirstyear-bb.minssb)/aa.ssbfirstyear)*100 as percentreduction
FROM
(select a.assessid, ssb as ssbfirstyear from srdb.newtimeseries_values_view v, (SELECT assessid, min(tsyear) as minyr, max(tsyear) as maxyr from srdb.newtimeseries_values_view WHERE ssb IS NOT NULL GROUP BY assessid) as a where v.assessid=a.assessid and a.minyr=v.tsyear) as aa,
(SELECT assessid, min(ssb) as minssb from srdb.newtimeseries_values_view WHERE ssb IS NOT NULL GROUP BY assessid) as bb
WHERE
aa.assessid=bb.assessid AND
bb.minssb / aa.ssbfirstyear <= 0.5
;

-- SSBmin and its first year of occurence
(SELECT assessid, min(tsyear) as minssbyear, min(minssb) as minssb  from (SELECT v.assessid, v.tsyear, aa.minssb FROM srdb.newtimeseries_values_view v, (SELECT assessid, min(ssb) as minssb from srdb.newtimeseries_values_view WHERE ssb IS NOT NULL GROUP BY assessid) as aa WHERE v.assessid=aa.assessid and v.ssb=aa.minssb) as bb GROUP BY assessid) as cc;


-- percent difference between maximum and minimum values of F between 5 years prior to SSBmin and 10 years after SSBmin was observed
SELECT ii.assessid, s.stocklong, ii.fpercentreduction 
FROM
(
SELECT assessid, ((maxf-minf)/maxf) * 100 as fpercentreduction
FROM
(
SELECT
v.assessid,
min(v.f) as minf,
max(v.f) as maxf
FROM
srdb.newtimeseries_values_view v,
(SELECT assessid, min(tsyear) as minssbyear, min(minssb) as minssb  from (SELECT v.assessid, v.tsyear, aa.minssb FROM srdb.newtimeseries_values_view v, (SELECT assessid, min(ssb) as minssb from srdb.newtimeseries_values_view WHERE ssb IS NOT NULL GROUP BY assessid) as aa WHERE v.assessid=aa.assessid and v.ssb=aa.minssb) as bb GROUP BY assessid) as cc
WHERE
cc.assessid=v.assessid AND
v.tsyear >= cc.minssbyear -5 AND
v.tsyear <= cc.minssbyear + 10 AND
v.f is not null
group by v.assessid
) as t
where t.maxf >0 and
t.assessid in
(
select aa.assessid
FROM
(select a.assessid, ssb as ssbfirstyear from srdb.newtimeseries_values_view v, (SELECT assessid, min(tsyear) as minyr, max(tsyear) as maxyr from srdb.newtimeseries_values_view WHERE ssb IS NOT NULL GROUP BY assessid) as a where v.assessid=a.assessid and a.minyr=v.tsyear) as aa,
(SELECT assessid, min(ssb) as minssb from srdb.newtimeseries_values_view WHERE ssb IS NOT NULL GROUP BY assessid) as bb
WHERE
aa.assessid=bb.assessid AND
bb.minssb / aa.ssbfirstyear <= 0.5
)
) ii,
srdb.assessment a,
srdb.stock s
WHERE 
ii.assessid = a.assessid and
a.stockid=s.stockid
;
