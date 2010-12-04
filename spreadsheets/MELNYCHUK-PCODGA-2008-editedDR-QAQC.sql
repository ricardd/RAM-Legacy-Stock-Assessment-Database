BEGIN;
 INSERT INTO srdb.assessment VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK', 'AFSC', 'PCODGA', 'MELNYCHUK', '2009-04-16', '2010-12-02 20:31:08', '1964-2008', 'http://www.afsc.noaa.gov/refm/docs/2008/GOApollock.pdf', 'Grant Thompson, Grant.Thompson@noaa.gov', 'catches since 1980 include discards', '', 1, 1, 'SS2', '', '../spreadsheets/MELNYCHUK-PCODGA-2008-editedDR-QAQC.xls') ; 
 INSERT INTO srdb.referencedoc VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK', 'ID', 'AFSC-PCODGA-2008-Pacific-cod-GA.pdf') ; 
 INSERT INTO srdb.referencedoc VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK', 'TY', 'RPRT') ; 
 INSERT INTO srdb.referencedoc VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK', 'A1', 'Thompson, G.') ; 
 INSERT INTO srdb.referencedoc VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK', 'A1', 'Ianelli, J.') ; 
 INSERT INTO srdb.referencedoc VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK', 'A1', 'Wilkins, M.') ; 
 INSERT INTO srdb.referencedoc VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK', 'T1', '2:  Assessment of the Pacific Cod Stock in the Gulf of Alaska') ; 
 INSERT INTO srdb.referencedoc VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK', 'VL', 'North Pacific Groundfish Stock Assessment and Fishery Evaluation Reports for 2009') ; 
 INSERT INTO srdb.referencedoc VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK', 'Y1', '2008') ; 
 INSERT INTO srdb.referencedoc VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK', 'PB', 'North Pacific Fisheries Management Council') ; 
 INSERT INTO srdb.referencedoc VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK', 'CY', 'Anchorage, AK') ; 
 INSERT INTO srdb.referencedoc VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK', 'ZZID', 'AFSC-PCODGA-1964-2008-MELNYCHUK') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-AGE-yr','4.3', 'age at 50% maturity', 'NULL') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-SEX-sex','1', '', 'NULL') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','REC-AGE-yr','0', '', 'NULL') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-AGE-yr','0+', '', 'NULL') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-TYPE-0-1','0', '', 'NULL') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','A50-yr','4.3', '', 'NULL') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','MAT-SEX-sex','1', '', 'NULL') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','MAT-REF-doctype','Stark, J. W.  2007.  Geographic and seasonal variations in maturation and growth of female Pacific cod (Gadus macrocephalus) in the Gulf of Alaska and Bering Sea.  Fish. Bull. 105:396-407. ', '', 'NULL') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','Habitat-Habitat','demersal marine', '', 'NULL') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','L50-cm','58', '', 'NULL') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','LEN-SEX-sex','1', '', 'NULL') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','LEN-REF-doctype','Stark, J. W.  2007.  Geographic and seasonal variations in maturation and growth of female Pacific cod (Gadus macrocephalus) in the Gulf of Alaska and Bering Sea.  Fish. Bull. 105:396-407. ', '', 'NULL') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','LW-a-kg/cm','8.84E-06', '', 'NULL') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','LW-b-dimensionless','3.072', '', 'NULL') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','M-1/yr','0.38', 'based on Equation 7 of Jensen (1996) and ages at 50% maturity reported by (Stark 2007', 'NULL') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','Fmsy-1/yr','0.64', 'F35%; is a proxy for Fmsy for tier 3 stocks', 'NULL') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','NATMORT-1/yr','0.38', 'based on Equation 7 of Jensen (1996) and ages at 50% maturity reported by (Stark 2007', 'NULL') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','F40%-1/T','0.52', '', 'NULL') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSBmsy-MT','89400', 'SSB35%; is a proxy for SSBmsy for tier 3 stocks', 'NULL') ; 
 INSERT INTO srdb.bioparams VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSBF40%-MT','102200', 'SSB35%; is a proxy for SSBmsy for tier 3 stocks', 'NULL') ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1964, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1965, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1966, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1967, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1968, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1969, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1970, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1971, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1972, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1973, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1974, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1975, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1976, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1977, 42383) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1978, 46819) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1979, 49013) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1980, 48282) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1981, 58523) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1982, 84423) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1983, 90265) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1984, 91090) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1985, 103996) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1986, 120116) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1987, 131660) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1988, 132230) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1989, 142571) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1990, 143190) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1991, 124241) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1992, 111780) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1993, 100449) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1994, 104843) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1995, 116013) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1996, 112578) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1997, 107972) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1998, 101303) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',1999, 99278) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',2000, 96551) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',2001, 91471) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',2002, 86583) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',2003, 81476) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',2004, 86338) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',2005, 89380) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',2006, 87240) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',2007, 83482) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','SSB-MT',2008, 81473) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1964, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1965, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1966, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1967, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1968, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1969, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1970, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1971, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1972, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1973, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1974, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1975, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1976, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1977, 567) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1978, 33) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1979, 119) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1980, 293) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1981, 129) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1982, 347) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1983, 15) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1984, 366) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1985, 258) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1986, 77) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1987, 286) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1988, 178) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1989, 223) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1990, 314) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1991, 183) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1992, 205) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1993, 229) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1994, 193) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1995, 313) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1996, 158) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1997, 166) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1998, 119) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',1999, 248) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',2000, 263) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',2001, 122) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',2002, 160) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',2003, 159) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',2004, 193) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',2005, 273) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',2006, 1334) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',2007, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','R-E06',2008, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1964, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1965, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1966, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1967, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1968, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1969, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1970, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1971, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1972, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1973, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1974, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1975, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1976, NULL) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1977, 130021) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1978, 146875) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1979, 180466) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1980, 225141) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1981, 247593) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1982, 266290) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1983, 287676) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1984, 305012) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1985, 330223) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1986, 364116) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1987, 390721) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1988, 400823) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1989, 405770) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1990, 401025) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1991, 374683) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1992, 356112) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1993, 340730) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1994, 346463) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1995, 358082) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1996, 351127) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1997, 347741) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1998, 335431) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',1999, 321952) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',2000, 295611) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',2001, 282343) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',2002, 285445) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',2003, 284783) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',2004, 281936) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',2005, 272978) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',2006, 280114) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',2007, 311870) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TB-MT',2008, 405367) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1964, 196) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1965, 599) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1966, 1376) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1967, 2225) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1968, 1046) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1969, 1335) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1970, 1805) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1971, 523) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1972, 3513) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1973, 5963) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1974, 5182) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1975, 6745) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1976, 6764) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1977, 2267) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1978, 12190) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1979, 14904) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1980, 35345) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1981, 36131) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1982, 29465) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1983, 36540) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1984, 23898) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1985, 14428) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1986, 25012) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1987, 32939) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1988, 33802) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1989, 43293) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1990, 72517) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1991, 76328) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1992, 80746) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1993, 56487) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1994, 47484) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1995, 68985) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1996, 68280) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1997, 77017) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1998, 72524) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',1999, 81784) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',2000, 66559) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',2001, 51541) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',2002, 54483) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',2003, 52498) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',2004, 54591) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',2005, 47541) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',2006, 47756) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',2007, 51489) ; 
 INSERT INTO srdb.timeseries VALUES('AFSC-PCODGA-1964-2008-MELNYCHUK','TC-MT',2008, NULL) ; 
COMMIT;