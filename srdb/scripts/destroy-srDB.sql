-- destroy-srDB.sql
-- postgreSQL implementation of stock-recruitment database
-- drop tables defined in "create-srDB.sql"
-- Daniel Ricard
-- Started: 2007-12-19
-- Last modified Time-stamp: <2009-03-11 21:03:51 (ricardd)>
-- Modification history:
-- 

DROP TABLE srdb.qaqc;
DROP TABLE srdb.lmetostocks;
DROP TABLE srdb.lmerefs;
DROP TABLE srdb.referencedoc;
DROP TABLE srdb.risfieldvalues;
DROP TABLE srdb.risfields;
DROP TABLE srdb.bioparams CASCADE;
DROP TABLE srdb.biometrics CASCADE;
--DROP TABLE srdb.nmfsbiometrics CASCADE;
DROP TABLE srdb.timeseries CASCADE;
--DROP TABLE srdb.nmfstsmetrics CASCADE;
DROP TABLE srdb.ramunits CASCADE;
DROP TABLE srdb.tsmetrics CASCADE;
DROP TABLE srdb.assessment CASCADE;
DROP TABLE srdb.assessmethod CASCADE;
DROP TABLE srdb.assessor CASCADE;
--DROP TABLE srdb.nmfsstock CASCADE;
DROP TABLE srdb.stock CASCADE;
DROP TABLE srdb.area CASCADE;
DROP TABLE srdb.taxonomy CASCADE;
DROP TABLE srdb.management CASCADE;
DROP TABLE srdb.recorder CASCADE;
DROP SCHEMA srdbrecovery;
DROP SCHEMA srdb CASCADE;
