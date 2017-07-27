# makebothpathsandmetadata.R
# kind of supersedes makepaths.R and getMetadata.R

# can just run the whole file each time you want to update the files

###################################################################
###################################################################
## first make csv file
###################################################################
###################################################################

max.iterations.meta <- 10000
## time to wait between calls to api, so
##  don't lose access; limit is 1000 in 5 minutes
## http://docs.cancergenomicscloud.org/v1.0/docs/the-cgc-api#section-rate-limits
wait.n.seconds <- 0.5

mydir <- "/my/dir"
setwd(file.path(mydir,"sbdata"))

nicedate<- tolower(format(Sys.time(),"%b%d"))

outcsv <- paste0(file.path(mydir,"fileinfo"),"/report.paths.",nicedate,".csv")
# next one does NOT have NAs, and does not have full paths to dir
outcsv.with.keys <- file.path(mydir,"sbdata/report.paths.with.keys.csv")
# next one has NAs
#  also allows you to keep track of changes by keeping the dates
outcsv.with.dirnames <- paste0(file.path(mydir,"fileinfo"),"/report.paths.with.directory.names.",nicedate,".csv")

#
dirs.one.level <- list.dirs(recursive=FALSE, full.names=FALSE)

# alldirs is all directories 2 levels deep, which is what we care about
alldirs.short.path <- vector("character", length=0)
alldirs.base.dir <- vector("character", length=0)
for (ttdir in dirs.one.level){
    alldirs.short.path <- append(alldirs.short.path, list.dirs(ttdir, recursive=FALSE))
    alldirs.base.dir <- append(alldirs.base.dir, list.dirs(ttdir, recursive=FALSE, full.names=FALSE))
}

n.dirs <- length(alldirs.short.path)

# then make alldirs have fullpath
alldirs <- file.path(rep(x=getwd(),n.dirs),alldirs.short.path) 

write.table(t(c("circ.junc.path","linear.junc.path","appended.report.path","knife.report")), file = outcsv, row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE)

write.table(t(c("circ.junc.path","linear.junc.path","appended.report.path","knife.report" , "base.directory")), file = outcsv.with.keys, row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE)

write.table(t(c("circ.junc.path","linear.junc.path","appended.report.path","knife.report", "directory.full.path","base.directory")), file = outcsv.with.dirnames, row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE)

ttcounter <- 0

for (tti in 1:n.dirs){
    allfiles.thisdir.recursive <- dir(path=alldirs[tti],recursive=TRUE)
    circ.junc.path <- file.path(alldirs[tti],allfiles.thisdir.recursive[grep(pattern="(glmReports/.*circJuncProbs.txt_cdf|glmReports/.*circJuncProbs.txt)$", x=allfiles.thisdir.recursive)])
    linear.junc.path <- file.path(alldirs[tti],allfiles.thisdir.recursive[grep(pattern="(glmReports/.*linearJuncProbs.txt|glmReports/.*linearJuncProbs.txt_cdf)$", x=allfiles.thisdir.recursive)])
    appended.report.path <- file.path(alldirs[tti],allfiles.thisdir.recursive[grep(pattern="reports/AppendedReports/.*naive_report_Appended.txt$", x=allfiles.thisdir.recursive)])
    knife.text.report.path <- file.path(alldirs[tti],allfiles.thisdir.recursive[grep(pattern=".*val_1_report.txt$", x=allfiles.thisdir.recursive)])
    {
        if (length(knife.text.report.path)>1){
            stop(paste("ERROR with knife text files for directory", alldirs[tti], " multiple matching files found, namely\n", paste(knife.text.report.path, collapse=",")))
        }
        else if (length(knife.text.report.path)==0){
            knife.text.report.path <- NA
        }
    }
    {
    if ((length(circ.junc.path)==1) & (length(linear.junc.path)==1) & (length(appended.report.path)==1)){
        write.table(t(c(circ.junc.path,linear.junc.path,appended.report.path,knife.text.report.path)), file = outcsv, row.names = FALSE, col.names = FALSE, sep = ",", append=TRUE)
        write.table(t(c(circ.junc.path,linear.junc.path,appended.report.path, knife.text.report.path, alldirs.base.dir[tti])), file = outcsv.with.keys, row.names = FALSE, col.names = FALSE, sep = ",", append=TRUE)
        write.table(t(c(circ.junc.path,linear.junc.path,appended.report.path, knife.text.report.path, alldirs[tti],alldirs.base.dir[tti])), file = outcsv.with.dirnames, row.names = FALSE, col.names = FALSE, sep = ",", append=TRUE)
        ttcounter <- ttcounter + 1
    }
    else {
        if (length(circ.junc.path)==0){
            circ.junc.path <- NA
        }
        if (length(linear.junc.path)==0){
            linear.junc.path <- NA
        }
        if (length(appended.report.path)==0){
            appended.report.path <- NA
        }
        write.table(t(c(circ.junc.path,linear.junc.path,appended.report.path, alldirs[tti],alldirs.base.dir[tti])), file = outcsv.with.dirnames, row.names = FALSE, col.names = FALSE, sep = ",", append=TRUE)
    }
    }
}

cat("\nNumber of files in report.paths.*csv: ", ttcounter, "\n")
# 209 on aug 6

###################################################################
###################################################################
## Now get metadata
###################################################################
###################################################################


home.home <- FALSE

# home directory

{
if (home.home){ 
    homedir = file.path(mydir, "api")
    temprdatadir = file.path(mydir, "api/rdatatempfiles")
}
else {
    homedir = file.path(mydir, "api")
    temprdatadir = file.path(mydir, "api/rdatatempfiles")
}
}

source(file.path(homedir,"apidefs.R"))

out.files.list <- list.all.files.project(projname="JSALZMAN/machete", ttwdir=wdir, tempdir=tempdir, auth.token=auth.token, max.iterations=max.iterations.meta)
allfilenames <- out.files.list$filenames 
allfileids <- out.files.list$fileids


# select out files from TCGA
# first get all things we expect for TCGA files
## adding in fastq's for bodymap in dec 2016

first.screen.indices <- union(union(union(  union(grep(pattern = "^TCGA.*_rnaseq_fastq\\.tar$", x = allfilenames),grep(pattern = "^UNCID.*\\.tar\\.gz$", x = allfilenames))  ,grep(pattern = "^G.*\\.tar\\.gz$", x = allfilenames))   ,grep(pattern = "^_1_G.*\\.tar\\.gz$", x = allfilenames)) ,grep(pattern="^ERR030.*1\\.fastq$", x=allfilenames))

# remove things with knife or out in the name
knife.indices <- grep(pattern="(knife|out)", x=allfilenames)

second.screen.indices <- setdiff(first.screen.indices, knife.indices)
second.screen.filenames <- allfilenames[second.screen.indices]
second.screen.ids <- allfileids[second.screen.indices]

# authorization object
ttaa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")
mm <- ttaa$project(id = "JSALZMAN/machete")

# Weirdly, if there is no data, e.g. for tti=422 (G17196),
#  there is no field. So have to clean this up to give NA value to
#  any value that is not there.
clean.metadata <- function(metalist){
    expected.fields <- c("age_at_diagnosis", "days_to_death", "case_id", "experimental_strategy", "disease_type", "aliquot_uuid", "vital_status", "gender", "aliquot_id", "data_subtype", "sample_uuid", "platform", "investigation", "case_uuid", "race", "data_format", "data_type", "ethnicity", "sample_type", "primary_site", "sample_id")
    n.exp.fields <- length(expected.fields)
    out.clean.metadata <- vector("list", length=0)
    for (ttii in 1:n.exp.fields){
        eval(parse(text=paste0("is.it.null <- is.null(metalist$", expected.fields[ttii], ")") ))
        {
            if (!is.it.null){ 
                eval(parse(text=paste0("out.clean.metadata$", expected.fields[ttii], " <- metalist$", expected.fields[ttii] )))
            }
            else {
                eval(parse(text=paste0("out.clean.metadata$", expected.fields[ttii], " <- NA" ) ))
            }
        } # end if/else
    }
    out.clean.metadata
}


# now get metadata, loop over files

# write header
# nicedate<- tolower(format(Sys.time(),"%b%d"))
metadata.filename <- file.path(wdir,paste0("metadata.csv"))

expected.fields <- c("age_at_diagnosis", "days_to_death", "case_id", "experimental_strategy", "disease_type", "aliquot_uuid", "vital_status", "gender", "aliquot_id", "data_subtype", "sample_uuid", "platform", "investigation", "case_uuid", "race", "data_format", "data_type", "ethnicity", "sample_type", "primary_site", "sample_id")

ffile1 <- mm$file(id = second.screen.ids[1])
write.table(t(c("nicename",expected.fields)), file = metadata.filename, row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE)
## OLD: (and wrong)
## write.table(t(c("nicename",names(ffile1$metadata))), file = metadata.filename, row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE)

n.ids <- length(second.screen.ids)
for (tti in 1:n.ids){
    if (tti %% 10==0){
        cat(tti," ")
    }
    ffile <- mm$file(id = second.screen.ids[tti])
    niceish.name <- gsub(pattern="*1\\.fastq$", replacement="", x=gsub(pattern="\\.tar\\.gz", replacement="", x =gsub(pattern="(_|-)", replacement="", x=gsub(pattern="_rnaseq_fastq.tar", replacement="", x=ffile$name))))
    # Weirdly, if there is no data, e.g. for tti=422 (G17196),
    #  there is no field. So have to clean this up to give it NA value.
    metadata.after.cleaning <- clean.metadata(ffile$metadata)
    write.table(t(c(niceish.name,as.character(metadata.after.cleaning))), file = metadata.filename, row.names = FALSE, col.names = FALSE, sep = ",", append=TRUE)
    Sys.sleep(wait.n.seconds)
}


# 514 ids on jul 28
# 571 on aug 6


###################################################################
###################################################################
## read in and cross-reference them
## can use this without doing the above
## as it just reads in files
###################################################################
###################################################################

home.home <- FALSE

# home directory

{
if (home.home){ 
    homedir = file.path(mydir, "api")
    wdir = file.path(homedir, "fileinfo")
    infodir = file.path(homedir, "fileinfo")
    temprdatadir = file.path(mydir, "api/rdatatempfiles")
    outcsv.with.keys <- file.path(wdir, "report.paths.with.keys.csv")
}
else {
    homedir = file.path(mydir, "api")
    wdir = file.path(homedir, "fileinfo")
    infodir = file.path(homedir, "fileinfo")
    temprdatadir = file.path(mydir, "api/rdatatempfiles")
    outcsv.with.keys <- file.path(wdir, "report.paths.with.keys.csv")
}
}

source(file.path(homedir,"apidefs.R"))

metadata.filename <- file.path(wdir,paste0("metadata.csv"))

if (home.home){
    metadata.filename <- file.path(infodir,paste0("metadata.csv"))
}

meta <- read.csv(metadata.filename, header=TRUE, sep=",", stringsAsFactors = FALSE)



paths.with.keys <- read.csv(outcsv.with.keys, header=TRUE, sep=",", stringsAsFactors = FALSE)

paths.with.meta <- merge(x=paths.with.keys, y=meta, by.x = "base.directory", by.y="nicename")

## write paths.with.meta file
## next one has meta data also; added this in oct 2016
outcsv.with.meta <- file.path(infodir, "report.paths.with.meta.csv")

write.table(paths.with.meta, file = outcsv.with.meta, row.names = FALSE, col.names = names(paths.with.meta), sep = ",", append=FALSE)






# aug 5:
## dim(paths.with.meta)
## [1] 190  25
## > dim(paths.with.keys)
## [1] 192   4


## metatwolines <- scan(metadata.filename, sep="\n", nmax = 2, what="character")



## dim(paths.with.meta); dim(paths.with.keys); dim(meta)
# aug 8:
# 216 25,  218 4, 581 22





## table(paths.with.meta$disease_type)






## table(paths.with.meta$disease_type, paths.with.meta$sample_type)

## aug 8
  ##                                   Primary Blood Derived Cancer - Peripheral Blood
  ## Acute Myeloid Leukemia                                                         12
  ## Breast Invasive Carcinoma                                                       0
  ## Colon Adenocarcinoma                                                            0
  ## Glioblastoma Multiforme                                                         0
  ## Lung Adenocarcinoma                                                             0
  ## Ovarian Serous Cystadenocarcinoma                                               0
  ## Pancreatic Adenocarcinoma                                                       0
  ## Prostate Adenocarcinoma                                                         0
                                   
  ##                                   Primary Tumor Recurrent Tumor
  ## Acute Myeloid Leukemia                        0               0
  ## Breast Invasive Carcinoma                    12               0
  ## Colon Adenocarcinoma                         11               0
  ## Glioblastoma Multiforme                      40               0
  ## Lung Adenocarcinoma                          18               0
  ## Ovarian Serous Cystadenocarcinoma            45               2
  ## Pancreatic Adenocarcinoma                    36               0
  ## Prostate Adenocarcinoma                      15               0
                                   
  ##                                   Solid Tissue Normal
  ## Acute Myeloid Leukemia                              0
  ## Breast Invasive Carcinoma                           9
  ## Colon Adenocarcinoma                                0
  ## Glioblastoma Multiforme                             0
  ## Lung Adenocarcinoma                                10
  ## Ovarian Serous Cystadenocarcinoma                   0
  ## Pancreatic Adenocarcinoma                           1
  ## Prostate Adenocarcinoma                             5

## ttext = paths.with.keys[1,1]
get.groupdir <- function(ttext){
    tsplit = strsplit(x=ttext, split="/")
    tsplit[[1]][7]
}

matchedgroupdirs <- sapply(X= paths.with.meta$circ.junc.path, FUN = get.groupdir)
names(matchedgroupdirs) <- NULL
table(paths.with.meta$disease_type, paths.with.meta$sample_type)
table(matchedgroupdirs)
table(paths.with.meta$disease_type[paths.with.meta$sample_type %in% c("Primary Tumor", "Recurrent Tumor", "Primary Blood Derived Cancer - Peripheral Blood")])
sum(!is.na(paths.with.meta$knife.report))
table(paths.with.meta$investigation)
dim(paths.with.meta); dim(paths.with.keys); dim(meta)

## To write non-normals to files:
## y <- unique(cbind(tolower(gsub("TCGA-", replacement="", x=paths.with.meta$investigation)), paths.with.meta$disease_type)); z <- y[order(y[,2]),]; x <- table(paths.with.meta$disease_type[paths.with.meta$sample_type %in% c("Primary Tumor", "Recurrent Tumor", "Primary Blood Derived Cancer - Peripheral Blood")]); disease.types <- names(x); frequencies <- as.integer(x); investigation.types <- z[,1]; write.table(x= data.frame(investigation.types, disease.types, frequencies), file = file.path(homedir, paste0("counts.of.nonnormals.completed.by.disease.type.", nicedate ,".csv")), col.names=FALSE, row.names=FALSE, sep=",")


