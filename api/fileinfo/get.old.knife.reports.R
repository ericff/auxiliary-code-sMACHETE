## going back over to get knife reports that did not download at first

home.home <- FALSE



## HAVE TO ADJUST THIS!! THERE WERE ABOUT 4600 TASKS ON SEP 13 2016
upper.bound.num.tasks <- 5000
n.lists <- floor(upper.bound.num.tasks/100)

## stuff before finding duplicate is in pre.duplicate.get.old.knife.reports.R

# max.iterations for loop in out.project.list function
max.iterations <- 10000


# home directory

mydir <- "/my/dir"
{
if (home.home){ 
    homedir = file.path(mydir,"api")
    temprdatadir = file.path(mydir,"api/rdatatempfiles")
    auth.token.filename <- file.path(mydir,"api/authtoken.txt")
}
else {
    homedir = file.path(mydir,"api")
    temprdatadir = file.path(mydir,"api/rdatatempfiles")
    auth.token.filename <- file.path(mydir,"api/authtoken.txt")
}
}



wdir = file.path(homedir,"sbdata")
tempdir = file.path(homedir,"tempfiles")
fileinfodir <- file.path(homedir, "fileinfo")

# make sure there is a directory called sb/sbdata or api/sbdata
if (!dir.exists(wdir)){
    dir.create(wdir)
}

# make sure there is a directory called sb/tempfiles or api/tempfiles
if (!dir.exists(tempdir)){
    dir.create(tempdir)
}

# make sure there is a directory fileinfodir; give error if not
if (!dir.exists(fileinfodir)){
    cat("\n\n\n\nERROR: no directory ", fileinfodir, "\n\n\n\n\n")
}



source(file.path(homedir,"newapidefs.R"))





out.files.list <- list.all.files.project(projname="JSALZMAN/machete", ttwdir=wdir, tempdir=tempdir, auth.token=auth.token, max.iterations=max.iterations)
allfilenames <- out.files.list$filenames 
allfileids <- out.files.list$fileids



aa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")
## mm for project, which is typically machete
mm <- aa$project(id="JSALZMAN/machete")



## get all tasks; did this in runapi.R
## R wrapper package does NOT seem to work for this

taskmetalist <- vector("list", length=n.lists)
tasklist <- list()
for (ttj in 1:n.lists){
    cat("Working on ", ttj, "\n")
    tempout.t <- mm$task(offset=(ttj-1)*100)
    if (!is.null(tempout.t)){
        taskmetalist[[ttj]] <- tempout.t
        n.already <- length(tasklist)
        for (ttk in 1:(length(taskmetalist[[ttj]]))){
            tasklist[[(n.already+ttk)]] <- taskmetalist[[ttj]][[ttk]]
        }
    }
}
length(tasklist)
## 4591 on sep 13 2016

save(tasklist, file=file.path(mydir,"api/fileinfo/tasklist.Rdata"))
load(file=file.path(mydir,"api/fileinfo/tasklist.Rdata"))

alltasknames <- sapply(X=tasklist, FUN = function(x){ x$name})
alltaskids <- sapply(X=tasklist, FUN = function(x){ x$id})
alltaskprojs <- sapply(X=tasklist, FUN = function(x){ x$project})

## Now narrow to only the tasks in machete project

machindices <- grep("JSALZMAN/machete", x = alltaskprojs)


machids <- alltaskids[machindices]
machnames <- alltasknames[machindices]

## get things starting with "Knife for"

knindices <- grep("^Knife for", machnames)
length(knindices)
# 993 on sep 13

knids <- machids[knindices]
knnames <- machnames[knindices]

knnames.clean <- as.vector(sapply(knnames, FUN = clean.names))



################################################################
################################################################
##  Get all completed tasks in machete project starting with
##    "Knife for"
##  Then keep only those with status completed
##
################################################################
################################################################

kncomplete.yes.no <- vector("logical", length = length(knids))
kncomplete.yes.no[] <- NA
for (tti in 1:length(knids)){
    if (tti %% 5 ==0){
        cat("Working on ", tti, "\n")
    }
    tempdetails <- mm$task(id=knids[tti], detail=TRUE)
    kncomplete.yes.no[tti] <- (tempdetails$status=="COMPLETED")
}

## knc for tasks in machete project starting with
##   "Knife for" which are also completed
kncids <- knids[kncomplete.yes.no]
kncnames <- knnames[kncomplete.yes.no]
kncnames.clean <- knnames.clean[kncomplete.yes.no]

length(kncids)
## 886 on sep 13




## Now for the ones in path reports without a knife report file,
##  want to look for a knife task in kncnames or kncnames.clean
##  that matches, and then use ids to download them
##  of course in many cases, nice names probably
##   won't match up quite right,
##   e.g. if have to run machete from the completed knife manually

wdir = file.path(homedir, "fileinfo")

metadata.filename <- file.path(wdir,paste0("metadata.csv"))
outcsv.with.keys <- file.path(wdir,"report.paths.with.keys.csv")


meta <- read.csv(metadata.filename, header=TRUE, sep=",", stringsAsFactors = FALSE)

## after finding duplicate, I manually change the outcsv.with.keys and
## then redo it

paths.with.keys <- read.csv(outcsv.with.keys, header=TRUE, sep=",", stringsAsFactors = FALSE)

paths.with.meta <- merge(x=paths.with.keys, y=meta, by.x = "base.directory", by.y="nicename")

## directory names that are in the report file:
report.dirnames <- paths.with.keys$base.directory
n.report.dirnames <- length(report.dirnames)



n.kncnames.clean <- length(kncnames.clean)
n.kncnames.clean


report.dirnames.without.knife.report.file <- paths.with.keys$base.directory[is.na(paths.with.keys$knife.report)]
n.report.dirnames.without.knife.report.file <- length(report.dirnames.without.knife.report.file)
n.report.dirnames.without.knife.report.file
# 380 on sep 13, 379 on sep 14


## which kncnames.clean have a nice report.dirname in them?
##   AND HAVE EXACTLY ONE
is.this.report.dirname.in.kncnames.clean <- vector("logical", length=n.report.dirnames.without.knife.report.file)
knife.id.matching.dirname <- vector("logical", length=n.report.dirnames.without.knife.report.file)
knife.name.matching.dirname <- vector("logical", length=n.report.dirnames.without.knife.report.file)
knife.id.matching.dirname[] <- NA
knife.name.matching.dirname[] <- NA
## this is the default, but I put this here for emphasis:
is.this.report.dirname.in.kncnames.clean[] <- FALSE
indices.kncnames.clean.more.than.one.match <- vector("integer", 0)
for (tti in 1:n.report.dirnames.without.knife.report.file){
    thisindex <- grep(pattern = report.dirnames.without.knife.report.file[tti], x = kncnames.clean)
    if (length(thisindex)==1){
        is.this.report.dirname.in.kncnames.clean[tti] <- TRUE
        knife.id.matching.dirname[tti] <- kncids[thisindex]
        knife.name.matching.dirname[tti] <- kncnames[thisindex]
    }
    if (length(thisindex)>1){
        indices.kncnames.clean.more.than.one.match <- append(indices.kncnames.clean.more.than.one.match, thisindex)
    }
}
sum(is.this.report.dirname.in.kncnames.clean)
## 325 on sep 13, 324 on sep 14

## knife.id.matching.dirname and knife.name.matching.dirname
## are the same length as n.report.dirnames.without.knife.report.file
## they have an id or name (respectively) if there is a
##  task in knc clean which matches, and have NA if not

fullpath.circ.reports <- paths.with.keys$circ.junc.path[is.na(paths.with.keys$knife.report)]
length(fullpath.circ.reports)
## 379 on sep 14


## check that these all start with
## wdir 

indices.correct.start <- grep(pattern=paste0("^", wdir), x=fullpath.circ.reports)
length(indices.correct.start)
## 380 on sep 13, 379 on sep 14

## so remove front:
partpath.circ.reports <- gsub(pattern=paste0("^", wdir), replacement="", x=fullpath.circ.reports)

split.circ.reports <- vector("list", length = length(partpath.circ.reports))
for (tti in 1:length(partpath.circ.reports)){
    split.circ.reports[[tti]] <- strsplit(partpath.circ.reports[tti], split ="/")[[1]]
}

base.directories.from.split.circ.reports <- sapply(split.circ.reports, FUN="[",2)

## check that the 2nd one is inded the base directory
sum(report.dirnames.without.knife.report.file != base.directories.from.split.circ.reports)
## 0

group.directories.from.split.circ.reports <- sapply(split.circ.reports, FUN="[",1)

## check that there are no duplicates
sum(duplicated(base.directories.from.split.circ.reports))
## 0 on sep 14

## there is at least one duplicate, as of sep 13
## so then check for all duplicates:
sum(duplicated(paths.with.keys$base.directory))
## as of sep 13, just 1 that already found
## as of sep 14, 0
##
## 
## removing one in jul26mopmachete

## remove the mopmachete from everything base.directories.from.split.circ.reports
##   so don't have to rerun everything
## THEN REDO THE ABOVE


## fullpath.circ.reports <- fullpath.circ.reports[-index.to.remove]





## first, get rid of this one in jul26mopmachete and
##   ovarian50
## base.directories.from.split.circ.reports[259]. 175


## for comparison and spotchecking:
matrix.comparison <- cbind(report.dirnames.without.knife.report.file, knife.id.matching.dirname, knife.name.matching.dirname)

## this has NA's if 
length(knife.id.matching.dirname)
## 379

## write good knife ids and directories and group directories to
##   a file, for downloading
cat(file=file.path(fileinfodir,"knife.good.ids.sep14.csv"), knife.id.matching.dirname[!is.na(knife.id.matching.dirname)], sep="\n")

cat(file=file.path(fileinfodir,"dirs.good.ids.sep14.csv"), report.dirnames.without.knife.report.file[!is.na(knife.id.matching.dirname)], sep="\n")

cat(file=file.path(fileinfodir,"groupdirs.good.ids.sep14.csv"), group.directories.from.split.circ.reports[!is.na(knife.id.matching.dirname)], sep="\n")


## x <- read.csv(file.path(fileinfodir,"knife.good.ids.sep13.csv"), stringsAsFactors=FALSE)[,1]


## do this to do downloads:
## read in the ones that do not have NAs, i.e. ones
##  for which the directory has a match in a knife task:
nice.knife.id.vec <- read.table(file.path(fileinfodir,"knife.good.ids.sep14.csv"), stringsAsFactors=FALSE)[,1]
nice.knife.dirs.vec <- read.table(file.path(fileinfodir,"dirs.good.ids.sep14.csv"), stringsAsFactors=FALSE)[,1]
nice.knife.groupdirs.vec <- read.table(file.path(fileinfodir,"groupdirs.good.ids.sep14.csv"), stringsAsFactors=FALSE)[,1]
length(nice.knife.id.vec); length(nice.knife.dirs.vec); length(nice.knife.groupdirs.vec)
## spot check:
cbind(nice.knife.id.vec, nice.knife.dirs.vec, nice.knife.groupdirs.vec)[c(1,300,length(nice.knife.id.vec)),]




## df of ones that weren't found: 379 -323 = 56
df.not.found <- data.frame(base.directory=base.directories.from.split.circ.reports, group.directory=group.directories.from.split.circ.reports, fullpath=fullpath.circ.reports, stringsAsFactors=FALSE)[is.na(knife.id.matching.dirname), ]

write.table(df.not.found, file=file.path(fileinfodir,"dirs.knife.task.not.found.csv"),   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)


## So now look in knife tasks for things like rerunning or attempt 2
## should have "knife for" in the task name, but NOT start with that


## knindices <- grep("^Knife for", machnames)
kn2indices <- setdiff(grep("Knife for", ignore.case=TRUE, machnames),knindices)
length(kn2indices)
# 65 on sep 14

kn2ids <- machids[kn2indices]
kn2names <- machnames[kn2indices]

kn2names.clean <- as.vector(sapply(kn2names, FUN = clean.names))



################################################################
################################################################
##  Get all completed tasks in machete project
##    with "knife for" in them, but NOT starting with
##    "Knife for"
##  Then keep only those with status completed
##
################################################################
################################################################

kn2complete.yes.no <- vector("logical", length = length(kn2ids))
kn2complete.yes.no[] <- NA
for (tti in 1:length(kn2ids)){
    if (tti %% 5 ==0){
        cat("Working on ", tti, "\n")
    }
    tempdetails <- mm$task(id=kn2ids[tti], detail=TRUE)
    kn2complete.yes.no[tti] <- (tempdetails$status=="COMPLETED")
}

## kn2c for tasks in machete project starting with
##   "Kn2ife for" which are also completed
kn2cids <- kn2ids[kn2complete.yes.no]
kn2cnames <- kn2names[kn2complete.yes.no]
kn2cnames.clean <- kn2names.clean[kn2complete.yes.no]

length(kn2cids)
## 56


## Now for the ones in df.not.found without a knife task found yet
##  want to look for a knife task in knc2names.clean
## df of ones that weren't found: 379 -323 = 56
## df.not.found <- data.frame(base.directory=base.directories.from.split.circ.reports, group.directory=group.directories.from.split.circ.reports, fullpath=fullpath.circ.reports)[is.na(knife.id.matching.dirname), ]

n.kn2cnames.clean <- length(kn2cnames.clean)
n.kn2cnames.clean
## 56 

## rename just to make a bit clearer hopefully:
base.directories.task.not.yet.found <- df.not.found$base.directory
n.base.directories.task.not.yet.found <- length(base.directories.task.not.yet.found)
n.base.directories.task.not.yet.found
# 55


## which kn2cnames.clean have a nice base.directory name in them?
##   AND HAVE EXACTLY ONE
is.this.base.directory.in.kn2cnames.clean <- vector("logical", length=n.base.directories.task.not.yet.found)
knife.id.matching.dirname <- vector("logical", length=n.base.directories.task.not.yet.found)
knife.name.matching.dirname <- vector("logical", length=n.base.directories.task.not.yet.found)
knife.id.matching.dirname[] <- NA
knife.name.matching.dirname[] <- NA
## this is the default, but I put this here for emphasis:
is.this.base.directory.in.kn2cnames.clean[] <- FALSE
indices.kn2cnames.clean.more.than.one.match <- vector("integer", 0)
for (tti in 1:n.base.directories.task.not.yet.found){
    ## cat(tti, " ")
    thisindex <- grep(pattern = base.directories.task.not.yet.found[tti], x = kn2cnames.clean)
    if (length(thisindex)==1){
        is.this.base.directory.in.kn2cnames.clean[tti] <- TRUE
        knife.id.matching.dirname[tti] <- kn2cids[thisindex]
        knife.name.matching.dirname[tti] <- kn2cnames[thisindex]
    }
    if (length(thisindex)>1){
        indices.kn2cnames.clean.more.than.one.match <- append(indices.kn2cnames.clean.more.than.one.match, thisindex)
    }
}
sum(is.this.base.directory.in.kn2cnames.clean)
## 40 on sep 14



## knife.id.matching.dirname and knife.name.matching.dirname
## are the same length as n.base.directories.task.not.yet.found
## they have an id or name (respectively) if there is a
##  task in kn2c clean which matches, and have NA if not

df.found.in.second.round <- data.frame(df.not.found,knife.id.matching.dirname=knife.id.matching.dirname, knife.name.matching.dirname=knife.name.matching.dirname, stringsAsFactors = FALSE)[is.this.base.directory.in.kn2cnames.clean,]

## write secondgood knife ids and directories and group directories to
##   a file, for downloading
cat(file=file.path(fileinfodir,"knife.secondgood.ids.sep14.csv"), df.found.in.second.round$knife.id.matching.dirname, sep="\n")

cat(file=file.path(fileinfodir,"dirs.secondgood.ids.sep14.csv"), df.found.in.second.round$base.directory, sep="\n")

cat(file=file.path(fileinfodir,"groupdirs.secondgood.ids.sep14.csv"), df.found.in.second.round$group.directory, sep="\n")


## x <- read.csv(file.path(fileinfodir,"knife.secondgood.ids.sep13.csv"), stringsAsFactors=FALSE)[,1]


## do this to do downloads:
## read in the ones that do not have NAs, i.e. ones
##  for which the directory has a match in a knife task:
nicesecond.knife.id.vec <- read.table(file.path(fileinfodir,"knife.secondgood.ids.sep14.csv"), stringsAsFactors=FALSE)[,1]
nicesecond.knife.dirs.vec <- read.table(file.path(fileinfodir,"dirs.secondgood.ids.sep14.csv"), stringsAsFactors=FALSE)[,1]
nicesecond.knife.groupdirs.vec <- read.table(file.path(fileinfodir,"groupdirs.secondgood.ids.sep14.csv"), stringsAsFactors=FALSE)[,1]
length(nicesecond.knife.id.vec); length(nicesecond.knife.dirs.vec); length(nicesecond.knife.groupdirs.vec)
## spot check:
cbind(nicesecond.knife.id.vec, nicesecond.knife.dirs.vec, nicesecond.knife.groupdirs.vec)[c(1,20,length(nicesecond.knife.id.vec)),]



## check that there are no duplicates
sum(duplicated(nicesecond.knife.dirs.vec))
## 0 on sep 15



## do this to do downloads:
## commented out so don't do accidentally:
## for (tti in 1:length(nicesecond.knife.id.vec)){
## for (tti in 2:length(nicesecond.knife.id.vec)){
##     cat("\nWorking on ", tti, "\n\n")
##     download.knife.text.reports(task.id = nicesecond.knife.id.vec[tti], task.short.name=nicesecond.knife.dirs.vec[tti], ttwdir=wdir, ttauth=auth.token, ttproj="JSALZMAN/machete", tempdir=tempdir, datadir=nicesecond.knife.groupdirs.vec[tti])
## }



## How many are left?

## base.directories.task.not.yet.found <- df.not.found$base.directory
df.left.over <- df.not.found[!is.this.base.directory.in.kn2cnames.clean,]
dim(df.left.over)
## 15 3

## write to csv
write.table(df.left.over, file=file.path(fileinfodir,"knife.tasks.df.left.over.csv"),   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)

## TO READ IT BACK IN, DO THIS:
## df.left.over <- read.table(file.path(fileinfodir,"knife.tasks.df.left.over.csv"), stringsAsFactors=FALSE, col.names = c("base.directory", "group.directory", "fullpath"), sep=",")


df.left.over[5,]
## G17204.TCGA08038601A01R184901.2
## https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/4c903872-dd7c-4740-bedb-088c8169f818/
grep("G17204.TCGA08038601A01R184901.2", x =kncnames.clean)
## [1]  15 465
indices.kncnames.clean.more.than.one.match
## [1]  19 210  14 220  15 465  14 220

df.left.over$base.directory
## df.left.over$base.directory
##  [1] "TCGAAB289803A01T073513"                                                             
##  [2] "TCGAAB296703A01T073413"                                                             
##  [3] "G17207.TCGA06015601A03R184901.2"                                                    
##  [4] "G17214.TCGA06019001A01R184901.2"                                                    
##  [5] "G17204.TCGA08038601A01R184901.2"                                                    
##  [6] "UNCID2193652.51eae0de8f164093b42e5c34c4768459.120405UNC10SN2540345AD0VAVACXX7GGCTAC"
##  [7] "UNCID2198749.821a5315e4a24005b5fc572b32a2386a.120104UNC16SN8510120BD0J72ACXX2TTAGGC"
##  [8] "UNCID2200373.c1796b57c5e445dd931dbf533dcb9e1a.111129UNC14SN7440193BD09J3ACXX4ATCACG"
##  [9] "1G17214.TCGA06019001A01R184901.2"                                                   
## [10] "TCGA04165101A01R156713"                                                             
## [11] "TCGA10093801A02R156413"                                                             
## [12] "UNCID2179113.f2b931d2b2cf44d7a2b64f94b0395cbc.130325UNC16SN8510231BC20VNACXX3CAGATC"
## [13] "UNCID2179140.5d441f3d7d254217a6d37ed6ca78c216.130325UNC16SN8510231BC20VNACXX2ATCACG"
## [14] "UNCID2179453.957a2beed5ff4b21931ac50c3bc5fcc2.130319UNC12SN6290267BC22Y1ACXX8ACTTGA"
## [15] "UNCID2179158.21ad88e7d9c74e66945419a539b1fc4a.130325UNC16SN8510231BC20VNACXX1TTAGGC"


## first two of these are from amlaugthirdtest where used the file ids by mistake
## https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/ff902025-2364-4c7f-ba63-29c8ca4866d5/
##  [1] "TCGAAB289803A01T073513"
##  [2] "TCGAAB296703A01T073413"
## 57c76ccee4b0f9890b16d3ba TCGAAB296703A01T073413
## 57c76ccee4b0f9890b16d3bc TCGAAB289803A01T073513

## doing these manually:
tti <- 2; download.knife.text.reports(task.id = "https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/ff902025-2364-4c7f-ba63-29c8ca4866d5/", task.short.name=df.left.over$base.directory[tti], ttwdir=wdir, ttauth=auth.token, ttproj="JSALZMAN/machete", tempdir=tempdir, datadir=df.left.over$group.directory[tti])

tti <- 1; download.knife.text.reports(task.id = "https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/fd646a44-2d01-4b54-b1fc-35c128db2442/", task.short.name=df.left.over$base.directory[tti], ttwdir=wdir, ttauth=auth.token, ttproj="JSALZMAN/machete", tempdir=tempdir, datadir=df.left.over$group.directory[tti])


## TRYING TO DO MORE ON SEP 24 2016 
## DOING THESE MANUALLY

### search for G17207 in tasks?
### it has 2G17207 because of file duplication
tti <- 3; download.knife.text.reports(task.id = "https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/2b4c212e-babf-4a6d-819f-0be234a1606e/", task.short.name=df.left.over$base.directory[tti], ttwdir=wdir, ttauth=auth.token, ttproj="JSALZMAN/machete", tempdir=tempdir, datadir=df.left.over$group.directory[tti])


## file duplication again the issue 1G17214
tti <- 4; download.knife.text.reports(task.id = "https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/38010beb-9cb9-464c-9969-c14b7d317c65/", task.short.name=df.left.over$base.directory[tti], ttwdir=wdir, ttauth=auth.token, ttproj="JSALZMAN/machete", tempdir=tempdir, datadir=df.left.over$group.directory[tti])

## not sure why problem:
## Knife for G17204.TCGA08038601A01R184901.2, from tar fileG17204.TCGA08038601A01R184901.2 from group gbmsep5; first fastq file is 2G17204.TCGA-08-0386-01A-01R-1849-01.2.bam_1.fastq; appended, drafted at Sep051353

tti <- 5; download.knife.text.reports(task.id = "https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/4c903872-dd7c-4740-bedb-088c8169f818/", task.short.name=df.left.over$base.directory[tti], ttwdir=wdir, ttauth=auth.token, ttproj="JSALZMAN/machete", tempdir=tempdir, datadir=df.left.over$group.directory[tti])


## from directory file names:
## glta 120405UNC10, but doesn't help
## trim galore task:
## https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/bd536ca7-55a0-4f1a-b971-5d4e3aac17f8/
## Knife for fastq files, first of which is 120405_UNC10-SN254_0345_AD0VAVACXX_GGCTAC_L007_1.fastq, appended, drafted at Aug022338
## https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/4d16d0c4-425e-4357-8882-664e2ab1f583/
## machete:
## https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/196e8e41-d42d-4cc8-adf3-d51e0bafd6ec/
## I probably ran this manually from trim galore
## run id : aug02lungjuly26threeFromTrimGalore
tti <- 6; download.knife.text.reports(task.id = "https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/4d16d0c4-425e-4357-8882-664e2ab1f583/", task.short.name=df.left.over$base.directory[tti], ttwdir=wdir, ttauth=auth.token, ttproj="JSALZMAN/machete", tempdir=tempdir, datadir=df.left.over$group.directory[tti])


## I probably ran this manually from trim galore
## run id : aug02lungjuly26threeFromTrimGalore
## from fullpath for circ
## df.left.over$fullpath[7]
## glta 1120104_UNC16-SN851_0120_BD0J72ACXX_TTAGGC_L002
tti <- 7; download.knife.text.reports(task.id = "https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/99cf49f6-b4c6-4263-95b1-027e047c5256/", task.short.name=df.left.over$base.directory[tti], ttwdir=wdir, ttauth=auth.token, ttproj="JSALZMAN/machete", tempdir=tempdir, datadir=df.left.over$group.directory[tti])


## I probably ran this manually from trim galore
## run id : aug02lungjuly26threeFromTrimGalore
## from fullpath for circ
## df.left.over$fullpath[tti]
## glta 1111129_UNC14-SN744_0193_BD09J3ACXX_ATCACG_L004
## https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/66cbf18c-38c1-426e-a2e6-960bdc934ea0/
tti <- 8; download.knife.text.reports(task.id = "https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/66cbf18c-38c1-426e-a2e6-960bdc934ea0/", task.short.name=df.left.over$base.directory[tti], ttwdir=wdir, ttauth=auth.token, ttproj="JSALZMAN/machete", tempdir=tempdir, datadir=df.left.over$group.directory[tti])


## glta G17214
## seems like this is a duplicate of 4 above
## > df.left.over[c(4,9),]
##                       base.directory group.directory
## 100  G17214.TCGA06019001A01R184901.2       gbmjuly19
## 232 1G17214.TCGA06019001A01R184901.2             mop
##                                                                                                                                                      fullpath

## DON'T DOWNLOAD THIS ONE; IT IS A DUPLICATE; WAS MOVED TO DUPLICATES-SEP24 FOLDER
tti <- 9; download.knife.text.reports(task.id = "", task.short.name=df.left.over$base.directory[tti], ttwdir=wdir, ttauth=auth.token, ttproj="JSALZMAN/machete", tempdir=tempdir, datadir=df.left.over$group.directory[tti])

## from fullpath for circ report
## glta C0W1YACXX_5_GAATAA
## machete task:
## https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/96771e68-7c79-4712-98c1-ff367e560896/
## gives knife output dir, which leads to knife task:
## https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/e61f283b-f215-4d24-8af1-ebdc84db7bbb/
tti <- 10; download.knife.text.reports(task.id = "https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/e61f283b-f215-4d24-8af1-ebdc84db7bbb/", task.short.name=df.left.over$base.directory[tti], ttwdir=wdir, ttauth=auth.token, ttproj="JSALZMAN/machete", tempdir=tempdir, datadir=df.left.over$group.directory[tti])


## from fullpath for circ report
## glta D0ALPACXX1GCAAGG
## gives (and leads to via machete task)
## https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/0d0da164-9248-4297-a99f-ff958c1c4e60/
tti <- 11; download.knife.text.reports(task.id = "https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/0d0da164-9248-4297-a99f-ff958c1c4e60/", task.short.name=df.left.over$base.directory[tti], ttwdir=wdir, ttauth=auth.token, ttproj="JSALZMAN/machete", tempdir=tempdir, datadir=df.left.over$group.directory[tti])

## from fullpath for circ report
## glta 130325_UNC16-SN851_0231_BC20VNACXX_CAGATC_L003
tti <- 12; download.knife.text.reports(task.id = "https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/a68ed7d6-868b-41f8-9a1d-f99a53e03e77/", task.short.name=df.left.over$base.directory[tti], ttwdir=wdir, ttauth=auth.token, ttproj="JSALZMAN/machete", tempdir=tempdir, datadir=df.left.over$group.directory[tti])

## from fullpath for circ report
## glta 130325_UNC16-SN851_0231_BC20VNACXX_ATCACG_L002
## https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/3fe27699-6856-43fd-8e37-4c536f6432ab/
tti <- 13; download.knife.text.reports(task.id = "https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/3fe27699-6856-43fd-8e37-4c536f6432ab/", task.short.name=df.left.over$base.directory[tti], ttwdir=wdir, ttauth=auth.token, ttproj="JSALZMAN/machete", tempdir=tempdir, datadir=df.left.over$group.directory[tti])

## from fullpath for circ report
## df.left.over[14,]
## glta 130319_UNC12-SN629_0267_BC22Y1ACXX_ACTTGA_L008
tti <- 14; download.knife.text.reports(task.id = "https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/9390b6b0-df40-42d6-99a3-5d4bb92a3ac0/", task.short.name=df.left.over$base.directory[tti], ttwdir=wdir, ttauth=auth.token, ttproj="JSALZMAN/machete", tempdir=tempdir, datadir=df.left.over$group.directory[tti])

## from fullpath for circ report
## glta 130325_UNC16-SN851_0231_BC20VNACXX_TTAGGC_L001
tti <- 15; download.knife.text.reports(task.id = "https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/aeea3cee-afb4-48a0-af41-8cc410a1e9b1/", task.short.name=df.left.over$base.directory[tti], ttwdir=wdir, ttauth=auth.token, ttproj="JSALZMAN/machete", tempdir=tempdir, datadir=df.left.over$group.directory[tti])






