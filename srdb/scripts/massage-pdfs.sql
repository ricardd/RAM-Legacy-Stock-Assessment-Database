-- when the value of "pdffile" in the assessment table is NULL, set it equal to the RIS entry for ID
--

UPDATE srdb.assessment
SET pdffile = NULL WHERE pdffile= 'NULL'
;UPDATE srdb.referencedoc
SET risentry = NULL 
WHERE risentry = 'NULL' and risfield = 'ID'
;

UPDATE srdb.referencedoc
SET risentry = risentry || '.pdf'
WHERE risentry NOT SIMILAR TO '%.pdf' and risfield = 'ID'
;


UPDATE srdb.assessment
SET pdffile = aa.risentry
FROM
(select a.assessid, a.pdffile, rd.risentry from srdb.assessment a, srdb.referencedoc rd where a.assessid=rd.assessid and rd.risfield='ID') as aa
WHERE
srdb.assessment.assessid = aa.assessid AND (srdb.assessment.pdffile is NULL OR srdb.assessment.pdffile='')
;
