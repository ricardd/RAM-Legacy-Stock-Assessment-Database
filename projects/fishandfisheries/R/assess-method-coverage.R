## assess-method-coverage.R
## - R code to generate a dendrogram showing the assessment methods for assessments in the database
##
require(RODBC)

## select aa.assess, (CASE when am.category in ('Integrated Analysis','Statistical catch at age model', 'Statistical catch at length model') THEN 'SCA' ELSE am.category END) as category, am.methodshort, aa.assessid from srdb.assessment aa, srdb.assessmethod am where aa.assessmethod=am.methodshort and aa.recorder != 'MYERS' order by aa.assess, am.category;



chan <- odbcConnect(dsn="srdbcalo")

