select 'INSERT INTO srdb.referencedoc VALUES(''' || assessid || ''',''ZZID'',''' || assessid || ''');' from (select distinct assessid from srdb.referencedoc) as a; 

select 'INSERT INTO srdb.referencedoc VALUES(''' || assessid || ''',''A'',''' || risentry || ''');' from (select assessid, risentry from srdb.referencedoc where risfield='TY') as a; 
