# bloomdata.R
# following
# http://docs.cancergenomicscloud.org/v1.0/docs/datasets-api-overview
# and stuff from datasetapi.R

## PROJECT NAME ASSUMES PROJECT IS UNDER ERICFG, CHANGE IF NOT


home.home <- TRUE

mydir <- "/my/dir"
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


####################################################################
####################################################################
# run up to here, then do individual lines
####################################################################
####################################################################




####################################################################
####################################################################
# breast cancer
# copy all files
## data browser https://cgc.sbgenomics.com/datasets/#/tcga/data-browser
## tells us there should be 1095 
## note that there are 1135 files, 1095 cases
## that's why we have to use the api, rather than just the browser:
## we need to pick a unique file for each case
####################################################################
####################################################################


todaydate <- "oct15"
shortname <- "br"
longname <- "Breast Invasive Carcinoma"
projnameshort <- "bloomtree-br"


projname <- paste0("ericfg/", projnameshort)

## first one is the one with zzzz where the disease will go
template.for.query.template.file <- file.path(tempdir, "tumorquery.json")
query.template.file.for.particular.disease <- file.path(tempdir, paste0(shortname,".tumorquery.json"))

outcsv <- paste0(shortname, todaydate, "query.tumor.csv")

write.different.disease.to.tumor.template.file(shortname, tempdir, longname, query.template.file=template.for.query.template.file)
out.tumors <- get.files.with.tumor.or.normal(tempdir, homedir, query.template.file=query.template.file.for.particular.disease, auth.token,  tt.files.per.download= files.per.download, sample.type="Primary Tumor", output.csv = outcsv)
length(out.tumors$ids.files)

# READ in results as nice data frame (instead of as a list)
all.tumors.df <- read.table(file=file.path(homedir, outcsv), header=TRUE, sep =",", stringsAsFactors=FALSE) 
dim(all.tumors.df)
## 

# Now choose a unique file for each case:

length(unique(all.tumors.df$ids.cases))
## 

unique.tumors.df <- choose.one.file.for.each.case(all.tumors.df)

n.total.cases <- length(unique.tumors.df$ids.cases)
n.total.cases


sb.ids.unique.tumors <- unique.tumors.df$ids.files

# Now copy these files to the machete project

out.tumors.today.first.copying.process <- copy.many.files.with.sb.id.to.project(vec.sbids=sb.ids.unique.tumors, proj.name=projname, auth.token=auth.token, tempdir=tempdir)

nice.ids.file = file.path(bloomworkdir,paste0("bloomfilesinfo.", shortname, ".", todaydate, ".nice.ids.csv"))
nice.names.file = file.path(bloomworkdir,paste0("bloomfilesinfo.", shortname, ".", todaydate, ".nice.names.csv"))
write.table(out.tumors.today.first.copying.process$files.ids, file = nice.ids.file,  row.names = FALSE, col.names = FALSE, sep = "\n", append=FALSE, quote=FALSE)
write.table(out.tumors.today.first.copying.process$files.names, file = nice.names.file,  row.names = FALSE, col.names = FALSE, sep = "\n", append=FALSE, quote=FALSE)
cat(paste0("Also writing files\n", nice.ids.file, "\n and \n", nice.names.file),"\n")






####################################################################
####################################################################
# lung cancer
# copy all files
## data browser https://cgc.sbgenomics.com/datasets/#/tcga/data-browser
## tells us there should be 516
## note that there are 540 files, 516 cases
## so we have to use the api, rather than just the browser:
## we need to pick a unique file for each case
####################################################################
####################################################################
## 540 3
## 516 unique


todaydate <- "oct21"
shortname <- "lung"
longname <- "Lung Adenocarcinoma"
projnameshort <- "bloomtreelung"


projname <- paste0("ericfg/", projnameshort)

## first one is the one with zzzz where the disease will go
template.for.query.template.file <- file.path(tempdir, "tumorquery.json")
query.template.file.for.particular.disease <- file.path(tempdir, paste0(shortname,".tumorquery.json"))

outcsv <- paste0(shortname, todaydate, "query.tumor.csv")

write.different.disease.to.tumor.template.file(shortname, tempdir, longname, query.template.file=template.for.query.template.file)
out.tumors <- get.files.with.tumor.or.normal(tempdir, homedir, query.template.file=query.template.file.for.particular.disease, auth.token,  tt.files.per.download= files.per.download, sample.type="Primary Tumor", output.csv = outcsv)
length(out.tumors$ids.files)

# READ in results as nice data frame (instead of as a list)
all.tumors.df <- read.table(file=file.path(homedir, outcsv), header=TRUE, sep =",", stringsAsFactors=FALSE) 
dim(all.tumors.df)

# Now choose a unique file for each case:

length(unique(all.tumors.df$ids.cases))

unique.tumors.df <- choose.one.file.for.each.case(all.tumors.df)

n.total.cases <- length(unique.tumors.df$ids.cases)
n.total.cases


sb.ids.unique.tumors <- unique.tumors.df$ids.files

# Now copy these files to the project

out.tumors.today.first.copying.process <- copy.many.files.with.sb.id.to.project(vec.sbids=sb.ids.unique.tumors, proj.name=projname, auth.token=auth.token, tempdir=tempdir)

nice.ids.file = file.path(bloomworkdir,paste0("bloomfilesinfo.", shortname, ".", todaydate, ".nice.ids.csv"))
nice.names.file = file.path(bloomworkdir,paste0("bloomfilesinfo.", shortname, ".", todaydate, ".nice.names.csv"))
write.table(out.tumors.today.first.copying.process$files.ids, file = nice.ids.file,  row.names = FALSE, col.names = FALSE, sep = "\n", append=FALSE, quote=FALSE)
write.table(out.tumors.today.first.copying.process$files.names, file = nice.names.file,  row.names = FALSE, col.names = FALSE, sep = "\n", append=FALSE, quote=FALSE)
cat(paste0("Also writing files\n", nice.ids.file, "\n and \n", nice.names.file),"\n")





####################################################################
####################################################################
# sarcoma
# copy one file for each case to sarcoma project
## data browser https://cgc.sbgenomics.com/datasets/#/tcga/data-browser
## tells us there should be 259
## note that there are 259 files, 259cases
## so we actually don't have to use the api, rather than just the browser:
## don't need to pick a unique file for each case
## but do it this way so can get all file names, already have it set
## up
####################################################################
####################################################################



todaydate <- "oct22"
shortname <- "sarcoma"
longname <- "Sarcoma"
projnameshort <- "bloomtreesarcoma"


projname <- paste0("ericfg/", projnameshort)

## first one is the one with zzzz where the disease will go
template.for.query.template.file <- file.path(tempdir, "tumorquery.json")
query.template.file.for.particular.disease <- file.path(tempdir, paste0(shortname,".tumorquery.json"))

outcsv <- paste0(shortname, todaydate, "query.tumor.csv")

write.different.disease.to.tumor.template.file(shortname, tempdir, longname, query.template.file=template.for.query.template.file)
out.tumors <- get.files.with.tumor.or.normal(tempdir, homedir, query.template.file=query.template.file.for.particular.disease, auth.token,  tt.files.per.download= files.per.download, sample.type="Primary Tumor", output.csv = outcsv)
length(out.tumors$ids.files)

# READ in results as nice data frame (instead of as a list)
all.tumors.df <- read.table(file=file.path(homedir, outcsv), header=TRUE, sep =",", stringsAsFactors=FALSE) 
dim(all.tumors.df)

# Now choose a unique file for each case:

length(unique(all.tumors.df$ids.cases))

unique.tumors.df <- choose.one.file.for.each.case(all.tumors.df)

n.total.cases <- length(unique.tumors.df$ids.cases)
n.total.cases


sb.ids.unique.tumors <- unique.tumors.df$ids.files

# Now copy these files to the project

out.tumors.today.first.copying.process <- copy.many.files.with.sb.id.to.project(vec.sbids=sb.ids.unique.tumors, proj.name=projname, auth.token=auth.token, tempdir=tempdir)

nice.ids.file = file.path(bloomworkdir,paste0("bloomfilesinfo.", shortname, ".", todaydate, ".nice.ids.csv"))
nice.names.file = file.path(bloomworkdir,paste0("bloomfilesinfo.", shortname, ".", todaydate, ".nice.names.csv"))
write.table(out.tumors.today.first.copying.process$files.ids, file = nice.ids.file,  row.names = FALSE, col.names = FALSE, sep = "\n", append=FALSE, quote=FALSE)
write.table(out.tumors.today.first.copying.process$files.names, file = nice.names.file,  row.names = FALSE, col.names = FALSE, sep = "\n", append=FALSE, quote=FALSE)
cat(paste0("Also writing files\n", nice.ids.file, "\n and \n", nice.names.file),"\n")





####################################################################
####################################################################
# colon cancer
## data browser https://cgc.sbgenomics.com/datasets/#/tcga/data-browser
## tells us there should be 
## note that there are 503 files, 471 samples, 458 cases
## so we have to use the api, rather than just the browser:
## we need to pick a unique file for each case
####################################################################
####################################################################


todaydate <- "nov18"
shortname <- "colon"
longname <- "Colon Adenocarcinoma"
projnameshort <- "bloomtreemany"

projname <- paste0("ericfg/", projnameshort)

## first one is the one with zzzz where the disease will go
template.for.query.template.file <- file.path(tempdir, "tumorquery.json")
query.template.file.for.particular.disease <- file.path(tempdir, paste0(shortname,".tumorquery.json"))

outcsv <- paste0(shortname, todaydate, "query.tumor.csv")

write.different.disease.to.tumor.template.file(shortname, tempdir, longname, query.template.file=template.for.query.template.file)
out.tumors <- get.files.with.tumor.or.normal(tempdir, homedir, query.template.file=query.template.file.for.particular.disease, auth.token,  tt.files.per.download= files.per.download, sample.type="Primary Tumor", output.csv = outcsv)
length(out.tumors$ids.files)

# READ in results as nice data frame (instead of as a list)
all.tumors.df <- read.table(file=file.path(homedir, outcsv), header=TRUE, sep =",", stringsAsFactors=FALSE) 
dim(all.tumors.df)

# Now choose a unique file for each case: 

length(unique(all.tumors.df$ids.cases))
## 458

filename.mostrecent = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.most.recent.csv"))


## THIS TAKES A LONG TIME ABOUT 5 TO 10 MINS
out.files.list <- list.all.files.project(projname="JSALZMAN/machete", ttwdir=wdir, tempdir=tempdir, auth.token=auth.token, max.iterations=max.iterations)
allfilenames <- out.files.list$filenames 
allfileids <- out.files.list$fileids



unique.tumors.df <- choose.one.file.for.each.case.using.the.choice.already.made.when.choosing.for.machete.runs(df.query=all.tumors.df, allfilenames= allfilenames, out.tumors=out.tumors, filename.mostrecent=filename.mostrecent)
##  OLD:
## unique.tumors.df <- choose.one.file.for.each.case(all.tumors.df)


dim(unique.tumors.df)
## [1] 458   3
sum(unique.tumors.df$names.files %in% allfilenames)
## [1] 60

n.total.cases <- length(unique.tumors.df$ids.cases)
n.total.cases

length(unique(unique.tumors.df$ids.cases))

sb.ids.unique.tumors <- unique.tumors.df$ids.files

# Now copy these files to the project

out.tumors.today.first.copying.process <- copy.many.files.with.sb.id.to.project(vec.sbids=sb.ids.unique.tumors, proj.name=projname, auth.token=auth.token, tempdir=tempdir)

nice.ids.file = file.path(bloomworkdir,paste0("bloomtreemany.tarfile.ids.", shortname, ".csv"))
nice.names.file = file.path(bloomworkdir,paste0("bloomtreemany.tarfile.names.", shortname, ".csv"))
write.table(out.tumors.today.first.copying.process$files.ids, file = nice.ids.file,  row.names = FALSE, col.names = FALSE, sep = "\n", append=FALSE, quote=FALSE)
write.table(out.tumors.today.first.copying.process$files.names, file = nice.names.file,  row.names = FALSE, col.names = FALSE, sep = "\n", append=FALSE, quote=FALSE)
cat(paste0("Also writing files\n", nice.ids.file, "\n and \n", nice.names.file),"\n")


#############
# checking colon sample ids, but doing this later
### check for multiple files per sample id
### i.e. want there to be same number of files as sample ids

aa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")
## mm for project, which was in past typically machete
mm <- aa$project(id=projname)

nice.ids.colon.file = file.path(bloomworkdir,paste0("bloomtreemany.tarfile.ids.colon.csv"))
nice.ids.colon <- readLines(con=nice.ids.colon.file)


## 
all.tumors.sample.ids.colon <- vector("integer", length=length(nice.ids.colon))
for (ii in 1:length(nice.ids.colon)){
    if (ii %% 10 ==0){
        cat(ii, "\t")
    }
    ffile <- mm$file(id = nice.ids.colon[ii])
    all.tumors.sample.ids.colon[ii] <- ffile$metadata$sample_id
}

cat("length(all.tumors.sample.ids.colon) is ", length(all.tumors.sample.ids.colon),"\n")
## 

cat("length(unique(all.tumors.sample.ids.colon)) is ", length(unique(all.tumors.sample.ids.colon)),"\n")
## 







##


####################################################################
####################################################################
# sarcoma
## data browser https://cgc.sbgenomics.com/datasets/#/tcga/data-browser
## tells us there should be 
## note that there are 259 files, 259 cases
## so we do NOT have to use the api, rather than just the browser:
## we do NOT need to pick a unique file for each case
####################################################################
####################################################################


## 
todaydate <- "nov26"
shortname <- "sarcoma"
longname <- "Sarcoma"
projnameshort <- "bloomtreemany"

projname <- paste0("ericfg/", projnameshort)

## first one is the one with zzzz where the disease will go
template.for.query.template.file <- file.path(tempdir, "tumorquery.json")
query.template.file.for.particular.disease <- file.path(tempdir, paste0(shortname,".tumorquery.json"))

outcsv <- paste0(shortname, todaydate, "query.tumor.csv")

write.different.disease.to.tumor.template.file(shortname, tempdir, longname, query.template.file=template.for.query.template.file)
out.tumors <- get.files.with.tumor.or.normal(tempdir, homedir, query.template.file=query.template.file.for.particular.disease, auth.token,  tt.files.per.download= files.per.download, sample.type="Primary Tumor", output.csv = outcsv)
length(out.tumors$ids.files)
## 259

# READ in results as nice data frame (instead of as a list)
all.tumors.df <- read.table(file=file.path(homedir, outcsv), header=TRUE, sep =",", stringsAsFactors=FALSE) 
dim(all.tumors.df)


length(unique(all.tumors.df$ids.cases))
## 259



##############################################################
##############################################################
# Now choose a unique file for each case if necessary
##############################################################
##############################################################



filename.mostrecent = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.most.recent.csv"))


## THIS TAKES A LONG TIME ABOUT 5 TO 10 MINS
out.files.list <- list.all.files.project(projname="JSALZMAN/machete", ttwdir=wdir, tempdir=tempdir, auth.token=auth.token, max.iterations=max.iterations)
allfilenames <- out.files.list$filenames 
allfileids <- out.files.list$fileids



unique.tumors.df <- choose.one.file.for.each.case.using.the.choice.already.made.when.choosing.for.machete.runs(df.query=all.tumors.df, allfilenames= allfilenames, filename.mostrecent=filename.mostrecent)
##  OLD:
## unique.tumors.df <- choose.one.file.for.each.case(all.tumors.df)


dim(unique.tumors.df)
## [1] 259  3
sum(unique.tumors.df$names.files %in% allfilenames)
## [1] 42

n.total.cases <- length(unique.tumors.df$ids.cases)
n.total.cases

length(unique(unique.tumors.df$ids.cases))

sb.ids.unique.tumors <- unique.tumors.df$ids.files

# Now copy these files to the project

out.tumors.today.first.copying.process <- copy.many.files.with.sb.id.to.project(vec.sbids=sb.ids.unique.tumors, proj.name=projname, auth.token=auth.token, tempdir=tempdir)


### check for multiple files per sample id
### i.e. want there to be same number of files as sample ids

aa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")
## mm for project, which was in past typically machete
mm <- aa$project(id=projname)

## 
all.tumors.sample.ids <- vector("integer", length=length(out.tumors.today.first.copying.process$files.ids))
for (ii in 1:length(out.tumors.today.first.copying.process$files.ids)){
    if (ii %% 10 ==0){
        cat(ii, "\t")
    }
    ffile <- mm$file(id = out.tumors.today.first.copying.process$files.ids[[ii]] )
    all.tumors.sample.ids[ii] <- ffile$metadata$sample_id
}

cat("length(all.tumors.sample.ids) is ", length(all.tumors.sample.ids),"\n")
## 259

cat("length(unique(all.tumors.sample.ids)) is ", length(unique(all.tumors.sample.ids)),"\n")
## 259

## So this is fine for sarcoma, no need to change anything for this one.
## And no "files.to.not.use"



nice.ids.file = file.path(bloomworkdir,paste0("bloomtreemany.tarfile.ids.", shortname, ".csv"))
nice.names.file = file.path(bloomworkdir,paste0("bloomtreemany.tarfile.names.", shortname, ".csv"))
write.table(out.tumors.today.first.copying.process$files.ids, file = nice.ids.file,  row.names = FALSE, col.names = FALSE, sep = "\n", append=FALSE, quote=FALSE)
write.table(out.tumors.today.first.copying.process$files.names, file = nice.names.file,  row.names = FALSE, col.names = FALSE, sep = "\n", append=FALSE, quote=FALSE)
cat(paste0("Also writing files\n", nice.ids.file, "\n and \n", nice.names.file),"\n")


####################################################################
####################################################################
## gbm
## data browser  https://cgc.sbgenomics.com/datasets/#/tcga/data-browser
## tells us there should be 155 
## note that there are 157 files, 156 samples, 155 cases
## so we have to use the api, rather than just the browser:
## we need to pick a unique file for each case
####################################################################
####################################################################


todaydate <- "dec3"
shortname <- "gbm"
longname <- "Glioblastoma Multiforme"
projnameshort <- "bloomtreemany"

projname <- paste0("ericfg/", projnameshort)

## first one is the one with zzzz where the disease will go
template.for.query.template.file <- file.path(tempdir, "tumorquery.json")
query.template.file.for.particular.disease <- file.path(tempdir, paste0(shortname,".tumorquery.json"))

outcsv <- paste0(shortname, todaydate, "query.tumor.csv")

write.different.disease.to.tumor.template.file(shortname, tempdir, longname, query.template.file=template.for.query.template.file)
out.tumors <- get.files.with.tumor.or.normal(tempdir, homedir, query.template.file=query.template.file.for.particular.disease, auth.token,  tt.files.per.download= files.per.download, sample.type="Primary Tumor", output.csv = outcsv)
length(out.tumors$ids.files)
## 157

# READ in results as nice data frame (instead of as a list)
all.tumors.df <- read.table(file=file.path(homedir, outcsv), header=TRUE, sep =",", stringsAsFactors=FALSE) 
dim(all.tumors.df)

# Now choose a unique file for each case: 

length(unique(all.tumors.df$ids.cases))
## 155

filename.mostrecent = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.most.recent.csv"))



## THIS TAKES A LONG TIME, ABOUT 5 TO 10 MINS
out.files.list <- list.all.files.project(projname="JSALZMAN/machete", ttwdir=wdir, tempdir=tempdir, auth.token=auth.token, max.iterations=max.iterations)
allfilenames <- out.files.list$filenames 
allfileids <- out.files.list$fileids



unique.tumors.df <- choose.one.file.for.each.case.using.the.choice.already.made.when.choosing.for.machete.runs(df.query=all.tumors.df, allfilenames= allfilenames, filename.mostrecent=filename.mostrecent)
##  OLD:
## unique.tumors.df <- choose.one.file.for.each.case(all.tumors.df)

## "length(indices.tumors.downloaded.by.today) is 140"

dim(unique.tumors.df)
## [1] 155   3
sum(unique.tumors.df$names.files %in% allfilenames)
## [1] 140

n.total.cases <- length(unique.tumors.df$ids.cases)
n.total.cases
## 155
length(unique(unique.tumors.df$ids.cases))

sb.ids.unique.tumors <- unique.tumors.df$ids.files

# Now copy these files to the project

out.tumors.today.first.copying.process <- copy.many.files.with.sb.id.to.project(vec.sbids=sb.ids.unique.tumors, proj.name=projname, auth.token=auth.token, tempdir=tempdir)

nice.ids.file = file.path(bloomworkdir,paste0("bloomtreemany.tarfile.ids.", shortname, ".csv"))
nice.names.file = file.path(bloomworkdir,paste0("bloomtreemany.tarfile.names.", shortname, ".csv"))
write.table(out.tumors.today.first.copying.process$files.ids, file = nice.ids.file,  row.names = FALSE, col.names = FALSE, sep = "\n", append=FALSE, quote=FALSE)
write.table(out.tumors.today.first.copying.process$files.names, file = nice.names.file,  row.names = FALSE, col.names = FALSE, sep = "\n", append=FALSE, quote=FALSE)
cat(paste0("Also writing files\n", nice.ids.file, "\n and \n", nice.names.file),"\n")


#################################################################
#################################################################
### Check for multiple files per sample id
## 
### i.e. want there to be same number of files as sample ids
##
## good for gbm b/c of this:
## length(all.tumors.sample.ids.this.type) is  155 
## length(unique(all.tumors.sample.ids.this.type)) is  155
## could be issue with _1_G17784.TCGA-76-4929-01A-01R-1850-01.4.tar.gz
#################################################################
#################################################################

aa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")
## mm for project, which was in past typically machete
mm <- aa$project(id=projname)

nice.ids.this.type <- readLines(con=nice.ids.file)


## 
all.tumors.sample.ids.this.type <- vector("integer", length=length(nice.ids.this.type))
for (ii in 1:length(nice.ids.this.type)){
    if (ii %% 10 ==0){
        cat(ii, "\t")
    }
    ffile <- mm$file(id = nice.ids.this.type[ii])
    all.tumors.sample.ids.this.type[ii] <- ffile$metadata$sample_id
}

cat("length(all.tumors.sample.ids.this.type) is ", length(all.tumors.sample.ids.this.type),"\n")
## 

cat("length(unique(all.tumors.sample.ids.this.type)) is ", length(unique(all.tumors.sample.ids.this.type)),"\n")
## 

## length(all.tumors.sample.ids.this.type) is  155 
## length(unique(all.tumors.sample.ids.this.type)) is  155 


## check for gbm
out.files.list.gbm <- list.all.files.project(projname=projname, ttwdir=wdir, tempdir=tempdir, auth.token=auth.token, max.iterations=max.iterations)
writeLines(out.files.list.gbm$filenames, con = "temp.bloomtreemany.file.list.dec4.csv")




