select
tt.commonname1 as "Common name", '\\' || 'textit{' || tt.scientificname || '}' as "Scientific name", bb.stockid, count(*) as "N. assessments"
FROM
srdb.assessment aa,
srdb.stock bb,
srdb.taxonomy tt
WHERE
aa.stockid=bb.stockid AND
bb.tsn=tt.tsn AND
aa.assessid in (SELECT distinct assessid from nceasplots)
GROUP BY
tt.commonname1, tt.scientificname, bb.stockid
ORDER BY
tt.commonname1, tt.scientificname, bb.stockid;

