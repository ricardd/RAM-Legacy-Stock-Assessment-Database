-- indices to speed up time-series views

create index assessment_index_assessid on srdb.assessment(assessid); 

create index ts_index_assessid on srdb.timeseries(assessid); 
create index ts_index_year on srdb.timeseries(tsyear); 

