# get packages
renv::restore()

# load packages
library(SqlRender)
library(CDMConnector)
library(DBI)
library(CodelistGenerator)
library(omopgenerics)

# database information
server_dbi <- "..."
user <- "..."
password <- "..."
port <- "..."
host <- "..."

# database schemas
cdm_database_schema <- "..."
results_database_schema <- "..."

# database name
database_name <- "..."

# prefix to identify cohorts
table_stem <- "whitefive"

# connecto to the database
db <- dbConnect(
  drv = RPostgres::Postgres(),
  dbname = server_dbi,
  port = port,
  host = host,
  user = user,
  password = password
)

# create cdm object
cdm <- cdmFromCon(
  con = db,
  cdmSchema = cdm_database_schema,
  writeSchema = results_database_schema,
  writePrefix = tolower(table_stem),
  cdmName = database_name
)

# create codelists
codesFracture <- getCandidateCodes(
  cdm = cdm,
  keywords = c("fracture of proximal end of femur"),
  exclude = c("conversion", "revision", "removal"),
  domains = c("condition"),
  standardConcept = "Standard",
  searchInSynonyms = TRUE,
  searchNonStandard = FALSE,
  includeDescendants = TRUE,
  includeAncestor = FALSE
)
codesUncemented <- getCandidateCodes(
  cdm = cdm,
  keywords = c("hip uncemented hemiarthroplasty"),
  exclude = c("conversion", "revision", "removal"),
  domains = c("procedure", "device"),
  standardConcept = "Standard",
  searchInSynonyms = TRUE,
  searchNonStandard = FALSE,
  includeDescendants = TRUE,
  includeAncestor = FALSE
)
codesCemented <- getCandidateCodes(
  cdm = cdm,
  keywords = c("hip cemented hemiarthroplasty"),
  exclude = c("conversion", "revision", "removal"),
  domains = c("procedure", "device"),
  standardConcept = "Standard",
  searchInSynonyms = TRUE,
  searchNonStandard = FALSE,
  includeDescendants = TRUE,
  includeAncestor = FALSE
)

# get codelist use
codeUse <- summariseCodeUse(
  x = list("fracture of proximal end of femur" = codesFracture$concept_id,
           "hip cemented hemiarthroplasty" = codesCemented$concept_id,
           "hip uncemented hemiarthroplasty" = codesUncemented$concept_id),
  cdm = cdm,
  byYear = TRUE,
  bySex = TRUE,
  ageGroup = list(c(0, 59), c(60, 150))
)

# export results
exportSummarisedResult(codeUse)

# disconnect
cdmDisconnect(cdm)

# see results
tableCodeUse(codeUse |> filterStrata(age_group == "overall", sex == "overall", year == "overall"))
