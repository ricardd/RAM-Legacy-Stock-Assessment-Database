-- snippet of SQL to generate the contents of the biometrics worksheet
-- INVOCATION:
-- psql srdb -f for-excel-template.sql -A -F'|' -o for-excel-template.cs
SELECT
bm.category,
bm.subcategory,
bm.bioshort,
bm.biolong,
bm.biounitsshort,
bm.biounitslong
FROM
srdb.biometrics bm
ORDER BY
bm.category DESC,
bm.subcategory DESC
;
-- SELECT DISTINCT category FROM srdb.assessmethod;