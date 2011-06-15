BEGIN;
 INSERT INTO srdb.assessment VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK', 'AFSC', 'WPOLLGA', 'MELNYCHUK', '2009-04-16', '2011-06-14 14:17:38', '1964-2008', 'http://www.afsc.noaa.gov/refm/docs/2008/GOApollock.pdf', 'Martin Dorn', 'catches from 1986-1990 were adjusted for discards; catches from 1997-2007 include dicards; unsure about 1991-1996', '', 1, 1, 'AD-CAM', '', '../spreadsheets/MELNYCHUK-WPOLLGA-2008-editedDR.xls', '999') ; 
 INSERT INTO srdb.referencedoc VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK', 'ID', 'AFSC-WPOLLGA-2008-Walleye pollock GA.pdf') ; 
 INSERT INTO srdb.referencedoc VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK', 'TY', 'RPRT') ; 
 INSERT INTO srdb.referencedoc VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK', 'A1', 'Dorn, Martin') ; 
 INSERT INTO srdb.referencedoc VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK', 'A1', 'Aydin, K., Barbeaux, S., Guttormsen, M., Megrey, B., Spalinger, K., and Wilkins, M.') ; 
 INSERT INTO srdb.referencedoc VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK', 'T1', '1.   Gulf of Alaska Walleye Pollock  ') ; 
 INSERT INTO srdb.referencedoc VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK', 'VL', 'North Pacific Groundfish Stock Assessment and Fishery Evaluation Reports for 2009 ') ; 
 INSERT INTO srdb.referencedoc VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK', 'Y1', '2008') ; 
 INSERT INTO srdb.referencedoc VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK', 'PB', 'North Pacific Fishery Management Council ') ; 
 INSERT INTO srdb.referencedoc VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK', 'CY', 'Anchorage, AK') ; 
 INSERT INTO srdb.referencedoc VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK', 'ZZID', 'AFSC-WPOLLGA-1964-2008-MELNYCHUK') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-AGE-yr','4.9', 'NULL', '') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-SEX-sex','1', 'NULL', '') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','REC-AGE-yr','2', 'NULL', '') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-AGE-yr','3+', 'NULL', '') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-TYPE-0-1','0', 'NULL', '') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','A50-yr','4.9', 'NULL', 'range from 3.7 in 1984 to 6.1 in 1991') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','Habitat-Habitat','demersal marine', 'NULL', '') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','L50-cm','43', 'NULL', '') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','M-1/yr','0.3', 'NULL', 'assumed value; range of 0.24 to 0.30 was estimated under different methods by Hollowed, A.B. and B.A. Megrey.  1990.  Walleye pollock.  In Stock Assessment and Fishery Evaluation Report for the 1991 Gulf of Alaska Groundfish Fishery.  Prepared by the Gulf of Alaska Groundfish Plan Team, North Pacific Fishery Management Council, P.O. Box 103136, Anchorage, AK 99510. ') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','MAX-AGE-yr','22', 'NULL', '') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','Fmsy-1/yr','0.286', 'NULL', 'F35%; is a proxy for Fmsy for tier 3 stocks') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','NATMORT-1/yr','0.3', 'NULL', 'assumed value; range of 0.24 to 0.30 was estimated under different methods by Hollowed, A.B. and B.A. Megrey.  1990.  Walleye pollock.  In Stock Assessment and Fishery Evaluation Report for the 1991 Gulf of Alaska Groundfish Fishery.  Prepared by the Gulf of Alaska Groundfish Plan Team, North Pacific Fishery Management Council, P.O. Box 103136, Anchorage, AK 99510. ') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','F40%-1/T','0.245', 'NULL', '') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSBmsy-MT','208000', 'NULL', 'SSB35%; is a proxy for SSBmsy for tier 3 stocks') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','MSY-MT','169000', 'NULL', '') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','Umsy-ratio','0.187', 'NULL', '') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','Bmsy-MT','903000', 'NULL', '') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSBF40%-MT','237000', 'NULL', '') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','BF40%-MT','975000', 'NULL', '') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','U40%-ratio','0.161', 'NULL', '') ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1964, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1965, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1966, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1967, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1968, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1969, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1970, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1971, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1972, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1973, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1974, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1975, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1976, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1977, 502000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1978, 545000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1979, 555000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1980, 613000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1981, 502000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1982, 580000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1983, 709000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1984, 745000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1985, 675000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1986, 551000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1987, 463000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1988, 419000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1989, 404000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1990, 362000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1991, 343000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1992, 302000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1993, 335000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1994, 383000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1995, 349000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1996, 314000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1997, 270000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1998, 204000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',1999, 185000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',2000, 172000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',2001, 167000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',2002, 139000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',2003, 130000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',2004, 141000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',2005, 178000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',2006, 185000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',2007, 164000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','SSB-MT',2008, 161000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1964, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1965, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1966, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1967, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1968, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1969, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1970, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1971, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1972, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1973, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1974, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1975, 2043) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1976, 2820) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1977, 2591) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1978, 3636) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1979, 1840) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1980, 446) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1981, 504) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1982, 210) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1983, 482) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1984, 1629) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1985, 553) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1986, 160) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1987, 375) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1988, 1617) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1989, 1007) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1990, 400) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1991, 237) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1992, 142) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1993, 215) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1994, 830) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1995, 394) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1996, 167) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1997, 151) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1998, 206) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',1999, 821) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',2000, 745) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',2001, 112) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',2002, 93) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',2003, 83) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',2004, 307) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',2005, 618) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',2006, 600) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',2007, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','R-E06',2008, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1964, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1965, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1966, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1967, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1968, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1969, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1970, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1971, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1972, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1973, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1974, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1975, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1976, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1977, 2145000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1978, 2319000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1979, 2840000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1980, 3333000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1981, 4020000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1982, 4157000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1983, 3515000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1984, 2846000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1985, 2114000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1986, 1709000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1987, 1763000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1988, 1659000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1989, 1502000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1990, 1277000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1991, 1388000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1992, 1696000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1993, 1535000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1994, 1284000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1995, 1078000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1996, 891000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1997, 902000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1998, 820000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',1999, 659000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',2000, 577000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',2001, 542000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',2002, 668000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',2003, 804000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',2004, 706000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',2005, 589000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',2006, 503000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',2007, 481000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TB-MT',2008, 537000) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1964, 1126) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1965, 2749) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1966, 8932) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1967, 6276) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1968, 6164) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1969, 17553) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1970, 9343) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1971, 9458) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1972, 34081) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1973, 36836) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1974, 61880) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1975, 59512) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1976, 86527) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1977, 118356) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1978, 96935) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1979, 105748) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1980, 114622) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1981, 147744) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1982, 168740) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1983, 215608) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1984, 307401) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1985, 284826) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1986, 87809) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1987, 69751) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1988, 65739) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1989, 78392) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1990, 90744) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1991, 100488) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1992, 90857) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1993, 108908) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1994, 107335) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1995, 72618) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1996, 51263) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1997, 90130) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1998, 125098) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',1999, 95590) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',2000, 73080) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',2001, 72076) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',2002, 51937) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',2003, 50666) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',2004, 63913) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',2005, 80876) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',2006, 71998) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',2007, 52120) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-WPOLLGA-1964-2008-MELNYCHUK','TC-MT',2008, NULL) ; 
COMMIT;