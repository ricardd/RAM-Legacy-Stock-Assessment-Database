BEGIN;
 INSERT INTO srdb.assessment VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH', 'NWFSC', 'WROCKPCOAST', 'BRANCH', '2008-11-23', '2011-06-14 14:17:27', '1955-2006', 'http://www.pcouncil.org/groundfish/gfsafe1008/WidowStockAssessment_Update_2007_Final_Oct_2007.pdf', '', '', '', 1, 1, 'AD-CAM', 'Purpose built code for this assessment', '../spreadsheets/BRANCH-WROCKPCOAST-2007-editedDR.xls', '999') ; 
 INSERT INTO srdb.referencedoc VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH', 'ID', 'NWFSC-WROCKPCOAST-2007-widow.pdf') ; 
 INSERT INTO srdb.referencedoc VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH', 'TY', 'RPRT') ; 
 INSERT INTO srdb.referencedoc VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH', 'A1', 'He X') ; 
 INSERT INTO srdb.referencedoc VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH', 'A1', 'Pearson DE, Dick EJ, Field JC, Ralston S, MacCall AD') ; 
 INSERT INTO srdb.referencedoc VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH', 'T1', 'Status of the widow rockfish resource in 2007: an update') ; 
 INSERT INTO srdb.referencedoc VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH', 'VL', '') ; 
 INSERT INTO srdb.referencedoc VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH', 'Y1', '2007') ; 
 INSERT INTO srdb.referencedoc VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH', 'PB', 'Pacific Fisheries Management Council') ; 
 INSERT INTO srdb.referencedoc VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH', 'CY', '') ; 
 INSERT INTO srdb.referencedoc VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH', 'ZZID', 'NWFSC-WROCKPCOAST-1955-2006-BRANCH') ; 
 INSERT INTO srdb.bioparams VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-SEX-sex','1', '', '') ; 
 INSERT INTO srdb.bioparams VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','REC-AGE-yr','3', '', '') ; 
 INSERT INTO srdb.bioparams VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','REC-ESTIMATED-yr-yr','1955-1996', '', 'back-dated three years (recruits 3yr old)') ; 
 INSERT INTO srdb.bioparams VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-AGE-yr-yr','3+', '', 'plus group is 20') ; 
 INSERT INTO srdb.bioparams VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-SEX-sex','0', '', '') ; 
 INSERT INTO srdb.bioparams VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-CALC-0-1-2','0', '', '') ; 
 INSERT INTO srdb.bioparams VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-TYPE-0-1','0', '', '') ; 
 INSERT INTO srdb.bioparams VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-AGE-yr','3+', '', '') ; 
 INSERT INTO srdb.bioparams VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','LW-a-kg/cm','0.00545', '', '') ; 
 INSERT INTO srdb.bioparams VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','LW-b-dimensionless','3.28781', '', '') ; 
 INSERT INTO srdb.bioparams VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','M-1/yr','0.125', '', 'fixed but uncertain') ; 
 INSERT INTO srdb.bioparams VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','VB-k-cm/T','0.14', '', 'females north (where most catches were)') ; 
 INSERT INTO srdb.bioparams VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','VB-t0-yr','-2.68', '', 'females north (where most catches were)') ; 
 INSERT INTO srdb.bioparams VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','BH-h-dimensionless','0.29', '', 'estimated with low prior weight on small values') ; 
 INSERT INTO srdb.bioparams VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','Blim-MT','39194', '', 'min in this assessment') ; 
 INSERT INTO srdb.bioparams VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSBmsy-E06eggs','20298', '', '') ; 
 INSERT INTO srdb.bioparams VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','Fmsy-1/yr','0.121', '', '') ; 
 INSERT INTO srdb.bioparams VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB0-E06eggs','50746', '', '') ; 
 INSERT INTO srdb.bioparams VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSBtarget-E06eggs','20298', '', '') ; 
 INSERT INTO srdb.bioparams VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSBmin-ratio','0.25', '', '') ; 
 INSERT INTO srdb.bioparams VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','Ftarget-1/yr','0.121', '', '') ; 
 INSERT INTO srdb.bioparams VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SPRtarget-ratio','0.4', '', '') ; 
 INSERT INTO srdb.bioparams VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','Linf-cm','50.5', '', 'females north (where most catches were)') ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1955, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1956, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1957, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1958, 119006) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1959, 119023) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1960, 119097) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1961, 119252) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1962, 119483) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1963, 119766) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1964, 120023) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1965, 120198) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1966, 120204) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1967, 117920) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1968, 115239) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1969, 113944) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1970, 114140) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1971, 114905) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1972, 116329) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1973, 118737) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1974, 121270) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1975, 125645) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1976, 130035) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1977, 132416) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1978, 131923) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1979, 128581) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1980, 122405) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1981, 105278) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1982, 86732) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1983, 71221) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1984, 67197) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1985, 66185) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1986, 67421) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1987, 69818) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1988, 70119) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1989, 69371) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1990, 65108) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1991, 60851) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1992, 58084) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1993, 54928) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1994, 50630) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1995, 47835) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1996, 45917) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1997, 45600) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1998, 45148) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',1999, 44774) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',2000, 43209) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',2001, 40888) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',2002, 39419) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',2003, 39194) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',2004, 40131) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',2005, 43017) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-MT',2006, 47478) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1955, 34152) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1956, 34221) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1957, 34248) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1958, 34108) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1959, 33555) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1960, 32982) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1961, 31526) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1962, 31650) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1963, 28162) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1964, 35997) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1965, 39154) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1966, 40511) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1967, 42282) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1968, 44704) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1969, 41551) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1970, 90448) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1971, 32579) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1972, 13728) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1973, 11264) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1974, 17009) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1975, 21795) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1976, 11539) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1977, 39262) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1978, 59049) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1979, 22302) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1980, 66907) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1981, 80725) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1982, 29116) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1983, 29471) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1984, 29931) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1985, 23296) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1986, 10683) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1987, 24898) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1988, 16128) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1989, 16102) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1990, 29824) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1991, 45363) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1992, 13939) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1993, 15758) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1994, 13534) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1995, 7470) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1996, 7663) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1997, 9847) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1998, 22504) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',1999, 18126) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',2000, 66180) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',2001, 16045) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',2002, 17236) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',2003, 16393) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',2004, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',2005, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','R-E03',2006, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1955, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1956, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1957, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1958, 0.000) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1959, 0.000) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1960, 0.000) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1961, 0.000) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1962, 0.000) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1963, 0.000) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1964, 0.000) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1965, 0.000) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1966, 0.036) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1967, 0.041) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1968, 0.020) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1969, 0.004) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1970, 0.006) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1971, 0.007) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1972, 0.004) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1973, 0.007) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1974, 0.005) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1975, 0.007) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1976, 0.010) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1977, 0.016) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1978, 0.008) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1979, 0.026) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1980, 0.223) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1981, 0.358) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1982, 0.434) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1983, 0.236) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1984, 0.223) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1985, 0.188) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1986, 0.173) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1987, 0.200) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1988, 0.153) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1989, 0.197) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1990, 0.176) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1991, 0.126) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1992, 0.128) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1993, 0.189) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1994, 0.167) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1995, 0.184) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1996, 0.170) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1997, 0.164) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1998, 0.101) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',1999, 0.108) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',2000, 0.118) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',2001, 0.065) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',2002, 0.018) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',2003, 0.002) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',2004, 0.004) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',2005, 0.007) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','F-1/yr',2006, 0.007) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1955, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1956, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1957, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1958, 243145) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1959, 243566) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1960, 244070) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1961, 244594) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1962, 244999) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1963, 245222) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1964, 244993) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1965, 244611) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1966, 243212) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1967, 239524) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1968, 236741) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1969, 237264) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1970, 240653) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1971, 245021) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1972, 248982) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1973, 265665) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1974, 270818) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1975, 269950) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1976, 265211) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1977, 259292) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1978, 252209) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1979, 241942) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1980, 235543) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1981, 216720) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1982, 187527) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1983, 173672) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1984, 181730) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1985, 179879) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1986, 179346) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1987, 176892) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1988, 167232) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1989, 156146) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1990, 145047) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1991, 133802) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1992, 126355) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1993, 123358) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1994, 123673) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1995, 118715) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1996, 113625) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1997, 108063) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1998, 99972) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',1999, 94495) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',2000, 89355) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',2001, 87514) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',2002, 88277) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',2003, 105582) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',2004, 110688) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',2005, 116042) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TB-MT',2006, 120132) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1955, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1956, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1957, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1958, 0) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1959, 0) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1960, 0) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1961, 0) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1962, 0) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1963, 0) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1964, 0) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1965, 0) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1966, 3766) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1967, 4149) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1968, 2029) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1969, 377) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1970, 555) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1971, 702) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1972, 423) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1973, 824) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1974, 573) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1975, 812) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1976, 1360) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1977, 2201) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1978, 1107) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1979, 3292) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1980, 21856) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1981, 27005) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1982, 26063) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1983, 10564) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1984, 10072) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1985, 9188) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1986, 9526) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1987, 12945) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1988, 10445) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1989, 12489) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1990, 10293) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1991, 6788) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1992, 6405) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1993, 8391) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1994, 6699) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1995, 6931) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1996, 6311) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1997, 6698) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1998, 4280) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',1999, 4162) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',2000, 4097) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',2001, 2035) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',2002, 508) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',2003, 55) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',2004, 109) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',2005, 219) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','TC-MT',2006, 281) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1955, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1956, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1957, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1958, 47481) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1959, 47481) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1960, 47488) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1961, 47514) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1962, 47576) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1963, 47670) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1964, 47776) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1965, 47875) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1966, 47941) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1967, 47125) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1968, 46127) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1969, 45536) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1970, 45384) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1971, 45410) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1972, 45694) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1973, 46298) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1974, 47013) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1975, 48104) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1976, 49697) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1977, 51534) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1978, 52503) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1979, 52133) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1980, 50269) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1981, 43657) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1982, 35867) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1983, 28812) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1984, 26352) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1985, 25142) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1986, 24840) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1987, 25488) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1988, 25960) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1989, 26185) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1990, 25053) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1991, 23792) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1992, 22929) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1993, 21803) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1994, 20150) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1995, 18887) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1996, 17764) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1997, 17372) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1998, 17280) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',1999, 17387) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',2000, 17107) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',2001, 16444) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',2002, 16040) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',2003, 15905) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',2004, 15963) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',2005, 16544) ; 
 INSERT INTO srdb.timeseries VALUES('NWFSC-WROCKPCOAST-1955-2006-BRANCH','SSB-E06eggs',2006, 17839) ; 
COMMIT;