-- triggers-srdb.sql
--
-- Time-stamp: <2008-11-25 10:26:02 (ricardd)>
--
-- rematerialize the views when a new stock is added
-- this trigger depends on the "mattsview" function defined in trigger-fct.sql
CREATE TRIGGER rematerializetsview 
AFTER INSERT OR UPDATE
ON srdb.assessment
EXECUTE PROCEDURE mattsview

