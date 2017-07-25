## use this to run SBT count runs
## use bloomdata.R to add files to bloom projects
## this is the newer version; apibloom.R is the older version

# home.home is TRUE if using home computer 
home.home <- TRUE


# home directory

{
if (home.home){ 
    homedir = "/my/dir/api"
    bloomdir = "/my/dir/bloom"
}
else {
    homedir = "/my/dir/api"
    bloomdir = "/my/dir/bloom"
}
}

source(file.path(bloomdir,"bloomdefs.R"))




#######################################################
#######################################################
#######################################################
##
## run lines up to here, then run specific lines below
##
#######################################################
#######################################################
#######################################################














#######################################################
#######################################################
##
## lung
##
#######################################################
#######################################################




## hashfile.id="580515dae4b0e6cba394fdf7"; hashfile.name="hashfile.hh"; tarfile.ids =c("58028589e4b0bd93e1462667", "58028588e4b0bd93e1462665"); tarfile.names = c("UNCID_2210153.463d3f12-16bb-456a-8fb1-f200c7996406.110412_UNC13-SN749_0053_BB018EABXX_2.tar.gz","UNCID_2319279.9014d9c4-ab6b-4318-9b07-c00266d9f5a9.131015_UNC11-SN627_0327_AC2ND3ACXX_8_TTAGGC.tar.gz")
## auth.token=auth.token; add.to.task.name= "out of a total of 1095"; app.short.name="TCGA-Archive-SBT-count-2"; nn=10; projname=projname; cutoff=2; bfsize = 4000000000;  n.chars.from.file.names=13



## nn=10 typically; number of files per task
## add.to.task.name = ""; nn

## thisdate <- "oct15"; shortname <- "br"; nice.ids.file = file.path(bloomworkdir,paste0("bloomfilesinfo.", shortname, ".", thisdate, ".nice.ids.csv")); nice.names.file = file.path(bloomworkdir,paste0("bloomfilesinfo.", shortname, ".", thisdate, ".nice.names.csv")); all.tarfile.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE); all.tarfile.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)

## do this for lung:
## first, need to find the hashfile.id and hashfile.name and read in
## tarfile ids and names
nice.ids.file = file.path(bloomworkdir,paste0("bloomfilesinfo.", shortname, ".", date.in.tarfile.info.files, ".nice.ids.csv"))
nice.names.file = file.path(bloomworkdir,paste0("bloomfilesinfo.", shortname, ".", date.in.tarfile.info.files, ".nice.names.csv"))
all.tarfile.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)
all.tarfile.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)
out.lung <- run.all.sbt.counts(ttmm=ttmm, hashfile.id="580bbca0e4b0e6cba39573e0", hashfile.name ="hashfile.hh", all.tarfile.ids, all.tarfile.names, bloomworkdir=bloomworkdir, short.name.and.date=short.name.and.date, auth.token=auth.token, add.to.task.name="total of 516 cases,", app.short.name="TCGA-Archive-SBT-count-2", nn=10, projname=projname, cutoff=2, bfsize = 4000000000, n.chars.from.file.names=13)




#######################################################
#######################################################
##
## colon
##
#######################################################
#######################################################


## project name; ASSUMES project is under ericfg, CHANGE IF NOT
shortprojname <- "bloomtreemany"

## shortname for current run:
shortname <- "colon"
shortdate <- "nov19"


## short.name.and.date <- "br.oct19"
short.name.and.date <- paste0(shortname, ".", shortdate)


## full project name:
projname <- paste0("ericfg/", shortprojname)

buildapp <- paste0(projname, "/", "bt-build")



## OLD: You have to look in the bloomwork dir to see what this is:
## OLD:
##  date.in.tarfile.info.files <- "oct21"
## I found the br one to be oct15 by looking at:
## bloomfilesinfo.br.oct15.nice.ids.csv
## bloomfilesinfo.br.oct15.nice.names.csv


## first, need to find the hashfile.id and hashfile.name 
##  Do this manually
hashfile.id.bloomtreemany <- "5830c237e4b0e05ac2a82013"
hashfile.name.bloomtreemany <- "hashfile.hh"



## Read in tarfile ids and names
## The below way is for bloomtreemany
## Was done differently for previous ones
nice.ids.file = file.path(bloomworkdir,paste0("bloomtreemany.tarfile.ids.", shortname, ".csv"))
nice.names.file = file.path(bloomworkdir,paste0("bloomtreemany.tarfile.names.", shortname, ".csv"))

all.tarfile.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)
all.tarfile.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)

n.tarfile.ids <- length(all.tarfile.ids)

num.tarfiles.per.task <- 10

out.this.type <- run.all.sbt.counts(ttmm=ttmm, hashfile.id=hashfile.id.bloomtreemany, hashfile.name =hashfile.name.bloomtreemany, all.tarfile.ids=all.tarfile.ids, all.tarfile.names=all.tarfile.names, bloomworkdir=bloomworkdir, short.name.and.date=short.name.and.date, auth.token=auth.token, add.to.task.name=paste0(shortname, " ", shortdate, ", total of ", n.tarfile.ids, " cases,"), app.short.name="TCGA-Archive-SBT-count-2", nn=num.tarfiles.per.task, projname=projname, cutoff=2, bfsize = 4000000000, n.chars.from.file.names=13)

## It is actually a vector, not a list:
sbt.task.ids <- out.this.type$list.taskids

## write these to a file:
sbt.task.ids.file = file.path(bloomworkdir,paste0("bloomtreemany.sbt.task.ids.", shortname, ".csv"))

writeLines(sbt.task.ids, con= sbt.task.ids.file, sep ="\n")



## Wait until the above ALL finish, then do the following:

## bv.file.ids <- vector("character", length = n.tarfile.ids)
## bv.file.ids[] <- NA
bv.file.ids <- vector("character", length = 0)
bv.file.names <- vector("character", length = 0)


## The following assumes you do 10 tasks at a time!!!
for (ii.taskid in 1:length(sbt.task.ids)){
    cat("Working on task ", ii.taskid, " of ", length(sbt.task.ids),"\n")
    ## NOTE: doesn't require a project name
    thistask.details <- get.details.of.a.task.from.id(taskid = sbt.task.ids[ii.taskid], auth.token=auth.token, ttwdir = tempdir)
    n.tarfiles.this.task <- length(thistask.details$outputs$bit_vector)
    bv.ids.this.task <- vector("character", length = n.tarfiles.this.task)
    bv.ids.this.task[] <- NA
    bv.names.this.task <- vector("character", length = n.tarfiles.this.task)
    bv.names.this.task[] <- NA
    for (ii.bv in 1:n.tarfiles.this.task){
        bv.ids.this.task[ii.bv] <- thistask.details$outputs$bit_vector[[ii.bv]]['path']
        bv.names.this.task[ii.bv] <- thistask.details$outputs$bit_vector[[ii.bv]]['name']
    }
    bv.file.ids <- append(bv.file.ids, bv.ids.this.task)
    bv.file.names <- append(bv.file.names, bv.names.this.task)
}


## write these to a file:
bv.file.ids.filename = file.path(bloomworkdir,paste0("bloomtreemany.bv.file.ids.", shortname, ".csv"))
bv.file.names.filename = file.path(bloomworkdir,paste0("bloomtreemany.bv.file.names.", shortname, ".csv"))

writeLines(bv.file.ids, con= bv.file.ids.filename, sep ="\n")
writeLines(bv.file.names, con= bv.file.names.filename, sep ="\n")


## now draft a bt-build task using these bv file ids

aa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")
## mm for project, which wss typically machete
mm <- aa$project(id=projname)
nicetime <- format(Sys.time(),"%b%d%H%M")
name.build.task <- paste0("bt build for ", shortname, " ", shortdate , "; drafted at ", nicetime, sep="")
cat("About to draft and then run ", name.unpacking.task)
bf_inputs = list()
for (ii.bv.ids in 1:length(bv.file.ids)){
    bf_inputs[[ii.bv.ids]] <- Files(id = bv.file.ids[ii.bv.ids], name=bv.file.names[ii.bv.ids])
}

inputs.build <- list(bf_inputs=bf_inputs, hashfile=Files(id=hashfile.id.bloomtreemany, name=hashfile.name.bloomtreemany), output_prefix= shortname)

build.task <- mm$task_add(name = name.build.task, description = name.build.task,  app = buildapp, inputs = inputs.build)
cat("Just drafted ", name.build.task, "; task id is\n", build.task$id, "\n")
build.task$run()



#######################################################
#######################################################
##
## sarcoma
##
#######################################################
#######################################################


## project name; ASSUMES project is under ericfg, CHANGE IF NOT
shortprojname <- "bloomtreemany"

## shortname for current run:
shortname <- "sarcoma"
shortdate <- "nov26"


short.name.and.date <- paste0(shortname, ".", shortdate)


## full project name:
projname <- paste0("ericfg/", shortprojname)

buildapp <- paste0(projname, "/", "bt-build")



## OLD: You have to look in the bloomwork dir to see what this is:
## OLD:
##  date.in.tarfile.info.files <- "oct21"
## I found the br one to be oct15 by looking at:
## bloomfilesinfo.br.oct15.nice.ids.csv
## bloomfilesinfo.br.oct15.nice.names.csv


## first, need to find the hashfile.id and hashfile.name 
##  Do this manually
hashfile.id.bloomtreemany <- "5830c237e4b0e05ac2a82013"
hashfile.name.bloomtreemany <- "hashfile.hh"



## Read in tarfile ids and names
## The below way is for bloomtreemany
## Was done differently for previous ones
nice.ids.file = file.path(bloomworkdir,paste0("bloomtreemany.tarfile.ids.", shortname, ".csv"))
nice.names.file = file.path(bloomworkdir,paste0("bloomtreemany.tarfile.names.", shortname, ".csv"))

all.tarfile.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)
all.tarfile.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)

n.tarfile.ids <- length(all.tarfile.ids)

num.tarfiles.per.task <- 10

out.this.type <- run.all.sbt.counts(ttmm=ttmm, hashfile.id=hashfile.id.bloomtreemany, hashfile.name =hashfile.name.bloomtreemany, all.tarfile.ids=all.tarfile.ids, all.tarfile.names=all.tarfile.names, bloomworkdir=bloomworkdir, short.name.and.date=short.name.and.date, auth.token=auth.token, add.to.task.name=paste0(shortname, " ", shortdate, ", total of ", n.tarfile.ids, " cases,"), app.short.name="TCGA-Archive-SBT-count-2", nn=num.tarfiles.per.task, projname=projname, cutoff=2, bfsize = 4000000000, n.chars.from.file.names=13)

## It is actually a vector, not a list:
sbt.task.ids <- out.this.type$list.taskids

## write these to a file:
sbt.task.ids.file = file.path(bloomworkdir,paste0("bloomtreemany.sbt.task.ids.", shortname, ".csv"))

writeLines(sbt.task.ids, con= sbt.task.ids.file, sep ="\n")


## can read in sbt.task.ids if you want like this:
## sbt.task.ids <- readLines(con= sbt.task.ids.file)



## Wait until the above ALL finish, then do the following:

## bv.file.ids <- vector("character", length = n.tarfile.ids)
## bv.file.ids[] <- NA
bv.file.ids <- vector("character", length = 0)
bv.file.names <- vector("character", length = 0)


## The following assumes you do 10 tasks at a time!!!
for (ii.taskid in 1:length(sbt.task.ids)){
    cat("Working on task ", ii.taskid, " of ", length(sbt.task.ids),"\n")
    ## NOTE: doesn't require a project name
    thistask.details <- get.details.of.a.task.from.id(taskid = sbt.task.ids[ii.taskid], auth.token=auth.token, ttwdir = tempdir)
    n.tarfiles.this.task <- length(thistask.details$outputs$bit_vector)
    bv.ids.this.task <- vector("character", length = n.tarfiles.this.task)
    bv.ids.this.task[] <- NA
    bv.names.this.task <- vector("character", length = n.tarfiles.this.task)
    bv.names.this.task[] <- NA
    for (ii.bv in 1:n.tarfiles.this.task){
        bv.ids.this.task[ii.bv] <- thistask.details$outputs$bit_vector[[ii.bv]]['path']
        bv.names.this.task[ii.bv] <- thistask.details$outputs$bit_vector[[ii.bv]]['name']
    }
    bv.file.ids <- append(bv.file.ids, bv.ids.this.task)
    bv.file.names <- append(bv.file.names, bv.names.this.task)
}


## write these to a file:
bv.file.ids.filename = file.path(bloomworkdir,paste0("bloomtreemany.bv.file.ids.", shortname, ".csv"))
bv.file.names.filename = file.path(bloomworkdir,paste0("bloomtreemany.bv.file.names.", shortname, ".csv"))

writeLines(bv.file.ids, con= bv.file.ids.filename, sep ="\n")
writeLines(bv.file.names, con= bv.file.names.filename, sep ="\n")


## now draft a bt-build task using these bv file ids

aa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")
## mm for project, which wss typically machete
mm <- aa$project(id=projname)
nicetime <- format(Sys.time(),"%b%d%H%M")
name.build.task <- paste0("bt build for ", shortname, " ", shortdate , "; drafted at ", nicetime, sep="")
cat("About to draft and then run ", name.build.task, "\n")
bf_inputs = list()
for (ii.bv.ids in 1:length(bv.file.ids)){
    bf_inputs[[ii.bv.ids]] <- Files(id = bv.file.ids[ii.bv.ids], name=bv.file.names[ii.bv.ids])
}

inputs.build <- list(bf_inputs=bf_inputs, hashfile=Files(id=hashfile.id.bloomtreemany, name=hashfile.name.bloomtreemany), output_prefix= shortname)

build.task <- mm$task_add(name = name.build.task, description = name.build.task,  app = buildapp, inputs = inputs.build)
cat("Just drafted ", name.build.task, "; task id is\n", build.task$id, "\n")
build.task$run()





#######################################################
#######################################################
##
## gbm
##
#######################################################
#######################################################


## project name; ASSUMES project is under ericfg, CHANGE IF NOT
shortprojname <- "bloomtreemany"

## shortname for current run:
shortname <- "gbm"
shortdate <- "dec3"


short.name.and.date <- paste0(shortname, ".", shortdate)


## full project name:
projname <- paste0("ericfg/", shortprojname)

buildapp <- paste0(projname, "/", "bt-build")



## OLD: You have to look in the bloomwork dir to see what this is:
## OLD:
##  date.in.tarfile.info.files <- "oct21"
## I found the br one to be oct15 by looking at:
## bloomfilesinfo.br.oct15.nice.ids.csv
## bloomfilesinfo.br.oct15.nice.names.csv


## first, need to find the hashfile.id and hashfile.name 
##  Do this manually
hashfile.id.bloomtreemany <- "5830c237e4b0e05ac2a82013"
hashfile.name.bloomtreemany <- "hashfile.hh"



## Read in tarfile ids and names
## The below way is for bloomtreemany
## Was done differently for previous ones
nice.ids.file = file.path(bloomworkdir,paste0("bloomtreemany.tarfile.ids.", shortname, ".csv"))
nice.names.file = file.path(bloomworkdir,paste0("bloomtreemany.tarfile.names.", shortname, ".csv"))

all.tarfile.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)
all.tarfile.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)

n.tarfile.ids <- length(all.tarfile.ids)

num.tarfiles.per.task <- 10

out.this.type <- run.all.sbt.counts(ttmm=ttmm, hashfile.id=hashfile.id.bloomtreemany, hashfile.name =hashfile.name.bloomtreemany, all.tarfile.ids=all.tarfile.ids, all.tarfile.names=all.tarfile.names, bloomworkdir=bloomworkdir, short.name.and.date=short.name.and.date, auth.token=auth.token, add.to.task.name=paste0(shortname, " ", shortdate, ", total of ", n.tarfile.ids, " cases,"), app.short.name="TCGA-Archive-SBT-count-2", nn=num.tarfiles.per.task, projname=projname, cutoff=2, bfsize = 4000000000, n.chars.from.file.names=13)

## It is actually a vector, not a list:
sbt.task.ids <- out.this.type$list.taskids

## write these to a file:
sbt.task.ids.file = file.path(bloomworkdir,paste0("bloomtreemany.sbt.task.ids.", shortname, ".csv"))

writeLines(sbt.task.ids, con= sbt.task.ids.file, sep ="\n")


## can read in sbt.task.ids if you want like this:
## sbt.task.ids <- readLines(con= sbt.task.ids.file)



## Wait until the above ALL finish, then do the following:

## bv.file.ids <- vector("character", length = n.tarfile.ids)
## bv.file.ids[] <- NA
bv.file.ids <- vector("character", length = 0)
bv.file.names <- vector("character", length = 0)


## The following assumes you do 10 tasks at a time!!!
for (ii.taskid in 1:length(sbt.task.ids)){
    cat("Working on task ", ii.taskid, " of ", length(sbt.task.ids),"\n")
    ## NOTE: doesn't require a project name
    thistask.details <- get.details.of.a.task.from.id(taskid = sbt.task.ids[ii.taskid], auth.token=auth.token, ttwdir = tempdir)
    n.tarfiles.this.task <- length(thistask.details$outputs$bit_vector)
    bv.ids.this.task <- vector("character", length = n.tarfiles.this.task)
    bv.ids.this.task[] <- NA
    bv.names.this.task <- vector("character", length = n.tarfiles.this.task)
    bv.names.this.task[] <- NA
    for (ii.bv in 1:n.tarfiles.this.task){
        bv.ids.this.task[ii.bv] <- thistask.details$outputs$bit_vector[[ii.bv]]['path']
        bv.names.this.task[ii.bv] <- thistask.details$outputs$bit_vector[[ii.bv]]['name']
    }
    bv.file.ids <- append(bv.file.ids, bv.ids.this.task)
    bv.file.names <- append(bv.file.names, bv.names.this.task)
}


## write these to a file:
bv.file.ids.filename = file.path(bloomworkdir,paste0("bloomtreemany.bv.file.ids.", shortname, ".csv"))
bv.file.names.filename = file.path(bloomworkdir,paste0("bloomtreemany.bv.file.names.", shortname, ".csv"))

writeLines(bv.file.ids, con= bv.file.ids.filename, sep ="\n")
writeLines(bv.file.names, con= bv.file.names.filename, sep ="\n")


## now draft a bt-build task using these bv file ids

aa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")
## mm for project, which wss typically machete
mm <- aa$project(id=projname)
nicetime <- format(Sys.time(),"%b%d%H%M")
name.build.task <- paste0("bt build for ", shortname, " ", shortdate , "; drafted at ", nicetime, sep="")
cat("About to draft and then run ", name.build.task, "\n")
bf_inputs = list()
for (ii.bv.ids in 1:length(bv.file.ids)){
    bf_inputs[[ii.bv.ids]] <- Files(id = bv.file.ids[ii.bv.ids], name=bv.file.names[ii.bv.ids])
}

inputs.build <- list(bf_inputs=bf_inputs, hashfile=Files(id=hashfile.id.bloomtreemany, name=hashfile.name.bloomtreemany), output_prefix= shortname)

build.task <- mm$task_add(name = name.build.task, description = name.build.task,  app = buildapp, inputs = inputs.build)
cat("Just drafted ", name.build.task, "; task id is\n", build.task$id, "\n")
build.task$run()








