# Cemented vs. Uncemented Hemiarthroplasty Trial Emulation
## Fesibility Code 

- Download the respository.
- Unzip the folder and open the R project file (Feasibility.RProj).
- Once RStudio is in the project, open the script WHITEfive.R.
- The script uses specific package versions. To recreate the correct environment, run the first line of the script: renv::restore(). This will install the required packages.
- Fill in the connection details for your database (server, schemas, and database name).
- Run the rest of the script. It will connect to the database, retrieve the relevant code counts, save the results, and produce a table for your visualisation.
