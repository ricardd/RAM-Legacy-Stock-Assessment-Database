drop table geo.temppoly;
create table geo.temppoly AS (
select 
1000 as gid,
-999 as area,
-999 as perimeter,
-999 as nafo_,
-999 as nafo_id,
'2J3KL' as zone,
-50.5 as x_coord,
50.7 as y_coord,
multi(ST_Union(the_geom)) as the_geom
from
geo.nafodivs
where
zone in ('2J','3K','3L')
)
;

INSERT INTO geo.nafodivs (SELECT * FROM geo.temppoly) ;


-- multi(ST_Union(the_geom))