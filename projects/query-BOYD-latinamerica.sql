select 
aa.assessid,
ss.stocklong,
tt.scientificname,
tt.commonname1
from 
srdb.assessment aa,
srdb.stock ss,
srdb.taxonomy tt
where aa.stockid in
(
select stockid 
from srdb.stock
where tsn in 
(
select tsn
from srdb.taxonomy
where
scientificname in
(
'Strangomera bentincki','Engraulis anchoita','Pleoticus muelleri','Illex argentinus','Merluccius hubbsi','Thunnus thynnus','Makaira nigricans','Sardinella brasiliensis',
'Engraulis mordax','Scomber japonicus','Sarda chiliensis','Epenephelus itajara','Cynoscion virescens','Trachurus murphyi','Cynoscion jamaicensis',
'Dosidicus gigas','Scomberomorus cavalla','Macrodon ancylodon','Octopus maya','Epinephelus striatus','Xiphias gladius','Litopenaeus setiferus',
'Logilo opalescens','Cetengraulis mysticetus','Opisthonema libertate','Macruronus magellanicus','Dissostichus eleginoides','Engraulis ringens ',
'Genypterus blacodes','Sciaenops ocellatus','Epinephelus morio','Lutjanus campechanus','Hymenopenaeus robustus','Scomberomorus brasiliensis',
'Nebris microps','Sardinops sagax','Merluccius gayi gayi','Cynoscion striatus','Micromesistius australis','Farfantepenaeus subtilis','Merluccius australis',
'Farfantepenaeus duorarum','Xiphias gladius','Istiophorus platypterus','Tetrapterus albidus','Micropogonias furnieri'
)
)
)
AND
aa.stockid=ss.stockid AND
ss.tsn=tt.tsn
;

