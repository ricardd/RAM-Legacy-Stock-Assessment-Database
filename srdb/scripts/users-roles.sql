-- users-groups.sql
-- SQL to create the proper users and groups on the postgresql server
-- this file must be loaded as postgresql user "postgres"
-- Time-stamp: <2008-11-17 16:52:14 (ricardd)>

-- as user postgres, i.e. "sudo -u postgres psql":
-- srdb administrator
CREATE ROLE srdbadmin LOGIN SUPERUSER PASSWORD 'srdb2008!';

-- general srdb user
CREATE ROLE srdbuser LOGIN PASSWORD 'srd6us3r!';

-- project-specific users
CREATE ROLE srdbrecovery LOGIN PASSWORD 'r3cov3ry!';
CREATE ROLE srdbdepensation LOGIN PASSWORD 'd3p3nsation!';

REVOKE CREATE ON SCHEMA public FROM srdbuser;
REVOKE CREATE ON SCHEMA public FROM srdbrecovery;
-- REVOKE CREATE ON SCHEMA public FROM PUBLIC;

-- now create the database owned by user "srdbadmin": createdb srdb -O srdbadmin

----------- NOW IN srdb AS "srdbadmin"
GRANT USAGE ON SCHEMA srdb TO srdbuser;
REVOKE CREATE ON DATABASE srdb FROM srdbuser;



GRANT USAGE ON SCHEMA srdb TO srdbrecovery;
GRANT CREATE ON SCHEMA srdbrecovery TO srdbrecovery;
REVOKE CREATE ON SCHEMA srdb FROM srdbrecovery;


GRANT USAGE ON SCHEMA srdb TO srdbdepensation;

