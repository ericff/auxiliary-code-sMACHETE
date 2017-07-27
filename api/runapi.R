# make directory of group before calling next function
# 

# NOTE: it is a problem if
#  any inputs, especially e.g. runid.suffix, are ""

# home.home is TRUE if using home computer 
home.home <- FALSE

# home directory

mydir <- "/my/dir"
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


# groupname <- "ovarian50"
# groupname <- "panc50"
# groupname <- "smalltest2"
# groupname <- "ovrun2"
# groupname <- "pancrun2"
# groupname <- "amljuly10"
# groupname <- "brjuly10"
# groupname <- "prosjuly10"
# groupname <- "amlbatch2"
# groupname <- "lungjuly12"
# groupname <- "gbmjuly12"

# groupname <- "brjuly12"
# groupname <- "gbm18mopup"

# groupname <- "colonjuly13"
# groupname <- "gbmjuly19"
# groupname <- "lungjuly22"
# groupname <- "lungjuly26"
# groupname <- "normalsjuly29"
# groupname <- "cwtrunctestaug1"

# groupname <- "amlaug1"
# groupname <- "amlnotdoneaug1"
# groupname <- "prosaug5"
# groupname <- "breaug5"

# groupname <- "prosnormalsaug7"

# groupname <- "cwtrunctestaug9"
## NOTICE THAT THE NEXT GROUP IS NOT REALLY NORMALS, I MADE A MISTAKE:
## groupname <- "lungnormalsaug10"

## groupname <- "lungnormalsaug11"
## groupname <- "lymphaug15"
## groupname <- "sqaug16"
## groupname <- "ovaug18"

## groupname <- "amlaug18"

## groupname <- "ovaug30"
## groupname <- "ovaug31"

groupname <- "amlaug31part1"

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}


# sink(file=file.path(groupdir, paste("consolelog", groupname, ".txt", sep="")), append=FALSE, split=TRUE)

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))

mastercsv <- file.path(homedir, paste("masterinfo.csv", sep=""))



# get all filenames and all file ids for the sake of looping
#   also will keep track of ones that are already done
#
#  list(filehrefs=filehrefs, fileids= fileids, filenames=filenames, n.files=n.files)
#
out.files.list <- list.all.files.project(projname="JSALZMAN/machete", ttwdir=wdir, tempdir=tempdir, auth.token=auth.token, max.iterations=max.iterations)
allfilenames <- out.files.list$filenames 
allfileids <- out.files.list$fileids


# I put in something for header.vec.for.csv everytime I add stuff
#  to vec.for.csv
#  in the function pipeline.one.tarfile
#  so as to get a header for the csv file and do it in an easy way
header.vec.for.csv <- c("group.name", "group.log.file", "group.csv.file","group.directory", "group.failed.tasks.log.file", "master.csv.file.all.groups", "complete.or.appended", "input.tar.file.name", "input.tar.file.path", "logfile.for.this.tarfile", "name.first.unpacking.task")
header.vec.for.csv <- append(header.vec.for.csv, c("succesful.unpacking.task.id", "succesful.unpacking.task.start.time", "succesful.unpacking.task.end.time"))
header.vec.for.csv <- append(header.vec.for.csv, c("original.forward.fastq.file", "original.reverse.fastq.file", "original.forward.fastq.id", "original.reverse.fastq.id", "forward.fastq.file", "reverse.fastq.file", "forward.fastq.id", "reverse.fastq.id"))

header.vec.for.csv <- append(header.vec.for.csv,c("name.first.trim.task", "start.time.first.trim.task"))

header.vec.for.csv <- append(header.vec.for.csv,c("successful.trim.task.name", "succcesful.trim.task.id"))

header.vec.for.csv <- append(header.vec.for.csv, c("original.trimmed.filenames", "original.trimmed.paths", "new.trimmed.filenames", "new.trimmed.paths"))

header.vec.for.csv <- append(header.vec.for.csv, "task.dir.full")
# length(header.vec.for.csv)
# [1] 31

# todo write header for mastercsv just once
# write.table(t(header.vec.for.csv), file = mastercsv, row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE)

write.table(t(header.vec.for.csv), file = groupcsv, row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE)


# jul 1
# TCGA-13-0891-01A-01R-1564-13_rnaseq_fastq.tar
# https://cgc.sbgenomics.com/u/JSALZMAN/machete/files/577403fce4b03bb2bc269e9e/
# intarname="_1_G17214.TCGA-06-0190-01A-01R-1849-01.2.tar.gz"
# intarpath="5775a414e4b03bb2bc272972"
complete.or.appended="appended"
pipeowner="JSALZMAN"
pipeproj="machete"
unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0"
trimapp="JSALZMAN/machete/trimgalorev2/0"
knifeapp="JSALZMAN/machete/knife-for-work"
macheteapp="JSALZMAN/machete/machete-for-work"
runid.suffix= groupname
seconds.between.checks=60
timeout.days=4

pipeline.script<- file.path(homedir, "pipeline.R")

seconds.of.wait.time.between.runs <- 10


############################################################
############################################################
############################################################
############################################################
# Can skip these for any new non-ovarian run
############################################################
############################################################
############################################################
############################################################


# how to deal with something like
# _1_G17207.TCGA-06-0156-01A-03R-1849-01.2.tar.gz
# probably have to semi-manually define the alltar lists
#  maybe also insist it does not have knife in name
#  or end in out.tar.gz
alltarindices.1 <- grep(pattern = "(\\.tar|\\.tar\\.gz)$", x = allfilenames)

alltarindices.2 <- setdiff(alltarindices.1, grep(pattern="(HG19|knife|IndelIndices)", x = allfilenames))

alltarindices <- setdiff(alltarindices.2, grep(pattern="out\\.tar\\.gz$", x = allfilenames))

alltarnames <- allfilenames[alltarindices]
alltarids <- allfileids[alltarindices]


# Not sure, but these may be the ids for all TCGA files (and cw tars) in
#   machete before july 8 massive upload
alltarids.before.july8 <- c("5775a4e2e4b03bb2bc27298b", "5775a4e2e4b03bb2bc27298c", "5775a4e2e4b03bb2bc27298f", "5775a4e2e4b03bb2bc272991", "5775a4e2e4b03bb2bc272993", "5775a4e2e4b03bb2bc272995", "575c7c41e4b05b4a92aac0be", "575c7c41e4b05b4a92aac0bd", "5775a4e2e4b03bb2bc272987", "5775a4e2e4b03bb2bc272989", "576995fce4b01be096f30e35", "577403fce4b03bb2bc269e9e", "576d6a09e4b01be096f370a6", "577eb413e4b00a1120129fe3", "577eb413e4b00a1120129fe2", "5775a414e4b03bb2bc27297b", "5775a414e4b03bb2bc27297c", "5775a414e4b03bb2bc27297a", "5775a474e4b03bb2bc272981", "5775a414e4b03bb2bc272972", "5775a414e4b03bb2bc272973", "5775a414e4b03bb2bc272974", "5775a414e4b03bb2bc272975", "57744d63e4b03bb2bc269ea4", "57746c34e4b03bb2bc269ea7", "57748dd8e4b03bb2bc269eb2", "57808d91e4b00a112012bf7b")
# get.filenames.from.fileids(fileids=alltarids.before.july8, allnames=allfilenames, allids=allfileids)

# got these by doing file name list before Julia added a LOT of ovarian
#  files on july 8:
ovarian.ids.done.before.july.8 <- c("575c7c41e4b05b4a92aac0be","576995fce4b01be096f30e35", "577403fce4b03bb2bc269e9e", "577eb413e4b00a1120129fe3", "577eb413e4b00a1120129fe2")
# ovarian.names.done.before.july.8 <- get.filenames.from.fileids(fileids=ovarian.ids.done.before.july.8, allnames=allfilenames, allids=allfileids)
#  ovarian.names.done.before.july.8
## [1] "TCGA-13-0900-01B-01R-1565-13_rnaseq_fastq.tar"
## [2] "TCGA-13-0730-01A-01R-1564-13_rnaseq_fastq.tar"
## [3] "TCGA-13-0891-01A-01R-1564-13_rnaseq_fastq.tar"
## [4] "TCGA-13-0765-01A-01R-1564-13_rnaseq_fastq.tar"
## [5] "TCGA-13-0795-01A-01R-1564-13_rnaseq_fastq.tar"

# all ovarian indices, including those already done before july 8:
all.ovarian.indices <- grep(pattern = "^TCGA.*_rnaseq_fastq\\.tar$", x = allfilenames)
all.ovarian.names <- allfilenames[all.ovarian.indices]
all.ovarian.ids <- allfileids[all.ovarian.indices]


ovarian.ids.not.run.before.july8 <- setdiff(all.ovarian.ids, ovarian.ids.done.before.july.8)
# length(ovarian.ids.not.run.before.july8)
# 100

ovarian.names.not.run.before.july8 <- get.filenames.from.fileids(fileids = ovarian.ids.not.run.before.july8, allnames=allfilenames, allids=allfileids)

# run first 50:
ov50.ids<- ovarian.ids.not.run.before.july8[1:50]
ov50.names <- ovarian.names.not.run.before.july8[1:50]

# remaining ids, printing out just in case:
# ovarian.ids.not.run.before.july8[51:length(ovarian.ids.not.run.before.july8)]
## [1] "577fc108e4b00a112012a70d" "577fc108e4b00a112012a70b"
##  [3] "577fc10ae4b00a112012a767" "577fc109e4b00a112012a737"
##  [5] "577fc10ae4b00a112012a765" "577fc108e4b00a112012a6da"
##  [7] "577fc10ae4b00a112012a763" "577fc108e4b00a112012a6dd"
##  [9] "577fc10ae4b00a112012a74f" "577fc10ae4b00a112012a74d"
## [11] "577fc108e4b00a112012a6f4" "577fc10ae4b00a112012a74b"
## [13] "577fc108e4b00a112012a6f1" "577fc10ae4b00a112012a761"
## [15] "577fc108e4b00a112012a6f5" "576d6a09e4b01be096f370a6"
## [17] "577fc108e4b00a112012a6f9" "577fc10ae4b00a112012a758"
## [19] "577fc10ae4b00a112012a757" "577fc108e4b00a112012a6ec"
## [21] "577fc10ae4b00a112012a754" "577fc108e4b00a112012a6ea"
## [23] "577fc10ae4b00a112012a753" "577fc108e4b00a112012a6ed"
## [25] "577fc10ae4b00a112012a73f" "577fc10ae4b00a112012a751"
## [27] "577fc10ae4b00a112012a747" "577fc10ae4b00a112012a745"
## [29] "577fc10ae4b00a112012a743" "577fc10ae4b00a112012a741"
## [31] "577fc108e4b00a112012a6bd" "577fc108e4b00a112012a6bc"
## [33] "577fc108e4b00a112012a6bb" "577fc108e4b00a112012a6be"
## [35] "577fc10ae4b00a112012a749" "577fc108e4b00a112012a6d2"
## [37] "577fc108e4b00a112012a6d6" "577fc108e4b00a112012a6d4"
## [39] "577fc108e4b00a112012a6d7" "577fc108e4b00a112012a6ce"
## [41] "577fc108e4b00a112012a6cc" "577fc108e4b00a112012a6cb"
## [43] "577fc108e4b00a112012a6cf" "577fc108e4b00a112012a6e3"
## [45] "577fc108e4b00a112012a6e2" "577fc108e4b00a112012a6e1"
## [47] "577fc108e4b00a112012a6e4" "577fc108e4b00a112012a6e9"

ovrun2.ids <- ovarian.ids.not.run.before.july8[51:length(ovarian.ids.not.run.before.july8)]
ovrun2.names <- ovarian.names.not.run.before.july8[51:length(ovarian.ids.not.run.before.july8)]

############################################################
############################################################
############################################################
############################################################
# END of: "Can skip these for any new non-ovarian run"
############################################################
############################################################
############################################################
############################################################



# july 7 test of loop over 2 files:
# run.n.pipelines(tarfilenames=c("TCGA-13-0765-01A-01R-1564-13_rnaseq_fastq.tar","TCGA-13-0795-01A-01R-1564-13_rnaseq_fastq.tar"), tarfileids=c("577eb413e4b00a1120129fe3","577eb413e4b00a1120129fe2"), pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp="JSALZMAN/machete/machete-for-work", runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=2)


# ovarian50, july 8
# run.n.pipelines(tarfilenames=ov50.names, tarfileids=ov50.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp="JSALZMAN/machete/machete-for-work", runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)







# Note that this won't work anymore b/c of files added!!!
# Note that this won't work anymore b/c of files added!!!
# Note that this won't work anymore b/c of files added!!!
# Note that this won't work anymore b/c of files added!!!
all.panc.indices <- grep(pattern = "^UNCID.*\\.tar\\.gz$", x = allfilenames)
all.panc.ids <- allfileids[all.panc.indices]
all.panc.names <- allfilenames[all.panc.indices]
# 183

panc.ids.not.done.before.july8 <- setdiff(all.panc.ids, alltarids.before.july8)

# length(panc.ids.not.done.before.july8)
# 175

panc50.ids <- panc.ids.not.done.before.july8[1:50]
panc50.names <- get.filenames.from.fileids(fileids = panc50.ids, allnames=allfilenames, allids=allfileids)

# panc50, july 8
macheteapp="JSALZMAN/machete/machete-for-work-big-60GB"
# run.n.pipelines(tarfilenames=panc50.names, tarfileids=panc50.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp="JSALZMAN/machete/machete-for-work-big-60GB", runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)





# ovrun2, july 9, actually is 50 files also coincidentally
macheteapp="JSALZMAN/machete/machete-for-work-big-60GB"
# run.n.pipelines(tarfilenames=ovrun2.names, tarfileids=ovrun2.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp="JSALZMAN/machete/machete-for-work-big-60GB", runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)


# Note that not all of the first 50 finished
#  Later will see which didn't finish
# length(panc.ids.not.done.before.july8)
# [1] 175
set.seed(3678)
next.50.panc.indices <- sort(sample(x=c(51:(length(panc.ids.not.done.before.july8))), size = 50, replace = FALSE))
# next.50.panc.indices
##  [1]  53  54  58  59  60  61  62  65  66  70  79  81  85  86  89  90  93  98  99
## [20] 101 106 110 111 112 115 117 120 124 131 134 135 136 138 139 140 141 145 146
## [39] 149 151 152 153 161 162 163 164 167 169 170 172


pancrun2.ids <- panc.ids.not.done.before.july8[next.50.panc.indices]
pancrun2.names <- get.filenames.from.fileids(fileids = pancrun2.ids, allnames=allfilenames, allids=allfileids)



# pancrun2, july 9
#  running machete on i2.xlarge
macheteapp="JSALZMAN/machete/machete-for-work"
# run.n.pipelines(tarfilenames=pancrun2.names, tarfileids=pancrun2.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp="JSALZMAN/machete/machete-for-work", runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)

######################################################################
# amljuly10
######################################################################

# have to figure out the file names: 

amljuly10.indices <- grep(pattern = "^TCGA\\-AB.*_rnaseq_fastq\\.tar$", x = allfilenames)
#> length(amljuly10.indices)
# [1] 13
# 
amljuly10.ids <- allfileids[amljuly10.indices]
amljuly10.names <- allfilenames[amljuly10.indices]
macheteapp.for.this.group <- "JSALZMAN/machete/machete-for-work-big-60GB"
# run.n.pipelines(tarfilenames=amljuly10.names, tarfileids=amljuly10.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)



######################################################################
# brjuly10
######################################################################

# have to figure out the file names: 
# this is probably dependent on which files are in there also, so
#  won't work again, so I paste the ids later
# brjuly10.indices.first.pass <- grep(pattern = "^UNCID_22.*\\.tar\\.gz$", x = allfilenames); brjuly10.ids <- union(allfileids[brjuly10.indices.first.pass], c("5782787ce4b00a112012cb53","5782787ce4b00a112012cb65"))
#> length(brjuly10.indices)
# [1] 13
#

brjuly10.ids <- c("5782787ce4b00a112012cb55", "5782787ce4b00a112012cb57", "5782787ce4b00a112012cb51", "5782787be4b00a112012cb4a", "5782787be4b00a112012cb4f", "5782787ce4b00a112012cb58", "5782787be4b00a112012cb4d", "5782787ce4b00a112012cb61", "5782787ce4b00a112012cb63", "5782787ce4b00a112012cb5d", "5782787be4b00a112012cb49", "5782787ce4b00a112012cb5f", "5782787ce4b00a112012cb5b", "5782787ce4b00a112012cb53", "5782787ce4b00a112012cb65")
brjuly10.names <- get.filenames.from.fileids(fileids = brjuly10.ids, allnames=allfilenames, allids=allfileids)


#

macheteapp.for.this.group <- "JSALZMAN/machete/machete-for-work"
# run.n.pipelines(tarfilenames=brjuly10.names, tarfileids=brjuly10.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)



######################################################################
# prosjuly10 
######################################################################

# have to figure out the file names: 
# this is probably dependent on which files are in there also, so
#  won't work again, so I paste the ids later
# prosjuly10.indices <- setdiff(union(grep(pattern = "^UNCID_2189.*\\.tar\\.gz$", x = allfilenames),grep(pattern = "^UNCID_21905.*\\.tar\\.gz$", x = allfilenames)), grep(pattern = "(^UNCID_2189615.*\\.tar\\.gz|^UNCID_2189093.*\\.tar\\.gz)$", x = allfilenames)); prosjuly10.ids <- allfileids[prosjuly10.indices]
#> length(prosjuly10.indices)
# [1] 13
#

prosjuly10.ids <- c("578279b1e4b00a112012cb68", "578279b1e4b00a112012cb6a", "578279b2e4b00a112012cb72", "578279b2e4b00a112012cb73", "578279b2e4b00a112012cb7e", "578279b2e4b00a112012cb7b", "578279b2e4b00a112012cb80", "578279b2e4b00a112012cb6e", "578279b2e4b00a112012cb6c", "578279b2e4b00a112012cb76", "578279b2e4b00a112012cb78", "578279b2e4b00a112012cb7a", "578279b2e4b00a112012cb82", "578279b2e4b00a112012cb84", "578279b2e4b00a112012cb6f")

prosjuly10.names <- get.filenames.from.fileids(fileids = prosjuly10.ids, allnames=allfilenames, allids=allfileids)


macheteapp.for.this.group <- "JSALZMAN/machete/machete-for-work-big-60GB"
run.n.pipelines(tarfilenames=prosjuly10.names, tarfileids=prosjuly10.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)


######################################################################
# amlbatch2
######################################################################

# have to figure out the file names: 

# amlbatch2.indices <- grep(pattern = "^TCGA\\-AB-29.*_rnaseq_fastq\\.tar$", x = allfilenames)
#> length(amlbatch2.indices)
# [1] 15
# 
# amlbatch2.ids <- allfileids[amlbatch2.indices]

# do this manually after figuring out the above, in case
#   I add more with the above id's
amlbatch2.ids <- c("578334e6e4b00a112012cdcb", "578334e6e4b00a112012cdcd", "578334e6e4b00a112012cdbf", "578334e6e4b00a112012cdcf", "578334e6e4b00a112012cdb7", "578334e6e4b00a112012cdb9", "578334e6e4b00a112012cdb3", "578334e6e4b00a112012cdb4", "578334e6e4b00a112012cdbb", "578334e6e4b00a112012cdbd", "578334e6e4b00a112012cdc7", "578334e6e4b00a112012cdc9", "578334e6e4b00a112012cdc1", "578334e6e4b00a112012cdc2", "578334e6e4b00a112012cdc5")


amlbatch2.names <- allfilenames[amlbatch2.indices]
macheteapp.for.this.group <- "JSALZMAN/machete/machete-for-work-big-60GB"
run.n.pipelines(tarfilenames=amlbatch2.names, tarfileids=amlbatch2.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)



######################################################################
# lungjuly12
######################################################################

# have to figure out the file names: 

# lungjuly12.indices <- grep(pattern = "^UNCID_2200.*\\.tar\\.gz$", x = allfilenames)
#> length(lungjuly12.indices)
# [1] 15
# 
# lungjuly12.ids <- allfileids[lungjuly12.indices]

# do this manually after figuring out the above, in case
#   I add more with id's similar to the above id's
lungjuly12.ids <- c("57853411e4b035347bd55990", "57853411e4b035347bd55998", "57853411e4b035347bd55996", "57853411e4b035347bd55994", "57853411e4b035347bd55992", "57853411e4b035347bd55988", "57853411e4b035347bd5597e", "57853411e4b035347bd5597f", "57853411e4b035347bd55986", "57853411e4b035347bd55984", "57853411e4b035347bd55980", "57853411e4b035347bd5599a", "57853411e4b035347bd5598e", "57853411e4b035347bd5598c", "57853411e4b035347bd5598a")
lungjuly12.names <- allfilenames[lungjuly12.indices]


#macheteapp.for.this.group <- "JSALZMAN/machete/machete-for-work-big-60GB"
#run.n.pipelines(tarfilenames=lungjuly12.names, tarfileids=lungjuly12.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)




######################################################################
# amlbatch33
######################################################################

# have to figure out the file names: 

# amlbatch33.indices <- grep(pattern = "^TCGA\\-AB-29.*_rnaseq_fastq\\.tar$", x = allfilenames)
#> length(amlbatch33.indices)
# [1] 15
# 
# amlbatch33.ids <- allfileids[amlbatch33.indices]

# do this manually after figuring out the above, in case
#   I add more with the above id's
amlbatch33.ids <- c("578334e6e4b00a112012cdcb", "578334e6e4b00a112012cdcd", "578334e6e4b00a112012cdbf", "578334e6e4b00a112012cdcf", "578334e6e4b00a112012cdb7", "578334e6e4b00a112012cdb9", "578334e6e4b00a112012cdb3", "578334e6e4b00a112012cdb4", "578334e6e4b00a112012cdbb", "578334e6e4b00a112012cdbd", "578334e6e4b00a112012cdc7", "578334e6e4b00a112012cdc9", "578334e6e4b00a112012cdc1", "578334e6e4b00a112012cdc2", "578334e6e4b00a112012cdc5")


amlbatch33.names <- allfilenames[amlbatch33.indices]
macheteapp.for.this.group <- "JSALZMAN/machete/machete-for-work-big-60GB"
run.n.pipelines(tarfilenames=amlbatch33.names, tarfileids=amlbatch33.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)




######################################################################
# gbmjuly12
######################################################################

# from two queries, 15 on july 10, 7 on july 12

gbmjuly12.keys <- c("G17188", "G17189", "G17192", "G17194", "G17195", "G17196", "G17197", "G17483", "G17491", "G17786", "G17793", "G17637", "G17655", "G17645", "G17484", "G17664", "G17475", "G17788", "G17670", "G17481", "G17489", "G17636")
gbmjuly12.indices <- vector("integer", length=0)
for (ttkey in gbmjuly12.keys){
    gbmjuly12.indices <- append(gbmjuly12.indices, grep(pattern = paste0("^",ttkey), x = allfilenames))
}

gbmjuly12.ids <- allfileids[gbmjuly12.indices]

# actually do this so it is repeatable in case extra files are added
gbmjuly12.ids <- c("5785e10ce4b035347bd55a90", "5785e10ce4b035347bd55a9a", "5785e10ce4b035347bd55a97", "5785e10ce4b035347bd55a96", "5785e10ce4b035347bd55a8e", "5785e10ce4b035347bd55a91", "5785e10ce4b035347bd55a8f", "57828049e4b00a112012cb9d", "57828049e4b00a112012cba3", "57828049e4b00a112012cb99", "57828049e4b00a112012cb9a", "57828049e4b00a112012cb9f", "57828049e4b00a112012cba1", "57828049e4b00a112012cb91", "57828049e4b00a112012cb95", "57828049e4b00a112012cb97", "57828049e4b00a112012cb8f", "57828049e4b00a112012cb92", "57828049e4b00a112012cb8b", "57828049e4b00a112012cb8d", "57828049e4b00a112012cb89", "57828048e4b00a112012cb87")

gbmjuly12.names <- get.filenames.from.fileids(fileids = gbmjuly12.ids, allnames=allfilenames, allids=allfileids)


macheteapp.for.this.group <- "JSALZMAN/machete/machete-for-work-big-60GB"
run.n.pipelines(tarfilenames=gbmjuly12.names, tarfileids=gbmjuly12.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)


######################################################################
# brjuly12
######################################################################


brjuly12.keys <- c("UNCID_2206632", "UNCID_2206889", "UNCID_2206794", "UNCID_2210767", "UNCID_2206966", "UNCID_2207475", "UNCID_2203861", "UNCID_2206510", "UNCID_2206976", "UNCID_2207366", "UNCID_2206862", "UNCID_2207142", "UNCID_2206499", "UNCID_2207926", "UNCID_2207518", "UNCID_2206540", "UNCID_2210579", "UNCID_2206861")


brjuly12.indices <- vector("integer", length=0)
for (ttkey in brjuly12.keys){
    brjuly12.indices <- append(brjuly12.indices, grep(pattern = paste0("^",ttkey), x = allfilenames))
}

brjuly12.ids <- allfileids[brjuly12.indices]

# actually do this so it is repeatable in case extra files are added
brjuly12.ids <- c("5785f43ee4b035347bd55ad3", "5785f168e4b035347bd55ab4", "5785f168e4b035347bd55ab7", "5785f168e4b035347bd55a9f", "5785f168e4b035347bd55a9d", "5785f168e4b035347bd55aa0", "5785f168e4b035347bd55aa8", "5785f168e4b035347bd55ab8", "5785f168e4b035347bd55abb", "5785f168e4b035347bd55aaf", "5785f168e4b035347bd55aa6", "5785f168e4b035347bd55aad", "5785f168e4b035347bd55ab1", "5785f168e4b035347bd55ab2", "5785f168e4b035347bd55abe", "5785f168e4b035347bd55aa7", "5785f168e4b035347bd55aa5", "5785f168e4b035347bd55a9e")

brjuly12.names <- get.filenames.from.fileids(fileids = brjuly12.ids, allnames=allfilenames, allids=allfileids)


macheteapp.for.this.group <- "JSALZMAN/machete/machete-for-work-big-60GB"
run.n.pipelines(tarfilenames=brjuly12.names, tarfileids=brjuly12.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)




######################################################################
# gbm18mopup
######################################################################


# mopping up the 18 of 22 from gbmjuly12 that didn't run, probably
#   b/c of memory issues
# originally from two queries, 15 on july 10, 7 on july 12

gbm18mopup.keys <- c("G17195", "G17196", "G17197", "G17483", "G17491", "G17786", "G17793", "G17637", "G17655", "G17645", "G17484", "G17664", "G17475", "G17788", "G17670", "G17481", "G17489", "G17636")
gbm18mopup.indices <- vector("integer", length=0)
for (ttkey in  gbm18mopup.keys){
     gbm18mopup.indices <- append( gbm18mopup.indices, grep(pattern = paste0("^",ttkey), x = allfilenames))
}

gbm18mopup.ids <- allfileids[ gbm18mopup.indices]

# actually do this so it is repeatable in case extra files are added
gbm18mopup.ids <- c("5785e10ce4b035347bd55a8e", "5785e10ce4b035347bd55a91", "5785e10ce4b035347bd55a8f", "57828049e4b00a112012cb9d", "57828049e4b00a112012cba3", "57828049e4b00a112012cb99", "57828049e4b00a112012cb9a", "57828049e4b00a112012cb9f", "57828049e4b00a112012cba1", "57828049e4b00a112012cb91", "57828049e4b00a112012cb95", "57828049e4b00a112012cb97", "57828049e4b00a112012cb8f", "57828049e4b00a112012cb92", "57828049e4b00a112012cb8b", "57828049e4b00a112012cb8d", "57828049e4b00a112012cb89", "57828048e4b00a112012cb87")

gbm18mopup.names <- get.filenames.from.fileids(fileids =  gbm18mopup.ids, allnames=allfilenames, allids=allfileids)

macheteapp.for.this.group <- "JSALZMAN/machete/machete-for-work-big-60GB"
run.n.pipelines(tarfilenames= gbm18mopup.names, tarfileids= gbm18mopup.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)


######################################################################
# colonjuly13
######################################################################


# 20 samples, all with matched normal tumor samples

colonjuly13.keys <- c("UNCID_2178306.bec43388-f9ec-4039-84ad-6d1a0f557922.130405_UNC9-SN296_0354_AC24DCACXX_1_TAGCTT.tar.gz", "UNCID_2184553.590576e0-24f2-4e70-8fd9-406fdc4dff5e.130205_UNC11-SN627_0280_AC1NEKACXX_2_GATCAG.tar.gz", "UNCID_2184584.b16349cb-2b41-4235-b20f-116b8c71604f.130205_UNC11-SN627_0280_AC1NEKACXX_2_TAGCTT.tar.gz", "UNCID_2184745.ada6b8cf-fdd9-4de9-8a4b-5e8fbaaf995d.130201_UNC14-SN744_0303_AC1NVMACXX_8_TTAGGC.tar.gz", "UNCID_2185080.e63057bc-ca98-4d72-8097-1c1fb2d19882.130201_UNC14-SN744_0303_AC1NVMACXX_8_GTTTCG.tar.gz", "UNCID_2185787.86414f87-c2a2-4ecb-92eb-7663492ba76b.121129_UNC13-SN749_0201_AC15RYACXX_5_TTAGGC.tar.gz", "UNCID_2185796.6d26af33-f181-4b3f-95b9-ac3c15c96592.121129_UNC13-SN749_0201_AC15RYACXX_2_ATCACG.tar.gz", "UNCID_2185797.1493b166-ffc2-4689-8b77-a8b972b6dbc0.121129_UNC13-SN749_0201_AC15RYACXX_1_ATCACG.tar.gz", "UNCID_2185800.76dbad94-73a2-4903-8a6f-3f3b40ce6f48.121129_UNC13-SN749_0201_AC15RYACXX_1_TTAGGC.tar.gz", "UNCID_2185845.b63c5cf4-5e75-498e-b08f-ceb835b71182.121129_UNC16-SN851_0193_BC12YPACXX_7_ACTTGA.tar.gz", "UNCID_2185848.85dd63e4-f58f-401d-8a76-cabc67a06fa9.121129_UNC16-SN851_0193_BC12YPACXX_7_GTTTCG.tar.gz", "UNCID_2211799.9515a5bc-b9bc-4333-9e95-d8740283bee8.110309_UNC3-RDR300156_00080_FC_62J42AAXX_2.tar.gz", "UNCID_2212975.04ed97f2-3ea3-4e0a-b1d5-3743f2673ec8.110224_UNC6-RDR300211_00061_FC_62J3RAAXX_4.tar.gz", "UNCID_2216514.812fa79e-d5a2-4efc-9e73-9f2e0f8d9ac9.100902_UNC7-RDR3001641_00025_FC_62EPOAAXX_4.tar.gz", "UNCID_2216558.7f81eab3-eb0b-4264-98ea-46e53cbaaa8e.100902_UNC7-RDR3001641_00025_FC_62EPOAAXX_6.tar.gz", "UNCID_2217541.ad28b826-ccfe-406e-a8c1-232702fc2ddd.100813_UNC3-RDR300156_00019_FC_629UPAAXX_3.tar.gz", "UNCID_2217644.c4356a34-5215-4703-9671-d7ce0d83cf9d.100730_UNC2-RDR300275_00017_FC_629JTAAXX_3.tar.gz", "UNCID_2263082.a8d4eaf8-812e-4842-bc6d-dc7c1c07c271.130924_UNC9-SN296_0403_AC2BR8ACXX_3_TGACCA.tar.gz", "UNCID_2327172.5b345610-029c-40b8-b39a-7d6657a6866e.131118_UNC12-SN629_0336_AC31D0ACXX_5_GAGTGG.tar.gz", "UNCID_2355695.e11")

colonjuly13.indices <- vector("integer", length=0)
for (ttkey in  colonjuly13.keys){
     colonjuly13.indices <- append( colonjuly13.indices, grep(pattern = paste0("^",ttkey), x = allfilenames))
}

colonjuly13.ids <- allfileids[ colonjuly13.indices]

# actually do this so it is repeatable in case extra files are added
colonjuly13.ids <- c("5786d14ce4b035347bd55cad", "5786d14ce4b035347bd55cb1", "5786d14ce4b035347bd55cb5", "5786d14ce4b035347bd55ca4", "5786d14ce4b035347bd55cb3", "5786d14ce4b035347bd55cc1", "5786d14ce4b035347bd55cb7", "5786d14ce4b035347bd55cb9", "5786d14ce4b035347bd55cbf", "5786d14ce4b035347bd55ca3", "5786d14ce4b035347bd55caf", "5786d14ce4b035347bd55c9b", "5786d14ce4b035347bd55cbd", "5786d14ce4b035347bd55cab", "5786d14ce4b035347bd55ca9", "5786d14ce4b035347bd55c9c", "5786d14ce4b035347bd55cbb", "5786d14ce4b035347bd55c9d", "5786d14ce4b035347bd55ca7", "5786d14ce4b035347bd55c9e")

colonjuly13.names <- get.filenames.from.fileids(fileids =  colonjuly13.ids, allnames=allfilenames, allids=allfileids)


macheteapp.for.this.group <- "JSALZMAN/machete/machete-for-work-big-60GB"
run.n.pipelines(tarfilenames= colonjuly13.names, tarfileids= colonjuly13.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)



######################################################################
# gbmjuly19
######################################################################

# 53 samples, randomly chosen out of 135 gbm's not run
#   before july 19; no gbm's at all have matched normals



# from datasetapi.R:
#  Note also that I manually changed the first one, b/c
#  I had forgotten to delete the test case, and then it gave
#  a _1_ thing, so I deleted that, so then have to change the file id

gbmjuly19.ids <- c("578eb8b9e4b02380c59dd8bd", "578eb8cfe4b02380c59dd8c1", "578eb8d0e4b02380c59dd8c3", "578eb8d0e4b02380c59dd8c5", "578eb8d1e4b02380c59dd8c7", "578eb8d2e4b02380c59dd8c9", "578eb8d2e4b02380c59dd8cb", "578eb8d3e4b02380c59dd8cd", "578eb8d4e4b02380c59dd8cf", "578eb8d4e4b02380c59dd8d1", "578eb8d5e4b02380c59dd8d3", "578eb8d5e4b02380c59dd8d5", "578eb8d6e4b02380c59dd8d7", "578eb8d6e4b02380c59dd8d9", "578eb8d7e4b02380c59dd8db", "578eb8d7e4b02380c59dd8dd", "578eb8d8e4b02380c59dd8df", "578eb8d8e4b02380c59dd8e1", "578eb8d9e4b02380c59dd8e3", "578eb8dae4b02380c59dd8e5", "578eb8dae4b02380c59dd8e7", "578eb8dbe4b02380c59dd8e9", "578eb8dbe4b02380c59dd8eb", "578eb8dce4b02380c59dd8ed", "578eb8dce4b02380c59dd8ef", "578eb8dde4b02380c59dd8f1", "578eb8dde4b02380c59dd8f3", "578eb8dee4b02380c59dd8f5", "578eb8dfe4b02380c59dd8f7", "578eb8dfe4b02380c59dd8f9", "578eb8e0e4b02380c59dd8fb", "578eb8e0e4b02380c59dd8fd", "578eb8e1e4b02380c59dd8ff", "578eb8e1e4b02380c59dd901", "578eb8e2e4b02380c59dd903", "578eb8e2e4b02380c59dd905", "578eb8e3e4b02380c59dd907", "578eb8e3e4b02380c59dd909", "578eb8e4e4b02380c59dd90b", "578eb8e4e4b02380c59dd90d", "578eb8e5e4b02380c59dd90f", "578eb8e6e4b02380c59dd911", "578eb8e6e4b02380c59dd913", "578eb8e6e4b02380c59dd915", "578eb8e7e4b02380c59dd917", "578eb8e8e4b02380c59dd919", "578eb8e8e4b02380c59dd91b", "578eb8e8e4b02380c59dd91d", "578eb8e9e4b02380c59dd91f", "578eb8e9e4b02380c59dd921", "578eb8eae4b02380c59dd923", "578eb8ebe4b02380c59dd925", "578eb8ebe4b02380c59dd927")

gbmjuly19.names <- get.filenames.from.fileids(fileids =  gbmjuly19.ids, allnames=allfilenames, allids=allfileids)

macheteapp.for.this.group <- "JSALZMAN/machete/machete-for-work-big-60GB"

run.n.pipelines(tarfilenames= gbmjuly19.names, tarfileids= gbmjuly19.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)


######################################################################
# lungjuly22
######################################################################

# have to figure out the file names: 

# lungjuly22.indices <- grep(pattern = "^UNCID_2200.*\\.tar\\.gz$", x = allfilenames)
#> length(lungjuly22.indices)
# [1] 15
# 
# lungjuly22.ids <- allfileids[lungjuly22.indices]

# do this manually after figuring out the above, in case
#   I add more with id's similar to the above id's
# 17 of these
lungjuly22.ids <- c("57929d38e4b02380c5a05441", "57929d39e4b02380c5a05443", "57929d3ae4b02380c5a05445", "57929d3ae4b02380c5a05447", "57929d3be4b02380c5a05449", "57929d3ce4b02380c5a0544b", "57929d3ce4b02380c5a0544d", "57929d3de4b02380c5a0544f", "57929d3ee4b02380c5a05451", "57929d3ee4b02380c5a05453", "57929d3fe4b02380c5a05455", "57929d40e4b02380c5a05457", "57929d41e4b02380c5a05459", "57929d41e4b02380c5a0545b", "57929d42e4b02380c5a0545d", "57929d42e4b02380c5a0545f", "57929d43e4b02380c5a05461")


lungjuly22.names <- get.filenames.from.fileids(fileids =  lungjuly22.ids, allnames=allfilenames, allids=allfileids)

macheteapp.for.this.group <- "JSALZMAN/machete/machete-for-work-big-60GB"

run.n.pipelines(tarfilenames= lungjuly22.names, tarfileids= lungjuly22.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)









######################################################################
# lungjuly26
######################################################################

# have to figure out the file names: 

# lungjuly26.indices <- grep(pattern = "^UNCID_2200.*\\.tar\\.gz$", x = allfilenames)
#> length(lungjuly26.indices)
# [1] 15
# 
# lungjuly26.ids <- allfileids[lungjuly26.indices]

# do this manually after figuring out the above, in case
#   I add more with id's similar to the above id's
# there are 17 of these, same as for lungjuly22.ids
lungjuly26.ids <- c("57929d38e4b02380c5a05441", "57929d39e4b02380c5a05443", "57929d3ae4b02380c5a05445", "57929d3ae4b02380c5a05447", "57929d3be4b02380c5a05449", "57929d3ce4b02380c5a0544b", "57929d3ce4b02380c5a0544d", "57929d3de4b02380c5a0544f", "57929d3ee4b02380c5a05451", "57929d3ee4b02380c5a05453", "57929d3fe4b02380c5a05455", "57929d40e4b02380c5a05457", "57929d41e4b02380c5a05459", "57929d41e4b02380c5a0545b", "57929d42e4b02380c5a0545d", "57929d42e4b02380c5a0545f", "57929d43e4b02380c5a05461")


lungjuly26.names <- get.filenames.from.fileids(fileids =  lungjuly26.ids, allnames=allfilenames, allids=allfileids)

macheteapp.for.this.group <- "JSALZMAN/machete/machete-for-work-big-60GB"

run.n.pipelines(tarfilenames= lungjuly26.names, tarfileids= lungjuly26.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)





# error I got before using github version of sb library
##    pipe.unpack.task <- mm$task_add(name = name.unpacking.task, description = paste("Unpacking the tar file", intarname),  app = unpackapp, inputs = list(input_archive_file=Files(id=intarpath, name=intarname)))
## checking inputs ...
## API: getting app input information ...
## checking ...
## check id match
## Task drafting ...
## Error in envRefSetField(.Object, field, classDef, selfEnv, elements[[field]]) : 
##   ‘warnings’ is not a field in class “Task”
## > traceback()
## 10: stop(gettextf("%s is not a field in class %s", sQuote(field), 
##         dQuote(thisClass@className)), domain = NA)
## 9: envRefSetField(.Object, field, classDef, selfEnv, elements[[field]])
## 8: methods::initRefFields(.Object, classDef, selfEnv, list(...))
## 7: initialize(value, ...)
## 6: initialize(value, ...)
## 5: new("Task", ...)
## 4: (function (...) 
##    new("Task", ...))(href = "https://cgc-api.sbgenomics.com/v2/tasks/6c0d3d20-c789-4c65-abc7-6192e0d0ba02", 
##        id = "6c0d3d20-c789-4c65-abc7-6192e0d0ba02", name = "Unpacking of UNCID_2193652.51eae0de-8f16-4093-b42e-5c34c4768459.120405_UNC10-SN254_0345_AD0VAVACXX_7_GGCTAC.tar.gz from group lungjuly26; drafted at Jul262340", 
##        description = "Unpacking the tar file UNCID_2193652.51eae0de-8f16-4093-b42e-5c34c4768459.120405_UNC10-SN254_0345_AD0VAVACXX_7_GGCTAC.tar.gz", 
##        status = "DRAFT", project = "JSALZMAN/machete", app = "JSALZMAN/machete/sbg-unpack-fastqs-1-0/3", 
##        type = "v2", created_by = "JSALZMAN", start_time = "2016-07-27T06:54:41Z", 
##        batch = FALSE, errors = list(), warnings = list(), inputs = list(
##            input_archive_file = list(class = "File", path = "57929d38e4b02380c5a05441", 
##                name = "UNCID_2193652.51eae0de-8f16-4093-b42e-5c34c4768459.120405_UNC10-SN254_0345_AD0VAVACXX_7_GGCTAC.tar.gz", 
##                size = 4543750652)), outputs = list(output_fastq_files = NULL))
## 3: do.call(Task, x)
## 2: .asTask(res)
## 1: mm$task_add(name = name.unpacking.task, description = paste("Unpacking the tar file", 
##        intarname), app = unpackapp, inputs = list(input_archive_file = Files(id = intarpath, 
##        name = intarname)))

                                                            



######################################################################
## normalsjuly29
## these are lung normals
######################################################################

# Do a group of these, but maybe also do one by itself in case
#  something goes wrong; seemed like something weird happened
#  last time when drafting the machete

normalsjuly29.ids <- c("579b932ee4b0dac228481ee2", "579b932fe4b0dac228481ee4", "579b932fe4b0dac228481ee6", "579b9330e4b0dac228481ee8", "579b9330e4b0dac228481eea", "579b9330e4b0dac228481eec", "579b9331e4b0dac228481eee", "579b9331e4b0dac228481ef0", "579b9332e4b0dac228481ef2", "579b9332e4b0dac228481ef4", "579b9333e4b0dac228481ef6", "579b9333e4b0dac228481ef8", "579b9333e4b0dac228481efa", "579b9334e4b0dac228481efc", "579b9334e4b0dac228481efe", "579b9335e4b0dac228481f00")




normalsjuly29.names <- get.filenames.from.fileids(fileids =  normalsjuly29.ids, allnames=allfilenames, allids=allfileids)

macheteapp.for.this.group <- "JSALZMAN/machete/machete-for-work-big-60GB"

run.n.pipelines(tarfilenames= normalsjuly29.names, tarfileids= normalsjuly29.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)


single.case.july29.normal <- c("579b9335e4b0dac228481f02")

# do this one by itself:
# "579b9335e4b0dac228481f02"
# UNCID_2199377.0b78c265-393c-4e3a-a53e-3ba76556c506.111229_UNC15-SN850_0157_AD0MHHACXX_5_TAGCTT.tar.gz





######################################################################
# amlaug1
######################################################################

amlaug1.ids <- c("579f965ee4b05eca73486dcc", "579f965ee4b05eca73486dce", "579f965fe4b05eca73486dd0", "579f965fe4b05eca73486dd2", "579f9660e4b05eca73486dd4", "579f9660e4b05eca73486dd6", "579f9661e4b05eca73486dd8", "579f9661e4b05eca73486dda", "579f9661e4b05eca73486ddc", "579f9662e4b05eca73486dde", "579f9662e4b05eca73486de0", "579f9663e4b05eca73486de2", "579f9663e4b05eca73486de4", "579f9664e4b05eca73486de6", "579f9664e4b05eca73486de8")

amlaug1.names <- get.filenames.from.fileids(fileids =  amlaug1.ids, allnames=allfilenames, allids=allfileids)

macheteapp.for.this.group <- "JSALZMAN/machete/machete-for-work-big-60GB"

run.n.pipelines(tarfilenames= amlaug1.names, tarfileids= amlaug1.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)


######################################################################
# amlnotdoneaug1
######################################################################


amlnotdoneaug1.ids <- amlaug1.ids[c(5,8,10,11,12,13,15)]

amlnotdoneaug1.names <- amlaug1.names[c(5,8,10,11,12,13,15)]

## [1] "579f9660e4b05eca73486dd4" "579f9661e4b05eca73486dda"
## [3] "579f9662e4b05eca73486dde" "579f9662e4b05eca73486de0"
## [5] "579f9663e4b05eca73486de2" "579f9663e4b05eca73486de4"
## [7] "579f9664e4b05eca73486de8"

## amlnotdoneaug1.names
## [1] "TCGA-AB-2803-03A-01T-0734-13_rnaseq_fastq.tar"
## [2] "TCGA-AB-2969-03A-01T-0734-13_rnaseq_fastq.tar"
## [3] "TCGA-AB-2930-03A-01T-0740-13_rnaseq_fastq.tar"
## [4] "TCGA-AB-2820-03A-01T-0735-13_rnaseq_fastq.tar"
## [5] "TCGA-AB-3008-03A-01T-0736-13_rnaseq_fastq.tar"
## [6] "TCGA-AB-2876-03A-01T-0734-13_rnaseq_fastq.tar"
## [7] "TCGA-AB-2919-03A-01T-0740-13_rnaseq_fastq.tar"



macheteapp.for.this.group <- "JSALZMAN/machete/machete-for-work-big-60GB"

run.n.pipelines(tarfilenames= amlnotdoneaug1.names, tarfileids= amlnotdoneaug1.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)




######################################################################
# prosaug5
# from aliquot ids from paper
######################################################################


prosaug5.ids <- c("57a4dface4b05eca734c1847", "57a4dface4b05eca734c1849", "57a4dfade4b05eca734c184b", "57a4dfade4b05eca734c184d", "57a4dfade4b05eca734c184f", "57a4dfaee4b05eca734c1851", "57a4dfaee4b05eca734c1853", "57a4dfafe4b05eca734c1855", "57a4dfafe4b05eca734c1857", "57a4dfb0e4b05eca734c1859", "57a4dfb0e4b05eca734c185b", "57a4dfb0e4b05eca734c185d", "57a4dfb1e4b05eca734c185f", "57a4dfb1e4b05eca734c1861", "57a4dfb2e4b05eca734c1863")

prosaug5.names <- c("UNCID_2190559.26c39f49-cf54-41d6-8c46-c089f4a57002.120223_UNC12-SN629_0186_AC0GA2ACXX_5_GCCAAT.tar.gz", "UNCID_2190593.e129e211-8237-4842-a5f5-c3dc05607527.111219_UNC11-SN627_0175_BC0CKKACXX_4_CAGATC.tar.gz", "UNCID_2190511.b8cc1fb1-5944-431c-aeec-a4301721f667.120502_UNC14-SN744_0235_BD0YUTACXX_5_ACTTGA.tar.gz", "UNCID_2190658.78808f76-820b-439f-8223-38f2899cad5f.111216_UNC10-SN254_0314_AD0JVAACXX_2_ACTTGA.tar.gz", "UNCID_2190676.2d12fd80-ba3f-49c3-aa15-1f67b9bbd443.120223_UNC12-SN629_0186_AC0GA2ACXX_8_GATCAG.tar.gz", "UNCID_2190673.f659e8f2-3d29-4170-bd40-84e54c70fcd4.120425_UNC11-SN627_0224_BD0VAKACXX_6_GATCAG.tar.gz", "UNCID_2235475.743ad0e2-903e-4438-a575-1f06c286c079.120425_UNC11-SN627_0224_BD0VAKACXX_7_GATCAG.tar.gz", "UNCID_2190566.1059fbc0-46bf-4135-99d0-080ec225391b.120215_UNC10-SN254_0327_AC0CMCACXX_5_GATCAG.tar.gz", "UNCID_2235687.86961468-9e93-469a-b812-03ef327bf5fb.120215_UNC10-SN254_0327_AC0CMCACXX_7_GATCAG.tar.gz", "UNCID_2190555.487c555b-81bb-4b70-8219-9abac8394b9f.120223_UNC12-SN629_0186_AC0GA2ACXX_7_TAGCTT.tar.gz", "UNCID_2190549.f4463436-536d-412e-824c-0c623a244da5.120425_UNC11-SN627_0224_BD0VAKACXX_4_TAGCTT.tar.gz", "UNCID_2235383.f1441277-65a1-486c-b8e1-2b947734cb17.120502_UNC14-SN744_0235_BD0YUTACXX_2_TAGCTT.tar.gz", "UNCID_2190506.c88d608d-79c7-41af-a3b3-e27b413cba28.120502_UNC14-SN744_0235_BD0YUTACXX_3_TAGCTT.tar.gz", "UNCID_2190494.8536a0fb-4aed-4db0-80b0-994606c87ace.120502_UNC14-SN744_0235_BD0YUTACXX_5_TAGCTT.tar.gz", "UNCID_2190614.67816085-c038-4c4f-86f0-b03e6da18aee.111219_UNC11-SN627_0175_BC0CKKACXX_1_ACTTGA.tar.gz")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-for-work-big-60GB"

run.n.pipelines(tarfilenames= prosaug5.names, tarfileids= prosaug5.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)



######################################################################
# breaug5
# from aliquot ids from paper
######################################################################


breaug5.ids <- c("57a51fa0e4b05eca734c96ed", "57a51fa0e4b05eca734c96ef", "57a51fa0e4b05eca734c96f1", "57a51fa1e4b05eca734c96f3", "57a51fa1e4b05eca734c96f5", "57a51fa2e4b05eca734c96f7", "57a51fa2e4b05eca734c96f9", "57a51fa2e4b05eca734c96fb", "57a51fa3e4b05eca734c96fd", "57a51fa3e4b05eca734c96ff")

breaug5.names <- c("UNCID_2206776.4c1d73ba-31f8-4652-a83d-cc367dde9f43.110912_UNC13-SN749_0111_AD0DEAABXX_5.tar.gz", "UNCID_2206525.7391b882-0be5-45b0-aa01-43c3381a476d.110919_UNC13-SN749_0113_AB00WUABXX_1_CGATGT.tar.gz", "UNCID_2206832.c2db17b1-c288-4f73-8e22-22929d846678.110829_UNC10-SN254_0271_AC00PWABXX_3_CTTGTA.tar.gz", "UNCID_2206871.a521a6fa-da2b-48ef-94e8-3307030427b6.110824_UNC13-SN749_0098_AC03YVABXX_5.tar.gz", "UNCID_2207028.ef84a69f-37bc-46fa-98ac-b3976212e11d.110801_UNC12-SN629_0115_BD0DVEABXX_4_ACAGTG.tar.gz", "UNCID_2207146.120bc298-f016-4c80-aa5f-a9006444942c.110715_UNC10-SN254_0245_BD0DG6ABXX_3.tar.gz", "UNCID_2206503.3078c384-b624-4f5a-ae36-fc896212e616.110921_UNC9-SN296_0242_AD0DDEABXX_7_TGACCA.tar.gz", "UNCID_2206939.df661ba2-098b-49e0-884c-27cf2ecd87f2.110805_UNC11-SN627_0135_BD0DKJABXX_1_ACTTGA.tar.gz", "UNCID_2207416.9fa440b0-6e8d-4c48-a425-50abc2682f6e.110711_UNC10-SN254_0242_AD0DK5ABXX_1.tar.gz", "UNCID_2206622.f18b2ff7-eddb-40b5-9bbe-7ef09787ddef.111003_UNC13-SN749_0121_AB020YABXX_2_TAGCTT.tar.gz")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-for-work"

run.n.pipelines(tarfilenames= breaug5.names, tarfileids= breaug5.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)






######################################################################
# prosnormalsaug7
# 4 normals matching previous runs plus 6 new matched normals
######################################################################


prosnormalsaug7.ids <- c("57a7b986e4b05eca734dd5e4", "57a7b986e4b05eca734dd5e6", "57a7b987e4b05eca734dd5e8", "57a7b987e4b05eca734dd5ea", "57a7b988e4b05eca734dd5ec", "57a7b988e4b05eca734dd5ee", "57a7b988e4b05eca734dd5f0", "57a7b989e4b05eca734dd5f2", "57a7b989e4b05eca734dd5f4", "57a7b98ae4b05eca734dd5f6")
## have to split into parts because of weird control G thing:
names.prosnormalaug7.part1 <- c("UNCID_2190663.3c3a7016-6270-4c87-af7d-53b46f7f8fd1.120223_UNC12-SN629_0186_AC0GA2ACXX_7_GATCAG.tar.gz", "UNCID_2339220.4e169e09-37da-42c9-bed4-2649212d9c6b.130221_UNC9-SN296_0338_BC1PYCACXX_8_ACAGTG.tar.gz", "UNCID_2190620.40c411e7-c0cb-4aff-8418-fd7400562bad.111219_UNC11-SN627_0175_BC0CKKACXX_2_ACTTGA.tar.gz", "UNCID_2189557.12358445-06b8-4055-8454-69b8544774fc.120521_UNC12-SN629_0212_AC0RWNACXX_4_CAGATC.tar.gz", "UNCID_2190618.f2ad4c22-c476-44af-a8ca-dffcae313ae2.111212_UNC15-SN850_0155_AD087AACXX_8_ACTTGA.tar.gz") 

names.prosnormalaug7.part2 <- c("UNCID_2189823.e95f79a8-15ea-4b95-9f8e-b63ada04c51e.120508_UNC13-SN749_0172_AD101FACXX_7_GATCAG.tar.gz", "UNCID_2187739.575740a1-6467-4f58-b462-6fd1a4f63c51.120814_UNC12-SN629_0220_AD13JAACXX_1_CTTGTA.tar.gz", "UNCID_2339218.d5a6b5e2-f1af-4b1f-bfbe-2b3c05f3f642.130226_UNC14-SN744_0315_AD1V5TACXX_5_TTAGGC.tar.gz", "UNCID_2339219.6b264e41-b852-4221-8e09-692a6a639ccf.130226_UNC14-SN744_0315_AD1V5TACXX_5_CGATGT.tar.gz", "UNCID_2339217.1eda4d9f-e9a1-4ee7-8c71-559c8940b751.130226_UNC14-SN744_0315_AD1V5TACXX_6_TGACCA.tar.gz")

prosnormalsaug7.names <- c(names.prosnormalaug7.part1, names.prosnormalaug7.part2)

macheteapp.for.this.group <- "JSALZMAN/machete/machete-for-work-big-60GB"

run.n.pipelines(tarfilenames= prosnormalsaug7.names, tarfileids= prosnormalsaug7.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)



######################################################################
# lungnormalsaug10
## BUT I MADE A MISTAKE- THESE ARE ACTUALLY TUMOR
## BUT I MADE A MISTAKE- THESE ARE ACTUALLY TUMOR
# 4 normals matching previous runs plus 6 new matched normals
######################################################################

lungnormalsaug10.ids <- c("57a91b11e4b054ebb03814e9", "57a91b12e4b054ebb03814eb", "57a91b12e4b054ebb03814ed", "57a91b13e4b054ebb03814ef", "57a91b13e4b054ebb03814f1", "57a91b13e4b054ebb03814f3", "57a91b14e4b054ebb03814f5", "57a91b14e4b054ebb03814f7", "57a91b15e4b054ebb03814f9", "57a91b15e4b054ebb03814fb")

lungnormalsaug10.names <- c("UNCID_2200473.5969b621-a81e-42aa-ac40-4849df285060.111130_UNC10-SN254_0310_BC06BYACXX_2_TTAGGC.tar.gz", "UNCID_2188026.bc6c762f-727f-43c8-a4bc-4c41351c7f13.120724_UNC11-SN627_0247_AC0Y10ACXX_2_GATCAG.tar.gz", "UNCID_2200118.4502921a-1650-4721-b814-c9435fe6042d.111208_UNC10-SN254_0313_BD087RACXX_1_TTAGGC.tar.gz", "UNCID_2200550.29af0307-5d76-462d-beee-18e8c4f179b8.111118_UNC11-SN627_0168_BC059VACXX_8_ATCACG.tar.gz", "UNCID_2197655.4f5215c3-7763-49f8-afe7-b3ce3474afe2.120113_UNC14-SN744_0200_AC0F4CACXX_2_CTTGTA.tar.gz", "UNCID_2206635.847f00ce-5f09-4e12-90c5-ebdf7612d707.111003_UNC9-SN296_0247_BB01WJABXX_3_ACTTGA.tar.gz", "UNCID_2197271.8b0a1ab6-e7ea-45f9-9e3a-bd98b3f59972.111122_UNC13-SN749_0137_BD098JACXX_1_GATCAG.tar.gz", "UNCID_2198771.bf920e10-514e-4623-b92e-c83a3e32485f.120104_UNC16-SN851_0120_BD0J72ACXX_1_ATCACG.tar.gz", "UNCID_2200852.c54cd39c-c7fc-4a0c-9d33-9c1f78c80871.111122_UNC16-SN851_0111_BD09J2ACXX_8_TTAGGC.tar.gz", "UNCID_2200262.e3958992-3206-4cdd-8bc9-38fd43853800.111129_UNC10-SN254_0309_AD095JACXX_7_ATCACG.tar.gz")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-for-work"

run.n.pipelines(tarfilenames= lungnormalsaug10.names, tarfileids= lungnormalsaug10.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)











######################################################################
# lungnormalsaug11
##
## do two of these separately to test if can fix this type of 
## error:
## [1] "Working on loop 85 ; max.iterations = 200 \n"
## [1] "Working on loop 88 ; max.iterations = 200 \n"
## [1] "Working on loop 91 ; max.iterations = 200 \n"
## Error in fromJSON(content, handler, default.size, depth, allowComments,  : 
##   invalid JSON input
## Calls: get.infile.names.and.ids ... <Anonymous> -> <Anonymous> -> fromJSON -> fromJSON -> .Call
## Execution halted 

######################################################################

lungnormalsaug11.ids <-  c("57acefa1e4b054ebb03943ee", "57acefa2e4b054ebb03943f0", "57acefa2e4b054ebb03943f2", "57acefa3e4b054ebb03943f4", "57acefa3e4b054ebb03943f6", "57acefa4e4b054ebb03943f8", "57acefa4e4b054ebb03943fa", "57acefa5e4b054ebb03943fc")

lungnormalsaug11.names <- c("UNCID_2197545.e448d6d2-be85-4164-be3f-fd7e5a0c53ec.120113_UNC14-SN744_0200_AC0F4CACXX_3_TGACCA.tar.gz", "UNCID_2199986.c6722ce9-8824-4721-9e95-96e9b0b09066.111208_UNC10-SN254_0312_AD0JRVACXX_3_GATCAG.tar.gz", "UNCID_2200018.2f16ddcc-8a98-4734-9878-645ff102fb14.111208_UNC10-SN254_0312_AD0JRVACXX_2_ATCACG.tar.gz", "UNCID_2187834.ca16fef9-9795-4a33-899f-9bf111ee093e.120723_UNC10-SN254_0372_AC0T70ACXX_7_GATCAG.tar.gz", "UNCID_2197175.0569af63-9a1d-4f03-9a67-1269c7973677.111122_UNC13-SN749_0137_BD098JACXX_5_GGCTAC.tar.gz", "UNCID_2199338.2b7e9552-e34f-4c68-96af-1c01a605df60.111229_UNC15-SN850_0157_AD0MHHACXX_7_TGACCA.tar.gz", "UNCID_2197582.d777ced1-c519-4281-b0c0-9e9188303e87.120113_UNC14-SN744_0200_AC0F4CACXX_5_ACAGTG.tar.gz", "UNCID_2198729.b3b1d4f3-1511-40a5-bf62-0ddf0893eac5.120104_UNC16-SN851_0120_BD0J72ACXX_4_TGACCA.tar.gz")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-for-work"

run.n.pipelines(tarfilenames= lungnormalsaug11.names, tarfileids= lungnormalsaug11.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)



## didn't do these yet, as of aug 15:

lungnormalsaug11.for.testing.with.tries.ids <- c("57acefa5e4b054ebb03943fe", "57acefa6e4b054ebb0394400")

lungnormalsaug11.for.testing.with.tries.names <- c("UNCID_2198748.0ab304f8-0976-4637-8955-199e1782ab16.120104_UNC16-SN851_0120_BD0J72ACXX_3_TAGCTT.tar.gz", "UNCID_2199367.fc4df3f7-2c4b-4a4d-9e5d-faac9e84fde8.111229_UNC15-SN850_0157_AD0MHHACXX_4_TTAGGC.tar.gz")


macheteapp.for.this.group <- "JSALZMAN/machete/machete-for-work"

run.n.pipelines(tarfilenames= lungnormalsaug11.for.testing.with.tries.names, tarfileids= lungnormalsaug11.for.testing.with.tries.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)




######################################################################
# lymphoma
## aug 15

######################################################################

lymphaug15.ids <-  c("57b25cafe4b0192c34a4b2c7", "57b25cb0e4b0192c34a4b2c9", "57b25cb0e4b0192c34a4b2cb", "57b25cb1e4b0192c34a4b2cd", "57b25cb1e4b0192c34a4b2cf", "57b25cb2e4b0192c34a4b2d1", "57b25cb2e4b0192c34a4b2d3", "57b25cb3e4b0192c34a4b2d5", "57b25cb3e4b0192c34a4b2d7", "57b25cb3e4b0192c34a4b2d9")

lymphaug15.names <- c("UNCID_2272258.144739d3-b2d3-493c-8731-d652f03a5b37.130926_SN254_0496_AD2DY9ACXX_6_ACAGTG.tar.gz", "UNCID_2581261.bc8a3747-bd29-4388-94b9-74d92b6db3a3.140509_UNC12-SN629_0368_BC4241ACXX_5_GCCAAT.tar.gz", "UNCID_2272264.c6930a35-3476-46a0-adde-da76ee758390.130909_UNC15-SN850_0327_BD2DT1ACXX_8_ACAGTG.tar.gz", "UNCID_2272274.5bce51af-fa6e-4fd2-b3b0-114eb8a275a9.130814_UNC10-SN254_0487_AC2BD1ACXX_3_TGACCA.tar.gz", "UNCID_2272268.95db81b0-d9e6-4cbf-b13f-7c1b92c26484.130909_UNC15-SN850_0327_BD2DT1ACXX_6_CGATGT.tar.gz", "UNCID_2272266.52ece957-8f21-4f13-a61d-7b2e1c850ef5.130909_UNC15-SN850_0327_BD2DT1ACXX_7_GCCAAT.tar.gz", "UNCID_2580232.827ebf10-230a-442b-aaae-80e1e0210bb5.140521_UNC13-SN749_0354_BC4GJ7ACXX_1_GATCAG.tar.gz", "UNCID_2580360.a3ca2450-1f4e-4372-bdd4-46f83e2e9602.140603_UNC11-SN627_0360_AC4H72ACXX_5_CAGATC.tar.gz", "UNCID_2272273.d15202c0-099f-46c9-99c0-cc6bdf3e82b1.130814_UNC10-SN254_0487_AC2BD1ACXX_4_CTTGTA.tar.gz", "UNCID_2580725.7c955c67-e0be-4c07-b0e9-b70da3a7f116.140603_UNC15-SN850_0369_BC4H6YACXX_6_AGTCAA.tar.gz")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-for-work"

run.n.pipelines(tarfilenames= lymphaug15.names, tarfileids= lymphaug15.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)

######################################################################
# sqaug16  machete-light
# testing out machete-light
## Lung Squamous Cell Carcinoma
## in the 9 files below, start using downloading of FJ files
##i.e. the function download.reports.and.fasta.and.outputfjfiles.one.task
######################################################################
  

sqmachetelightaug16firstone.ids <- c("57b35e24e4b0192c34a4b60b")


sqmachetelightaug16firstone.names <- c("UNCID_2206830.b936c3f0-795b-4128-bca0-b797b3d86f8d.110729_UNC11-SN627_0130_ACG487ABXX_5.tar.gz")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

run.n.pipelines(tarfilenames= sqmachetelightaug16firstone.names, tarfileids= sqmachetelightaug16firstone.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)





### these are the 9 other ones:


sqmachetelightaug16.ids <- c("57b35e25e4b0192c34a4b60d", "57b35e25e4b0192c34a4b60f", "57b35e26e4b0192c34a4b611", "57b35e26e4b0192c34a4b613", "57b35e27e4b0192c34a4b615", "57b35e27e4b0192c34a4b617", "57b35e27e4b0192c34a4b619", "57b35e28e4b0192c34a4b61b", "57b35e28e4b0192c34a4b61d")


sqmachetelightaug16.names <- c("UNCID_2206709.7db69d77-75ce-4f75-9e95-7205c55e5e6d.110923_UNC13-SN749_0118_BC04BNABXX_6_GATCAG.tar.gz", "UNCID_2181252.f3c5b879-2ca4-4d16-972b-6ed8f82b97a1.130304_UNC16-SN851_0221_BD1VDMACXX_4_AGTTCC.tar.gz", "UNCID_2212595.27e89ada-fc8b-484f-8570-c26af5434438.110223_UNC9-SN296_0153_A81FMUABXX_3.tar.gz", "UNCID_2207116.88d40fcc-c30a-437f-b514-ef0a60f8836e.110726_UNC12-SN629_0112_AC03YWABXX_3.tar.gz", "UNCID_2206706.25361c46-91f3-4b7b-80e0-ef8576ce00c1.110923_UNC13-SN749_0118_BC04BNABXX_8_GATCAG.tar.gz", "UNCID_2194734.b7d58bd2-216f-4fdf-b97e-56d9cfb69e3b.120313_UNC9-SN296_0281_BD0UM8ACXX_6_ATCACG.tar.gz", "UNCID_2206700.17d5f5c9-ed12-4dd7-810e-601b7545b47f.110923_UNC13-SN749_0117_AD0DRLABXX_7_ACTTGA.tar.gz", "UNCID_2651465.265c0257-54b6-4b79-8c9a-d56ca8bbdb48.131021_UNC9-SN296_0409_BC2M6NACXX_7_GTCCGC.tar.gz", "UNCID_2206817.87fc2c1d-3072-40fb-bc36-5b7a5604d4d7.110729_UNC11-SN627_0131_BD0DV6ABXX_6_ACAGTG.tar.gz")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

run.n.pipelines(tarfilenames= sqmachetelightaug16.names, tarfileids= sqmachetelightaug16.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)



######################################################################
# 20 ovarian
## ovaug18
## uses regular machete
## get ids from datasetapi.R
######################################################################

ovaug18.ids <-  c("57b5dd54e4b0192c34a4ee2b", "57b5dd55e4b0192c34a4ee2d", "57b5dd55e4b0192c34a4ee2f", "57b5dd55e4b0192c34a4ee31", "57b5dd56e4b0192c34a4ee33", "57b5dd56e4b0192c34a4ee35", "57b5dd57e4b0192c34a4ee37", "57b5dd57e4b0192c34a4ee39", "57b5dd58e4b0192c34a4ee3b", "57b5dd58e4b0192c34a4ee3d", "57b5dd58e4b0192c34a4ee3f", "57b5dd59e4b0192c34a4ee41", "57b5dd59e4b0192c34a4ee43", "57b5dd5ae4b0192c34a4ee45", "57b5dd5ae4b0192c34a4ee47", "57b5dd5be4b0192c34a4ee49", "57b5dd5be4b0192c34a4ee4b", "57b5dd5ce4b0192c34a4ee4d", "57b5dd5ce4b0192c34a4ee4f", "57b5dd5ce4b0192c34a4ee51")
    
ovaug18.names <- c("TCGA-23-1026-01B-01R-1569-13_rnaseq_fastq.tar", "TCGA-13-0924-01A-01R-1564-13_rnaseq_fastq.tar", "TCGA-13-0890-01A-01R-1564-13_rnaseq_fastq.tar", "TCGA-24-0979-01A-01R-1565-13_rnaseq_fastq.tar", "TCGA-24-1544-01A-01R-1566-13_rnaseq_fastq.tar", "TCGA-36-1578-01A-01R-1566-13_rnaseq_fastq.tar", "TCGA-29-1778-01A-01R-1567-13_rnaseq_fastq.tar", "TCGA-13-1499-01A-01R-1565-13_rnaseq_fastq.tar", "TCGA-13-1507-01A-01R-1565-13_rnaseq_fastq.tar", "TCGA-23-1113-01A-01R-1564-13_rnaseq_fastq.tar", "TCGA-20-1686-01A-01R-1566-13_rnaseq_fastq.tar", "TCGA-09-1659-01B-01R-1564-13_rnaseq_fastq.tar", "TCGA-30-1853-01A-02R-1567-13_rnaseq_fastq.tar", "TCGA-61-1910-01A-01R-1567-13_rnaseq_fastq.tar", "TCGA-25-2392-01A-01R-1569-13_rnaseq_fastq.tar", "TCGA-25-1313-01A-01R-1565-13_rnaseq_fastq.tar", "TCGA-24-1556-01A-01R-1566-13_rnaseq_fastq.tar", "TCGA-13-0762-01A-01R-1564-13_rnaseq_fastq.tar", "TCGA-23-1120-01A-02R-1565-13_rnaseq_fastq.tar", "TCGA-25-1633-01A-01R-1566-13_rnaseq_fastq.tar")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-for-work-big-60GB"

run.n.pipelines(tarfilenames= ovaug18.names, tarfileids= ovaug18.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)




######################################################################
## amlaug18  machete-new-glm-script  machete-light
##
######################################################################


amlaug18.names <- c("TCGA-AB-2859-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2943-03A-01T-0740-13_rnaseq_fastq.tar", "TCGA-AB-2822-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2847-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2971-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2912-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2869-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2940-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2944-03A-01T-0740-13_rnaseq_fastq.tar", "TCGA-AB-2908-03A-01T-0740-13_rnaseq_fastq.tar")

amlaug18.ids <- c("57b64bbae4b0192c34a4f8b3", "57b64bbbe4b0192c34a4f8b5", "57b64bbbe4b0192c34a4f8b7", "57b64bbce4b0192c34a4f8b9", "57b64bbce4b0192c34a4f8bb", "57b64bbce4b0192c34a4f8bd", "57b64bbde4b0192c34a4f8bf", "57b64bbde4b0192c34a4f8c1", "57b64bbee4b0192c34a4f8c3", "57b64bbee4b0192c34a4f8c5")


macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

run.n.pipelines(tarfilenames= amlaug18.names, tarfileids= amlaug18.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)










######################################################################
## ovspachaug24  spachete with ovarian
##   run on 10 ovarians that were already run using regular machete
##
######################################################################

## first use allfilenames, convert to "niceish names" with
## this:
niceish.names.allfilenames <- gsub(pattern="\\.tar\\.gz", replacement="", x =gsub(pattern="(_|-)", replacement="", x=gsub(pattern="_rnaseq_fastq.tar", replacement="", x=allfilenames)))

## get names previously done with this:
{
if (home.home){
        outcsv.with.keys <- file.path(mydir, "api/fileinfo/report.paths.with.keys.csv")
        metadata.filename <- file.path(mydir, "api/fileinfo/metadata.csv")
}
else {
        outcsv.with.keys <- file.path(mydir, "api/fileinfo/report.paths.with.keys.csv")
        metadata.filename <- file.path(mydir, "api/fileinfo/metadata.csv")
}
meta <- read.csv(metadata.filename, header=TRUE, sep=",", stringsAsFactors = FALSE)
paths.with.keys <- read.csv(outcsv.with.keys, header=TRUE, sep=",", stringsAsFactors = FALSE)
paths.with.meta <- merge(x=paths.with.keys, y=meta, by.x = "base.directory", by.y="nicename")
## Note that this excludes Recurrent Tumors:
ov.tumors.with.meta.names <- paths.with.meta$base.directory[paths.with.meta$disease_type=="Ovarian Serous Cystadenocarcinoma" & paths.with.meta$sample_type =="Primary Tumor"]
n.ov.tumors.with.meta <- length(ov.tumors.with.meta.names)
n.ov.tumors.with.meta
## 62

## Choose a random 10 of these
sample.size <- 10
set.seed(24233478)
indices.ov.spach.aug24.run <- sample(n.ov.tumors.with.meta, sample.size)

niceish.names.filenames.ov.spach.aug24.run <- ov.tumors.with.meta.names[indices.ov.spach.aug24.run]

## now search for these names within niceish.names.allfilenames
indices.ov.spach.within.allfilenames <- vector("integer", length=sample.size)
for (tti in 1:sample.size){
    indices.ov.spach.within.allfilenames[tti] <- which(niceish.names.allfilenames == niceish.names.filenames.ov.spach.aug24.run[tti])
}

## get the original (non-niceish) names, though don't really need these
## so so much
ovspachaug24.names <- allfilenames[indices.ov.spach.within.allfilenames]

## ovspachaug24.names
##  [1] "TCGA-13-1489-01A-01R-1565-13_rnaseq_fastq.tar"
##  [2] "TCGA-04-1536-01A-01R-1566-13_rnaseq_fastq.tar"
##  [3] "TCGA-23-2081-01A-01R-1568-13_rnaseq_fastq.tar"
##  [4] "TCGA-13-1507-01A-01R-1565-13_rnaseq_fastq.tar"
##  [5] "TCGA-04-1332-01A-01R-1564-13_rnaseq_fastq.tar"
##  [6] "TCGA-13-0924-01A-01R-1564-13_rnaseq_fastq.tar"
##  [7] "TCGA-04-1542-01A-01R-1566-13_rnaseq_fastq.tar"
##  [8] "TCGA-61-1918-01A-01R-1568-13_rnaseq_fastq.tar"
##  [9] "TCGA-25-1314-01A-01R-1565-13_rnaseq_fastq.tar"
## [10] "TCGA-13-0804-01A-01R-1564-13_rnaseq_fastq.tar"
print.nice.ids.vector(niceish.names.filenames.ov.spach.aug24.run)
## [1] "TCGA13148901A01R156513" "TCGA04153601A01R156613" "TCGA23208101A01R156813"
##  [4] "TCGA13150701A01R156513" "TCGA04133201A01R156413" "TCGA13092401A01R156413"
##  [7] "TCGA04154201A01R156613" "TCGA61191801A01R156813" "TCGA25131401A01R156513"
## [10] "TCGA13080401A01R156413"
## niceish.names.filenames.ov.spach.aug24.run <- c("TCGA13148901A01R156513", "TCGA04153601A01R156613", "TCGA23208101A01R156813", "TCGA13150701A01R156513", "TCGA04133201A01R156413", "TCGA13092401A01R156413", "TCGA04154201A01R156613", "TCGA61191801A01R156813", "TCGA25131401A01R156513", "TCGA13080401A01R156413")


ovspachaug24.ids <- allfileids[indices.ov.spach.within.allfilenames]
 ## [1] "577fc10ae4b00a112012a767" "577fc10ae4b00a112012a769"
 ## [3] "577fc108e4b00a112012a6e2" "57b5dd58e4b0192c34a4ee3b"
 ## [5] "577fc108e4b00a112012a708" "57b5dd55e4b0192c34a4ee2d"
 ## [7] "577fc108e4b00a112012a72c" "577fc108e4b00a112012a719"
 ## [9] "577fc109e4b00a112012a73d" "577fc10ae4b00a112012a758"

## use first one as test, do manually
## did this in another file
## find completed knife task manually
## glta TCGA13148901A01R156513
## https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/292b473a-2c17-4bc0-bca5-9131c9a7ebd2/


## Now look for tasks having the above nice names
##   and also having knife in the name; and look for the same but
##   with machete in the name to make sure it's one with a completed
##   machete task

aa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")
## mm for project, which is typically machete
mm <- aa$project(id="JSALZMAN/machete")

## get list of tasks- but it's only 100, right? yes
## maybe include search for
## tti <- 2
## mm$task(name=niceish.names.filenames.ov.spach.aug24.run[tti])


## 2,015 tasks as of aug 26 2016

n.lists <- 25
taskmetalist <- vector("list", length=n.lists)
tasklist <- list()
## for some reason, I can't find how to append lists easily:
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
## 2,015 as of sep 1
save(tasklist, file= file.path(mydir, "api/fileinfo/tasklist.Rdata"))
load(file= file.path(mydir, "api/fileinfo/tasklist.Rdata"))


alltasknames <- sapply(X=tasklist, FUN = function(x){ x$name})
alltaskids <- sapply(X=tasklist, FUN = function(x){ x$id})
## alltaskprojects <- sapply(X=tasklist, FUN = function(x){ x$project})



## Now, for each niceish name (2 through 10)
##   already did number 1, grep for it in task list
## Then, within that, grep for things having both task and knife
##   and manually check for things having both task and machete
##   in that list or a respective task for the machete, so that there
##   is a knife AND a machete for
##   that niceish name
##   BUT actually they should have a machete task b/c
##   they are from the report.paths.with.keys.csv file


indices.containing.niceish.names <- vector("list", length=10)
names.of.tasks.containing.niceish.names <- vector("list", length=10)
ids.of.tasks.containing.niceish.names <- vector("list", length=10)
indices.containing.knife.and.niceish.names  <- vector("list", length=10)
names.containing.knife.and.niceish.names <- vector("list", length=10)
ids.of.tasks.containing.knife.and.niceish.names <- vector("list", length=10)
for (tti in 2:length(niceish.names.filenames.ov.spach.aug24.run)){
    this.niceish.name <- niceish.names.filenames.ov.spach.aug24.run[tti]
    indices.containing.niceish.names[[tti]] <- grep(pattern=this.niceish.name, x=alltasknames)
    names.of.tasks.containing.niceish.names[[tti]] <- alltasknames[indices.containing.niceish.names[[tti]] ]
    ids.of.tasks.containing.niceish.names[[tti]] <- alltaskids[indices.containing.niceish.names[[tti]] ]
    temp.indices.within.other.indices.containing.knife.and.niceish.names <- grep(pattern="knife", x=names.of.tasks.containing.niceish.names[[tti]], ignore.case=TRUE)
    indices.containing.knife.and.niceish.names[[tti]] <- indices.containing.niceish.names[[tti]][temp.indices.within.other.indices.containing.knife.and.niceish.names]
    names.containing.knife.and.niceish.names[[tti]] <- names.of.tasks.containing.niceish.names[[tti]][temp.indices.within.other.indices.containing.knife.and.niceish.names]
    ids.of.tasks.containing.knife.and.niceish.names[[tti]] <- ids.of.tasks.containing.niceish.names[[tti]][temp.indices.within.other.indices.containing.knife.and.niceish.names]
}

## checking:
## glta 0cc7615a-70fd-4eb0-b647-98216d845d00

## Now have to do some manual stuff
## get the most recent knife task, so it could be attempt 2
## 8 and 10 have an attempt 2

finished.knife.names <- vector("character", length=10)
finished.knife.ids <- vector("character", length=10)
for (tti in 2:10){
    finished.knife.names[tti] <- names.containing.knife.and.niceish.names[[tti]][1]
    finished.knife.ids[tti] <- ids.of.tasks.containing.knife.and.niceish.names[[tti]][1]
    if (tti %in% c(8,10)){
        finished.knife.names[tti] <- names.containing.knife.and.niceish.names[[tti]][2]
        finished.knife.ids[tti] <- ids.of.tasks.containing.knife.and.niceish.names[[tti]][2]
    }
}

## finished.knife.names
##  [1] ""                                                               ##  [2] "Knife for 1D0RMBACXX1CACCGG, from tar fileTCGA04153601A01R156613, appended, drafted at Jul081340"
##  [3] "Knife for C0NEWACXX8ATAATT, from tar fileTCGA23208101A01R156813, appended, drafted at Jul100116"
##  [4] "Knife for C0L6EACXX7ATACGG, from tar fileTCGA13150701A01R156513 from group ovaug18; appended, drafted at Aug181151"
##  [5] "Knife for C09BFACXX7CTAGCT, from tar fileTCGA04133201A01R156413, appended, drafted at Jul081501"
##  [6] "Knife for C09BFACXX4AGCGCT, from tar fileTCGA13092401A01R156413 from group ovaug18; appended, drafted at Aug181102"
##  [7] "Knife for D0RMBACXX4CCCATG, from tar fileTCGA04154201A01R156613, appended, drafted at Jul081316
##  [8] "ATTEMPT 2: original is Knife for D0W8YACXX7ACATCT, from tar fileTCGA61191801A01R156813, appended, drafted at Jul092248, this attempt drafted at Jul100056"
## [9] "Knife for D0ULKACXX5CGAGAA, from tar fileTCGA25131401A01R156513, appended, drafted at Jul100041"
## [10] "ATTEMPT 2: original is Knife for D0DYAACXX1CAAAAG, from tar fileTCGA13080401A01R156413, appended, drafted at Jul092221, this attempt drafted at Jul100011"
## [1] "finished.knife.ids
##  [1] ""                                    
##  [2] "f646c6bd-08eb-4544-922d-4ebfd71dcfdd"
##  [3] "e14757b1-9017-4ef6-ad07-97f52ba48365"
##  [4] "fda83bbc-12c4-41be-9dbf-c14acc8ab3ea"
##  [5] "53d2f392-ae62-48b2-aac9-7a8911d73aad"
##  [6] "21f79572-429d-4a3c-889f-21c3a01376fd"
##  [7] "ef4ddb29-b017-47d5-aa60-572c9987e767"
##  [8] "cae34a93-dc84-43da-b675-85e8de80e4e3"
##  [9] "3e42b7f6-f058-49ee-a428-1a6a41130e55"
## [10] "65cca8a8-6179-43d8-9c62-a018246e202b"


## Now do run.spachete.given function and collect spachete task ids

## actually the outputs are url's
ov.spachete.ids <- vector("character", length=10)
spachete.app.for.this.group = "JSALZMAN/machete/spachetealpha"
for (tti in 2:10){
    ov.spachete.ids[tti] <- run.spachete.given.knife.task.id(taskid=finished.knife.ids[tti], auth.token=auth.token, spacheteapp=spachete.app.for.this.group, tempdir=tempdir, max.iterations=max.iterations, runid.suffix="", complete.or.appended="appended")
}
print.nice.ids.vector(ov.spachete.ids)
##  print.nice.ids.vector(ov.spachete.ids)
## ov.spachete.ids <- c("", "https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/56d82dbd-8da3-4df8-8807-d6055f457cdc/3a1094f7-1599-4365-b490-26295aee5d46", "https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/56d82dbd-8da3-4df8-8807-d6055f457cdc/dfadd617-1e62-4b3d-8558-b200f642292e", "https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/56d82dbd-8da3-4df8-8807-d6055f457cdc/44801d50-07ba-4e25-af7b-73ce37f37ae8", "https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/56d82dbd-8da3-4df8-8807-d6055f457cdc/65ecb38a-4170-4336-a108-41c7167cc38f", "https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/56d82dbd-8da3-4df8-8807-d6055f457cdc/3b87bd98-c193-4a7a-b824-49ce50d3269d", "https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/56d82dbd-8da3-4df8-8807-d6055f457cdc/2119a051-f817-4acc-9a41-d71ff83b98ce", "https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/56d82dbd-8da3-4df8-8807-d6055f457cdc/408af4c9-dc58-468a-a8a2-99f90865c99c", "https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/56d82dbd-8da3-4df8-8807-d6055f457cdc/ce7505e2-b27f-4c0e-8738-081889238a48", "https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/56d82dbd-8da3-4df8-8807-d6055f457cdc/09fee6d9-c92c-4e5d-adca-f39fa6609010")



# do download for first task:
download.reports.and.fasta.and.outputfjfiles.one.task(task.id="https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/56d82dbd-8da3-4df8-8807-d6055f457cdc/", task.short.name="TCGA13148901A01R156513", ttwdir=wdir, ttauth=auth, ttproj="JSALZMAN/machete", tempdir=tempdir, datadir=file.path(wdir,"spachetedata"))

## do download for other 9 tasks
for (tti in 2:10){
    download.reports.and.fasta.and.outputfjfiles.one.task(task.id=ov.spachete.ids[tti], task.short.name=niceish.names.filenames.ov.spach.aug24.run[tti], ttwdir=wdir, ttauth=auth, ttproj="JSALZMAN/machete", tempdir=tempdir, datadir=file.path(wdir,"spachetedata"))
}






## macheteapp.for.this.group <- "JSALZMAN/machete/spachetealpha"

## run.n.pipelines(tarfilenames= ovspachaug24.names, tarfileids= ovspachaug24.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)



######################################################################
## amlspachaug29  spachete with aml
##   run on 10 aml that were already run using regular machete
##
######################################################################


aml.tumors.with.meta.names <- paths.with.meta$base.directory[paths.with.meta$disease_type=="Acute Myeloid Leukemia" & paths.with.meta$sample_type =="Primary Blood Derived Cancer - Peripheral Blood"]
n.aml.tumors.with.meta <- length(aml.tumors.with.meta.names)
n.aml.tumors.with.meta
## 16

## Choose a random 10 of these
sample.size <- 10
set.seed(2424578)
indices.aml.spach.aug29.run <- sort(sample(n.aml.tumors.with.meta, sample.size))

niceish.names.filenames.aml.spach.aug29.run <- aml.tumors.with.meta.names[indices.aml.spach.aug29.run]

## now search for these names within niceish.names.allfilenames 
indices.aml.spach.within.allfilenames <- vector("integer", length=sample.size)
for (tti in 1:sample.size){
    indices.aml.spach.within.allfilenames[tti] <- which(niceish.names.allfilenames == niceish.names.filenames.aml.spach.aug29.run[tti])
}

## get the original (non-niceish) names, though don't really need these
## so so much
amlspachaug29.names <- allfilenames[indices.aml.spach.within.allfilenames]

## amlspachaug29.names
##  [1] "TCGA-AB-2826-03A-01T-0734-13_rnaseq_fastq.tar"
##  [2] "TCGA-AB-2836-03A-01T-0736-13_rnaseq_fastq.tar"
##  [3] "TCGA-AB-2845-03B-01T-0748-13_rnaseq_fastq.tar"
##  [4] "TCGA-AB-2911-03A-01T-0734-13_rnaseq_fastq.tar"
##  [5] "TCGA-AB-2915-03A-01T-0740-13_rnaseq_fastq.tar"
##  [6] "TCGA-AB-2917-03A-01T-0734-13_rnaseq_fastq.tar"
##  [7] "TCGA-AB-2921-03A-01T-0740-13_rnaseq_fastq.tar"
##  [8] "TCGA-AB-2927-03A-01T-0740-13_rnaseq_fastq.tar"
##  [9] "TCGA-AB-2943-03A-01T-0740-13_rnaseq_fastq.tar"
## [10] "TCGA-AB-3008-03A-01T-0736-13_rnaseq_fastq.tar"

print.nice.ids.vector(niceish.names.filenames.aml.spach.aug29.run)
## niceish.names.filenames.aml.spach.aug29.run <- c("TCGAAB282603A01T073413", "TCGAAB283603A01T073613", "TCGAAB284503B01T074813", "TCGAAB291103A01T073413", "TCGAAB291503A01T074013", "TCGAAB291703A01T073413", "TCGAAB292103A01T074013", "TCGAAB292703A01T074013", "TCGAAB294303A01T074013", "TCGAAB300803A01T073613")



## Now, for each niceish name (1 through 10),
##   grep for it in task list
## Then, within that, grep for things having both task and knife
##   and manually check for things having both task and machete
##   in that list or a respective task for the machete, so that there
##   is a knife AND a machete for
##   that niceish name
##   BUT actually they should have a machete task b/c
##   they are from the report.paths.with.keys.csv file


indices.containing.niceish.names <- vector("list", length=10)
names.of.tasks.containing.niceish.names <- vector("list", length=10)
ids.of.tasks.containing.niceish.names <- vector("list", length=10)
indices.containing.knife.and.niceish.names  <- vector("list", length=10)
names.containing.knife.and.niceish.names <- vector("list", length=10)
ids.of.tasks.containing.knife.and.niceish.names <- vector("list", length=10)
for (tti in 1:length(niceish.names.filenames.aml.spach.aug29.run)){
    this.niceish.name <- niceish.names.filenames.aml.spach.aug29.run[tti]
    indices.containing.niceish.names[[tti]] <- grep(pattern=this.niceish.name, x=alltasknames)
    names.of.tasks.containing.niceish.names[[tti]] <- alltasknames[indices.containing.niceish.names[[tti]] ]
    ids.of.tasks.containing.niceish.names[[tti]] <- alltaskids[indices.containing.niceish.names[[tti]] ]
    temp.indices.within.other.indices.containing.knife.and.niceish.names <- grep(pattern="knife", x=names.of.tasks.containing.niceish.names[[tti]], ignore.case=TRUE)
    indices.containing.knife.and.niceish.names[[tti]] <- indices.containing.niceish.names[[tti]][temp.indices.within.other.indices.containing.knife.and.niceish.names]
    names.containing.knife.and.niceish.names[[tti]] <- names.of.tasks.containing.niceish.names[[tti]][temp.indices.within.other.indices.containing.knife.and.niceish.names]
    ids.of.tasks.containing.knife.and.niceish.names[[tti]] <- ids.of.tasks.containing.niceish.names[[tti]][temp.indices.within.other.indices.containing.knife.and.niceish.names]
}

## checking:
## gltad 29f0a2fc-5648-41a9-ad65-be7250d7386f

## Now have to do some manual stuff
## get the most recent knife task, so it could be attempt 2
## 8 has an attempt 2

finished.knife.names <- vector("character", length=10)
finished.knife.ids <- vector("character", length=10)
for (tti in 1:10){
    finished.knife.names[tti] <- names.containing.knife.and.niceish.names[[tti]][1]
    finished.knife.ids[tti] <- ids.of.tasks.containing.knife.and.niceish.names[[tti]][1]
    if (tti == 8){
        finished.knife.names[tti] <- names.containing.knife.and.niceish.names[[tti]][2]
        finished.knife.ids[tti] <- ids.of.tasks.containing.knife.and.niceish.names[[tti]][2]
    }
}

## finished.knife.names
##  finished.knife.names
##  [1] "Knife for 610W1AAXX4, from tar fileTCGAAB282603A01T073413, appended, drafted at Jul101122"                                                          
##  [2] "Knife for 700D3AAXX5, from tar fileTCGAAB283603A01T073613, appended, drafted at Jul101119"                                                          
##  [3] "Knife for 61TV6AAXX4, from tar fileTCGAAB284503B01T074813, appended, drafted at Jul101130"                                                          
##  [4] "Knife for 613RTAAXX4, from tar fileTCGAAB291103A01T073413, appended, drafted at Jul110008"                                                          
##  [5] "Knife for 61FFWAAXX8, from tar fileTCGAAB291503A01T074013, appended, drafted at Jul110011"                                                          
##  [6] "Knife for 61660AAXX8, from tar fileTCGAAB291703A01T073413, appended, drafted at Jul110012"                                                          
##  [7] "Knife for 61FJYAAXX4, from tar fileTCGAAB292103A01T074013, appended, drafted at Jul110014"                                                          
##  [8] "ATTEMPT 2: original is Knife for 61FFWAAXX5, from tar fileTCGAAB292703A01T074013, appended, drafted at Jul110010, this attempt drafted at Jul110141"
##  [9] "Knife for 61U24AAXX4, from tar fileTCGAAB294303A01T074013 from group amlaug18; appended, drafted at Aug181812"

## [10] "Knife for 17009AAAXX5, from tar fileTCGAAB300803A01T073613 from group amlnotdoneaug1; appended, drafted at Aug011804"                       > finished.knife.ids
##  [1] "7bf3c1d8-2171-4a83-9624-5122c3454e1e"
##  [2] "8c3b6b6c-0f50-4120-901f-56c9fa7dd198"
##  [3] "1e056f66-370d-4cc6-af29-2e4830c48f29"
##  [4] "e738677d-a845-4738-9d83-f1d413582c01"
##  [5] "e4364f9d-b4ab-455c-9f47-17cf73ae4dab"
##  [6] "3cc6210f-67cf-4d5e-a315-e880bf8b827b"
##  [7] "b3983b9f-0dd8-43a6-983d-05d05fc812ef"
##  [8] "29f0a2fc-5648-41a9-ad65-be7250d7386f"
##  [9] "783c25c4-9663-48e9-895d-d59b283fa47a"
## [10] "0204ae86-247e-4306-bad8-bab0d5b7031f"



## Now do run.spachete.given function and collect spachete task ids

## actually the outputs are url's
aml.spachete.ids <- vector("character", length=10)
spachete.app.for.this.group = "JSALZMAN/machete/spachetealpha"
## run 1 first to test new call spachete stuff
aml.spachete.ids[1] <- run.spachete.given.knife.task.id(taskid=finished.knife.ids[1], auth.token=auth.token, spacheteapp=spachete.app.for.this.group, tempdir=tempdir, max.iterations=max.iterations, runid.suffix="", complete.or.appended="appended")
}
for (tti in 2:10){
    aml.spachete.ids[tti] <- run.spachete.given.knife.task.id(taskid=finished.knife.ids[tti], auth.token=auth.token, spacheteapp=spachete.app.for.this.group, tempdir=tempdir, max.iterations=max.iterations, runid.suffix="", complete.or.appended="appended")
}
print.nice.ids.vector(aml.spachete.ids)

## aml.spachete.ids[1]
## https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/56d82dbd-8da3-4df8-8807-d6055f457cdc/0cc61e3f-aa1c-4168-9a27-1f7324cac577







## amlspachaug29.ids <- 


macheteapp.for.this.group <- "JSALZMAN/machete/spachete-alpha"

run.n.pipelines(tarfilenames= amlspachaug29.names, tarfileids= amlspachaug29.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)



######################################################################
## prosspachaug29  spachete with prostate
##   run on 1 prostate to check spachete
##
######################################################################

pros.tumors.with.meta.names <- paths.with.meta$base.directory[paths.with.meta$disease_type=="Prostate Adenocarcinoma" & paths.with.meta$sample_type =="Primary Tumor"]
n.pros.tumors.with.meta <- length(pros.tumors.with.meta.names)
n.pros.tumors.with.meta
## 15

## Choose a random 1 of these
sample.size <- 1
set.seed(24864578)
indices.pros.spach.aug29.run <- sort(sample(n.pros.tumors.with.meta, sample.size))

niceish.names.filenames.pros.spach.aug29.run <- pros.tumors.with.meta.names[indices.pros.spach.aug29.run]

## now search for these names within niceish.names.allfilenames 
indices.pros.spach.within.allfilenames <- vector("integer", length=sample.size)
for (tti in 1:sample.size){
    indices.pros.spach.within.allfilenames[tti] <- which(niceish.names.allfilenames == niceish.names.filenames.pros.spach.aug29.run[tti])
}

## get the original (non-niceish) names, though don't really need these
## so so much
prosspachaug29.names <- allfilenames[indices.pros.spach.within.allfilenames]


print.nice.ids.vector(niceish.names.filenames.pros.spach.aug29.run)
## niceish.names.filenames.pros.spach.aug29.run <- c("UNCID2190566.1059fbc046bf413599d0080ec225391b.120215UNC10SN2540327AC0CMCACXX5GATCAG")


## Now, for each niceish name (1 through 10, in this case 1 through 1),
##   grep for it in task list
## Then, within that, grep for things having both task and knife
##   and manually check for things having both task and machete
##   in that list or a respective task for the machete, so that there
##   is a knife AND a machete for
##   that niceish name
##   BUT actually they should have a machete task b/c
##   they are from the report.paths.with.keys.csv file


indices.containing.niceish.names <- vector("list", length=10)
names.of.tasks.containing.niceish.names <- vector("list", length=10)
ids.of.tasks.containing.niceish.names <- vector("list", length=10)
indices.containing.knife.and.niceish.names  <- vector("list", length=10)
names.containing.knife.and.niceish.names <- vector("list", length=10)
ids.of.tasks.containing.knife.and.niceish.names <- vector("list", length=10)
for (tti in 1:length(niceish.names.filenames.pros.spach.aug29.run)){
    this.niceish.name <- niceish.names.filenames.pros.spach.aug29.run[tti]
    indices.containing.niceish.names[[tti]] <- grep(pattern=this.niceish.name, x=alltasknames)
    names.of.tasks.containing.niceish.names[[tti]] <- alltasknames[indices.containing.niceish.names[[tti]] ]
    ids.of.tasks.containing.niceish.names[[tti]] <- alltaskids[indices.containing.niceish.names[[tti]] ]
    temp.indices.within.other.indices.containing.knife.and.niceish.names <- grep(pattern="knife", x=names.of.tasks.containing.niceish.names[[tti]], ignore.case=TRUE)
    indices.containing.knife.and.niceish.names[[tti]] <- indices.containing.niceish.names[[tti]][temp.indices.within.other.indices.containing.knife.and.niceish.names]
    names.containing.knife.and.niceish.names[[tti]] <- names.of.tasks.containing.niceish.names[[tti]][temp.indices.within.other.indices.containing.knife.and.niceish.names]
    ids.of.tasks.containing.knife.and.niceish.names[[tti]] <- ids.of.tasks.containing.niceish.names[[tti]][temp.indices.within.other.indices.containing.knife.and.niceish.names]
}

## checking:
## gltad ee491742-ce9e-4799-97fd-36b81d028f5d

## Now have to do some manual stuff
## get the most recent knife task, so it could be attempt 2
## 8 has an attempt 2

finished.knife.names <- vector("character", length=10)
finished.knife.ids <- vector("character", length=10)
for (tti in 1:1){
    finished.knife.names[tti] <- names.containing.knife.and.niceish.names[[tti]][1]
    finished.knife.ids[tti] <- ids.of.tasks.containing.knife.and.niceish.names[[tti]][1]
    if (tti == 8){
        finished.knife.names[tti] <- names.containing.knife.and.niceish.names[[tti]][2]
        finished.knife.ids[tti] <- ids.of.tasks.containing.knife.and.niceish.names[[tti]][2]
    }
}


spachete.app.for.this.group = "JSALZMAN/machete/spachetealpha"
## run 1 first to test new call spachete stuff
aml.spachete.ids <- run.spachete.given.knife.task.id(taskid=finished.knife.ids[1], auth.token=auth.token, spacheteapp=spachete.app.for.this.group, tempdir=tempdir, max.iterations=max.iterations, runid.suffix="", complete.or.appended="appended")
}
print.nice.ids.vector(aml.spachete.ids)
## c("https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/56d82dbd-8da3-4df8-8807-d6055f457cdc/41df8e6a-77b6-4527-b4ce-268156c0bc61")









######################################################################
# 20 ovarian
## ovaug30
## uses regular machete
## get ids from datasetapi.R
######################################################################

ovaug30.ids <-  c("57c67cdae4b0192c34a77f57", "57c67cdae4b0192c34a77f59", "57c67cdbe4b0192c34a77f5b", "57c67cdbe4b0192c34a77f5d", "57c67cdce4b0192c34a77f5f", "57c67cdce4b0192c34a77f61", "57c67cdce4b0192c34a77f63", "57c67cdde4b0192c34a77f65", "57c67cdde4b0192c34a77f67", "57c67cdee4b0192c34a77f69", "57c67cdee4b0192c34a77f6b", "57c67cdfe4b0192c34a77f6d", "57c67cdfe4b0192c34a77f6f", "57c67ce0e4b0192c34a77f71", "57c67ce0e4b0192c34a77f73", "57c67ce0e4b0192c34a77f75", "57c67ce1e4b0192c34a77f77", "57c67ce1e4b0192c34a77f79", "57c67ce2e4b0192c34a77f7b", "57c67ce2e4b0192c34a77f7d")
    
ovaug30.names <- c("TCGA-61-2094-01A-01R-1568-13_rnaseq_fastq.tar", "TCGA-61-1737-01A-01R-1567-13_rnaseq_fastq.tar", "TCGA-25-1320-01A-01R-1565-13_rnaseq_fastq.tar", "TCGA-31-1950-01A-01R-1568-13_rnaseq_fastq.tar", "TCGA-24-1555-01A-01R-1566-13_rnaseq_fastq.tar", "TCGA-13-1487-01A-01R-1565-13_rnaseq_fastq.tar", "TCGA-61-2109-01A-01R-1568-13_rnaseq_fastq.tar", "TCGA-24-1928-01A-01R-1567-13_rnaseq_fastq.tar", "TCGA-29-1701-01A-01R-1567-13_rnaseq_fastq.tar", "TCGA-25-1328-01A-01R-1565-13_rnaseq_fastq.tar", "TCGA-09-2054-01A-01R-1568-13_rnaseq_fastq.tar", "TCGA-24-2033-01A-01R-1568-13_rnaseq_fastq.tar", "TCGA-13-1510-01A-02R-1565-13_rnaseq_fastq.tar", "TCGA-30-1892-01A-01R-1568-13_rnaseq_fastq.tar", "TCGA-24-1423-01A-01R-1565-13_rnaseq_fastq.tar", "TCGA-24-2027-01A-01R-1567-13_rnaseq_fastq.tar", "TCGA-04-1356-01A-01R-1569-13_rnaseq_fastq.tar", "TCGA-09-1673-01A-01R-1566-13_rnaseq_fastq.tar", "TCGA-09-2056-01B-01R-1568-13_rnaseq_fastq.tar", "TCGA-29-1691-01A-01R-1566-13_rnaseq_fastq.tar")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-for-work"

run.n.pipelines(tarfilenames= ovaug30.names, tarfileids= ovaug30.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)



######################################################################
## 20 ovarian
## second group of 20
## ovaug31
## uses regular machete
## get ids from datasetapi.R
######################################################################

ovaug31.ids <- c("57c67d52e4b0192c34a77f7f", "57c67d52e4b0192c34a77f81", "57c67d53e4b0192c34a77f83", "57c67d53e4b0192c34a77f85", "57c67d54e4b0192c34a77f87", "57c67d54e4b0192c34a77f89", "57c67d54e4b0192c34a77f8b", "57c67d55e4b0192c34a77f8d", "57c67d56e4b0192c34a77f8f", "57c67d56e4b0192c34a77f91", "57c67d56e4b0192c34a77f93", "57c67d57e4b0192c34a77f95", "57c67d58e4b0192c34a77f97", "57c67d58e4b0192c34a77f99", "57c67d58e4b0192c34a77f9b", "57c67d59e4b0192c34a77f9d", "57c67d59e4b0192c34a77f9f", "57c67d5ae4b0192c34a77fa1", "57c67d5ae4b0192c34a77fa3", "57c67d5be4b0192c34a77fa5")
    
ovaug31.names <- c("TCGA-23-1021-01B-01R-1564-13_rnaseq_fastq.tar", "TCGA-13-1505-01A-01R-1565-13_rnaseq_fastq.tar", "TCGA-13-0727-01A-01R-1564-13_rnaseq_fastq.tar", "TCGA-24-2288-01A-01R-1568-13_rnaseq_fastq.tar", "TCGA-61-2092-01A-01R-1568-13_rnaseq_fastq.tar", "TCGA-04-1357-01A-01R-1565-13_rnaseq_fastq.tar", "TCGA-61-2097-01A-02R-1568-13_rnaseq_fastq.tar", "TCGA-25-2398-01A-01R-1569-13_rnaseq_fastq.tar", "TCGA-57-1994-01A-01R-1568-13_rnaseq_fastq.tar", "TCGA-24-1850-01A-01R-1567-13_rnaseq_fastq.tar", "TCGA-13-1410-01A-01R-1565-13_rnaseq_fastq.tar", "TCGA-24-1436-01A-01R-1566-13_rnaseq_fastq.tar", "TCGA-3P-A9WA-01A-11R-A406-31_rnaseq_fastq.tar", "TCGA-10-0931-01A-01R-1564-13_rnaseq_fastq.tar", "TCGA-04-1361-01A-01R-1565-13_rnaseq_fastq.tar", "TCGA-23-1107-01A-01R-1564-13_rnaseq_fastq.tar", "TCGA-25-2401-01A-01R-1569-13_rnaseq_fastq.tar", "TCGA-23-1119-01A-02R-1565-13_rnaseq_fastq.tar", "TCGA-29-1705-01A-01R-1567-13_rnaseq_fastq.tar", "TCGA-13-0885-01A-02R-1569-13_rnaseq_fastq.tar")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

run.n.pipelines(tarfilenames= ovaug31.names, tarfileids= ovaug31.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)




######################################################################
## amlaug31  machete-new-glm-script  machete-light
##  part1 and part2 each with 45 files
######################################################################


amlaug31part1.names <- c("TCGA-AB-2817-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2955-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2883-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2938-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2857-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2866-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2886-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2986-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2879-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2885-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2976-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2897-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2881-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2880-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2823-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2934-03A-01T-0740-13_rnaseq_fastq.tar", "TCGA-AB-2988-03B-01T-0748-13_rnaseq_fastq.tar", "TCGA-AB-2867-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2833-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2904-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2818-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2865-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2870-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2814-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2893-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2812-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2952-03B-01T-0760-13_rnaseq_fastq.tar", "TCGA-AB-2929-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2846-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2972-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2963-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2868-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2914-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2950-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2821-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2808-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2848-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2949-03B-01T-0748-13_rnaseq_fastq.tar", "TCGA-AB-2970-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-3011-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2992-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2807-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2871-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2890-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-3002-03A-01T-0736-13_rnaseq_fastq.tar")

amlaug31part1.ids <-  c("57c76cb0e4b0f9890b16d356", "57c76cb1e4b0f9890b16d358", "57c76cb1e4b0f9890b16d35a", "57c76cb1e4b0f9890b16d35c", "57c76cb2e4b0f9890b16d35e", "57c76cb2e4b0f9890b16d360", "57c76cb3e4b0f9890b16d362", "57c76cb3e4b0f9890b16d364", "57c76cb4e4b0f9890b16d366", "57c76cb4e4b0f9890b16d368", "57c76cb4e4b0f9890b16d36a", "57c76cb5e4b0f9890b16d36c", "57c76cb5e4b0f9890b16d36e", "57c76cb5e4b0f9890b16d370", "57c76cb6e4b0f9890b16d372", "57c76cb7e4b0f9890b16d374", "57c76cb7e4b0f9890b16d376", "57c76cb8e4b0f9890b16d378", "57c76cb8e4b0f9890b16d37a", "57c76cb9e4b0f9890b16d37c", "57c76cb9e4b0f9890b16d37e", "57c76cb9e4b0f9890b16d380", "57c76cbae4b0f9890b16d382", "57c76cbae4b0f9890b16d384", "57c76cbbe4b0f9890b16d386", "57c76cbbe4b0f9890b16d388", "57c76cbbe4b0f9890b16d38a", "57c76cbce4b0f9890b16d38c", "57c76cbce4b0f9890b16d38e", "57c76cbde4b0f9890b16d390", "57c76cbde4b0f9890b16d392", "57c76cbee4b0f9890b16d394", "57c76cbfe4b0f9890b16d396", "57c76cbfe4b0f9890b16d398", "57c76cc0e4b0f9890b16d39a", "57c76cc0e4b0f9890b16d39c", "57c76cc1e4b0f9890b16d39e", "57c76cc1e4b0f9890b16d3a0", "57c76cc1e4b0f9890b16d3a2", "57c76cc2e4b0f9890b16d3a4", "57c76cc2e4b0f9890b16d3a6", "57c76cc3e4b0f9890b16d3a8", "57c76cc4e4b0f9890b16d3aa", "57c76cc4e4b0f9890b16d3ac", "57c76cc5e4b0f9890b16d3ae")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

run.n.pipelines(tarfilenames= amlaug31part1.names, tarfileids= amlaug31part1.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)



amlaug31part2.names <- 

amlaug31part2.ids <- 


macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

run.n.pipelines(tarfilenames= amlaug31part2.names, tarfileids= amlaug31part2.ids, pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=seconds.of.wait.time.between.runs)









# pipeline.test.cmd <- paste("Rscript", pipeline.script, "_1_G17211.TCGA-06-0747-01A-01R-1849-01.2.tar.gz", "5775a414e4b03bb2bc27297b", auth.token, groupname, grouplog, groupcsv, groupdir, tempdir, groupfailedtaskslog, mastercsv, homedir, home.home, complete.or.appended, pipeowner, pipeproj, unpackapp, trimapp, knifeapp, macheteapp, runid.suffix, seconds.between.checks, timeout.days, temprdatadir, "2>&1", sep=" ")

# cat(pipeline.test.cmd)

## Send stdout and stderr to screen
# system(command=pipeline.test.cmd, wait=FALSE, intern=FALSE)

# sink()

# technically don't need wait=FALSE if intern=TRUE
# out.test <- system(command=pipeline.test.cmd, wait=FALSE, intern=TRUE)







# running on jun30 or later:
# pipeline.one.tarfile(intarname="TCGA-13-0891-01A-01R-1564-13_rnaseq_fastq.tar", intarpath="577403fce4b03bb2bc269e9e", auth.token=auth.token, groupname =groupname, grouplog = grouplog, groupcsv=groupcsv, groupdir = groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv = mastercsv, homedir=homedir, home.home=FALSE, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj = "machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp="JSALZMAN/machete/machete-for-work", runid.suffix="firsttest", seconds.between.checks=60, timeout.days=4)

# _rnaseq_fastq.tar .fastq




