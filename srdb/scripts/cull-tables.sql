-- remove all unnecessary information in the database tables
-- this is mostly used to create a "tidy" version of the stock-recruitment database where unnecessary areas, stocks, species, etc are removed
-- Daniel Ricard, started 2009-03-16
-- Time-stamp: <2009-03-16 13:13:35 (ricardd)>
--

DELETE FROM srdb.stock where stockid not (SELECT distinct stockid from srdb.assessment);

DELETE FROM srdb.taxonomy where tsn not in (SELECT distinct tsn from srdb.stock);

DELETE FROM srdb.area where areaid  not in (SELECT distinct areaid from srdb.stock);

DELETE FROM srdb.biometrics where bioid not in (SELECT DISTINCT biounique from srdb.bioparams);

DELETE FROM srdb.tsmetrics where bioid not in (SELECT DISTINCT biounique from srdb.timeseries);

