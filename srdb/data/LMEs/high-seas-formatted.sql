DROP TABLE highseasformatted;
CREATE TABLE highseasformatted AS
(
select -99 as gid, -99 as objectid, -999 as area, -999 as perimeter, -999 as lme_2002_, -999 as lme_2002_i, -99 as lme_number, 'Pacific High Seas' as lme_name, -999 as sq_km, 'NULL' as website, -999 as shape_leng, -999 as shape_area, multi(ST_Union(the_geom)) as the_geom from highseas where gid in (1,4)
UNION
select -98 as gid, -98 as objectid, -999 as area, -999 as perimeter, -999 as lme_2002_, -999 as lme_2002_i, -98 as lme_number, 'Atlantic High Seas' as lme_name, -999 as sq_km, 'NULL' as website, -999 as shape_leng, -999 as shape_area, multi(ST_Union(the_geom)) as the_geom from highseas where gid in (6,7)
UNION
select -97 as gid, -97 as objectid, -999 as area, -999 as perimeter, -999 as lme_2002_, -999 as lme_2002_i, -97 as lme_number, 'Indian High Seas' as lme_name, -999 as sq_km, 'NULL' as website, -999 as shape_leng, -999 as shape_area, multi(ST_Union(the_geom)) as the_geom from highseas where gid in (5)
UNION
select -96 as gid, -96 as objectid, -999 as area, -999 as perimeter, -999 as lme_2002_, -999 as lme_2002_i, -96 as lme_number, 'Subantarctic High Seas' as lme_name, -999 as sq_km, 'NULL' as website, -999 as shape_leng, -999 as shape_area, multi(ST_Union(the_geom)) as the_geom from highseas where gid in (2,3)
);


INSERT INTO lmes (SELECT * FROM highseasformatted);

INSERT INTO lmes VALUES (-95, -95, -999, -999, -999, -999, -95, 'Caspian Sea',-999, NULL, -999, -999, geomfromtext('MULTIPOLYGON(((46.757813 44.865213, 49.570313 46.703709, 51.855469 46.82412, 53.085938 46.583028, 52.910156 45.853291, 51.679688 45.361409, 50.800781 44.74049, 50.449219 44.364704, 52.03125 42.837306, 52.734375 42.059081, 53.085938 39.801784, 53.964844 38.023862, 54.140625 37.188329, 52.03125 36.484907, 49.921875 37.188329, 49.21875 37.746394, 48.867188 39.123242, 49.746094 40.473695, 47.8125 42.708274, 46.757813 44.865213)))',4326 ));

