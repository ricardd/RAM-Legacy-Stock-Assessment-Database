BEGIN;
 INSERT INTO srdb.assessment VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK', 'AFSC', 'ALPLAICBSAI', 'MELNYCHUK', '2009-04-14', '2010-05-10 16:05:19', '1972-2008', 'http://www.afsc.noaa.gov/refm/docs/2008/BSAIplaice.pdf', 'Thomas Wilderbuer, Tom.Wilderbuer@noaa.gov', '', '', 1, 1, 'AD-CAM', 'no comments', '../spreadsheets/MELNYCHUK-ALPLAICBSAI-2008-editedDR-QAQC.xls') ; 
 INSERT INTO srdb.referencedoc VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK', 'ID', 'AFSC-ALPLAICBSAI-2008-Alaska plaice BSAI.pdf') ; 
 INSERT INTO srdb.referencedoc VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK', 'TY', 'RPRT') ; 
 INSERT INTO srdb.referencedoc VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK', 'A1', 'Wilderbuer WT') ; 
 INSERT INTO srdb.referencedoc VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK', 'A1', 'Nichol DG, Spencer PD') ; 
 INSERT INTO srdb.referencedoc VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK', 'T1', 'Chapter 9: Alaska plaice') ; 
 INSERT INTO srdb.referencedoc VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK', 'VL', 'North Pacific Groundfish Stock Assessment and Fishery Evaluation Reports for 2009') ; 
 INSERT INTO srdb.referencedoc VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK', 'Y1', '2008') ; 
 INSERT INTO srdb.referencedoc VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK', 'PB', 'North Pacific Fisheries Management Council') ; 
 INSERT INTO srdb.referencedoc VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK', 'CY', 'Anchorage, AK') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-SEX-sex','1', 'NULL', '') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','REC-AGE-yr','3', 'NULL', '') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-AGE-yr-yr','3+', 'NULL', '') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-SEX-sex','0', 'NULL', '') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-CALC-0-1-2','1', 'NULL', '') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-AGE-yr','3+', 'NULL', '') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-TYPE-0-1','0', 'NULL', '') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','VB-k-cm/T','0.1315', 'NULL', '') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','VB-t0-yr','0.1334', 'NULL', '') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','Habitat-Habitat','demersal marine', 'NULL', '') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','Linf-cm','45.6', 'NULL', '') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','LW-a-kg/cm','0.007', 'NULL', '') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','LW-b-dimensionless','3.15', 'NULL', '') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','M-1/yr','0.25', 'NULL', 'result of previous assessment profiling; may range from 0.195 for males to 0.27 for females') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','MAX-AGE-yr','25', 'NULL', 'oldest ages found in trawl surveys') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','Fmsy-1/yr','0.62', 'NULL', 'note, the value in the table on p.1 of the assessment is switched with F40%') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','NATMORT-1/yr','0.25', 'NULL', 'result of previous assessment profiling; may range from 0.195 for males to 0.27 for females') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F40%-1/T','0.86', 'NULL', 'note, the value in the table on p.1 of the assessment is switched with Fmsy') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSBmsy-MT','129300', 'NULL', '') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSBF40%-MT','147850', 'NULL', '') ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',1972, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',1973, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',1974, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',1975, 172125) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',1976, 208732) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',1977, 247863) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',1978, 281912) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',1979, 308075) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',1980, 337365) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',1981, 370607) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',1982, 411737) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',1983, 443838) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',1984, 469901) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',1985, 476423) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',1986, 468456) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',1987, 451535) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',1988, 432878) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',1989, 404037) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',1990, 387198) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',1991, 369813) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',1992, 350450) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',1993, 333477) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',1994, 323936) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',1995, 318627) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',1996, 310472) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',1997, 307622) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',1998, 300812) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',1999, 300783) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',2000, 295967) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',2001, 292180) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',2002, 284077) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',2003, 275286) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',2004, 267245) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',2005, 265295) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',2006, 268379) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',2007, 284426) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','SSB-MT',2008, 318176) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',1972, 2101) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',1973, 3630) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',1974, 1922) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',1975, 1896) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',1976, 1831) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',1977, 1327) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',1978, 1495) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',1979, 1445) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',1980, 1532) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',1981, 692) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',1982, 772) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',1983, 1339) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',1984, 877) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',1985, 1099) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',1986, 1727) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',1987, 883) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',1988, 1295) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',1989, 912) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',1990, 1526) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',1991, 1034) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',1992, 1131) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',1993, 652) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',1994, 785) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',1995, 825) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',1996, 1073) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',1997, 1259) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',1998, 1679) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',1999, 1886) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',2000, 3769) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',2001, 4080) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',2002, 850) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',2003, 722) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',2004, 397) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',2005, 681) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',2006, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',2007, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','R-E06',2008, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',1972, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',1973, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',1974, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',1975, 0.013) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',1976, 0.017) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',1977, 0.01) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',1978, 0.032) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',1979, 0.035) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',1980, 0.016) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',1981, 0.019) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',1982, 0.014) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',1983, 0.02) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',1984, 0.031) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',1985, 0.038) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',1986, 0.069) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',1987, 0.028) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',1988, 0.096) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',1989, 0.024) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',1990, 0.019) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',1991, 0.026) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',1992, 0.033) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',1993, 0.027) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',1994, 0.023) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',1995, 0.042) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',1996, 0.037) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',1997, 0.049) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',1998, 0.033) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',1999, 0.033) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',2000, 0.035) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',2001, 0.021) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',2002, 0.029) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',2003, 0.024) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',2004, 0.019) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',2005, 0.029) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',2006, 0.047) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',2007, 0.054) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','F-1/yr',2008, 0.043) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',1972, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',1973, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',1974, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',1975, 1136420) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',1976, 1293040) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',1977, 1426510) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',1978, 1538610) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',1979, 1627500) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',1980, 1686430) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',1981, 1718730) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',1982, 1729330) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',1983, 1721590) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',1984, 1669490) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',1985, 1593060) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',1986, 1501420) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',1987, 1430420) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',1988, 1324270) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',1989, 1295700) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',1990, 1262020) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',1991, 1237030) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',1992, 1204320) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',1993, 1194400) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',1994, 1182570) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',1995, 1165200) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',1996, 1137060) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',1997, 1099280) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',1998, 1065360) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',1999, 1037760) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',2000, 1021130) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',2001, 1033790) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',2002, 1066910) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',2003, 1181750) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',2004, 1361180) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',2005, 1479680) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',2006, 1550420) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',2007, 1562280) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TB-MT',2008, 1537920) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',1972, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',1973, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',1974, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',1975, 2492) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',1976, 3620) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',1977, 2589) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',1978, 10420) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',1979, 13672) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',1980, 6902) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',1981, 8653) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',1982, 6811) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',1983, 10766) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',1984, 18982) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',1985, 24888) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',1986, 46519) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',1987, 18567) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',1988, 61638) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',1989, 14134) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',1990, 10926) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',1991, 15003) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',1992, 18074) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',1993, 13846) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',1994, 10882) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',1995, 19172) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',1996, 16096) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',1997, 21236) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',1998, 14296) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',1999, 13997) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',2000, 14487) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',2001, 8685) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',2002, 12176) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',2003, 9978) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',2004, 7572) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',2005, 11079) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',2006, 17202) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',2007, 19427) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK','TC-MT',2008, NULL) ; 
COMMIT;