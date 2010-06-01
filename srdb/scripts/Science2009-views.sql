-- for Science 2009 manuscript
-- Daniel Ricard
-- these views were materialised on Time-stamp: <2009-06-12 22:32:19 (ricardd)>
-- and are not mean to be updated, they represent the state of the database before the final analyses
-- for the Science manuscript
-- some stocks are not present in these views
drop table srdb.timeseries_values_science2009;
create table srdb.timeseries_values_science2009 as
(

SELECT  tsv.* ,lst.lme_number, lref.lme_name
FROM 
srdb.timeseries_values_view tsv, srdb.science2009stocks ss, srdb.lmerefs lref, srdb.lmetostocks lst, srdb.assessment a
WHERE
tsv.assessid = ss.assessid and a.assessid=tsv.assessid and a.stockid=lst.stockid and lst.stocktolmerelation='primary' and lst.lme_number=lref.lme_number
);

drop table srdb.timeseries_units_science2009;
create table srdb.timeseries_units_science2009 as
(
SELECT tsu.* 
FROM 
srdb.timeseries_units_view tsu, srdb.science2009stocks ss
WHERE
tsu.assessid = ss.assessid
);

drop table srdb.reference_points_values_science2009;
create table srdb.reference_points_values_science2009 as
(
SELECT rpv.* 
FROM 
srdb.reference_point_values_view rpv, srdb.science2009stocks ss
WHERE
rpv.assessid = ss.assessid
);

drop table srdb.reference_points_units_science2009;
create table srdb.reference_points_units_science2009 as
(
SELECT rpu.* 
FROM 
srdb.reference_point_units_view rpu, srdb.science2009stocks ss
WHERE
rpu.assessid = ss.assessid
);

