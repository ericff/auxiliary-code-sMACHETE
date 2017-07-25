## use this to run SBT count runs
## use bloomdata.R to add files to bloom projects
## see dobloom.R to run this


# max.iterations for loop in out.project.list function
max.iterations <- 10000

# home directory

{
if (home.home){ 
    temprdatadir = "/my/dir/api/rdatatempfiles"
    auth.token.filename <- "/my/dir/api/authtoken.txt"
}
else {
    temprdatadir = "/my/dir/api/rdatatempfiles"
    auth.token.filename <- "/my/dir/api/authtoken.txt"
}
}


bloomworkdir = file.path(bloomdir, "bloomwork")

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

## hashfile.id="580515dae4b0e6cba394fdf7"; hashfile.name="hashfile.hh"; tarfile.ids =c("58028589e4b0bd93e1462667", "58028588e4b0bd93e1462665"); tarfile.names = c("UNCID_2210153.463d3f12-16bb-456a-8fb1-f200c7996406.110412_UNC13-SN749_0053_BB018EABXX_2.tar.gz","UNCID_2319279.9014d9c4-ab6b-4318-9b07-c00266d9f5a9.131015_UNC11-SN627_0327_AC2ND3ACXX_8_TTAGGC.tar.gz")
## auth.token=auth.token; add.to.task.name= "out of a total of 1095"; app.short.name="TCGA-Archive-SBT-count-2"; nn=10; projname=projname; cutoff=2; bfsize = 4000000000;  n.chars.from.file.names=13



## run a task for using "SBT count - TCGA Archive" with n files
##  where n is typically 10
run.sbt.count.with.n.files <- function(ttmm, hashfile.id, hashfile.name, tarfile.ids, tarfile.names, auth.token=auth.token, add.to.task.name="", app.short.name="TCGA-Archive-SBT-count-2", nn=10, projname=projname, cutoff=2, bfsize = 4000000000, n.chars.from.file.names=13){
    ttaa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")
    # mm for project, because it uses to be machete
    ttmm <- ttaa$project(id=projname)
    app.full.name = paste0(projname, "/", app.short.name)
    nicetime.task <- format(Sys.time(),"%b%d%H%M")
    ## cutoff names of files to use in name of task, use first
    ##  n.chars.from.file.names
    filename.string <- paste(substr(tarfile.names, start = 0, stop = n.chars.from.file.names), collapse = " ")
    name.task <- paste(app.short.name, " ", add.to.task.name, " for ", nn, " tar files, ", "drafted at ", nicetime.task, " with files ", filename.string, sep="")
    # do this so it doesn't use scientific notation
    options(scipen = 9)
    bfsize = as.character(bfsize)
    ## Make file array of input archive files
    inputarchivefile <- vector("list", length = nn)
    for (ii in 1:nn){
        inputarchivefile[[ii]] <- Files(id=tarfile.ids[[ii]], name=tarfile.names[[ii]])
    }
    inputs.task <- list(cutoff = cutoff, bf_size = bfsize, hashfile= Files(id=hashfile.id, name=hashfile.name), input_archive_file = inputarchivefile)
    # 
    cat("About to draft and then run ", name.task, "\n")
    #  
    sbt.task <- ttmm$task_add(name = name.task, description = name.task, app = app.full.name, inputs = inputs.task)
    # phred64=".001",
    #
    # Now run the task
    sbt.task$run()
    sbt.task
}


## nn=10 typically; number of files per task
## add.to.task.name = ""; nn

## thisdate <- "oct15"; shortname <- "br"; nice.ids.file = file.path(bloomworkdir,paste0("bloomfilesinfo.", shortname, ".", thisdate, ".nice.ids.csv")); nice.names.file = file.path(bloomworkdir,paste0("bloomfilesinfo.", shortname, ".", thisdate, ".nice.names.csv")); all.tarfile.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE); all.tarfile.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)


## run all of the sbt count tasks for one project and then return
##  list of the task objects
run.all.sbt.counts <- function(ttmm, hashfile.id, hashfile.name, all.tarfile.ids, all.tarfile.names, bloomworkdir, short.name.and.date, auth.token=auth.token, add.to.task.name="", app.short.name="TCGA-Archive-SBT-count-2", nn=10, projname=projname, cutoff=2, bfsize = 4000000000, n.chars.from.file.names=13){
    ## split up all.tarfile.ids and names into groups of nn
    n.tarfiles <- length(all.tarfile.names)
    stopifnot(length(all.tarfile.ids)==n.tarfiles)
    left.ends <- seq(from=1, to=n.tarfiles, by = nn)
    right.ends <- c(left.ends[-1] - 1, n.tarfiles)
    n.tasks <- length(left.ends)
    partition.tarfiles <- vector("list", length= n.tasks)
    for (ii in 1:n.tasks){
        partition.tarfiles[[ii]] <- c(left.ends[ii], right.ends[ii])
    }
    list.tar.ids <- vector("list", length = n.tasks)
    list.tar.names <- vector("list", length = n.tasks)
    for (ii in 1:n.tasks){
        list.tar.ids[[ii]] <- all.tarfile.ids[left.ends[ii]:right.ends[ii]]
        list.tar.names[[ii]] <- all.tarfile.names[left.ends[ii]:right.ends[ii]]
    }
    list.tasks <- vector("list", length = n.tasks)
    list.taskids <- vector("character", length = n.tasks)
    list.tasknames <- vector("character", length = n.tasks)
    ## Now run all of the tasks
    ## Need to do nn = min(nn,length(list.tar.ids[[ii]])) in case
    ## the tarfiles are, e.g. numbers 1091 to 1095 and thus not
    ## as long as nn
    for (ii in 1:n.tasks){
        cat("Working on task ", ii, " of ", n.tasks, "\n")
        list.tasks[[ii]] <-  run.sbt.count.with.n.files(ttmm=ttmm, hashfile.id = hashfile.id, hashfile.name = hashfile.name, tarfile.ids = list.tar.ids[[ii]], tarfile.names = list.tar.names[[ii]], auth.token=auth.token, add.to.task.name=paste0(", Task ", ii, " of ", n.tasks, ", ", add.to.task.name), app.short.name=app.short.name, nn=min(nn,length(list.tar.ids[[ii]])), projname=projname, cutoff=cutoff, bfsize = bfsize,  n.chars.from.file.names=n.chars.from.file.names)
        list.taskids[ii] <- list.tasks[[ii]]$id
        list.tasknames[ii] <- list.tasks[[ii]]$name
    }
    ## write taskids and names to files
    idsfilename <- file.path(bloomworkdir, paste0(short.name.and.date, ".sbt.count.task.ids.csv"))
    namesfilename <- file.path(bloomworkdir, paste0(short.name.and.date, ".sbt.count.task.names.csv"))
    write.table(list.taskids, file = idsfilename,  row.names = FALSE, col.names = FALSE, sep = "\n", append=FALSE, quote=FALSE)
    write.table(list.tasknames, file = namesfilename,  row.names = FALSE, col.names = FALSE, sep = "\n", append=FALSE, quote=FALSE)
    cat(paste0("Writing files\n", idsfilename, "\n and \n", namesfilename),"\n")
    list(list.tasks = list.tasks, list.taskids = list.taskids, list.tasknames = list.tasknames)
}

















