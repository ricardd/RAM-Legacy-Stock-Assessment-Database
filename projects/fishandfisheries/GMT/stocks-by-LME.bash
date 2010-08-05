#!/bin/bash
rm /home/srdbadmin/srdb/projects/fishandfisheries/GMT/stocks-byLME.ps

# 1 to 4 assessments
#psql srdb -t -A -F " " -c "SELECT '>' || lme_number || E'\n', RTRIM(LTRIM(astext(the_geom), 'MULTIPOLYGON(('),'))') FROM stocksbylme where numassessments <=4 " | sed 's/),(/\n>/g' | sed 's/\,/\n/g' | psxy -Rg -JN13/10i -G250 -W -m -N -K >> /home/srdbadmin/srdb/projects/fishandfisheries/GMT/stocks-byLME.ps
psql srdb -t -A -F " " -c "SELECT '>' || lme_number || E'\n', RTRIM(LTRIM(astext(the_geom), 'MULTIPOLYGON(('),'))') FROM stocksbylme where numassessments <=4 " | sed 's/),(/\n>/g' | sed 's/\,/\n/g' | psxy -Rg -JN4/10i -G65/152/175 -W -m -N -K >> /home/srdbadmin/srdb/projects/fishandfisheries/GMT/stocks-byLME.ps

#185/205/150

#psql srdb -t -A -F " " -c "SELECT '>' || lme_number || E'\n', RTRIM(LTRIM(astext(the_geom), 'MULTIPOLYGON(('),'))') FROM stocksbylme where numassessments > 4 and numassessments <=9 " | sed 's/),(/\n>/g' | sed 's/\,/\n/g' | psxy -R -J -G220 -W -m -N -K -O>> /home/srdbadmin/srdb/projects/fishandfisheries/GMT/stocks-byLME.ps
psql srdb -t -A -F " " -c "SELECT '>' || lme_number || E'\n', RTRIM(LTRIM(astext(the_geom), 'MULTIPOLYGON(('),'))') FROM stocksbylme where numassessments > 4 and numassessments <=9 " | sed 's/),(/\n>/g' | sed 's/\,/\n/g' | psxy -R -J -G185/205/150 -W -m -N -K -O>> /home/srdbadmin/srdb/projects/fishandfisheries/GMT/stocks-byLME.ps

#137/165/78

#psql srdb -t -A -F " " -c "SELECT '>' || lme_number || E'\n', RTRIM(LTRIM(astext(the_geom), 'MULTIPOLYGON(('),'))') FROM stocksbylme where numassessments > 9 and numassessments <=20 " | sed 's/),(/\n>/g' | sed 's/\,/\n/g' | psxy -R -J -G180 -W -m -N -K -O>> /home/srdbadmin/srdb/projects/fishandfisheries/GMT/stocks-byLME.ps
psql srdb -t -A -F " " -c "SELECT '>' || lme_number || E'\n', RTRIM(LTRIM(astext(the_geom), 'MULTIPOLYGON(('),'))') FROM stocksbylme where numassessments > 9 and numassessments <=20 " | sed 's/),(/\n>/g' | sed 's/\,/\n/g' | psxy -R -J -G137/165/78 -W -m -N -K -O>> /home/srdbadmin/srdb/projects/fishandfisheries/GMT/stocks-byLME.ps

#65/152/175

#psql srdb -t -A -F " " -c "SELECT '>' || lme_number || E'\n', RTRIM(LTRIM(astext(the_geom), 'MULTIPOLYGON(('),'))') FROM stocksbylme where numassessments > 20 and numassessments <=30 " | sed 's/),(/\n>/g' | sed 's/\,/\n/g' | psxy -R -J -G110 -W -m -N -K -O>> /home/srdbadmin/srdb/projects/fishandfisheries/GMT/stocks-byLME.ps
psql srdb -t -A -F " " -c "SELECT '>' || lme_number || E'\n', RTRIM(LTRIM(astext(the_geom), 'MULTIPOLYGON(('),'))') FROM stocksbylme where numassessments > 20 and numassessments <=30 " | sed 's/),(/\n>/g' | sed 's/\,/\n/g' | psxy -R -J -G219/132/61 -W -m -N -K -O>> /home/srdbadmin/srdb/projects/fishandfisheries/GMT/stocks-byLME.ps

#219/132/61

#psql srdb -t -A -F " " -c "SELECT '>' || lme_number || E'\n', RTRIM(LTRIM(astext(the_geom), 'MULTIPOLYGON(('),'))') FROM stocksbylme where numassessments > 30 " | sed 's/),(/\n>/g' | sed 's/\,/\n/g' | psxy -R -J -G30 -W -m -N -K -O>> /home/srdbadmin/srdb/projects/fishandfisheries/GMT/stocks-byLME.ps
psql srdb -t -A -F " " -c "SELECT '>' || lme_number || E'\n', RTRIM(LTRIM(astext(the_geom), 'MULTIPOLYGON(('),'))') FROM stocksbylme where numassessments > 30 " | sed 's/),(/\n>/g' | sed 's/\,/\n/g' | psxy -R -J -G170/70/67 -W -m -N -K -O>> /home/srdbadmin/srdb/projects/fishandfisheries/GMT/stocks-byLME.ps

#170/70/67

pscoast -W  -A15000 -Dc -R -J -Gwhite -K -O >> /home/srdbadmin/srdb/projects/fishandfisheries/GMT/stocks-byLME.ps

#pslegend /home/srdbadmin/srdb/projects/fishandfisheries/GMT/legend-text.txt -D-167/-10/4i/4i/LM -J -R -X-0.2c -O >> /home/srdbadmin/srdb/projects/fishandfisheries/GMT/stocks-byLME.ps
pslegend /home/srdbadmin/srdb/projects/fishandfisheries/GMT/legend-text-colours.txt -D-167/-10/4i/4i/LM -J -R -X-0.2c -O >> /home/srdbadmin/srdb/projects/fishandfisheries/GMT/stocks-byLME.ps


ps2pdf /home/srdbadmin/srdb/projects/fishandfisheries/GMT/stocks-byLME.ps /home/srdbadmin/srdb/projects/fishandfisheries/GMT/stocks-byLME.pdf

convert /home/srdbadmin/srdb/projects/fishandfisheries/GMT/stocks-byLME.ps /home/srdbadmin/srdb/projects/fishandfisheries/GMT/stocks-byLME.png