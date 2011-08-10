#!/bin/bash
rm /home/srdbadmin/srdb/projects/fishandfisheries/GMT/hourglass.ps
# 1 to 4 assessments

psql srdb -t -A -F " " -c "SELECT '>' || lme_number || E'\n', RTRIM(LTRIM(astext(the_geom), 'MULTIPOLYGON(('),'))') FROM stocksbylme where numassessments <=4 " | sed 's/),(/\n>/g' | sed 's/\,/\n/g' | psxy -Rg -JN4/10i -G65/152/175 -W -m -N -K -Y3c>> /home/srdbadmin/srdb/projects/fishandfisheries/GMT/hourglass.ps


pscoast -W  -A15000 -Dc -R -J -Gwhite -K -O >> /home/srdbadmin/srdb/projects/fishandfisheries/GMT/hourglass.ps

psxy /home/srdbadmin/srdb/srdb/data/LMEs/hourglass-atlantic.xy -R -J -G65/152/175 -W -m -N -O>> /home/srdbadmin/srdb/projects/fishandfisheries/GMT/hourglass.ps
