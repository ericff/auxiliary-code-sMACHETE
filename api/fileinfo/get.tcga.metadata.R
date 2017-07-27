## 
## 

mydir <- "/my/dir"
wdir <- file.path(mydir, "api/fileinfo")

datadir <- file.path(wdir, "tcgametadata")

## wrapper, call curl for each, then python for each, make into a csv file, then read in, then try to combine into tables, probably with
## a merge and some NAs
## in python, get rid of .0. terms, and also change any underscores to .

## then have to merge with the list of fusions, then take out any
##    case info if we ever publish it


## First need a list of all CASE UUIDs we have used for MACHETE

## Note that file uuids might be better, but this is easier


metadata.machete.runs.all <- read.table(file.path(wdir, "metadata.csv"), sep =",", fill=TRUE, colClasses="character", stringsAsFactors=FALSE, header=TRUE)
case.ids.all <- tolower(metadata.machete.runs.all$case_uuid)
sample.ids.all <- tolower(metadata.machete.runs.all$sample_uuid)

n.case.ids <- length(case.ids.all)
stopifnot(length(sample.ids.all)==n.case.ids)
    
## this.case.id <- "1fe19c6b-71d0-4b07-923b-74ea32210db0"
## this.sample.id <- "841bdebe-253d-4183-a3a1-e2780c859187"
all.json.files <- vector("character", length = n.case.ids)
all.csv.files <- vector("character", length = n.case.ids)
download.success <- vector("character", length = n.case.ids)
all.json.files[] <- NA
all.csv.files[] <- NA
download.success[] <- FALSE

ii <- 0
for (this.case.id in case.ids.all){
    ii <- ii + 1
    this.sample.id<- sample.ids.all[ii]
    jsonfilename <- file.path(datadir, paste("jsoninfo.caseid.", this.case.id, ".json", sep=""))
    outfilename <- file.path(datadir, paste("csvinfo.caseid.", this.case.id, ".csv", sep=""))
    if (ii %% 10 == 0){
        cat("Working on ", ii, "\n")
        ##
        ## call for curl
        ## See https://docs.gdc.cancer.gov/API/Users_Guide/Search_and_Retrieval/#cases-endpoint
        ## and
        ## https://docs.gdc.cancer.gov/API/Users_Guide/Search_and_Retrieval/#expand
        ## and
        ## https://docs.gdc.cancer.gov/API/Users_Guide/Appendix_A_Available_Fields/#cases-field-groups
        ## curl.call <- paste('curl "https://gdc-api.nci.nih.gov/legacy/cases/', this.case.id, '?expand=demographic,diagnoses,diagnoses.treatments,exposures,family_histories,project,project.program,summary,tissue_source_site&pretty=true" > ', jsonfilename, sep="")
        curl.call <- paste('curl "https://gdc-api.nci.nih.gov/legacy/cases/', this.case.id, '?expand=demographic,diagnoses,diagnoses.treatments,exposures,family_histories,project,project.program,samples,summary,tissue_source_site&pretty=true" > ', jsonfilename, sep="")
        curl.out <- system(command = curl.call, wait = TRUE)
        ## example for files
        ## curl "https://gdc-api.nci.nih.gov/legacy/files/6818b91b-a181-4345-9938-b75b43ba6c2e?expand=cases.demographic,cases.diagnoses,cases.diagnoses.treatments,cases.exposures,cases.family_histories,cases.files,cases.project,cases.project.program,cases.samples,cases.summary,cases.tissue_source_site&pretty=true"        
        cmd = paste("python3", file.path(wdir, "convertjsontocsv.py"), "--caseid", this.case.id, "--sampleid", this.sample.id, "--datadir", datadir, sep=" ")
        system(command = cmd, wait = T)
        all.json.files <- append(all.json.files, jsonfilename)
        all.csv.files <- append(all.csv.files, outfilename)

}



try1 <- read.table(file.path(mydir, "api/fileinfo/tempout.csv"), sep =",", fill=TRUE, colClasses="character", stringsAsFactors=FALSE, header=TRUE)
