--
-- Last modified Time-stamp: <2011-08-12 11:18:29 (srdbadmin)>

-- remove surplus production fits
drop table srdb.spfits;
drop table srdb.spfits_fox;
drop table srdb.spfits_fox_all;
drop table srdb.spfits_fox_summary;
drop table srdb.spfits_schaefer;
drop table srdb.spfits_schaefer_all;
drop table srdb.spfits_schaefer_kbound2maxtb;
drop table srdb.spfits_schaefer_kbound2maxtb_all;
drop table srdb.spfits_schaefer_kbound5maxtb;
drop table srdb.spfits_schaefer_kbound5maxtb_all;
drop table srdb.spfits_schaefer_summary;

-- remove fishfisheries schema and its tables
drop schema fishfisheries cascade;

-- remove the MTL table
drop table srdb.fishbasemtl;

-- remove the QAQC table
drop table srdb.qaqc;

-- remove the stocksbylme, highseas and highseasformatted tables from the public schema
drop table stocksbylme;
drop table highseasformatted;
drop table highseas;

-- remove other unwanted
drop table srdb.newtimeseries_values_view;
drop table srdb.ramunits;

-- the database now only contains the tables that appear in the Entity-Relationship Diagram in the Supporting Information of the 2011 Fish and Fisheries manuscript
