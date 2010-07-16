-- load QA/QC data

DROP TABLE srdb.qaqc;

CREATE TABLE srdb.qaqc (
assessid VARCHAR(200) UNIQUE REFERENCES srdb.assessment,
issueid INT UNIQUE, -- the issue number on the RAMlegacy spreadsheet submission
datesent DATE, -- date that the QA/QC plots were sent to the recorder
datereply DATE, -- date that the recorder sent a reply / replied on the RAMlegacy issue tracker 
dateapproved DATE, -- date that the assessment was approved as being QA/QAed
notes VARCHAR(1000), -- text field for notes
qaqc BOOLEAN -- is the assessment QA/QCed?
);



COPY srdb.qaqc
FROM '/home/srdbadmin/srdb/srdb/data/qaqc.dat'
CSV HEADER 
;

ALTER TABLE srdb.qaqc
ADD COLUMN issueurl VARCHAR(200);

UPDATE srdb.qaqc SET issueurl = ('http://www.marinebiodiversity.ca/RAMlegacy/ramlegacy-bug-reporting/' || issueid);

