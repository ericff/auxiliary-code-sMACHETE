home.home <- TRUE

library(sevenbridges)

{
if (home.home){ 
    homedir = "/my/dir/api/fileinfo"
    temprdatadir = "/my/dir/api/rdatatempfiles"
    tempdir = "/my/dir/api/tempfiles"
    fileinfodir = "/my/dir/api/fileinfo"
}
else {
    homedir = "/my/dir/api/fileinfo"
    temprdatadir = "/my/dir/api/rdatatempfiles"
    tempdir = "/my/dir/api/tempfiles"
    fileinfodir = "/my/dir/api/fileinfo"
}
}

setwd(homedir)

source(file.path(homedir, "setdefs.R"))

####################################################
# run above lines, then go to relevant lines below
####################################################
##
## Note that in some cases, e.g. GBM,
## the bv files have names just like the tar files
## in other cases, this is not true
## e.g. for AML






######################################################
## gbm 
## Check in datasetapi.R for todaydate value to use

todaydate <- "sep5"
shortname <- "gbm"
outcsv <- paste0(shortname, todaydate, "query.tumor.csv")
projname <- "ericfg/bloomtree-gbm"

all.tumors.df <- read.table(file=file.path(homedir, outcsv), header=TRUE, sep =",", stringsAsFactors=FALSE) 
dim(all.tumors.df)
# 157 3
length(unique(all.tumors.df$ids.cases))
# 155
unique.tumors.df <- choose.one.file.for.each.case(all.tumors.df)
n.total.cases <- length(unique.tumors.df$ids.cases)
n.total.cases
unique.tumors.gbm.file <- file.path(homedir, "unique.tumors.gbm.csv")
write.table(unique.tumors.df, file=unique.tumors.gbm.file, col.names = FALSE, row.names = FALSE, sep=",", append = FALSE)
# Check that all of these are contained in cases used by bloom tree; might have to fix if not

# First get names of all files in bloom folder


out.files.list <- list.all.files.project(projname=projname, ttwdir=wdir, tempdir=tempdir, auth.token=auth.token, max.iterations=max.iterations)
allfilenames <- out.files.list$filenames 
allfileids <- out.files.list$fileids

# Is there anything in unique tumors that is NOT in the gbm file?
# Next thing should be empty. I.e. there should NOT be anything.
setdiff(unique.tumors.df[,2], allfilenames)
## character(0)

# Now, what is in project ending in .tar.gz ?

alltargzfiles.in.project <- allfilenames[grep(pattern = ".tar.gz$", x =allfilenames)]
print(length(alltargzfiles.in.project))
# 157

targz.filenames.to.not.use <- gsub(pattern = ".tar.gz", replacement = "",  x = setdiff(alltargzfiles.in.project, unique.tumors.df[,2]))
## "G17191.TCGA-06-0211-01A-01R-1849-01.2.tar.gz"
## "G17201.TCGA-06-0156-01A-02R-1849-01.2.tar.gz"

files.not.to.use <- file.path(homedir, paste0("files.not.to.use.", shortname, ".csv"))

writeLines(targz.filenames.to.not.use, con = files.not.to.use, sep = "\n")





######################################################
## aml
## Check in datasetapi.R for todaydate value to use

todaydate <- "aug31"
shortname <- "aml"
outcsv <- paste0(shortname, todaydate, "query.tumor.csv")
projname <- "ericfg/bloomtree-aml"

all.tumors.df <- read.table(file=file.path(homedir, outcsv), header=TRUE, sep =",", stringsAsFactors=FALSE) 
dim(all.tumors.df)
# 179 3
length(unique(all.tumors.df$ids.cases))
# 178
unique.tumors.df <- choose.one.file.for.each.case(all.tumors.df)
n.total.cases <- length(unique.tumors.df$ids.cases)
n.total.cases
unique.tumors.file <- file.path(homedir, paste0("unique.tumors.", shortname, ".csv"))
write.table(unique.tumors.df, file=unique.tumors.file, col.names = FALSE, row.names = FALSE, sep=",", append = FALSE)
# Check that all of these are contained in cases used by bloom tree,
#  might have to fix if not

# First get names of all files in bloom folder

out.files.list <- list.all.files.project(projname=projname, ttwdir=wdir, tempdir=tempdir, auth.token=auth.token, max.iterations=max.iterations)
allfilenames <- out.files.list$filenames 
allfileids <- out.files.list$fileids

# Is there anything in unique tumors that is NOT also in the project?
# Next thing should be empty. I.e. there should NOT be anything.
setdiff(unique.tumors.df[,2], allfilenames)
## character(0)

# Now, what is in project ending in .tar.gz ?

alltarfiles.in.project <- allfilenames[grep(pattern = "(.tar.gz|fastq.tar)$", x =allfilenames)]
print(length(alltarfiles.in.project))
# 179

## This is a basic check, but one should do more manually:
if (length(alltarfiles.in.project)< n.total.cases){
    stop("\n\n\n\nERROR: PROBLEM, check this out. Maybe different file suffixes need to be examined???\n\n\n\n")
}


tar.filenames.to.not.use <- gsub(pattern = "(.tar.gz|fastq.tar)$", replacement = "",  x = setdiff(alltarfiles.in.project, unique.tumors.df[,2]))

## NEED TO DO THIS MANUALLY for AML b/c the un-tarred files have
## different names:

## # authorization object
## ttaa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")
## mm <- ttaa$project(id = "ericfg/bloomtree-aml")

## bvfiles <- allfilenames[grep(pattern = ".bv$", x=allfilenames)]
## bvfile.ids <- allfileids[grep(pattern = ".bv$", x=allfilenames)]

## # Weirdly, if there is no data, e.g. for tti=422 (G17196),
## #  there is no field. So have to clean this up to give NA value to
## #  any value that is not there.

## clean.metadata <- function(metalist){
##     expected.fields <- c("age_at_diagnosis", "days_to_death", "case_id", "experimental_strategy", "disease_type", "aliquot_uuid", "vital_status", "gender", "aliquot_id", "data_subtype", "sample_uuid", "platform", "investigation", "case_uuid", "race", "data_format", "data_type", "ethnicity", "sample_type", "primary_site", "sample_id")
##     n.exp.fields <- length(expected.fields)
##     out.clean.metadata <- vector("list", length=0)
##     for (ttii in 1:n.exp.fields){
##         eval(parse(text=paste0("is.it.null <- is.null(metalist$", expected.fields[ttii], ")") ))
##         {
##             if (!is.it.null){ 
##                 eval(parse(text=paste0("out.clean.metadata$", expected.fields[ttii], " <- metalist$", expected.fields[ttii] )))
##             }
##             else {
##                 eval(parse(text=paste0("out.clean.metadata$", expected.fields[ttii], " <- NA" ) ))
##             }
##         } # end if/else
##     }
##     out.clean.metadata
## }


## # now get metadata, loop over files

## # write header
## # nicedate<- tolower(format(Sys.time(),"%b%d"))
## ## metadata.filename <- file.path(wdir,paste0("metadata.csv"))

## ## expected.fields <- c("age_at_diagnosis", "days_to_death", "case_id", "experimental_strategy", "disease_type", "aliquot_uuid", "vital_status", "gender", "aliquot_id", "data_subtype", "sample_uuid", "platform", "investigation", "case_uuid", "race", "data_format", "data_type", "ethnicity", "sample_type", "primary_site", "sample_id")

## ## ffile1 <- mm$file(id = second.screen.ids[1])
## ## write.table(t(c("nicename",expected.fields)), file = metadata.filename, row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE)
## ## OLD: (and wrong)
## ## write.table(t(c("nicename",names(ffile1$metadata))), file = metadata.filename, row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE)

## amlbvlist <- list()

## n.ids <- length(bvfiles)
## for (tti in 1:n.ids){
##     if (tti %% 10==0){
##         cat(tti," ")
##     }
##     gfile <- mm$file(id=bvfile.ids[tti])
##     amlbvlist[[tti]] <- gfile$metadata
##     Sys.sleep(0.1)
## }


## amlbvcases <- vector("character", length = n.ids)
## for (tti in 1:n.ids){
##     amlbvcases[tti] <- amlbvlist[[tti]]$case_id
## }

## which(duplicated(amlbvcases))
## ## 140 180

## ## "TCGA-AB-2929-03A

## allfilenames[c(140,180)]
## which(amlbvcases %in% amlbvcases[c(140,180)])
## ## which(amlbvcases %in% amlbvcases[c(140,180)])
## ## [1] 112 126 140 180

## bvfiles[c(112, 126, 140, 180)]
## ## [1] "703RKAAXX_1_1.concatenated.bf.bv"    "7043VAAXX_1_1.concatenated.bf.bv"   
## ## [3] "703RKAAXX_2_1.concatenated.bf.bv"    "_1_7043VAAXX_1_1.concatenated.bf.bv"

## bvfile.ids[c(112, 126, 140, 180)]
## ## [1] "57d9f9fce4b0b39158aab547" "57d9ffdde4b0b39158aadb89"
## ## [3] "57da01fde4b0b39158aae3aa" "57d9ffe3e4b0b39158aadba1"


## amlbvcases[c(112, 126, 140, 180)]
## [1] "TCGA-AB-2929" "TCGA-AB-2956" "TCGA-AB-2929" "TCGA-AB-2956"


## 11 of 18:
## 2929 here:
## https://cgc.sbgenomics.com/u/ericfg/bloomtree-aml/tasks/6dbd832f-ee5f-4516-a6bd-29ff11a7b11c/#
## 18 of 18
## _1_TCGA-AB-2929-03A-01T-0735-13_rnaseq_fastq.tar
## 7009AAAXX_8_1.concatenated.bf.bv


## so files to not use:
##     remove this one, it seems like just a copy was made
##     somewhere along the way, both are from aml 14 of 18:
##     _1_7043VAAXX_1_1.concatenated.bf.bv
## also don't use
##    703RKAAXX_2_1.concatenated.bf.bv
## it's from
## _1_TCGA-AB-2929-03A-01T-0735-13_rnaseq_fastq.tar
## in task 18 of 18
## not sure why name of bv file isn't the same though


bv.filenames.to.not.use <- c("_1_7043VAAXX_1_1.concatenated.bf.bv", "703RKAAXX_2_1.concatenated.bf.bv")

files.not.to.use <- file.path(homedir, paste0("files.not.to.use.", shortname, ".csv"))

writeLines(bv.filenames.to.not.use, con = files.not.to.use, sep = "\n")





######################################################
## cervical
## Check in datasetapi.R for todaydate value to use

todaydate <- "sep9"
shortname <- "cervical"
outcsv <- paste0(shortname, todaydate, "query.tumor.csv")
projname <- "elehnert/sequence-bloomtree-cesc-largescale"

all.tumors.df <- read.table(file=file.path(homedir, outcsv), header=TRUE, sep =",", stringsAsFactors=FALSE) 
dim(all.tumors.df)
# 304 3
length(unique(all.tumors.df$ids.cases))
# 304


# First get names of all files in _machete_ project
## THIS TAKES A LONG TIME ABOUT 5 TO 10 MINS
out.files.list <- list.all.files.project(projname="JSALZMAN/machete", ttwdir=wdir, tempdir=tempdir, auth.token=auth.token, max.iterations=max.iterations)
allfilenames <- out.files.list$filenames 
allfileids <- out.files.list$fileids

filename.mostrecent = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.most.recent.csv"))

unique.tumors.df <- choose.one.file.for.each.case.using.the.choice.already.made.when.choosing.for.machete.runs(df.query=all.tumors.df, allfilenames=allfilenames, filename.mostrecent=filename.mostrecent)
## unique.tumors.df <- choose.one.file.for.each.case(all.tumors.df)

n.total.cases <- length(unique.tumors.df$ids.cases)
n.total.cases
unique.tumors.file <- file.path(homedir, paste0("unique.tumors.", shortname, ".csv"))
write.table(unique.tumors.df, file=unique.tumors.file, col.names = FALSE, row.names = FALSE, sep=",", append = FALSE)
# Check that all of these are contained in cases used by bloom tree,
#  might have to fix if not:
# First need to get names of all files in _bloomtree_ project:
out.files.list.bloom <- list.all.files.project(projname=projname, ttwdir=wdir, tempdir=tempdir, auth.token=auth.token, max.iterations=max.iterations)
allfilenames.bloom <- out.files.list.bloom$filenames 
allfileids.bloom <- out.files.list.bloom$fileids


## Is there anything in unique tumors that is NOT also in the
## _bloomtree_ project?
## Next thing should be empty. I.e. there should NOT be anything.
setdiff(unique.tumors.df[,2], allfilenames.bloom)
## character(0)

# Now, what is in bloomtree project ending in .tar.gz ?
alltarfiles.in.project <- allfilenames.bloom[grep(pattern = "(.tar.gz|fastq.tar)$", x =allfilenames.bloom)]
print(length(alltarfiles.in.project))
# 309

## This is a basic check, but one should do more manually:
if (length(alltarfiles.in.project)< n.total.cases){
    stop("\n\n\n\nERROR: PROBLEM, check this out. Maybe different file suffixes need to be examined???\n\n\n\n")
}


tar.filenames.to.not.use <- gsub(pattern = "(.tar.gz|fastq.tar)$", replacement = "",  x = setdiff(alltarfiles.in.project, unique.tumors.df[,2]))



## NEED TO GET THE bv filenames from these filenames; use the sample ids

file.ids.tar.filenames.to.not.use.in.allfilenames.bloom <- allfileids.bloom[which(allfilenames.bloom %in% tar.filenames.to.not.use)]

bvfile.names <- allfilenames.bloom[grep(pattern = ".bv$", x=allfilenames.bloom)]
bvfile.ids <- allfileids.bloom[grep(pattern = ".bv$", x=allfilenames.bloom)]


aa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")
## mm for project, which was in past typically machete
mm <- aa$project(id=projname)

## this is really rerunning the getbvinfo stuff, but ok fine:
bvfile.sample.ids <- vector("integer", length=length(bvfile.names))
for (bvii in 1:length(bvfile.names)){
    if (bvii %% 10 ==0){
        cat(bvii, "\t")
    }
    ffile <- mm$file(id = bvfile.ids[bvii])
    bvfile.sample.ids[bvii] <- ffile$metadata$sample_id
}

bv.filenames.to.not.use <- vector("character", length = length(file.ids.tar.filenames.to.not.use.in.allfilenames.bloom))
for (tti in 1:length(file.ids.tar.filenames.to.not.use.in.allfilenames.bloom)){
    if (tti %% 10 ==0){
        cat(tti, "\t")
    }
    ffile <- mm$file(id = file.ids.tar.filenames.to.not.use.in.allfilenames.bloom[tti])
    this.sample.id <- ffile$metadata$sample_id
    this.bv.index <- which(bvfile.sample.ids == this.sample.id)
    stopifnot(length(this.bv.index)==1)
    bv.filenames.to.not.use[tti] <- bvfile.names[this.bv.index]
}










files.not.to.use <- file.path(homedir, paste0("files.not.to.use.", shortname, ".csv"))

writeLines(tar.filenames.to.not.use, con = files.not.to.use, sep = "\n")



















## unique.tumors.df <- choose.one.file.for.each.case(all.tumors.df)
## n.total.cases <- length(unique.tumors.df$ids.cases)
## n.total.cases
## unique.tumors.file <- file.path(homedir, paste0("unique.tumors.", shortname, ".csv"))
## write.table(unique.tumors.df, file=unique.tumors.file, col.names = FALSE, row.names = FALSE, sep=",", append = FALSE)
## # Check that all of these are contained in cases used by bloom tree,
## #  might have to fix if not

## # First get names of all files in bloom folder

## out.files.list <- list.all.files.project(projname=projname, ttwdir=wdir, tempdir=tempdir, auth.token=auth.token, max.iterations=max.iterations)
## allfilenames <- out.files.list$filenames 
## allfileids <- out.files.list$fileids

## # Is there anything in unique tumors that is NOT also in the project?
## # Next thing should be empty. I.e. there should NOT be anything.
## setdiff(unique.tumors.df[,2], allfilenames)
## ## character(0)

## # Now, what is in project ending in .tar.gz ?

## alltarfiles.in.project <- allfilenames[grep(pattern = "(.tar.gz|fastq.tar)$", x =allfilenames)]
## print(length(alltarfiles.in.project))
## # 309

## ## This is a basic check, but one should do more manually:
## if (length(alltarfiles.in.project)< n.total.cases){
##     stop("\n\n\n\nERROR: PROBLEM, check this out. Maybe different file suffixes need to be examined???\n\n\n\n")
## }


## tar.filenames.to.not.use <- gsub(pattern = "(.tar.gz|fastq.tar)$", replacement = "",  x = setdiff(alltarfiles.in.project, unique.tumors.df[,2]))


## files.not.to.use <- file.path(homedir, paste0("files.not.to.use.", shortname, ".csv"))

## writeLines(tar.filenames.to.not.use, con = files.not.to.use, sep = "\n")











######################################################
## prad prostate
## Check in datasetapi.R for todaydate value to use
## This is for the case that you've already gotten info
## on all of the files, and you can get it from a saved
## csv file.
##
## NOTE MISTAKE, WHICH WAS CORRECTED, SEE BELOW, SEARCH FOR JAN 17 2017

todaydate <- "nov1"
shortname <- "pros"
outcsv <- paste0(shortname, todaydate, "query.tumor.csv")
projname <- "elehnert/sequence-bloomtree-prad-largescale"

# READ in results from previous 
all.tumors.df <- read.table(file=file.path(homedir, outcsv), header=TRUE, sep =",", stringsAsFactors=FALSE) 
dim(all.tumors.df)
# 505 3
length(unique(all.tumors.df$ids.cases))
# 497

# First get names of all files in _machete_ project
## THIS TAKES A LONG TIME ABOUT 5 TO 10 MINS
out.files.list <- list.all.files.project(projname="JSALZMAN/machete", ttwdir=wdir, tempdir=tempdir, auth.token=auth.token, max.iterations=max.iterations)
allfilenames <- out.files.list$filenames 
allfileids <- out.files.list$fileids

filename.mostrecent = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.most.recent.csv"))

## 
unique.tumors.df <- choose.one.file.for.each.case.using.the.choice.already.made.when.choosing.for.machete.runs(df.query=all.tumors.df, allfilenames=allfilenames, filename.mostrecent=filename.mostrecent)
## unique.tumors.df <- choose.one.file.for.each.case(all.tumors.df)
n.total.cases <- length(unique.tumors.df$ids.cases)
n.total.cases
### NOTE THAT I NEEDED TO FIX THIS, ON JAN 17 2017
### I made a mistake in here when I manually tried to exclude 3
### files from a list of 64 so that they wouldn't be in the list
### of 61 files to not use. Those were actually the ones that should
### have been excluded from the 497 and thus still in the 61. So I got
### mixed up. See get.metadata.for.files.used.in.SBTs.R also for details.
### So I save the original file as
###
old.unique.tumors.file <- file.path(homedir, paste0("old.with.3.mistakes.unique.tumors.", shortname, ".csv"))

unique.tumors.file <- file.path(homedir, paste0("unique.tumors.", shortname, ".csv"))
write.table(unique.tumors.df, file=unique.tumors.file, col.names = FALSE, row.names = FALSE, sep=",", append = FALSE)
# Check that all of these are contained in cases used by bloom tree,
#  might have to fix if not


## 

# Now get names of all files in _bloomtree_ project:
out.files.list.bloom <- list.all.files.project(projname=projname, ttwdir=wdir, tempdir=tempdir, auth.token=auth.token, max.iterations=max.iterations)
allfilenames.bloom <- out.files.list.bloom$filenames 
allfileids.bloom <- out.files.list.bloom$fileids


## Is there anything in unique tumors that is NOT also in the
## _bloomtree_ project?
## Next thing should be empty. I.e. there should NOT be anything.
setdiff(unique.tumors.df[,2], allfilenames.bloom)
## character(0)

# Now, what is in bloomtree project ending in .tar.gz ?
alltarfiles.in.project <- allfilenames.bloom[grep(pattern = "(.tar.gz|fastq.tar)$", x =allfilenames.bloom)]
print(length(alltarfiles.in.project))
# 558

## This is a basic check, but one should do more manually:
if (length(alltarfiles.in.project)< n.total.cases){
    stop("\n\n\n\nERROR: PROBLEM, check this out. Maybe different file suffixes need to be examined???\n\n\n\n")
}


## tar.filenames.to.not.use <- gsub(pattern = "(.tar.gz|fastq.tar)$", replacement = "",  x = setdiff(alltarfiles.in.project, unique.tumors.df[,2]))
tar.filenames.to.not.use <- setdiff(alltarfiles.in.project, unique.tumors.df[,2])

## NEED TO GET THE bv filenames from these filenames; use the sample ids

indices.filenames.to.not.use.in.allfilenames.bloom <- which(allfilenames.bloom %in% tar.filenames.to.not.use)

file.ids.tar.filenames.to.not.use.in.allfilenames.bloom <- allfileids.bloom[indices.filenames.to.not.use.in.allfilenames.bloom]
file.names.tar.filenames.to.not.use.in.allfilenames.bloom <- allfilenames.bloom[indices.filenames.to.not.use.in.allfilenames.bloom]

bvfile.names <- allfilenames.bloom[grep(pattern = ".bv$", x=allfilenames.bloom)]
bvfile.ids <- allfileids.bloom[grep(pattern = ".bv$", x=allfilenames.bloom)]


aa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")
## mm for project, which was in past typically machete
mm <- aa$project(id=projname)

## this is really rerunning the getbvinfo stuff, but ok fine:
bvfile.sample.ids <- vector("integer", length=length(bvfile.names))
for (bvii in 1:length(bvfile.names)){
    if (bvii %% 10 ==0){
        cat(bvii, "\t")
    }
    ffile <- mm$file(id = bvfile.ids[bvii])
    bvfile.sample.ids[bvii] <- ffile$metadata$sample_id
}

metadata.tar.filenames.to.not.use.in.allfilenames.bloom <- list()
sample.uuid.tar.filenames.to.not.use.in.allfilenames.bloom <- vector("character", length=length(file.ids.tar.filenames.to.not.use.in.allfilenames.bloom))
for (tti in 1:length(file.ids.tar.filenames.to.not.use.in.allfilenames.bloom)){
    if (tti %% 10 ==0){
        cat(tti, "\t")
    }
    ffile <- mm$file(id = file.ids.tar.filenames.to.not.use.in.allfilenames.bloom[tti])
    metadata.tar.filenames.to.not.use.in.allfilenames.bloom[[tti]] <- ffile$metadata
    sample.uuid.tar.filenames.to.not.use.in.allfilenames.bloom[tti] <- ffile$metadata$sample_uuid
}



bv.filenames.to.not.use <- vector("character", length = length(file.ids.tar.filenames.to.not.use.in.allfilenames.bloom))
bv.extra.filenames <- vector("character", length=0)
for (tti in 1:length(file.ids.tar.filenames.to.not.use.in.allfilenames.bloom)){
    if (tti %% 10 ==0){
        cat(tti, "\t")
    }
    this.sample.id <- metadata.tar.filenames.to.not.use.in.allfilenames.bloom[[tti]]$sample_id
    this.sample.uuid <- metadata.tar.filenames.to.not.use.in.allfilenames.bloom[[tti]]$sample_uuid
    this.bv.index <- which(bvfile.sample.ids == this.sample.id)
    if (length(this.bv.index)>=2){
        cat("tti is ", tti, "\n")
        bv.filenames.to.not.use[tti] <- bvfile.names[this.bv.index[1]]
        bv.extra.filenames <- c(bv.extra.filenames, bvfile.names[this.bv.index[-1]])
        cat("length(this.bv.index) is ", length(this.bv.index), "\n")
        cat("sample id is: ", this.sample.id, "\n")
        cat("sample uuid is: ", this.sample.uuid, "\n")
        tarfile.indices <- which(sample.uuid.tar.filenames.to.not.use.in.allfilenames.bloom==this.sample.uuid)
        cat("tar file names are:\n", paste(file.names.tar.filenames.to.not.use.in.allfilenames.bloom[tarfile.indices], collapse ="\n"),"\n")
                                
    }
    else {
        stopifnot(length(this.bv.index)==1)
        bv.filenames.to.not.use[tti] <- bvfile.names[this.bv.index]
    }
}

## Append the weird ones on to the end, and do unique
## for first pass, then need to remove three manually:
## bv.filenames.to.not.use <- c(bv.filenames.to.not.use, bv.extra.filenames)

bv.filenames.first.pass <- unique(c(bv.filenames.to.not.use, bv.extra.filenames))
length(bv.filenames.first.pass)
## 64

## But then need to take out any bv filenames that are actually
## associated with tar files that are in the 497 tarfiles
## Look for possibilities, then add manually
## No other way to link tarfiles to the bv files that come from them

bloom.ids.unique.tumors <- allfileids.bloom[which(allfilenames.bloom %in% unique.tumors.df[,2])]
bloom.names.unique.tumors <- allfilenames.bloom[which(allfilenames.bloom %in% unique.tumors.df[,2])]

sample.id.tar.filenames.to.yes.use.in.allfilenames.bloom <- vector("character", length=dim(unique.tumors.df)[1])
for (tti in 1:dim(unique.tumors.df)[1]){
    if (tti %% 10 ==0){
        cat(tti, "\t")
    }
    ffile <- mm$file(id = bloom.ids.unique.tumors[tti])
    sample.id.tar.filenames.to.yes.use.in.allfilenames.bloom[tti] <- ffile$metadata$sample_id
}

## 
indices.bv.filenames.to.not.use.within.bvfile.names <- which(bvfile.names %in% bv.filenames.to.not.use)
sample.ids.bv.filenames.to.not.use <- bvfile.sample.ids[indices.bv.filenames.to.not.use.within.bvfile.names]
bv.filenames.to.not.use.in.particular.order <- bvfile.names[indices.bv.filenames.to.not.use.within.bvfile.names]

indices.to.examine <- which(sample.ids.bv.filenames.to.not.use %in% sample.id.tar.filenames.to.yes.use.in.allfilenames.bloom)
bv.files.to.examine <- bv.filenames.to.not.use.in.particular.order[indices.to.examine]
sample.ids.to.examine <- sample.ids.bv.filenames.to.not.use[indices.to.examine]
tarfiles.that.are.included.to.examine <- bloom.names.unique.tumors[which(sample.id.tar.filenames.to.yes.use.in.allfilenames.bloom %in% sample.ids.to.examine)]



## bv.files.to.examine
## [1] "120710_UNC12-SN629_0215_BC0WRNACXX_TGACCA_L005_1_concatenated.bf.bv"
## [2] "120710_UNC12-SN629_0215_BC0WRNACXX_TGACCA_L006_1_concatenated.bf.bv"
## [3] "120710_UNC16-SN851_0169_AC0VVKACXX_TGACCA_L001_1_concatenated.bf.bv"
## sample.ids.to.examine
## [1] "TCGA-HC-7740-01B" "TCGA-HC-8258-01B" "TCGA-HC-8261-01B"
## tarfiles.that.are.included.to.examine
## [1] "UNCID_2355579.3476ee8f-8cbe-4c6e-a3f7-f53facfe585a.121011_UNC15-SN850_0238_AD13P9ACXX_8_CAGATC.tar.gz"
## [2] "UNCID_2355692.783062c7-cf22-426d-8cd1-52ecdd28b43d.120710_UNC16-SN851_0169_AC0VVKACXX_4_CAGATC.tar.gz"
## [3] "UNCID_2355581.b7f3a96d-01f8-4ef2-a71d-2c684bd18812.121011_UNC15-SN850_0238_AD13P9ACXX_7_CAGATC.tar.gz"


## unique.tumors.df[(sample.id.tar.filenames.to.yes.use.in.allfilenames.bloom =="TCGA-HC-7740-01B"),2]

## manually looking at these:
## [1] "120710_UNC12-SN629_0215_BC0WRNACXX_TGACCA_L005_1_concatenated.bf.bv"
## targz's with this sample id:
## UNCID_2355699.b7f3a96d-01f8-4ef2-a71d-2c684bd18812.120710_UNC12-SN629_0215_BC0WRNACXX_5_TGACCA.tar.gz
## UNCID_2355581.b7f3a96d-01f8-4ef2-a71d-2c684bd18812.121011_UNC15-SN850_0238_AD13P9ACXX_7_CAGATC.tar.gz
## compare with the task that produced the bv file, see which one (or both?) is in there:
## both are in there
## So need to run unpacking task
## SBG Unpack FASTQs run to find out names of unpacked files from UNCID_2355699.b7f3a96d-01f8-4ef2-a71d-2c684bd18812.120710_UNC12-SN629_0215_BC0WRNACXX_5_TGACCA.tar.gz; metadata not enough- 11-23-16 18:47:44
## https://cgc.sbgenomics.com/u/elehnert/sequence-bloomtree-prad-largescale/tasks/1bf5713e-9db6-49e2-befd-291e599ddae3/#
## one output of above task is:
## 120710_UNC12-SN629_0215_BC0WRNACXX_TGACCA_L005_1.fastq
## Note: this is actually in the name of the file (almost)
## didn't notice this until afterward!
##
## also doublecheck: SBG Unpack FASTQs run to find out names of unpacked files from UNCID_2355581.b7f3a96d-01f8-4ef2-a71d-2c684bd18812.121011_UNC15-SN850_0238_AD13P9ACXX_7_CAGATC.tar.gz 11-23-16
## one output of above task:
## 121011_UNC15-SN850_0238_AD13P9ACXX_NoIndex_L007_1.fastq
##
## tarfiles.that.are.included.to.examine
## [3] "UNCID_2355581.b7f3a96d-01f8-4ef2-a71d-2c684bd18812.121011_UNC15-SN850_0238_AD13P9ACXX_7_CAGATC.tar.gz"
## 3rd one goes with sample id TCGA-HC-7740-01B
## that tar file goes with
## 121011_UNC15-SN850_0238_AD13P9ACXX_NoIndex_L007_1.fastq
## other bv file is
## 120710_UNC12-SN629_0215_BC0WRNACXX_TGACCA_L005_1.fastq
## so that is the one to remove

bv.filenames.pass.2 <-bv.filenames.first.pass[- grep(pattern = "^120710_UNC12-SN629_0215_BC0WRNACXX_TGACCA_L005_1", x = bv.filenames.first.pass)]




## [2] "120710_UNC12-SN629_0215_BC0WRNACXX_TGACCA_L006_1_concatenated.bf.bv"
## targz's with this sample id, TCGA-HC-8258-01B
## UNCID_2355696.783062c7-cf22-426d-8cd1-52ecdd28b4....120710_UNC12-SN629_02
## UNCID_2355692.783062c7-cf22-426d-8cd1-52ecdd28b4....120710_UNC16-SN851_0169_AC0VVKACXX_4_CAGATC.tar.gz
## compare with the task that produced the bv file, see which one (or both?) is in there:
## both are in there
## So need to run unpacking task
## SBG Unpack FASTQs run to find out names of unpacked files from UNCID_2355692.783062c7-cf22-426d-8cd1-52ecdd28b4....120710_UNC16-SN851_0169_AC0VVKACXX_4_CAGATC.tar.gz 11-23-16
## one output is
## 	120710_UNC16-SN851_0169_AC0VVKACXX_CAGATC_L004_1.fastq

##
## tarfiles.that.are.included.to.examine
## [2] "UNCID_2355692.783062c7-cf22-426d-8cd1-52ecdd28b43d.120710_UNC16-SN851_0169_AC0VVKACXX_4_CAGATC.tar.gz"
## this has 120710_UNC16-SN851_0169_AC0VVKACXX_CAGATC_L004_1.fastq
## so want to remove other bv file, which is (by searching sample ids
##  on SB)
## 120710_UNC12-SN629_0215_BC0WRNACXX_TGACCA_L006_1_concatenated.bf.bv
##

bv.filenames.pass.3 <-bv.filenames.pass.2[- grep(pattern = "^120710_UNC12-SN629_0215_BC0WRNACXX_TGACCA_L006_1", x = bv.filenames.pass.2)]
length(bv.filenames.pass.3)
## 62


## [3] "120710_UNC16-SN851_0169_AC0VVKACXX_TGACCA_L001_1_concatenated.bf.bv"
## targz's with this sample id, TCGA-HC-8261-01B
## UNCID_2355694.3476ee8f-8cbe-4c6e-a3f7-f53facfe58....120710_UNC16-SN851_0169_AC0VVKACXX_1_TGACCA.tar.gz
## UNCID_2355579.3476ee8f-8cbe-4c6e-a3f7-f53facfe58....121011_UNC15-SN850_0238_AD1
## compare with the task that produced the bv file, see which one (or both?) is in there:
## both are in there 
## So need to run unpacking task
## SBG Unpack FASTQs run to find out names of unpacked files from UNCID_2355694.3476ee8f-8cbe-4c6e-a3f7-f53facfe58....120710_UNC16-SN851_0169_AC0VVKACXX_1_TGACCA.tar.gz 11:23-16
## https://cgc.sbgenomics.com/u/elehnert/sequence-bloomtree-prad-largescale/tasks/df02a853-2672-4419-a67f-170d93d04bc7/#
## one output is
## 120710_UNC16-SN851_0169_AC0VVKACXX_TGACCA_L001_1.fastq


##
## tarfiles.that.are.included.to.examine
## [1] "UNCID_2355579.3476ee8f-8cbe-4c6e-a3f7-f53facfe585a.121011_UNC15-SN850_0238_AD13P9ACXX_8_CAGATC.tar.gz"
## this does NOT have
## 120710_UNC16-SN851_0169_AC0VVKACXX_TGACCA_L001_1.fastq
##
## so we want to remove that one
##

bv.filenames.final <-bv.filenames.pass.3[- grep(pattern = "^120710_UNC16-SN851_0169_AC0VVKACXX_TGACCA_L001_1", x = bv.filenames.pass.3)]
length(bv.filenames.final)
## 61, as expected



## OLD, NOT RIGHT: Then need to do unique, because there could have been duplicates!!

## OLD, NOT RIGHT: bv.filenames.to.not.use <- unique(x=bv.filenames.to.not.use)

## OLD, NOT RIGHT: print(length(bv.filenames.to.not.use))
## OLD, NOT RIGHT: 64


## problem with tti = 47
## UNCID_2355694.3476ee8f-8cbe-4c6e-a3f7-f53facfe58....120710_UNC16-SN851_0169_AC0VVKACXX_1_TGACCA.tar.gz
## PRAD
## 	RNA-Seq 	Aug. 23, 2016 12:09	TAR.GZ 	5.1 GB	TCGA-HC-8261-01B
## 	TCGAUNCID_2355579.3476ee8f-8cbe-4c6e-a3f7-f53facfe58....121011_UNC15-SN850_0238_AD13P9ACXX_8_CAGATC.tar.gz
## PRAD
## 	RNA-Seq 	Aug. 23, 2016 12:09	TAR.GZ 	13.2 GB	TCGA-HC-8261-01B
## 	121011_UNC15-SN850_0238_AD13P9ACXX_NoIndex_L008_1_concatenated.bf.bv
## RNA-Seq
## Aug. 23, 2016 17:08	BV 	476.8 MB	TCGA-HC-8261-01B
## 	120710_UNC16-SN851_0169_AC0VVKACXX_TGACCA_L001_1_concatenated.bf.bv


## bv.filenames.to.not.use <- vector("character", length = length(file.ids.tar.filenames.to.not.use.in.allfilenames.bloom))
## bv.extra.filenames <- vector("character", length=0)
## for (tti in 1:length(file.ids.tar.filenames.to.not.use.in.allfilenames.bloom)){
##     if (tti %% 10 ==0){
##         cat(tti, "\t")
##     }
##     ffile <- mm$file(id = file.ids.tar.filenames.to.not.use.in.allfilenames.bloom[tti])
##     this.sample.id <- ffile$metadata$sample_id
##     this.bv.index <- which(bvfile.sample.ids == this.sample.id)
##     if (this.sample.id %in% c("TCGA-HC-8261-01B","TCGA-HC-8265-01B")){
##         bv.filenames.to.not.use[tti] <- bvfile.names[this.bv.index[1]]
##         bv.extra.filenames <- c(bv.extra.filenames, bvfile.names[this.bv.index[1]])
##     }
##     else {
##         stopifnot(length(this.bv.index)==1)
##         bv.filenames.to.not.use[tti] <- bvfile.names[this.bv.index]
##     }
## }





files.not.to.use <- file.path(homedir, paste0("files.not.to.use.", shortname, ".csv"))

writeLines(bv.filenames.final, con = files.not.to.use, sep = "\n")


###############################################################
###############################################################
## Pancreatic
## uses 188 files in build, 10 are duplicates
## LATER I BUILT A TREE WITH JUST 178 FILES
## AFTER REALIZING THAT I ACCIDENTALLY WASN'T USING 
##  THE FILES.NOT.TO.USE FILE FOR PANCREATIC
## SEE BELOW
##
###############################################################
###############################################################

## reusing code from below that I already used:
all.fullprojnames <- c(paste0("ericfg/",c("bloomtree-gbm", "bloomtree-pancreatic", "bloomtree-aml", "bloomtree-ovarian", "bloomtree-br")), "elehnert/sequence-bloomtree-cesc-largescale", "elehnert/sequence-bloomtree-prad-largescale", "ericfg/bloomtreelung")

cancer.type.keys <- c("gbm", "pancreatic", "aml", "ovarian", "breast", "cesc", "prostate", "lung")

nicedates <- c("oct29", "oct29", "oct29", "oct29", "nov04", "oct29", "oct29", "nov15")

ii.type <- 2
bv.filename <- file.path(fileinfodir, paste0("bv.", cancer.type.keys[ii.type], ".files.info.", nicedates[ii.type], ".csv"))
bvdf <- read.table(bv.filename, header=TRUE, stringsAsFactors=FALSE, sep=",")
cat("Cancer type is ", cancer.type.keys[ii.type], "\n")
cat("Dimension of bv data frame is ", paste(dim(bvdf), collapse = " "), "\n")
cat("Number of (unique) bv.file.names is ", length(unique(bvdf$bv.file.name)), "\n")
cat("Number of (unique) sample id's associated with bv.file.names is ", length(unique(bvdf$sample.id)), "\n")
cat("Duplicates:\n")
cat(paste(bvdf$bv.file.name[bvdf$sample.id %in% bvdf$sample.id[duplicated(bvdf$sample.id)]], collapse = "\n"),"\n\n")

## these are 10 duplicates
## 121126_UNC9-SN296_0314_BC11Y0ACXX_CTTGTA_L008_1.concatenated.bf.bv
## 120820_UNC15-SN850_0229_AD13JBACXX_TAGCTT_L003_1.concatenated.bf.bv
## 120820_UNC15-SN850_0229_AD13JBACXX_GATCAG_L007_1.concatenated.bf.bv
## 130319_UNC12-SN629_0267_BC22Y1ACXX_ACAGTG_L002_1.concatenated.bf.bv
## 120820_UNC15-SN850_0229_AD13JBACXX_TAGCTT_L007_1.concatenated.bf.bv
## 130325_UNC16-SN851_0231_BC20VNACXX_CAGATC_L003_1.concatenated.bf.bv
## 130319_UNC12-SN629_0267_BC22Y1ACXX_ACTTGA_L008_1.concatenated.bf.bv
## 130325_UNC16-SN851_0231_BC20VNACXX_CAGATC_L001_1.concatenated.bf.bv
## 120820_UNC15-SN850_0229_AD13JBACXX_GATCAG_L004_1.concatenated.bf.bv
## 120730_UNC14-SN744_0252_BC0VLGACXX_ATCACG_L008_1.concatenated.bf.bv
## _1_130325_UNC16-SN851_0231_BC20VNACXX_CAGATC_L001_1.concatenated.bf.bv
## _1_121126_UNC9-SN296_0314_BC11Y0ACXX_CTTGTA_L008_1.concatenated.bf.bv
## _1_120820_UNC15-SN850_0229_AD13JBACXX_GATCAG_L007_1.concatenated.bf.bv
## _1_120820_UNC15-SN850_0229_AD13JBACXX_TAGCTT_L003_1.concatenated.bf.bv
## _1_130319_UNC12-SN629_0267_BC22Y1ACXX_ACAGTG_L002_1.concatenated.bf.bv
## _1_130325_UNC16-SN851_0231_BC20VNACXX_CAGATC_L003_1.concatenated.bf.bv
## _1_130319_UNC12-SN629_0267_BC22Y1ACXX_ACTTGA_L008_1.concatenated.bf.bv
## _1_120820_UNC15-SN850_0229_AD13JBACXX_TAGCTT_L007_1.concatenated.bf.bv
## _1_120730_UNC14-SN744_0252_BC0VLGACXX_ATCACG_L008_1.concatenated.bf.bv
## _1_120820_UNC15-SN850_0229_AD13JBACXX_GATCAG_L004_1.concatenated.bf.bv 

## So get files starting in _1 and ending in .bv, and check
##  that there are only 10 of them
print.nice.ids.vector(bvdf$bv.file.name[grep(pattern = "^_1_.*bv$", x =bvdf$bv.file.name)])

panc.bv.files.to.not.use.vec <- c("_1_130325_UNC16-SN851_0231_BC20VNACXX_CAGATC_L001_1.concatenated.bf.bv", "_1_121126_UNC9-SN296_0314_BC11Y0ACXX_CTTGTA_L008_1.concatenated.bf.bv", "_1_120820_UNC15-SN850_0229_AD13JBACXX_GATCAG_L007_1.concatenated.bf.bv", "_1_120820_UNC15-SN850_0229_AD13JBACXX_TAGCTT_L003_1.concatenated.bf.bv", "_1_130319_UNC12-SN629_0267_BC22Y1ACXX_ACAGTG_L002_1.concatenated.bf.bv", "_1_130325_UNC16-SN851_0231_BC20VNACXX_CAGATC_L003_1.concatenated.bf.bv", "_1_130319_UNC12-SN629_0267_BC22Y1ACXX_ACTTGA_L008_1.concatenated.bf.bv", "_1_120820_UNC15-SN850_0229_AD13JBACXX_TAGCTT_L007_1.concatenated.bf.bv", "_1_120730_UNC14-SN744_0252_BC0VLGACXX_ATCACG_L008_1.concatenated.bf.bv", "_1_120820_UNC15-SN850_0229_AD13JBACXX_GATCAG_L004_1.concatenated.bf.bv")

shortname <- "pancreatic"
files.not.to.use <- file.path(homedir, paste0("files.not.to.use.", shortname, ".csv"))

writeLines(panc.bv.files.to.not.use.vec, con = files.not.to.use, sep = "\n")


###############################################################
### for each project, check if there is an instance with
###   a sample id which has more than one bv file
###   attached to it
###  This could cause an issue with the way I determine
###  the files.to.not.use  files unless I take care.
### An example of this happens in PRAD
### also should check in the bloomtreemany project
###  after restricting to each type, do that separately
###
###############################################################

n.types <- 8

all.fullprojnames <- c(paste0("ericfg/",c("bloomtree-gbm", "bloomtree-pancreatic", "bloomtree-aml", "bloomtree-ovarian", "bloomtree-br")), "elehnert/sequence-bloomtree-cesc-largescale", "elehnert/sequence-bloomtree-prad-largescale", "ericfg/bloomtreelung")

cancer.type.keys <- c("gbm", "pancreatic", "aml", "ovarian", "breast", "cesc", "prostate", "lung")

nicedates <- c("oct29", "oct29", "oct29", "oct29", "nov04", "oct29", "oct29", "nov15")

## cancer.types <- c("Acute Myeloid Leukemia", "Bladder Urothelial Carcinoma", "Brain Lower Grade Glioma", "Breast Invasive Carcinoma", "Cervical Squamous Cell Carcinoma and Endocervical Adenocarcinoma", "Colon Adenocarcinoma", "Esophageal Carcinoma", "Glioblastoma Multiforme", "Head and Neck Squamous Cell Carcinoma", "Kidney Chromophobe", "Kidney Renal Clear Cell Carcinoma", "Kidney Renal Papillary Cell Carcinoma", "Liver Hepatocellular Carcinoma", "Lung Adenocarcinoma", "Lung Squamous Cell Carcinoma", "Lymphoid Neoplasm Diffuse Large B-cell Lymphoma", "Ovarian Serous Cystadenocarcinoma", "Pancreatic Adenocarcinoma", "Prostate Adenocarcinoma", "Sarcoma", "Skin Cutaneous Melanoma", "Stomach Adenocarcinoma")
## cancer.type.keys <- c("aml", "bladder", "glioma", "breast", "cesc", "colon", "esophagus", "gbm", "headneck", "kidneychromophobe", "krcc", "kirp", "liver", "lung", "lungcell", "lymphoma", "ovarian", "pancreatic", "prostate", "sarcoma", "skin", "stomach")



for (ii.type in 1:n.types){
    bv.filename <- file.path(fileinfodir, paste0("bv.", cancer.type.keys[ii.type], ".files.info.", nicedates[ii.type], ".csv"))
    bvdf <- read.table(bv.filename, header=TRUE, stringsAsFactors=FALSE, sep=",")
    cat("Cancer type is ", cancer.type.keys[ii.type], "\n")
    cat("Dimension of bv data frame is ", paste(dim(bvdf), collapse = " "), "\n")
    cat("Number of (unique) bv.file.names is ", length(unique(bvdf$bv.file.name)), "\n")
    cat("Number of (unique) sample id's associated with bv.file.names is ", length(unique(bvdf$sample.id)), "\n")
    cat("Duplicates:\n")
    cat(paste(bvdf$bv.file.name[bvdf$sample.id %in% bvdf$sample.id[duplicated(bvdf$sample.id)]], collapse = "\n"),"\n\n")
}













aa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")

out.files.list.bloom <- list.all.files.project(projname=projname, ttwdir=wdir, tempdir=tempdir, auth.token=auth.token, max.iterations=max.iterations)
allfilenames.bloom <- out.files.list.bloom$filenames 
allfileids.bloom <- out.files.list.bloom$fileids



bvfile.names <- allfilenames.bloom[grep(pattern = ".bv$", x=allfilenames.bloom)]
bvfile.ids <- allfileids.bloom[grep(pattern = ".bv$", x=allfilenames.bloom)]


## mm for project, which was in past typically machete
mm <- aa$project(id=projname)

## this is really rerunning the getbvinfo stuff, but ok fine:
bvfile.sample.ids <- vector("integer", length=length(bvfile.names))
for (bvii in 1:length(bvfile.names)){
    if (bvii %% 10 ==0){
        cat(bvii, "\t")
    }
    ffile <- mm$file(id = bvfile.ids[bvii])
    bvfile.sample.ids[bvii] <- ffile$metadata$sample_id
}


###################################################################
###################################################################
## PANCREATIC
## CHECKING that i have the right 178 files for the new build
## 
## I BUILT A TREE WITH JUST 178 FILES
## AFTER REALIZING THAT I ACCIDENTALLY WASN'T USING 
##  THE FILES.NOT.TO.USE FILE FOR PANCREATIC
###################################################################
###################################################################


panc.bv.info.from.sb.task.info.raw <- read.table(file=file.path(fileinfo, "paad.build.jan26.178.files.txt"), header=F, sep="\t")


cancer.type.keys <- c("gbm", "pancreatic", "aml", "ovarian", "breast", "cesc", "prostate", "lung")

nicedates <- c("oct29", "oct29", "oct29", "oct29", "nov04", "oct29", "oct29", "nov15")

ii.type <- 2
bv.filename <- file.path(fileinfodir, paste0("bv.", cancer.type.keys[ii.type], ".files.info.", nicedates[ii.type], ".csv"))
bvdf <- read.table(bv.filename, header=TRUE, stringsAsFactors=FALSE, sep=",")

bvnames.178 <- as.character(panc.bv.info.from.sb.task.info.raw$V1)
bvnames.188 <- bvdf$bv.file.name

panc.duplicates <- setdiff(bvnames.188, bvnames.178)
##  [1] "_1_130325_UNC16-SN851_0231_BC20VNACXX_CAGATC_L001_1.concatenated.bf.bv"
##  [2] "_1_121126_UNC9-SN296_0314_BC11Y0ACXX_CTTGTA_L008_1.concatenated.bf.bv" 
##  [3] "_1_120820_UNC15-SN850_0229_AD13JBACXX_GATCAG_L007_1.concatenated.bf.bv"
##  [4] "_1_120820_UNC15-SN850_0229_AD13JBACXX_TAGCTT_L003_1.concatenated.bf.bv"
##  [5] "_1_130319_UNC12-SN629_0267_BC22Y1ACXX_ACAGTG_L002_1.concatenated.bf.bv"
##  [6] "_1_130325_UNC16-SN851_0231_BC20VNACXX_CAGATC_L003_1.concatenated.bf.bv"
##  [7] "_1_130319_UNC12-SN629_0267_BC22Y1ACXX_ACTTGA_L008_1.concatenated.bf.bv"
##  [8] "_1_120820_UNC15-SN850_0229_AD13JBACXX_TAGCTT_L007_1.concatenated.bf.bv"
##  [9] "_1_120730_UNC14-SN744_0252_BC0VLGACXX_ATCACG_L008_1.concatenated.bf.bv"
## [10] "_1_120820_UNC15-SN850_0229_AD13JBACXX_GATCAG_L004_1.concatenated.bf.bv"

indices.panc.duplicates.in.bvdf <- which(bvdf$bv.file.name %in% panc.duplicates)
bv.178.only <- bvdf[-indices.panc.duplicates.in.bvdf,]
## check again:
identical(sort(bv.178.only$bv.file.name), sort(bvnames.178))
duplicated(bv.178.only$bv.file.name)
## TRUE

new.bv.filename <- file.path(fileinfodir, paste0("bv.", cancer.type.keys[ii.type], ".files.info.jan28.2017.csv"))
write.table(x=bv.178.only, file= new.bv.filename, sep=",", col.names = T, row.names=F)







