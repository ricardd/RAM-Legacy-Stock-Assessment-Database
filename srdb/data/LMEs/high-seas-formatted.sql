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

INSERT INTO lmes VALUES (-94, -94, -999, -999, -999, -999, -94, 'Atlantic High Seas hourglass',-999, NULL, -999, -999, geomfromtext('MULTIPOLYGON(((-53.4375 42.86308, -58.359375 41.297618, -62.226562 37.49578, -63.984375 32.901727, -63.984375 27.434189, -60.46875 23.305936, -55.898437 20.039417, -50.976562 18.712853, -45 16.028918, -40.078125 12.279892, -35.507812 5.685956, -31.640625 -0.28125, -28.476562 -6.943877, -28.476562 -13.855148, -30.585937 -21.551198, -34.804687 -27.30931, -39.023437 -33.957942, -43.242187 -40.66064, -43.59375 -45.779784, -40.429687 -49.565128, -35.507812 -51.79231, -26.71875 -52.009232, -18.28125 -51.135245, -9.492187 -48.177809, -4.570312 -45.779784, 1.40625 -40.926796, 4.570313 -34.828235, 5.273438 -27.30931, 3.164063 -19.907253, -1.40625 -11.454185, -5.625 -6.943877, -9.84375 -3.443239, -16.171875 -2.038633, -21.796875 1.124927, -26.367187 7.432193, -30.585937 13.650256, -31.289062 21.681931, -28.828125 26.808382, -25.3125 32.901727, -23.90625 38.603134, -24.257812 40.767229, -28.125 43.885224, -33.046875 44.890125, -39.726562 45.138654, -46.054687 44.640517, -50.273437 43.885224, -53.4375 42.86308 )))',4326 ));

