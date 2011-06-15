--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: srdb; Type: SCHEMA; Schema: -; Owner: srdbadmin
--

CREATE SCHEMA srdb;


ALTER SCHEMA srdb OWNER TO srdbadmin;

--
-- Name: SCHEMA srdb; Type: COMMENT; Schema: -; Owner: srdbadmin
--

COMMENT ON SCHEMA srdb IS 'This schema handles all tables and views for the RAM Legacy assessment database.';


--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: srdbadmin
--

CREATE PROCEDURAL LANGUAGE plpgsql;


ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO srdbadmin;

SET search_path = srdb, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: area; Type: TABLE; Schema: srdb; Owner: srdbadmin; Tablespace: 
--

CREATE TABLE area (
    country character varying(50),
    areatype character varying(40),
    areacode character varying(50),
    areaname character varying(100),
    alternateareaname character varying(50),
    areaid character varying(70) NOT NULL
);


ALTER TABLE srdb.area OWNER TO srdbadmin;

--
-- Name: TABLE area; Type: COMMENT; Schema: srdb; Owner: srdbadmin
--

COMMENT ON TABLE area IS 'Stock areas, used in the definition of stocks.';


--
-- Name: assessment; Type: TABLE; Schema: srdb; Owner: srdbadmin; Tablespace: 
--

CREATE TABLE assessment (
    assessid character varying(200) NOT NULL,
    assessorid character varying(40),
    stockid character varying(40),
    recorder character varying(40),
    daterecorded date,
    dateloaded date,
    assessyear character varying(9),
    assesssource character varying(1000),
    contacts character varying(300),
    notes character varying(1000),
    pdffile character varying(300),
    assess integer,
    refpoints integer,
    assessmethod character varying(200),
    assesscomments character varying(1000),
    xlsfilename character varying(100),
    mostrecent character varying(3)
);


ALTER TABLE srdb.assessment OWNER TO srdbadmin;

--
-- Name: TABLE assessment; Type: COMMENT; Schema: srdb; Owner: srdbadmin
--

COMMENT ON TABLE assessment IS 'Assesment-level details, defines ASSESSID.';


--
-- Name: assessmethod; Type: TABLE; Schema: srdb; Owner: srdbadmin; Tablespace: 
--

CREATE TABLE assessmethod (
    category character varying(100),
    methodshort character varying(20) NOT NULL,
    methodlong character varying(200)
);


ALTER TABLE srdb.assessmethod OWNER TO srdbadmin;

--
-- Name: TABLE assessmethod; Type: COMMENT; Schema: srdb; Owner: srdbadmin
--

COMMENT ON TABLE assessmethod IS 'Details of assessment methods.';


--
-- Name: assessor; Type: TABLE; Schema: srdb; Owner: srdbadmin; Tablespace: 
--

CREATE TABLE assessor (
    assessorid character varying(40) NOT NULL,
    mgmt character varying(40),
    country character varying(50),
    assessorfull character varying(200)
);


ALTER TABLE srdb.assessor OWNER TO srdbadmin;

--
-- Name: TABLE assessor; Type: COMMENT; Schema: srdb; Owner: srdbadmin
--

COMMENT ON TABLE assessor IS 'Details of assessors. An assessor must be associated with a management boby from the table srdb.management.';


--
-- Name: biometrics; Type: TABLE; Schema: srdb; Owner: srdbadmin; Tablespace: 
--

CREATE TABLE biometrics (
    category character varying(100),
    subcategory character varying(100),
    bioshort character varying(40),
    biolong character varying(300),
    biounitsshort character varying(40),
    biounitslong character varying(200),
    biounique character varying(70) NOT NULL
);


ALTER TABLE srdb.biometrics OWNER TO srdbadmin;

--
-- Name: TABLE biometrics; Type: COMMENT; Schema: srdb; Owner: srdbadmin
--

COMMENT ON TABLE biometrics IS 'Definition of point metrics such as reference points, life-history parameters and description of timeseries (e.g. age of recruitment, ages used in F calculations, etc.).';


--
-- Name: bioparams; Type: TABLE; Schema: srdb; Owner: srdbadmin; Tablespace: 
--

CREATE TABLE bioparams (
    assessid character varying(200),
    bioid character varying(40),
    biovalue character varying(200),
    bioyear character varying(15),
    bionotes character varying(1000)
);


ALTER TABLE srdb.bioparams OWNER TO srdbadmin;

--
-- Name: TABLE bioparams; Type: COMMENT; Schema: srdb; Owner: srdbadmin
--

COMMENT ON TABLE bioparams IS 'Values of point metrics.';


--
-- Name: management; Type: TABLE; Schema: srdb; Owner: srdbadmin; Tablespace: 
--

CREATE TABLE management (
    mgmt character varying(40) NOT NULL,
    country character varying(50),
    managementauthority character varying(200)
);


ALTER TABLE srdb.management OWNER TO srdbadmin;

--
-- Name: TABLE management; Type: COMMENT; Schema: srdb; Owner: srdbadmin
--

COMMENT ON TABLE management IS 'Management bodies, used in the definition of stock areas and stock assessors.';


--
-- Name: recorder; Type: TABLE; Schema: srdb; Owner: srdbadmin; Tablespace: 
--

CREATE TABLE recorder (
    firstname character varying(50),
    lastname character varying(50),
    email character varying(50),
    institution character varying(100),
    address character varying(1000),
    phonenumber character varying(50),
    notes character varying(1000),
    nameinxls character varying(50) NOT NULL
);


ALTER TABLE srdb.recorder OWNER TO srdbadmin;

--
-- Name: TABLE recorder; Type: COMMENT; Schema: srdb; Owner: srdbadmin
--

COMMENT ON TABLE recorder IS 'Details for recorders of assessments.';


--
-- Name: referencedoc; Type: TABLE; Schema: srdb; Owner: srdbadmin; Tablespace: 
--

CREATE TABLE referencedoc (
    assessid character varying(200),
    risfield character varying(50),
    risentry character varying(300)
);


ALTER TABLE srdb.referencedoc OWNER TO srdbadmin;

--
-- Name: TABLE referencedoc; Type: COMMENT; Schema: srdb; Owner: srdbadmin
--

COMMENT ON TABLE referencedoc IS 'RIS fields containing the reference document for an assessment.';


--
-- Name: risfields; Type: TABLE; Schema: srdb; Owner: srdbadmin; Tablespace: 
--

CREATE TABLE risfields (
    risfield character varying(50) NOT NULL,
    risdescription character varying(200)
);


ALTER TABLE srdb.risfields OWNER TO srdbadmin;

--
-- Name: TABLE risfields; Type: COMMENT; Schema: srdb; Owner: srdbadmin
--

COMMENT ON TABLE risfields IS 'Name of RIS fields.';


--
-- Name: risfieldvalues; Type: TABLE; Schema: srdb; Owner: srdbadmin; Tablespace: 
--

CREATE TABLE risfieldvalues (
    risfield character varying(50),
    allowedvalueshort character varying(10),
    allowedvaluelong character varying(200)
);


ALTER TABLE srdb.risfieldvalues OWNER TO srdbadmin;

--
-- Name: TABLE risfieldvalues; Type: COMMENT; Schema: srdb; Owner: srdbadmin
--

COMMENT ON TABLE risfieldvalues IS 'Allowed RIS field values.';


--
-- Name: stock; Type: TABLE; Schema: srdb; Owner: srdbadmin; Tablespace: 
--

CREATE TABLE stock (
    stockid character varying(40) NOT NULL,
    tsn integer,
    scientificname character varying(200),
    commonname character varying(200),
    areaid character varying(70),
    stocklong character varying(200),
    inmyersdb integer,
    myersstockid character varying(40)
);


ALTER TABLE srdb.stock OWNER TO srdbadmin;

--
-- Name: TABLE stock; Type: COMMENT; Schema: srdb; Owner: srdbadmin
--

COMMENT ON TABLE stock IS 'A stock consists of a species (field "tsn" from srdb.taxonomy), an area (field "areaid" from srdb.area). This table also keeps track of stocks that were in RAM''s original database and the name used there if it is different from the stockid defined in the RAM Legacy database';


--
-- Name: taxonomy; Type: TABLE; Schema: srdb; Owner: srdbadmin; Tablespace: 
--

CREATE TABLE taxonomy (
    tsn integer NOT NULL,
    scientificname character varying(200),
    kingdom character varying(200),
    phylum character varying(200),
    classname character varying(200),
    ordername character varying(200),
    family character varying(200),
    genus character varying(200),
    species character varying(200),
    myersname character varying(20),
    commonname1 character varying(200),
    commonname2 character varying(200),
    myersscientificname character varying(200),
    myersfamily character varying(50)
);


ALTER TABLE srdb.taxonomy OWNER TO srdbadmin;

--
-- Name: TABLE taxonomy; Type: COMMENT; Schema: srdb; Owner: srdbadmin
--

COMMENT ON TABLE taxonomy IS 'Taxonomic information obtained from the Integrated Taxonomic Information System (ITIS). Negative values for taxonomic serial number (TSN) are used in cases where a stock is of a species not present in ITIS.';


--
-- Name: timeseries; Type: TABLE; Schema: srdb; Owner: srdbadmin; Tablespace: 
--

CREATE TABLE timeseries (
    assessid character varying(200),
    tsid character varying(40),
    tsyear integer,
    tsvalue double precision
);


ALTER TABLE srdb.timeseries OWNER TO srdbadmin;

--
-- Name: TABLE timeseries; Type: COMMENT; Schema: srdb; Owner: srdbadmin
--

COMMENT ON TABLE timeseries IS 'Values of timeseries';


--
-- Name: tsmetrics; Type: TABLE; Schema: srdb; Owner: srdbadmin; Tablespace: 
--

CREATE TABLE tsmetrics (
    tscategory character varying(200),
    tsshort character varying(40),
    tslong character varying(200),
    tsunitsshort character varying(40),
    tsunitslong character varying(300),
    tsunique character varying(70) NOT NULL
);


ALTER TABLE srdb.tsmetrics OWNER TO srdbadmin;

--
-- Name: TABLE tsmetrics; Type: COMMENT; Schema: srdb; Owner: srdbadmin
--

COMMENT ON TABLE tsmetrics IS 'Definition of tiemseries such as recruits, spawning stock biomass, total abundance, etc.';


--
-- Data for Name: area; Type: TABLE DATA; Schema: srdb; Owner: srdbadmin
--

COPY area (country, areatype, areacode, areaname, alternateareaname, areaid) FROM stdin;
New Zealand	MFish	LIN6b	New Zealand Areas LIN 6b	NA	New Zealand-MFish-LIN6b
New Zealand	MFish	LIN5-6	New Zealand Areas LIN 5 and 6	NA	New Zealand-MFish-LIN5-6
New Zealand	MFish	LIN72	New Zealand Areas LIN 72	NA	New Zealand-MFish-LIN72
New Zealand	MFish	LIN7WC-WCSI	New Zealand Areas LIN 7WC-WCSI	NA	New Zealand-MFish-LIN7WC-WCSI
New Zealand	MFish	CR	Chatham Rise	NA	New Zealand-MFish-CR
New Zealand	MFish	SA	Sub-Antarctic	NA	New Zealand-MFish-SA
New Zealand	MFish	NZ	New Zealand	NA	New Zealand-MFish-NZ
New Zealand	MFish	TRE7	New Zealand Areas TRE 7	NA	New Zealand-MFish-TRE7
New Zealand	MFish	CIR	New Zealand - Campbell Island Rise	NA	New Zealand-MFish-CIR
USA	NMFS	NS	Norton Sound	NA	USA-NMFS-NS
multinational	ICES	28	Gulf of Riga East of Gotland	NA	multinational-ICES-28
New Zealand	MFish	WECR	West end of Chatham Rise	NA	New Zealand-MFish-WECR
USA	NMFS	ATL	Atlantic	NA	USA-NMFS-ATL
New Zealand	MFish	PAU5A	New Zealand Area PAU 5A	NA	New Zealand-MFish-PAU5A
USA	NMFS	AIES	Aleutian Islands Eastern segment	NA	USA-NMFS-AIES
New Zealand	MFish	PAU5D	New Zealand Area PAU 5D (Otago)	NA	New Zealand-MFish-PAU5D
multinational	ICCAT	EATL	Eastern Atlantic	NA	multinational-ICCAT-EATL
USA	NMFS	AIWS	Aleutian Islands Western segment	NA	USA-NMFS-AIWS
New Zealand	MFish	PAU5B	New Zealand Area PAU 5B (Stewart Island)	NA	New Zealand-MFish-PAU5B
New Zealand	MFish	PAU7	New Zealand Area PAU 7 (Marlborough)	NA	New Zealand-MFish-PAU7
multinational	ICCAT	WATL	Western Atlantic	NA	multinational-ICCAT-WATL
New Zealand	MFish	CRA3	New Zealand Area CRA3	NA	New Zealand-MFish-CRA3
New Zealand	MFish	CRA2	New Zealand Area CRA2	NA	New Zealand-MFish-CRA2
New Zealand	MFish	CRA1	New Zealand Area CRA1	NA	New Zealand-MFish-CRA1
New Zealand	MFish	CRA4	New Zealand Area CRA4	NA	New Zealand-MFish-CRA4
New Zealand	MFish	CRA5	New Zealand Area CRA5	NA	New Zealand-MFish-CRA5
New Zealand	MFish	CRA7	New Zealand Area CRA7	NA	New Zealand-MFish-CRA7
New Zealand	MFish	CRA8	New Zealand Area CRA8	NA	New Zealand-MFish-CRA8
Australia	AFMA	GAB	Great Australian Bight	NA	Australia-AFMA-GAB
Australia	AFMA	SE	Southeast Australia	NA	Australia-AFMA-SE
Australia	AFMA	CASCADE	Cascade Plateau	NA	Australia-AFMA-CASCADE
Australia	AFMA	NAUST	Northern Australia	NA	Australia-AFMA-NAUST
Argentina	CFP	ARG-S	Southern Argentina	NA	Argentina-CFP-ARG-S
Argentina	CFP	ARG-N	Northern Argentina	NA	Argentina-CFP-ARG-N
multinational	ICES	VIIIc	Bay of Biscay -South	NA	multinational-ICES-VIIIc
Australia	AFMA	TAS	Tasmania	NA	Australia-AFMA-TAS
Canada	DFO	2J3KLNOPs	Labrador Shelf-Grand Banks-S. Pierre Bank	NA	Canada-DFO-2J3KLNOPs
Canada	DFO	2J3KL	Southern Labrador-Eastern Newfoundland	NA	Canada-DFO-2J3KL
Canada	DFO	3Pn4RS	Northern Gulf of St. Lawrence	NA	Canada-DFO-3Pn4RS
Canada	DFO	3Ps	St. Pierre Bank	NA	Canada-DFO-3Ps
Canada	DFO	23K	Labrador - NE Newfoundland	NA	Canada-DFO-23K
Canada	DFO	4R	NAFO 4R	NA	Canada-DFO-4R
Canada	DFO	4T	Southern Gulf of St. Lawrence	NA	Canada-DFO-4T
Canada	DFO	4RST	Gulf of St. Lawrence	NA	Canada-DFO-4RST
Canada	DFO	4TVn	Southern Gulf of St. Lawrence and Cabot Strait	NA	Canada-DFO-4TVn
Canada	DFO	4Vn	Cabot Strait	NA	Canada-DFO-4Vn
Canada	DFO	4VsW	Eastern Scotian Shelf	NA	Canada-DFO-4VsW
Canada	DFO	4VWX	Scotian Shelf and Bay of Fundy	NA	Canada-DFO-4VWX
Canada	DFO	4VWX5	Scotian Shelf, Bay of Fundy and Georges Bank	NA	Canada-DFO-4VWX5
Canada	DFO	4VWX5Zc	Scotian Shelf, Bay of Fundy and Georges Bank	NA	Canada-DFO-4VWX5Zc
Canada	DFO	4X	Western Scotian Shelf	NA	Canada-DFO-4X
Canada	DFO	4X5Y	Western Scotian Shelf, Bay of Fundy and Gulf of Maine	NA	Canada-DFO-4X5Y
Canada	DFO	3Pn4RSTVn	Gulf of St. Lawrence and Cabot Strait	NA	Canada-DFO-3Pn4RSTVn
Canada	DFO	5Zejm	Georges Bank	NA	Canada-DFO-5Zejm
Canada	DFO	5Zjm	Georges Bank	NA	Canada-DFO-5Zjm
Canada	DFO	CC	Central Coast	NA	Canada-DFO-CC
Canada	DFO	HS	Hecate Strait	NA	Canada-DFO-HS
Canada	DFO	PRD	Prince Rupert District	NA	Canada-DFO-PRD
Canada	DFO	QCI	Queen Charlotte Islands	NA	Canada-DFO-QCI
Canada	DFO	SOG	Straight of Georgia	NA	Canada-DFO-SOG
Canada	DFO	WCVANI	West Coast of Vancouver Island	NA	Canada-DFO-WCVANI
Canada	DFO	ATL	Canadian Atlantic Ocean	NA	Canada-DFO-ATL
multinational	GFCMED	BLACKW	Western Black Sea	NA	multinational-GFCMED-BLACKW
multinational	IATTC	EPAC	Eastern Pacific	NA	multinational-IATTC-EPAC
multinational	IATTC	NEPAC	Northeast Pacific	NA	multinational-IATTC-NEPAC
multinational	ICCAT	MED	Mediterranean Sea	NA	multinational-ICCAT-MED
multinational	ICES	29	Archipelago Sea	NA	multinational-ICES-29
multinational	ICES	30	Bothnian Sea	NA	multinational-ICES-30
multinational	ICES	31	Bothnian Bay	NA	multinational-ICES-31
multinational	ICES	32	Gulf of Finland	NA	multinational-ICES-32
multinational	ICES	22-24	Western Baltic	NA	multinational-ICES-22-24
multinational	ICES	22-24-IIIa	22-24-IIIa	NA	multinational-ICES-22-24-IIIa
multinational	ICES	22-32	Baltic Areas 22-32	NA	multinational-ICES-22-32
multinational	ICES	25-32	Eastern Baltic	NA	multinational-ICES-25-32
multinational	ICES	I	Barents Sea	NA	multinational-ICES-I
multinational	ICES	I-II	North-East Arctic	NA	multinational-ICES-I-II
USA	NMFS	EBSAIGA	Eastern Bering Sea / Aleutian Islands / Gulf of Alaska	NA	USA-NMFS-EBSAIGA
multinational	ICES	I-II-III-IV-V-VI-VII-VIII-IX-XII-XIV	Northeast Atlantic	I-II-III-IV-V-VI-VII-VIII-IX-XII-XIV	multinational-ICES-I-II-III-IV-V-VI-VII-VIII-IX-XII-XIV
multinational	ICES	II-IIIa-IV-VI-VII-VIIIabc	II-IIIa-IV-VI-VII-VIIIabc	NA	multinational-ICES-II-IIIa-IV-VI-VII-VIIIabc
multinational	ICES	IIa	Norwegian Sea	NA	multinational-ICES-IIa
multinational	ICES	IIa-IIIabd-IV-Vb-VI-VII-VIIIabcde-XII-XIV-Ixa	IIa-IIIabd-IV-Vb-VI-VII-VIIIabcde-XII-XIV-Ixa	NA	multinational-ICES-IIa-IIIabd-IV-Vb-VI-VII-VIIIabcde-XII-XIV-Ixa
multinational	ICES	IIb	Spitzbergen and Bear Island	NA	multinational-ICES-IIb
multinational	ICES	IIIa	Kattegat and Skagerrak	Skagerrak	multinational-ICES-IIIa
multinational	ICES	IIIa-IV	IIIa and North Sea	NA	multinational-ICES-IIIa-IV
multinational	ICES	IIIa-IV-VI	IIIa, VI and North Sea	NA	multinational-ICES-IIIa-IV-VI
multinational	ICES	IIIa-IV-VIId	IIIa, VIId and North Sea	NA	multinational-ICES-IIIa-IV-VIId
multinational	ICES	IIIb(23)	Sound Sea	NA	multinational-ICES-IIIb(23)
multinational	ICES	IIIc(22)	Belt Sea	NA	multinational-ICES-IIIc(22)
multinational	ICES	IIId	Baltic Sea	NA	multinational-ICES-IIId
multinational	ICES	IV	North Sea	NA	multinational-ICES-IV
multinational	ICES	IVa	Northern North Sea	NA	multinational-ICES-IVa
multinational	ICES	IVb	Central North Sea	NA	multinational-ICES-IVb
multinational	ICES	IVc	Southern North Sea	NA	multinational-ICES-IVc
multinational	ICES	IXa	Portugese Waters -East	NA	multinational-ICES-IXa
multinational	ICES	IXb	Portugese Waters -West	NA	multinational-ICES-IXb
multinational	ICES	Va	Iceland Grounds	NA	multinational-ICES-Va
multinational	ICES	Vb	Faroe Grounds	NA	multinational-ICES-Vb
multinational	ICES	Vb1	Faroe Plateau	NA	multinational-ICES-Vb1
multinational	ICES	Vb2	Faroe Bank	NA	multinational-ICES-Vb2
multinational	ICES	VIa	West of Scotland	Clyde herring	multinational-ICES-VIa
multinational	ICES	VIa-VIIb-VIIc	VIa, VIIb and VIIc	NA	multinational-ICES-VIa-VIIb-VIIc
multinational	ICES	VIb	Rockall Bank	NA	multinational-ICES-VIb
multinational	ICES	VIIa	Irish Sea	NA	multinational-ICES-VIIa
multinational	ICES	VIIb	West of Ireland	NA	multinational-ICES-VIIb
multinational	ICES	VIIb-k	ICES VIIb-k	NA	multinational-ICES-VIIb-k
multinational	ICES	VIIc	Porcupine Bank	NA	multinational-ICES-VIIc
multinational	ICES	VIId	Eastern English Channel	NA	multinational-ICES-VIId
multinational	ICES	VIIe	Western English Channel	NA	multinational-ICES-VIIe
multinational	ICES	VIIe-k	Celtic Sea	NA	multinational-ICES-VIIe-k
multinational	ICES	VIIf	Bristol Channel	NA	multinational-ICES-VIIf
multinational	ICES	VIIf-g	Celtic Sea	NA	multinational-ICES-VIIf-g
multinational	ICES	VIIg	Celtic Sea North	NA	multinational-ICES-VIIg
multinational	ICES	VIIh	Celtic Sea South	NA	multinational-ICES-VIIh
multinational	ICES	VIII	Bay of Biscay	NA	multinational-ICES-VIII
multinational	ICES	VIIIa	Bay of Biscay -North	NA	multinational-ICES-VIIIa
multinational	ICES	VIIIb	Bay of Biscay -Central	NA	multinational-ICES-VIIIb
multinational	ICES	VIIIc-IXa	VIIIc-IXa	NA	multinational-ICES-VIIIc-IXa
multinational	ICES	VIIId	Bay of Biscay -Offshore	NA	multinational-ICES-VIIId
multinational	ICES	VIIIe	West of Bay of Biscay	NA	multinational-ICES-VIIIe
multinational	ICES	VIIj	Southwest of Ireland -East	NA	multinational-ICES-VIIj
multinational	ICES	VIIk	Southwest of Ireland -West	NA	multinational-ICES-VIIk
multinational	ICES	X	Azores Grounds	NA	multinational-ICES-X
multinational	ICES	XII	North of Azores	NA	multinational-ICES-XII
multinational	ICES	XIVa	Northeast Greenland	NA	multinational-ICES-XIVa
multinational	ICES	XIVb	Southeast Greenland	NA	multinational-ICES-XIVb
multinational	NAFO	01ABCDEF	NAFO 01ABCDEF	NA	multinational-NAFO-01ABCDEF
multinational	NAFO	1	West Greenland	NA	multinational-NAFO-1
multinational	NAFO	23K	Labrador - NE Newfoundland	NA	multinational-NAFO-23K
multinational	NAFO	23KLMNO	Labrador Shelf - Grand Banks	NA	multinational-NAFO-23KLMNO
multinational	NAFO	3L	N Grand Banks	NA	multinational-NAFO-3L
multinational	NAFO	3LN	N and SW Grand Banks	NA	multinational-NAFO-3LN
multinational	NAFO	3LNO	Grand Banks	NA	multinational-NAFO-3LNO
multinational	NAFO	3M	Flemish Cap	NA	multinational-NAFO-3M
multinational	NAFO	3NO	Southern Grand Banks	NA	multinational-NAFO-3NO
multinational	NAFO	3O	SW Grand Banks	NA	multinational-NAFO-3O
multinational	SPC	WPO	Western Pacific Ocean	NA	multinational-SPC-WPO
multinational	WCPFC	SPAC	South Pacific Ocean	NA	multinational-WCPFC-SPAC
New Zealand	MFish	ENZ	Eastern New Zealand	NA	New Zealand-MFish-ENZ
New Zealand	MFish	WNZ	Western New Zealand	NA	New Zealand-MFish-WNZ
New Zealand	MFish	LIN3-4	New Zealand Areas LIN 3 and 4	NA	New Zealand-MFish-LIN3-4
South Africa	DETMCM	SA	South Africa	NA	South Africa-DETMCM-SA
South Africa	DETMCM	SASC	South Africa South coast	NA	South Africa-DETMCM-SASC
USA	NMFS	5Y	Gulf of Maine	NA	USA-NMFS-5Y
USA	NMFS	5YCHATT	Gulf of Maine / Cape Hatteras	NA	USA-NMFS-5YCHATT
USA	NMFS	5YZ	Gulf of Maine / Georges Bank	NA	USA-NMFS-5YZ
USA	NMFS	5YZSNE	Gulf of Maine / Georges Bank-Southern New England	NA	USA-NMFS-5YZSNE
USA	NMFS	5Z	Georges Bank	NA	USA-NMFS-5Z
USA	NMFS	5ZSNE	Georges Bank-Southern New England	NA	USA-NMFS-5ZSNE
USA	NMFS	AI	Aleutian Islands	NA	USA-NMFS-AI
USA	NMFS	ATLC	Atlantic Coast	NA	USA-NMFS-ATLC
USA	NMFS	BB	Bristol Bay	NA	USA-NMFS-BB
USA	NMFS	BS	Bering Sea	NA	USA-NMFS-BS
USA	NMFS	BSAI	Bering Sea and Aleutian Islands	NA	USA-NMFS-BSAI
USA	NMFS	CAL	California	NA	USA-NMFS-CAL
USA	NMFS	CBS	Central Bering Sea	NA	USA-NMFS-CBS
USA	NMFS	CCOD5Y	Cape Cod / Gulf of Maine	NA	USA-NMFS-CCOD5Y
USA	NMFS	CWPAC	Central Western Pacific	NA	USA-NMFS-CWPAC
USA	NMFS	EBS	Eastern Bering Sea	NA	USA-NMFS-EBS
USA	NMFS	EBSAI	Eastern Bering Sea and Aleutian Islands	NA	USA-NMFS-EBSAI
USA	NMFS	EBSGA	Eastern Bering Sea and Gulf of Alaska	NA	USA-NMFS-EBSGA
USA	NMFS	EGM	Eastern Gulf of Mexico	NA	USA-NMFS-EGM
USA	NMFS	GA	Gulf of Alaska	NA	USA-NMFS-GA
USA	NMFS	GM	Gulf of Mexico	NA	USA-NMFS-GM
USA	NMFS	MATLC	Mid-Atlantic Coast	NA	USA-NMFS-MATLC
USA	NMFS	NATL	North Atlantic	NA	USA-NMFS-NATL
USA	NMFS	NPAC	North Pacific	NA	USA-NMFS-NPAC
multinational	IPHC	NPAC	North Pacific	NA	multinational-IPHC-NPAC
USA	NMFS	NPCOAST	Northern Pacific Coast	NA	USA-NMFS-NPCOAST
USA	NMFS	NWATL	Northwestern Atlantic	NA	USA-NMFS-NWATL
USA	NMFS	NWATLC	Northwestern Atlantic Coast	NA	USA-NMFS-NWATLC
USA	NMFS	PCOAST	Pacific Coast	NA	USA-NMFS-PCOAST
USA	NMFS	PI	Pribilof Islands	NA	USA-NMFS-PI
USA	NMFS	SATL	South Atlantic	NA	USA-NMFS-SATL
USA	NMFS	SATLC	Southern Atlantic coast	NA	USA-NMFS-SATLC
USA	NMFS	SATLCGM	Southern Atlantic coast and Gulf of Mexico	NA	USA-NMFS-SATLCGM
USA	NMFS	SCAL	Southern California	NA	USA-NMFS-SCAL
USA	NMFS	SMI	Saint Matthews Island	NA	USA-NMFS-SMI
USA	NMFS	SNEMATL	Southern New England /Mid Atlantic	NA	USA-NMFS-SNEMATL
USA	NMFS	SNEMATLB	Southern New England /Mid Atlantic Bight	NA	USA-NMFS-SNEMATLB
USA	NMFS	SPCOAST	Southern Pacific Coast	NA	USA-NMFS-SPCOAST
USA	NMFS	WATL	Western Atlantic	NA	USA-NMFS-WATL
USA	NMFS	WGM	Western Gulf of Mexico	NA	USA-NMFS-WGM
USA	US State	ATKINS	Atkins Reservoir, Arkansas	NA	USA-US State-ATKINS
USA	US State	HUNT	Hunt Creek, Michigan	NA	USA-US State-HUNT
USA	US State	KAB	Kabegogama Lake, Minnesota	NA	USA-US State-KAB
USA	US State	MIN	Minter Creek, Washington	NA	USA-US State-MIN
USA	US State	NIMROD	Nimrod Reservoir, Arkansas	NA	USA-US State-NIMROD
USA	US State	OKA	Okatibbee Reservoir, Mississippi	NA	USA-US State-OKA
USA	US State	RI	Rhode Island	NA	USA-US State-RI
USA	US State	ROSS	Ross Barnett Reservoir, Mississippi	NA	USA-US State-ROSS
USA	US State	SHAL	Shale Creek, Washington	NA	USA-US State-SHAL
USA	US State	SKY	South Fork Skykomish River, Washington	NA	USA-US State-SKY
USA	US State	SNAH	Snahapish Creek, Washington	NA	USA-US State-SNAH
USA	US State	SNOW	Snow Creek, Washington	NA	USA-US State-SNOW
USA	US State	SPRI	Spring Creek, Oregon	NA	USA-US State-SPRI
USA	US State	TAYU	Little Tayuha Creek, Washington	NA	USA-US State-TAYU
USA	US State	WILD	Wildcat Creek, Washington	NA	USA-US State-WILD
multinational	TRAC	5Z	Georges Bank	NA	multinational-TRAC-5Z
multinational	ICCAT	NATL	Northern Atlantic	NA	multinational-ICCAT-NATL
South Africa	DETMCM	1-2	South Africa Areas 1-2	NA	South Africa-DETMCM-1-2
South Africa	DETMCM	3-4	South Africa Areas 3-4	NA	South Africa-DETMCM-3-4
South Africa	DETMCM	5-6	South Africa Areas 5-6	NA	South Africa-DETMCM-5-6
South Africa	DETMCM	7	South Africa Area 7	NA	South Africa-DETMCM-7
South Africa	DETMCM	8	South Africa Area 8	NA	South Africa-DETMCM-8
multinational	ICES	IIIa-IV-VI-VII-VIIIabd	IIIa-IV-VI-VII-VIIIabd	NA	multinational-ICES-IIIa-IV-VI-VII-VIIIabd
New Zealand	MFish	8	New Zealand Area 8 (Auckland and Central West)	NA	New Zealand-MFish-8
multinational	ICCAT	SATL	South Atlantic	NA	multinational-ICCAT-SATL
New Zealand	MFish	NZMEC	New Zealand Mid East Coast	NA	New Zealand-MFish-NZMEC
USA	NMFS	SGBMATL	Southern Georges Bank / Mid-Atlantic	NA	USA-NMFS-SGBMATL
USA	NMFS	GOMNGB	Gulf of Maine / Northern Georges Bank	NA	USA-NMFS-GOMNGB
multinational	IOTC	IO	Indian Ocean	NA	multinational-IOTC-IO
USA	US State	PWS	Prince William Sound	NA	USA-US State-PWS
USA	US State	SITKA	Sitka	NA	USA-US State-SITKA
South Africa	DETMCM	PEI	South Africa Subantarctic Prince Edward Islands	NA	South Africa-DETMCM-PEI
Australia	AFMA	WSE	Western half of Southeast Australia	NA	Australia-AFMA-WSE
multinational	SPRFMO	CH	Chilean EEZ and offshore	NA	multinational-SPRFMO-CH
Russia	RFFA	NSO	Northern Sea of Okhotsk	NA	Russia-RFFA-NSO
Russia	RFFA	WBS	Western Bering Sea	NA	Russia-RFFA-WBS
USA	NMFS	SNE	Southern New England	NA	USA-NMFS-SNE
Australia	AFMA	ESE	Eastern half of Southeast Australia	NA	Australia-AFMA-ESE
USA	NMFS	ORECOAST	Oregon Coast	NA	USA-NMFS-ORECOAST
USA	NMFS	NCAL	Northern California	NA	USA-NMFS-NCAL
multinational	CCAMLR	RS	Ross Sea	NA	multinational-CCAMLR-RS
multinational	UNKNOWN	NWPAC	Nothwest Pacific Ocean	NA	multinational-UNKNOWN-NWPAC
Peru	IMARPE	NC	North-Central Peruvian coast	NA	Peru-IMARPE-NC
\.


--
-- Data for Name: assessment; Type: TABLE DATA; Schema: srdb; Owner: srdbadmin
--

COPY assessment (assessid, assessorid, stockid, recorder, daterecorded, dateloaded, assessyear, assesssource, contacts, notes, pdffile, assess, refpoints, assessmethod, assesscomments, xlsfilename, mostrecent) FROM stdin;
\.


--
-- Data for Name: assessmethod; Type: TABLE DATA; Schema: srdb; Owner: srdbadmin
--

COPY assessmethod (category, methodshort, methodlong) FROM stdin;
\.


--
-- Data for Name: assessor; Type: TABLE DATA; Schema: srdb; Owner: srdbadmin
--

COPY assessor (assessorid, mgmt, country, assessorfull) FROM stdin;
\.


--
-- Data for Name: biometrics; Type: TABLE DATA; Schema: srdb; Owner: srdbadmin
--

COPY biometrics (category, subcategory, bioshort, biolong, biounitsshort, biounitslong, biounique) FROM stdin;
OTHER BIOMETRICS	LIFE HISTORY	MAT-SLOPE	Slope of maturity function	dimless	dimensionless	MAT-SLOPE-dimless
OTHER BIOMETRICS	LIFE HISTORY	LW-b	Power in length-weight relationship	dimless	dimensionless	LW-b-dimless
OTHER BIOMETRICS	REFERENCE POINTS ETC.	BH-h	Beverton-Holt steepness	dimless	recruitment units per spawner units (dimensionless if recruits and spawners are in the same units)	BH-h-dimless
OTHER BIOMETRICS	REFERENCE POINTS ETC.	BF40%	Total biomass at F40%	MT	metric tons	BF40%-MT
OTHER BIOMETRICS	REFERENCE POINTS ETC.	U40%	harvest rate that reduces B to B40%	ratio	ratio	U40%-ratio
OTHER BIOMETRICS	REFERENCE POINTS ETC.	F0.1	the fishing mortality rate at which the increase in yield per recruit in weight for an increase in a unit of effort is only 10 percent of the yield per recruit produced by the first unit of effort on the unexploited stock	1/T	per unit time	F0.1-1/T
OTHER BIOMETRICS	REFERENCE POINTS ETC.	Fmax	the rate of fishing mortality for a given exploitation pattern rate of growth and natural mortality, that results in the maximum level of yield per recruit	1/T	per unit time	Fmax-1/T
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSBmsy	Spawning Stock Biomass at MSY	E03eggs	thousands of eggs	SSBmsy-E03eggs
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSB0	Pre-exploitation spawning biomass	E03eggs	thousands of eggs	SSB0-E03eggs
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSBtarget	Target spawning biomass level (SSB40%)	E03eggs	thousands of eggs	SSBtarget-E03eggs
OTHER BIOMETRICS	REFERENCE POINTS ETC.	B0	Pre-exploitation total biomass	MT	metric tons	B0-MT
OTHER BIOMETRICS	LIFE HISTORY	VB-k	k parameter in Von Bertalanffy growth function	cm/yr	centimeters per year	VB-k-cm/yr
OTHER BIOMETRICS	LIFE HISTORY	VB-k	k parameter in Von Bertalanffy growth function	1/T	per unit time	VB-k-1/T
TIME SERIES DATA DESCRIPTORS	SPAWNERS	SSB-AGE	Age of spawners (e.g. 3+)	yr	years	SSB-AGE-yr
TIME SERIES DATA DESCRIPTORS	SPAWNERS	SSB-SEX	Sex of spawners: 0=both sexes,1=females only,2=males only,NA=sex unknown	sex	0=both sexes,1=females only,2=males only,NA=sex unknown	SSB-SEX-sex
TIME SERIES DATA DESCRIPTORS	RECRUITS	REC-AGE	Age of recruits (note: offset in the time series by their age as in Myers SR database)	yr	years	REC-AGE-yr
TIME SERIES DATA DESCRIPTORS	RECRUITS	REC-ESTIMATED	Enter the year range for which R was estimated from the data (rather than being dominantly driven by the assumed underlying S-R relationship)	yr-yr	years	REC-ESTIMATED-yr-yr
TIME SERIES DATA DESCRIPTORS	FISHING MORTALITY	F-AGE	Ages used to compute fishing mortality	yr-yr	range of years	F-AGE-yr-yr
TIME SERIES DATA DESCRIPTORS	FISHING MORTALITY	F-SEX	Sex used for F calculation: 0=both sexes,1=females only,2=males only,NA=sex unknown	sex	0=both sexes,1=females only,2=males only,NA=sex unknown	F-SEX-sex
TIME SERIES DATA DESCRIPTORS	FISHING MORTALITY	F-CALC	Fishing mortality calculation: 0=weighted by weights-at-age; 1=weighted by numbers-at-age; 2=unweighted	0-1-2	0=weighted by weights-at-age; 1=weighted by numbers-at-age; 2=unweighted	F-CALC-0-1-2
TIME SERIES DATA DESCRIPTORS	TOTAL BIOMASS	TB-AGE	age used in the calculation of total recruited biomass (e.g. age 3+ biomass)	yr	years	TB-AGE-yr
TIME SERIES DATA DESCRIPTORS	TOTAL BIOMASS	TB-TYPE	0=total biomass, 1=total exploitable biomass	0-1	0=total biomass, 1=total exploitable biomass	TB-TYPE-0-1
OTHER BIOMETRICS	LIFE HISTORY	A50	Age at 50% maturity	yr	years	A50-yr
OTHER BIOMETRICS	LIFE HISTORY	A50-1	Age at 50% maturity	yr	years	A50-1-yr
OTHER BIOMETRICS	LIFE HISTORY	A50-2	Age at 50% maturity	yr	years	A50-2-yr
OTHER BIOMETRICS	LIFE HISTORY	A50min	Minimum age at 50% maturity (choose the age (in years or half years) closest to 50%)	yr	years	A50min-yr
OTHER BIOMETRICS	LIFE HISTORY	A50min	Minimum age at 50% maturity (choose the age (in years or half years) closest to 50%)	0.5yr	half-year	A50min-0.5yr
OTHER BIOMETRICS	LIFE HISTORY	A50max	Maximum age at 50% maturity (choose the age (in years or half years) closest to 50%)	yr	years	A50max-yr
OTHER BIOMETRICS	LIFE HISTORY	A50max	Maximum age at 50% maturity (choose the age (in years or half years) closest to 50%)	0.5yr	half-year	A50max-0.5yr
OTHER BIOMETRICS	LIFE HISTORY	MAT-SEX	Maturity sex: 0=both sexes,1=females only,2=males only,NA=sex unknown	sex	0=both sexes,1=females only,2=males only,NA=sex unknown	MAT-SEX-sex
OTHER BIOMETRICS	LIFE HISTORY	MAT-CALC	Maturity 50% calculation: 0=by cohort,1=by age	0-1	0=by cohor or 1=by age	MAT-CALC-0-1
OTHER BIOMETRICS	LIFE HISTORY	MAT-MODEL	Maturity model option	option	option	MAT-MODEL-option
OTHER BIOMETRICS	LIFE HISTORY	MAT-SLOPE	Slope of maturity function	dimensionless	dimensionless	MAT-SLOPE-dimensionless
OTHER BIOMETRICS	LIFE HISTORY	MAT-REF	Age at 50% maturity reference	doctype	Reference document for age at 50% maturity	MAT-REF-doctype
OTHER BIOMETRICS	LIFE HISTORY	Fecundity	Fecundity	N	number of eggs	Fecundity-N
OTHER BIOMETRICS	LIFE HISTORY	Fecundity-rel	Relative fecundity	eggs/g	Total egg production per gram of ssb	Fecundity-rel-eggs/g
OTHER BIOMETRICS	LIFE HISTORY	Habitat	Habitat, (pelagic marine; demersal marine; diadromous; wholly freshwater)	Habitat	habitat type	Habitat-Habitat
OTHER BIOMETRICS	LIFE HISTORY	L50	Length at 50% maturity	cm	centimeters	L50-cm
OTHER BIOMETRICS	LIFE HISTORY	L50	Length at 50% maturity	mm	millimeters	L50-mm
OTHER BIOMETRICS	LIFE HISTORY	L50-1	Length at 50% maturity	cm	centimeters	L50-1-cm
OTHER BIOMETRICS	LIFE HISTORY	L50-2	Length at 50% maturity	cm	centimeters	L50-2-cm
OTHER BIOMETRICS	LIFE HISTORY	L50max	Maximum length at 50% maturity	cm	centimeters	L50max-cm
OTHER BIOMETRICS	LIFE HISTORY	L50min	Minimum length at 50% maturity	cm	centimeters	L50min-cm
OTHER BIOMETRICS	LIFE HISTORY	L50min-1	Minimum length at 50% maturity	cm	centimeters	L50min-1-cm
OTHER BIOMETRICS	LIFE HISTORY	L50min-2	Minimum length at 50% maturity	cm	centimeters	L50min-2-cm
OTHER BIOMETRICS	LIFE HISTORY	LEN-SEX	Length at 50% maturity sex: 0=both sexes,1=females only,2=males only,NA=sex unknown	sex	0=both sexes,1=females only,2=males only,NA=sex unknown	LEN-SEX-sex
OTHER BIOMETRICS	LIFE HISTORY	LEN-REF	Length at 50% maturity reference	doctype	Reference document for length at 50% maturity	LEN-REF-doctype
OTHER BIOMETRICS	LIFE HISTORY	Linf	Asymptotic length in von Bertalanffy growth model	cm	centimeters	Linf-cm
OTHER BIOMETRICS	LIFE HISTORY	Linf	Asymptotic length in von Bertalanffy growth model	mm	millimeters	Linf-mm
OTHER BIOMETRICS	LIFE HISTORY	LW-a	Coefficient in length-weight relationship	kg/cm	kilograms per centimeters	LW-a-kg/cm
OTHER BIOMETRICS	LIFE HISTORY	LW-a	Coefficient in length-weight relationship	kg/mm	kilograms per millimeters	LW-a-kg/mm
OTHER BIOMETRICS	LIFE HISTORY	LW-a	Coefficient in length-weight relationship	g/mm	grams per millimeters	LW-a-g/mm
OTHER BIOMETRICS	LIFE HISTORY	LW-a	Coefficient in length-weight relationship	MT/cm	tonnes per centimeters	LW-a-MT/cm
OTHER BIOMETRICS	LIFE HISTORY	LW-b	Power in length-weight relationship	dimensionless	dimensionless	LW-b-dimensionless
OTHER BIOMETRICS	LIFE HISTORY	M	Natural mortality	1/T	per unit time	M-1/T
OTHER BIOMETRICS	LIFE HISTORY	M	Natural mortality	1/yr	per year	M-1/yr
OTHER BIOMETRICS	LIFE HISTORY	M	Natural mortality	1/month	per month	M-1/month
OTHER BIOMETRICS	LIFE HISTORY	MAX-AGE	Maximum age	yr	years	MAX-AGE-yr
OTHER BIOMETRICS	LIFE HISTORY	MAX-LEN	Maximum length	cm	centimeters	MAX-LEN-cm
OTHER BIOMETRICS	LIFE HISTORY	MAX-WGT	Maximum weight	g	grams	MAX-WGT-g
OTHER BIOMETRICS	LIFE HISTORY	VB-k	k parameter in Von Bertalanffy growth function	cm/T	centimeters per unit time	VB-k-cm/T
OTHER BIOMETRICS	LIFE HISTORY	VB-k	k parameter in Von Bertalanffy growth function	mm/T	millimeters per unit time	VB-k-mm/T
OTHER BIOMETRICS	LIFE HISTORY	VB-t0	t0 parameter in Von Bertalanffy growth function	yr	years	VB-t0-yr
OTHER BIOMETRICS	LIFE HISTORY	VB-LA	length in max age class for von Bertalanffy growth function	cm	centimeters	VB-LA-cm
OTHER BIOMETRICS	LIFE HISTORY	VB-L1	length in first age class for von Bertalanffy growth function	cm	centimeters	VB-L1-cm
OTHER BIOMETRICS	LIFE HISTORY	Winf	Asymptotic weight in von Bertalanffy growth model	g	grams	Winf-g
OTHER BIOMETRICS	LIFE HISTORY	VB-A	age of last age class for von Bertalanffy growth function	yr	years	VB-A-yr
OTHER BIOMETRICS	LIFE HISTORY	Z-AGE	Ages used to compute total mortality	yr-yr	range of years	Z-AGE-yr-yr
OTHER BIOMETRICS	LIFE HISTORY	Trophiclevel	should be entered from FishBase, and the HIGHEST value should be entered	value	float value	Trophiclevel-value
OTHER BIOMETRICS	REFERENCE POINTS ETC.	BH-h	Beverton-Holt steepness	R units per SSB units	recruitment units per spawner units (dimensionless if recruits and spawners are in the same units)	BH-h-R units per SSB units
OTHER BIOMETRICS	REFERENCE POINTS ETC.	BH-h	Beverton-Holt steepness	dimensionless	recruitment units per spawner units (dimensionless if recruits and spawners are in the same units)	BH-h-dimensionless
OTHER BIOMETRICS	REFERENCE POINTS ETC.	Blim	lowest observed spawning stock biomass in previous assessments	MT	metric tons	Blim-MT
OTHER BIOMETRICS	REFERENCE POINTS ETC.	Blim	lowest observed spawning stock biomass in previous assessments	E00eggs	eggs	Blim-E00eggs
OTHER BIOMETRICS	REFERENCE POINTS ETC.	Blim	lowest observed spawning stock biomass in previous assessments	E09eggs	trillions of eggs	Blim-E09eggs
OTHER BIOMETRICS	REFERENCE POINTS ETC.	Blim	lowest observed spawning stock biomass in previous assessments	FemaleGonadMT	Female Gonad Weight in metric tons	Blim-FemaleGonadMT
OTHER BIOMETRICS	REFERENCE POINTS ETC.	Bmsy	Total biomass at maximum sustainable yield	MT	metric tons	Bmsy-MT
OTHER BIOMETRICS	REFERENCE POINTS ETC.	Bpa	Precautionary approach biomass	MT	Metric tonnes	Bpa-MT
OTHER BIOMETRICS	REFERENCE POINTS ETC.	Brebuild	Rebuild target for biomass	MT	Metric tonnes	Brebuild-MT
OTHER BIOMETRICS	REFERENCE POINTS ETC.	Bbuf	spawning stock biomass that produced the last abundant year-class	MT	Metric tonnes	Bbuf-MT
OTHER BIOMETRICS	REFERENCE POINTS ETC.	F0.1	the fishing mortality rate at which the increase in yield per recruit in weight for an increase in a unit of effort is only 10 percent of the yield per recruit produced by the first unit of effort on the unexploited stock	1/yr	per year	F0.1-1/yr
OTHER BIOMETRICS	REFERENCE POINTS ETC.	Fext	the rate of fishing mortality where equilibrium biomass=0	1/yr	per year	Fext-1/yr
OTHER BIOMETRICS	REFERENCE POINTS ETC.	Flim	the fishing mortality threshold, above which fishing has typically lead to stock decline	1/yr	per year	Flim-1/yr
OTHER BIOMETRICS	REFERENCE POINTS ETC.	Flim	the fishing mortality threshold, above which fishing has typically lead to stock decline	1/T	per unit time	Flim-1/T
OTHER BIOMETRICS	REFERENCE POINTS ETC.	Fmax	the rate of fishing mortality for a given exploitation pattern rate of growth and natural mortality, that results in the maximum level of yield per recruit	1/yr	per year	Fmax-1/yr
OTHER BIOMETRICS	REFERENCE POINTS ETC.	Fmsy	fishing mortality corresponding to maximum sustainable yield	1/yr	per year	Fmsy-1/yr
OTHER BIOMETRICS	REFERENCE POINTS ETC.	Fmsy	fishing mortality corresponding to maximum sustainable yield	1/T	per unit time	Fmsy-1/T
OTHER BIOMETRICS	REFERENCE POINTS ETC.	Fpa	Precautionary approach fishing mortality	1/yr	per year	Fpa-1/yr
OTHER BIOMETRICS	REFERENCE POINTS ETC.	Fpa	Precautionary approach fishing mortality	1/T	per unit time	Fpa-1/T
OTHER BIOMETRICS	REFERENCE POINTS ETC.	Fref	Reference fishing mortality	1/T	per unit time	Fref-1/T
OTHER BIOMETRICS	REFERENCE POINTS ETC.	Fcurrent	Best available point estimate of fishing mortality rate or total catch used to determine the rate of fishing	1/T	per unit time	Fcurrent-1/T
OTHER BIOMETRICS	REFERENCE POINTS ETC.	Fcurrent	Best available point estimate of fishing mortality rate or total catch used to determine the rate of fishing	1/yr	per year	Fcurrent-1/yr
OTHER BIOMETRICS	REFERENCE POINTS ETC.	Frebuild	Fishing mortality that allows stock to rebuild	1/T	per unit time	Frebuild-1/T
OTHER BIOMETRICS	REFERENCE POINTS ETC.	MORATOR	Fishing moratorium (years): e.g. 1992-1996	yr-yr	range of years	MORATOR-yr-yr
OTHER BIOMETRICS	REFERENCE POINTS ETC.	NATMORT	Natural mortality	1/yr	per year	NATMORT-1/yr
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SPRF0	Spawners per recruit when F=0	E01	numbers	SPRF0-E01
OTHER BIOMETRICS	REFERENCE POINTS ETC.	F40%	Fishing mortality that reduces spawner biomass per recruit to 40% of the level obtained without fishing mortality	1/T	per unit time	F40%-1/T
OTHER BIOMETRICS	REFERENCE POINTS ETC.	F35%	Fishing mortality that reduces spawner biomass per recruit to 35% of the level obtained without fishing mortality	1/T	per unit time	F35%-1/T
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSBmsy	Spawning Stock Biomass at MSY	relative	relative	SSBmsy-relative
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSBmsy	Spawning Stock Biomass at MSY	MT	metric tons	SSBmsy-MT
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSBmsy	Spawning Stock Biomass at MSY	E00eggs	number of eggs	SSBmsy-E00eggs
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSBmsy	Spawning Stock Biomass at MSY	E06eggs	millions of eggs	SSBmsy-E06eggs
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSBmsy	Spawning Stock Biomass at MSY	E08eggs	hundreds of millions of eggs	SSBmsy-E08eggs
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSBmsy	Spawning Stock Biomass at MSY	E09eggs	trillions of eggs	SSBmsy-E09eggs
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSBmsy	Spawning Stock Biomass at MSY	E06larvae	millions of larvae	SSBmsy-E06larvae
OTHER BIOMETRICS	REFERENCE POINTS ETC.	MSY	Maximum Sustainable Yield	MT	metric tons	MSY-MT
OTHER BIOMETRICS	REFERENCE POINTS ETC.	Umsy	harvest rate corresponding to maximum sustainable yield	ratio	dimensionless	Umsy-ratio
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSB0	Pre-exploitation spawning biomass	MT	metric tons	SSB0-MT
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSB0	Pre-exploitation spawning biomass	E06eggs	millions of eggs	SSB0-E06eggs
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSB0	Pre-exploitation spawning biomass	E08eggs	hundreds of millions of eggs	SSB0-E08eggs
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSB0	Pre-exploitation spawning biomass	E09eggs	trillions of eggs	SSB0-E09eggs
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSB0	Pre-exploitation spawning biomass	E06larvae	millions of larvae	SSB0-E06larvae
OTHER BIOMETRICS	REFERENCE POINTS ETC.	R0	Recruitment in unexploited population	E00	numbers	R0-E00
OTHER BIOMETRICS	REFERENCE POINTS ETC.	R0	Recruitment in unexploited population	E03	number in thousands	R0-E03
OTHER BIOMETRICS	REFERENCE POINTS ETC.	R0	Recruitment in unexploited population	E09	number in tens of millions	R0-E09
OTHER BIOMETRICS	REFERENCE POINTS ETC.	R0	Recruitment in unexploited population	E06	number in millions	R0-E06
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSBtarget	Target spawning biomass level (SSB40%)	MT	metric tons	SSBtarget-MT
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSBtarget	Target spawning biomass level (SSB40%)	E06eggs	millions of eggs	SSBtarget-E06eggs
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSBtarget	Target spawning biomass level (SSB40%)	E08eggs	hundreds of millions of eggs	SSBtarget-E08eggs
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSBtarget	Target spawning biomass level (SSB40%)	E09eggs	trillions of eggs	SSBtarget-E09eggs
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSBtarget	Target spawning biomass level (SSB40%)	E06larvae	millions of larvae	SSBtarget-E06larvae
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSBF40%	Spawning biomass at F40%	MT	metric tons	SSBF40%-MT
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSBmin	Minimum acceptable spawning biomass (fraction of SSB0)	ratio	dimensionless	SSBmin-ratio
OTHER BIOMETRICS	REFERENCE POINTS ETC.	Ftarget	Average fishing mortality target	1/yr	per year	Ftarget-1/yr
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SPRtarget	Target spawning potential ratio (fraction of pre-exploitation SPR)	ratio	dimensionless	SPRtarget-ratio
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSBexceptional	The Exceptional Circumstances threshold below which quotas are sharply reduced	MT	metric tons	SSBexceptional-MT
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSBrecovery	The lowest spawner biomass for which a secure recovery has occurred	MT	metric tons	SSBrecovery-MT
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSBrecovery-1	The lowest spawner biomass for which a secure recovery has occurred	MT	metric tons	SSBrecovery-1-MT
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSBrecovery-2	The lowest spawner biomass for which a secure recovery has occurred	MT	metric tons	SSBrecovery-2-MT
OTHER BIOMETRICS	REFERENCE POINTS ETC.	Bcrp	Conservation reference point: stock level below which productivity is sufficiently impaired to cause serious harm to the resource.	MT	metric tons	Bcrp-MT
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSB50	SSB that produces 50% of the max recruitment as estimated from the stock-recruitment curve	MT	metric tons	SSB50-MT
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSBnp50	The SSB corresponding to 50% of the maximum recruitment predicted by a non-parametric S-R curve	MT	metric tons	SSBnp50-MT
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSBrk50	The SSB (left-hand limb) corresponding to 50% of the maximum value of a Ricker curve	MT	metric tons	SSBrk50-MT
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSBbh50	The SSB corresponding to the recruitment at 50% of the asymptotic value of a Beverton-Holt curve	MT	metric tons	SSBbh50-MT
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSBsb50/90	The intersection of the 50th percentile of the recruitment and the replacement line above 90% of the S-R points	MT	metric tons	SSBsb50/90-MT
OTHER BIOMETRICS	REFERENCE POINTS ETC.	Busr	Upper stock reference: stock level below which the removal rate is reduced	MT	metric tons	Busr-MT
OTHER BIOMETRICS	REFERENCE POINTS ETC.	Blrp	Limit reference point: stock level below which productivity is sufficiently impaired to cause serious harm because the probability of poor recruitment is high	MT	metric tons	Blrp-MT
OTHER BIOMETRICS	REFERENCE POINTS ETC.	ERtarget	Average exploitation ratio target	ratio	ratio	ERtarget-ratio
OTHER BIOMETRICS	REFERENCE POINTS ETC.	ERcurrent	Best available point estimate of exploitation ratio used to determine the rate of fishing	ratio	ratio	ERcurrent-ratio
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSBlimit20%	Limit spawning biomass level (SSB20%), Spawning Biomass at which harvest rate is set to 0	MT	metric tons	SSBlimit20%-MT
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSBlimit30%	Limit spawning biomass level (SSB30%), Spawning Biomass below which target fishing mortality declines linearly to reach 0 at SSB20	MT	metric tons	SSBlimit30%-MT
OTHER BIOMETRICS	LIFE HISTORY	LW-a	Coefficient in length-weight relationship	g/cm	grams per centimeters	LW-a-g/cm
OTHER BIOMETRICS	REFERENCE POINTS ETC.	Bmsy	Total biomass at maximum sustainable yield	relative	relative	Bmsy-relative
OTHER BIOMETRICS	REFERENCE POINTS ETC.	Fmsy	fishing mortality corresponding to maximum sustainable yield	relative	relative	Fmsy-relative
OTHER BIOMETRICS	REFERENCE POINTS ETC.	Bpa	Precautionary approach biomass	relative	relative	Bpa-relative
OTHER BIOMETRICS	REFERENCE POINTS ETC.	Upa	harvest rate for precautionary approach	ratio	ratio	Upa-ratio
OTHER BIOMETRICS	LIFE HISTORY	VB-k	k parameter in Von Bertalanffy growth function	1/yr	per year	VB-k-1/yr
OTHER BIOMETRICS	REFERENCE POINTS ETC.	Blim	lowest observed spawning stock biomass in previous assessments	relative	relative	Blim-relative
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSFmsy	Spawning Stock Fecundity at MSY	E00	Individuals	SSFmsy-E00
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SPRmsy	Spawners per recruit at MSY	E00	Individuals	SPRmsy-E00
OTHER BIOMETRICS	REFERENCE POINTS ETC.	MSY	Maximum Sustainable Yield	E03MT	thousands of metric tons	MSY-E03MT
OTHER BIOMETRICS	REFERENCE POINTS ETC.	Bmsy	Total biomass at maximum sustainable yield	E03MT	thousands of metric tons	Bmsy-E03MT
OTHER BIOMETRICS	REFERENCE POINTS ETC.	Blim	lowest observed spawning stock biomass in previous assessments	E03eggs	thousand of eggs	Blim-E03eggs
OTHER BIOMETRICS	REFERENCE POINTS ETC.	MSY	Maximum Sustainable Yield	E00	Individuals	MSY-E00
OTHER BIOMETRICS	REFERENCE POINTS ETC.	Nmsy	Total abundance at maximum sustainable yield	E00	Individuals	Nmsy-E00
OTHER BIOMETRICS	REFERENCE POINTS ETC.	N0	Pre-exploitation abundance	E00	Individuals	N0-E00
OTHER BIOMETRICS	REFERENCE POINTS ETC.	RY	Replacement yield	E00	Individuals	RY-E00
OTHER BIOMETRICS	REFERENCE POINTS ETC.	r	Intrinsic rate of increase	1/yr	per year	r-1/yr
OTHER BIOMETRICS	REFERENCE POINTS ETC.	K	Carrying capacity	E00	Individuals	K-E00
OTHER BIOMETRICS	REFERENCE POINTS ETC.	F30%	Fishing mortality that reduces spawner biomass per recruit to 30% of the level obtained without fishing mortality	1/yr	per year	F30%-1/yr
OTHER BIOMETRICS	REFERENCE POINTS ETC.	F35%	Fishing mortality that reduces spawner biomass per recruit to 35% of the level obtained without fishing mortality	1/yr	per year	F35%-1/yr
OTHER BIOMETRICS	REFERENCE POINTS ETC.	F40%	Fishing mortality that reduces spawner biomass per recruit to 40% of the level obtained without fishing mortality	1/yr	per year	F40%-1/yr
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSBlim	lowest observed spawning stock biomass in previous assessments	MT	metric tons	SSBlim-MT
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSBpa	Precautionary approach spawning stock biomass	MT	Metric tonnes	SSBpa-MT
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSBlim	lowest observed spawning stock biomass in previous assessments	E00eggs	eggs	SSBlim-E00eggs
TIME SERIES DATA DESCRIPTORS	SUMMARY TOTAL BIOMASS	STB-AGE	Age of summary total biomass (e.g. 3+)	yr	years	STB-AGE-yr
TIME SERIES DATA DESCRIPTORS	SUMMARY TOTAL BIOMASS	STB-SEX	Sex of summary total biomass: 0=both sexes,1=females only,2=males only,NA=sex unknown	sex	0=both sexes,1=females only,2=males only,NA=sex unknown	STB-SEX-sex
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSBlim	lowest observed spawning stock biomass in previous assessments	E06larvae	millions of larvae	SSBlim-E06larvae
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSBlim	lowest observed spawning stock biomass in previous assessments	E03larvae	thousands of larvae	SSBlim-E03larvae
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSBlim	lowest observed spawning stock biomass in previous assessments	E09eggs	trillions of eggs	SSBlim-E09eggs
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSBlim	lowest observed spawning stock biomass in previous assessments	E03eggs	thousands of eggs	SSBlim-E03eggs
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSBmsy	Spawning Stock Biomass at MSY	FemaleGonadMT	Female Gonad Weight in metric tons	SSBmsy-FemaleGonadMT
OTHER BIOMETRICS	REFERENCE POINTS ETC.	SSBlim	lowest observed spawning stock biomass in previous assessments	FemaleGonadMT	Female Gonad Weight in metric tons	SSBlim-FemaleGonadMT
\.


--
-- Data for Name: bioparams; Type: TABLE DATA; Schema: srdb; Owner: srdbadmin
--

COPY bioparams (assessid, bioid, biovalue, bioyear, bionotes) FROM stdin;
\.


--
-- Data for Name: management; Type: TABLE DATA; Schema: srdb; Owner: srdbadmin
--

COPY management (mgmt, country, managementauthority) FROM stdin;
US State	USA	US state-level management
CCSBT	Multinational	Commission for the Conservation of Southern Bluefin Tuna
IATTC	Multinational	Inter-American Tropical Tuna Commission
ICCAT	Multinational	International Commission for the Conservation of Atlantic Tunas
ICES	Multinational	International Council for the Exploration of the Sea
IPHC	Multinational	International Pacific Halibut Commission
NAFO	Multinational	Northwest Atlantic Fisheries Organization
TRAC	Multinational	Transboundary Resource Assessment Committee (USA and Canada)
SPC	Multinational	Secretariat of the Pacific Community
CCAMLR	Multinational	Commission for the Conservation of Antarctic Marine Living Resources
IOTC	Multinational	Indian Ocean Tuna Commission
WPFMC	Multinational	Western Pacific Fishery Management Council
WCPFC	Multinational	Western and Central Pacific Fisheries Commission
_	_	_
GFCMED	Multinational	General Fisheries Council for the Mediterranean
DETMCM	South Africa	South African national management, Department of Environment and Tourism, Marine and Coastal Management
SPRFMO	Multinational	South Pacific Regional Fisheries Management Organization
UNKNOWN	Multinational	Unknown management body
DFO	Canada	Department of Fisheries and Oceans, Canada national management
NMFS	USA	National Marine Fisheries Service, US national management
MFish	New Zealand	Ministry of Fisheries, New Zealand national management
AFMA	Australia	Australian Fisheries Management Authority, Australia national management
RFFA	Russia	Russian Federal Fisheries Agency, Russia national management
CFP	Argentina	Consejo Federal Pesquero, Argentina national management
IMARPE	Peru	Instituto del Mar del Peru, Peru national management
\.


--
-- Data for Name: recorder; Type: TABLE DATA; Schema: srdb; Owner: srdbadmin
--

COPY recorder (firstname, lastname, email, institution, address, phonenumber, notes, nameinxls) FROM stdin;
Julia	Baum	juliakbaum@gmail.com	NA	NA	NA	NA	BAUM
Trevor	Branch	tbranch@gmail.com	NA	NA	NA	NA	BRANCH
Jeremy	Collie	jcollie@gso.uri.edu	NA	NA	NA	NA	COLLIE
Carryn	de Moor	c.l.demoor@telkomsa.net	NA	NA	NA	assesments from this recorder were submitted by Trevor Branch	deMoor
Chris	Francis	NULL	NA	NA	NA	NA	FRANCIS
Beth	Fulton	Beth.Fulton@csiro.au	NA	NA	NA	NA	FULTON
David	Gilroy	6ilroy@gmail.com	NA	NA	NA	Working with Olaf Jensen	GILROY
Jeff	Hutchings	jhutch@mathstat.dal.ca	Dalhousie University	1355 Oxford St. Halifax NS B3H 4J1 Canada	Intl. +1 902-494-2687	Professor at Dalhousie	HUTCHINGS
Simon	Jennings	simon.jennings@cefas.co.uk	NA	NA	NA	NA	JENNINGS
Olaf	Jensen	ojensen@u.washington.edu	University of Washington	NA	NA	NA	JENSEN
Susan	Johnston	susan.holloway@uct.ac.za	NA	NA	NA	assesments from this recorder were submitted by Trevor Branch	Johnston
Chris	Legault	chris.legault@noaa.gov	NOAA Fisheries - Northeast Fisheries Science Center	NMFS/NOAAWoods Hole MA 02543-1026 USA	NA	NMFS scientist - assessments from this recorder were submitted by Mike Fogarty	LEGAULT
Coilin	Minto	mintoc@mathstat.dal.ca	Dalhousie University	1355 Oxford St. Halifax NS B3H 4J1 Canada	Intl. +1 902-494-3910	Ph.D. candidate at Dalhousie University	MINTO
Ransom	Myers	NULL	NA	NA	NA	RAM's original data	MYERS
Ana	Parma	parma@cenpat.edu.ar	Centro Nacional Patagonico	Boulevard Brown 2915 U 9120 ACF Puerto Madryn, Chubut Argentina	(++54)(2965)451024 (ext. 229)	NA	Parma
Renee	Prefontaine	RN968668@dal.ca	NA	NA	NA	Honours student with Jeff Hutchings	PREFONTAINE
Mark	Terceiro	mtercer@mercury.wh.whoi.edu	NOAA Fisheries - Northeast Fisheries Science Center	NA	NA	NMFS scientist - assessments from this recorder were submitted by Mike Fogarty	TERCEIRO
Susan	Wigley	susan.wigley@noaa.gov	NOAA Fisheries - Northeast Fisheries Science Center	NA	NA	NMFS scientist - assessments from this recorder were submitted by Mike Fogarty	WIGLEY
Boris	Worm	bworm@dal.ca	Dalhousie University	1355 Oxford St. Halifax NS B3H 4J1 Canada	Intl. +1 902-494-2478	Assistant Professor at Dalhousie	WORM
Kate	Stanton	k.o.stanton@gmail.com	University of Washington	NA	NA	undergraduate student working with Olaf Jensen	STANTON
Loretta	O'Brien	loretta.o'brien@noaa.gov	NOAA Fisheries - Northeast Fisheries Science Center	NA	NA	NMFS scientist - assessments from this recorder were submitted by Mike Fogarty	OBRIEN
Michael 	Melnychuk	mmel@u.washington.edu	NA	NA	NA	graduate student working with Olaf Jensen	MELNYCHUK
Lisa	Hendrickson	NA	NA	NA	NA	NEFSC scientist, submitted on RAMlegacy	HENDRICKSON
William	Overholtz	NA	NA	NA	NA	NEFSC scientist, submitted on RAMlegacy	OVERHOLTZ
Paul	Nitschke	NA	NA	NA	NA	NEFSC scientist, submitted on RAMlegacy	NITSCHKE
Lauren	Col	NA	NA	NA	NA	NEFSC scientist, submitted on RAMlegacy	COL
Anne	Richards	NA	NA	NA	NA	NEFSC scientist, submitted on RAMlegacy	RICHARDS
Katherine	Sosebee	NA	NA	NA	NA	NEFSC scientist, submitted on RAMlegacy	SOSEBEE
Malin	Pinsky	mpinsky@stanford.edu	Stanford University	NA	NA	Grad student working with Steve Palumbi	PINSKY
Ralph	Mayo	NA	NA	NA	NA	NEFSC scientist, submitted on RAMlegacy	MAYO
Gary	Shepherd	NA	NA	NA	NA	NEFSC scientist, submitted on RAMlegacy	SHEPHERD
Laurence	Fauconnet	laurence.fauconnet@gmail.com	NA	NA	NA	graduate student working with Julia Baum	FAUCONNET
Tim	Miller	NA	NA	NA	NA	NEFSC scientist, submitted on RAMlegacy	MILLER
Josef	Idoine	NA	NA	NA	NA	NEFSC scientist, submitted on RAMlegacy	IDOINE
Dvora	Hart	NA	NA	NA	NA	NEFSC scientist, submitted on RAMlegacy	HART
Toni	Chute	NA	NA	NA	NA	NEFSC scientist, submitted on RAMlegacy	CHUTE
Eva	Plaganyi	NA	NA	NA	NA	assesments from this recorder were submitted by Trevor Branch	PLAGANYI
Sean	Anderson	sean@dal.ca	NA	NA	NA	NA	ANDERSON
Michelle	de Decker	Michelle.DeDecker@uct.ac.za	NA	NA	NA	assesments from this recorder were submitted by Trevor Branch	DEDECKER
Jacobson	Larry	NA	NA	NA	NA	NEFSC scientist, submitted on RAMlegacy	JACOBSON
Daniel	Ricard	ricardd@mathstat.dal.ca	Dalhousie University	1355 Oxford St. Halifax NS B3H 4J1 Canada	Intl. +1 902-494-2146	NA	RICARD
\.


--
-- Data for Name: referencedoc; Type: TABLE DATA; Schema: srdb; Owner: srdbadmin
--

COPY referencedoc (assessid, risfield, risentry) FROM stdin;
\.


--
-- Data for Name: risfields; Type: TABLE DATA; Schema: srdb; Owner: srdbadmin
--

COPY risfields (risfield, risdescription) FROM stdin;
TY	type of citation
ER	End of reference
ID	Reference ID
T1	Title Primary
TI	Title Primary
CT	Title Primary
BT	Title Primary
T2	Title Secondary
T3	Title Series
A1	Author Primary
AU	Author Primary
A2	Author Secondary
ED	Author Secondary
A3	Author Series
Y1	Date Primary
PY	Date Primary
Y2	Date Secondary
N1	Notes
AB	Notes
N2	Abstract
KW	Keywords
RP	Reprint status
L1	Link to PDF
L2	Link to Full-text
PB	Publisher
CY	City, State of publisher
VL	Volume or report number
JO	Periodical name
ZZID	My Reference ID
A	My TY
M1	Miscellaneous 1
EP	End Page
SP	Start Page
\.


--
-- Data for Name: risfieldvalues; Type: TABLE DATA; Schema: srdb; Owner: srdbadmin
--

COPY risfieldvalues (risfield, allowedvalueshort, allowedvaluelong) FROM stdin;
TY	CHAP	Book chapter
TY	COMP	Computer program
TY	CONF	Conference proceeding
TY	DATA	Data file
TY	ELEC	Electronic Citation
TY	JFULL	Journal (full)
TY	JOUR	Journal
TY	PCOMM	Personal communication
TY	RPRT	Report
TY	SER	Serial (Book, Monograph)
TY	THES	Thesis/Dissertation
TY	UNPB	Unpublished work
\.


--
-- Data for Name: stock; Type: TABLE DATA; Schema: srdb; Owner: srdbadmin
--

COPY stock (stockid, tsn, scientificname, commonname, areaid, stocklong, inmyersdb, myersstockid) FROM stdin;
\.


--
-- Data for Name: taxonomy; Type: TABLE DATA; Schema: srdb; Owner: srdbadmin
--

COPY taxonomy (tsn, scientificname, kingdom, phylum, classname, ordername, family, genus, species, myersname, commonname1, commonname2, myersscientificname, myersfamily) FROM stdin;
171342	Anarhichas minor	Animalia	Chordata	Actinopterygii	Perciformes	Anarhichadidae	Anarhichas	minor	SPWOLF	Spotted wolffish	NA	NA	NA
171341	Anarhichas lupus	Animalia	Chordata	Actinopterygii	Perciformes	Anarhichadidae	Anarhichas	lupus	STRWOLF	Striped wolffish	NA	NA	NA
167123	Anoplopoma fimbria	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Anoplopomatidae	Anoplopoma	fimbria	SABLEF	Sablefish	NA	NA	NA
172750	Scophthalmus maeoticus	Animalia	Chordata	Actinopterygii	Pleuronectiformes	Scophthalmidae	Scophthalmus	maeoticus	TURBOT	Black Sea turbot	NA	NA	NA
168598	Trachurus capensis	Animalia	Chordata	Actinopterygii	Perciformes	Carangidae	Trachurus	capensis	CTRAC	Cape horse mackerel	NA	NA	NA
168590	Trachurus mediterraneus	Animalia	Chordata	Actinopterygii	Perciformes	Carangidae	Trachurus	mediterraneus	MTRAC	Mediterranean horse mackerel	NA	NA	NA
168586	Trachurus symmetricus	Animalia	Chordata	Actinopterygii	Perciformes	Carangidae	Trachurus	symmetricus	STRAC	Pacific jack mackerel	South Pacific horse mackerel	NA	NA
168588	Trachurus trachurus	Animalia	Chordata	Actinopterygii	Perciformes	Carangidae	Trachurus	trachurus	TRAC	Horse mackerel	Atlantic horse mackerel	NA	NA
642743	Champsocephalus gunnari	Animalia	Chordata	Actinopterygii	Perciformes	Channichthyidae	Champsocephalus	gunnari	CGUN	Mackerel icefish	NA	NA	NA
642960	Pseudochaenichthys georgianus	Animalia	Chordata	Actinopterygii	Perciformes	Channichthyidae	Pseudochaenichthys	georgianus	PSGEOR	South Georgia icefish	NA	NA	NA
161703	Alosa aestivalis	Animalia	Chordata	Actinopterygii	Clupeiformes	Clupeidae	Alosa	aestivalis	ALOSA	Blueback shad	Blueback herring	NA	NA
551288	Alosa kessleri	Animalia	Chordata	Actinopterygii	Clupeiformes	Clupeidae	Alosa	kessleri	ALOSK	Caspian anadromous shad	Black sea shad	NA	NA
161706	Alosa pseudoharengus	Animalia	Chordata	Actinopterygii	Clupeiformes	Clupeidae	Alosa	pseudoharengus	ALEWIFE	Alewife	Gaspareau	NA	NA
161702	Alosa sapidissima	Animalia	Chordata	Actinopterygii	Clupeiformes	Clupeidae	Alosa	sapidissima	ATLALEWIFE	Atlantic shad	American shad	NA	NA
161732	Brevoortia tyrannus	Animalia	Chordata	Actinopterygii	Clupeiformes	Clupeidae	Brevoortia	tyrannus	MENAT	Atlantic menhaden	NA	NA	NA
161734	Brevoortia patronus	Animalia	Chordata	Actinopterygii	Clupeiformes	Clupeidae	Brevoortia	patronus	MENGF	Gulf menhaden	NA	NA	NA
161722	Clupea harengus	Animalia	Chordata	Actinopterygii	Clupeiformes	Clupeidae	Clupea	harengus	HERR	Herring	Atlantic herring	NA	NA
551209	Clupea pallasii	Animalia	Chordata	Actinopterygii	Clupeiformes	Clupeidae	Clupea	pallasii	PHERR	Pacific herring	NA	NA	NA
161813	Sardina pilchardus	Animalia	Chordata	Actinopterygii	Clupeiformes	Clupeidae	Sardina	pilchardus	SARDP	European pilchard	Spanish sardine	NA	NA
572698	Sardinella janeiro	Animalia	Chordata	Actinopterygii	Clupeiformes	Clupeidae	Sardinella	janeiro	SARDJ	Brazilian sardinella	Brazilian sardine	NA	NA
161729	Sardinops sagax	Animalia	Chordata	Actinopterygii	Clupeiformes	Clupeidae	Sardinops	sagax	SARD	Sardine	Pacific sardine	NA	NA
161789	Sprattus sprattus	Animalia	Chordata	Actinopterygii	Clupeiformes	Clupeidae	Sprattus	sprattus	SPRAT	Sprat	NA	NA	NA
692068	Scorpaenichthys marmoratus	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Cottidae	Scorpaenichthys	marmoratus	CABEZ	Cabezon	NA	NA	NA
167207	Artediellus uncinatus	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Cottidae	Artediellus	uncinatus	AHSCULPIN	Arctic hookear sculpin	NA	NA	NA
167439	Aspidophoroides monopterygius	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Cottidae	Aspidophoroides	monopterygius	ALLIGATORFISH	Alligatorfish	NA	NA	NA
167408	Cottunculus microps	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Psychrolutidae	Cottunculus	microps	ARCSCULPIN	Arctic sculpin	NA	NA	NA
551435	Coilia dussumieri	Animalia	Chordata	Actinopterygii	Clupeiformes	Engraulidae	Coilia	dussumieri	GANCHO	Goldspotted grenadier anchovy	NA	NA	NA
161831	Engraulis encrasicolus	Animalia	Chordata	Actinopterygii	Clupeiformes	Engraulidae	Engraulis	encrasicolus	ANCHO	Anchovy	European anchovy	NA	NA
161828	Engraulis mordax	Animalia	Chordata	Actinopterygii	Clupeiformes	Engraulidae	Engraulis	mordax	NANCHO	Northern anchovy	Californian anchovy	NA	NA
551340	Engraulis ringens	Animalia	Chordata	Actinopterygii	Clupeiformes	Engraulidae	Engraulis	ringens	PEANCHO	Peruvian anchoveta	Anchoveta	NA	NA
551338	Engraulis anchoita	Animalia	Chordata	Actinopterygii	Clupeiformes	Engraulidae	Engraulis	anchoita	ARGANCHO	Argentine anchoita	Anchoita	NA	NA
164712	Gadus morhua	Animalia	Chordata	Actinopterygii	Gadiformes	Gadidae	Gadus	morhua	COD	Atlantic cod	NA	NA	NA
164706	Boreogadus saida	Animalia	Chordata	Actinopterygii	Gadiformes	Gadidae	Boreogadus	saida	ARCCOD	Arctic cod	NA	NA	NA
164711	Gadus macrocephalus	Animalia	Chordata	Actinopterygii	Gadiformes	Gadidae	Gadus	macrocephalus	PCOD	Pacific cod	NA	NA	NA
164744	Melanogrammus aeglefinus	Animalia	Chordata	Actinopterygii	Gadiformes	Gadidae	Melanogrammus	aeglefinus	HAD	Haddock	NA	NA	NA
164758	Merlangius merlangus	Animalia	Chordata	Actinopterygii	Gadiformes	Gadidae	Merlangius	merlangus	WHIT	Whiting	NA	NA	NA
164774	Micromesistius poutassou	Animalia	Chordata	Actinopterygii	Gadiformes	Gadidae	Micromesistius	poutassou	BWHIT	Blue whiting	NA	NA	NA
164775	Micromesistius australis	Animalia	Chordata	Actinopterygii	Gadiformes	Gadidae	Micromesistius	australis	SBWHIT	Southern blue whiting	NA	Polaca	NA
164727	Pollachius virens	Animalia	Chordata	Actinopterygii	Gadiformes	Gadidae	Pollachius	virens	POLL	Pollock	Saithe	NA	NA
164722	Theragra chalcogramma	Animalia	Chordata	Actinopterygii	Gadiformes	Gadidae	Theragra	chalcogramma	WPOLL	Walleye pollock	NA	NA	NA
164756	Trisopterus esmarkii	Animalia	Chordata	Actinopterygii	Gadiformes	Gadidae	Trisopterus	esmarkii	NPOUT	Norway Pout	NA	NA	NA
167120	Pleurogrammus monopterygius	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Hexagrammidae	Pleurogrammus	monopterygius	ATKA	Atka mackerel	NA	NA	NA
159911	Lamna nasus	Animalia	Chordata	Chondrichthyes	Lamniformes	Lamnidae	Lamna	nasus	PORB	Porbeagle	NA	NA	NA
164499	Lophius americanus	Animalia	Chordata	Actinopterygii	Lophiiformes	Lophiidae	Lophius	americanus	MONK	Monkfish	Goosefish	NA	NA
164502	Lophius budegassa	Animalia	Chordata	Actinopterygii	Lophiiformes	Lophiidae	Lophius	budegassa	BMONK	Black anglerfish	Black-bellied angler	NA	NA
164501	Lophius piscatorius	Animalia	Chordata	Actinopterygii	Lophiiformes	Lophiidae	Lophius	piscatorius	MONK	Angler	Monkfish	NA	NA
164740	Brosme brosme	Animalia	Chordata	Actinopterygii	Gadiformes	Gadidae	Brosme	brosme	CUSK	Cusk	Torsk	NA	NA
164761	Molva dypterygia	Animalia	Chordata	Actinopterygii	Gadiformes	Gadidae	Molva	dypterygia	BLING	Blue ling	NA	NA	NA
164760	Molva molva	Animalia	Chordata	Actinopterygii	Gadiformes	Gadidae	Molva	molva	LING	Ling	NA	NA	NA
168860	Lutjanus synagris	Animalia	Chordata	Actinopterygii	Perciformes	Lutjanidae	Lutjanus	synagris	LSNAP	Lane snapper	Silk snapper	NA	NA
168853	Lutjanus campechanus	Animalia	Chordata	Actinopterygii	Perciformes	Lutjanidae	Lutjanus	campechanus	RSNAP	Red snapper	NA	NA	NA
165421	Macrourus berglax	Animalia	Chordata	Actinopterygii	Gadiformes	Macrouridae	Macrourus	berglax	RGHGRN	Roughhead grenadier	NA	NA	NA
164798	Merluccius capensis	Animalia	Chordata	Actinopterygii	Gadiformes	Merlucciidae	Merluccius	capensis	CHAKE	Shallow-water cape hake	South African hake	NA	NA
164795	Merluccius merluccius	Animalia	Chordata	Actinopterygii	Gadiformes	Merlucciidae	Merluccius	merluccius	HAKE	Hake	European hake	NA	NA
164799	Merluccius gayi	Animalia	Chordata	Actinopterygii	Gadiformes	Merlucciidae	Merluccius	gayi	PEHAKE	Peruvian hake	NA	NA	NA
164792	Merluccius productus	Animalia	Chordata	Actinopterygii	Gadiformes	Merlucciidae	Merluccius	productus	PHAKE	Pacific hake	North Pacific hake	NA	NA
164791	Merluccius bilinearis	Animalia	Chordata	Actinopterygii	Gadiformes	Merlucciidae	Merluccius	bilinearis	SHAKE	Silver Hake	NA	NA	NA
642916	Patagonotothen guntheri	Animalia	Chordata	Actinopterygii	Perciformes	Nototheniidae	Patagonotothen	guntheri	PATAG	Yellowfin notothen	NA	NA	NA
642852	Gobionotothen gibberifrons	Animalia	Chordata	Actinopterygii	Perciformes	Nototheniidae	Gobionotothen	gibberifrons	GOBIO	Humped rockcod 	NA	NA	NA
642886	Lepidonotothen squamifrons	Animalia	Chordata	Actinopterygii	Perciformes	Nototheniidae	Lepidonotothen	squamifrons	LEPSQ	Grey rockcod	NA	NA	NA
171105	Notothenia rossii	Animalia	Chordata	Actinopterygii	Perciformes	Nototheniidae	Notothenia	rossii	NOTOR	Marbled rockcod	NA	NA	NA
162035	Mallotus villosus	Animalia	Chordata	Actinopterygii	Osmeriformes	Osmeridae	Mallotus	villosus	CAPE	Capelin	NA	NA	NA
172735	Paralichthys dentatus	Animalia	Chordata	Actinopterygii	Pleuronectiformes	Paralichthyidae	Paralichthys	dentatus	SFLOUN	Summer flounder	NA	NA	NA
645441	Pseudopentaceros wheeleri	Animalia	Chordata	Actinopterygii	Perciformes	Pentacerotidae	Pseudopentaceros	wheeleri	PAHEAD	Pelagic armorhead	NA	NA	NA
164730	Urophycis chuss	Animalia	Chordata	Actinopterygii	Gadiformes	Gadidae	Urophycis	chuss	RHAKE	Red hake	NA	NA	NA
164732	Urophycis tenuis	Animalia	Chordata	Actinopterygii	Gadiformes	Gadidae	Urophycis	tenuis	WHAKE	White hake	NA	NA	NA
172868	Eopsetta jordani	Animalia	Chordata	Actinopterygii	Pleuronectiformes	Pleuronectidae	Eopsetta	jordani	PSOLE	Petrale sole	NA	NA	NA
172873	Glyptocephalus cynoglossus	Animalia	Chordata	Actinopterygii	Pleuronectiformes	Pleuronectidae	Glyptocephalus	cynoglossus	WITFLOUN	Witch flounder	NA	NA	NA
172877	Hippoglossoides platessoides	Animalia	Chordata	Actinopterygii	Pleuronectiformes	Pleuronectidae	Hippoglossoides	platessoides	AMPL	American plaice	NA	NA	NA
616041	Hippoglossoides dubius	Animalia	Chordata	Actinopterygii	Pleuronectiformes	Pleuronectidae	Hippoglossoides	dubius	FLFLOUN	Flathead flounder	NA	NA	NA
172932	Hippoglossus stenolepis	Animalia	Chordata	Actinopterygii	Pleuronectiformes	Pleuronectidae	Hippoglossus	stenolepis	PHAL	Pacific halibut	NA	NA	NA
172917	Lepidopsetta bilineata	Animalia	Chordata	Actinopterygii	Pleuronectiformes	Pleuronectidae	Lepidopsetta	bilineata	RSOLE	Rock sole	NA	NA	NA
172881	Limanda limanda	Animalia	Chordata	Actinopterygii	Pleuronectiformes	Pleuronectidae	Limanda	limanda	DAB	Common dab	NA	NA	NA
172911	Limanda proboscidea	Animalia	Chordata	Actinopterygii	Pleuronectiformes	Pleuronectidae	Limanda	proboscidea	LHDAB	Longhead dab	NA	NA	NA
616064	Limanda sakhalinensis	Animalia	Chordata	Actinopterygii	Pleuronectiformes	Pleuronectidae	Limanda	sakhalinensis	SAKFLOUN	Sakalin flounder	NA	NA	NA
172909	Limanda ferruginea	Animalia	Chordata	Actinopterygii	Pleuronectiformes	Pleuronectidae	Limanda	ferruginea	YELL	Yellowtail flounder	NA	NA	NA
172907	Limanda aspera	Animalia	Chordata	Actinopterygii	Pleuronectiformes	Pleuronectidae	Limanda	aspera	YSOLE	Yellowfin sole	NA	NA	NA
172921	Parophrys vetulus	Animalia	Chordata	Actinopterygii	Pleuronectiformes	Pleuronectidae	Parophrys	vetulus	ESOLE	English sole	NA	NA	NA
172894	Platichthys flesus	Animalia	Chordata	Actinopterygii	Pleuronectiformes	Pleuronectidae	Platichthys	flesus	FLOUN	Flounder	NA	NA	NA
172893	Platichthys stellatus	Animalia	Chordata	Actinopterygii	Pleuronectiformes	Pleuronectidae	Platichthys	stellatus	STFLOUN	Starry flounder	NA	NA	NA
172901	Pleuronectes quadrituberculatus	Animalia	Chordata	Actinopterygii	Pleuronectiformes	Pleuronectidae	Pleuronectes	quadrituberculatus	ALPLAIC	Alaska plaice	NA	NA	NA
172902	Pleuronectes platessa	Animalia	Chordata	Actinopterygii	Pleuronectiformes	Pleuronectidae	Pleuronectes	platessa	PLAIC	European Plaice	Plaice	NA	NA
172905	Pseudopleuronectes americanus	Animalia	Chordata	Actinopterygii	Pleuronectiformes	Pleuronectidae	Pseudopleuronectes	americanus	WINFLOUN	Winter flounder	NA	NA	NA
172930	Reinhardtius hippoglossoides	Animalia	Chordata	Actinopterygii	Pleuronectiformes	Pleuronectidae	Reinhardtius	hippoglossoides	GHAL	Greenland halibut	Greenland turbot	NA	NA
168559	Pomatomus saltatrix	Animalia	Chordata	Actinopterygii	Perciformes	Pomatomidae	Pomatomus	saltatrix	BLUEFISH	Bluefish	NA	NA	NA
564149	Amblyraja radiata	Animalia	Chordata	Chondrichthyes	Rajiformes	Rajidae	Amblyraja	radiata	THSKAT	Thorny skate	NA	NA	NA
564139	Dipturus laevis	Animalia	Chordata	Chondrichthyes	Rajiformes	Rajidae	Dipturus	laevis	BSKAT	Barndoor skate	NA	NA	NA
564130	Leucoraja erinacea	Animalia	Chordata	Chondrichthyes	Rajiformes	Rajidae	Leucoraja	erinacea	LSKAT	Little skate	NA	NA	NA
564136	Leucoraja garmani	Animalia	Chordata	Chondrichthyes	Rajiformes	Rajidae	Leucoraja	garmani	RSKAT	Rosette skate	Freckled skate	NA	NA
564145	Leucoraja ocellata	Animalia	Chordata	Chondrichthyes	Rajiformes	Rajidae	Leucoraja	ocellata	WSKAT	Winter skate	NA	NA	NA
564151	Malacoraja senta	Animalia	Chordata	Chondrichthyes	Rajiformes	Rajidae	Malacoraja	senta	SSKAT	Smooth skate	NA	NA	NA
160855	Raja eglanteria	Animalia	Chordata	Chondrichthyes	Rajiformes	Rajidae	Raja	eglanteria	CSKAT	Clearnose skate	NA	NA	NA
172412	Scomber japonicus	Animalia	Chordata	Actinopterygii	Perciformes	Scombridae	Scomber	japonicus	CMACK	Chub mackerel	Pacific chub mackerel	NA	NA
172414	Scomber scombrus	Animalia	Chordata	Actinopterygii	Perciformes	Scombridae	Scomber	scombrus	MACK	Mackerel	Atlantic mackerel	NA	NA
172435	Scomberomorus cavalla	Animalia	Chordata	Actinopterygii	Perciformes	Scombridae	Scomberomorus	cavalla	KMACK	King Mackerel	NA	NA	NA
172419	Thunnus alalunga	Animalia	Chordata	Actinopterygii	Perciformes	Scombridae	Thunnus	alalunga	ALBA	Albacore tuna	NA	NA	NA
172421	Thunnus thynnus	Animalia	Chordata	Actinopterygii	Perciformes	Scombridae	Thunnus	thynnus	ATBTUNA	Atlantic bluefin tuna	Northern bluefin tuna	NA	NA
172428	Thunnus obesus	Animalia	Chordata	Actinopterygii	Perciformes	Scombridae	Thunnus	obesus	BIGEYE	Bigeye tuna	NA	NA	NA
172431	Thunnus maccoyii	Animalia	Chordata	Actinopterygii	Perciformes	Scombridae	Thunnus	maccoyii	SBTUNA	Southern bluefin tuna	NA	NA	NA
172423	Thunnus albacares	Animalia	Chordata	Actinopterygii	Perciformes	Scombridae	Thunnus	albacares	YFIN	Yellowfin tuna	NA	NA	NA
172834	Lepidorhombus boscii	Animalia	Chordata	Actinopterygii	Pleuronectiformes	Scophthalmidae	Lepidorhombus	boscii	FMEG	Fourspotted megrim	NA	NA	NA
172835	Lepidorhombus whiffiagonis	Animalia	Chordata	Actinopterygii	Pleuronectiformes	Scophthalmidae	Lepidorhombus	whiffiagonis	MEG	Megrim	NA	NA	NA
172746	Scophthalmus aquosus	Animalia	Chordata	Actinopterygii	Pleuronectiformes	Scophthalmidae	Scophthalmus	aquosus	WINDOW	Windowpane	Windowpane flounder	NA	NA
166827	Scorpaena guttata	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Scorpaenidae	Scorpaena	guttata	CALSCORP	California scorpionfish	NA	NA	NA
166774	Sebastes fasciatus	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Scorpaenidae	Sebastes	fasciatus	ACADRED	Acadian redfish	Redfish	NA	NA
166733	Sebastes paucispinis	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Scorpaenidae	Sebastes	paucispinis	BOCACC	Bocaccio	NA	NA	NA
166722	Sebastes goodei	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Scorpaenidae	Sebastes	goodei	CHILI	Chilipepper rockfish	Chilipepper	NA	NA
166754	Sebastes levis	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Scorpaenidae	Sebastes	levis	COWCOD	Cowcod	NA	NA	NA
166715	Sebastes crameri	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Scorpaenidae	Sebastes	crameri	DKROCK	Darkblotched rockfish	NA	NA	NA
166767	Sebastes carnatus	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Scorpaenidae	Sebastes	carnatus	GOPHER	Gopher rockfish	NA	NA	NA
166707	Sebastes alutus	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Scorpaenidae	Sebastes	alutus	POPERCH	Pacific ocean perch	NA	NA	NA
167862	Serranus scriba	Animalia	Chordata	Actinopterygii	Perciformes	Serranidae	Serranus	scriba	REDMAR	Ocean perch	Redfish	NA	NA
166756	Sebastes mentella	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Scorpaenidae	Sebastes	mentella	REDMEN	Deepwater redfish	Redfish	NA	NA
166781	Sebastes norvegicus	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Scorpaenidae	Sebastes	norvegicus	GOLDRED	Golden Redfish	NA	NA	NA
166729	Sebastes miniatus	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Scorpaenidae	Sebastes	miniatus	VERMIL	Vermilion rockfish	NA	NA	NA
166719	Sebastes entomelas	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Scorpaenidae	Sebastes	entomelas	WROCK	Widow rockfish	NA	NA	NA
173002	Solea solea	Animalia	Chordata	Actinopterygii	Pleuronectiformes	Soleidae	Solea	solea	SOLE	Sole	Common sole	NA	NA
647939	Dentex tumifrons	Animalia	Chordata	Actinopterygii	Perciformes	Sparidae	Dentex	tumifrons	YSBREAM	Yellowback seabream	Yellow sea bream	NA	NA
169231	Chrysophrys auratus	Animalia	Chordata	Actinopterygii	Perciformes	Sparidae	Chrysophrys	auratus	NZSNAP	New Zealand snapper	Snapper	NA	NA
169207	Pagrus pagrus	Animalia	Chordata	Actinopterygii	Perciformes	Sparidae	Pagrus	pagrus	RPORGY	Common seabream	Red porgy	NA	NA
647892	Pagrus major	Animalia	Chordata	Actinopterygii	Perciformes	Sparidae	Pagrus	major	SBREAM	Red seabream	Sea bream	NA	NA
169182	Stenotomus chrysops	Animalia	Chordata	Actinopterygii	Perciformes	Sparidae	Stenotomus	chrysops	SCUP	Scup	NA	NA	NA
172482	Xiphias gladius	Animalia	Chordata	Actinopterygii	Perciformes	Xiphiidae	Xiphias	gladius	SWORD	Swordfish	NA	NA	NA
630979	Zoarces americanus	Animalia	Chordata	Actinopterygii	Perciformes	Zoarcidae	Zoarces	americanus	OPOUT	Ocean pout	NA	NA	NA
162064	Argentina silus	Animalia	Chordata	Actinopterygii	Osmeriformes	Argentinidae	Argentina	silus	ARGEN	Atlantic argentine	NA	NA	NA
162144	Esox masquinongy	Animalia	Chordata	Actinopterygii	Esociformes	Esocidae	Esox	masquinongy	MASKINOGIES	Maskinonge	NA	NA	NA
162139	Esox lucius	Animalia	Chordata	Actinopterygii	Esociformes	Esocidae	Esox	lucius	PIKE	Pike	NA	NA	NA
162027	Plecoglossus altivelis	Animalia	Chordata	Actinopterygii	Osmeriformes	Osmeridae	Plecoglossus	altivelis	AYU	Ayu	NA	NA	NA
161996	Salmo salar	Animalia	Chordata	Actinopterygii	Salmoniformes	Salmonidae	Salmo	salar	ASAL	Atlantic salmon	NA	NA	NA
623394	Coregonus hoyi	Animalia	Chordata	Actinopterygii	Salmoniformes	Salmonidae	Coregonus	hoyi	BLO	Bloater	NA	NA	NA
161997	Salmo trutta	Animalia	Chordata	Actinopterygii	Salmoniformes	Salmonidae	Salmo	trutta	BRNTRO	Brown Trout	NA	NA	NA
162003	Salvelinus fontinalis	Animalia	Chordata	Actinopterygii	Salmoniformes	Salmonidae	Salvelinus	fontinalis	BTRO	Freshwater brook trout	NA	NA	NA
161980	Oncorhynchus tshawytscha	Animalia	Chordata	Actinopterygii	Salmoniformes	Salmonidae	Oncorhynchus	tshawytscha	CHNK	Chinook salmon	NA	NA	NA
161976	Oncorhynchus keta	Animalia	Chordata	Actinopterygii	Salmoniformes	Salmonidae	Oncorhynchus	keta	CHUM	Chum salmon	NA	NA	NA
161977	Oncorhynchus kisutch	Animalia	Chordata	Actinopterygii	Salmoniformes	Salmonidae	Oncorhynchus	kisutch	COHO	Coho salmon	NA	NA	NA
162002	Salvelinus namaycush	Animalia	Chordata	Actinopterygii	Salmoniformes	Salmonidae	Salvelinus	namaycush	LTRO	Lake trout	NA	NA	NA
161941	Coregonus clupeaformis	Animalia	Chordata	Actinopterygii	Salmoniformes	Salmonidae	Coregonus	clupeaformis	LWHFSH	Lake Whitefish	NA	NA	NA
161975	Oncorhynchus gorbuscha	Animalia	Chordata	Actinopterygii	Salmoniformes	Salmonidae	Oncorhynchus	gorbuscha	PINK	Pink salmon	NA	NA	NA
161979	Oncorhynchus nerka	Animalia	Chordata	Actinopterygii	Salmoniformes	Salmonidae	Oncorhynchus	nerka	SOCK	Sockeye salmon	NA	NA	NA
161989	Oncorhynchus mykiss	Animalia	Chordata	Actinopterygii	Salmoniformes	Salmonidae	Oncorhynchus	mykiss	STRO	Steelhead trout	NA	NA	NA
161963	Coregonus albula	Animalia	Chordata	Actinopterygii	Salmoniformes	Salmonidae	Coregonus	albula	VENDACE	Vendace	NA	NA	NA
161950	Coregonus lavaretus	Animalia	Chordata	Actinopterygii	Salmoniformes	Salmonidae	Coregonus	lavaretus	WHFSH	Whitefish	NA	NA	NA
172978	Glyptocephalus zachirus	Animalia	Chordata	Actinopterygii	Pleuronectiformes	Pleuronectidae	Glyptocephalus	zachirus	REXSOLE	Rex sole	NA	NA	NA
616029	Reinhardtius stomias	Animalia	Chordata	Actinopterygii	Pleuronectiformes	Pleuronectidae	Reinhardtius	stomias	ARFLOUND	Arrowtooth flounder	NA	NA	NA
616392	Lepidopsetta polyxystra	Animalia	Chordata	Actinopterygii	Pleuronectiformes	Pleuronectidae	Lepidopsetta	polyxystra	NRSOLE	Northern rock sole	NA	NA	NA
172875	Hippoglossoides elassodon	Animalia	Chordata	Actinopterygii	Pleuronectiformes	Pleuronectidae	Hippoglossoides	elassodon	FLSOLE	Flathead sole	NA	NA	NA
166735	Sebastes polyspinis	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Scorpaenidae	Sebastes	polyspinis	NROCK	Northern rockfish	NA	NA	NA
166706	Sebastes aleutianus	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Scorpaenidae	Sebastes	aleutianus	REYEROCK	Rougheye rockfish	NA	NA	NA
172933	Hippoglossus hippoglossus	Animalia	Chordata	Actinopterygii	Pleuronectiformes	Pleuronectidae	Hippoglossus	hippoglossus	ATHAL	Atlantic Halibut	NA	NA	NA
97314	Homarus americanus	Animalia	Arthropoda	Malacostraca	Decapoda	Nephropidae	Homarus	americanus	LOBSTER	American lobster	NA	NA	NA
170479	Tautoga onitis	Animalia	Chordata	Actinopterygii	Perciformes	Labridae	Tautoga	onitis	TAUTOG	Tautog	NA	NA	NA
171677	Ammodytes marinus	Animalia	Chordata	Actinopterygii	Perciformes	Ammodytidae	Ammodytes	marinus	SEEL	Sand eel	Sand lance	NA	NA
171674	Ammodytes dubius	Animalia	Chordata	Actinopterygii	Perciformes	Ammodytidae	Ammodytes	dubius	SANDLANCE	Northern sand lance	NA	NA	NA
173001	Solea vulgaris	Animalia	Chordata	Actinopterygii	Pleuronectiformes	Soleidae	Solea	vulgaris	SOLE	common European sole	common sole	NA	NA
550883	Rexea solandri	Animalia	Chordata	Actinopterygii	Perciformes	Gempylidae	Rexea	solandri	GEMFISH	common gemfish	hake	NA	NA
170262	Nemadactylus macropterus	Animalia	Chordata	Actinopterygii	Perciformes	Cheilodactylidae	Nemadactylus	macropterus	MORWONG	Hawaiian morwong	Jackass morwong	NA	NA
172534	Seriolella punctata	Animalia	Chordata	Actinopterygii	Perciformes	Centrolophidae	Seriolella	punctata	SILVERFISH	Silverfish	NA	NA	NA
644187	Neoplatycephalus richardsoni	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Platycephalidae	Neoplatycephalus	richardsoni	TIGERFLAT	Tiger flathead	NA	NA	NA
646043	Sillago flindersi	Animalia	Chordata	Actinopterygii	Perciformes	Sillaginidae	Sillago	flindersi	SWHIT	School whiting	NA	NA	NA
172567	Peprilus triacanthus	Animalia	Chordata	Actinopterygii	Perciformes	Stromateidae	Peprilus	triacanthus	BUTTER	Atlantic butterfish	butterfish	NA	NA
160200	Rhizoprionodon terraenovae	Animalia	Chordata	Chondrichthyes	Carcharhiniformes	Carcharhinidae	Rhizoprionodon	terraenovae	SNOSESHAR	Atlantic sharpnose shark	NA	NA	NA
80944	Spisula solidissima	Animalia	Mollusca	Bivalvia	Veneroida	Mactridae	Spisula	solidissima	SURF	Atlantic surfclam	NA	NA	NA
166727	Sebastes melanops	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Scorpaenidae	Sebastes	melanops	BLACKROCK	Black rockfish	NA	NA	NA
167687	Centropristis striata	Animalia	Chordata	Actinopterygii	Perciformes	Serranidae	Centropristis	striata	BSBASS	Black sea bass	NA	NA	NA
160304	Carcharhinus acronotus	Animalia	Chordata	Chondrichthyes	Carcharhiniformes	Carcharhinidae	Carcharhinus	acronotus	BNOSESHAR	Blacknose shark	NA	NA	NA
160318	Carcharhinus limbatus	Animalia	Chordata	Chondrichthyes	Carcharhiniformes	Carcharhinidae	Carcharhinus	limbatus	BTIPSHAR	Blacktip shark	NA	NA	NA
97936	Paralithodes platypus	Animalia	Arthropoda	Malacostraca	Decapoda	Lithodidae	Paralithodes	platypus	BKINGCRAB	Blue king crab	NA	NA	NA
166730	Sebastes mystinus	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Scorpaenidae	Sebastes	mystinus	BLUEROCK	Blue rockfish	NA	NA	NA
160502	Sphyrna tiburo	Animalia	Chordata	Chondrichthyes	Carcharhiniformes	Sphyrnidae	Sphyrna	tiburo	BHEADSHAR	Bonnethead shark	NA	NA	NA
96028	Sicyonia brevirostris	Animalia	Arthropoda	Malacostraca	Decapoda	Sicyoniidae	Sicyonia	brevirostris	BRNROCKSHRIMP	Brown rock shrimp	NA	NA	NA
551570	Farfantepenaeus aztecus	Animalia	Arthropoda	Malacostraca	Decapoda	Penaeidae	Farfantepenaeus	aztecus	BRNSHRIMP	Brown shrimp	NA	NA	NA
166734	Sebastes pinniger	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Scorpaenidae	Sebastes	pinniger	CROCK	Canary rockfish	NA	NA	NA
172887	Microstomus pacificus	Animalia	Chordata	Actinopterygii	Pleuronectiformes	Pleuronectidae	Microstomus	pacificus	DSOLE	Dover sole	NA	NA	NA
166714	Sebastes ciliatus	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Scorpaenidae	Sebastes	ciliatus	DUSKYROCK	Dusky rockfish	NA	NA	NA
160268	Carcharhinus obscurus	Animalia	Chordata	Chondrichthyes	Carcharhiniformes	Carcharhinidae	Carcharhinus	obscurus	DUSKYSHAR	Dusky shark	NA	NA	NA
160409	Carcharhinus isodon	Animalia	Chordata	Chondrichthyes	Carcharhiniformes	Carcharhinidae	Carcharhinus	isodon	FTOOTHSHAR	Finetooth shark	NA	NA	NA
167759	Mycteroperca microlepis	Animalia	Chordata	Actinopterygii	Perciformes	Serranidae	Mycteroperca	microlepis	GAG	Gag	NA	NA	NA
173138	Balistes capriscus	Animalia	Chordata	Actinopterygii	Tetraodontiformes	Balistidae	Balistes	capriscus	GTRIG	Gray triggerfish	NA	NA	NA
168689	Seriola dumerili	Animalia	Chordata	Actinopterygii	Perciformes	Carangidae	Seriola	dumerili	GRAMBER	Greater amberjack	NA	NA	NA
160851	Raja rhina	Animalia	Chordata	Chondrichthyes	Rajiformes	Rajidae	Raja	rhina	LNOSESKA	Longnose skate	NA	NA	NA
82521	Illex illecebrosus	Animalia	Mollusca	Cephalopoda	Teuthida	Ommastrephidae	Illex	illecebrosus	ILLEX	Northern shortfin squid	NA	NA	NA
96967	Pandalus borealis	Animalia	Arthropoda	Malacostraca	Decapoda	Pandalidae	Pandalus	borealis	PANDAL	Northern shrimp	NA	NA	NA
81343	Arctica islandica	Animalia	Mollusca	Bivalvia	Veneroida	Arcticidae	Arctica	islandica	QUAH	Ocean quahog	NA	NA	NA
551574	Farfantepenaeus duorarum	Animalia	Arthropoda	Malacostraca	Decapoda	Penaeidae	Farfantepenaeus	duorarum	PINKSHRIMP	Pink shrimp	Northern pink shrimp	NA	NA
620992	Chaceon quinquedens	Animalia	Arthropoda	Malacostraca	Decapoda	Geryonidae	Chaceon	quinquedens	RDEEPCRAB	Red deepsea crab	NA	NA	NA
167702	Epinephelus morio	Animalia	Chordata	Actinopterygii	Perciformes	Serranidae	Epinephelus	morio	RGROUP	Red grouper	NA	NA	NA
97935	Paralithodes camtschaticus	Animalia	Arthropoda	Malacostraca	Decapoda	Lithodidae	Paralithodes	camtschaticus	RKCRAB	Red king crab	NA	NA	NA
95966	Pleoticus robustus	Animalia	Arthropoda	Malacostraca	Decapoda	Solenoceridae	Pleoticus	robustus	ROYALRSHRIMP	Royal red shrimp	NA	NA	NA
160289	Carcharhinus plumbeus	Animalia	Chordata	Chondrichthyes	Carcharhiniformes	Carcharhinidae	Carcharhinus	plumbeus	SBARSHAR	Sandbar shark	NA	NA	NA
79718	Placopecten magellanicus	Animalia	Mollusca	Bivalvia	Ostreoida	Pectinidae	Placopecten	magellanicus	SCALL	Sea scallop	NA	NA	NA
166725	Sebastes jordani	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Scorpaenidae	Sebastes	jordani	SBELLYROCK	Shortbelly rockfish	NA	NA	NA
166712	Sebastes borealis	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Scorpaenidae	Sebastes	borealis	SRAKEROCK	Shortraker rockfish	NA	NA	NA
98428	Chionoecetes opilio	Animalia	Arthropoda	Malacostraca	Decapoda	Oregoniidae	Chionoecetes	opilio	SNOWCRAB	Snow crab	NA	NA	NA
167705	Epinephelus niveatus	Animalia	Chordata	Actinopterygii	Perciformes	Serranidae	Epinephelus	niveatus	SNOWGROUP	Snowy grouper	NA	NA	NA
172436	Scomberomorus maculatus	Animalia	Chordata	Actinopterygii	Perciformes	Scombridae	Scomberomorus	maculatus	SPANMACK	Spanish mackerel	NA	NA	NA
160617	Squalus acanthias	Animalia	Chordata	Chondrichthyes	Squaliformes	Squalidae	Squalus	acanthias	SDOG	Spiny dogfish	NA	NA	NA
160703	Centroscyllium fabricii	Animalia	Chordata	Chondrichthyes	Squaliformes	Etmopteridae	Centroscyllium	fabricii	BDOG	Black dogfish	NA	NA	NA
167680	Morone saxatilis	Animalia	Chordata	Actinopterygii	Perciformes	Moronidae	Morone	saxatilis	STRIPEDBASS	Striped bass	NA	NA	NA
168546	Lopholatilus chamaeleonticeps	Animalia	Chordata	Actinopterygii	Perciformes	Malacanthidae	Lopholatilus	chamaeleonticeps	TILE	Tilefish	NA	NA	NA
168909	Rhomboplites aurorubens	Animalia	Chordata	Actinopterygii	Perciformes	Lutjanidae	Rhomboplites	aurorubens	VSNAP	Vermilion snapper	NA	NA	NA
551680	Litopenaeus setiferus	Animalia	Arthropoda	Malacostraca	Decapoda	Penaeidae	Litopenaeus	setiferus	WSHRIMP	White shrimp	NA	NA	NA
166740	Sebastes ruberrimus	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Scorpaenidae	Sebastes	ruberrimus	YEYEROCK	Yelloweye rockfish	NA	NA	NA
623193	Macruronus novaezelandiae	Animalia	Chordata	Actinopterygii	Gadiformes	Merlucciidae	Macruronus	novaezelandiae	HOKI	Hoki	New Zealand whiptail	NA	NA
168469	Perca flavescens	Animalia	Chordata	Actinopterygii	Perciformes	Percidae	Perca	flavescens	YPER	Yellow perch	NA	NA	NA
172401	Katsuwonus pelamis	Animalia	Chordata	Actinopterygii	Perciformes	Scombridae	Katsuwonus	pelamis	SKJ	Skipjack tuna	NA	NA	NA
95625	Penaeus esculentus	Animalia	Arthropoda	Malacostraca	Decapoda	Penaeidae	Penaeus	esculentus	BTSHRIMP	Brown tiger shrimp	Brown tiger prawn	NA	NA
95644	Penaeus semisulcatus	Animalia	Arthropoda	Malacostraca	Decapoda	Penaeidae	Penaeus	semisulcatus	GTPRAWN	Green tiger prawn	Grooved Tiger Prawn	NA	NA
166139	Hoplostethus atlanticus	Animalia	Chordata	Actinopterygii	Beryciformes	Trachichthyidae	Hoplostethus	atlanticus	OROUGHY	Orange roughy	NA	NA	NA
172531	Seriolella brama	Animalia	Chordata	Actinopterygii	Perciformes	Centrolophidae	Seriolella	brama	WAREHOU	whario	Blue Warehou	NA	NA
644351	Platycephalus conatus	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Platycephalidae	Platycephalus	conatus	DEEPFLATHEAD	Deepwater flathead	NA	NA	NA
622143	Centroberyx gerrardi	Animalia	Chordata	Actinopterygii	Beryciformes	Berycidae	Centroberyx	gerrardi	BIGHTRED	Bight redfish	NA	NA	NA
167612	Cyclopterus lumpus	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Cyclopteridae	Cyclopterus	lumpus	LUMPFISH	Lumpfish	NA	NA	NA
164748	Enchelyopus cimbrius	Animalia	Chordata	Actinopterygii	Gadiformes	Gadidae	Enchelyopus	cimbrius	FBROCKLING	Fourbeard rockling	NA	NA	NA
164717	Gadus ogac	Animalia	Chordata	Actinopterygii	Gadiformes	Gadidae	Gadus	ogac	GRCOD	Greenland cod	NA	NA	NA
201978	Gasterosteus aculeatus aculeatus	Animalia	Chordata	Actinopterygii	Gasterosteiformes	Gasterosteidae	Gasterosteus	aculeatus aculeatus	TSSTICKLEBACK	Threespine stickleback	NA	NA	NA
167289	Hemitripterus americanus	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Hemitripteridae	Hemitripterus	americanus	SEARAVEN	Sea raven	Sea sculpin	NA	NA
167375	Triglops murrayi	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Cottidae	Triglops	murrayi	MSCULPIN	Mailed sculpin	Moustache sculpin	NA	NA
170481	Tautogolabrus adspersus	Animalia	Chordata	Actinopterygii	Perciformes	Labridae	Tautogolabrus	adspersus	CUNNER	Cunner	NA	NA	NA
171596	Stichaeus punctatus	Animalia	Chordata	Actinopterygii	Perciformes	Stichaeidae	Stichaeus	punctatus	ARCSHINNY	Arctic shinny	NA	NA	NA
164734	Phycis chesteri	Animalia	Chordata	Actinopterygii	Gadiformes	Gadidae	Phycis	chesteri	LFHAKE	Longfin hake	NA	NA	NA
162041	Osmerus mordax	Animalia	Chordata	Actinopterygii	Osmeriformes	Osmeridae	Osmerus	mordax	RBSMELT	Rainbow smelt	NA	NA	NA
162043	Osmerus mordax mordax	Animalia	Chordata	Actinopterygii	Osmeriformes	Osmeridae	Osmerus	mordax mordax	RBSMELT	Rainbow smelt	NA	NA	NA
644687	Arctozenus risso	Animalia	Chordata	Actinopterygii	Aulopiformes	Paralepididae	Arctozenus	risso	WBARRACUDINA	White barracudina	NA	NA	NA
167192	Icelus spatula	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Cottidae	Icelus	spatula	SPSCULPIN	spatulate sculpin	NA	NA	NA
167478	Leptagonus decagonus	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Agonidae	Leptagonus	decagonus	ATLPOACHER	Atlantic poacher	NA	NA	NA
171603	Leptoclinus maculatus	Animalia	Chordata	Actinopterygii	Perciformes	Stichaeidae	Leptoclinus	maculatus	DSHANNY	Daubed shanny	NA	NA	NA
165395	Nezumia bairdii	Animalia	Chordata	Actinopterygii	Gadiformes	Macrouridae	Nezumia	bairdii	COMGRENADIER	Common grenadier	NA	NA	NA
159772	Myxine glutinosa	Animalia	Chordata	Myxini	Myxiniformes	Myxinidae	Myxine	glutinosa	ATLHAGFISH	Atlantic hagfish	NA	NA	NA
167318	Myoxocephalus scorpius	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Cottidae	Myoxocephalus	scorpius	SHORNSCULPIN	Shorthorn sculpin	NA	NA	NA
167317	Myoxocephalus scorpioides	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Cottidae	Myoxocephalus	scorpioides	ARCSCULPIN	Arctic sculpin	NA	NA	NA
167320	Myoxocephalus octodecemspinosus	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Cottidae	Myoxocephalus	octodecemspinosus	LHORNSCULPIN	Longhorn sculpin	NA	NA	NA
165296	Melanostigma atlanticum	Animalia	Chordata	Actinopterygii	Perciformes	Zoarcidae	Melanostigma	atlanticum	ATLSPOUT	Atlantic soft pout	NA	NA	NA
631028	Gymnelus viridis	Animalia	Chordata	Actinopterygii	Perciformes	Zoarcidae	Gymnelus	viridis	FISHDOCTOR	Fish doctor	NA	NA	NA
631023	Lumpenus lampretaeformis	Animalia	Chordata	Actinopterygii	Perciformes	Stichaeidae	Lumpenus	lampretaeformis	SNAKEBLENNY	Snakeblenny	NA	NA	NA
166705	Sebastes spp	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Scorpaenidae	Sebastes	spp	SEBASTES	Sebastes species	NA	NA	NA
167550	Liparis spp	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Liparidae	Liparis	spp	LIPARIS	Snailfishes	NA	NA	NA
165255	Lycodes spp	Animalia	Chordata	Actinopterygii	Perciformes	Zoarcidae	Lycodes	spp	LYCODES	Eelpouts	NA	NA	NA
165280	Lycodes reticulatus	Animalia	Chordata	Actinopterygii	Perciformes	Zoarcidae	Lycodes	reticulatus	ARCEELPOUT	Arctic eelpout	NA	NA	NA
172719	Citharichthys arctifrons	Animalia	Chordata	Actinopterygii	Pleuronectiformes	Paralichthyidae	Citharichthys	arctifrons	GSFLOUNDER	Gulf Stream flounder	NA	NA	NA
166787	Helicolenus dactylopterus	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Scorpaenidae	Helicolenus	dactylopterus	BBROSEFISH	Blackbelly rosefish	NA	NA	NULL 
172783	Hippoglossina oblonga	Animalia	Chordata	Actinopterygii	Pleuronectiformes	Paralichthyidae	Hippoglossina	oblonga	FSFLOUNDER	Fourspot flounder	NA	NA	NA
165284	Lycodes vahlii	Animalia	Chordata	Actinopterygii	Perciformes	Zoarcidae	Lycodes	vahlii	CEELPOUT	Checker eelpout	NA	NA	NA
161701	Alosa spp	Animalia	Chordata	Actinopterygii	Clupeiformes	Clupeidae	Alosa	spp	ALEWIFESPP	River herring species	NA	NA	NA
98671	Cancer spp	Animalia	Arthropoda	Malacostraca	Decapoda	Cancridae	Cancer	spp	CANCERSPP	True crab species	NA	NA	NA
82703	Limulus polyphemus	Animalia	Arthropoda	Merostomata	Xiphosura	Limulidae	Limulus	polyphemus	HORSESHOECRAB	Horseshoe crab	NA	NA	NA
98714	Ovalipes ocellatus	Animalia	Arthropoda	Malacostraca	Decapoda	Portunidae	Ovalipes	ocellatus	LADYCRAB	Lady crab	NA	NA	NA
164800	Merluccius hubbsi	Animalia	Chordata	Actinopterygii	Gadiformes	Merlucciidae	Merluccius	hubbsi	ARGHAKE	Argentine hake	NA	NA	NA
-999	Pseudocarcinus gigas	Animalia	Arthropoda	Malacostraca	Decapoda	Menippidae	Pseudocarcinus	gigas	TASGIANTCRAB	Tasmanian giant crab	NA	NA	NA
168849	Lutjanus analis	Animalia	Chordata	Actinopterygii	Perciformes	Lutjanidae	Lutjanus	analis	MUTSNAP	Mutton snapper	NA	NA	NA
552965	Palinurus gilchristi	Animalia	Arthropoda	Malacostraca	Decapoda	Palinuridae	Palinurus	gilchristi	SSLOBSTER	Southern spiny lobster	NA	NA	NA
550662	Macruronus magellanicus	Animalia	Chordata	Actinopterygii	Gadiformes	Merlucciidae	Macruronus	magellanicus	PATGRENADIER	Patagonian grenadier	Merluza de cola	NA	NA
164797	Merluccius australis	Animalia	Chordata	Actinopterygii	Gadiformes	Merlucciinae	Merluccius	australis	SOUTHHAKE	Southern hake	NA	NA	NA
644604	Sebastes variabilis	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Scorpaenidae	Sebastes	variabilis	DUSROCK	Dusky rockfish	NA	NA	NA
-997	Haliotis iris	Animalia	Mollusca	Gastropoda	Archaeogastropoda	Haliotididae	Haliotis	iris	BFOOTABALONE	Blackfoot abalone	NA	NA	NA
98429	Chionoecetes bairdi	Animalia	Arthropoda	Malacostraca	Decapoda	Oregoniidae	Chionoecetes	bairdi	TANNERCRAB	Tanner crab	NA	NA	NA
552953	Jasus lalandii	Animalia	Arthropoda	Malacostraca	Decapoda	Palinuridae	Jasus	lalandii	CRLOBSTER	South African west coast rock lobster	Cape rock lobster	NA	NA
660179	Lithodes aequispinus	Animalia	Arthropoda	Malacostraca	Decapoda	Lithodidae	Lithodes	aequispinus	GKINGCRAB	Golden king crab	NA	NA	NA
625280	Pseudocyttus maculatus	Animalia	Chordata	Actinopterygii	Zeiformes	Oreosomatidae	Pseudocyttus	maculatus	SMOOTHOREO	Smooth oreo	NA	NA	NA
-996	Haliotis spp	Animalia	Mollusca	Gastropoda	Archaeogastropoda	Haliotididae	Haliotis	NA	PAUA	Paua	New Zealand abalone species	NA	NA
660225	Jasus edwardsii	Animalia	Arthropoda	Malacostraca	Decapoda	Palinuridae	Jasus	edwardsii	RROCKLOBSTER	Red rock lobster	NA	NA	NA
625296	Allocyttus niger	Animalia	Chordata	Actinopterygii	Zeiformes	Oreosomatidae	Allocyttus	niger	BLACKOREO	Black oreo	NA	NA	NA
165000	Genypterus blacodes	Animalia	Chordata	Actinopterygii	Ophidiiformes	Ophidiidae	Genypterus	blacodes	NZLING	New Zealand ling	NA	NA	NA
168641	Pseudocaranx dentex	Animalia	Chordata	Actinopterygii	Perciformes	Carangidae	Pseudocaranx	dentex	TREVALLY	Trevally	White trevally	NA	NA
164796	Merluccius paradoxus	Animalia	Chordata	Actinopterygii	Gadiformes	Merlucciidae	Merluccius	paradoxus	DEEPCHAKE	Deep-water cape hake	Deep-water hake	NA	NA
169283	Micropogonias undulatus	Animalia	Chordata	Actinopterygii	Perciformes	Sciaenidae	Micropogonias	undulatus	ATLCROAK	Atlantic croaker	NA	NA	NA
642807	Dissostichus eleginoides	Animalia	Chordata	Actinopterygii	Perciformes	Nototheniidae	Dissostichus	eleginoides	PTOOTHFISH	Patagonian toothfish	NA	NA	NA
168597	Trachurus murphyi	Animalia	Chordata	Actinopterygii	Perciformes	Carangidae	Trachurus	murphyi	CHTRAC	Chilean jack mackerel	NA	NA	NA
168907	Ocyurus chrysurus	Animalia	Chordata	Actinopterygii	Perciformes	Lutjanidae	Ocyurus	chrysurus	YTSNAP	Yellowtail snapper	NA	NA	NA
166720	Sebastes flavidus	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Scorpaenidae	Sebastes	flavidus	YTROCK	Yellowtail rockfish	NA	NA	NA
167116	Ophiodon elongatus	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Hexagrammidae	Ophiodon	elongatus	LINGCOD	Lingcod	NA	NA	NA
166728	Sebastes melanostomus	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Scorpaenidae	Sebastes	melanostomus	BGROCK	Blackgill rockfish	NA	NA	NA
166783	Sebastolobus alascanus	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Scorpaenidae	Sebastolobus	alascanus	SSTHORNH	Shortspine thornyhead	NA	NA	NA
166784	Sebastolobus altivelis	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Scorpaenidae	Sebastolobus	altivelis	LSTHORNH	Longspine thornyhead	NA	NA	NA
-995	Haliotis midae	Animalia	Mollusca	Gastropoda	Archaeogastropoda	Haliotididae	Haliotis	midae	SAABALONE	South African abalone	NA	NA	NA
-998	Redfish species	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Scorpaenidae	NA	NA	REDFISHSPP	Redfish species	NA	NA	NA
168827	Arripis trutta	Animalia	Chordata	Actinopterygii	Perciformes	Arripidae	Arripis	trutta	AUSSALMON	Australian salmon	NA	NA	NA
167110	Hexagrammos decagrammus	Animalia	Chordata	Actinopterygii	Scorpaeniformes	Hexagrammidae	Hexagrammos	decagrammus	KELPGREENLING	Kelp greenling	NA	NA	NA
642808	Dissostichus mawsoni	Animalia	Chordata	Actinopterygii	Perciformes	Nototheniidae	Dissostichus	mawsoni	ATOOTHFISH	Antarctic toothfish	NA	NA	NA
159924	Isurus oxyrinchus	Animalia	Chordata	Chondrichthyes	Lamniformes	Lamnidae	Isurus	oxyrinchus	SFMAKO	Shortfin mako	NA	NA	NA
169241	Cynoscion regalis	Animalia	Chordata	Actinopterygii	Perciformes	Sciaenidae	Cynoscion	regalis	WEAKFISH	Weakfish	NA	NA	NA
165001	Genypterus capensis	Animalia	Chordata	Actinopterygii	Ophidiiformes	Ophidiidae	Genypterus	capensis	KINGKLIP	Kingklip	NA	NA	NA
\.


--
-- Data for Name: timeseries; Type: TABLE DATA; Schema: srdb; Owner: srdbadmin
--

COPY timeseries (assessid, tsid, tsyear, tsvalue) FROM stdin;
\.


--
-- Data for Name: tsmetrics; Type: TABLE DATA; Schema: srdb; Owner: srdbadmin
--

COPY tsmetrics (tscategory, tsshort, tslong, tsunitsshort, tsunitslong, tsunique) FROM stdin;
FISHING MORTALITY	F-unweighted	Fishing mortality	1/T	NA	F-unweighted-1/T
FISHING MORTALITY	F-N-weighted	Fishing mortality	1/T	NA	F-N-weighted-1/T
FISHING MORTALITY	F-B-weighted	Fishing mortality	1/T	NA	F-B-weighted-1/T
TOTAL BIOMASS	MB	Mean biomass	MT	Metric tons	MB-MT
TIME UNITS	YEAR	YEAR	yr	years	YEAR-yr
SPAWNING STOCK BIOMASS or CPUE	SSB	Spawning Stock Biomass	FemaleGonadMT	Female Gonad Weight in metric tons	SSB-FemaleGonadMT
SPAWNING STOCK BIOMASS or CPUE	SSB	Spawning Stock Biomass	E00pertow	Numbers per Tow	SSB-E00pertow
SPAWNING STOCK BIOMASS or CPUE	SSB	Spawning Stock Biomass	E03pertow	Thousands per Tow	SSB-E03pertow
SPAWNING STOCK BIOMASS or CPUE	SSB	Spawning Stock Biomass	E03MT	Thousands of metric tons	SSB-E03MT
SPAWNING STOCK BIOMASS or CPUE	SSB	Spawning Stock Biomass	E05MT	Tens of thousand of metric tons	SSB-E05MT
SPAWNING STOCK BIOMASS or CPUE	SSB	Spawning Stock Biomass	MT	Metric tons	SSB-MT
SPAWNING STOCK BIOMASS or CPUE	SSB	Spawning Stock Biomass	E00lbs	Pounds	SSB-E00lbs
SPAWNING STOCK BIOMASS or CPUE	SSB	Spawning Stock Biomass	E00	Individuals	SSB-E00
SPAWNING STOCK BIOMASS or CPUE	SSB	Spawning Stock Biomass	E03	Thousands	SSB-E03
SPAWNING STOCK BIOMASS or CPUE	SSB	Spawning Stock Biomass	E12eggs	Trillions of eggs produced	SSB-E12eggs
SPAWNING STOCK BIOMASS or CPUE	SSB	Spawning Stock Biomass	E08eggs	Hundreds of millions of eggs produced	SSB-E08eggs
SPAWNING STOCK BIOMASS or CPUE	SSB	Spawning Stock Biomass	E09eggs	Trillions of eggs produced	SSB-E09eggs
SPAWNING STOCK BIOMASS or CPUE	SSB	Spawning Stock Biomass	E06eggs	Millions of eggs produced	SSB-E06eggs
SPAWNING STOCK BIOMASS or CPUE	SSB	Spawning Stock Biomass	E03eggs	Thousands of eggs produced	SSB-E03eggs
SPAWNING STOCK BIOMASS or CPUE	SSB	Spawning Stock Biomass	E00eggs	Number of eggs produced	SSB-E00eggs
SPAWNING STOCK BIOMASS or CPUE	SSB	Spawning Stock Biomass	E06larvae	Millions of larvae produced	SSB-E06larvae
SPAWNING STOCK BIOMASS or CPUE	SSB	Spawning Stock Biomass	relative	relative	SSB-relative
SPAWNING STOCK BIOMASS or CPUE	SSB	Spawning Stock Biomass	E03relative	relative	SSB-E03relative
SPAWNING STOCK BIOMASS or CPUE	SSB-1	Spawning Stock Biomass. Use only when there is more than 1 'final' model.	MT	Metric tons	SSB-1-MT
SPAWNING STOCK BIOMASS or CPUE	SSB-2	Spawning Stock Biomass. Use only when there is more than 1 'final' model.	MT	Metric tons	SSB-2-MT
SPAWNING STOCK BIOMASS or CPUE	SSB-3	Spawning Stock Biomass. Use only when there is more than 1 'final' model.	MT	Metric tons	SSB-3-MT
SPAWNING STOCK BIOMASS or CPUE	SSB-4	Spawning Stock Biomass. Use only when there is more than 1 'final' model.	MT	Metric tons	SSB-4-MT
SPAWNING STOCK BIOMASS or CPUE	SSB-STDDEV	Standard deviation of spawning Stock Biomass	MT	Metric tons	SSB-STDDEV-MT
SPAWNING STOCK BIOMASS or CPUE	CPUEstand	Standardized CPUE for spawners. Use CPUE if SSB not available.	C/E	catch/effort	CPUEstand-C/E
SPAWNING STOCK BIOMASS or CPUE	CPUEstand-1	Standardized CPUE for spawners. Use only when there is more than 1 CPUE series	C/E	catch/effort	CPUEstand-1-C/E
SPAWNING STOCK BIOMASS or CPUE	CPUEstand-2	Standardized CPUE for spawners. Use only when there is more than 1 CPUE series	C/E	catch/effort	CPUEstand-2-C/E
SPAWNING STOCK BIOMASS or CPUE	CPUEstand-3	Standardized CPUE for spawners. Use only when there is more than 1 CPUE series	C/E	catch/effort	CPUEstand-3-C/E
SPAWNING STOCK BIOMASS or CPUE	CPUEstand-4	Standardized CPUE for spawners. Use only when there is more than 1 CPUE series	C/E	catch/effort	CPUEstand-4-C/E
SPAWNING STOCK BIOMASS or CPUE	CPUEstand-5	Standardized CPUE for spawners. Use only when there is more than 1 CPUE series	C/E	catch/effort	CPUEstand-5-C/E
SPAWNING STOCK BIOMASS or CPUE	CPUEstand-6	Standardized CPUE for spawners. Use only when there is more than 1 CPUE series	C/E	catch/effort	CPUEstand-6-C/E
SPAWNING STOCK BIOMASS or CPUE	CPUEraw	Raw CPUE for spawners. Use if CPUEstand is not available.	C/E	catch/effort	CPUEraw-C/E
SPAWNING STOCK BIOMASS or CPUE	CPUEraw-1	Standardized CPUE for spawners. Use only when there is more than 1 CPUE series	C/E	catch/effort	CPUEraw-1-C/E
SPAWNING STOCK BIOMASS or CPUE	CPUEraw-2	Standardized CPUE for spawners. Use only when there is more than 1 CPUE series	C/E	catch/effort	CPUEraw-2-C/E
SPAWNING STOCK BIOMASS or CPUE	CPUEraw-3	Standardized CPUE for spawners. Use only when there is more than 1 CPUE series	C/E	catch/effort	CPUEraw-3-C/E
SPAWNING STOCK BIOMASS or CPUE	CPUEraw-4	Standardized CPUE for spawners. Use only when there is more than 1 CPUE series	C/E	catch/effort	CPUEraw-4-C/E
SPAWNING STOCK BIOMASS or CPUE	CPUEraw-5	Standardized CPUE for spawners. Use only when there is more than 1 CPUE series	C/E	catch/effort	CPUEraw-5-C/E
SPAWNING STOCK BIOMASS or CPUE	CPUEraw-6	Standardized CPUE for spawners. Use only when there is more than 1 CPUE series	C/E	catch/effort	CPUEraw-6-C/E
SPAWNING STOCK BIOMASS or CPUE	CPUEsmooth	Smoothed survey index	E00pertow	Number per tow	CPUEsmooth-E00pertow
RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)	R	Recruits	MT	Metric tons	R-MT
RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)	R	Recruits	E03MT	Thousands of metric tons	R-E03MT
RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)	R	Recruits	E12	Trillions	R-E12
RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)	R	Recruits	E09	Billions	R-E09
RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)	R	Recruits	E06	Millions	R-E06
RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)	R	Recruits	E03	Thousands	R-E03
RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)	R	Recruits	E00	Individuals	R-E00
RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)	R	Recruits	E03smolt	Thousands of smolt	R-E03smolt
RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)	R	Recruits	E06fry	Millions of fry	R-E06fry
RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)	R	Recruits	E02fry	Hundreds of fry	R-E02fry
RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)	R	Recruits	E00fry	Number of fry	R-E00fry
RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)	R	Recruits	E00pertow	Numbers per Tow	R-E00pertow
RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)	R	Recruits	E00perhour	Numbers per Hour	R-E00perhour
RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)	R	Recruits	E03pertow	Thousands per Tow	R-E03pertow
RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)	RYCS	Relative year class strength	%	Percentage	RYCS-%
RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)	R-1	Recruits. Use only when there is more than 1 'final' model.	E00	Individuals	R-1-E00
RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)	R-2	Recruits. Use only when there is more than 1 'final' model.	E00	Individuals	R-2-E00
RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)	R-3	Recruits. Use only when there is more than 1 'final' model.	E00	Individuals	R-3-E00
RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)	R-4	Recruits. Use only when there is more than 1 'final' model.	E00	Individuals	R-4-E00
RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)	R-1	Recruits. Use only when there is more than 1 'final' model.	E03	Individuals	R-1-E03
RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)	R-2	Recruits. Use only when there is more than 1 'final' model.	E03	Individuals	R-2-E03
RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)	R-3	Recruits. Use only when there is more than 1 'final' model.	E03	Individuals	R-3-E03
RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)	R-4	Recruits. Use only when there is more than 1 'final' model.	E03	Individuals	R-4-E03
RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)	R	Recruits	relative	relative	R-relative
FISHING MORTALITY	F	Fishing mortality (preferred metric).	1/yr	NA	F-1/yr
FISHING MORTALITY	F	Fishing mortality (preferred metric).	1/T	NA	F-1/T
FISHING MORTALITY	F-1	Fishing mortality. Use only when there is more than 1 'final' model.	1/T	NA	F-1-1/T
FISHING MORTALITY	F-2	Fishing mortality. Use only when there is more than 1 'final' model.	1/T	NA	F-2-1/T
FISHING MORTALITY	F-3	Fishing mortality. Use only when there is more than 1 'final' model.	1/T	NA	F-3-1/T
FISHING MORTALITY	F-4	Fishing mortality. Use only when there is more than 1 'final' model.	1/T	NA	F-4-1/T
FISHING MORTALITY	F-5	Fishing mortality. Use only when there is more than 1 'final' model.	1/T	NA	F-5-1/T
FISHING MORTALITY	F-6	Fishing mortality. Use only when there is more than 1 'final' model.	1/T	NA	F-6-1/T
FISHING MORTALITY	ER	Exploitation Rate (2nd choice - use if F not available). Catch / Total Biomass	ratio	catch/biomass	ER-ratio
FISHING MORTALITY	ER-1	Exploitation Rate (2nd choice - use if F not available). Catch / Total Biomass	ratio	catch/biomass	ER-1-ratio
FISHING MORTALITY	ER-2	Exploitation Rate (2nd choice - use if F not available). Catch / Total Biomass	ratio	catch/biomass	ER-2-ratio
FISHING MORTALITY	ER-3	Exploitation Rate (2nd choice - use if F not available). Catch / Total Biomass	ratio	catch/biomass	ER-3-ratio
FISHING MORTALITY	ER-4	Exploitation Rate (2nd choice - use if F not available). Catch / Total Biomass	ratio	catch/biomass	ER-4-ratio
FISHING MORTALITY	ER-5	Exploitation Rate (2nd choice - use if F not available). Catch / Total Biomass	ratio	catch/biomass	ER-5-ratio
FISHING MORTALITY	ER-6	Exploitation Rate (2nd choice - use if F not available). Catch / Total Biomass	ratio	catch/biomass	ER-6-ratio
FISHING MORTALITY	ER	Exploitation Rate (2nd choice - use if F not available). Catch / Total Biomass	none	none	ER-none
FISHING MORTALITY	EI	Exploitation index (3rd choice - use this if ER and percentSPR not available)	ratio	catch biomass/survey biomass	EI-ratio
TOTAL BIOMASS	TB	Total biomass (or total exploitable biomass). Denoted on biometrics page	MT	Metric tons	TB-MT
TOTAL BIOMASS	TB	Total biomass (or total exploitable biomass). Denoted on biometrics page	E03MT	Thousands of metric tons	TB-E03MT
TOTAL BIOMASS	TB	Total biomass (or total exploitable biomass). Denoted on biometrics page	relative	relative	TB-relative
TOTAL BIOMASS	TN	Total abundance. Use TN if TB is not available	E03	Thousands	TN-E03
TOTAL BIOMASS	TN	Total abundance. Use TN if TB is not available	E06	Millions	TN-E06
TOTAL BIOMASS	TN	Total abundance	relative	relative	TN-relative
TOTAL BIOMASS	TB-1	Total biomass. Use only when there is more than 1 'final' model.	MT	Metric tons	TB-1-MT
TOTAL BIOMASS	TB-2	Total biomass. Use only when there is more than 1 'final' model.	MT	Metric tons	TB-2-MT
TOTAL BIOMASS	TB-3	Total biomass. Use only when there is more than 1 'final' model.	MT	Metric tons	TB-3-MT
TOTAL BIOMASS	TB-4	Total biomass. Use only when there is more than 1 'final' model.	MT	Metric tons	TB-4-MT
CATCH or LANDINGS	TC	Total catch (i.e. landings + discards. Add landings + discards to get this).	E03MT	Thousands of metric tons	TC-E03MT
CATCH or LANDINGS	TC	Total catch (i.e. landings + discards. Add landings + discards to get this).	MT	Metric tons	TC-MT
CATCH or LANDINGS	TC-1	Total catch (i.e. landings + discards. Add landings + discards to get this).	MT	Metric tons	TC-1-MT
CATCH or LANDINGS	TC-2	Total catch (i.e. landings + discards. Add landings + discards to get this).	MT	Metric tons	TC-2-MT
CATCH or LANDINGS	TC-3	Total catch (i.e. landings + discards. Add landings + discards to get this).	MT	Metric tons	TC-3-MT
CATCH or LANDINGS	TC	Total catch (i.e. landings + discards. Add landings + discards to get this).	E03	Thousands	TC-E03
CATCH or LANDINGS	TC	Total catch (i.e. landings + discards. Add landings + discards to get this).	E06	Millions	TC-E06
CATCH or LANDINGS	TC-1	Total catch. Use only when there is more than 1 accepted 'total catch' time series	E06	Millions	TC-1-E06
CATCH or LANDINGS	TC-1	Total catch. Use only when there is more than 1 accepted 'total catch' time series	E03	Thousands	TC-1-E03
CATCH or LANDINGS	TC-2	Total catch. Use only when there is more than 1 accepted 'total catch' time series	E06	Millions	TC-2-E06
CATCH or LANDINGS	TC-2	Total catch. Use only when there is more than 1 accepted 'total catch' time series	E03	Thousands	TC-2-E03
CATCH or LANDINGS	TC-3	Total catch. Use only when there is more than 1 accepted 'total catch' time series	E06	Millions	TC-3-E06
CATCH or LANDINGS	TC-3	Total catch. Use only when there is more than 1 accepted 'total catch' time series	E03	Thousands	TC-3-E03
CATCH or LANDINGS	TC-4	Total catch. Use only when there is more than 1 accepted 'total catch' time series	E06	Millions	TC-4-E06
CATCH or LANDINGS	TC-4	Total catch. Use only when there is more than 1 accepted 'total catch' time series	E03	Thousands	TC-4-E03
CATCH or LANDINGS	TL	Total landings	E03MT	Thousands of metric tons	TL-E03MT
CATCH or LANDINGS	TL	Total landings	E06MT	Millions of metric tons	TL-E06MT
CATCH or LANDINGS	TL	Total landings	MT	Metric tons	TL-MT
CATCH or LANDINGS	TL	Total landings	E00	Individuals	TL-E00
CATCH or LANDINGS	TL	Total landings	E06	Millions	TL-E06
CATCH or LANDINGS	TL	Total landings	E03lbs	Thousands of pounds	TL-E03lbs
CATCH or LANDINGS	TL-1	Total landings. Use only when there is more than 1 accepted 'total landings' time series	MT	Metric tons	TL-1-MT
CATCH or LANDINGS	TL-2	Total landings. Use only when there is more than 1 accepted 'total landings' time series	MT	Metric tons	TL-2-MT
CATCH or LANDINGS	TL-3	Total landings. Use only when there is more than 1 accepted 'total landings' time series	MT	Metric tons	TL-3-MT
CATCH or LANDINGS	TL-4	Total landings. Use only when there is more than 1 accepted 'total landings' time series	MT	Metric tons	TL-4-MT
CATCH or LANDINGS	TL-1	Total landings. Use only when there is more than 1 accepted 'total landings' time series	E03MT	Thousands of metric tons	TL-1-E03MT
OTHER TIME SERIES DATA	ASP	Annual surplus production	MT	Metric tons	ASP-MT
OTHER TIME SERIES DATA	M	Natural mortality (1 value per year)	1/T	per unit time	M-1/T
OTHER TIME SERIES DATA	M-1	Natural mortality (1 value per year)	1/T	per unit time	M-1-1/T
OTHER TIME SERIES DATA	M-2	Natural mortality (1 value per year)	1/T	per unit time	M-2-1/T
OTHER TIME SERIES DATA	Yield-SSB	Yield per SSB	dimensionless	dimensionless	Yield-SSB-dimensionless
OTHER TIME SERIES DATA	Yield-SSB-1	Yield per SSB. Use only when there is more than 1 'final' model.	dimensionless	dimensionless	Yield-SSB-1-dimensionless
OTHER TIME SERIES DATA	Yield-SSB-2	Yield per SSB. Use only when there is more than 1 'final' model.	dimensionless	dimensionless	Yield-SSB-2-dimensionless
OTHER TIME SERIES DATA	Z	Total mortality from survey based assessments	1/T	per unit time	Z-1/T
OTHER TIME SERIES DATA	DIS	Discards time series	E03MT	Thousands of metric tons	DIS-E03MT
OTHER TIME SERIES DATA	DIS	Discards time series	MT	Metric tons	DIS-MT
OTHER TIME SERIES DATA	DIS-1	Discards time series	MT	Metric tons	DIS-1-MT
OTHER TIME SERIES DATA	DIS-2	Discards time series	MT	Metric tons	DIS-2-MT
OTHER TIME SERIES DATA	BYCAT	Industrial bycatch	MT	Metric tons	BYCAT-MT
FISHING MORTALITY	F_MSY	Fishing mortality that yields MSY	1/yr	1/yr	F_MSY-1/yr
SPAWNING STOCK BIOMASS or CPUE	CPUE	Survey index	kgpertow	kg per tow	CPUE-kgpertow
RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)	R	Recruits	E07	Tens of Millions	R-E07
FISHING MORTALITY	F-7	Fishing mortality. Use only when there is more than 1 'final' model.	1/T	NA	F-7-1/T
FISHING MORTALITY	F-8	Fishing mortality. Use only when there is more than 1 'final' model.	1/T	NA	F-8-1/T
FISHING MORTALITY	F-0	Fishing mortality. Use only when there is more than 1 'final' model.	1/T	NA	F-0-1/T
SPAWNING STOCK BIOMASS or CPUE	SSF	Spawning Stock Fecundity	E00	Individuals	SSF-E00
CATCH or LANDINGS	TC	Total catch (i.e. landings + discards. Add landings + discards to get this).	E00	Individuals	TC-E00
SPAWNING STOCK BIOMASS or CPUE	SPR	Spawning Potential Ratio	ratio	ratio	SPR-ratio
FISHING MORTALITY	F-male	Fishing mortality for males.	1/yr	per year	F-male-1/yr
FISHING MORTALITY	F-female	Fishing mortality for females.	1/yr	per year	F-female-1/yr
TOTAL BIOMASS	STB	Summary total biomass.	MT	Metric tons	STB-MT
SPAWNING STOCK BIOMASS or CPUE	SSB	Spawning Stock Biomass	E06MT	Millions of metric tons	SSB-E06MT
\.


--
-- Name: area_pkey; Type: CONSTRAINT; Schema: srdb; Owner: srdbadmin; Tablespace: 
--

ALTER TABLE ONLY area
    ADD CONSTRAINT area_pkey PRIMARY KEY (areaid);


--
-- Name: assessment_pkey; Type: CONSTRAINT; Schema: srdb; Owner: srdbadmin; Tablespace: 
--

ALTER TABLE ONLY assessment
    ADD CONSTRAINT assessment_pkey PRIMARY KEY (assessid);


--
-- Name: assessmethod_pkey; Type: CONSTRAINT; Schema: srdb; Owner: srdbadmin; Tablespace: 
--

ALTER TABLE ONLY assessmethod
    ADD CONSTRAINT assessmethod_pkey PRIMARY KEY (methodshort);


--
-- Name: assessor_pkey; Type: CONSTRAINT; Schema: srdb; Owner: srdbadmin; Tablespace: 
--

ALTER TABLE ONLY assessor
    ADD CONSTRAINT assessor_pkey PRIMARY KEY (assessorid);


--
-- Name: biometrics_pkey; Type: CONSTRAINT; Schema: srdb; Owner: srdbadmin; Tablespace: 
--

ALTER TABLE ONLY biometrics
    ADD CONSTRAINT biometrics_pkey PRIMARY KEY (biounique);


--
-- Name: management_pkey; Type: CONSTRAINT; Schema: srdb; Owner: srdbadmin; Tablespace: 
--

ALTER TABLE ONLY management
    ADD CONSTRAINT management_pkey PRIMARY KEY (mgmt);


--
-- Name: recorder_pkey; Type: CONSTRAINT; Schema: srdb; Owner: srdbadmin; Tablespace: 
--

ALTER TABLE ONLY recorder
    ADD CONSTRAINT recorder_pkey PRIMARY KEY (nameinxls);


--
-- Name: risfields_pkey; Type: CONSTRAINT; Schema: srdb; Owner: srdbadmin; Tablespace: 
--

ALTER TABLE ONLY risfields
    ADD CONSTRAINT risfields_pkey PRIMARY KEY (risfield);


--
-- Name: scientificname_id; Type: CONSTRAINT; Schema: srdb; Owner: srdbadmin; Tablespace: 
--

ALTER TABLE ONLY taxonomy
    ADD CONSTRAINT scientificname_id UNIQUE (scientificname);


--
-- Name: stock_pkey; Type: CONSTRAINT; Schema: srdb; Owner: srdbadmin; Tablespace: 
--

ALTER TABLE ONLY stock
    ADD CONSTRAINT stock_pkey PRIMARY KEY (stockid);


--
-- Name: taxonomy_pkey; Type: CONSTRAINT; Schema: srdb; Owner: srdbadmin; Tablespace: 
--

ALTER TABLE ONLY taxonomy
    ADD CONSTRAINT taxonomy_pkey PRIMARY KEY (tsn);


--
-- Name: tsmetrics_pkey; Type: CONSTRAINT; Schema: srdb; Owner: srdbadmin; Tablespace: 
--

ALTER TABLE ONLY tsmetrics
    ADD CONSTRAINT tsmetrics_pkey PRIMARY KEY (tsunique);


--
-- Name: area_areatype_fkey; Type: FK CONSTRAINT; Schema: srdb; Owner: srdbadmin
--

ALTER TABLE ONLY area
    ADD CONSTRAINT area_areatype_fkey FOREIGN KEY (areatype) REFERENCES management(mgmt);


--
-- Name: assessment_assessmethod_fkey; Type: FK CONSTRAINT; Schema: srdb; Owner: srdbadmin
--

ALTER TABLE ONLY assessment
    ADD CONSTRAINT assessment_assessmethod_fkey FOREIGN KEY (assessmethod) REFERENCES assessmethod(methodshort);


--
-- Name: assessment_assessorid_fkey; Type: FK CONSTRAINT; Schema: srdb; Owner: srdbadmin
--

ALTER TABLE ONLY assessment
    ADD CONSTRAINT assessment_assessorid_fkey FOREIGN KEY (assessorid) REFERENCES assessor(assessorid);


--
-- Name: assessment_recorder_fkey; Type: FK CONSTRAINT; Schema: srdb; Owner: srdbadmin
--

ALTER TABLE ONLY assessment
    ADD CONSTRAINT assessment_recorder_fkey FOREIGN KEY (recorder) REFERENCES recorder(nameinxls);


--
-- Name: assessment_stockid_fkey; Type: FK CONSTRAINT; Schema: srdb; Owner: srdbadmin
--

ALTER TABLE ONLY assessment
    ADD CONSTRAINT assessment_stockid_fkey FOREIGN KEY (stockid) REFERENCES stock(stockid);


--
-- Name: assessor_mgmt_fkey; Type: FK CONSTRAINT; Schema: srdb; Owner: srdbadmin
--

ALTER TABLE ONLY assessor
    ADD CONSTRAINT assessor_mgmt_fkey FOREIGN KEY (mgmt) REFERENCES management(mgmt);


--
-- Name: bioparams_bioid_fkey; Type: FK CONSTRAINT; Schema: srdb; Owner: srdbadmin
--

ALTER TABLE ONLY bioparams
    ADD CONSTRAINT bioparams_bioid_fkey FOREIGN KEY (bioid) REFERENCES biometrics(biounique);


--
-- Name: referencedoc_assessid_fkey; Type: FK CONSTRAINT; Schema: srdb; Owner: srdbadmin
--

ALTER TABLE ONLY referencedoc
    ADD CONSTRAINT referencedoc_assessid_fkey FOREIGN KEY (assessid) REFERENCES assessment(assessid);


--
-- Name: referencedoc_risfield_fkey; Type: FK CONSTRAINT; Schema: srdb; Owner: srdbadmin
--

ALTER TABLE ONLY referencedoc
    ADD CONSTRAINT referencedoc_risfield_fkey FOREIGN KEY (risfield) REFERENCES risfields(risfield);


--
-- Name: risfieldvalues_risfield_fkey; Type: FK CONSTRAINT; Schema: srdb; Owner: srdbadmin
--

ALTER TABLE ONLY risfieldvalues
    ADD CONSTRAINT risfieldvalues_risfield_fkey FOREIGN KEY (risfield) REFERENCES risfields(risfield);


--
-- Name: stock_areaid_fkey; Type: FK CONSTRAINT; Schema: srdb; Owner: srdbadmin
--

ALTER TABLE ONLY stock
    ADD CONSTRAINT stock_areaid_fkey FOREIGN KEY (areaid) REFERENCES area(areaid);


--
-- Name: stock_tsn_fkey; Type: FK CONSTRAINT; Schema: srdb; Owner: srdbadmin
--

ALTER TABLE ONLY stock
    ADD CONSTRAINT stock_tsn_fkey FOREIGN KEY (tsn) REFERENCES taxonomy(tsn);


--
-- Name: timeseries_assessid_fkey; Type: FK CONSTRAINT; Schema: srdb; Owner: srdbadmin
--

ALTER TABLE ONLY timeseries
    ADD CONSTRAINT timeseries_assessid_fkey FOREIGN KEY (assessid) REFERENCES assessment(assessid);


--
-- Name: timeseries_tsid_fkey; Type: FK CONSTRAINT; Schema: srdb; Owner: srdbadmin
--

ALTER TABLE ONLY timeseries
    ADD CONSTRAINT timeseries_tsid_fkey FOREIGN KEY (tsid) REFERENCES tsmetrics(tsunique);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

