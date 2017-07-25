## get info for files used to build SBTs for table for paper

## Used to make these:
## (Descriptions below are slightly different from current tables, as of
##  July 2017)
## Supplemental Table 1: Sample IDs and Metadata for Samples Used to Build SBTs, and Used in Queries, for the 10 Cancer Types
## Note that for 5 cancers (AML, CESC, OV, PAAD, PRAD), SBTs were built with additional files that were not used in the queries; this does not affect any results, but see Methods for details. This list does NOT include those additional files. See Supplemental Table 2.

## Supplemental Table 2: Sample IDs and Metadata for Additional Samples Used to Build SBTs for 5 Cancer Types but NOT Used in Queries
## Note that for 5 cancers (AML, CESC, OV, PAAD, PRAD), SBTs were built with additional files that were not used in the queries; this does not affect any results, but see Methods for details. See Supplemental Table 1 for a list of files used in the Queries.


## First have to use a few different ways to get file IDs

## for some, can use bloomwork/bloomfiles.info files
## produced by bloomdata.R
## can do that for br, lung
## note that we produced these files for sarc, but then
##  actually used the bloomtreemany project to do sarc
##
## for some, can use bloomwork/bloomtreemany.tarfile.ids
## produced by bloomdata.R
## for colon, sarc, gbm

##
## for others, will have to get IDs another way
## put these into projects manually
## then will have to note file IDs which were removed
## for aml, cesc, ov, paad, prad, 
## NOTE: in the end, we used gbm in the bloomtreemany
##    project, not in the bloomtree-gbm project

## don't need to do for bodymap- the same 16 files are used for SBTs



home.home <- TRUE

mydir<-"/my/dir"
{
if (home.home){ 
    homedir = file.path(mydir,"api/fileinfo")
    temprdatadir = file.path(mydir,"api/rdatatempfiles")
    tempdir = file.path(mydir,"api/tempfiles")
    gldir = mydir
}
else {
    homedir = file.path(mydir,"api/fileinfo")
    temprdatadir = file.path(mydir,"api/rdatatempfiles")
    tempdir = file.path(mydir,"api/tempfiles")
    gldir = mydir
}
}


bloomdir = file.path(gldir, "bloom")
bloomworkdir = file.path(bloomdir, "bloomwork")

setwd(homedir)

library(sevenbridges)

source(file.path(homedir, "setdefs.R"))



# Weirdly, if there is no data,
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





## Make list of vectors of file ids
## and list of projects corresponding to those

## ASSUMES that there are 10 cancer types to use

short.names <- c("br", "lung", "colon", "sarcoma", "gbm", "aml", "cesc", "ov", "paad", "prad")
n.types <- length(short.names)
list.file.ids <- vector("list", n.types)
list.project.names <- c(paste0("ericfg/",c("bloomtree-br", "bloomtreelung", "bloomtreemany", "bloomtreemany", "bloomtreemany", "bloomtree-aml")),"elehnert/sequence-bloomtree-cesc-largescale", "ericfg/bloomtree-ovarian", "ericfg/bloomtree-pancreatic", "elehnert/sequence-bloomtree-prad-largescale")

## Check:
## cbind(short.names, list.project.names)

## ii =1,2:
list.file.ids[[1]] <- readLines(con=file.path(bloomworkdir,"bloomfilesinfo.br.oct15.nice.ids.csv"))
list.file.ids[[2]] <- readLines(con=file.path(bloomworkdir,"bloomfilesinfo.lung.oct21.nice.ids.csv"))

## ii = 3,4,5:
for (ii in 3:5){
    nice.ids.file = file.path(bloomworkdir,paste0("bloomtreemany.tarfile.ids.", short.names[ii], ".csv"))
    list.file.ids[[ii]] <- readLines(con=nice.ids.file)
}


## Now do the ones where we have to get info from the projects



######################################################
## AML
##  Below is modified from determine.bloom.files.not.to.use.R
######################################################


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
unique.tumors.df <- read.table(file=unique.tumors.file, header=FALSE, sep=",", stringsAsFactors = FALSE)
# Check that all of these are contained in cases used by bloom tree,
#  might have to fix if not

# First get names of all files in project

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

## this is just a start, I had to figure it out manually before
tar.filenames.to.not.use <- gsub(pattern = "(.tar.gz|fastq.tar)$", replacement = "",  x = setdiff(alltarfiles.in.project, unique.tumors.df[,2]))

## tar.filenames.to.not.use
## [1] "_1_TCGA-AB-2929-03A-01T-0735-13_rnaseq_"

ids.alltarfiles.in.project <- allfileids[grep(pattern = "(.tar.gz|fastq.tar)$", x =allfilenames)]
ids.badtarfile <- allfileids[grep(pattern= tar.filenames.to.not.use, x=allfilenames)]

ids.nice.tarfiles <- setdiff(ids.alltarfiles.in.project, ids.badtarfile)

ids.file <- file.path(bloomworkdir, paste0("bloomfilesinfo.", shortname, ".nice.ids.csv"))

writeLines(ids.nice.tarfiles, con = ids.file, sep = "\n")

## now write two files
## one with sample id, tarfile name, and bv file name- for internal
##   memory
## other with same but without bv file name

sample.ids.extras <- c("TCGA-AB-2956-03A","TCGA-AB-2929-03A ")
tarfilenames.extras <- c("TCGA-AB-2956-03A-01T-0740-13_rnaseq_fastq.tar","_1_TCGA-AB-2929-03A-01T-0735-13_rnaseq_fastq.tar")
bv.extras <- c("_1_7043VAAXX_1_1.concatenated.bf.bv","703RKAAXX_2_1.concatenated.bf.bv")
df.extras <- data.frame(Sample.Id=sample.ids.extras, Tarfile.Name=tarfilenames.extras, bvfile.name=bv.extras, stringsAsFactors = FALSE)
df.extras.for.table= df.extras[,1:2]

extras.file.with.bv.file <- file.path(bloomworkdir, paste0("bloomfiles.extra.files.info.with.bv.file.info.", shortname, ".csv"))
extras.file <- file.path(bloomworkdir, paste0("bloomfiles.extra.files.info.", shortname, ".csv"))

write.table(df.extras, file=extras.file.with.bv.file, append = F, sep=",", row.names = F, col.names = T)

write.table(t(c("Sample ID", "Archive File Name")), file=extras.file, append = F, sep=",", row.names = F, col.names = F)
write.table(df.extras.for.table, file=extras.file, append = T, sep=",", row.names = F, col.names = F)


## so files to not use:
##     remove this one, it seems like just a copy was made
##     somewhere along the way, both are from aml 14 of 18:
##     _1_7043VAAXX_1_1.concatenated.bf.bv
##     it comes from sample TCGA-AB-2956-03A
## also don't use
##    703RKAAXX_2_1.concatenated.bf.bv
## it's from
## _1_TCGA-AB-2929-03A-01T-0735-13_rnaseq_fastq.tar
## in task 18 of 18
## not sure why name of bv file isn't the same though



#################################################################
## get meta data for all "good" tar files

alltarfiles.in.project <- allfilenames[grep(pattern = "(.tar.gz|fastq.tar)$", x =allfilenames)]
ids.alltarfiles.in.project <- allfileids[grep(pattern = "(.tar.gz|fastq.tar)$", x =allfilenames)]
print(length(alltarfiles.in.project))
print(length(ids.alltarfiles.in.project))
## 179

print(length(ids.nice.tarfiles))
## 178

## Now use api to get info for these files from their IDs

aa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")
## mm for project, which was in past typically machete
mm <- aa$project(id=projname)


expected.fields <- c("age_at_diagnosis", "days_to_death", "case_id", "experimental_strategy", "disease_type", "aliquot_uuid", "vital_status", "gender", "aliquot_id", "data_subtype", "sample_uuid", "platform", "investigation", "case_uuid", "race", "data_format", "data_type", "ethnicity", "sample_type", "primary_site", "sample_id")

expected.fields.nice <- tools::toTitleCase(gsub(pattern="_", replacement = " ", expected.fields))


metadata.filename <- file.path(bloomworkdir,paste0("bloomfiles.metadata.", shortname, ".csv"))

write.table(t(expected.fields.nice), file = metadata.filename, row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE)

for (tti in 1:length(ids.nice.tarfiles)){
    if (tti %% 10 ==0){
        cat(tti, "\t")
    }
    ffile <- mm$file(id = ids.nice.tarfiles[tti])
    # Weirdly, if there is no data,
    #  there is no field. So have to clean this up to give it NA value.
    metadata.after.cleaning <- clean.metadata(ffile$metadata)
    write.table(t(as.character(metadata.after.cleaning)), file = metadata.filename, row.names = FALSE, col.names = FALSE, sep = ",", append=TRUE)
}


######################################################
## CESC
##  Below is modified from determine.bloom.files.not.to.use.R
######################################################


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


filename.mostrecent = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.most.recent.csv"))

n.total.cases <- length(unique.tumors.df$ids.cases)
n.total.cases
unique.tumors.file <- file.path(homedir, paste0("unique.tumors.", shortname, ".csv"))
unique.tumors.df <- read.table(file=unique.tumors.file, header=FALSE, sep=",", stringsAsFactors = FALSE)

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


tar.filenames.to.not.use <- setdiff(alltarfiles.in.project, unique.tumors.df[,2])
## tar.filenames.to.not.use <- gsub(pattern = "(.tar.gz|fastq.tar)$", replacement = "",  x = setdiff(alltarfiles.in.project, unique.tumors.df[,2]))



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
bv.sample.ids.for.files.to.not.use <- vector("character", length = length(file.ids.tar.filenames.to.not.use.in.allfilenames.bloom))
for (tti in 1:length(file.ids.tar.filenames.to.not.use.in.allfilenames.bloom)){
    if (tti %% 10 ==0){
        cat(tti, "\t")
    }
    ffile <- mm$file(id = file.ids.tar.filenames.to.not.use.in.allfilenames.bloom[tti])
    this.sample.id <- ffile$metadata$sample_id
    bv.sample.ids.for.files.to.not.use[tti] <- this.sample.id
    this.bv.index <- which(bvfile.sample.ids == this.sample.id)
    stopifnot(length(this.bv.index)==1)
    bv.filenames.to.not.use[tti] <- bvfile.names[this.bv.index]
}






## now write two files
## one with sample id, tarfile name, and bv file name- for internal
##   memory
## other with same but without bv file name

sample.ids.extras <- bv.sample.ids.for.files.to.not.use
tarfilenames.extras <- tar.filenames.to.not.use
bv.extras <- bv.filenames.to.not.use
df.extras <- data.frame(Sample.Id=sample.ids.extras, Tarfile.Name=tarfilenames.extras, bvfile.name=bv.extras, stringsAsFactors = FALSE)
df.extras.for.table= df.extras[,1:2]

extras.file.with.bv.file <- file.path(bloomworkdir, paste0("bloomfiles.extra.files.info.with.bv.file.info.", shortname, ".csv"))
extras.file <- file.path(bloomworkdir, paste0("bloomfiles.extra.files.info.", shortname, ".csv"))

write.table(df.extras, file=extras.file.with.bv.file, append = F, sep=",", row.names = F, col.names = T)

write.table(t(c("Sample ID", "Archive File Name")), file=extras.file, append = F, sep=",", row.names = F, col.names = F)
write.table(df.extras.for.table, file=extras.file, append = T, sep=",", row.names = F, col.names = F)


#################################################################
## get meta data for all "good" tar files

alltarfiles.in.project <- allfilenames.bloom[grep(pattern = "(.tar.gz|fastq.tar)$", x =allfilenames.bloom)]
ids.alltarfiles.in.project <- allfileids.bloom[grep(pattern = "(.tar.gz|fastq.tar)$", x =allfilenames.bloom)]
print(length(alltarfiles.in.project))
print(length(ids.alltarfiles.in.project))
## 309

ids.nice.tarfiles <- setdiff(ids.alltarfiles.in.project, file.ids.tar.filenames.to.not.use.in.allfilenames.bloom)
print(length(ids.nice.tarfiles))
## 304

ids.file <- file.path(bloomworkdir, paste0("bloomfilesinfo.", shortname, ".nice.ids.csv"))

writeLines(ids.nice.tarfiles, con = ids.file, sep = "\n")

## Now use api to get info for these files from their IDs

aa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")
## mm for project, which was in past typically machete
mm <- aa$project(id=projname)


expected.fields <- c("age_at_diagnosis", "days_to_death", "case_id", "experimental_strategy", "disease_type", "aliquot_uuid", "vital_status", "gender", "aliquot_id", "data_subtype", "sample_uuid", "platform", "investigation", "case_uuid", "race", "data_format", "data_type", "ethnicity", "sample_type", "primary_site", "sample_id")

expected.fields.nice <- tools::toTitleCase(gsub(pattern="_", replacement = " ", expected.fields))


metadata.filename <- file.path(bloomworkdir,paste0("bloomfiles.metadata.", shortname, ".csv"))

write.table(t(expected.fields.nice), file = metadata.filename, row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE)

for (tti in 1:length(ids.nice.tarfiles)){
    if (tti %% 10 ==0){
        cat(tti, "\t")
    }
    ffile <- mm$file(id = ids.nice.tarfiles[tti])
    # Weirdly, if there is no data,
    #  there is no field. So have to clean this up to give it NA value.
    metadata.after.cleaning <- clean.metadata(ffile$metadata)
    write.table(t(as.character(metadata.after.cleaning)), file = metadata.filename, row.names = FALSE, col.names = FALSE, sep = ",", append=TRUE)
}



## 

######################################################
## ovarian
##  ovarian is explained by the 5 copies- they
##   are duplicates
######################################################


######################################################
## ovarian
## _1_C0NWYACXX_5_CACTCA_1
## _1_D0REMACXX_4_GCTCCA_1
## _1_D0ULKACXX_5_CGGAAT_1
## _1_D0W1KACXX_1_GGCCTG_1
## _1_D0WJEACXX_2_GAAACC_1

shortname <- "ovarian"
projname <- "ericfg/bloomtree-ovarian"

bv.filenames.to.not.use <- readLines(con= file.path(bloomworkdir, "ovarian.files.not.to.use.csv"))

## First need to get names of all files in _bloomtree_ project:
out.files.list.bloom <- list.all.files.project(projname=projname, ttwdir=wdir, tempdir=tempdir, auth.token=auth.token, max.iterations=max.iterations)
allfilenames.bloom <- out.files.list.bloom$filenames 
allfileids.bloom <- out.files.list.bloom$fileids

ids.bv.filenames.to.not.use <-vector("character",length(bv.filenames.to.not.use))
full.names.bv.filenames.to.not.use <-vector("character",length(bv.filenames.to.not.use))

## YOU HAVE TO INSPECT NEXT THING MANUALLY, IT'S NOT ROBUST
for (tti in 1:length(bv.filenames.to.not.use)){
    ids.bv.filenames.to.not.use[tti] <- allfileids.bloom[(grep(pattern= bv.filenames.to.not.use[tti], x = allfilenames.bloom))]
    full.names.bv.filenames.to.not.use[tti] <- allfilenames.bloom[(grep(pattern= bv.filenames.to.not.use[tti], x = allfilenames.bloom))]
}
cbind(bv.filenames.to.not.use, full.names.bv.filenames.to.not.use)

bv.sample.ids.for.files.to.not.use <- vector("character", length = length(ids.bv.filenames.to.not.use))
for (tti in 1:length(ids.bv.filenames.to.not.use)){
    if (tti %% 10 ==0){
        cat(tti, "\t")
    }
    ffile <- mm$file(id = ids.bv.filenames.to.not.use[tti])
    this.sample.id <- ffile$metadata$sample_id
    bv.sample.ids.for.files.to.not.use[tti] <- this.sample.id
}

## this would be nice, but it doesn't seem to work:
## ffile <- mm$file(metadata = list(sample_id= "TCGA-25-1871-01A"), complete = TRUE)

## So get names of all tarfiles, and get sample IDs for them:
tarfile.indices <- grep(pattern = "(.tar.gz|fastq.tar)$", x =allfilenames.bloom)
names.alltarfiles.in.project <- allfilenames.bloom[tarfile.indices]
ids.alltarfiles.in.project <- allfileids.bloom[tarfile.indices]

sample.ids.alltarfiles.in.project <- vector("character", length(ids.alltarfiles.in.project))
for (tti in 1:length(ids.alltarfiles.in.project)){
   if (tti %% 10 ==0){
        cat(tti, "\t")
    }
    ffile <- mm$file(id = ids.alltarfiles.in.project[tti])
    this.sample.id <- ffile$metadata$sample_id
    sample.ids.alltarfiles.in.project[tti] <- this.sample.id
}


tarfiles.not.to.use <- vector("character", length = length(ids.bv.filenames.to.not.use))
for (tti in 1:length(ids.bv.filenames.to.not.use)){
    tarfiles.not.to.use[tti] <- names.alltarfiles.in.project[which(sample.ids.alltarfiles.in.project==bv.sample.ids.for.files.to.not.use[tti])]
}




## now write two files
## one with sample id, tarfile name, and bv file name- for internal
##   memory
## other with same but without bv file name

sample.ids.extras <- bv.sample.ids.for.files.to.not.use
tarfilenames.extras <- tarfiles.not.to.use
bv.extras <- bv.filenames.to.not.use
df.extras <- data.frame(Sample.Id=sample.ids.extras, Tarfile.Name=tarfilenames.extras, bvfile.name=bv.extras, stringsAsFactors = FALSE)
df.extras.for.table= df.extras[,1:2]

extras.file.with.bv.file <- file.path(bloomworkdir, paste0("bloomfiles.extra.files.info.with.bv.file.info.", shortname, ".csv"))
extras.file <- file.path(bloomworkdir, paste0("bloomfiles.extra.files.info.", shortname, ".csv"))

write.table(df.extras, file=extras.file.with.bv.file, append = F, sep=",", row.names = F, col.names = T)

write.table(t(c("Sample ID", "Archive File Name")), file=extras.file, append = F, sep=",", row.names = F, col.names = F)
write.table(df.extras.for.table, file=extras.file, append = T, sep=",", row.names = F, col.names = F)


#################################################################
## get meta data for all "good" tar files

length(ids.alltarfiles.in.project)
## 422
## so this is everything for ovarian
    
ids.file <- file.path(bloomworkdir, paste0("bloomfilesinfo.", shortname, ".nice.ids.csv"))

writeLines(ids.alltarfiles.in.project, con = ids.file, sep = "\n")

## Now use api to get info for these files from their IDs

aa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")
## mm for project, which was in past typically machete
mm <- aa$project(id=projname)


expected.fields <- c("age_at_diagnosis", "days_to_death", "case_id", "experimental_strategy", "disease_type", "aliquot_uuid", "vital_status", "gender", "aliquot_id", "data_subtype", "sample_uuid", "platform", "investigation", "case_uuid", "race", "data_format", "data_type", "ethnicity", "sample_type", "primary_site", "sample_id")

expected.fields.nice <- tools::toTitleCase(gsub(pattern="_", replacement = " ", expected.fields))


metadata.filename <- file.path(bloomworkdir,paste0("bloomfiles.metadata.", shortname, ".csv"))

write.table(t(expected.fields.nice), file = metadata.filename, row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE)

for (tti in 1:length(ids.alltarfiles.in.project)){
    if (tti %% 10 ==0){
        cat(tti, "\t")
    }
    ffile <- mm$file(id = ids.alltarfiles.in.project[tti])
    # Weirdly, if there is no data,
    #  there is no field. So have to clean this up to give it NA value.
    metadata.after.cleaning <- clean.metadata(ffile$metadata)
    write.table(t(as.character(metadata.after.cleaning)), file = metadata.filename, row.names = FALSE, col.names = FALSE, sep = ",", append=TRUE)
}






###############################################################
###############################################################
## Pancreatic
## uses 188 files in build, 10 are duplicates
##
##  Below is modified from determine.bloom.files.not.to.use.R
###############################################################
###############################################################

fileinfodir = homedir
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

panc.bv.files.to.not.use.vec <- sort(c("_1_130325_UNC16-SN851_0231_BC20VNACXX_CAGATC_L001_1.concatenated.bf.bv", "_1_121126_UNC9-SN296_0314_BC11Y0ACXX_CTTGTA_L008_1.concatenated.bf.bv", "_1_120820_UNC15-SN850_0229_AD13JBACXX_GATCAG_L007_1.concatenated.bf.bv", "_1_120820_UNC15-SN850_0229_AD13JBACXX_TAGCTT_L003_1.concatenated.bf.bv", "_1_130319_UNC12-SN629_0267_BC22Y1ACXX_ACAGTG_L002_1.concatenated.bf.bv", "_1_130325_UNC16-SN851_0231_BC20VNACXX_CAGATC_L003_1.concatenated.bf.bv", "_1_130319_UNC12-SN629_0267_BC22Y1ACXX_ACTTGA_L008_1.concatenated.bf.bv", "_1_120820_UNC15-SN850_0229_AD13JBACXX_TAGCTT_L007_1.concatenated.bf.bv", "_1_120730_UNC14-SN744_0252_BC0VLGACXX_ATCACG_L008_1.concatenated.bf.bv", "_1_120820_UNC15-SN850_0229_AD13JBACXX_GATCAG_L004_1.concatenated.bf.bv"))
length(panc.bv.files.to.not.use.vec)

shortname <- "pancreatic"
files.not.to.use <- file.path(homedir, paste0("files.not.to.use.", shortname, ".csv"))

projname <- all.fullprojnames[ii.type]

## writeLines(panc.bv.files.to.not.use.vec, con = files.not.to.use, sep = "\n")

rm(bv.filenames.to.not.use)

## not robust

bv.filenames.to.not.use.for.purpose.of.getting.sample.ids <- sort(bvdf$bv.file.name[bvdf$sample.id %in% bvdf$sample.id[duplicated(bvdf$sample.id)]][1:10])





## First need to get names of all files in _bloomtree_ project:
out.files.list.bloom <- list.all.files.project(projname=projname, ttwdir=wdir, tempdir=tempdir, auth.token=auth.token, max.iterations=max.iterations)
allfilenames.bloom <- out.files.list.bloom$filenames 
allfileids.bloom <- out.files.list.bloom$fileids

ids.bv.filenames.to.not.use <-vector("character",length(bv.filenames.to.not.use.for.purpose.of.getting.sample.ids))
check.names.bv.filenames.to.not.use <-vector("character",length(bv.filenames.to.not.use.for.purpose.of.getting.sample.ids))
## looks like these were deleted from PAAD project:
## see this to see evidence of the deletions:
## https://cgc.sbgenomics.com/u/ericfg/bloomtree-pancreatic/tasks/6d054d32-6ba0-490f-b5ef-28be2ba2ccab/

## YOU HAVE TO INSPECT NEXT THING MANUALLY, IT'S NOT ROBUST
for (tti in 1:length(bv.filenames.to.not.use.for.purpose.of.getting.sample.ids)){
    ids.bv.filenames.to.not.use[tti] <- allfileids.bloom[(grep(pattern= bv.filenames.to.not.use.for.purpose.of.getting.sample.ids[tti], x = allfilenames.bloom))]
    check.names.bv.filenames.to.not.use[tti] <- allfilenames.bloom[(grep(pattern= bv.filenames.to.not.use.for.purpose.of.getting.sample.ids[tti], x = allfilenames.bloom))]
}
cbind(bv.filenames.to.not.use.for.purpose.of.getting.sample.ids, check.names.bv.filenames.to.not.use)
which(bv.filenames.to.not.use.for.purpose.of.getting.sample.ids == check.names.bv.filenames.to.not.use)

aa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")
## mm for project, which was in past typically machete
mm <- aa$project(id=projname)


bv.sample.ids.for.files.to.not.use <- vector("character", length = length(ids.bv.filenames.to.not.use))
for (tti in 1:length(ids.bv.filenames.to.not.use)){
    if (tti %% 10 ==0){
        cat(tti, "\t")
    }
    ffile <- mm$file(id = ids.bv.filenames.to.not.use[tti])
    this.sample.id <- ffile$metadata$sample_id
    bv.sample.ids.for.files.to.not.use[tti] <- this.sample.id
}

## this would be nice, but it doesn't seem to work:
## ffile <- mm$file(metadata = list(sample_id= "TCGA-25-1871-01A"), complete = TRUE)


## So get names of all tarfiles, and get sample IDs for them:
tarfile.indices <- grep(pattern = "(.tar.gz|fastq.tar)$", x =allfilenames.bloom)
names.alltarfiles.in.project <- allfilenames.bloom[tarfile.indices]
ids.alltarfiles.in.project <- allfileids.bloom[tarfile.indices]

sample.ids.alltarfiles.in.project <- vector("character", length(ids.alltarfiles.in.project))
for (tti in 1:length(ids.alltarfiles.in.project)){
   if (tti %% 10 ==0){
        cat(tti, "\t")
    }
    ffile <- mm$file(id = ids.alltarfiles.in.project[tti])
    this.sample.id <- ffile$metadata$sample_id
    sample.ids.alltarfiles.in.project[tti] <- this.sample.id
}

## Note that these tarfiles were actually used, but two copies were
## used.
tarfiles.not.to.use <- vector("character", length = length(ids.bv.filenames.to.not.use))
for (tti in 1:length(ids.bv.filenames.to.not.use)){
    tarfiles.not.to.use[tti] <- names.alltarfiles.in.project[which(sample.ids.alltarfiles.in.project==bv.sample.ids.for.files.to.not.use[tti])]
}




## now write two files
## one with sample id, tarfile name, and bv file name- for internal
##   memory
## other with same but without bv file name

sample.ids.extras <- bv.sample.ids.for.files.to.not.use
tarfilenames.extras <- tarfiles.not.to.use
bv.extras <- bv.filenames.to.not.use
df.extras <- data.frame(Sample.Id=sample.ids.extras, Tarfile.Name=tarfilenames.extras, bvfile.name=bv.extras, stringsAsFactors = FALSE)
df.extras.for.table= df.extras[,1:2]

extras.file.with.bv.file <- file.path(bloomworkdir, paste0("bloomfiles.extra.files.info.with.bv.file.info.", shortname, ".csv"))
extras.file <- file.path(bloomworkdir, paste0("bloomfiles.extra.files.info.", shortname, ".csv"))

write.table(df.extras, file=extras.file.with.bv.file, append = F, sep=",", row.names = F, col.names = T)

write.table(t(c("Sample ID", "Archive File Name")), file=extras.file, append = F, sep=",", row.names = F, col.names = F)
write.table(df.extras.for.table, file=extras.file, append = T, sep=",", row.names = F, col.names = F)


#################################################################
## get meta data for all "good" tar files

length(ids.alltarfiles.in.project)
## 178
## so this is everything for pancreatic
    
ids.file <- file.path(bloomworkdir, paste0("bloomfilesinfo.", shortname, ".nice.ids.csv"))

writeLines(ids.alltarfiles.in.project, con = ids.file, sep = "\n")

## Now use api to get info for these files from their IDs

aa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")
## mm for project, which was in past typically machete
mm <- aa$project(id=projname)


expected.fields <- c("age_at_diagnosis", "days_to_death", "case_id", "experimental_strategy", "disease_type", "aliquot_uuid", "vital_status", "gender", "aliquot_id", "data_subtype", "sample_uuid", "platform", "investigation", "case_uuid", "race", "data_format", "data_type", "ethnicity", "sample_type", "primary_site", "sample_id")

expected.fields.nice <- tools::toTitleCase(gsub(pattern="_", replacement = " ", expected.fields))


metadata.filename <- file.path(bloomworkdir,paste0("bloomfiles.metadata.", shortname, ".csv"))

write.table(t(expected.fields.nice), file = metadata.filename, row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE)

for (tti in 1:length(ids.alltarfiles.in.project)){
    if (tti %% 10 ==0){
        cat(tti, "\t")
    }
    ffile <- mm$file(id = ids.alltarfiles.in.project[tti])
    # Weirdly, if there is no data,
    #  there is no field. So have to clean this up to give it NA value.
    metadata.after.cleaning <- clean.metadata(ffile$metadata)
    write.table(t(as.character(metadata.after.cleaning)), file = metadata.filename, row.names = FALSE, col.names = FALSE, sep = ",", append=TRUE)
}



###############################################################
###############################################################
## prad
##
## 558 used in build, but should only be 497 (also a lot of these 558 were normals, some were multiple samples per case)
##  Below is modified from determine.bloom.files.not.to.use.R
###############################################################
###############################################################


######################################################
## prad prostate
## Check in datasetapi.R for todaydate value to use
## This is for the case that you've already gotten info
## on all of the files, and you can get it from a saved
## csv file.

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

### I saved the original file as
###
old.unique.tumors.file <- file.path(homedir, paste0("old.with.3.mistakes.unique.tumors.", shortname, ".csv"))

unique.tumors.file <- file.path(homedir, paste0("unique.tumors.", shortname, ".csv"))
unique.tumors.df <- read.table(file=old.unique.tumors.file, header=FALSE, sep=",", stringsAsFactors = FALSE)
## unique.tumors.df <- read.table(file=unique.tumors.file, header=FALSE, sep=",", stringsAsFactors = FALSE)

n.total.cases <- dim(unique.tumors.df)[1]
n.total.cases
## 497

### 
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

# 61 of these

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
sample.id.tar.filenames.to.not.use.in.allfilenames.bloom <- vector("character", length=length(file.ids.tar.filenames.to.not.use.in.allfilenames.bloom))
for (tti in 1:length(file.ids.tar.filenames.to.not.use.in.allfilenames.bloom)){
    if (tti %% 10 ==0){
        cat(tti, "\t")
    }
    ffile <- mm$file(id = file.ids.tar.filenames.to.not.use.in.allfilenames.bloom[tti])
    metadata.tar.filenames.to.not.use.in.allfilenames.bloom[[tti]] <- ffile$metadata
    sample.uuid.tar.filenames.to.not.use.in.allfilenames.bloom[tti] <- ffile$metadata$sample_uuid
    sample.id.tar.filenames.to.not.use.in.allfilenames.bloom[tti] <- ffile$metadata$sample_id
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

###################################################################
###################################################################
## NOTE THAT I made a mistake in the manual selection of the 3
## bv files below and actually did the opposite in each case
## Since we already used those bv files,
## and since the tarfiles involved were not run with MACHETE
## the final list of tarfiles will actually involve
## swapping out 3 old tarfiles for 3 new tarfiles
## Note that this got really complicated because
## there are two tarfiles with the same sample ID in these 3 cases
##
## so the names of the tarfiles
## have to be fixed; see below
###################################################################
###################################################################



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

## next line is WRONG, USES WRONG INDICES:
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
## I made a mistake and did the opposite here: it should be in the list of bv files 
##  not to use, so it should NOT be removed


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
## I made a mistake and did the opposite here: it should be in the list of bv files 
##  not to use, so it should NOT be removed

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
## I made a mistake and did the opposite here: it should be in the list of bv files 
##  not to use, so it should NOT be removed

bv.filenames.final <-bv.filenames.pass.3[- grep(pattern = "^120710_UNC16-SN851_0169_AC0VVKACXX_TGACCA_L001_1", x = bv.filenames.pass.3)]
length(bv.filenames.final)
## 61, as expected

## Now go through these 61 files, and find the sample ID associated with
##  them, and then the tarfiles
##  associated with those (in turn)
##  also then have to look at those three special
##  sample IDs, and manually figure out and possibly correct the
##  associated tar files

bv.extras <- bv.filenames.final
sample.ids.extras <- vector("character", length = length(bv.extras))
sample.ids.extras[] <- NA
tarfilenames.extras <- vector("character", length = length(bv.extras))
tarfilenames.extras[]<- NA
n.bv.extras <- length(bv.extras)

                            
for (tti in 1:n.bv.extras){
    if (tti %% 10 ==0){
        cat(tti, "\t")
    }
    ## figure out the sample id
    i.bv <- which(bvfile.names==bv.extras[tti])
    if (length(i.bv)!=1){
        stop(paste0("problem with tti=", tti, "; i.bv=", i.bv))
    }
    this.sample.id <- bvfile.sample.ids[i.bv]
    sample.ids.extras[tti] <- this.sample.id
    ## figure out which tar file it's associated with, might
    ## actually get the wrong one; manually figure out later
    i.tarfile <- which(sample.id.tar.filenames.to.not.use.in.allfilenames.bloom==this.sample.id)
    if (length(i.tarfile)==0){
        stop(paste0("problem with tti=", tti, "; i.tarfile=", i.tarfile))
    }
    if (length(i.tarfile)>=2){
        print(paste0("issue with tti=", tti, "; i.tarfile=", i.tarfile))
    }
    if (length(i.tarfile)==1){
        tarfilenames.extras[tti] <- file.names.tar.filenames.to.not.use.in.allfilenames.bloom[i.tarfile]
    }
}

## "issue with tti=52; i.tarfile=52" "issue with tti=52; i.tarfile=53"
## [1] "issue with tti=58; i.tarfile=52" "issue with tti=58; i.tarfile=53"

## So have to do that case manually
## sample ID is
## TCGA-HC-8265-01B

## https://cgc.sbgenomics.com/u/elehnert/sequence-bloomtree-prad-largescale/files/#q?page=1&case_id=TCGA-HC-8265
## Neither of the above 2 was there, it selected this file
## in unique.tumors.pros.csv
## "564a3883e4b08c5d8690980f","UNCID_2187696.cefe4277-778b-42b3-8e05-5df8327f50be.120814_UNC12-SN629_0220_AD13JAACXX_8_GCCAAT.tar.gz","3E290DC6-ABA3-4135-B844-3E8C4CC8A25F"


## so just have to assign these manually:
bv.extras[c(52,58)]
file.names.tar.filenames.to.not.use.in.allfilenames.bloom[c(52,53)]
## [1] "120710_UNC16-SN851_0169_AC0VVKACXX_CAGATC_L007_1_concatenated.bf.bv"
## [2] "120710_UNC16-SN851_0169_AC0VVKACXX_TGACCA_L002_1_concatenated.bf.bv"
## [1] "UNCID_2355687.da8ee6ab-5fde-462b-96ad-b45b9441e495.120710_UNC16-SN851_0169_AC0VVKACXX_7_CAGATC.tar.gz"
## [2] "UNCID_2355693.da8ee6ab-5fde-462b-96ad-b45b9441e495.120710_UNC16-SN851_0169_AC0VVKACXX_2_TGACCA.tar.gz"

## from names, and I'll go with this in the interest of time, looks like
## bv.extras[52]
## 120710_UNC16-SN851_0169_AC0VVKACXX_CAGATC_L007_1_concatenated.bf.bv
## goes with
## file.names.tar.filenames.to.not.use.in.allfilenames.bloom[52]
## [1] "UNCID_2355687.da8ee6ab-5fde-462b-96ad-b45b9441e495.120710_UNC16-SN851_0169_AC0VVKACXX_7_CAGATC.tar.gz"

tarfilenames.extras[52] <- file.names.tar.filenames.to.not.use.in.allfilenames.bloom[52]
tarfilenames.extras[58] <- file.names.tar.filenames.to.not.use.in.allfilenames.bloom[53]

bv.extras[c(52,58)]
tarfilenames.extras[c(52,58)]
## [1] "120710_UNC16-SN851_0169_AC0VVKACXX_CAGATC_L007_1_concatenated.bf.bv"
## [2] "120710_UNC16-SN851_0169_AC0VVKACXX_TGACCA_L002_1_concatenated.bf.bv"
## [1] "UNCID_2355687.da8ee6ab-5fde-462b-96ad-b45b9441e495.120710_UNC16-SN851_0169_AC0VVKACXX_7_CAGATC.tar.gz"
## [2] "UNCID_2355693.da8ee6ab-5fde-462b-96ad-b45b9441e495.120710_UNC16-SN851_0169_AC0VVKACXX_2_TGACCA.tar.gz"


## check others:
## bv.extras[31:33]
## [1] "120508_UNC13-SN749_0172_AD101FACXX_GCCAAT_L002_1_concatenated.bf.bv"
## [2] "120507_UNC10-SN254_0355_AC0TR8ACXX_GATCAG_L004_1_concatenated.bf.bv"
## [3] "120508_UNC13-SN749_0172_AD101FACXX_GCCAAT_L007_1_concatenated.bf.bv"
## > sample.ids.extras[31:33]
## [1] "TCGA-EJ-7782-11A" "TCGA-EJ-7783-11A" "TCGA-HC-7752-11A"
## > tarfilenames.extras[31:33]
## [1] "UNCID_2189831.e74de9a3-6dd4-42b7-b92c-eba3e3827bed.120508_UNC13-SN749_0172_AD101FACXX_2_GCCAAT.tar.gz"
## [2] "UNCID_2189849.7afedcd4-d921-4996-9587-a8faa03dcea0.120507_UNC10-SN254_0355_AC0TR8ACXX_4_GATCAG.tar.gz"
## [3] "UNCID_2189850.c08293b3-507d-4c7c-8b14-9a328e1d15fe.120508_UNC13-SN749_0172_AD101FACXX_7_GCCAAT.tar.gz"


## Now look at three sample IDs, and 
## possibly correct the
## associated tar files
sample.ids.to.examine
## [1] "TCGA-HC-7740-01B" "TCGA-HC-8258-01B" "TCGA-HC-8261-01B"


indices.to.examine <- which(sample.ids.extras %in% sample.ids.to.examine)
## 59 60 61

sample.ids.extras[indices.to.examine]
## [1] "TCGA-HC-8261-01B" "TCGA-HC-8258-01B" "TCGA-HC-7740-01B"

tarfilenames.extras[indices.to.examine]
## [1] "UNCID_2355694.3476ee8f-8cbe-4c6e-a3f7-f53facfe585a.120710_UNC16-SN851_0169_AC0VVKACXX_1_TGACCA.tar.gz"
## [2] "UNCID_2355696.783062c7-cf22-426d-8cd1-52ecdd28b43d.120710_UNC12-SN629_0215_BC0WRNACXX_6_TGACCA.tar.gz"
## [3] "UNCID_2355699.b7f3a96d-01f8-4ef2-a71d-2c684bd18812.120710_UNC12-SN629_0215_BC0WRNACXX_5_TGACCA.tar.gz"

bv.extras[indices.to.examine]
## [1] "121011_UNC15-SN850_0238_AD13P9ACXX_NoIndex_L008_1_concatenated.bf.bv"
## [2] "120710_UNC16-SN851_0169_AC0VVKACXX_CAGATC_L004_1_concatenated.bf.bv" 
## [3] "121011_UNC15-SN850_0238_AD13P9ACXX_NoIndex_L007_1_concatenated.bf.bv"


which(sample.id.tar.filenames.to.yes.use.in.allfilenames.bloom %in% sample.ids.extras[indices.to.examine])
## 272 273 274
bloom.names.unique.tumors[which(sample.id.tar.filenames.to.yes.use.in.allfilenames.bloom %in% sample.ids.extras[indices.to.examine])]
## these are the PREVIOUS "good" ones, i.e. that WERE in the list of 497:
## [1] "UNCID_2355579.3476ee8f-8cbe-4c6e-a3f7-f53facfe585a.121011_UNC15-SN850_0238_AD13P9ACXX_8_CAGATC.tar.gz"
## [2] "UNCID_2355581.b7f3a96d-01f8-4ef2-a71d-2c684bd18812.121011_UNC15-SN850_0238_AD13P9ACXX_7_CAGATC.tar.gz"
## [3] "UNCID_2355692.783062c7-cf22-426d-8cd1-52ecdd28b43d.120710_UNC16-SN851_0169_AC0VVKACXX_4_CAGATC.tar.gz"
tarfilenames.extras[indices.to.examine]
## these used to be excluded, but are not now:
## [1] "UNCID_2355694.3476ee8f-8cbe-4c6e-a3f7-f53facfe585a.120710_UNC16-SN851_0169_AC0VVKACXX_1_TGACCA.tar.gz"
## [2] "UNCID_2355696.783062c7-cf22-426d-8cd1-52ecdd28b43d.120710_UNC12-SN629_0215_BC0WRNACXX_6_TGACCA.tar.gz"
## [3] "UNCID_2355699.b7f3a96d-01f8-4ef2-a71d-2c684bd18812.120710_UNC12-SN629_0215_BC0WRNACXX_5_TGACCA.tar.gz"

## OLD:
tarfilenames.extras[indices.to.examine][which(tarfilenames.extras[indices.to.examine] %in% tar.filenames.to.not.use)]

## OLD:
which(unique.tumors.df[,2] %in% bloom.names.unique.tumors[which(sample.id.tar.filenames.to.yes.use.in.allfilenames.bloom %in% sample.ids.extras[indices.to.examine])])
## 108 244 269
which(unique.tumors.df[,2] %in% bloom.names.unique.tumors[which(sample.id.tar.filenames.to.yes.use.in.allfilenames.bloom %in% tarfilenames.extras[indices.to.examine])])
## integer(0)


## So I made a mistake when selecting the bv files not to use;
## my OLD list follows; OLD list
## I checked manually and indeed it has these three (at the end)
bv.extras[indices.to.examine]
## [1] "121011_UNC15-SN850_0238_AD13P9ACXX_NoIndex_L008_1_concatenated.bf.bv"
## [2] "120710_UNC16-SN851_0169_AC0VVKACXX_CAGATC_L004_1_concatenated.bf.bv" 
## [3] "121011_UNC15-SN850_0238_AD13P9ACXX_NoIndex_L007_1_concatenated.bf.bv"
##
bv.filenames.final
## my OLD list follows; OLD list
##  [1] "130226_UNC12-SN629_0260_AC1PTLACXX_CGATGT_L003_1_concatenated.bf.bv" 
##  [2] "130226_UNC14-SN744_0315_AD1V5TACXX_ACTTGA_L004_1_concatenated.bf.bv" 
##  [3] "130221_UNC9-SN296_0338_BC1PYCACXX_TGACCA_L008_1_concatenated.bf.bv"  
##  [4] "120815_UNC16-SN851_0177_BD13LJACXX_AGTTCC_L005_1_concatenated.bf.bv" 
##  [5] "120815_UNC16-SN851_0177_BD13LJACXX_ACAGTG_L006_1_concatenated.bf.bv" 
##  [6] "120814_UNC12-SN629_0220_AD13JAACXX_GGCTAC_L007_1_concatenated.bf.bv" 
##  [7] "120815_UNC16-SN851_0177_BD13LJACXX_CAGATC_L005_1_concatenated.bf.bv" 
##  [8] "120814_UNC12-SN629_0220_AD13JAACXX_CTTGTA_L001_1_concatenated.bf.bv" 
##  [9] "120814_UNC12-SN629_0220_AD13JAACXX_CGATGT_L002_1_concatenated.bf.bv" 
## [10] "120814_UNC12-SN629_0220_AD13JAACXX_CAGATC_L007_1_concatenated.bf.bv" 
## [11] "120814_UNC12-SN629_0220_AD13JAACXX_CAGATC_L003_1_concatenated.bf.bv" 
## [12] "120814_UNC12-SN629_0220_AD13JAACXX_GCCAAT_L001_1_concatenated.bf.bv" 
## [13] "120605_UNC11-SN627_0237_AD11WMACXX_ACAGTG_L008_1_concatenated.bf.bv" 
## [14] "120529_UNC16-SN851_0165_BC0UMTACXX_TAGCTT_L006_1_concatenated.bf.bv" 
## [15] "120529_UNC16-SN851_0165_BC0UMTACXX_CTTGTA_L002_1_concatenated.bf.bv" 
## [16] "120521_UNC12-SN629_0212_AC0RWNACXX_CAGATC_L004_1_concatenated.bf.bv" 
## [17] "120521_UNC12-SN629_0212_AC0RWNACXX_CTTGTA_L001_1_concatenated.bf.bv" 
## [18] "120514_UNC16-SN851_0158_AC0UWTACXX_ACTTGA_L003_1_concatenated.bf.bv" 
## [19] "120514_UNC16-SN851_0159_BC0TARACXX_TAGCTT_L006_1_concatenated.bf.bv" 
## [20] "120514_UNC16-SN851_0159_BC0TARACXX_GCCAAT_L005_1_concatenated.bf.bv" 
## [21] "120514_UNC16-SN851_0159_BC0TARACXX_CTTGTA_L003_1_concatenated.bf.bv" 
## [22] "120514_UNC16-SN851_0159_BC0TARACXX_CAGATC_L002_1_concatenated.bf.bv" 
## [23] "120507_UNC10-SN254_0355_AC0TR8ACXX_TGACCA_L006_1_concatenated.bf.bv" 
## [24] "120507_UNC10-SN254_0355_AC0TR8ACXX_CGATGT_L004_1_concatenated.bf.bv" 
## [25] "120507_UNC10-SN254_0355_AC0TR8ACXX_TGACCA_L001_1_concatenated.bf.bv" 
## [26] "120507_UNC10-SN254_0355_AC0TR8ACXX_CAGATC_L002_1_concatenated.bf.bv" 
## [27] "120508_UNC13-SN749_0172_AD101FACXX_GATCAG_L007_1_concatenated.bf.bv" 
## [28] "120508_UNC13-SN749_0172_AD101FACXX_ACAGTG_L005_1_concatenated.bf.bv" 
## [29] "120508_UNC13-SN749_0172_AD101FACXX_TAGCTT_L004_1_concatenated.bf.bv" 
## [30] "120508_UNC13-SN749_0172_AD101FACXX_CAGATC_L003_1_concatenated.bf.bv" 
## [31] "120508_UNC13-SN749_0172_AD101FACXX_GCCAAT_L002_1_concatenated.bf.bv" 
## [32] "120507_UNC10-SN254_0355_AC0TR8ACXX_GATCAG_L004_1_concatenated.bf.bv" 
## [33] "120508_UNC13-SN749_0172_AD101FACXX_GCCAAT_L007_1_concatenated.bf.bv" 
## [34] "120430_UNC10-SN254_0353_AC0TGUACXX_TGACCA_L006_1_concatenated.bf.bv" 
## [35] "120430_UNC10-SN254_0353_AC0TGUACXX_CGATGT_L004_1_concatenated.bf.bv" 
## [36] "120501_UNC11-SN627_0226_AC0TGKACXX_CGATGT_L006_1_concatenated.bf.bv" 
## [37] "120501_UNC11-SN627_0226_AC0TGKACXX_GATCAG_L002_1_concatenated.bf.bv" 
## [38] "111212_UNC15-SN850_0155_AD087AACXX_ACTTGA_L008_1_concatenated.bf.bv" 
## [39] "111219_UNC11-SN627_0175_BC0CKKACXX_ACTTGA_L002_1_concatenated.bf.bv" 
## [40] "111212_UNC15-SN850_0155_AD087AACXX_ACTTGA_L002_1_concatenated.bf.bv" 
## [41] "111212_UNC15-SN850_0156_BD0KGCACXX_ACTTGA_L002_1_concatenated.bf.bv" 
## [42] "111208_UNC10-SN254_0313_BD087RACXX_ACTTGA_L001_1_concatenated.bf.bv" 
## [43] "120223_UNC12-SN629_0186_AC0GA2ACXX_GATCAG_L007_1_concatenated.bf.bv" 
## [44] "120430_UNC10-SN254_0353_AC0TGUACXX_GCCAAT_L006_1_concatenated.bf.bv" 
## [45] "120430_UNC10-SN254_0353_AC0TGUACXX_ACAGTG_L001_1_concatenated.bf.bv" 
## [46] "120223_UNC12-SN629_0186_AC0GA2ACXX_ACTTGA_L004_1_concatenated.bf.bv" 
## [47] "130226_UNC14-SN744_0315_AD1V5TACXX_ACAGTG_L007_1_concatenated.bf.bv" 
## [48] "130226_UNC14-SN744_0315_AD1V5TACXX_TGACCA_L006_1_concatenated.bf.bv" 
## [49] "130226_UNC14-SN744_0315_AD1V5TACXX_TTAGGC_L005_1_concatenated.bf.bv" 
## [50] "130226_UNC14-SN744_0315_AD1V5TACXX_CGATGT_L005_1_concatenated.bf.bv" 
## [51] "130221_UNC9-SN296_0338_BC1PYCACXX_ACAGTG_L008_1_concatenated.bf.bv"  
## [52] "120710_UNC16-SN851_0169_AC0VVKACXX_CAGATC_L007_1_concatenated.bf.bv" 
## [53] "140318_UNC12-SN629_0354_AC3K7VACXX_AGTCAA_L002_1_concatenated.bf.bv" 
## [54] "140318_UNC12-SN629_0354_AC3K7VACXX_CCGTCC_L004_1_concatenated.bf.bv" 
## [55] "120514_UNC16-SN851_0158_AC0UWTACXX_GATCAG_L008_1_concatenated.bf.bv" 
## [56] "120501_UNC16-SN851_0154_BC0MB8ACXX_ACTTGA_L008_1_concatenated.bf.bv" 
## [57] "140820_UNC17-D00216_0240_AC5FB2ACXX_ACAGTG_L006_1_concatenated.bf.bv"
## [58] "120710_UNC16-SN851_0169_AC0VVKACXX_TGACCA_L002_1_concatenated.bf.bv" 
## [59] "121011_UNC15-SN850_0238_AD13P9ACXX_NoIndex_L008_1_concatenated.bf.bv"
## [60] "120710_UNC16-SN851_0169_AC0VVKACXX_CAGATC_L004_1_concatenated.bf.bv" 
## [61] "121011_UNC15-SN850_0238_AD13P9ACXX_NoIndex_L007_1_concatenated.bf.bv"
##
## Now look at these:
bv.extras[indices.to.examine]
## [1] "121011_UNC15-SN850_0238_AD13P9ACXX_NoIndex_L008_1_concatenated.bf.bv"
## [2] "120710_UNC16-SN851_0169_AC0VVKACXX_CAGATC_L004_1_concatenated.bf.bv" 
## [3] "121011_UNC15-SN850_0238_AD13P9ACXX_NoIndex_L007_1_concatenated.bf.bv"
## I checked manually that these are in files.not.to.use.pros.csv

## 121011_UNC15-SN850_0238_AD13P9ACXX_NoIndex_L008_1_concatenated.bf.bv
## is here:
## https://cgc.sbgenomics.com/u/elehnert/sequence-bloomtree-prad-largescale/files/57bce578e4b0a323e2cf24b9/
## it has sample ID
## TCGA-HC-8261-01B
## https://cgc.sbgenomics.com/u/elehnert/sequence-bloomtree-prad-largescale/files/#q?page=1&sample_id=TCGA-HC-8261-01B
## shows that
## it could come from either
## ## [1] "UNCID_2355579.3476ee8f-8cbe-4c6e-a3f7-f53facfe585a.121011_UNC15-SN850_0238_AD13P9ACXX_8_CAGATC.tar.gz"
## OR
## [1] "UNCID_2355694.3476ee8f-8cbe-4c6e-a3f7-f53facfe585a.120710_UNC16-SN851_0169_AC0VVKACXX_1_TGACCA.tar.gz"
## 120710_UNC16-SN851_0169_AC0VVKACXX_TGACCA_L001_2.fastq
## comes from
## [1] "UNCID_2355694.3476ee8f-8cbe-4c6e-a3f7-f53facfe585a.120710_UNC16-SN851_0169_AC0VVKACXX_1_TGACCA.tar.gz"
## so
## our starting one
## ## 121011_UNC15-SN850_0238_AD13P9ACXX_NoIndex_L008_1_concatenated.bf.bv
## comes from 
## ## [1] "UNCID_2355579.3476ee8f-8cbe-4c6e-a3f7-f53facfe585a.121011_UNC15-SN850_0238_AD13P9ACXX_8_CAGATC.tar.gz"
## which was in the 497 unique tumors, so this was a mistake, and I need to fix this
tarfilenames.extras[59] <- "UNCID_2355579.3476ee8f-8cbe-4c6e-a3f7-f53facfe585a.121011_UNC15-SN850_0238_AD13P9ACXX_8_CAGATC.tar.gz"

## [2] "120710_UNC16-SN851_0169_AC0VVKACXX_CAGATC_L004_1_concatenated.bf.bv"
## is here:
## https://cgc.sbgenomics.com/u/elehnert/sequence-bloomtree-prad-largescale/files/57bce579e4b0a323e2cf24bc/
## has sample ID
## TCGA-HC-8258-01B
## See here:
## https://cgc.sbgenomics.com/u/elehnert/sequence-bloomtree-prad-largescale/files/#q?page=1&sample_id=TCGA-HC-8258-01B
## associated with one of these tar files:
## ## [3] "UNCID_2355692.783062c7-cf22-426d-8cd1-52ecdd28b43d.120710_UNC16-SN851_0169_AC0VVKACXX_4_CAGATC.tar.gz"
## [2] "UNCID_2355696.783062c7-cf22-426d-8cd1-52ecdd28b43d.120710_UNC12-SN629_0215_BC0WRNACXX_6_TGACCA.tar.gz"
## from this unpacking task
## https://cgc.sbgenomics.com/u/elehnert/sequence-bloomtree-prad-largescale/tasks/3de9fa82-289a-421f-bd7c-e25738c8ece2/
## can see that 
## [2] "120710_UNC16-SN851_0169_AC0VVKACXX_CAGATC_L004_1_concatenated.bf.bv"
## came from
## 
## ## [3] "UNCID_2355692.783062c7-cf22-426d-8cd1-52ecdd28b43d.120710_UNC16-SN851_0169_AC0VVKACXX_4_CAGATC.tar.gz"
## which was in the 497 originally
## so I made a mistake, I need to fix this
## also need to do:
tarfilenames.extras[60] <- "UNCID_2355692.783062c7-cf22-426d-8cd1-52ecdd28b43d.120710_UNC16-SN851_0169_AC0VVKACXX_4_CAGATC.tar.gz"

## [3] "121011_UNC15-SN850_0238_AD13P9ACXX_NoIndex_L007_1_concatenated.bf.bv"
## is here:
## https://cgc.sbgenomics.com/u/elehnert/sequence-bloomtree-prad-largescale/files/57bce57ee4b0ac84db9268ed/
## has sample ID
## TCGA-HC-7740-01B
## associated tar files:
## [2] "UNCID_2355581.b7f3a96d-01f8-4ef2-a71d-2c684bd18812.121011_UNC15-SN850_0238_AD13P9ACXX_7_CAGATC.tar.gz"
## [3] "UNCID_2355699.b7f3a96d-01f8-4ef2-a71d-2c684bd18812.120710_UNC12-SN629_0215_BC0WRNACXX_5_TGACCA.tar.gz"
## from this task
## https://cgc.sbgenomics.com/u/elehnert/sequence-bloomtree-prad-largescale/tasks/01126fd5-37c7-4768-82df-11c90fa81453/
## can see that
## [3] "121011_UNC15-SN850_0238_AD13P9ACXX_NoIndex_L007_1_concatenated.bf.bv"
## comes from
## [2] "UNCID_2355581.b7f3a96d-01f8-4ef2-a71d-2c684bd18812.121011_UNC15-SN850_0238_AD13P9ACXX_7_CAGATC.tar.gz"
## this is one of the original 497, so I made a mistake, so I need to
## fix this
## do this also:
tarfilenames.extras[61] <- "UNCID_2355581.b7f3a96d-01f8-4ef2-a71d-2c684bd18812.121011_UNC15-SN850_0238_AD13P9ACXX_7_CAGATC.tar.gz"


## quick fix, though it doesn't preserve the randomness, is to
## change the list of tar files used in bloom builds to have
## [1] "UNCID_2355694.3476ee8f-8cbe-4c6e-a3f7-f53facfe585a.120710_UNC16-SN851_0169_AC0VVKACXX_1_TGACCA.tar.gz"
## [2] "UNCID_2355696.783062c7-cf22-426d-8cd1-52ecdd28b43d.120710_UNC12-SN629_0215_BC0WRNACXX_6_TGACCA.tar.gz"
## [3] "UNCID_2355699.b7f3a96d-01f8-4ef2-a71d-2c684bd18812.120710_UNC12-SN629_0215_BC0WRNACXX_5_TGACCA.tar.gz"

## AND REMOVE THESE, which were formerly on the list:
## but need to swap the order: 3 below replaces 2 above, 2 below replaces
##   3 above
## [1] "UNCID_2355579.3476ee8f-8cbe-4c6e-a3f7-f53facfe585a.121011_UNC15-SN850_0238_AD13P9ACXX_8_CAGATC.tar.gz"
## [2] "UNCID_2355581.b7f3a96d-01f8-4ef2-a71d-2c684bd18812.121011_UNC15-SN850_0238_AD13P9ACXX_7_CAGATC.tar.gz"
## [3] "UNCID_2355692.783062c7-cf22-426d-8cd1-52ecdd28b43d.120710_UNC16-SN851_0169_AC0VVKACXX_4_CAGATC.tar.gz"

## also need to make sure that none of the ones being removed had machete run on them
## sample.ids.extras[indices.to.examine]
## [1] "TCGA-HC-8261-01B" "TCGA-HC-8258-01B" "TCGA-HC-7740-01B"
## yes, none of these sample ids show up

## ACTUALLY DON'T NEED TO CHECK THAT METADATA IS THE SAME FOR THESE CASES## BUT ANYWAY, IT SHOULD BE SINCE THEY HAVE THE SAME SAMPLE IDS
## BUT I HAD STARTED THIS BEFORE REALIZING IT'S NOT NECESSARY
ids.3.in.old.497<- unique.tumors.df[which(unique.tumors.df[,2] %in% bloom.names.unique.tumors[which(sample.id.tar.filenames.to.yes.use.in.allfilenames.bloom %in% sample.ids.extras[indices.to.examine])]),1]
ids.3.in.new.497 <- c("57bc9f5de4b0192c34a625bf", "57bc9f5de4b0192c34a627c7", "57bc9f5de4b0192c34a62601")

metadata.3.in.old.497 <- vector("list", length=3)
metadata.3.in.new.497 <- vector("list", length=3)
names.3.in.old.497 <- vector("character", length=3)
names.3.in.new.497 <- vector("character", length=3)
for (tti in 1:3){
    ffile <- mm$file(id = ids.3.in.old.497[tti])
    metadata.3.in.old.497[[tti]] <- ffile$metadata
    names.3.in.old.497[tti] <- ffile$name
    gfile <- mm$file(id = ids.3.in.new.497[tti])
    metadata.3.in.new.497[[tti]] <- gfile$metadata
    names.3.in.new.497[tti] <- gfile$name
}

## names.3.in.new.497 <- c("UNCID_2355694.3476ee8f-8cbe-4c6e-a3f7-f53facfe585a.120710_UNC16-SN851_0169_AC0VVKACXX_1_TGACCA.tar.gz", "UNCID_2355699.b7f3a96d-01f8-4ef2-a71d-2c684bd18812.120710_UNC12-SN629_0215_BC0WRNACXX_5_TGACCA.tar.gz", "UNCID_2355696.783062c7-cf22-426d-8cd1-52ecdd28b43d.120710_UNC12-SN629_0215_BC0WRNACXX_6_TGACCA.tar.gz")

## names.3.in.old.497
## [1] "UNCID_2355579.3476ee8f-8cbe-4c6e-a3f7-f53facfe585a.121011_UNC15-SN850_0238_AD13P9ACXX_8_CAGATC.tar.gz"
## [2] "UNCID_2355581.b7f3a96d-01f8-4ef2-a71d-2c684bd18812.121011_UNC15-SN850_0238_AD13P9ACXX_7_CAGATC.tar.gz"
## [3] "UNCID_2355692.783062c7-cf22-426d-8cd1-52ecdd28b43d.120710_UNC16-SN851_0169_AC0VVKACXX_4_CAGATC.tar.gz"
for (tti in 1:3){
    print(identical(metadata.3.in.old.497[[tti]], metadata.3.in.new.497[[tti]]))
}


###################################################################
##  Fix the names of the tarfiles
###################################################################


## replace rows with the new tarfiles
new.tarfiles.df <- unique.tumors.df
indices.to.replace <- which(unique.tumors.df[,2] %in% bloom.names.unique.tumors[which(sample.id.tar.filenames.to.yes.use.in.allfilenames.bloom %in% sample.ids.extras[indices.to.examine])])
indices.to.replace
## 108 244 269
## which(unique.tumors.df[,2] %in% bloom.names.unique.tumors[which(sample.id.tar.filenames.to.yes.use.in.allfilenames.bloom %in% tarfilenames.extras[indices.to.examine])])

## new names and SB ids
## names.3.in.new.497 <- c("UNCID_2355694.3476ee8f-8cbe-4c6e-a3f7-f53facfe585a.120710_UNC16-SN851_0169_AC0VVKACXX_1_TGACCA.tar.gz", "UNCID_2355699.b7f3a96d-01f8-4ef2-a71d-2c684bd18812.120710_UNC12-SN629_0215_BC0WRNACXX_5_TGACCA.tar.gz", "UNCID_2355696.783062c7-cf22-426d-8cd1-52ecdd28b43d.120710_UNC12-SN629_0215_BC0WRNACXX_6_TGACCA.tar.gz")
## ids.3.in.new.497 <- c("57bc9f5de4b0192c34a625bf", "57bc9f5de4b0192c34a627c7", "57bc9f5de4b0192c34a62601")
##
## get case uuids manually, although they should actually be the same
## 
new.tarfiles.df[indices.to.replace,1] <- ids.3.in.new.497
new.tarfiles.df[indices.to.replace,2] <- names.3.in.new.497
new.tarfiles.df[indices.to.replace,3] <- c("F16CE517-D51D-499A-A4C4-A6844FEFA52C","91E249A6-B0B0-487E-9FAD-0E9F5798DCAE","DA5B0169-E4F4-4674-B348-220AF03FF4B5")
cbind(new.tarfiles.df,unique.tumors.df)[indices.to.replace,]

unique.tumors.file <- file.path(homedir, paste0("unique.tumors.", shortname, ".csv"))

### I made a mistake in determine.bloom.files.not.to.use.R
### when I manually tried to exclude 3
### files from a list of 64 so that they wouldn't be in the list
### of 61 files to not use. Those were actually the ones that should
### have been excluded from the 497 and thus still in the 61. So I got
### mixed up. So I save the original file as
### old.unique.tumors.file <- file.path(homedir, paste0("old.with.3.mistakes.unique.tumors.", shortname, ".csv"))
### Just in case it gets copied over, I'm also saving a copy of the
### new one as:
### 
copy.of.new.unique.tumors.file <- file.path(homedir, paste0("copy.of.new.in.case.of.accidental.overwriting.unique.tumors.", shortname, ".csv"))

write.table(new.tarfiles.df, file=copy.of.new.unique.tumors.file, col.names = FALSE, row.names = FALSE, sep=",", append = FALSE)

write.table(new.tarfiles.df, file=unique.tumors.file, col.names = FALSE, row.names = FALSE, sep=",", append = FALSE)






## now write two files
## one with sample id, tarfile name, and bv file name- for internal
##   memory
## other with same but without bv file name

## can keep tarfilenames.extras as is (I did examine this manually
##  to check this.)

## sample.ids.extras <- bv.sample.ids.for.files.to.not.use
## tarfilenames.extras <- tarfiles.not.to.use
## bv.extras <- bv.filenames.to.not.use
df.extras <- data.frame(Sample.Id=sample.ids.extras, Tarfile.Name=tarfilenames.extras, bvfile.name=bv.extras, stringsAsFactors = FALSE)
df.extras.for.table= df.extras[,1:2]

extras.file.with.bv.file <- file.path(bloomworkdir, paste0("bloomfiles.extra.files.info.with.bv.file.info.", shortname, ".csv"))
extras.file <- file.path(bloomworkdir, paste0("bloomfiles.extra.files.info.", shortname, ".csv"))

write.table(df.extras, file=extras.file.with.bv.file, append = F, sep=",", row.names = F, col.names = T)

write.table(t(c("Sample ID", "Archive File Name")), file=extras.file, append = F, sep=",", row.names = F, col.names = F)
write.table(df.extras.for.table, file=extras.file, append = T, sep=",", row.names = F, col.names = F)



#################################################################
## get meta data for all "good" tar files
##   using new list of "good" tar files

    
ids.file <- file.path(bloomworkdir, paste0("bloomfilesinfo.", shortname, ".nice.ids.csv"))

writeLines(new.tarfiles.df[,1], con = ids.file, sep = "\n")

## Now use api to get info for these files from their IDs

aa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")
## mm for project, which was in past typically machete
mm <- aa$project(id=projname)


expected.fields <- c("age_at_diagnosis", "days_to_death", "case_id", "experimental_strategy", "disease_type", "aliquot_uuid", "vital_status", "gender", "aliquot_id", "data_subtype", "sample_uuid", "platform", "investigation", "case_uuid", "race", "data_format", "data_type", "ethnicity", "sample_type", "primary_site", "sample_id")

expected.fields.nice <- tools::toTitleCase(gsub(pattern="_", replacement = " ", expected.fields))


metadata.filename <- file.path(bloomworkdir,paste0("bloomfiles.metadata.", shortname, ".csv"))

write.table(t(expected.fields.nice), file = metadata.filename, row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE)

for (tti in 1:length(new.tarfiles.df[,1])){
    if (tti %% 10 ==0){
        cat(tti, "\t")
    }
    ffile <- mm$file(id = new.tarfiles.df[tti,1])
    # Weirdly, if there is no data,
    #  there is no field. So have to clean this up to give it NA value.
    metadata.after.cleaning <- clean.metadata(ffile$metadata)
    write.table(t(as.character(metadata.after.cleaning)), file = metadata.filename, row.names = FALSE, col.names = FALSE, sep = ",", append=TRUE)
}






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


## weird:
## https://cgc.sbgenomics.com/u/elehnert/sequence-bloomtree-prad-largescale/files/57bc9f5de4b0192c34a625bf/



files.not.to.use <- file.path(homedir, paste0("files.not.to.use.", shortname, ".csv"))





######################################################################
######################################################################
######################################################################
######################################################################
### Now combine the files across all disease types
######################################################################
######################################################################
######################################################################
######################################################################

## first do the extra files

extras.file.with.bv.file.all.cancers <- file.path(bloomworkdir, paste0("bloomfiles.extra.files.info.with.bv.file.info.all.cancers.csv"))
extras.file.all.cancers <- file.path(bloomworkdir, paste0("bloomfiles.extra.files.info.all.cancers.csv"))

write.table(t(c("Cancer Type", "Sample ID", "Archive File Name")), file=extras.file, append = F, sep=",", row.names = F, col.names = F)
write.table(t(c("Cancer Type", "Sample ID", "Archive File Name", "Bit Vector File")), file=extras.file.with.bv.file.all.cancers, append = F, sep=",", row.names = F, col.names = F)

## 
short.names.for.extra.files <- c("aml", "cervical", "ovarian", "pancreatic", "pros")
n.types.for.extras <- length(short.names.for.extra.files)
nice.short.names.for.extra.files <- c("aml", "cesc", "ov", "paad", "prad")

for (tti in 1:n.types.for.extras){
    this.extras.file <- file.path(bloomworkdir, paste0("bloomfiles.extra.files.info.", short.names.for.extra.files[tti], ".csv"))
    this.extras.file.with.bv.info <- file.path(bloomworkdir, paste0("bloomfiles.extra.files.info.with.bv.file.info.",  short.names.for.extra.files[tti], ".csv"))
    these.extras.1 <- read.table(this.extras.file, header=TRUE, sep=",")
    these.extras <- data.frame(rep(nice.short.names.for.extra.files[tti], dim(these.extras.1)[1]), these.extras.1) 
    these.extras.with.bv.info.1 <- read.table(this.extras.file.with.bv.info, header=TRUE, sep=",")
    these.extras.with.bv.info <- data.frame(rep(nice.short.names.for.extra.files[tti], dim(these.extras.with.bv.info.1)[1]), these.extras.with.bv.info.1) 
    write.table(x=these.extras, file=extras.file.all.cancers, append=T, sep=",", row.names=F, col.names = F)
    write.table(x=these.extras.with.bv.info, file=extras.file.with.bv.file.all.cancers, append=T, sep=",", row.names=F, col.names = F)
}

######################################################################
## Now do the metadata for all the "good" files
## I.e. for all files used for the bloom trees (and not for the
##    extra files that we excluded)
##
## have to get metadata for all other types that haven't gotten it for
## yet

## first get list of all ids for those we need to get metadata for


## for some, can use bloomwork/bloomfiles.info files
## produced by bloomdata.R
## can do that for br, lung
## note that we produced these files for sarc, but then
##  actually used the bloomtreemany project to do sarc
##
## for some, can use bloomwork/bloomtreemany.tarfile.ids
## produced by bloomdata.R
## for colon, sarc, gbm

##
## for others, will have to get IDs another way
## put these into projects manually
## then will have to note file IDs which were removed
## for aml, cesc, ov, paad, prad, 
## NOTE: in the end, we used gbm in the bloomtreemany
##    project, not in the bloomtree-gbm project

short.names.for.extra.files <- c("aml", "cervical", "ovarian", "pancreatic", "pros")
n.types.for.extras <- length(short.names.for.extra.files)
nice.short.names.for.extra.files <- c("aml", "cesc", "ov", "paad", "prad")
metadata.filenames.for.files.with.extras <- vector("character", length= n.types.for.extras)
for (tti in 1:n.types.for.extras){
    metadata.filenames.for.files.with.extras[tti] <- file.path(bloomworkdir,paste0("bloomfiles.metadata.", short.names.for.extra.files[tti], ".csv"))
}


## get ids for other types
ids.for.types.without.extras <- vector("list", length = 5)
n.types.without.extras <- length(ids.for.types.without.extras)
short.names.for.types.without.extras <- c("brca", "lung", "coad", "gbm", "sarc")
ids.for.types.without.extras[[1]] <- readLines(file.path(bloomworkdir, "bloomfilesinfo.br.oct15.nice.ids.csv"))
ids.for.types.without.extras[[2]] <- readLines(file.path(bloomworkdir, "bloomfilesinfo.lung.oct21.nice.ids.csv"))
ids.for.types.without.extras[[3]] <- readLines(file.path(bloomworkdir, "bloomtreemany.tarfile.ids.colon.csv"))
ids.for.types.without.extras[[4]] <- readLines(file.path(bloomworkdir, "bloomtreemany.tarfile.ids.gbm.csv"))
ids.for.types.without.extras[[5]] <- readLines(file.path(bloomworkdir, "bloomtreemany.tarfile.ids.sarcoma.csv"))

## now get metadata

metadata.filenames.for.files.without.extras <- vector("character", length= n.types.without.extras)
for (tti in 1:n.types.without.extras){
    metadata.filenames.for.files.without.extras[tti] <- file.path(bloomworkdir,paste0("bloomfiles.metadata.", short.names.for.types.without.extras[tti], ".csv"))
}

expected.fields <- c("age_at_diagnosis", "days_to_death", "case_id", "experimental_strategy", "disease_type", "aliquot_uuid", "vital_status", "gender", "aliquot_id", "data_subtype", "sample_uuid", "platform", "investigation", "case_uuid", "race", "data_format", "data_type", "ethnicity", "sample_type", "primary_site", "sample_id")

expected.fields.nice <- tools::toTitleCase(gsub(pattern="_", replacement = " ", expected.fields))


projnames.for.types.without.extras <- paste0("ericfg/",c("bloomtree-br", "bloomtreelung", rep("bloomtreemany",3)))

aa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")

for (tti in 1:n.types.without.extras){
    cat("Working on ", tti, "\n")
    thisproj <- projnames.for.types.without.extras[tti]
    ## mm for project, which was in past typically machete
    mm <- aa$project(id=thisproj)
    thismetafile <- metadata.filenames.for.files.without.extras[tti]
    these.ids <- ids.for.types.without.extras[[tti]]
    write.table(t(expected.fields.nice), file = thismetafile, row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE)
    cat("length(these.ids) is: ", length(these.ids), "\n\n")
    for (jj in 1:length(these.ids)){
        if (jj %% 10 ==0){
            cat(jj, "\t")
        }
        ffile <- mm$file(id = these.ids[jj])
        ## Weirdly, if there is no data,
        ##  there is no field. So have to clean this up to give it NA value.
        metadata.after.cleaning <- clean.metadata(ffile$metadata)
        write.table(t(as.character(metadata.after.cleaning)), file = thismetafile, row.names = FALSE, col.names = FALSE, sep = ",", append=TRUE)
    }
}


######################################################################
######################################################################
######################################################################
## Now combine the metadata for all 10 cancer types
##
######################################################################
######################################################################
######################################################################

metadata.filenames.all <- c(metadata.filenames.for.files.with.extras, metadata.filenames.for.files.without.extras)


metadata.all <- read.table(file= metadata.filenames.for.files.with.extras[1], header=T, sep=",")
print(dim(metadata.all))

nice.names <- tools::toTitleCase(gsub(pattern="\\.", replacement = " ", colnames(metadata.all)))
colnames(metadata.all) <- nice.names

for (tti in 2:5){
    thisfile = metadata.filenames.for.files.with.extras[tti]
    cat("Working on file ", thisfile, "\n")
    this.df <- read.table(file= thisfile, header=T, sep=",")
    colnames(this.df) <- nice.names
    cat("Dimension of df being added on is: ", paste((dim(this.df)), collapse = " "), "\n")
    print(dim(this.df))
    metadata.all <- rbind(metadata.all, this.df)
    print(dim(metadata.all))
}

for (ttj in 1:5){
    thisfile = metadata.filenames.for.files.without.extras[ttj]
    cat("Working on file ", thisfile, "\n")
    this.df <- read.table(file= thisfile, header=T, sep=",")
    colnames(this.df) <- nice.names
    cat("Dimension of df being added on is: ", paste((dim(this.df)), collapse = " "), "\n")
    metadata.all <- rbind(metadata.all, this.df)
    print(dim(metadata.all))
}


all.metadata.filename <- file.path(bloomworkdir, "bloomfiles.metadata.all.csv")
write.table(t(nice.names), file=all.metadata.filename, append =F, sep=",", row.names=F, col.names = F)
write.table(metadata.all, file=all.metadata.filename, append =T, sep=",", row.names=F, col.names = F)



