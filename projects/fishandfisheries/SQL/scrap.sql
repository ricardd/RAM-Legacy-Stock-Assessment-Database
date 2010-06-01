SELECT
b.assessid, e.commonname1, d.areaID, b.Linf, b.VBK, b.MAXAGE, b.Fecundity 
FROM
(SELECT 
*
FROM 
(SELECT assessid, 
(CASE WHEN bioid = 'Linf-cm' THEN biovalue ELSE NULL END) as Linf,
(CASE WHEN bioid like 'VB-k%' THEN biovalue ELSE NULL END) as VBK,
(CASE WHEN bioid = 'MAX-AGE-yr' THEN biovalue ELSE NULL END) as MAXAGE,
(CASE WHEN bioid = 'Fecundity-N' THEN biovalue ELSE NULL END) as Fecundity
FROM srdb.bioparams) as a
WHERE 
(a.Linf >'30' AND a.Linf <'50') OR
(a.VBK > '0.2' AND a.VBK < '0.4') OR
(a.MAXAGE > '8' AND a.MAXAGE < '12') OR
a.Fecundity < '1000' 
) as b,
srdb.assessment as c,
srdb.stock as d,
srdb.taxonomy as e
WHERE
b.assessid=c.assessid AND
c.stockid=d.stockid AND
d.tsn=e.tsn
;




