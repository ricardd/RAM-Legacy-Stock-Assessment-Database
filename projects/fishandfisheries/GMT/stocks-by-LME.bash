#!/bin/bash
rm /home/srdbadmin/srdb/projects/fishandfisheries/GMT/stocks-byLME.ps

# 1 to 4 assessments
psql srdb -t -A -F " " -c "SELECT '>' || lme_number || E'\n', RTRIM(LTRIM(astext(the_geom), 'MULTIPOLYGON(('),'))') FROM stocksbylme where numassessments <=4 " | sed 's/),(/\n>/g' | sed 's/\,/\n/g' | psxy -Rg -JN13/10i -G250 -W -m -N -K >> /home/srdbadmin/srdb/projects/fishandfisheries/GMT/stocks-byLME.ps

psql srdb -t -A -F " " -c "SELECT '>' || lme_number || E'\n', RTRIM(LTRIM(astext(the_geom), 'MULTIPOLYGON(('),'))') FROM stocksbylme where numassessments > 4 and numassessments <=9 " | sed 's/),(/\n>/g' | sed 's/\,/\n/g' | psxy -R -J -G220 -W -m -N -K -O>> /home/srdbadmin/srdb/projects/fishandfisheries/GMT/stocks-byLME.ps

psql srdb -t -A -F " " -c "SELECT '>' || lme_number || E'\n', RTRIM(LTRIM(astext(the_geom), 'MULTIPOLYGON(('),'))') FROM stocksbylme where numassessments > 9 and numassessments <=20 " | sed 's/),(/\n>/g' | sed 's/\,/\n/g' | psxy -R -J -G180 -W -m -N -K -O>> /home/srdbadmin/srdb/projects/fishandfisheries/GMT/stocks-byLME.ps

psql srdb -t -A -F " " -c "SELECT '>' || lme_number || E'\n', RTRIM(LTRIM(astext(the_geom), 'MULTIPOLYGON(('),'))') FROM stocksbylme where numassessments > 20 and numassessments <=30 " | sed 's/),(/\n>/g' | sed 's/\,/\n/g' | psxy -R -J -G110 -W -m -N -K -O>> /home/srdbadmin/srdb/projects/fishandfisheries/GMT/stocks-byLME.ps

psql srdb -t -A -F " " -c "SELECT '>' || lme_number || E'\n', RTRIM(LTRIM(astext(the_geom), 'MULTIPOLYGON(('),'))') FROM stocksbylme where numassessments > 30 " | sed 's/),(/\n>/g' | sed 's/\,/\n/g' | psxy -R -J -G30 -W -m -N -K -O>> /home/srdbadmin/srdb/projects/fishandfisheries/GMT/stocks-byLME.ps

pscoast -W  -A15000 -Dc -R -J -Gwhite -K -O >> /home/srdbadmin/srdb/projects/fishandfisheries/GMT/stocks-byLME.ps

pslegend /home/srdbadmin/srdb/projects/fishandfisheries/GMT/legend-text.txt -D-167/-10/4i/4i/LM -J -R -X-0.2c -O >> /home/srdbadmin/srdb/projects/fishandfisheries/GMT/stocks-byLME.ps


ps2pdf /home/srdbadmin/srdb/projects/fishandfisheries/GMT/stocks-byLME.ps /home/srdbadmin/srdb/projects/fishandfisheries/GMT/stocks-byLME.pdf
