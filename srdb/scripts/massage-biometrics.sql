-- normalize the units for the reference points
-- Started 2009-03-10
-- Last modified Time-stamp: <2010-03-19 14:50:27 (srdbadmin)>
-- Modification history:
-- 2010

UPDATE srdb.bioparams 
SET biovalue = cast(biovalue as float) * 1000, bioid = 'Blim-MT'
WHERE bioid = 'Blim-E03MT';

UPDATE srdb.bioparams 
SET biovalue = cast(biovalue as float) * 1000, bioid = 'Bmsy-MT'
WHERE bioid = 'Bmsy-E03MT';

UPDATE srdb.bioparams 
SET biovalue = cast(biovalue as float) * 1000, bioid = 'MSY-MT'
WHERE bioid = 'MSY-E03MT';

UPDATE srdb.bioparams 
SET biovalue = (cast(biovalue as float))*100000, bioid = 'SSBmsy-E03eggs'
WHERE bioid = 'SSBmsy-E08eggs';

UPDATE srdb.bioparams 
SET biovalue = (cast(biovalue as float))*100000, bioid = 'SSB0-E03eggs'
WHERE bioid = 'SSB0-E08eggs';

UPDATE srdb.bioparams 
SET biovalue = (cast(biovalue as float))*100000, bioid = 'SSBtarget-E03eggs'
WHERE bioid = 'SSBtarget-E08eggs';

UPDATE srdb.bioparams 
SET biovalue = (cast(biovalue as float))*1000000, bioid = 'Blim-E03eggs'
WHERE bioid = 'Blim-E09eggs';

UPDATE srdb.bioparams 
SET biovalue = (cast(biovalue as float))*1000000, bioid = 'SSBlim-E03eggs'
WHERE bioid = 'SSBlim-E09eggs';

UPDATE srdb.bioparams 
SET biovalue = (cast(biovalue as float))*1000000, bioid = 'SSBmsy-E03eggs'
WHERE bioid = 'SSBmsy-E09eggs';

UPDATE srdb.bioparams 
SET biovalue = (cast(biovalue as float))*1000000, bioid = 'SSB0-E03eggs'
WHERE bioid = 'SSB0-E09eggs';

UPDATE srdb.bioparams 
SET biovalue = (cast(biovalue as float)) * 1000000, bioid = 'SSBtarget-E03eggs'
WHERE bioid = 'SSBtarget-E09eggs';

UPDATE srdb.bioparams 
SET bioid = 'BH-h-dimless'
WHERE bioid = 'BH-h-dimensionless';

UPDATE srdb.bioparams 
SET biovalue = (cast(biovalue as float)*1.0)/1000, bioid = 'SSBmsy-E03eggs'
WHERE bioid = 'SSBmsy-E00eggs';


-- THIS WON'T WORK, IT NEEDS DATA FROM ANOTHER TABLE!!
--------------------------------------------------------------------------
-- UPDATE srdb.bioparams
-- SET bioyear = 
-- WHERE bioyear IS NULL;