# newapidefs.R
# 
# NOTE THAT Various things should be defined
#  BEFORE THIS IS SOURCED
## Intended for one to use execapinew.R when using this
## NOTE THAT this uses first version of trimgalore only:
## trimapp="JSALZMAN/machete/trimgalorev2/0"

# assumes that fastq or fq files are tarred and that they end in
#   _R1.fastq or _1.fastq or _R1.fq or _1.fq
#   _R2.fastq or _2.fastq or _R2.fq or _2.fq
#   _R1.fastq.gz or _1.fastq.gz or _R1.fq.gz or _1.fq.gz
#   _R2.fastq.gz or _2.fastq.gz or _R2.fq.gz or _2.fq.gz
#


###########################################################
# NOTE: you must install their wrapper
###########################################################

# do once
## see
## https://github.com/sbg/sevenbridges-r/blob/c4986238938440dddc3f30831705f13097913d93/vignettes/api.Rmd
# source("http://bioconductor.org/biocLite.R")
# useDevel(devel = TRUE)
# biocLite("sevenbridges")

## If you cannot install it because you are not running latest R, you can install the package from github

## # install.packages("devtools") if devtools was not installed
## ## Install from github for development version  
## source("http://bioconductor.org/biocLite.R")
## # install.packages("devtools") if devtools was not installed
## library(devtools)
## install_github("sbg/sevenbridges-r", build_vignettes=TRUE, 
##   repos=BiocInstaller::biocinstallRepos(),
##   dependencies=TRUE)

## This package is also available in docker image tengfei/sevenbridges, which the latest is build on bioconductor/devel_base on dockerhub.

## Checkout the Dockerfile at

## system.file("docker", "sevenbridges/Dockerfile", package = "sevenbridges")

setwd(dir=wdir)

auth.token <-scan(file=auth.token.filename, what="character")


# install.packages("RJSONIO", repos = "http://cran.cnr.berkeley.edu/")
library(RJSONIO)

library(sevenbridges)

## should install xml2, I guess; I got an error about it,
##  not clear why though 
## install.packages("xml2", repos = "http://cran.cnr.berkeley.edu/")

library(xml2)

## run this once to get all the "infile" names and ids and save in Rdata
##   file, for machete project only
## infile.array <- get.infile.names.and.ids(projname = "JSALZMAN/machete", auth.token=auth.token, tempdir=tempdir, max.iterations=max.iterations)
## save(infile.array, file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata"))

## ## do this one time and save file for use with running multiple files
## get.infile.etc.names.and.ids(projname = "JSALZMAN/machete", auth.token, tempdir=tempdir, max.iterations=max.iterations, infile.etc.info.file = file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata"))

## probably shouldn't be needed b/c should be done within functions
## below, as infile.etc.info.file
load(file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata"))

# text="rrtesting this\n testing"; logfilenames = c("temp.txt"); ttappend=TRUE; screen=TRUE
# write.logs(text="hi hi hi", logfilenames = c("temp.txt", "temp2.txt"), ttappend=TRUE, screen=TRUE)
#  screen=TRUE means print to screen also
# append a string to log files, typically 2 but
#   could be any number; should
#   check that 1 works
#  default is to append to file
#   Note that if it doesn't exist, it will create the file first
#  
write.logs <- function(text, logfilenames, ttappend=TRUE, screen=TRUE){
    # Add \n to end to make things nicer:
    text <-paste(text,"\n")
    for (tti in 1:length(logfilenames)){
        # first check that file is already there if append is true
        if (!(file.exists(logfilenames[tti]))){
            file.create(logfilenames[tti])
        }
        cat(text, file=logfilenames[tti], sep="\n", append=ttappend)
    }
    if (screen){
        cat(text)
    }
}







# get list of all files in directory
#   also, exclude some probably
# limit to those matching a certain type, tar files with certain
#   attributes maybe?

# out.project.list <- list.all.files.project(projname="ericfg/testing", ttwdir=wdir, tempdir=tempdir, auth.token=auth.token, max.iterations=max.iterations)

# projname = "ericfg/mach1"
# get list of all files in a project:
# projname shouldn't have any spaces or unusual characters!!!
list.all.files.project<-function(projname, ttwdir, tempdir, auth.token, max.iterations=max.iterations){
    file.increment <- 100
    # initialize the outputs:
    filehrefs <- vector("character", length=0)
    fileids <- vector("character", length=0)
    filenames <- vector("character", length=0)
    # while loop
    # ask for 100 files, then read off last element - link I think
    # then change more.files.yn to FALSE
    # maybe for loop, with test each time, don't want to go forever
    more.files.yn <- TRUE
    i.loop <- 1   # i.loop is the number of times through the loop;
                  # also helps to limit your total number of
                  # runs through loop
    while (more.files.yn) {
        if (i.loop %% 3 == 1){
            print(paste("Working on loop", i.loop, "; max.iterations =", max.iterations, "\n"))
        }
        # first time through, use your own link
        #  later times through, use link provided by API
        # Note that this overwrites the file if already there.
        filename.t <- file.path(tempdir, "tempfilelist.txt")
        {    # start if/else
        if (i.loop==1){
            system(paste('curl -s -H "X-SBG-Auth-Token: ', auth.token, ' " -H "content-type: application/json" -X GET "https://cgc-api.sbgenomics.com/v2/files?offset=0&limit=',file.increment,'&project=', projname, '" > ', filename.t, sep =""))
        }
        else {
            system(paste('curl -s -H "X-SBG-Auth-Token: ', auth.token, ' " -H "content-type: application/json" -X GET "', nextlink, '" > ', filename.t, sep =""))
        }
        }   # end if/else
        all.files.raw <- vector("list", length=0)
        all.files.raw[[i.loop]] <- RJSONIO::fromJSON(filename.t)
        # names(all.files.raw[[i.loop]])
        # [1] "href"  "items" "links"
        #
        # names(all.files.raw[[i.loop]]$items[1][[1]])
        # [1] "href"    "id"      "name"    "project"
        # Add hrefs, file ids and file names from this step of loop
        #  to big list of file names
        #
        filehrefs <- append(filehrefs, sapply(all.files.raw[[i.loop]]$items, FUN= function(x){ x[["href"]]}))
        fileids <- append(fileids, sapply(all.files.raw[[i.loop]]$items, FUN= function(x){ x[["id"]]}))
        filenames <- append(filenames, sapply(all.files.raw[[i.loop]]$items, FUN= function(x){ x[["name"]]}))
        ## filehrefs <- append(filehrefs, all.files.raw[[i.loop]]$items$href)
        ## fileids <- append(fileids, all.files.raw[[i.loop]]$items$id)
        ## filenames <- append(filenames, all.files.raw[[i.loop]]$items$name)
        #
        templink <- all.files.raw[[i.loop]]$links
        {
        # if there is nothing in templink, that means the loop is
        #   done, apparently- not documented, but that happened once
        #   when number of files was less than 100
        if (is.list(templink) & length(templink)==0){
            more.files.yn <- FALSE
        }
        else {
            nextlink <- all.files.raw[[i.loop]]$links[[1]][1]
            names(nextlink)<- NULL
            # check if next link has the val "prev" for "rel", which
            #  means that the current request is the last one
            prev.or.next <- all.files.raw[[i.loop]]$links[[1]]["rel"]
            names(prev.or.next)<- NULL
            i.loop <- i.loop + 1
            if (! (prev.or.next %in% c("prev","next"))){
                stop(paste("ERROR: prev.or.next is ", prev.or.next, " and it should be one of prev or next"))
            }
            if (prev.or.next=="prev"){
                more.files.yn <- FALSE
            }
        }
        } # end if/else
        # if you reach the max loop size, end loop:
        if (i.loop>= max.iterations){
            more.files.yn <- FALSE
        }
        #
    } # end while loop 
    n.files <- length(filenames)
    list(filehrefs=filehrefs, fileids= fileids, filenames=filenames, n.files=n.files)
}

# out34 <- get.details.of.a.task.from.id(taskid = "0bb0a961-41fd-4617-a9d4-f2392445a04e", auth.token=auth.token, ttwdir=tempdir)
# taskid = "0bb0a961-41fd-4617-a9d4-f2392445a04e"
# http://docs.cancergenomicscloud.org/docs/get-details-of-a-task
#
get.details.of.a.task.from.id <- function(taskid, auth.token, ttwdir=tempdir){
    filename.t <- file.path(ttwdir, "temptaskdetails.json")
    system(paste('curl -s -H "X-SBG-Auth-Token: ', auth.token, ' " -H "content-type: application/json" -X GET "https://cgc-api.sbgenomics.com/v2/tasks/',taskid, '" > ', filename.t, sep =""))
    RJSONIO::fromJSON(filename.t)
}


# remove _1 or _2 if not right before .fastq* or .fq*
# See https://github.com/lindaszabo/KNIFE
# filename ="asaew_1_ad_1fa_R1we_R1.fastq"
# filename ="asa+ew_1_ad_1fa_R1we_1.fq"
## make.new.file.names.so.nice.for.knife(filename = "700D6AAXX_1_1.fastq")
# make.new.file.names.so.nice.for.knife("unalignedasa+ew_1_ad_1fa_R1we_1.fq")
## "The file names for a given sample must start with an identical string that identifies the sample and then have either _1, _R1, _2, or _R2 identifying them as read1 or read2. Any part of the file name after this will be ignored. Reads may be in gzipped files or plain text fastq files, but the file extension must be .fq, .fq.gz, .fastq, or .fastq.gz. Read file names must not contain the string 'unaligned' as this will interfere with logic around identifying de novo junctions."
## https://github.com/lindaszabo/KNIFE
## Mistake I made, that I noticed in sep 2016
## Conider this: "700D6AAXX_1_1.fastq"
## it would have replaced _1_ first to give 11.fastq
## and that gets rid of the underscore before 1, which is expected
## if have _1_1.fq, want it to keep _ before 1.fq
## so first replace 
make.new.file.names.so.nice.for.knife <- function(filename){
    # replace every instance of _1_ NOT followed by either .fastq or .fq
    ##    or by 1.fastq, 1.fq, 2.fastq, 2.fq, 
    #    with 1; similarly for _1, _R1, _2_, _2, _R2
    ## newname1 <- gsub(pattern="_1_(?!(\\.fastq|\\.fq).*)", replacement = "1", x=filename, perl=TRUE)
    ## changing sep 2016, so don't remove last underscore, e.g.
    ##   from _1_1.fastq
    newname1 <- gsub(pattern="_1_(?!((1|2)\\.fastq|(1|2)\\.fq).*)", replacement = "1", x=filename, perl=TRUE)
    newname2 <- gsub(pattern="_1(?!(\\.fastq|\\.fq).*)", replacement = "1", x=newname1, perl=TRUE)
    newname3 <- gsub(pattern="_R1(?!(\\.fastq|\\.fq).*)", replacement = "1", x=newname2, perl=TRUE)
    ## changing sep 2016, so don't remove last underscore
    newname4 <- gsub(pattern="_2_(?!((1|2)\\.fastq|(1|2)\\.fq).*)", replacement = "2", x=newname3, perl=TRUE)
    newname5 <- gsub(pattern="_2(?!(\\.fastq|\\.fq).*)", replacement = "2", x=newname4, perl=TRUE)
    newname6 <- gsub(pattern="_R2(?!(\\.fastq|\\.fq).*)", replacement = "2", x=newname5, perl=TRUE)
    # remove + signs, bad for SB
    newname7 <- gsub(pattern="\\+", replacement="", x=newname6)
    # check that unaligned is not in the name
    gsub(pattern = "unaligned", replacement = "unaalligned", x=newname7)
}



# determine.reverse.and.forward.fastq.files(filenames=c("CW2012_1_bulk_GTCCGC_L005_R1truncated.fastq", "CW2012_1_bulk_GTCCGC_L005_R2truncated.fastq"))
# determine.reverse.and.forward.fastq.files(filenames = c("asa+ew_1_ad_1fa_R1we_R1.fq", "asa+ew_1_ad_1fa_R1we_R2.fq"))
#
# determine which file has the 1 in it
#
# ASSUMES file names end in one of .fastq, .fq, .fastq.gz or .fq.gz
#
# filenames = c("asa+ew_1_ad_1fa_R1we_R1.fq", "asa+ew_1_ad_1fa_R1we_R2.fq")
# pass this a vector of two filenames
determine.reverse.and.forward.fastq.files <- function(filenames){
    #   first do checks that all take form _1.fastq
    #   and _2.fastq or R1, R2,
    #   .fq, etc.
    # do this by looking for one ending in _R1.fq or _1.fastq.gz etc.
    #   changing it into a 2 and checking that the filenames are the
    #   same
    #
    #
    # first look for which file has the pattern one would expect
    if (length(filenames)!=2){
        stop(paste("ERROR in determine.reverse.and.forward.fastq.files: input vector should have length 2 but it does not.\nThe filenames given as input are:\n", paste(filenames, collapse = "\n"), sep=""), sep="")
    }
    # 
    pattern1 = "(_1|_R1)(?=(\\.fastq|\\.fq|\\.fastq.gz|\\.fq.gz)$)"
    outgrep = grep(pattern=pattern1, x =filenames, perl = TRUE)
    {
    if (length(outgrep)==0){
        stop(paste("ERROR in determine.reverse.and.forward.fastq.files: finding 0 files that\nmatch the pattern for what the forward file name (file number 1) should look like\nThe list of all of the filenames is:\n", paste(filenames, collapse = "\n"), sep=""), sep="")  
    }
    else if (length(outgrep)==2){
        stop(paste("ERROR in determine.reverse.and.forward.fastq.files: finding 2 files that\nmatch the pattern for what the forward file name (file number 1) should look like\nThe filenames that match are:\n", paste(filenames[outgrep], collapse = "\n"), sep=""), sep="")
    }
    else {
        file.one <- filenames[outgrep]
        # file.two must be the other one
        file.two <- filenames[(3-outgrep[1])]
    }
    } # end if/else
    #
    # 
    pattern1a = "_1(?=(\\.fastq|\\.fq|\\.fastq.gz|\\.fq.gz)$)"
    pattern1b = "_R1(?=(\\.fastq|\\.fq|\\.fastq.gz|\\.fq.gz)$)"
    filename.that.should.match.with.second.step1 <- gsub(pattern = pattern1a, replacement="_2", x = file.one, perl = TRUE)
    filename.that.should.match.with.second <- gsub(pattern = pattern1b, replacement="_R2", x = filename.that.should.match.with.second.step1, perl = TRUE)
    # check that it matches with second filename; if not, give error
    #    if so, then proceed
    if (!(filename.that.should.match.with.second== file.two)){
        stop(paste("ERROR in determine.reverse.and.forward.fastq.files: after changing _1 or _R1 in first file to _2 or _R2, respectively,\n it does not match the other file.First file is\n", file.one, "\nModified first file is:\n", filename.that.should.match.with.second, "\nSecond file is:\n", file.two, sep=""))  
    }
    list(forward.file=file.one, reverse.file=file.two)
}


## determine.reverse.and.forward.fastq.files.with.error.warning(filenames=c("120110_UNC13-SN749_0142_BD0HK1ACXX_ATCACG_L008_1.fastq", "120110_UNC13-SN749_0142_BD0HK1ACXX_ATCACG_L008_2.fastq"))

# determine.reverse.and.forward.fastq.files.with.error.warning(filenames=c("CW2012_1_bulk_GTCCGC_L005_R1truncated.fastq", "CW2012_1_bulk_GTCCGC_L005_R2truncated.fastq"))
# determine.reverse.and.forward.fastq.files.with.error.warning(filenames = c("asa+ew_1_ad_1fa_R1we_R1.fq", "asa+ew_1_ad_1fa_R1we_R2.fq"))
#
# determine which file has the 1 in it
#
# ASSUMES file names end in one of .fastq, .fq, .fastq.gz or .fq.gz
#
# filenames = c("asa+ew_1_ad_1fa_R1we_R1.fq", "asa+ew_1_ad_1fa_R1we_R2.fq")

# problematic example:
## https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/b4902464-6466-4ac2-b88a-8d155c9e569b/
## filenames = c("700D6AAXX11_val_1.fq.gz", "700D6AAXX12_val_2.fq.gz")

# pass this a vector of two filenames
## SIMILAR to above, but this will always succeed
## gives an output though of error.in.fastq.file.names = TRUE if there is a problem
determine.reverse.and.forward.fastq.files.with.error.warning <- function(filenames){
    #   first do checks that all take form _1.fastq
    #   and _2.fastq or R1, R2,
    #   .fq, etc.
    # do this by looking for one ending in _R1.fq or _1.fastq.gz etc.
    #   changing it into a 2 and checking that the filenames are the
    #   same
    #
    #
    ## initialize:
    error.in.fastq.file.names <- FALSE
    file.one <- NA
    file.two <- NA
    # first look for which file has the pattern one would expect
    if (length(filenames)!=2){
        error.in.fastq.file.names <- TRUE
        print(paste("ERROR ERROR in determine.reverse.and.forward.fastq.files.with.error.warning: input vector should have length 2 but it does not.\nThe filenames given as input are:\n", paste(filenames, collapse = "\n"), sep=""), sep="")
    }
    # 
    pattern1 = "(_1|_R1)(?=(\\.fastq|\\.fq|\\.fastq.gz|\\.fq.gz)$)"
    outgrep = grep(pattern=pattern1, x =filenames, perl = TRUE)
    {
    if (length(outgrep)==0){
        error.in.fastq.file.names <- TRUE
        print(paste("ERROR in determine.reverse.and.forward.fastq.files.with.error.warning: finding 0 files that\nmatch the pattern for what the forward file name (file number 1) should look like\nThe list of all of the filenames is:\n", paste(filenames, collapse = "\n"), sep=""), sep="")  
    }
    else if (length(outgrep)==2){
        error.in.fastq.file.names <- TRUE
        print(paste("ERROR in determine.reverse.and.forward.fastq.files.with.error.warning: finding 2 files that\nmatch the pattern for what the forward file name (file number 1) should look like\nThe filenames that match are:\n", paste(filenames[outgrep], collapse = "\n"), sep=""), sep="")
    }
    else {
        file.one <- filenames[outgrep]
        # file.two must be the other one
        file.two <- filenames[(3-outgrep[1])]
        ##
        pattern1a = "_1(?=(\\.fastq|\\.fq|\\.fastq.gz|\\.fq.gz)$)"
        pattern1b = "_R1(?=(\\.fastq|\\.fq|\\.fastq.gz|\\.fq.gz)$)"
        filename.that.should.match.with.second.step1 <- gsub(pattern = pattern1a, replacement="_2", x = file.one, perl = TRUE)
        filename.that.should.match.with.second <- gsub(pattern = pattern1b, replacement="_R2", x = filename.that.should.match.with.second.step1, perl = TRUE)
        ## check that it matches with second filename; if not, give error
        ##    if so, then proceed
        if (!(filename.that.should.match.with.second== file.two)){
            error.in.fastq.file.names <- TRUE
            print(paste("ERROR in determine.reverse.and.forward.fastq.files.with.error.warning: after changing _1 or _R1 in first file to _2 or _R2, respectively,\n it does not match the other file.First file is\n", file.one, "\nModified first file is:\n", filename.that.should.match.with.second, "\nSecond file is:\n", file.two, sep=""))  
        }
    }
    } # end if/else
    #
    # 
    list(error.in.fastq.file.names=error.in.fastq.file.names, forward.file=file.one, reverse.file=file.two)
}





# list.from.draft.task <- out34drafttask
# get the task href and id from the output json file in the list
#   created when
#   creating a draft task
get.task.href.and.id <- function(list.from.draft.task){
    ttjson <- RJSONIO::fromJSON(list.from.draft.task$draftoutjsonfile)
    list(href=ttjson$href, id=ttjson$id)
}

# out35draftask<- run.task.from.draft(list.from.draft.task=out34drafttask, tempdir=tempdir)
#
# run task after draft already made
run.task.from.draft <- function(list.from.draft.task, tempdir=tempdir){
    href=get.task.href.and.id(list.from.draft.task)$href
    runoutjsonfile <- file.path(tempdir, paste("runof", basename(list.from.draft.task$draftoutjsonfile), sep=""))
    system(paste('curl  -s -H "X-SBG-Auth-Token: ', auth.token,'" -H "content-type: application/json" -X POST "', href, '/actions/run" > ', runoutjsonfile, sep=""))
    list.from.run.task <- list.from.draft.task
    list.from.run.task$runoutjsonfile = runoutjsonfile
    list.from.run.task
}










# "execution_status": {
    ##     "message": "Aborted",
    ##     "queued": 0,
    ##     "running": 0,
    ##     "completed": 0,
    ##     "failed": 0,
    ##     "aborted": 0
    ## },
# http://docs.cancergenomicscloud.org/docs/get-details-of-a-task

# seconds.between.checks = 60; tt.task=pipe.unpack.task; timeout.days=4
#
# monitor.task(seconds.between.checks = 60, tt.task=pipe.unpack.task, timeout.days=4, logs.to.write=logs.to.write)
#
# seconds.between.checks  number of seconds between checking status
#   of task
# monitor the status of a task, stop when completed or failed
#  timeout.days is  number of days before timeout just to give
#  an upper bound; default is 4
#  it is crude, doesn't depend what time of day you start
#
monitor.task <- function(seconds.between.checks = 60, tt.task, timeout.days=4, logs.to.write){
    start.time <- Sys.time()
    msg <- paste("Monitoring task ", tt.task$name, "; starting at ", start.time, "\n", sep="")
    write.logs(text=msg, logfilenames = logs.to.write, ttappend=TRUE, screen=TRUE)
    stop.day.numeric <- as.numeric(as.Date(start.time) + timeout.days)
    stoploop <- FALSE
    while (stoploop == FALSE){
        Sys.sleep(seconds.between.checks)
        # make api call to check status
        tryout.t <- try(status <- tolower(tt.task$update()$status))
        if (class(tryout.t)=="try-error"){
            cat("Problem with task update. Maybe you are offline.")
        }
        if (status %in% c("completed", "failed", "aborted")){
            stoploop <- TRUE
        }
        if (as.numeric(Sys.Date())>= stop.day.numeric){
            stoploop <- TRUE
        }
        if (seconds.between.checks >= 10){
            cat("Status is ", status, ".", sep="")
        }
    }
    hours.to.complete <- round(as.numeric(difftime(Sys.time(), start.time, units="hours")), digits=2)
    msg <- paste0("\n\nTask ", tt.task$name, " finished with status ", status, " as of ", Sys.time(), ", so in ", hours.to.complete, " hours.\n\n")
    write.logs(text=msg, logfilenames = logs.to.write, ttappend=TRUE, screen=TRUE)
    list(status=status, hours.to.complete=hours.to.complete)
}

# copy.and.rename.file.on.sb(file.id="57302e7fe4b003986b30f6c9", new.name="zz7.txt", proj.name="ericfg/mach1", auth.token=auth.token, temp.dir=temp.dir)
# renames a file within current project
copy.and.rename.file.on.sb <- function(file.id, new.name, proj.name, auth.token, tempdir=tempdir){
    tempfilename=file.path(tempdir,"tempcopyandrenamefile.json")
    system(paste('curl --data \'{"project": "', proj.name, '", "name": "', new.name ,'"}\' -s -H "X-SBG-Auth-Token: ', auth.token,'" -H "content-type: application/json" -X POST "https://cgc-api.sbgenomics.com/v2/files/', file.id ,'/actions/copy" -o ', tempfilename, sep=""))
    rawjson <- RJSONIO::fromJSON(tempfilename)
    rawjson
}
    

# projname=paste0(pipeowner,"/", pipeproj)
# projname = "JSALZMAN/machete"
#
# Get names and ids for the 43 "infile" files; output is a list of
#    objects of class Files
get.infile.names.and.ids <- function(projname, auth.token, tempdir=tempdir, max.iterations=max.iterations){
    out.project.list <- list.all.files.project(projname=projname, ttwdir=tempdir, tempdir=tempdir, auth.token=auth.token, max.iterations=max.iterations)
    ttnfiles <- out.project.list$n.files
    ttallfilenames <- out.project.list$filenames
    ttallfileids <- out.project.list$fileids
    infile.indices <- grep(pattern="^infile", x= ttallfilenames)
    infile.names <- ttallfilenames[infile.indices]
    infile.ids <- ttallfileids[infile.indices]
    n.infiles <- length(infile.indices)
    infile.array <- vector("list", length= n.infiles)
    for (tti in 1:n.infiles){
        infile.array[[tti]] <- Files(id=infile.ids[[tti]], name=infile.names[[tti]])
    }
    infile.array
}




## infile.etc.info.file = file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata"); projname = "JSALZMAN/machete"

## do this one time and save file for use with running multiple files
get.infile.etc.names.and.ids <- function(projname, auth.token, tempdir=tempdir, max.iterations=max.iterations, infile.etc.info.file){
    infile.array <- get.infile.names.and.ids(projname=projname, auth.token=auth.token, tempdir=tempdir, max.iterations=max.iterations)

    ## USES files HG19exons.tar.gz and
    ##   toyIndelIndices.tar.gz; could change code if needed
    ## gets file info from the project
    out.try <- try(out.project.list <- list.all.files.project(projname=projname, max.iterations=max.iterations,  auth.token=auth.token, ttwdir=wdir, tempdir=tempdir))
    ## if it doesn't work, try again:
    if (class(out.try)=="try-error"){
        ## wlog("\n\nERROR:", out.try.two[1])
        out.project.list <- list.all.files.project(projname=projname, max.iterations=max.iterations,  auth.token=auth.token, ttwdir=wdir, tempdir=tempdir)
    }
    project.filenames <- out.project.list$filenames
    project.fileids <- out.project.list$fileids

    exons.index <- grep(pattern= "^HG19exons.tar.gz$", x=project.filenames)
    if (length(exons.index)!=1){
        errtext= paste0("Problem; not finding exactly one file called HG19exons.tar.gz; very weird.\nFinding these:\n", paste(project.filenames[exons.index],collapse="\n"))
        stop(errtext)
}
    exons.Files.object <- Files(id=project.fileids[exons.index], name=project.filenames[exons.index])

    indels.index <- grep(pattern= "^toyIndelIndices.tar.gz$", x=project.filenames)
    if (length(indels.index)!=1){
        errtext= paste0("Problem; not finding exactly one file called toyIndelIndices.tar.gz; very weird.\nFinding these:\n", paste(project.filenames[indels.index],collapse="\n"))
        stop(errtext)
    }
    indelindices.Files.object <- Files(id=project.fileids[indels.index], name=project.filenames[indels.index])

    save(infile.array, exons.Files.object, indelindices.Files.object, file=infile.etc.info.file)
}


# download.file.from.href(href="https://cgc-api.sbgenomics.com/v2/files/574f5231e4b0edf77da96f03", ttauth=auth, filename="test.txt", tempdir=tempdir)
# href should take this kind of form
# href="https://cgc-api.sbgenomics.com/v2/files/574f5231e4b0edf77da96f03"
download.file.from.href <- function(href, ttauth, filename, tempdir){
   # get url, put it in file called templocation.json
   full.path.tempfile <- file.path(tempdir, "tempfilelocation.json")
   call.curl = paste('curl -s -H "X-SBG-Auth-Token: ', ttauth , '" -H "content-type: application/json" -X GET "', href, '/download_info" -o ', full.path.tempfile , sep="")
   system(call.curl)
   thisfileurl <- RJSONIO::fromJSON(full.path.tempfile)[['url']]
   print(paste("About to download file ", filename, "\n"))
   call2.curl = paste('curl -o ', filename, ' "', thisfileurl, '"', sep="")
   system(call2.curl)
}


# task.id = "4aae8b03-a941-4bb3-8bcb-9f48d46a4f91"; task.short.name="srr"; ttproj="ericfg/mach1"
# task.short.name will be used to make a directory
# Now will unpack glm reports from knife if there and also
#   reports from machete if there
# ASSUMES there are at most 50 files produced by the task!!!
download.files.one.task <- function(task.id, task.short.name, ttwdir, ttauth, ttproj, tempdir, datadir=file.path(ttwdir,"sbdata")){
   # Make directory for files from this task
   dirname = paste(datadir, "/" ,task.short.name, sep="")
   if (dir.exists(dirname) == FALSE){
      dir.create(dirname)
   }
   # Change to the directory for the task
   setwd(dirname)
   # get file list from one task
   filelist.thistask = file.path(tempdir,paste(task.id, ".json", sep=""))
   call.curl = paste('curl -s -H "X-SBG-Auth-Token: ', ttauth , '" -H "content-type: application/json" -X GET "https://cgc-api.sbgenomics.com/v2/files?project=', ttproj, '&origin.task=', task.id, '" -o ', filelist.thistask, sep="")
   system(call.curl)
   print(getwd())
   print(filelist.thistask)
   rawfilelist <- RJSONIO::fromJSON(filelist.thistask)
   nfiles <- length(rawfilelist$items)
   filenames <- sapply(rawfilelist$items, function(x) x[[3]])
   hrefs <- sapply(rawfilelist$items, function(x) x[[1]])
   # Now get download url for each and download it
   for (ii in 1:nfiles){
       download.file.from.href(href=hrefs[ii], ttauth=ttauth, filename=filenames[ii], tempdir=tempdir)
   }
   # Should only be relevant for machete output, but
   #   shouldn't fail if knife output:
   # if there is a glm reports tar file, then unpack it
   #  it will just unpack the first if there is at least one, since
   #  there should be at most one
   glmreportstar<- dir(pattern="glmreportfilesout.tar.gz$")
   if (length(glmreportstar)>=1){
       system(paste("tar -xvzf ", glmreportstar[1])) 
   }
   # Should only be relevant for machete output, but
   #   shouldn't fail if knife output:
   # if there is a reports tar file from machete, then unpack it
   #  it will just unpack the first if there is at least one, since
   #  there should be at most one
   machreportstar<- dir(pattern="machreportsout.tar.gz$")
   if (length(machreportstar)>=1){
       system(paste("tar -xvzf ", machreportstar[1])) 
   }
   # Change back to the working directory, to be cautious
   setwd(ttwdir)
   list(nfiles=nfiles, hrefs=hrefs, filenames=filenames)
}



# task.id = "4aae8b03-a941-4bb3-8bcb-9f48d46a4f91"; task.short.name="srr"; ttproj="ericfg/mach1"
# task.short.name will be used to make a directory
# Now will unpack glm reports from knife if there and also
#   reports from machete if there
# ASSUMES there are at most 50 files produced by the task!!!
# ALSO DOWNLOADS fasta files as of jul 31 2016
## Adding on aug 9 2016:
## only add files if there are no error files
download.onlyreports.one.task <- function(task.id, task.short.name, ttwdir, ttauth, ttproj, tempdir, datadir=file.path(ttwdir,"sbdata")){
   # Make directory for files from this task
   dirname = paste(datadir, "/" , task.short.name, sep="")
   if (dir.exists(dirname) == FALSE){
      dir.create(dirname)
   }
   # Change task id from url, so can paste in whole url if you want:
   if (length(grep(pattern="*http.*", x=task.id))> 0){
       task.id <- basename(task.id)
   }
   # Change to the directory for the task
   setwd(dirname)
   # get file list from one task
   filelist.thistask = file.path(tempdir,paste(task.id, ".json", sep=""))
   call.curl = paste('curl -s -H "X-SBG-Auth-Token: ', ttauth , '" -H "content-type: application/json" -X GET "https://cgc-api.sbgenomics.com/v2/files?project=', ttproj, '&origin.task=', task.id, '" -o ', filelist.thistask, sep="")
   system(call.curl)
   print(getwd())
   print(filelist.thistask)
   rawfilelist <- RJSONIO::fromJSON(filelist.thistask)
   nfiles <- length(rawfilelist$items)
   filenames <- sapply(rawfilelist$items, function(x) x[[3]])
   hrefs <- sapply(rawfilelist$items, function(x) x[[1]])
   indices.errors <- grep("error.in.subprocess.txt", filenames)
   if (length(indices.errors)>=1){
       stopifnot(length(indices.errors)==1)
       errorfile.present <- 1
       if (length(grep("YES", filenames[indices.errors[1]]))>0){
           print("Not downloading; a file YES*.error.in.subprocess.txt is present.\n\n")
           download.yes <- 0
       }
       else {
           download.yes <- 1
       }
   }
   else {
       download.yes <- 1
       print("Downloading; NO file *.error.in.subprocess.txt is present.\n\n")
       errorfile.present <- 0
   }
   ##
   if (download.yes){
       ## Figure out filenames for the two reports tar files
       ##  machreportsout, knifeglmreportfilesout
       ## Actually now also figure out filename for the fasta file
       indices.machreports <- grep(pattern="*machreports*", x=filenames)
       indices.knifeglm <- grep(pattern="*knifeglmreportfiles*", x=filenames)
       index.fasta <- grep(pattern="*.fa$", x=filenames)
       report.hrefs <- hrefs[c(indices.machreports, indices.knifeglm, index.fasta)]
       report.filenames <- filenames[c(indices.machreports, indices.knifeglm, index.fasta)]
       ## Now get download url for each and download it
       if (length(report.hrefs)>=1){
           for (ii in 1:(length(report.hrefs))){
               download.file.from.href(href=report.hrefs[ii], ttauth=ttauth, filename=report.filenames[ii], tempdir=tempdir)
           }
       }
       ## Should only be relevant for machete output, but
       ##   shouldn't fail if knife output:
       ## if there is a glm reports tar file, then unpack it
       ##  it will just unpack the first if there is at least one, since
       ##  there should be at most one
       glmreportstar<- dir(pattern="glmreportfilesout.tar.gz$")
       if (length(glmreportstar)>=1){
           system(paste("tar -xvzf ", glmreportstar[1])) 
       }
       ## Should only be relevant for machete output, but
       ##   shouldn't fail if knife output:
       ## if there is a reports tar file from machete, then unpack it
       ##  it will just unpack the first if there is at least one, since
       ##  there should be at most one
       machreportstar<- dir(pattern="machreportsout.tar.gz$")
       if (length(machreportstar)>=1){
           system(paste("tar -xvzf ", machreportstar[1])) 
       }
       ## Change back to the working directory, to be cautious
   } ## end if download.yes =1
   ##
   ## write text file indicating if errorfile is present
   cat(errorfile.present, file="is.error.file.present.txt",sep="\n",append=FALSE)
   setwd(ttwdir)
   list(nfiles=nfiles, hrefs=hrefs, filenames=filenames, errorfile.present= errorfile.present)
}



## new version sep 2016
## includes output for error file
## it is build off of
##  download.reports.and.fasta.and.outputfjfiles.one.task
##  but changed so that it reports if there is a YES.error.file or not
## 
# task.id = "4aae8b03-a941-4bb3-8bcb-9f48d46a4f91"; task.short.name="srr"; ttproj="ericfg/mach1"
# task.short.name will be used to make a directory
# Now will unpack glm reports from knife if there and also
#   reports from machete if there
# ASSUMES there are at most 50 files produced by the task!!!
# ALSO DOWNLOADS fasta files
## only adds files if there are no error files
## started aug 17 2016
## differs from download.onlyreports.one.task in that it gets
## files like GLM_classInput/7009AAAXX_4val_1__output_FJ.txt
download.reports.new.version <- function(task.id, task.short.name, ttwdir, ttauth, ttproj, tempdir, datadir=file.path(ttwdir,"sbdata")){
   # Make directory for files from this task
   dirname = paste(datadir, "/" , task.short.name, sep="")
   if (dir.exists(dirname) == FALSE){
      dir.create(dirname)
   }
   # Change task id from url, so can paste in whole url if you want:
   if (length(grep(pattern="*http.*", x=task.id))> 0){
       task.id <- basename(task.id)
   }
   # Change to the directory for the task
   setwd(dirname)
   # get file list from one task
   filelist.thistask = file.path(tempdir,paste(task.id, ".json", sep=""))
   call.curl = paste('curl -s -H "X-SBG-Auth-Token: ', ttauth , '" -H "content-type: application/json" -X GET "https://cgc-api.sbgenomics.com/v2/files?project=', ttproj, '&origin.task=', task.id, '" -o ', filelist.thistask, sep="")
   system(call.curl)
   print(getwd())
   print(filelist.thistask)
   rawfilelist <- RJSONIO::fromJSON(filelist.thistask)
   nfiles <- length(rawfilelist$items)
   filenames <- sapply(rawfilelist$items, function(x) x[[3]])
   hrefs <- sapply(rawfilelist$items, function(x) x[[1]])
   indices.errors <- grep("error.in.subprocess.txt", filenames)
   yes.error.file.present <- 0
   if (length(indices.errors)>=1){
       stopifnot(length(indices.errors)==1)
       error.file.present <- 1
       if (length(grep("YES", filenames[indices.errors[1]]))>0){
           print("Not downloading; a file YES*.error.in.subprocess.txt is present.\n\n")
           download.yes <- 0
           yes.error.file.present <- 1
       }
       else {
           download.yes <- 1
       }
   }
   else {
       download.yes <- 1
       print("Downloading; NO file *.error.in.subprocess.txt is present.\n\n")
       error.file.present <- 0
   }
   ##
   if (download.yes){
       ## Figure out filenames for the two reports tar files
       ##  machreportsout, knifeglmreportfilesout
       ## Actually now also figure out filename for the fasta file
       ## and figure out filename for the glmclassinput tarfile
       indices.machreports <- grep(pattern="*machreports*", x=filenames)
       indices.knifeglm <- grep(pattern="*knifeglmreportfiles*", x=filenames)
       index.fasta <- grep(pattern="*.fa$", x=filenames)
       index.glmclassinput <- grep(pattern="*glmclassinputout.tar.gz$", x=filenames)
       report.hrefs <- hrefs[c(indices.machreports, indices.knifeglm, index.fasta,index.glmclassinput)]
       report.filenames <- filenames[c(indices.machreports, indices.knifeglm, index.fasta, index.glmclassinput)]
       ## Now get download url for each and download it
       if (length(report.hrefs)>=1){
           for (ii in 1:(length(report.hrefs))){
               download.file.from.href(href=report.hrefs[ii], ttauth=ttauth, filename=report.filenames[ii], tempdir=tempdir)
           }
       }
       ## Should only be relevant for machete output, but
       ##   shouldn't fail if knife output:
       ## if there is a glm reports tar file, then unpack it
       ##  it will just unpack the first if there is at least one, since
       ##  there should be at most one
       glmreportstar<- dir(pattern="glmreportfilesout.tar.gz$")
       if (length(glmreportstar)>=1){
           system(paste("tar -xvzf ", glmreportstar[1])) 
       }
       ## Should only be relevant for machete output, but
       ##   shouldn't fail if knife output:
       ## if there is a reports tar file from machete, then unpack it
       ##  it will just unpack the first if there is at least one, since
       ##  there should be at most one
       machreportstar<- dir(pattern="machreportsout.tar.gz$")
       if (length(machreportstar)>=1){
           system(paste("tar -xvzf ", machreportstar[1])) 
       }
       ## unpack glm class input tarfile
       glmclassinputtar<- dir(pattern="glmclassinputout.tar.gz$")
       if (length(glmclassinputtar)>=1){
           system(paste("tar -xvzf ", glmclassinputtar[1])) 
       }
       ## if there, mv the FJ.txt file up to the main directory level,
       ## then remove the GLM_classInput directory and what remains
       ##  in it, namely FJ Indels files
       ## At a certain point, we stopped downloading this tar file.
       fjtextfile <- dir(path= "GLM_classInput", pattern = "*FJ.txt")
       if (length(fjtextfile)>=1){
           system("mv GLM_classInput/*FJ.txt .", wait=TRUE)
       }
       system("rm -r GLM_classInput", wait=TRUE)
       ## 
       ## Change back to the working directory, to be cautious
   } ## end if download.yes =1
   ##
   ## write text file indicating if errorfile is present
   cat(error.file.present, file="is.error.file.present.txt",sep="\n",append=FALSE)
   setwd(ttwdir)
   list(nfiles=nfiles, hrefs=hrefs, filenames=filenames, error.file.present= error.file.present, yes.error.file.present=yes.error.file.present)
}



## task.id = "383ea76d-13ab-445e-af28-9d6aa7978506"; task.short.name = "UNCID2200495.bd7708e4e80740e79b9c8071edab66e4.111116UNC10SN2540305BD07BUACXX6TTAGGC"; ttwdir = wdir; ttauth = auth.token; ttproj = "JSALZMAN/machete"; tempdir = tempdir; datadir=file.path(fileinfodir, "headnecksep10")
download.log.file.for.one.task <- function(task.id, task.short.name, ttwdir, ttauth, ttproj, tempdir, datadir=file.path(ttwdir,"sbdata")){
   # Make directory for files from this task
   dirname = paste(datadir, "/" , task.short.name, sep="")
   if (dir.exists(dirname) == FALSE){
      dir.create(dirname)
   }
   # Change task id from url, so can paste in whole url if you want:
   if (length(grep(pattern="*http.*", x=task.id))> 0){
       task.id <- basename(task.id)
   }
   # Change to the directory for the task
   setwd(dirname)
   # get file list from one task
   filelist.thistask = file.path(tempdir,paste(task.id, ".json", sep=""))
   call.curl = paste('curl -s -H "X-SBG-Auth-Token: ', ttauth , '" -H "content-type: application/json" -X GET "https://cgc-api.sbgenomics.com/v2/files?project=', ttproj, '&origin.task=', task.id, '" -o ', filelist.thistask, sep="")
   system(call.curl)
   print(getwd())
   print(filelist.thistask)
   rawfilelist <- RJSONIO::fromJSON(filelist.thistask)
   nfiles <- length(rawfilelist$items)
   filenames <- sapply(rawfilelist$items, function(x) x[[3]])
   hrefs <- sapply(rawfilelist$items, function(x) x[[1]])
   ## Figure out filename for the log file
   index.logfile <- grep(pattern="^log", x=filenames)
   logfile.href <- hrefs[index.logfile]
   ## Now get download url for each and download it
   if (length(logfile.href)>=1){
       for (ii in 1:(length(logfile.href))){
           download.file.from.href(href=logfile.href[ii], ttauth=ttauth, filename=filenames[index.logfile[ii]], tempdir=tempdir)
       }
   }
   setwd(ttwdir)
   filenames
}




## sep 2016
## task.id = "https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/5b59e0d1-b9e3-49bb-ad5a-50d82579a05b/"; task.short.name="testing"; ttproj="JSALZMAN/machete"
## download.knife.text.reports(task.id = "https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/5b59e0d1-b9e3-49bb-ad5a-50d82579a05b/", task.short.name="testing", ttwdir=wdir, ttauth=auth.token, ttproj="JSALZMAN/machete", tempdir=tempdir, datadir=wdir)
## task.short.name will be used to make a directory
## Will unpack glm reports from knife if there
## ASSUMES there are at most 50 files produced by the task!!!
download.knife.text.reports <- function(task.id, task.short.name, ttwdir, ttauth, ttproj, tempdir, datadir=file.path(ttwdir,"sbdata")){
   ## Make directory for files from this task if it doesn't already exist
   dirname = paste(datadir, "/" , task.short.name, sep="")
   if (dir.exists(dirname) == FALSE){
      dir.create(dirname)
   }
   ## Change task id from url, so can paste in whole url if you want:
   if (length(grep(pattern="*http.*", x=task.id))> 0){
       task.id <- basename(task.id)
   }
   ## Change to the directory for the task
   setwd(dirname)
   ## get file list from one task
   filelist.thistask = file.path(tempdir,paste(task.id, ".json", sep=""))
   call.curl = paste('curl -s -H "X-SBG-Auth-Token: ', ttauth , '" -H "content-type: application/json" -X GET "https://cgc-api.sbgenomics.com/v2/files?project=', ttproj, '&origin.task=', task.id, '" -o ', filelist.thistask, sep="")
   system(call.curl)
   print(getwd())
   print(filelist.thistask)
   rawfilelist <- RJSONIO::fromJSON(filelist.thistask)
   nfiles <- length(rawfilelist$items)
   filenames <- sapply(rawfilelist$items, function(x) x[[3]])
   hrefs <- sapply(rawfilelist$items, function(x) x[[1]])
   ## Figure out filenames for the tar file
   indices.knifetext <- grep(pattern="*knifetextfiles*", x=filenames)
   report.href <- hrefs[indices.knifetext]
   report.filename <- filenames[indices.knifetext]
   ## Now get download url and download it
   if (length(report.href)>=1){
       download.file.from.href(href=report.href, ttauth=ttauth, filename=report.filename, tempdir=tempdir)
   }
   ## if there is a knife text files tar file, then unpack it
   ##  it will just unpack the first if there is at least one, since
   ##  there should be at most one
   knifetextfilestar<- dir(pattern="knifetextfiles")
       if (length(knifetextfilestar)>=1){
           system(paste("tar -xvzf ", knifetextfilestar[1])) 
       }
   setwd(ttwdir)
   list(nfiles=nfiles, hrefs=hrefs, filenames=filenames)
}








# run.trim.galore.given.unpacking.task.id(taskid="386d0577-7c37-4561-a3ca-07abaadc8e6a", auth.token=auth.token, trimapp="JSALZMAN/machete/trimgalorev2/0", tempdir=tempdir)
# taskid="cf7e9549-687f-4f26-ac51-b7d5ad09462c"
# use this for running tasks semi-manually
#  ONLY WORKS in machete directory 
run.trim.galore.given.unpacking.task.id <- function(taskid, auth.token=auth.token, trimapp="JSALZMAN/machete/trimgalorev2/0", tempdir=tempdir){
    ttaa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")
    # mm for project, which is typically machete
    ttmm <- ttaa$project(id="JSALZMAN/machete")
    details.unpacking.task <- get.details.of.a.task.from.id(taskid = taskid, auth.token=auth.token, ttwdir=tempdir)
    
    # Get the names and ids of the output files
    unordered.names.unpacked.files <- c(details.unpacking.task$outputs$output_fastq_files[[1]][2], details.unpacking.task$outputs$output_fastq_files[[2]][2])
    unordered.paths.unpacked.files <- c(details.unpacking.task$outputs$output_fastq_files[[1]][1], details.unpacking.task$outputs$output_fastq_files[[2]][1])
    #
    # determine which is forward, which is reverse, from name
    #  although it's probably already in the right order
    determined.files.output <- determine.reverse.and.forward.fastq.files(filenames=unordered.names.unpacked.files)
    # these are the original names, but in the correct order
    #   maybe they were in the right order anyway before, but
    #   this should make them be
    ordered.names.unpacked.files.raw <- as.character(c(determined.files.output$forward.file, determined.files.output$reverse.file))
    index.of.forward.within.unorder.unpacked.files <- which(ordered.names.unpacked.files.raw==unordered.names.unpacked.files[1])
    #
    # Now rename in case the file names have _1 or _2 or _R1 or _R2 in
    #   the middle of the name
    ordered.names.unpacked.files <- vector("character", length =2)
    for (tti in 1:2){
        ordered.names.unpacked.files[tti] <- make.new.file.names.so.nice.for.knife(filename= ordered.names.unpacked.files.raw[tti])
    }
    # do something if doesn't exist or is >=3 or <=0
    #
    # rearrange paths if unordered files in wrong order
    {
    if (index.of.forward.within.unorder.unpacked.files ==1){
        new.indices <- c(1,2)
    }
    else {
        new.indices <- c(2,1)
    }
    }
    # 
    ordered.paths.unpacked.files.raw <- unordered.paths.unpacked.files[new.indices]
    #
    # old names: ordered.names.unpacked.files.raw
    # new names: ordered.names.unpacked.files
    #
    # Now call copy.and.rename to actually create new files with
    #   these names, if they are actually changed 
    #
    {
    if (!identical(ordered.names.unpacked.files, ordered.names.unpacked.files.raw)){
        jsonoutunpacked.from.renaming <- vector("list", length =2)
        for (tti in 1:2){
            jsonoutunpacked.from.renaming[[tti]] <- copy.and.rename.file.on.sb(file.id=ordered.paths.unpacked.files.raw[tti], new.name= ordered.names.unpacked.files[tti], proj.name="JSALZMAN/machete", auth.token=auth.token, tempdir=tempdir)
        }
        # Get id's of the new files
        #   make sure that this is the id of the new file and not
        #   the id of the old file
        ordered.paths.unpacked.files <- as.character(sapply(jsonoutunpacked.from.renaming, "[", 2))
    }
    else {
        ordered.paths.unpacked.files <- ordered.paths.unpacked.files.raw
    }
    } # end if/else 

    # Now run trimgalore task
    nicetime.trim.task <- format(Sys.time(),"%b%d%H%M")
    name.trim.task <- paste("Trim galore for tar file ", details.unpacking.task$inputs$input_archive_file$name, ", first fastq file of which is ", ordered.names.unpacked.files[1], ", drafted at ", nicetime.trim.task, sep="")
    inputs.trim.task <- list(error_rate=0.1,  min_read_length=20, stringency=1, quality=20, read1= Files(id=ordered.paths.unpacked.files[1], name=ordered.names.unpacked.files[1]), read2= Files(id=ordered.paths.unpacked.files[2], name=ordered.names.unpacked.files[2]))
    # 
    # wlog("About to draft and then run ", name.trim.task)
    #  
    trim.task <- ttmm$task_add(name = name.trim.task, description = name.trim.task, app = trimapp, inputs = inputs.trim.task)
    #
    # Now run the task
    trim.task$run()
    trim.task
}





# run.knife.given.trim.galore.task.id(taskid="556b7741-6812-4632-8fcf-4cb34104cd17", auth.token=auth.token, knifeapp="JSALZMAN/machete/knife-for-work", tempdir=tempdir, proj.name="JSALZMAN/machete", max.iterations=max.iterations, runid.suffix="", complete.or.appended="appended")
#
# Note that taskid can be the web address for the task also
#  It will remove all but last part if pasting in web address of task:
#  But MUST CONTAIN http in the string somewhere if so
#
# taskid="https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/360861a4-ea6c-44f5-96f5-2f9ed6a35c22/"
#
# use this for running tasks semi-manually
#  ONLY WORKS in machete directory 
run.knife.given.trim.galore.task.id <- function(taskid, auth.token=auth.token, knifeapp="JSALZMAN/machete/knife-for-work", tempdir=tempdir, proj.name="JSALZMAN/machete", max.iterations=max.iterations, runid.suffix="", complete.or.appended="appended"){
    ttaa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")
    # mm for project, which is typically machete
    ttmm <- ttaa$project(id="JSALZMAN/machete")
    # Remove all but last part if pasting in web address of task:
    if (length(grep(pattern="*http.*", x=taskid))> 0){
        taskid <- basename(taskid)
    }
    details.trim.task <- get.details.of.a.task.from.id(taskid = taskid, auth.token=auth.token, ttwdir=tempdir)

    # Get outputs from trim task 

    # NOTE THAT these are ordered, 1 is forward, 2 reverse:
    trimmed.files.info.raw <- list(details.trim.task$outputs$trim_read1, details.trim.task$outputs$trim_read2)
    trimmed.filenames.raw <- as.character(sapply(trimmed.files.info.raw, "[", 2) )
    trimmed.paths <- as.character(sapply(trimmed.files.info.raw, "[", 1))
    #
    # Rename val files, because of e.g. _1_val before _1.fq.gz
    #    or _R1_val before _R1.fq.gz
    trimmed.filenames.new <- vector("character", length=2) 
    trimmed.filenames.new[1] <- gsub(pattern="1_val", replacement="val", x = gsub(pattern="(_1_val|_R1_val)", replacement="val", x=trimmed.filenames.raw[1]))
    trimmed.filenames.new[2] <- gsub(pattern="2_val", replacement="val", x = gsub(pattern="(_2_val|_R2_val)", replacement="val", x=trimmed.filenames.raw[2]))
    #
    # Check that these new file names match
    # This fails if they do not match; actually does more, but that is ok
    #  So note that we do not care about the output. We just want
    #   to get an error if there is a problem.
    out.determine <- determine.reverse.and.forward.fastq.files(filenames = trimmed.filenames.new)
    # Now use api to rename the files
    # use copy call
    # Now call copy.and.rename to actually create new files with
    #   these names, if they are actually changed 
    #
    {
    if (!identical(trimmed.filenames.new, trimmed.filenames.raw)){
        cat("Renaming files, specifically to get rid of strings like\n_1_val or _R1_val inserted into the file name by trim galore:\n Original names are:\n", paste(trimmed.filenames.raw, collapse="\n"), "\nNew names are:\n", paste(trimmed.filenames.new, collapse="\n"), "\n")
        jsonout.from.renaming <- vector("list", length =2)
        for (tti in 1:2){
            jsonout.from.renaming[[tti]] <- copy.and.rename.file.on.sb(file.id=trimmed.paths[tti], new.name= trimmed.filenames.new[tti], proj.name=proj.name, auth.token=auth.token, tempdir=tempdir)
        }
        # Get id's of the new files 
        # 
        trimmed.paths.new <- as.character(sapply(jsonout.from.renaming, "[", 2))
    } # end if
    else {
        trimmed.paths.new <- trimmed.paths
    }
    } # end if/else
    infile.array <- get.infile.names.and.ids(projname=proj.name, auth.token=auth.token, tempdir=tempdir, max.iterations=max.iterations)
    #
    # Now set up the draft knife task 
    nicedate<- tolower(format(Sys.time(),"%b%d"))
    runid <- paste0(nicedate,runid.suffix)
    nicetime.knife.task <- format(Sys.time(),"%b%d%H%M")
    name.knife.task <- paste("Knife for fastq files, first of which is ",details.trim.task$inputs$read1$name , ", ", complete.or.appended, ", drafted at ", nicetime.knife.task, sep="")
    #
    niceish.name <- gsub(pattern="( |_|val)", replacement="", x=gsub(pattern = "(_1|_R1)(\\.fastq|\\.fq|\\.fastq.gz|\\.fq.gz)$", replacement ="", x=trimmed.filenames.new[1]))
    inputs.knife <- list(inputarray=infile.array,  fastqfiles=list(Files(id=trimmed.paths.new[1], name=trimmed.filenames.new[1]), Files(id=trimmed.paths.new[2], name=trimmed.filenames.new[2])),  datasetname=niceish.name,  readidstyle=complete.or.appended,  runid=runid)
    #
    cat("About to draft and then run ", name.knife.task)
    knife.task <- ttmm$task_add(name = name.knife.task, description = name.knife.task, app = knifeapp, inputs = inputs.knife)
    # Now run the knife task
    knife.task$run()
    cat("\n", knife.task$name,"\n\n")
    knife.task
}


# taskid="https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/831bb9a6-af07-45b1-bf06-a56a0621af8e/"; auth.token=auth.token; macheteapp="JSALZMAN/machete/machete-for-work"; tempdir=tempdir; max.iterations=max.iterations; runid.suffix=""; complete.or.appended="appended"
#
# use this for running tasks semi-manually
#  ONLY WORKS in machete directory  
run.machete.given.knife.task.id <- function(taskid, auth.token=auth.token, macheteapp="JSALZMAN/machete/machete-for-work", tempdir=tempdir, max.iterations=max.iterations, runid.suffix="", complete.or.appended="appended"){
    ttaa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")
    # mm for project, which is typically machete
    ttmm <- ttaa$project(id="JSALZMAN/machete")
    # ttmm <- ttaa$project("machete")
    # Remove all but last part if pasting in web address of task:
    if (length(grep(pattern="*http.*", x=taskid))> 0){
        taskid <- basename(taskid)
    }
    details.knife.task <- get.details.of.a.task.from.id(taskid = taskid, auth.token=auth.token, ttwdir=tempdir)

    datasetname <- details.knife.task$inputs$datasetname
    runid <- details.knife.task$inputs$runid

    knifeoutputtarballs <- details.knife.task$outputs$outputtarballs
    knifeoutputtarballnames <- sapply(knifeoutputtarballs, FUN=function(x){ x[2]})
    index.knifeoutput.within.tarballs <- grep(pattern="*outputdir", knifeoutputtarballnames)
    # Check that the index has length 1
    if (length(index.knifeoutput.within.tarballs)!=1){
        errtext <- paste0("ERROR in run.machete.given.knife.task.id: length(index.knifeoutput.within.tarballs)!=1, but it should be 1.\n knifeoutputtarballs look like\n", paste(knifeoutputtarballs, collapse="\n"), "\nIndex is\n", paste(index.knifeoutput.within.tarballs, collapse = "\n"))
        stop(errtext) 
    }
    knifeoutputdetails <- details.knife.task$outputs$outputtarballs[[index.knifeoutput.within.tarballs]]
    names(knifeoutputdetails) <- NULL
    knifeoutputtarname <- knifeoutputdetails[2]
    knifeoutputtarpath <- knifeoutputdetails[1]
    
    # get project and project owner from task
    projname <- details.knife.task$project

    # get names and ids of infile files, output list of Files object
    infile.array <- get.infile.names.and.ids(projname=projname, auth.token=auth.token, tempdir=tempdir, max.iterations=max.iterations)
    
    # USES files HG19exons.tar.gz and
    #   toyIndelIndices.tar.gz; could change code if needed
    # gets file info from the project
    out.project.list <- list.all.files.project(projname=projname, max.iterations=max.iterations,  auth.token=auth.token, ttwdir=wdir, tempdir=tempdir)
    project.filenames <- out.project.list$filenames
    project.fileids <- out.project.list$fileids


    exons.index <- grep(pattern= "^HG19exons.tar.gz$", x=project.filenames)
    if (length(exons.index)!=1){
        errtext= paste0("Problem; not finding exactly one file called HG19exons.tar.gz; very weird.\nFinding these:\n", paste(project.filenames[exons.index],collapse="\n"))
    }
    exons.Files.object <- Files(id=project.fileids[exons.index], name=project.filenames[exons.index])

    indels.index <- grep(pattern= "^toyIndelIndices.tar.gz$", x=project.filenames)
    if (length(indels.index)!=1){
        errtext= paste0("Problem; not finding exactly one file called toyIndelIndices.tar.gz; very weird.\nFinding these:\n", paste(project.filenames[indels.index],collapse="\n"))
    }
    indelindices.Files.object <- Files(id=project.fileids[indels.index], name=project.filenames[indels.index])
    
    # Set up draft machete task
    nicetime.machete.task <- format(Sys.time(),"%b%d%H%M")

    name.machete.task <- paste("Machete for files, first of which is ", details.knife.task$inputs$fastqfiles[[1]]$name, ", drafted at ", nicetime.machete.task, sep="")

    
    inputs.machete <- list(inputarray=infile.array, knifeoutputtarball = Files(id= knifeoutputtarpath, name=knifeoutputtarname), exons= exons.Files.object, indel_indices=indelindices.Files.object, datasetname=datasetname, runid=runid)

    machete.task <- ttmm$task_add(name = name.machete.task, description = name.machete.task,  app = macheteapp, inputs = inputs.machete)
    machete.task$run()
    
    cat("\n", machete.task$name,"\n\n")
    machete.task
}





#
# use this for running tasks semi-manually
#  ONLY WORKS in machete project
run.spachete.given.knife.task.id <- function(taskid, auth.token=auth.token, spacheteapp="JSALZMAN/machete/spachetealpha", tempdir=tempdir, max.iterations=max.iterations, runid.suffix="", complete.or.appended="appended"){
    ttaa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")
    # mm for project, which is typically machete
    ttmm <- ttaa$project(id="JSALZMAN/machete")
    # ttmm <- ttaa$project("machete")
    # Remove all but last part if pasting in web address of task:
    if (length(grep(pattern="*http.*", x=taskid))> 0){
        taskid <- basename(taskid)
    }
    details.knife.task <- get.details.of.a.task.from.id(taskid = taskid, auth.token=auth.token, ttwdir=tempdir)

    datasetname <- details.knife.task$inputs$datasetname
    runid <- details.knife.task$inputs$runid

    knifeoutputtarballs <- details.knife.task$outputs$outputtarballs
    knifeoutputtarballnames <- sapply(knifeoutputtarballs, FUN=function(x){ x[2]})
    index.knifeoutput.within.tarballs <- grep(pattern="*outputdir", knifeoutputtarballnames)
    # Check that the index has length 1
    if (length(index.knifeoutput.within.tarballs)!=1){
        errtext <- paste0("ERROR in run.spachete.given.knife.task.id: length(index.knifeoutput.within.tarballs)!=1, but it should be 1.\n knifeoutputtarballs look like\n", paste(knifeoutputtarballs, collapse="\n"), "\nIndex is\n", paste(index.knifeoutput.within.tarballs, collapse = "\n"))
        stop(errtext) 
    }
    knifeoutputdetails <- details.knife.task$outputs$outputtarballs[[index.knifeoutput.within.tarballs]]
    names(knifeoutputdetails) <- NULL
    knifeoutputtarname <- knifeoutputdetails[2]
    knifeoutputtarpath <- knifeoutputdetails[1]
    
    # get project and project owner from task
    projname <- details.knife.task$project

    # get names and ids of infile files, output list of Files object
    infile.array <- get.infile.names.and.ids(projname=projname, auth.token=auth.token, tempdir=tempdir, max.iterations=max.iterations)
    
    # USES files HG19exons.tar.gz and
    #   toyIndelIndices.tar.gz; could change code if needed
    # gets file info from the project
    out.project.list <- list.all.files.project(projname=projname, max.iterations=max.iterations,  auth.token=auth.token, ttwdir=wdir, tempdir=tempdir)
    project.filenames <- out.project.list$filenames
    project.fileids <- out.project.list$fileids


    exons.index <- grep(pattern= "^HG19exons.tar.gz$", x=project.filenames)
    if (length(exons.index)!=1){
        errtext= paste0("Problem; not finding exactly one file called HG19exons.tar.gz; very weird.\nFinding these:\n", paste(project.filenames[exons.index],collapse="\n"))
    }
    exons.Files.object <- Files(id=project.fileids[exons.index], name=project.filenames[exons.index])

    indels.index <- grep(pattern= "^toyIndelIndices.tar.gz$", x=project.filenames)
    if (length(indels.index)!=1){
        errtext= paste0("Problem; not finding exactly one file called toyIndelIndices.tar.gz; very weird.\nFinding these:\n", paste(project.filenames[indels.index],collapse="\n"))
    }
    indelindices.Files.object <- Files(id=project.fileids[indels.index], name=project.filenames[indels.index])
    
    # Set up draft spachete task
    nicetime.spachete.task <- format(Sys.time(),"%b%d%H%M")

    name.spachete.task <- paste("Spachete for files, first of which is ", details.knife.task$inputs$fastqfiles[[1]]$name, ", drafted at ", nicetime.spachete.task, sep="")

    
    inputs.spachete <- list(inputarray=infile.array, knifeoutputtarball = Files(id= knifeoutputtarpath, name=knifeoutputtarname), exons= exons.Files.object, indel_indices=indelindices.Files.object, datasetname=datasetname, runid=runid)

    spachete.task <- ttmm$task_add(name = name.spachete.task, description = name.spachete.task,  app = spacheteapp, inputs = inputs.spachete)
    spachete.task$run()
    
    cat("\n", spachete.task$name,"\n\n")
    paste0("https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/",spachete.task$id)
}









##

#
# use this for running one spachete task via API
#  ONLY WORKS in machete project
## typically call this from
##  within run.one.step.spachete.given.knife.task.id
new.run.spachete.given.knife.task.id <- function(taskid, auth.token=auth.token, spacheteapp="JSALZMAN/machete/spachetealpha", tempdir=tempdir, max.iterations=max.iterations, runid.suffix="", complete.or.appended="appended", infile.etc.info.file, grouplog, thisnicefname, spinfodf, line.to.work.on, projname){
    wlogone <- function(...){ write.logs(text=paste0(...,"\n"), logfilenames = grouplog, ttappend = TRUE, screen = TRUE) }
    ttaa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")
    # mm for project, which is always machete in this case
    ttmm <- ttaa$project(id=projname)
    # Remove all but last part if pasting in web address of task:
    if (length(grep(pattern="*http.*", x=taskid))> 0){
        taskid <- basename(taskid)
    }
    details.knife.task <- get.details.of.a.task.from.id(taskid = taskid, auth.token=auth.token, ttwdir=tempdir)
    spinfodf$name.knife[line.to.work.on] <- details.knife.task$name

    datasetname <- details.knife.task$inputs$datasetname
    runid <- details.knife.task$inputs$runid

    ## Note that the inputs to spachete and machete are the same, so
    ##  this next thing is OK:
    out.inputs.spachete <- get.inputs.machete.from.knife.details(details.knife.task = details.knife.task, infile.etc.info.file = infile.etc.info.file, logs.to.write=logs.to.write)
    {
        if (out.inputs.spachete$error.in.getting.machete.inputs == TRUE){
            ## if there was a problem getting inputs,
            ## then alldone <- TRUE
            wlogone("ERROR ERROR. Problem getting inputs for the spachete task following the task ", thisspinfo$name.knife, ". Not continuing running for this file, namely file ", thisnicefname, " with file id ", thisspinfo$id.file, ". Line number of file: ", line.to.work.on)
            spinfodf$alldone[line.to.work.on] <- TRUE
            spinfodf$error.in.getting.spachete.inputs[line.to.work.on] <- TRUE
        }
        else {
            ## Set up draft spachete task
            spinfodf$error.in.getting.spachete.inputs[line.to.work.on] <- FALSE
            nicetime.spachete.task <- format(Sys.time(),"%b%d%H%M")
            name.spachete.task <- paste("Spachete for knife task with name ", details.knife.task$name, "; for file ", thisnicefname, ", drafted at ", nicetime.spachete.task, sep="")
            inputs.spachete <- out.inputs.spachete$inputs.machete
            spachete.task <- ttmm$task_add(name = name.spachete.task, description = name.spachete.task,  app = spacheteapp, inputs = inputs.spachete)
            wlogone(text=paste0("Drafting ", name.spachete.task,"\nId is:\n", spachete.task$id), ttappend=TRUE, screen=TRUE)
            spachete.task$run()
            spinfodf$id.spachete[line.to.work.on] <- spachete.task$id
            spinfodf$name.spachete[line.to.work.on] <- spachete.task$name
            spinfodf$spachete.started[line.to.work.on] <- TRUE
        }
    }
    list(spinfodf = spinfodf, spachete.task = spachete.task)
}







##   auth.token=auth.token, spacheteapp=spacheteapp, tempdir=tempdir, max.iterations=max.iterations, runid.suffix=run.id.suffix, complete.or.appended=complete.or.appended, spinfofile=spinfofile, grouplog =grouplog
# line.to.work.on=ii.line; infile.etc.info.file = infile.etc.info.file



## This is made for use in running a lot of spachetes at once, i.e.
##    as part of a larger program. 
## This assumes there is already an "infofile" called spinfofile made.
run.one.step.spachete.given.knife.task.id <- function(auth.token=auth.token, spacheteapp="JSALZMAN/machete/spachetealpha", tempdir=tempdir, max.iterations=max.iterations, runid.suffix="", complete.or.appended="appended", spinfofile, line.to.work.on, grouplog, infile.etc.info.file, projname, groupdir){
    wlogone <- function(...){ write.logs(text=paste0(...,"\n"), logfilenames = grouplog, ttappend = TRUE, screen = TRUE) }
    ## 
    ## read in spinfofile
    spinfodf <- read.table(file = spinfofile, header = TRUE, sep = ",", stringsAsFactors = FALSE)
    thisnicefname <- spinfodf$nicefname[line.to.work.on]
    thisspinfo <- spinfodf[line.to.work.on,]
    ## Now check what status is, and proceed accordingly
    ##
    ## 1. Is the spachete task not even started? If not, then run it.
    if (!spinfodf$spachete.started[line.to.work.on]){
        spachete.run.out <- new.run.spachete.given.knife.task.id(taskid=spinfodf$id.knife[line.to.work.on], auth.token=auth.token, spacheteapp=spacheteapp, tempdir=tempdir, max.iterations=max.iterations, runid.suffix=runid.suffix, complete.or.appended=complete.or.appended, infile.etc.info.file=infile.etc.info.file, grouplog=grouplog, thisnicefname=thisnicefname, spinfodf=spinfodf, line.to.work.on=line.to.work.on, projname=projname)
        # update the spinfodf
        spinfodf <- spachete.run.out$spinfodf
    }
    else {
        ## Now check on status and, if complete, download it
        ## check the status of the task
        ## "QUEUED", "DRAFT", "RUNNING",
        ##  "COMPLETED", "ABORTED", "FAILED"
        thistask.details <- get.details.of.a.task.from.id(taskid = thisspinfo$id.spachete, auth.token=auth.token, ttwdir=tempdir)
        this.status <- thistask.details$status
        ## ########################
        ## if aborted or failed, then stop
        if (this.status %in% c("ABORTED", "FAILED")){
            spinfodf$alldone[line.to.work.on] <- TRUE
            spinfodf$spachete.done[line.to.work.on] <- FALSE
            spinfodf$spachete.aborted.or.failed[line.to.work.on] <- TRUE         }
        else if (this.status == "COMPLETED"){
            wlogone("Task ", thisspinfo$name.spachete, " finished.")
            spinfodf$alldone[line.to.work.on] <- TRUE
            spinfodf$spachete.done[line.to.work.on] <- TRUE
            wlogone("\ntaskinfo,spachete,finished,", thisspinfo$id.spachete, ",", thisnicefname, "\n")
            ## now download spachete results 
            out.download <- download.reports.new.version(task.id=thisspinfo$id.spachete, task.short.name=thisnicefname, ttwdir=groupdir, ttauth=auth.token, ttproj=projname, tempdir=tempdir, datadir=groupdir)
            ## is there any error.file at all and 
            ## is there a YES.error file in the machete when you
            ## download it?
            spinfodf$some.error.file.present[line.to.work.on] <- as.logical(out.download$error.file.present)
            spinfodf$yes.error.file.present[line.to.work.on] <- as.logical(out.download$yes.error.file.present)
            spinfodf$spachete.done[line.to.work.on] <- TRUE
            spinfodf$download.attempted[line.to.work.on] <- TRUE
            taskidforinfo = thisspinfo$id.spachete
            wlogone("\ntaskinfo,spachete,downloadattempted,", taskidforinfo, ",", thisnicefname, "\n")
            ## If you download spachete results, download knife
            ##   text reports also; use try to be cautious 
            out.try.download.knife <- try(download.knife.text.reports(task.id = spinfodf$id.knife[line.to.work.on], task.short.name=thisnicefname, ttwdir=groupdir, ttauth=auth.token, ttproj=projname, tempdir=tempdir, datadir=groupdir))
            task.dir.full <- file.path(groupdir, thisnicefname)
            ## 
            wlogone("\nDone with downloading for ", thisnicefname, ".\nFiles saved in \n", task.dir.full, "\nLine number of file: ", line.to.work.on)
            spinfodf$alldone[line.to.work.on] <- TRUE
        } ## end if (this.status == "COMPLETED")
        else if (this.status %in% c("QUEUED","RUNNING")){
            ## don't do anything
            Sys.sleep(1)
        }
        else {
            wlogone("ERROR ERROR. Task ", thisspinfo$name.spachete, " is either in draft status or something else and this is weird. Killing the pipeline for this file, namely file ", thisnicefname, " with file id ", thisspinfo$id.file, " . Line number of file: ", line.to.work.on)
            spinfodf$alldone[line.to.work.on] <- TRUE
        } ## end else for status choices
    } # end else; in these cases spachete was already started
    ## write spinfodf to file so new info can be retrieved next
    ## time this function is called
    write.table(spinfodf, file = spinfofile, row.names = FALSE, col.names = TRUE, sep = ",", append=FALSE, quote=TRUE)
}



## tarfilenames = file.names.amlspachnov8; nicenames = nicefnames.amlspachnov8; tarfileids = file.ids.amlspachnov8; groupdir = file.path(mydir, "api/sptest"); infile.etc.info.file = file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata"); projname = "JSALZMAN/machete"; knife.ids = knife.ids.amlspachnov8; auth.token=auth.token; spacheteapp="JSALZMAN/machete/spachetealpha", tempdir=tempdir, max.iterations=max.iterations, runid.suffix="", complete.or.appended="appended"; grouplog = grouplog

## run spachete from runs of knife; typically expect this to come
## from runs of machete using api, specifically using exec.n.pipelines
##  
run.n.spachetes.from.knife.task.ids <- function(auth.token, groupdir, grouplog, infile.etc.info.file, projname, tarfileids, tarfilenames, nicenames, knife.ids, tempdir, max.iterations, seconds.of.wait.time.between.runs, run.id.suffix="", complete.or.appended = "appended", spacheteapp="JSALZMAN/machete/spachetealpha", timeout.days=4){
    wlogone <- function(...){ write.logs(text=paste0(...,"\n"), logfilenames = grouplog, ttappend = TRUE, screen = TRUE) }
    ## start this for this function call, whether it's the
    ##  start of all the runs or just resuming
    start.time.this.function.call <- Sys.time()
    ## First look for infofile spinfofile; if not there, make new one
    spinfofile = file.path(groupdir, "spinfofile.csv")
    n.runs <- length(tarfileids)
    ## This is the STARTING case, if the file doesn't already exist
    if (!file.exists(spinfofile)){
        empty.char <- vector("character", length=n.runs)
        bb <- vector("logical", length=n.runs)
        spinfodf <- data.frame(alldone = bb, spachete.started = bb, spachete.done = bb, spachete.aborted.or.failed = bb, id.file = tarfileids, filename = tarfilenames, nicefname = nicenames, id.knife = knife.ids, id.spachete = empty.char, name.knife = empty.char, name.spachete = empty.char, error.in.getting.spachete.inputs = bb, download.attempted = bb, some.error.file.present= bb, yes.error.file.present = bb, stringsAsFactors = FALSE)
        ## some of these are just for clarity
        spinfodf$alldone[] <- FALSE
        spinfodf$spachete.started[] <- FALSE
        spinfodf$spachete.done[] <- NA
        spinfodf$spachete.aborted.or.failed[] <- NA
        spinfodf$id.spachete[] <- NA
        spinfodf$name.knife[] <- NA
        spinfodf$name.spachete[] <- NA
        spinfodf$error.in.getting.spachete.inputs[] <- NA
        spinfodf$download.attempted[] <- FALSE
        spinfodf$some.error.file.present[] <- NA
        spinfodf$yes.error.file.present[] <- NA
        write.table(spinfodf, file = spinfofile, row.names = FALSE, col.names = TRUE, sep = ",", append=FALSE, quote=TRUE)
        wlogone("Just stored initialized info in spinfofile at\n", spinfofile)
        } ## end STARTING CASE
    else {
        ## THIS IS THE CASE OF RESUMING
        ##  if the spinfofile already exists
        resumption.time <- Sys.time()
        wlogone("The time that this started resuming is ", resumption.time)
    }
    ## Now do a loop, and run one step
    n.done <- 0
    vec.of.alldones <- vector("logical", length = n.runs)
    ## for emphasis:
    vec.of.alldones[] <- FALSE
    stop.day.numeric <- as.numeric(as.Date(start.time.this.function.call) + timeout.days)
    notimeout <- TRUE
    line.to.work.on <- 1
    ## Now start while loop
    while (notimeout & (n.done < n.runs)){
        print(paste0("Working on line ", line.to.work.on))
        Sys.sleep(seconds.of.wait.time.between.runs)
        spinfodf <- read.table(file = spinfofile, header = TRUE, sep = ",", stringsAsFactors = FALSE)
        {
            if (spinfodf$alldone[line.to.work.on] == FALSE){
                run.one.step.spachete.given.knife.task.id(auth.token=auth.token, spacheteapp=spacheteapp, tempdir=tempdir, max.iterations=max.iterations, runid.suffix=run.id.suffix, complete.or.appended=complete.or.appended, spinfofile=spinfofile, line.to.work.on=line.to.work.on, grouplog=grouplog, infile.etc.info.file=infile.etc.info.file, projname = projname, groupdir=groupdir)
            }
            else {
                vec.of.alldones[line.to.work.on] <- TRUE
            }
        }
        n.done <- sum(vec.of.alldones)
        ## if line.to.work.on is at the end, go to line 1,
        ## otherwise go to the next line
        line.to.work.on <- ifelse(line.to.work.on == n.runs, 1, line.to.work.on + 1)
        ##
        if (as.numeric(Sys.Date())>= stop.day.numeric){
            notimeout <- FALSE
        }
    } ## end while loop
    wlogone("\n\nExiting while loop in run.n.spachetes.from.knife.task.ids.\n\n")
    end.time <- Sys.time()
    wlogone("The time that this stopped is ", end.time)
}



# ASSUMES there are at most 50 files produced by the machete task!!
#
# intarname="TCGA-13-0883-01A-02R-1569-13_rnaseq_fastq.tar"; intarpath="576d6a09e4b01be096f370a6"
# intarname="cwtar3_rnaseq_fastq.tar"; intarpath="57748dd8e4b03bb2bc269eb2"; auth.token=auth.token; groupname =groupname; grouplog = grouplog; groupcsv=groupcsv; groupdir = groupdir; tempdir=tempdir; groupfailedtaskslog=groupfailedtaskslog; mastercsv = mastercsv; homedir=homedir; home.home=TRUE; complete.or.appended="appended"; pipeowner="JSALZMAN"; pipeproj = "machete"; unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0"; trimapp="JSALZMAN/machete/trimgalorev2"; knifeapp="JSALZMAN/machete/knife-for-work"; macheteapp="JSALZMAN/machete/machete-for-work"; runid.suffix="thirdtest"; seconds.between.checks=60; timeout.days=4;  temprdatadir=NULL
#
# NOTE THAT intarpath is not a path, but an id

# inputs intarfile, grouplog, tarcsv, groupcsv, mastercsv, outputdir should be
#  be full paths
#   runid.suffix adds to something like jun27 or firsttest,
#        default is blank
#   dataset name is determined by the stem todo should make this
#   changeable
#  seconds.between.checks is the number of seconds between checks when
#   monitoring the task; defaults to 60
#  timeout.days is  number of days before timeout just to give
#  an upper bound; default is 4
#  it is crude, doesn't depend what time of day you start

# if no temprdatadir given, doesn't save, but otherwise
#   saves files in the directory given

# spawns and monitors one series of tasks for one tarfile that
#   unpacks to a pair of fastq files
pipeline.one.tarfile <- function(intarname, intarpath, auth.token, groupname, grouplog, groupcsv, groupdir, tempdir, groupfailedtaskslog, mastercsv, homedir, home.home, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp="JSALZMAN/machete/machete-for-work", runid.suffix="", seconds.between.checks=60, timeout.days=4, temprdatadir=NULL){
    # ASSUMES tar file ends in _rnaseq_fastq.tar or .tar.gz
    niceish.name.tar <- gsub(pattern="\\.tar\\.gz", replacement="", x =gsub(pattern="(_|-)", replacement="", x=gsub(pattern="_rnaseq_fastq.tar", replacement="", x=intarname)))
    # niceish.name.tar <- gsub(pattern="(_|-)", replacement="", x=gsub(pattern="_rnaseq_fastq.tar", replacement="", x=intarname))    
    # get a nice time stamp to use when naming thing
    nicetime <- format(Sys.time(),"%b%d%H%M")
    nicedate<- tolower(format(Sys.time(),"%b%d"))
    # directory for this tar file, i.e. for this pipeline
    pipedir <- file.path(groupdir,niceish.name.tar)
    # make pipedir if it doesn't already exist
    if (!dir.exists(pipedir)){
        dir.create(pipedir)
    }
    # Make save.r.data boolean for ease of understanding
    save.r.data <- !(is.null(temprdatadir))
    # make a nice filename for log for this tarfile, call it pipelog
    pipelog <- file.path(pipedir, paste0("log",niceish.name.tar,".txt"))
    # Note that in the below call to machete
    #  logs.to.write is assumed to have
    #  length at least 2 and really length 2 makes the most sense
    logs.to.write <- c(grouplog, pipelog)
    # 
    # Make shorthand so easier to type command to write to logs
    # Now create auth object; aa for auth
    wlog <- function(...){ write.logs(text=paste0(...,"\n"), logfilenames = logs.to.write, ttappend = TRUE, screen = TRUE) }
    wlog("Note that this function assumes that files take forms like\n_R1.fastq or _1.fastq or _R1.fq or _1.fq or with .gz also")
    aa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")
    # mm for project, which is typically machete
    mm <- aa$project(id=paste0(pipeowner,"/",pipeproj))
    # create a draft task
    # no example given with a file as input, so doing the following.
    #  need to confirm with SB, but seems to work
    name.unpacking.task <- paste("Unpacking of ", intarname, " from group ", groupname, "; drafted at ", nicetime, sep="")
    # vec.for.csv is the character vector that will be written
    #   as a line into each of groupcsv and mastercsv
    vec.for.csv <- c(groupname, grouplog, groupcsv, groupdir, groupfailedtaskslog, mastercsv, complete.or.appended, intarname, intarpath, pipelog, name.unpacking.task)
    wlog("About to draft and then run ", name.unpacking.task)
    pipe.unpack.task <- mm$task_add(name = name.unpacking.task, description = paste("Unpacking the tar file", intarname),  app = unpackapp, inputs = list(input_archive_file=Files(id=intarpath, name=intarname)))
    wlog("Just drafted ", name.unpacking.task, "; task id is ", pipe.unpack.task$id) # 
    #
    ###############################################################
    ###############################################################
    # Now run the unpacking task
    ###############################################################
    ###############################################################
    pipe.unpack.task$run()
    #
    taskidforinfo = pipe.unpack.task$id
    wlog("\ntaskinfo,unpack,running,", taskidforinfo, ",", niceish.name.tar, "\n")
    # Then monitor until it's done
    task.status <- monitor.task(seconds.between.checks = seconds.between.checks, tt.task=pipe.unpack.task, timeout.days=timeout.days, logs.to.write=logs.to.write)
    wlog("monitor.task for unpacking task exited with status ", task.status$status)
    # y <- pipe.unpack.task$monitor()
    #
    # if it failed or was aborted, just try one more time, for now
    {
    if (task.status$status %in% c("failed","aborted")){
        failedunpack1 <- paste0("* Failed task ", pipe.unpack.task$href, "\n** ", name.unpacking.task)
        cat(failedunpack1, file=groupfailedtaskslog, sep="\n", append=TRUE)
        name.unpacking.task.two <- paste0("ATTEMPT 2 for ", name.unpacking.task, "; this version drafted at ", format(Sys.time(),"%b%d%H%M"))
        wlog(name.unpacking.task, "failed or was aborted. About to draft and then run ", name.unpacking.task.two)
        pipe.unpack.task.two <- mm$task_add(name = name.unpacking.task.two, description = name.unpacking.task.two,  app = unpackapp, inputs = list(input_archive_file=Files(id=intarpath, name=intarname)))
        wlog("Just drafted ", name.unpacking.task, "; task id is ", pipe.unpack.task.two$id, "\nAbout to run it\n") 
        pipe.unpack.task.two$run()
        taskidforinfo = pipe.unpack.task.two$id
        wlog("\ntaskinfo,unpack,running,", taskidforinfo, ",", niceish.name.tar, "\n")
        task.status.two <- monitor.task(seconds.between.checks = seconds.between.checks, tt.task=pipe.unpack.task.two, timeout.days=timeout.days, logs.to.write= logs.to.write)
        wlog("monitor.task for attempt 2 of unpacking task exited with status", task.status.two$status)
        if (task.status.two$status %in% c("failed","aborted")){
            failedunpack2 <- paste0("* ATTEMPT 2 failed task ", pipe.unpack.task.two$href, "\n** ", name.unpacking.task.two)
            cat(failedunpack2, file=groupfailedtaskslog, sep="\n", append=TRUE) 
            msg <- paste0("ERROR: unpacking task FAILED TWICE for tar file ", intarname, " with id=", intarpath)
            write.logs(text=msg, logfilenames = logs.to.write, ttappend=TRUE, screen=TRUE)
            stop(msg)
        }
        else {
            finished.task <- pipe.unpack.task.two
        }
    } # end if task.status$status %in% ...
    else {
        finished.task <- pipe.unpack.task
    }
    } # end if/else
    wlog("Task ", finished.task$name, " finished.")
    taskidforinfo = finished.task$id
    wlog("\ntaskinfo,unpack,finished,", taskidforinfo, ",", niceish.name.tar, "\n")

    #
    #
    # Now suppose we have a successful task; otherwise we stopped
    #   and need to handle it manually.
    #
    vec.for.csv <- append(vec.for.csv, c(finished.task$id, finished.task$start_time, finished.task$end_time))
    #
    if (save.r.data){
        save.image(file=file.path(temprdatadir,"afterunpack.Rdata"))
    }

    # should check this in case running or queued or something else got
        # through  TODO
    #
    # Get the names and ids of the output files
    unordered.names.unpacked.files <- c(finished.task$outputs$output_fastq_files[[1]]$name, finished.task$outputs$output_fastq_files[[2]]$name)
    unordered.paths.unpacked.files <- c(finished.task$outputs$output_fastq_files[[1]]$path, finished.task$outputs$output_fastq_files[[2]]$path)
    #
    # determine which is forward, which is reverse, from name
    #  although it's probably already in the right order
    determined.files.output <- determine.reverse.and.forward.fastq.files(filenames=unordered.names.unpacked.files)
    # these are the original names, but in the correct order
    #   maybe they were in the right order anyway before, but
    #   this should make them be
    ordered.names.unpacked.files.raw <- as.character(c(determined.files.output$forward.file, determined.files.output$reverse.file))
    index.of.forward.within.unorder.unpacked.files <- which(ordered.names.unpacked.files.raw==unordered.names.unpacked.files[1])
    #
    # Now rename in case the file names have _1 or _2 or _R1 or _R2 in
    #   the middle of the name
    ordered.names.unpacked.files <- vector("character", length =2)
    for (tti in 1:2){
        ordered.names.unpacked.files[tti] <- make.new.file.names.so.nice.for.knife(filename= ordered.names.unpacked.files.raw[tti])
    }
    # do something if doesn't exist or is >=3 or <=0 TODO
    #
    # rearrange paths if unordered files in wrong order
    {
    if (index.of.forward.within.unorder.unpacked.files ==1){
        new.indices <- c(1,2)
    }
    else {
        new.indices <- c(2,1)
    }
    }
    # 
    ordered.paths.unpacked.files.raw <- unordered.paths.unpacked.files[new.indices]
    #
    # old names: ordered.names.unpacked.files.raw
    # new names: ordered.names.unpacked.files
    #
    # Now call copy.and.rename to actually create new files with
    #   these names, if they are actually changed
    #
    {
    if (!identical(ordered.names.unpacked.files, ordered.names.unpacked.files.raw)){
        jsonoutunpacked.from.renaming <- vector("list", length =2)
        for (tti in 1:2){
            jsonoutunpacked.from.renaming[[tti]] <- copy.and.rename.file.on.sb(file.id=ordered.paths.unpacked.files.raw[tti], new.name= ordered.names.unpacked.files[tti], proj.name=paste0(pipeowner,"/",pipeproj), auth.token=auth.token, tempdir=tempdir)
        }
        # Get id's of the new files
        #   make sure that this is the id of the new file and not
        #   the id of the old file
        ordered.paths.unpacked.files <- as.character(sapply(jsonoutunpacked.from.renaming, "[", 2))
    }
    else {
        ordered.paths.unpacked.files <- ordered.paths.unpacked.files.raw
    }
    } # end if/else
    # aabb
    wlog("Original ordered names of unpacked files, forward, then reverse, are:\n", paste(ordered.names.unpacked.files.raw, collapse="\n"))
    wlog("Original ordered paths of unpacked files, forward, then reverse, are:\n", paste(ordered.paths.unpacked.files.raw, collapse="\n"))
    wlog("New ordered names of unpacked files, forward, then reverse, are:\n", paste(ordered.names.unpacked.files, collapse="\n"))
    wlog("New ordered paths of unpacked files, forward, then reverse, are:\n", paste(ordered.paths.unpacked.files, collapse="\n"))
    #
    vec.for.csv <- append(vec.for.csv, c(ordered.names.unpacked.files.raw, ordered.paths.unpacked.files.raw, ordered.names.unpacked.files, ordered.paths.unpacked.files))
    # desc.vec.for.csv <- c("tarfilename","tarfileid","name.of.unpacking.task.first.try", "completed.unpacking.task.id", "completed.unpacking.task.start.time", "completed.unpacking.task.end.time", "forward.fastq.file", "reverse.fastq.file", "forward.fastq.id", "reverse.fastq.id")
    #
    #
    #############################################################
    #############################################################
    # Now run trimgalore task
    #############################################################
    #############################################################
    #
    nicetime.trim.task <- format(Sys.time(),"%b%d%H%M")
    name.trim.task <- paste("Trim galore for tar file ", niceish.name.tar, " from group ", groupname, "; first fastq file is ", ordered.names.unpacked.files[1], ", drafted at ", nicetime.trim.task, sep="")
    desc.trim.task <- name.trim.task
    # name.trim.task <- paste("Running trim galore on fastq files in ", niceish.name.tar, ", drafted at ", nicetime.trim.task, sep="")
    # desc.trim.task <- paste("Trim galore for tar file ", niceish.name.tar, ", first fastq file of which is ", ordered.names.unpacked.files[1], ", drafted at ", nicetime.trim.task, sep="")
    #
    # vec.for.csv is the character vector that will be written
    #   as a line into each of groupcsv and mastercsv 
    vec.for.csv <- append(vec.for.csv,c(name.trim.task, nicetime.trim.task))
    inputs.trim.task <- list(error_rate=0.1,  min_read_length=20, stringency=1, quality=20, read1= Files(id=ordered.paths.unpacked.files[1], name=ordered.names.unpacked.files[1]), read2= Files(id=ordered.paths.unpacked.files[2], name=ordered.names.unpacked.files[2]))
    # 
    wlog("About to draft and then run ", name.trim.task)
    #  
    trim.task <- mm$task_add(name = name.trim.task, description = desc.trim.task, app = trimapp, inputs = inputs.trim.task)
    #
    # Now run the task
    trim.task$run()
    taskidforinfo = trim.task$id
    wlog("\ntaskinfo,trim,running,", taskidforinfo, ",", niceish.name.tar, "\n")

    #
    # Then monitor until it's done
    trim.task.status <- monitor.task(seconds.between.checks = seconds.between.checks, tt.task=trim.task, timeout.days=timeout.days, logs.to.write=logs.to.write)
    #
    wlog("First trim task ", name.trim.task, " finished with status ", trim.task.status$status)
    # 
    {
    if (trim.task.status$status %in% c("failed","aborted")){
        failedtrim1 <- paste0("* Failed task ", trim.task$href, "\n** ", name.trim.task)
        cat(failedtrim1, file=groupfailedtaskslog, sep="\n", append=TRUE)
        wlog(failedtrim1)
        nicetime.trim.task.two <- format(Sys.time(),"%b%d%H%M")
        #         name.trim.task.two <- paste("ATTEMPT 2: Trim galore for tar file ", niceish.name.tar, ", first fastq file of which is ", ordered.names.unpacked.files[1], ", drafted at ", nicetime.trim.task.two, sep="")
        name.trim.task.two <- paste("ATTEMPT 2 for ", name.trim.task, "; this version drafted at ", nicetime.trim.task.two, sep="")
        # paste("ATTEMPT 2: Running trim galore on fastq files in ", niceish.name.tar, ", drafted at ", nicetime.trim.task.two, sep="")
        wlog("About to draft and then run ", name.trim.task.two)
        trim.task.two <- mm$task_add(name = name.trim.task.two, description = name.trim.task.two,  app = trimapp, inputs = inputs.trim.task)
        trim.task.two$run()
        taskidforinfo = trim.task.two$id
        wlog("\ntaskinfo,trim,running,", taskidforinfo, ",", niceish.name.tar, "\n")
        trim.task.status.two <- monitor.task(seconds.between.checks = seconds.between.checks, tt.task=pipe.unpack.task.two, timeout.days=timeout.days, logs.to.write= logs.to.write)
        if (trim.task.status.two$status %in% c("failed","aborted")){
            msg <- paste0("ERROR: trim galore task FAILED TWICE for tar file ", intarname, "located at ", intarpath, " with task id=", trim.task.two$id)
            write.logs(text=msg, logfilenames = logs.to.write, ttappend=TRUE, screen=TRUE)
            failedtrim2 <- paste0("* ATTEMPT 2 failed task ", trim.task.two$href, "\n** ", name.trim.task.two)
            cat(failedtrim2, file=groupfailedtaskslog, sep="\n", append=TRUE) 
            stop(msg)
        }
        else {
            finished.trim.task <-trim.task.two
        }
    } # end if task.status$status %in% ..
    else {
        finished.trim.task <-trim.task
    }
    } # end if/else
    wlog("Task ", finished.trim.task$name, " finished with status ", trim.task.status$status)
    taskidforinfo = finished.trim.task$id
    wlog("\ntaskinfo,trim,finished,", taskidforinfo, ",", niceish.name.tar, "\n")
    #

    vec.for.csv <- append(vec.for.csv,c(finished.trim.task$name, finished.trim.task$id))

    if (save.r.data){
        save.image(file=file.path(temprdatadir,"aftertrim.Rdata"))
    }

    
    # Get outputs from trim task 

    # NOTE THAT these are ordered, 1 is forward, 2 reverse:
    trimmed.files.info.raw <- list(finished.trim.task$outputs$trim_read1, finished.trim.task$outputs$trim_read2)
    trimmed.filenames.raw <- as.character(sapply(trimmed.files.info.raw, "[", 2) )
    trimmed.paths <- as.character(sapply(trimmed.files.info.raw, "[", 1))
    #
    # Rename val files, because of e.g. _1_val before _1.fq.gz
    #    or _R1_val before _R1.fq.gz
    trimmed.filenames.new <- vector("character", length=2) 
    trimmed.filenames.new[1] <- gsub(pattern="(_1_val|_R1_val)", replacement="val", x=trimmed.filenames.raw[1])
    trimmed.filenames.new[2] <- gsub(pattern="(_2_val|_R2_val)", replacement="val", x=trimmed.filenames.raw[2])
    wlog("Checking new names of validated files that will be assigned do indeed match.\n")
    # Check that these new file names match
    # This fails if they do not match; actually does more, but that is ok
    #  So note that we do not care about the output. We just want
    #   to get an error if there is a problem.
    out.determine <- determine.reverse.and.forward.fastq.files(filenames = trimmed.filenames.new)
    # Now use api to rename the files
    # use copy call
    # Now call copy.and.rename to actually create new files with
    #   these names, if they are actually changed 
    #
    {
    if (!identical(trimmed.filenames.new, trimmed.filenames.raw)){
        wlog("Renaming files, specifically to get rid of strings like\n_1_val or _R1_val inserted into the file name by trim galore:\n Original names are:\n", paste(trimmed.filenames.raw, collapse="\n"), "\nNew names are:\n", paste(trimmed.filenames.new, collapse="\n"))
        jsonout.from.renaming <- vector("list", length =2)
        for (tti in 1:2){
            jsonout.from.renaming[[tti]] <- copy.and.rename.file.on.sb(file.id=trimmed.paths[tti], new.name= trimmed.filenames.new[tti], proj.name=paste0(pipeowner,"/",pipeproj), auth.token=auth.token, tempdir=tempdir)
        }
        # Get id's of the new files 
        #   make sure that this is the id of the new file and not
        #   the id of the old file
        # 
        trimmed.paths.new <- as.character(sapply(jsonout.from.renaming, "[", 2))
    } # end if
    else {
        trimmed.paths.new <- trimmed.paths
    }
    }
    niceish.name <- gsub(pattern="( |_|val)", replacement="", x=gsub(pattern = "(_1|_R1)(\\.fastq|\\.fq|\\.fastq.gz|\\.fq.gz)$", replacement ="", x=trimmed.filenames.new[1]))
    #
    vec.for.csv <- append(vec.for.csv, c(trimmed.filenames.raw, trimmed.paths, trimmed.filenames.new, trimmed.paths.new))
    #
    ###############################################################
    ###############################################################
    # Now start a knife draft task
    ###############################################################
    ###############################################################
    #

    # List of all the "infiles", the 43 auxiliary input files
    # 
    out.try <- try(infile.array <- get.infile.names.and.ids(projname=paste0(pipeowner,"/", pipeproj), auth.token=auth.token, tempdir=tempdir, max.iterations=max.iterations))
    # if it doesn't work, try again:
    if (class(out.try)=="try-error"){
        wlog("\n\nERROR:", out.try[1])
        infile.array <- get.infile.names.and.ids(projname=paste0(pipeowner,"/", pipeproj), auth.token=auth.token, tempdir=tempdir, max.iterations=max.iterations)
    }
    #
    # Now set up the draft knife task
    runid = paste0(nicedate,runid.suffix)
    nicetime.knife.task <- format(Sys.time(),"%b%d%H%M")
    name.knife.task <- paste("Knife for ", niceish.name, ", from tar file ", niceish.name.tar," from group ", groupname, "; ", complete.or.appended, ", drafted at ", nicetime.knife.task, sep="")
    # paste0("Knife run for ", niceish.name, "for runid ", runid, " drafted at ", format(Sys.time(),"%b%d%H%M"))
    desc.knife.task <- name.knife.task
    inputs.knife <- list(inputarray=infile.array,  fastqfiles=list(Files(id=trimmed.paths.new[1], name=trimmed.filenames.new[1]), Files(id=trimmed.paths.new[2], name=trimmed.filenames.new[2])),  datasetname=niceish.name,  readidstyle=complete.or.appended,  runid=runid)
    #
    wlog("About to draft and then run ", name.knife.task)
    knife.task <- mm$task_add(name = name.knife.task, description = desc.knife.task,  app = knifeapp, inputs = inputs.knife)
    # Now run the knife task
    knife.task$run()
    taskidforinfo = knife.task$id
    wlog("\ntaskinfo,knife,running,", taskidforinfo, ",", niceish.name.tar, "\n")

    #
    # Then monitor it until it's done 
    knife.task.status <- monitor.task(seconds.between.checks = seconds.between.checks, tt.task=knife.task, timeout.days=timeout.days, logs.to.write=logs.to.write)
    wlog("First knife task ", name.knife.task, " finished with status ", knife.task.status$status)

    # if it failed, run knife again
    # 
    {
    if (knife.task.status$status %in% c("failed","aborted")){
        failedknife1 <- paste0("* Failed task ", knife.task$href, "\n** ", name.knife.task)
        cat(failedknife1, file=groupfailedtaskslog, sep="\n", append=TRUE)
        nicetime.knife.task.two <- format(Sys.time(),"%b%d%H%M")
        name.knife.task.two <- paste0("ATTEMPT 2: original is ", knife.task$name, ", this attempt drafted at ", nicetime.knife.task.two, sep="")
        desc.knife.task.two <- name.knife.task.two
        wlog("About to draft and then run ", name.knife.task.two)
        knife.task.two <- mm$task_add(name = name.knife.task.two, description = desc.knife.task.two,  app = knifeapp, inputs = inputs.knife)
        knife.task.two$run()
        taskidforinfo = knife.task.two$id
        wlog("\ntaskinfo,knife,running,", taskidforinfo, ",", niceish.name.tar, "\n")
        knife.task.status.two <- monitor.task(seconds.between.checks = seconds.between.checks, tt.task=knife.task.two, timeout.days=timeout.days, logs.to.write= logs.to.write)
        if (knife.task.status.two$status %in% c("failed","aborted")){
            failedknife2 <- paste0("* ATTEMPT 2 failed task ", knife.task.two$href, "\n** ", name.knife.task.two)
            cat(failedknife2, file=groupfailedtaskslog, sep="\n", append=TRUE) 
            msg <- paste0("ERROR: knife FAILED TWICE for tar file ", intarname, "located at ", intarpath, "; first task id is ", knife.task$id, " and second task id is ", knife.task.two$id)
            write.logs(text=msg, logfilenames = logs.to.write, ttappend=TRUE, screen=TRUE)
            stop(msg)
        }
        else {
            finished.knife.task <-knife.task.two
        }
    } # end if task.status$status %in% ..
    else {
        finished.knife.task <-knife.task
    }
    } # end if/else 
    wlog("Task ", finished.knife.task$name, " finished with status ", knife.task.status$status)
    taskidforinfo = finished.knife.task$id
    wlog("\ntaskinfo,knife,finished,", taskidforinfo, ",", niceish.name.tar, "\n")
    ### 
    ###############################################################
    ###############################################################
    # Now start machete task
    ###############################################################
    ###############################################################

    if (save.r.data){
        save.image(file=file.path(temprdatadir,"afterknife.Rdata"))
    }

    
    call.machete.script<- file.path(homedir, "draftMacheteGivenKnifeTask.R")
    nicedate<- tolower(format(Sys.time(),"%b%d"))
    rdata.file <- file.path(tempdir, paste0(niceish.name,nicedate,".Rdata"))


    # If successful, call R script that creates a draft of the machete:
    cmd.machete <- paste("Rscript", call.machete.script,finished.knife.task$id, paste0(niceish.name,"fromgroup",groupname), homedir, home.home, logs.to.write[1], logs.to.write[2], niceish.name.tar, macheteapp, rdata.file, "2>&1", sep=" ")
    wlog("About to draft machete with command line call\n", cmd.machete)
    
    # Note that intern=TRUE makes the output go to a character vector
    #   this waits for the command to finish b/c intern is
    #   TRUE (that makes wait automatically TRUE)
    #   and
    machete.task.drafting.output <- system(command = cmd.machete, intern=TRUE)
    write.logs(text=paste(machete.task.drafting.output, collapse = "\n"), logfilenames = logs.to.write, ttappend=TRUE, screen=TRUE)
    # load the R objects machete.task and inputs.machete,
    #    which were both saved within the R script
    load(file=rdata.file)

    # Above just creates draft
    # So now run the draft task
    write.logs(text="About to run the machete task just drafted.\n", logfilenames = logs.to.write, ttappend=TRUE, screen=TRUE)
    machete.task$run()
    taskidforinfo = machete.task$id
    wlog("\ntaskinfo,machete,running,", taskidforinfo, ",", niceish.name.tar, "\n")

    # Monitor the task
    machete.task.status <- monitor.task(seconds.between.checks = seconds.between.checks, tt.task=machete.task, timeout.days=timeout.days, logs.to.write=logs.to.write)
    wlog("First machete task ", machete.task$name, " finished with status ", machete.task.status$status)
    

    # if it failed, run again using details in machine.task object
    {
    if (machete.task.status$status %in% c("failed","aborted")){
        failedmachete1 <- paste0("* Failed task ", machete.task$href, "\n** ", machete.task$name)
        cat(failedmachete1, file=groupfailedtaskslog, sep="\n", append=TRUE)
        nicetime.machete.task.two <- format(Sys.time(),"%b%d%H%M")
        name.machete.task.two <- paste0("ATTEMPT 2: original is ", machete.task$name, ", this attempt drafted at ", nicetime.machete.task.two, sep="")
        wlog("About to draft and run second machete attempt, called:\n", name.machete.task.two)
        desc.machete.task.two <- name.machete.task.two
        machete.task.two <- mm$task_add(name = name.machete.task.two, description = desc.machete.task.two,  app = macheteapp, inputs = inputs.machete)
        machete.task.two$run()
        taskidforinfo = machete.task.two$id
        wlog("\ntaskinfo,machete,running,", taskidforinfo, ",", niceish.name.tar, "\n")
        machete.task.status.two <- monitor.task(seconds.between.checks = seconds.between.checks, tt.task=machete.task.two, timeout.days=timeout.days, logs.to.write= logs.to.write)
        if (machete.task.status.two$status %in% c("failed","aborted")){
            failedmachete2 <- paste0("* ATTEMPT 2 failed task ", machete.task.two$href, "\n** ", name.machete.task.two)
            cat(failedmachete2, file=groupfailedtaskslog, sep="\n", append=TRUE) 
            msg <- paste0("ERROR: machete FAILED TWICE for tar file ", intarname, "located at ", intarpath, "; first task id is ", machete.task$id, " and second task id is ", machete.task.two$id)
            write.logs(text=msg, logfilenames = logs.to.write, ttappend=TRUE, screen=TRUE)
            stop(msg)
        }
        else {
            finished.machete.task <-machete.task.two
        }
    } # end if task.status$status %in% ..
    else {
        finished.machete.task <-machete.task
    }
    } # end if/else
    wlog("Task ", finished.machete.task$name, " finished with status ", machete.task.status$status)
    taskidforinfo = finished.machete.task$id
    wlog("\ntaskinfo,machete,finished,", taskidforinfo, ",", niceish.name.tar, "\n")

    if (save.r.data){
        save.image(file=file.path(temprdatadir,"aftermachete.Rdata"))
    }


    
    # Download output from the successful call to machete
    #   If there wasn't one, pipeline should have failed
    
    machete.task.id <- finished.machete.task$id

    # task.dir.base.name <- paste0(groupname, niceish.name)


    # for testing:
    # machete.task.id <- "d957e518-951e-4229-b02d-34970351781c"
    
    # ASSUMES there are at most 50 files produced by the task!!! 
    download.reports.and.fasta.and.outputfjfiles.one.task(task.id=machete.task.id, task.short.name=niceish.name.tar, ttwdir=groupdir, ttauth=auth.token, ttproj=paste0(pipeowner,"/", pipeproj), tempdir=tempdir, datadir=groupdir)
    ## download.onlyreports.one.task(task.id=machete.task.id, task.short.name=niceish.name.tar, ttwdir=groupdir, ttauth=auth.token, ttproj=paste0(pipeowner,"/", pipeproj), tempdir=tempdir, datadir=groupdir)
    # download.onlyreports.one.task(task.id=machete.task.id, task.short.name=task.dir.base.name, ttwdir=groupdir, ttauth=auth.token, ttproj=paste0(pipeowner,"/", pipeproj), tempdir=tempdir, datadir=groupdir)
    # download.files.one.task(task.id=machete.task.id, task.short.name=task.dir.base.name, ttwdir=groupdir, ttauth=auth.token, ttproj=paste0(pipeowner,"/", pipeproj), tempdir=tempdir, datadir=file.path(ttwdir,"sbdata"))
    taskidforinfo = finished.machete.task$id
    wlog("\ntaskinfo,machete,downloadattempted,", taskidforinfo, ",", niceish.name.tar, "\n")
    
    task.dir.full <- file.path(groupdir, niceish.name.tar)
    # task.dir.full <- file.path(groupdir, task.dir.base.name)

    
    wlog("\nDone with pipeline for ", niceish.name.tar, ", which involves, e.g., the file ", trimmed.filenames.new[1],"\nFiles saved in \n", task.dir.full, "\n\n")

    vec.for.csv <- append(vec.for.csv, task.dir.full)
    
    # todo write vec.for.csv to file
    # Write a lot of log messages along way
    #  write header.vec.for.csv in runapi.R file
    write.table(t(vec.for.csv), file = groupcsv, row.names = FALSE, col.names = FALSE, sep = ",", append=TRUE)
    
    # maybe write these to csv if not already written:
    # pipedir, niceish.name, groupname, grouplog, groupcsv, groupdir, mastercsv
    #  id and href for pipe.unpack.task
    #    and id for files from them and status of task
    vec.for.csv
}

# 
# run.n.pipelines(tarfilenames=c("TCGA-13-0765-01A-01R-1564-13_rnaseq_fastq.tar","TCGA-13-0795-01A-01R-1564-13_rnaseq_fastq.tar"), tarfileids=c("577eb413e4b00a1120129fe3","577eb413e4b00a1120129fe2"), pipeline.script=file.path(homedir, "pipeline.R"), auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir=homedir, home.home=home.home, temprdatadir=temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp="JSALZMAN/machete/machete-for-work", runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=2)
# 
# run the whole pipeline for multiple tar files
# tarfilenames and tarfileids are character vectors that should be
#  the same length
# 
run.n.pipelines <- function(tarfilenames, tarfileids, pipeline.script, auth.token, groupname, grouplog, groupcsv, groupdir, tempdir, groupfailedtaskslog, mastercsv, homedir, home.home, temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp="JSALZMAN/machete/machete-for-work", runid.suffix= groupname, seconds.between.checks=60, timeout.days=4, seconds.of.wait.time.between.runs=2){
    n.tarfiles <- length(tarfilenames)
    if (length(tarfileids) != n.tarfiles){
        stop(paste0("ERROR: length(tarfileids) != n.tarfiles, i.e.\n", length(tarfileids), " != ", n.tarfiles, "\n\n"))
    }
    wlog <- function(...){ write.logs(text=paste0(...,"\n"), logfilenames = grouplog, ttappend = TRUE, screen = TRUE) }    
    wlog("Running pipeline on ", n.tarfiles, ". The filenames are:\n", paste(tarfilenames, collapse="\n"), "\n\nThe file ids are:\n", paste(tarfileids, collapse="\n"),"\n\n")
    # Now do loop
    for (tti in 1:n.tarfiles){
        pipeline.cmd <- paste("Rscript", pipeline.script, tarfilenames[tti], tarfileids[tti], auth.token, groupname, grouplog, groupcsv, groupdir, tempdir, groupfailedtaskslog, mastercsv, homedir, home.home, complete.or.appended, pipeowner, pipeproj, unpackapp, trimapp, knifeapp, macheteapp, runid.suffix, seconds.between.checks, timeout.days, temprdatadir, "2>&1", sep=" ")
        wlog(pipeline.cmd)
        system(command=pipeline.cmd, wait=FALSE, intern=FALSE)
        # wait a few seconds before launching next one, to
        #  make viewing of R output easier and to make sure
        #  one doesn't hit the rate limit
        # http://docs.cancergenomicscloud.org/v1.0/docs/the-cgc-api#section-rate-limits
        Sys.sleep(seconds.of.wait.time.between.runs)
    }
    wlog("Done with the calling of each pipeline in run.n.pipelines, first file of which is \n", tarfilenames[1])
}


# get.one.filename.from.fileid(fileid="576d6a09e4b01be096f370a6", allnames=alltarnames, allids=alltarids)
get.one.filename.from.fileid <- function(fileid, allnames, allids){
    tfvec <- (allids == fileid)
    { # start if/else
    if (any(is.na(tfvec))){
        stop(paste0("Error: fileid ", fileid, " is giving NAs\n"))
    }
    else if (sum(tfvec)>=2){
        stop(paste0("Error: fileid ", fileid, " is giving more than two matches\n"))
    }
    else if (sum(tfvec)==0){
        stop(paste0("Error: fileid ", fileid, " is giving 0 matches\n"))
    }
    }
    allnames[which(tfvec==1)]
}

# get.filenames.from.fileids(fileids=c("576d6a09e4b01be096f370a6","57748dd8e4b03bb2bc269eb2"), allnames=alltarnames, allids=alltarids)
# 
# vectorized version of the above
get.filenames.from.fileids <- function(fileids, allnames, allids){
	sapply(seq(along=fileids),FUN =function(i) get.one.filename.from.fileid(fileids[i],allnames=allnames, allids=allids))
}

# for use in editing only, for changing vec.for.csv to header
vfconv <- function(x){
    gsub(pattern=",", replacement="\",\"", x=x)
}

# mach tasks:
# f549e2ba-2492-4e4d-94e4-ba1dafe12251
#  ce8e8599-aaa4-41e8-b449-49ccb81d757a
# TCGA04133201A01R156413
# UNCID2178306.bec43388f9ec403984ad6d1a0f557922.130405UNC9SN2960354AC24DCACXX1TAGCTT

# https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/ae0bbde7-6f4f-4575-b1b5-c0b4ad68ecf3/   UNCID2198736
# https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/fc0a7251-b1d6-499a-94df-fb0202b1eb80/   UNCID2200631
# first two trim galore files
# file.taskids  c("fc0a7251-b1d6-499a-94df-fb0202b1eb80","ae0bbde7-6f4f-4575-b1b5-c0b4ad68ecf3")
# file.niceish.name.tar  
# 
# inputs intarfile, grouplog, tarcsv, groupcsv, mastercsv, outputdir shou# if no temprdatadir given, doesn't save, but otherwise
#   saves files in the directory given

# pipeline for one  (intarname, intarpath, auth.token, groupname, grouplog, groupcsv, groupdir, tempdir, mastercsv, homedir, home.home, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp="JSALZMAN/machete/machete-for-work", runid.suffix="", seconds.between.checks=60, timeout.days=4, temprdatadir=NULL)

# if "run", should have input
#  vec.tarfile.ids and vec.tarfile.names both not NULL

#   tdf$typecode (1-4)
#   1 unpack, 2 trim, 3 knife, 4 machete

# give full path of file.taskids and file.niceish.name.tar
#  each one should have one line per entry
#  if it is run, should have do.run.or.resume="run"
#  
run.or.resume <- function(file.taskids, file.niceish.name.tar, auth.token, groupname, grouplog, file.current.tasks, file.completed.tasks, groupdir, tempdir, homedir, home.home, do.run.or.resume="resume", complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp="JSALZMAN/machete/machete-for-work", runid.suffix="", seconds.between.checks=60, timeout.days=2, temprdatadir=NULL, vec.tarfile.ids=NULL, vec.tarfile.names=NULL){
    # clear out completed tasks file:
    write.table("", file=file.completed.tasks, append=TRUE, sep=",", row.names=FALSE, col.names=FALSE)
    loop.wait.time <- 5
    app.short.names <- c("unpack", "trim", "knife", "machete")
    if (do.run.or.resume =="run"){
        n.tasks <- length(vec.tarfile.ids)
        stopifnot(length(vec.tarfile.ids)==length(vec.tarfile.names))
        tt.taskids <- vector("character", length=n.tasks)
        tt.taskids[] <- NA
        vec.niceish.name.tar <-  gsub(pattern="\\.tar\\.gz", replacement="", x =gsub(pattern="(_|-)", replacement="", x=gsub(pattern="_rnaseq_fastq.tar", replacement="", x=vec.tarfile.names)))
    }
    else if (do.run.or.resume =="resume") {
        tt.taskids <- read.csv(file=file.taskids, header=FALSE, sep=",", stringsAsFactors=FALSE)[,1]
        vec.niceish.name.tar <- read.csv(file=file.niceish.name.tar, header=FALSE, sep=",", stringsAsFactors=FALSE)[,1]
        n.tasks <- length(tt.taskids)
    }
    if (length(vec.niceish.name.tar)!= n.tasks){
        stop(paste("length(vec.niceish.name.tar)!= n.tasks"))
    }
    #   tdf$typecode (1-4)
    #   1 unpack, 2 trim, 3 knife, 4 machete
    tdf <- data.frame(id=tt.taskids, nicename=vec.niceish.name.tar, typecode= as.integer(rep(NA,n.tasks)), type= as.character(rep(NA,n.tasks)), status=as.character(rep(NA,n.tasks)), pipedir=as.character(rep(NA,n.tasks)), fullname= as.character(rep(NA,n.tasks)), href= as.character(rep(NA,n.tasks)), stringsAsFactors = FALSE)
    for (ii.task in c(1:n.tasks)){
        tdf$pipedir[ii.task] <- file.path(groupdir,vec.niceish.name.tar[ii.task])
        ## make pipedir if it doesn't already exist
        if (!dir.exists(tdf$pipedir[ii.task])){
            dir.create(tdf$pipedir[ii.task])
        }
    }

    aa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")
    ## mm for project, which is typically machete
    mm <- aa$project(id=paste0(pipeowner,"/",pipeproj))
    # mm <- aa$project(pipeproj)

    not.done.master.loop <- TRUE
    ## Are there already task objects that you have launched
                                        #  in this function? (for all tasks)
                                        # Before loop, answer is no
    have.all.task.objects <- FALSE
    
    start.time <- Sys.time()
    msg <- paste("Starting master loop at ", start.time, "\n", sep="")
    cat(text=msg, file = grouplog, append=FALSE)
    cat(text=msg)
    stop.day.numeric <- as.numeric(as.Date(start.time) + timeout.days)
    ii.loop <- 0
        #
    while (not.done.master.loop) {
        ii.loop <- ii.loop + 1
        # if don't have task objects, should be b/c
        #   just started the loop
        #   or perhaps if the task is still running
        #   or just completed machete tasks
        #   if not, then get details of the task, figure out the type
        #   and start the necessary tasks if not completed
        #  inefficient to check for everything if don't have
        #  one task object, but do it that way b/c
        #  probably uncommon to start resume while any task
        #  is running
        {
        if (have.all.task.objects){
            for (i.tasks in 1:n.tasks){
                thistask <- task.objects[i.task]
            }
        }
        else {
            tt.indices.to.drop <- vector("integer", length=0)
            for (i.tasks in 1:n.tasks){
                temptaskdetailsfile <- file.path(tempdir, "temptaskdetails.json")
                thistaskid <- tdf$id[i.tasks]
                system(paste0('curl -s -H "X-SBG-Auth-Token: ', auth.token, ' " -H "content-type: application/json" -X GET "https://cgc-api.sbgenomics.com/v2/tasks/', thistaskid , '" > ', temptaskdetailsfile))
                thistaskdetails <- fromJSON(temptaskdetailsfile)
                tdf$typecode[i.tasks] <- whichapp(fullappname=thistaskdetails$app, appnames.vec=c(unpackapp, trimapp, knifeapp, macheteapp))
                tdf$type[i.tasks] <- app.short.names[tdf$typecode[i.tasks]]
                tdf$status[i.tasks] <- thistaskdetails$status
                tdf$fullname[i.tasks] <- thistaskdetails$name
    # https://cgc.sbgenomics.com/u/JSALZMAN/machete/tasks/731f821a-5d33-4641-8192-1444e4cdecbc/
                tdf$href[i.tasks] <- paste0("https://cgc.sbgenomics.com/u/", pipeowner, "/", pipeproj, "/tasks/", thistaskdetails$id)
                tt.text <- paste0(tdf$fullname[i.tasks], " is ", tdf$status[i.tasks], " as of ", tolower(format(Sys.time(),"%b%d%H%M")))
                cat(tt.text, file=grouplog, sep="\n", append=TRUE)
    
                if (tdf$status[i.tasks]=="COMPLETED"){
    # make it easier to write the type code for which app
    #  it is
                    tt.code <- tdf$typecode[i.tasks]
                    {
                        if (tt.code==4){
                            tt.text <- paste0("About to download files for ", tdf$fullname[i.tasks], " with href\n", tdf$href[i.tasks] ,"\ndownloading at ", tolower(format(Sys.time(),"%b%d%H%M")))
                            cat(tt.text, file=grouplog, sep="\n", append=TRUE)
                            out.handle <- handle.complete.machete(taskid = tdf$id[i.tasks], nicename=tdf$nicename[i.tasks], auth.token=auth.token, grouplog=grouplog, tempdir = tempdir, groupdir = groupdir, proj.name=paste0(pipeowner , "/", pipeproj), href=tdf$href[i.tasks])
    # drop index, since it should have
    #  downloaded successfully
                            tt.taskids.for.writing <- read.csv(file=file.taskids, header=FALSE, sep=",", stringsAsFactors=FALSE)[,1]
                            vec.niceish.name.tar.for.writing <- read.csv(file=file.niceish.name.tar, header=FALSE, sep=",", stringsAsFactors=FALSE)[,1]
                            this.index.to.drop <- which(tt.taskids.for.writing==tdf$id[i.tasks])
                            tt.indices.to.drop <- union(tt.indices.to.drop, this.index.to.drop)
                            write.table(tdf[this.index.to.drop,], file=file.completed.tasks, append=TRUE, sep=",", row.names=FALSE, col.names=FALSE)
                        }
                        


                    } ## end if/else
                } ## end what to do if task is completed
                
            } ## end for loop
            ##
            ## Drop any indices that should have downloaded successfully
            ##  if there were any
            tt.taskids.for.writing <- read.csv(file=file.taskids, header=FALSE, sep=",", stringsAsFactors=FALSE)[,1]
            vec.niceish.name.tar.for.writing <- read.csv(file=file.niceish.name.tar, header=FALSE, sep=",", stringsAsFactors=FALSE)[,1]
            tt.taskids.for.writing <- tt.taskids.for.writing[-tt.indices.to.drop]
            vec.niceish.name.tar.for.writing <- vec.niceish.name.tar[-tt.indices.to.drop]
            cat(tt.taskids.for.writing, file=file.taskids, sep="\n")
            cat(vec.niceish.name.tar.for.writing, file=file.niceish.name.tar, sep="\n")
            tdf <- tdf[-tt.indices.to.drop,]
                                        # write file of current tasks for inspection while
                                        # program is going
            write.table(tdf, file=file.current.tasks, append=FALSE, sep=",", row.names=FALSE, col.names=TRUE)
        } # end else
    } # end if/else
        msg <- paste0("Number of tasks is now ", dim(tdf)[1], "\n")
        cat(msg, file=grouplog, append=TRUE)
        cat(msg)
        # if no more tasks, stop loop
        if (dim(tdf)[1]==0){
            not.done.master.loop <- FALSE
        }
        # if timeout, stop loop
        if (as.numeric(Sys.Date())>= stop.day.numeric){
            not.done.master.loop <- FALSE
        }
        # read these in, in case you remove or change/draft anything
        #  put in col.names to prevent getting an error if it's blank
        tt.taskids <- read.csv(file=file.taskids, header=FALSE, sep=",", stringsAsFactors=FALSE, col.names="id")[,1]
        vec.niceish.name.tar <- read.csv(file=file.niceish.name.tar, header=FALSE, sep=",", stringsAsFactors=FALSE, col.names="niceish.name.tar")[,1]
        #
        #
        msg <- paste0("Pausing at end of loop number ", ii.loop,  "\n")
        cat(msg, file=grouplog, append=TRUE)
        cat(msg)
        Sys.sleep(loop.wait.time)
    } # end while

    # now go into loop, wait 5 seconds each time
    # loop.wait.time  5
    # inside loop for one file/task, figure out what stage it's at
    #  if tarfile, unpack, trim, knife, machete
    #  if tarfile, start unpack task
    #  if one of first three tools, then check if completed;
    #   if aborted 1 time, rereun  
    #   if complete, run next ask
    #   

    # things to update when removing things from list of tasks:
    # tt.taskids, vec.niceish.name.tar, vec.pipedir, tasks.type
    #   tasks.status
    # and the respective files for task ids and nice names




    # 

} # end run.or.resume

# whichapp(fullappname="JSALZMAN/machete/machete-for-work/9", appnames.vec=c(unpackapp, trimapp, knifeapp, macheteapp))
# appnames.vec =c(unpackapp, trimapp, knifeapp, macheteapp); fullappname="JSALZMAN/machete/machete-for-work/9"
whichapp <- function(fullappname, appnames.vec){
    # stopifnot(length(app.short.names)==length(appnames.vec))
    vec.grep <- vector("integer", length = length(appnames.vec))
    for (i.app in 1:(length(appnames.vec))){
        vec.grep[i.app] <- length(grep(pattern=appnames.vec[i.app], x=fullappname))
    }
    stopifnot(sum(vec.grep)==1)
    which(vec.grep==1)
}

# what to do if complete
# 
handle.complete.machete <- function(taskid, nicename, auth.token, grouplog, tempdir, groupdir, proj.name, href){
    sink(file=grouplog, split=TRUE, append=TRUE)
    download.reports.and.fasta.and.outputfjfiles.one.task(task.id=taskid, task.short.name=nicename, ttwdir=groupdir, ttauth=auth.token, ttproj=proj.name, tempdir=tempdir, datadir=groupdir)
    ## download.onlyreports.one.task(task.id=taskid, task.short.name=nicename, ttwdir=groupdir, ttauth=auth.token, ttproj=proj.name, tempdir=tempdir, datadir=groupdir)
    sink()
}

# for printing out vectors of file ids in form c("","") for easy
#  copying and pasting to use them later or in other files, e.g.
#  to transfer from datasetapi.R to runapi.R
print.nice.ids.vector <- function(ttvec){
    noquote(paste0("c(\"", paste(ttvec, collapse = "\", \""), "\")"))
}



# use this for help when knife tasks stop
#  you need the niceish.name.tar for downloading machete results later
#  taskid can be full http
get.niceish.name.tar.from.knife.task <- function(taskid, auth.token=auth.token, tempdir=tempdir){
    ttaa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")
    # mm for project, which is typically machete
    ttmm <- ttaa$project(id="JSALZMAN/machete")
    # Remove all but last part if pasting in web address of task:
    if (length(grep(pattern="*http.*", x=taskid))> 0){
        taskid <- basename(taskid)
    }
    details.knife.task <- get.details.of.a.task.from.id(taskid = taskid, auth.token=auth.token, ttwdir=tempdir)
    intermediate <- gsub(pattern="ATTEMPT 2: original is Knife for .*from tar file", replacement = "", x=details.knife.task$name)
    gsub(pattern=" from group .*", replacement="", x=gsub("Knife for .*from tar file", replacement = "", x=intermediate))
}


## make niceish names:
clean.names <- function(tt.name){
    gsub(pattern="\\.tar\\.gz", replacement="", x =gsub(pattern="(_|-)", replacement="", x=gsub(pattern="_rnaseq_fastq.tar", replacement="", x=tt.name)))
}

## unordered.names.unpacked.files = c("700D6AAXX_1_1.fastq","700D6AAXX_1_2.fastq")
## this one happens after unpacking but before the trim task
make.nice.names.of.fastq.files <- function(unordered.names.unpacked.files, unordered.paths.unpacked.files, pipeowner, pipeproj, auth.token, tempdir, logs.to.write){
    error.in.fastq.file.names <- FALSE
    files.renamed <- NA
    ordered.names.unpacked.files.original <- NA
    ordered.names.unpacked.files.new.if.changed <- NA
    ordered.paths.unpacked.files.original <- NA
    ordered.paths.unpacked.files.new.if.changed <- NA

    ## initialize these, as with some of the others, so 
    ## that it can be given as output eve n if irrelevant
    ordered.names.unpacked.files.raw <-NA
    ordered.names.unpacked.files <-NA
    ordered.paths.unpacked.files <-NA
    ordered.paths.unpacked.files.raw <- NA
    ##
    ## determine which is forward, which is reverse, from name
    ##  although it's probably already in the right order
    determined.files.output <- determine.reverse.and.forward.fastq.files.with.error.warning(filenames=unordered.names.unpacked.files)
    {
        if (determined.files.output$error.in.fastq.file.names == TRUE){
            error.in.fastq.file.names <- TRUE
        }
        else {
            ## these are the original names, but in the correct order
            ##   maybe they were in the right order anyway before, but
            ##   this should make them be
            ordered.names.unpacked.files.raw <- as.character(c(determined.files.output$forward.file, determined.files.output$reverse.file))
            index.of.forward.within.unorder.unpacked.files <- which(ordered.names.unpacked.files.raw==unordered.names.unpacked.files[1])
            ##
            ## Now rename in case the file names have _1 or _2 or _R1 or _R2
            ##   in the middle of the name
            ordered.names.unpacked.files <- vector("character", length =2)
            for (tti in 1:2){
                ordered.names.unpacked.files[tti] <- make.new.file.names.so.nice.for.knife(filename= ordered.names.unpacked.files.raw[tti])
    }
            ## do something if doesn't exist or is >=3 or <=0 TODO
            ##
            ## rearrange paths if unordered files in wrong order
            {
                if (index.of.forward.within.unorder.unpacked.files ==1){
                    new.indices <- c(1,2)
                }
                else {
                    new.indices <- c(2,1)
                }
            }
            ## 
            ordered.paths.unpacked.files.raw <- unordered.paths.unpacked.files[new.indices]
            ##
            ## old names: ordered.names.unpacked.files.raw
            ## new names: ordered.names.unpacked.files
            ##
            ## Now call copy.and.rename to actually create new files with
            ##   these names, if they are actually changed
            ##
            files.renamed <- FALSE
            {
                if (!identical(ordered.names.unpacked.files, ordered.names.unpacked.files.raw)){
                    jsonoutunpacked.from.renaming <- vector("list", length =2)
                    for (tti in 1:2){
                        jsonoutunpacked.from.renaming[[tti]] <- copy.and.rename.file.on.sb(file.id=ordered.paths.unpacked.files.raw[tti], new.name= ordered.names.unpacked.files[tti], proj.name=paste0(pipeowner,"/",pipeproj), auth.token=auth.token, tempdir=tempdir)
                        files.renamed <- TRUE
                    }
                    ## Get id's of the new files
                    ##   make sure that this is the id of the new file and not
                    ##   the id of the old file
                    ordered.paths.unpacked.files <- as.character(sapply(jsonoutunpacked.from.renaming, "[", 2))
                }
                else {
                    ordered.paths.unpacked.files <- ordered.paths.unpacked.files.raw
                }
            } ## end if/else
            ## 
            wlog <- function(...){ write.logs(text=paste0(...,"\n"), logfilenames = logs.to.write, ttappend = TRUE, screen = TRUE) }
            wlog("Original ordered names of unpacked files, forward, then reverse, are:\n", paste(ordered.names.unpacked.files.raw, collapse="\n"))
            wlog("Original ordered paths of unpacked files, forward, then reverse, are:\n", paste(ordered.paths.unpacked.files.raw, collapse="\n"))
            wlog("New ordered names of unpacked files, forward, then reverse, are:\n", paste(ordered.names.unpacked.files, collapse="\n"))
            wlog("New ordered paths of unpacked files, forward, then reverse, are:\n", paste(ordered.paths.unpacked.files, collapse="\n"))
        } ## end else
    } ## end if/else
    ## files.renamed is TRUE or FALSE
    list(error.in.fastq.file.names= error.in.fastq.file.names, files.renamed=files.renamed, ordered.names.unpacked.files.original= ordered.names.unpacked.files.raw, ordered.names.unpacked.files.new.if.changed= ordered.names.unpacked.files, ordered.paths.unpacked.files.original=ordered.paths.unpacked.files.raw, ordered.paths.unpacked.files.new.if.changed=ordered.paths.unpacked.files)
}

##  Rename val files, because of e.g. _1_val before _1.fq.gz
##    or _R1_val before _R1.fq.gz
##  This takes place after trim task
make.nice.names.of.validated.fastq.files <- function(trimmed.files.info.raw, pipeowner, pipeproj, auth.token, tempdir, logs.to.write){
    error.in.fastq.file.names <- FALSE
    trimmed.paths.new <- c(NA,NA)
    # NOTE THAT these are ordered, 1 is forward, 2 reverse:
    trimmed.filenames.raw <- as.character(sapply(trimmed.files.info.raw, "[", 2) )
    trimmed.paths <- as.character(sapply(trimmed.files.info.raw, "[", 1))
    #
    # Rename val files, because of e.g. _1_val before _1.fq.gz
    #    or _R1_val before _R1.fq.gz
    trimmed.filenames.new <- vector("character", length=2) 
    trimmed.filenames.new[1] <- gsub(pattern="(_1_val|_R1_val)", replacement="val", x=trimmed.filenames.raw[1])
    trimmed.filenames.new[2] <- gsub(pattern="(_2_val|_R2_val)", replacement="val", x=trimmed.filenames.raw[2])
    wlog <- function(...){ write.logs(text=paste0(...,"\n"), logfilenames = logs.to.write, ttappend = TRUE, screen = TRUE) }
    wlog("Checking new names of validated files that will be assigned do indeed match.\n")
    # Check that these new file names match
    # This fails if they do not match; actually does more, but that is ok
    #  We do not care about the output. We just want
    #   to know if there is a problem.
    out.determine <- determine.reverse.and.forward.fastq.files.with.error.warning(filenames = trimmed.filenames.new)
    {
        if (out.determine$error.in.fastq.file.names == TRUE) {
            error.in.fastq.file.names <- TRUE
        }
        else {
            ## Now use api to rename the files
            ## use copy call
            ## Now call copy.and.rename to actually create new files with
            ##   these names, if they are actually changed 
            ##
            {
                if (!identical(trimmed.filenames.new, trimmed.filenames.raw)){
                    wlog("Renaming files, specifically to get rid of strings like\n_1_val or _R1_val inserted into the file name by trim galore:\n Original names are:\n", paste(trimmed.filenames.raw, collapse="\n"), "\nNew names are:\n", paste(trimmed.filenames.new, collapse="\n"))
                    jsonout.from.renaming <- vector("list", length =2)
                    for (tti in 1:2){
                        jsonout.from.renaming[[tti]] <- copy.and.rename.file.on.sb(file.id=trimmed.paths[tti], new.name= trimmed.filenames.new[tti], proj.name=paste0(pipeowner,"/",pipeproj), auth.token=auth.token, tempdir=tempdir)
                    }
                    ## Get id's of the new files 
                    ##   make sure that this is the id of the new file and not
                    ##   the id of the old file
                    ## 
                    trimmed.paths.new <- as.character(sapply(jsonout.from.renaming, "[", 2))
                    ## just in case it throws an _1_ in front, or
                    ## something like that
                    trimmed.filenames.new <- as.character(sapply(jsonout.from.renaming, "[", 3))
                } ## end if
                else {
                    trimmed.paths.new <- trimmed.paths
                }
            }
        } ## end else
    } ## end if/else
    list(error.in.fastq.file.names=error.in.fastq.file.names, trimmed.paths.new=trimmed.paths.new, trimmed.filenames.new=trimmed.filenames.new)
}

## get.inputs.machete.from.knife.details(details.knife.task = thistask.details, infile.etc.info.file = file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata"), logs.to.write=logs.to.write)


## details.knife.task = thistask.details
get.inputs.machete.from.knife.details <- function(details.knife.task, infile.etc.info.file, logs.to.write){
    error.in.getting.machete.inputs <- FALSE
    datasetname <- details.knife.task$inputs$datasetname
    runid <- details.knife.task$inputs$runid

    knifeoutputtarballs <- details.knife.task$outputs$outputtarballs
    knifeoutputtarballnames <- sapply(knifeoutputtarballs, FUN=function(x){ x[2]})
    index.knifeoutput.within.tarballs <- grep(pattern="*outputdir", knifeoutputtarballnames)
    ## Check that the index has length 1
    if (length(index.knifeoutput.within.tarballs)!=1){
        errtext <- paste0("ERROR ERROR in get.inputs.machete.from.knife.details: length(index.knifeoutput.within.tarballs)!=1, but it should be 1.\n knifeoutputtarballs look like\n", paste(knifeoutputtarballs, collapse="\n"), "\nIndex is\n", paste(index.knifeoutput.within.tarballs, collapse = "\n"))
        if (!is.null(logs.to.write)){
            write.logs(text=errtext, logfilenames = logs.to.write, ttappend = TRUE)
        }
        error.in.getting.machete.inputs <- TRUE
    }

    knifeoutputdetails <- details.knife.task$outputs$outputtarballs[[index.knifeoutput.within.tarballs]]
    names(knifeoutputdetails) <- NULL
    knifeoutputtarname <- knifeoutputdetails[2]
    knifeoutputtarpath <- knifeoutputdetails[1]

    load(infile.etc.info.file)

    inputs.machete <- list(inputarray=infile.array, knifeoutputtarball = Files(id= knifeoutputtarpath, name=knifeoutputtarname), exons= exons.Files.object, indel_indices=indelindices.Files.object, datasetname=datasetname, runid=runid)

    list(error.in.getting.machete.inputs=error.in.getting.machete.inputs, inputs.machete=inputs.machete)
}

    









##  

## type.latest.task is one of 0,1,2,3,4
## first csv
## id.file, filename, nicefname, type.latest.task, id.latest.task, status.latest.task, alldone,
##    id.unpack, id.trim, id.knife, id.machete, download.attempted,
##    


## second csv
##    fails.task.1, fails.task.2, fails.task.3, fails.task.4
##    stored as a matrix
## 

## linenumber is line of file to start working on

## with csv files as inputs, do one step, i.e. process one file
##  e.g. check the status of a task, and if complete, launch the
##  next task
## each time you call this, you should check to see if everything
##  is done BEFORE calling it
do.one.step <- function(line.to.work.on, infofile, failfile, tarfilenames, tarfileids, auth.token, groupname, grouplog, groupdir, tempdir, homedir, temprdatadir, complete.or.appended, pipeowner, pipeproj, unpackapp, trimapp, knifeapp, macheteapp, runid.suffix, timeout.days, seconds.of.wait.time.between.runs, allowed.fails, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")){
    ## Read the csv files in:
    infodf <- read.table(file = infofile, header = TRUE, sep = ",", stringsAsFactors = FALSE)
    failmatrix <- as.matrix(read.table(file = failfile, header = FALSE, sep = ",", stringsAsFactors = FALSE))
    colnames(failmatrix) <- NULL

    thisnicefname <- infodf$nicefname[line.to.work.on]
    thisinfo <- infodf[line.to.work.on,]
    
    thisfiledir <- file.path(groupdir, thisnicefname)
    
    ## make a nice filename for log for this tarfile, call it thisfilelog
    thisfilelog <- file.path(thisfiledir, paste0("log",thisnicefname,".txt"))

    logs.to.write <- c(grouplog, thisfilelog)
    ## 
    ## Make shorthand so easier to type command to write to logs
    wlog <- function(...){ write.logs(text=paste0(...,"\n"), logfilenames = logs.to.write, ttappend = TRUE, screen = TRUE) }
    ## 
    print(paste0("Working on line ", line.to.work.on))
    ## print(line.to.work.on)
    ## print(paste0("Working on line ", line.to.work.on, " of file ", infofile, ", i.e. file ", thisnicefname))

    ## Only do anything if not all done.
    ## However, should have already checked this at
    ## the level of the function calling this one.
    if (thisinfo$alldone == FALSE){
        nicetime <- format(Sys.time(),"%b%d%H%M")
        nicedate<- tolower(format(Sys.time(),"%b%d"))

        aa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")
        ## mm for project, which is typically machete
        mm <- aa$project(id=paste0(pipeowner,"/",pipeproj))
        ## Now see what is the type for the latest task:
        {
        ## ####################################################    
        ## ####################################################    
        ## first case: haven't even started the unpacking task
        ## ####################################################    
        ## ####################################################    
        if (thisinfo$type.latest.task == 0){
            name.unpacking.task <- paste("Unpacking of ", thisinfo$nicefname, " from group ", groupname, "; drafted at ", nicetime, sep="")
            wlog("About to draft and then run ", name.unpacking.task)
            pipe.unpack.task <- mm$task_add(name = name.unpacking.task, description = name.unpacking.task,  app = unpackapp, inputs = list(input_archive_file=Files(id=thisinfo$id.file, name=thisinfo$filename)))
            wlog("Just drafted ", name.unpacking.task, "; task id is ", pipe.unpack.task$id)
            infodf$type.latest.task[line.to.work.on] <- 1
            infodf$id.latest.task[line.to.work.on] <- pipe.unpack.task$id
            infodf$status.latest.task[line.to.work.on] <- pipe.unpack.task$status
            infodf$id.unpack[line.to.work.on] <- pipe.unpack.task$id
            infodf$name.unpack[line.to.work.on] <- name.unpacking.task

            ## ######################################################
            ## Now run the unpacking task
            ## ######################################################
            pipe.unpack.task$run()
            ##
            wlog("\ntaskinfo,unpack,running,", pipe.unpack.task$id, ",", thisnicefname, "\n")
        }
        ## ####################################################    
        ## ####################################################    
        ## Now deal with the case of latest task being unpacking:
        ##   i.e. type 1
        ## ####################################################    
        ## ####################################################    
        else if (thisinfo$type.latest.task == 1){
            ## check the status of the task
            ## "QUEUED", "DRAFT", "RUNNING",
            ##  "COMPLETED", "ABORTED", "FAILED"
            thistask.details <- get.details.of.a.task.from.id(taskid = thisinfo$id.latest.task, auth.token=auth.token, ttwdir=tempdir)
            this.status <- thistask.details$status
            {
            ## if aborted or failed, then rerun if fails <= allowed.fails
            if (this.status %in% c("ABORTED", "FAILED")){
                if (failmatrix[line.to.work.on,1] < allowed.fails){
                    failmatrix[line.to.work.on,1] <- failmatrix[line.to.work.on,1] + 1
                    name.unpacking.task <- paste0("Rerunning at ", nicetime, " for failed task ", thisinfo$name.unpack)
                    wlog("About to draft and then run ", name.unpacking.task)
                    pipe.unpack.task <- mm$task_add(name = name.unpacking.task, description = name.unpacking.task,  app = unpackapp, inputs = list(input_archive_file=Files(id=thisinfo$id.file, name=thisinfo$filename)))
                    wlog("Just drafted ", name.unpacking.task, "; task id is ", pipe.unpack.task$id)
                    infodf$type.latest.task[line.to.work.on] <- 1
                    infodf$id.latest.task[line.to.work.on] <- pipe.unpack.task$id
                    infodf$status.latest.task[line.to.work.on] <- pipe.unpack.task$status
                    infodf$id.unpack[line.to.work.on] <- pipe.unpack.task$id
                    infodf$name.unpack[line.to.work.on] <- name.unpacking.task
                    ## Now run the unpacking task
                    pipe.unpack.task$run()
                    ##
                    wlog("\ntaskinfo,unpack,rerunning,", pipe.unpack.task$id, ",", thisnicefname, "\n")
                }
                else {
                    wlog("ERROR ERROR. Too many (", allowed.fails, ") fails for unpacking task. Killing the pipeline for this file, namely file ", thisnicefname, " with file id ", thisinfo$id.file, "\n Task id:\n", thisinfo$id.latest.task, " . Line number of file: ", line.to.work.on)
                infodf$alldone[line.to.work.on] <- TRUE
                }
            }
            ## if completed, run trim galore
            else if (this.status == "COMPLETED"){
                wlog("Task ", thisinfo$name.unpack, " finished.")
                wlog("\ntaskinfo,unpack,finished,", thisinfo$id.latest.task, ",", thisnicefname, "\n")
                ## figure out order of fastq names and clean up the
                ##  names
                unordered.names.unpacked.files <- c(thistask.details$outputs$output_fastq_files[[1]]["name"], thistask.details$outputs$output_fastq_files[[2]]["name"])
                wlog("Fastq files for ", thisnicefname, " are:\n", paste(unordered.names.unpacked.files, collapse=","))
                if (length(unordered.names.unpacked.files)==0){
                    try(wlog("Empty value of unordered.names.unpacked.files. line number ", line.to.work.on, ". thistask.details :", thistask.details$outputs))
                }
                unordered.paths.unpacked.files <- c(thistask.details$outputs$output_fastq_files[[1]]["path"], thistask.details$outputs$output_fastq_files[[2]]["path"])

                nicefastqnames.out <- make.nice.names.of.fastq.files(unordered.names.unpacked.files, unordered.paths.unpacked.files, pipeowner, pipeproj, auth.token, tempdir, logs.to.write)
                ## if get error when making names, should set alldone to
                ## TRUE and stop here
                {
                    if (nicefastqnames.out$error.in.fastq.file.names) {
                        infodf$alldone[line.to.work.on] <- TRUE
                    }
                    else {
                        ## add names and whether changed to infodf
                        ##  run trim galore here after dealing
                        ##  with file names
                        name.trim.task <- paste("Trim galore for tar file ", thisnicefname, " from group ", groupname, "; first fastq file is ", nicefastqnames.out$ordered.names.unpacked.files.new.if.changed[1], "; drafted at ", nicetime, sep="")
                        inputs.trim.task <- list(error_rate=0.1,  min_read_length=20, stringency=1, quality=20, read1= Files(id=nicefastqnames.out$ordered.paths.unpacked.files.new.if.changed[1], name=nicefastqnames.out$ordered.names.unpacked.files.new.if.changed[1]), read2= Files(id=nicefastqnames.out$ordered.paths.unpacked.files.new.if.changed[2], name=nicefastqnames.out$ordered.names.unpacked.files.new.if.changed[2]))
                                        
                        wlog("About to draft and then run ", name.trim.task)
                
                        trim.task <- mm$task_add(name = name.trim.task, description = name.trim.task, app = trimapp, inputs = inputs.trim.task)
                        ## Now run the task
                        trim.task$run()
                        taskidforinfo = trim.task$id
                        wlog("\ntaskinfo,trim,running,", taskidforinfo, ",", thisnicefname, "\n")
                        infodf$type.latest.task[line.to.work.on] <- 2
                        infodf$id.latest.task[line.to.work.on] <- trim.task$id
                        infodf$status.latest.task[line.to.work.on] <- trim.task$status
                        infodf$id.trim[line.to.work.on] <- trim.task$id
                        infodf$name.trim[line.to.work.on] <- name.trim.task
                        infodf$fastq.files.renamed[line.to.work.on] <- nicefastqnames.out$files.renamed
                        infodf$fastq1.original[line.to.work.on] <- nicefastqnames.out$ordered.names.unpacked.files.original[1]
                        infodf$fastq2.original[line.to.work.on] <-  nicefastqnames.out$ordered.names.unpacked.files.original[2]
                        infodf$fastq1.new[line.to.work.on] <- nicefastqnames.out$ordered.names.unpacked.files.new.if.changed[1]
                        infodf$fastq2.new[line.to.work.on] <- nicefastqnames.out$ordered.names.unpacked.files.new.if.changed[2]
                        infodf$fastq.files.renamed[line.to.work.on] <- nicefastqnames.out$files.renamed
                    } ## end else
                } ## end if/else
            }
            else if (this.status %in% c("QUEUED","RUNNING")){
                ## don't do anything
                Sys.sleep(1)
            }
            else {
                wlog("ERROR ERROR. Task ", thisinfo$name.unpack, " is either in draft status or something else and this is weird. Killing the pipeline for this file, namely file ", thisnicefname, " with file id ", thisinfo$id.file, " . Line number of file: ", line.to.work.on)
                infodf$alldone[line.to.work.on] <- TRUE
            }
        } 
        } ## end else if (thisinfo$type.latest.task == 1)
        ## ####################################################    
        ## ####################################################    
        ## Now deal with the case of latest task being trim:
        ##  task.type is 2
        ## ####################################################    
        ## ####################################################    
        else if (thisinfo$type.latest.task == 2){
            task.type <- 2
            ## check the status of the task
            ## "QUEUED", "DRAFT", "RUNNING",
            ##  "COMPLETED", "ABORTED", "FAILED"
            thistask.details <- get.details.of.a.task.from.id(taskid = thisinfo$id.latest.task, auth.token=auth.token, ttwdir=tempdir)
            this.status <- thistask.details$status
            {
            ## if aborted or failed, then rerun if fails <= allowed.fails
            if (this.status %in% c("ABORTED", "FAILED")){
                if (failmatrix[line.to.work.on,task.type] < allowed.fails){
                    failmatrix[line.to.work.on,task.type] <- failmatrix[line.to.work.on,task.type] + 1
                    name.trim.task <- paste0("Rerunning at ", nicetime, " for failed task ", thisinfo$name.trim)
                    ## get info on read1 and read2 from thistask.details
                    ## changing next thing on nov 1 2016 
                    ## I don't know why, but it seems that sometimes 
                    ## thistask.details$inputs$read1 works for the
                    ## api and other times it decides that
                    ## thistask.details$inputs is character class
                    ## and has no names, not sure why. File info
                    ## is inconsistent for whatever reason, I guess??
                    ## e.g.:
                    ## Error in thistask.details$inputs$read1$path :
                    ## $ operator is invalid for atomic vectors
                    out.try.read.name.1 <- try(read.name.1 <- thistask.details$inputs$read1$name)
                    if (class(out.try.read.name.1)=="try-error"){
                        read.name.1 <- as.character(thistask.details$inputs$read1['name'])
                    }
                    out.try.read.name.2 <- try(read.name.2 <- thistask.details$inputs$read2$name)
                    if (class(out.try.read.name.2)=="try-error"){
                        read.name.2 <- as.character(thistask.details$inputs$read2['name'])
                    }
                    out.try.read.1.id <- try(read.1.id <- thistask.details$inputs$read1$path)
                    if (class(out.try.read.1.id)=="try-error"){
                        read.1.id <- as.character(thistask.details$inputs$read1['path'])
                    }
                    out.try.read.2.id <- try(read.2.id <- thistask.details$inputs$read2$path)
                    if (class(out.try.read.2.id)=="try-error"){
                        read.2.id <- as.character(thistask.details$inputs$read2['path'])
                    }
                    inputs.trim.task <- list(error_rate=0.1,  min_read_length=20, stringency=1, quality=20, read1= Files(id=read.1.id, name=read.name.1), read2= Files(id=read.2.id, name=read.name.2))
                    wlog("About to draft and then run ", name.trim.task)

                    trim.task <- mm$task_add(name = name.trim.task, description = name.trim.task, app = trimapp, inputs = inputs.trim.task)
                    ## Now run the task
                    trim.task$run()
                    taskidforinfo = trim.task$id
                    wlog("\ntaskinfo,trim,rerunning,", taskidforinfo, ",", thisnicefname, "\n")
                    infodf$type.latest.task[line.to.work.on] <- 2
                    infodf$id.latest.task[line.to.work.on] <- trim.task$id
                    infodf$status.latest.task[line.to.work.on] <- trim.task$status
                    infodf$id.trim[line.to.work.on] <- trim.task$id
                    infodf$name.trim[line.to.work.on] <- name.trim.task
                }
                else {
                    wlog("ERROR ERROR. Too many (", allowed.fails, ") fails for trim task. Killing the pipeline for this file, namely file ", thisnicefname, " with file id ", thisinfo$id.file, "\n Task id:\n", thisinfo$id.latest.task, " . Line number of file: ", line.to.work.on)
                    infodf$alldone[line.to.work.on] <- TRUE
                }
            }
            ## if completed, run knife
            else if (this.status == "COMPLETED"){
                wlog("Task ", thisinfo$name.unpack, " finished.")
                wlog("\ntaskinfo,unpack,finished,", thisinfo$id.latest.task, ",", thisnicefname, "\n")

                ## first rename outputs from trim
                ##  Rename val files, because of e.g. _1_val
                ##    before _1.fq.gz
                ##    or _R1_val before _R1.fq.gz
                thistask.details <- get.details.of.a.task.from.id(taskid = thisinfo$id.latest.task, auth.token=auth.token, ttwdir=tempdir)
                trimmed.files.info.raw <- list(thistask.details$outputs$trim_read1, thistask.details$outputs$trim_read2)
                
                out.nice.names.validated <- make.nice.names.of.validated.fastq.files(trimmed.files.info.raw, pipeowner, pipeproj, auth.token, tempdir, logs.to.write)       
                ## if get error when making names, should set alldone to
                ## TRUE and stop here
                {
                    if (out.nice.names.validated$error.in.fastq.file.names) {
                        infodf$alldone[line.to.work.on] <- TRUE
                        infodf$error.in.fastq.file.names[line.to.work.on] <- TRUE
                        wlog("ERROR ERROR: problem with names after trim galore for file ", thisnicefname, "; line number is of file is: ", line.to.work.on)
                    }
                    else {
                        ##      now run knife task
                        ##
                        ##  first write the new filenames and ids
                        ##   to the df so that we can use
                        ##   the knife task drafting stuff below
                        ##   again when doing the code for rerunning
                        ##   a failed knife task
                        infodf$trimmed.filename1.new[line.to.work.on] <- out.nice.names.validated$trimmed.filenames.new[1]
                        infodf$trimmed.filename2.new[line.to.work.on] <- out.nice.names.validated$trimmed.filenames.new[2]
                        infodf$id.new.trimmed.file1[line.to.work.on] <- out.nice.names.validated$trimmed.paths.new[1]
                        infodf$id.new.trimmed.file2[line.to.work.on] <- out.nice.names.validated$trimmed.paths.new[2]

                        ## then do inputs.knife
                        ## We assign thisinfo here again
                        ## so that we can use the same code
                        ## below for rerunning knife
                        thisinfo <- infodf[line.to.work.on,]
                        ## Next data set includes list of
                        ##  all the "infiles",
                        ##  i.e. the 43 auxiliary input files
                        ## this data file contains object infile.array
                        load(infile.etc.info.file)
                        ## Now set up the draft knife task
                        runid = paste0(nicedate,runid.suffix)
                        name.knife.task <- paste("Knife for ", thisnicefname, ", from tar file ", thisnicefname," from group ", groupname, "; first fastq file is ", thisinfo$fastq1.new, "; ", complete.or.appended, ", drafted at ", nicetime, sep="")
                        
                        inputs.knife <- list(inputarray=infile.array,  fastqfiles=list(Files(id=thisinfo$id.new.trimmed.file1, name=thisinfo$trimmed.filename1.new), Files(id=thisinfo$id.new.trimmed.file2, name=thisinfo$trimmed.filename2.new)),  datasetname=thisnicefname,  readidstyle=complete.or.appended,  runid=runid)
                        ##
                        wlog("About to draft and then run ", name.knife.task)
                        knife.task <- mm$task_add(name = name.knife.task, description = name.knife.task,  app = knifeapp, inputs = inputs.knife)
                        ## Now run the knife task
                        knife.task$run()
                        taskidforinfo = knife.task$id
                        wlog("\ntaskinfo,knife,running,", taskidforinfo, ",", thisnicefname, "\n")

                        infodf$type.latest.task[line.to.work.on] <- 3
                        infodf$id.latest.task[line.to.work.on] <- knife.task$id
                        infodf$status.latest.task[line.to.work.on] <- knife.task$status
                        infodf$id.knife[line.to.work.on] <- knife.task$id
                        infodf$name.knife[line.to.work.on] <- name.knife.task
                        
                    } ## end else
                } ## end if/else

            }
            else if (this.status %in% c("QUEUED","RUNNING")){
                ## don't do anything
                Sys.sleep(1)
            }
            else {
                wlog("ERROR ERROR. Task ", thisinfo$name.trim, " is either in draft status or something else and this is weird. Killing the pipeline for this file, namely file ", thisnicefname, " with file id ", thisinfo$id.file, " . Line number of file: ", line.to.work.on)
                infodf$alldone[line.to.work.on] <- TRUE
            }
        } 
        } ## end else if (thisinfo$type.latest.task == 2)


        ## ####################################################    
        ## ####################################################    
        ## Now deal with the case of latest task being knife:
        ##  task.type is 3
        ## ####################################################    
        ## ####################################################    
        else if (thisinfo$type.latest.task == 3){
            task.type <- 3
            ## check the status of the task
            ## "QUEUED", "DRAFT", "RUNNING",
            ##  "COMPLETED", "ABORTED", "FAILED"
            thistask.details <- get.details.of.a.task.from.id(taskid = thisinfo$id.latest.task, auth.token=auth.token, ttwdir=tempdir)
            this.status <- thistask.details$status
            {
                ## ########################
                ## if aborted or failed, then rerun if
                ##  fails <= allowed.fails
                if (this.status %in% c("ABORTED", "FAILED")){
                    if (failmatrix[line.to.work.on,task.type] < allowed.fails){
                        failmatrix[line.to.work.on,task.type] <- failmatrix[line.to.work.on,task.type] + 1
                        name.knife.task <- paste0("Rerunning knife at ", nicetime, " for failed task ", thisinfo$name.knife)
                        ## Now set up the draft knife task
                        load(infile.etc.info.file)
                        runid = paste0(nicedate,runid.suffix)
                        inputs.knife <- list(inputarray=infile.array,  fastqfiles=list(Files(id=thisinfo$id.new.trimmed.file1, name=thisinfo$trimmed.filename1.new), Files(id=thisinfo$id.new.trimmed.file2, name=thisinfo$trimmed.filename2.new)),  datasetname=thisnicefname,  readidstyle=complete.or.appended,  runid=runid)
                        ##
                        wlog("About to draft and then run ", name.knife.task)
                        knife.task <- mm$task_add(name = name.knife.task, description = name.knife.task,  app = knifeapp, inputs = inputs.knife)
                        ## Now run the knife task
                        knife.task$run()
                        taskidforinfo = knife.task$id
                        wlog("\ntaskinfo,knife,rerunning,", taskidforinfo, ",", thisnicefname, "\n")
                        infodf$type.latest.task[line.to.work.on] <- 3
                        infodf$id.latest.task[line.to.work.on] <- knife.task$id
                        infodf$status.latest.task[line.to.work.on] <- knife.task$status
                        infodf$id.knife[line.to.work.on] <- knife.task$id
                        infodf$name.knife[line.to.work.on] <- name.knife.task
                    } ## end if (failmatrix[line.to.work.on,task.type]
                    ## < allowed.fails)
                    else {
                        wlog("ERROR ERROR. Too many (", allowed.fails, ") fails for knife task. Killing the pipeline for this file, namely file ", thisnicefname, " with file id ", thisinfo$id.file, "\n Task id:\n", thisinfo$id.latest.task, " . Line number of file: ", line.to.work.on)
                        infodf$alldone[line.to.work.on] <- TRUE
                    }
                } ## end if (this.status %in% c("ABORTED", "FAILED"))
                ##########################
                ## if completed, download knife tar and then run machete
                else if (this.status == "COMPLETED"){
                    wlog("Task ", thisinfo$name.knife, " finished.")
                    wlog("\ntaskinfo,knife,finished,", thisinfo$id.latest.task, ",", thisnicefname, "\n")
                    ##########################
                    ## download knife tar
                    ## do a try, just to be cautious
                    out.try.download.knife <- try(download.knife.text.reports(task.id = thisinfo$id.knife, task.short.name=thisnicefname, ttwdir=groupdir, ttauth=auth.token, ttproj=paste0(pipeowner,"/", pipeproj), tempdir=tempdir, datadir=groupdir))
                    {
                        if (class(out.try.download.knife)=="try-error"){
                            wlog("Failed when downloading files for knife for task ", thisinfo$id.knife, " for line ", line.to.work.on)
                        }
                        else {
                            wlog("Successfully downloaded files for knife for task ", thisinfo$id.knife, " for line ", line.to.work.on)
                        }
                    }
                    out.inputs.machete <- get.inputs.machete.from.knife.details(details.knife.task = thistask.details, infile.etc.info.file = infile.etc.info.file, logs.to.write=logs.to.write)
                    {
                        if (out.inputs.machete$error.in.getting.machete.inputs == TRUE){
                            ## if there was a problem getting inputs,
                            ## then alldone <- TRUE
                            wlog("ERROR ERROR. Problem getting inputs forthe machete task following the task ", thisinfo$name.knife, ". Killing the pipeline for this file, namely file ", thisnicefname, " with file id ", thisinfo$id.file, " . Line number of file: ", line.to.work.on)
                            infodf$alldone[line.to.work.on] <- TRUE
                            infodf$error.in.getting.machete.inputs[line.to.work.on] <- TRUE
                        }
                        else {
                            inputs.machete <- out.inputs.machete$inputs.machete
                            name.machete.task <- paste("Machete for ", thisnicefname, ", from group ", groupname, "; first fastq file is ", thisinfo$fastq1.new, "; ", complete.or.appended, ", drafted at ", nicetime, sep="")

                            machete.task <- mm$task_add(name = name.machete.task, description = name.machete.task,  app = macheteapp, inputs = inputs.machete)
                            write.logs(text=paste0("Drafting ", name.machete.task,"\nId is:\n", machete.task$id), logfilenames = logs.to.write, ttappend=TRUE, screen=TRUE)
                            ## Now run the draft task
                            write.logs(text="About to run the machete task just drafted.\n", logfilenames = logs.to.write, ttappend=TRUE, screen=TRUE)
                            machete.task$run()
                            taskidforinfo = machete.task$id
                            wlog("\ntaskinfo,machete,running,", taskidforinfo, ",", thisnicefname, "\n")
                            infodf$type.latest.task[line.to.work.on] <- 4
                            infodf$id.latest.task[line.to.work.on] <- machete.task$id
                            infodf$status.latest.task[line.to.work.on] <- machete.task$status
                            infodf$id.machete[line.to.work.on] <- machete.task$id
                            infodf$name.machete[line.to.work.on] <- name.machete.task
                        } ## end else
                    } ## end if/else re if error in getting machete inputs
                } ## end if (this.status == "COMPLETED")
                else if (this.status %in% c("QUEUED","RUNNING")){
                    ## don't do anything
                    Sys.sleep(1)
                }
                else {
                    wlog("ERROR ERROR. Task ", thisinfo$name.knife, " is either in draft status or something else and this is weird. Killing the pipeline for this file, namely file ", thisnicefname, " with file id ", thisinfo$id.file, " . Line number of file: ", line.to.work.on)
                    infodf$alldone[line.to.work.on] <- TRUE
                } ## end else for status choices
            } ## end if/else for status choices
        } ## end else if (thisinfo$type.latest.task == 3)
        ## ####################################################  
        ## ####################################################  
        ## Now deal with the case of latest task being knife:
        ##  task.type is 4
        ## ####################################################  
        ## ####################################################  
        else if (thisinfo$type.latest.task == 4){
            task.type <- 4
            ## check the status of the task
            ## "QUEUED", "DRAFT", "RUNNING",
            ##  "COMPLETED", "ABORTED", "FAILED"
            thistask.details <- get.details.of.a.task.from.id(taskid = thisinfo$id.latest.task, auth.token=auth.token, ttwdir=tempdir)
            this.status <- thistask.details$status
            {
                ## ########################
                ## if aborted or failed, then rerun if
                ##  fails <= allowed.fails
                if (this.status %in% c("ABORTED", "FAILED")){
                    if (failmatrix[line.to.work.on,task.type] < allowed.fails){
                        failmatrix[line.to.work.on,task.type] <- failmatrix[line.to.work.on,task.type] + 1
                        name.machete.task <- paste0("Rerunning machete at ", nicetime, " for failed task ", thisinfo$name.machete)

                        ## for some reason, api doesn't work to just
                        ## get machete inputs from the machete task
                        ## so just get them from the knife again
                        knifetask.details <- get.details.of.a.task.from.id(taskid = thisinfo$id.knife, auth.token=auth.token, ttwdir=tempdir)
                        out.inputs.machete <- get.inputs.machete.from.knife.details(details.knife.task = knifetask.details, infile.etc.info.file = infile.etc.info.file, logs.to.write=logs.to.write)
                        {
                            if (out.inputs.machete$error.in.getting.machete.inputs == TRUE){
                                ## if there was a problem getting inputs,
                                ## then alldone <- TRUE
                                wlog("ERROR ERROR. Problem getting inputs for a rerun of the machete task following the task ", thisinfo$name.knife, ". Killing the pipeline for this file, namely file ", thisnicefname, " with file id ", thisinfo$id.file, " . Line number of file: ", line.to.work.on)
                                infodf$alldone[line.to.work.on] <- TRUE
                                infodf$error.in.getting.machete.inputs[line.to.work.on] <- TRUE
                            }
                            else {
                                inputs.machete <- out.inputs.machete$inputs.machete
                                machete.task <- mm$task_add(name = name.machete.task, description = name.machete.task,  app = macheteapp, inputs = inputs.machete)
                                write.logs(text=paste0("Drafting ", name.machete.task,"\nId is:\n", machete.task$id), logfilenames = logs.to.write, ttappend=TRUE, screen=TRUE)
                                ## Now run the draft task
                                write.logs(text="About to run the machete task just drafted.\n", logfilenames = logs.to.write, ttappend=TRUE, screen=TRUE)
                                machete.task$run()
                                taskidforinfo = machete.task$id
                                wlog("\ntaskinfo,machete,rerunning,", taskidforinfo, ",", thisnicefname, "\n")
                                infodf$type.latest.task[line.to.work.on] <- 4
                                infodf$id.latest.task[line.to.work.on] <- machete.task$id
                                infodf$status.latest.task[line.to.work.on] <- machete.task$status
                                infodf$id.machete[line.to.work.on] <- machete.task$id
                                infodf$name.machete[line.to.work.on] <- name.machete.task
                            } ## end else
                        } ## end if/else re if error in getting machete inputs
                    } ## end if (failmatrix[line.to.work.on,task.type]
                    ## < allowed.fails)
                    else {
                        wlog("ERROR ERROR. Too many (", allowed.fails, ") fails for machete task. Killing the pipeline for this file, namely file ", thisnicefname, " with file id ", thisinfo$id.file, "\n Task id:\n", thisinfo$id.latest.task, " . Line number of file: ", line.to.work.on)
                        infodf$alldone[line.to.work.on] <- TRUE
                    }
                } ## end if (this.status %in% c("ABORTED", "FAILED"))
                ##########################
                ## if completed, download machete results
                else if (this.status == "COMPLETED"){
                    wlog("Task ", thisinfo$name.machete, " finished.")
                    wlog("\ntaskinfo,machete,finished,", thisinfo$id.latest.task, ",", thisnicefname, "\n")
                    ## now download machete results 
 
                    out.download <- download.reports.new.version(task.id=thisinfo$id.machete, task.short.name=thisnicefname, ttwdir=groupdir, ttauth=auth.token, ttproj=paste0(pipeowner,"/", pipeproj), tempdir=tempdir, datadir=groupdir)
                    ## is there any error.file at all and 
                    ## is there a YES.error file in the machete when you
                    ## download it?
                    infodf$some.error.file.present[line.to.work.on] <- as.logical(out.download$error.file.present)
                    infodf$yes.error.file.present[line.to.work.on] <- as.logical(out.download$yes.error.file.present)
                    infodf$status.latest.task[line.to.work.on] <- "COMPLETED"
                    infodf$download.attempted[line.to.work.on] <- TRUE
                    taskidforinfo = thisinfo$id.machete
                    wlog("\ntaskinfo,machete,downloadattempted,", taskidforinfo, ",", thisnicefname, "\n")
    
                    task.dir.full <- file.path(groupdir, thisnicefname)

                    wlog("\nDone with pipeline for ", thisnicefname, ", which involves, e.g., the first fastq file\n", thisinfo$fastq1.new, "\nFiles saved in \n", task.dir.full, "\nLine number of file: ", line.to.work.on)
                    infodf$alldone[line.to.work.on] <- TRUE
                } ## end if (this.status == "COMPLETED")
                else if (this.status %in% c("QUEUED","RUNNING")){
                    ## don't do anything
                    Sys.sleep(1)
                }
                else {
                    wlog("ERROR ERROR. Task ", thisinfo$name.machete, " is either in draft status or something else and this is weird. Killing the pipeline for this file, namely file ", thisnicefname, " with file id ", thisinfo$id.file, " . Line number of file: ", line.to.work.on)
                    infodf$alldone[line.to.work.on] <- TRUE
                } ## end else for status choices
            } ## end if/else for status choices
        } ## end else if (thisinfo$type.latest.task == 4)
        else {
            wlog("ERROR ERROR. Shouldn't have gotten here. This means alldone is FALSE, but task.type is not in 0,1,2,3,4. Killing the pipeline for this file, namely file ", thisnicefname, " with file id ", thisinfo$id.file, " . Line number of file: ", line.to.work.on)
            infodf$alldone[line.to.work.on] <- TRUE
        }
    } ## end if/else chain for type of latest task

         
    ## write infodf and failmatrix again
    write.table(infodf, file = infofile, row.names = FALSE, col.names = TRUE, sep = ",", append=FALSE, quote=TRUE)
    write.table(failmatrix, file = failfile, row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)

    } ## end of if (thisinfo$alldone == FALSE)
    infodf$alldone[line.to.work.on]
}




## before this, get nicename, set latest.task to 0, alldone to 0
##  download.attempted to 0, other stuff to NA







## for testing, using two aml files
## start.of.run = TRUE; tarfileids = c("57c76ccce4b0f9890b16d3b0", "57c76ccce4b0f9890b16d3b2"); tarfilenames = c("TCGA-AB-2874-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2900-03A-01T-0735-13_rnaseq_fastq.tar"); complete.or.appended="appended"; pipeowner="JSALZMAN"; pipeproj="machete"; unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0"; trimapp="JSALZMAN/machete/trimgalorev2/0"; knifeapp="JSALZMAN/machete/knife-for-work"; macheteapp="JSALZMAN/machete/machete-light"; runid.suffix= groupname; timeout.days=4; seconds.of.wait.time.between.runs=2; allowed.fails = 2; infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")

## second round of testing, using two aml files
##  the second aml file from the first round of testing is the first
##  file here
## so up to 45:47 in file info for part 2 for amlaug31
## start.of.run = TRUE; tarfileids = c("57c76ccce4b0f9890b16d3b2","57c76ccce4b0f9890b16d3b4"); tarfilenames = c("TCGA-AB-2900-03A-01T-0735-13_rnaseq_fastq.tar","TCGA-AB-2877-03A-01T-0735-13_rnaseq_fastq.tar"); complete.or.appended="appended"; pipeowner="JSALZMAN"; pipeproj="machete"; unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0"; trimapp="JSALZMAN/machete/trimgalorev2/0"; knifeapp="JSALZMAN/machete/knife-for-work"; macheteapp="JSALZMAN/machete/machete-light"; runid.suffix= groupname; timeout.days=4; seconds.of.wait.time.between.runs=2; allowed.fails = 2; infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")

## third round of testing, using two other aml files
## so using 46:50 in file info for part 2 for amlaug31
##  use group name amlaug31secondtest
## 
## exec.n.pipelines(start.of.run = TRUE, tarfileids = c("57c76ccde4b0f9890b16d3b6", "57c76ccde4b0f9890b16d3b8"), tarfilenames = c("TCGA-AB-2860-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2862-03A-01T-0736-13_rnaseq_fastq.tar"), auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp="JSALZMAN/machete/machete-light", runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata"))

## to resume, rather than to start:
## exec.n.pipelines(start.of.run = FALSE, tarfileids = c("57c76ccde4b0f9890b16d3b6", "57c76ccde4b0f9890b16d3b8"), tarfilenames = c("TCGA-AB-2860-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2862-03A-01T-0736-13_rnaseq_fastq.tar"), auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp="JSALZMAN/machete/machete-light", runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata"))



## start.of.run defaults to TRUE
##  that's what you want if you're starting n runs
##  but if you are picking up in the middle, set it to FALSE

## run the whole pipeline for multiple tar files
## tarfilenames and tarfileids are character vectors that should be
##  the same length
##
## infofile and failfile sits inside groupdir
exec.n.pipelines <- function(start.of.run = TRUE, tarfilenames, tarfileids, auth.token, groupname, grouplog, groupdir, tempdir, homedir, temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp="JSALZMAN/machete/machete-light", runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails=2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")){
    ## write to one log, probably just the grouplog:
    wlogone <- function(...){ write.logs(text=paste0(...,"\n"), logfilenames = grouplog, ttappend = TRUE, screen = TRUE) }
    n.tarfiles <- length(tarfilenames)
    ## 
    ## where the big data frame is stored
    infofile = file.path(groupdir, "infofile.csv")
    ## where the matrix of failed task 0/1's is stored
    failfile = file.path(groupdir, "failfile.csv")
    ##
    ## start this for this function call, whether it's the
    ##  start of all the runs or just resuming
    start.time.this.function.call <- Sys.time()
    
    nicenames <- vector("character", n.tarfiles)
    for (tti in 1:n.tarfiles){
        nicenames[tti] <- clean.names(tarfilenames[tti])
    }
    ##
    ## do this if it's the first time you call the function for these
    ##  files:
    ##
    {
        if (start.of.run){
            start.time <- Sys.time()
            wlogone("The start time is ", start.time)
            wlogone("Note that this function assumes that files take forms like\n_R1.fastq or _1.fastq or _R1.fq or _1.fq or with .gz also")
            wlogone("There are ", n.tarfiles, " tar files.")
            wlogone("The ids are:\n\"", paste(tarfileids, collapse = "\",\""), "\"", "\n\n")
            wlogone("The names are:\n\"", paste(tarfilenames, collapse = "\",\""), "\"", "\n\n")
            ## ####################################
            ## initialize the two csv info files
            ## ####################################
            failmatrix <- matrix(0, nrow= n.tarfiles, ncol = 4)
            ## make these next things so that line with
            ##  initialization of data frame
            ##  has < 1024 characters in line
            empty.char <- vector("character", length=n.tarfiles)
            bb <- vector("logical", length=n.tarfiles)
            infodf <- data.frame(id.file = tarfileids, filename = tarfilenames, nicefname = nicenames, type.latest.task = vector("integer", length = n.tarfiles), id.latest.task = empty.char, status.latest.task = empty.char, alldone = bb, id.unpack = empty.char, id.trim = empty.char, id.knife = empty.char, id.machete = empty.char, name.unpack = empty.char, name.trim = empty.char, name.knife = empty.char, name.machete = empty.char, fastq.files.renamed = bb, fastq1.original = empty.char, fastq2.original = empty.char, fastq1.new = empty.char, fastq2.new = empty.char, trimmed.filename1.new = empty.char, trimmed.filename2.new = empty.char, id.new.trimmed.file1 = empty.char, id.new.trimmed.file2 = empty.char, error.in.fastq.file.names = bb, error.in.getting.machete.inputs = bb, download.attempted = bb, some.error.file.present= bb, yes.error.file.present = bb, stringsAsFactors = FALSE)
            ## some of these are just for clarity
            infodf$type.latest.task[] <- 0
            infodf$id.latest.task[] <- NA
            infodf$status.latest.task[] <- NA
            infodf$alldone[] <- FALSE
            infodf$id.unpack[] <- NA
            infodf$id.trim[] <- NA
            infodf$id.knife[] <- NA
            infodf$id.machete[] <- NA
            infodf$name.unpack[] <- NA
            infodf$name.trim[] <- NA
            infodf$name.knife[] <- NA
            infodf$name.machete[] <- NA
            infodf$fastq.files.renamed[] <- NA
            infodf$fastq1.original[] <- NA
            infodf$fastq2.original[] <- NA
            infodf$fastq1.new[] <- NA
            infodf$fastq2.new[] <- NA
            infodf$trimmed.filename1.new[] <- NA
            infodf$trimmed.filename2.new[] <- NA
            infodf$id.new.trimmed.file1[] <- NA
            infodf$id.new.trimmed.file2[] <- NA
            infodf$error.in.fastq.file.names[] <- NA
            infodf$error.in.getting.machete.inputs[] <- FALSE
            infodf$download.attempted[] <- FALSE
            infodf$some.error.file.present[] <- NA
            infodf$yes.error.file.present[] <- NA
            ## id.file, filename, nicefname, type.latest.task, id.latest.task, status.latest.task, alldone,
            ##    id.unpack, id.trim, id.knife, id.machete, download.attempted,
            ## Now write the files for the first time
            write.table(infodf, file = infofile, row.names = FALSE, col.names = TRUE, sep = ",", append=FALSE, quote=TRUE)
            write.table(failmatrix, file = failfile, row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)
            wlogone("Just stored initialized info in infofile at\n", infofile)
            wlogone("Just stored initialized fail info in failfile at\n", failfile)
            ## Create directories for each of the tar files
            for (tti in 1:n.tarfiles){
                thisfiledir = file.path(groupdir, nicenames[tti])
                if (!dir.exists(thisfiledir)){
                    dir.create(thisfiledir)
                }
            }
        }  ## end initializing you do if start.of.run is TRUE
        else {
            resumption.time <- Sys.time()
            wlogone("The time that this started resuming is ", resumption.time)
        }
    } ## end if/else for start.of.run == TRUE
    ## Read them in, as a check:
    ## infodf <- read.table(file = infofile, header = TRUE, sep = ",", stringsAsFactors = FALSE)
    ## failmatrix <- as.matrix(read.table(file = failfile, header = FALSE, sep = ",", stringsAsFactors = FALSE))
    ## colnames(failmatrix) <- NULL
    n.done <- 0
    vec.of.alldones <- vector("logical", length = n.tarfiles)
    ## for emphasis:
    vec.of.alldones[] <- FALSE
    stop.day.numeric <- as.numeric(as.Date(start.time.this.function.call) + timeout.days)
    notimeout <- TRUE
    line.to.work.on <- 1
    ## Now start while loop
    while (notimeout & (n.done < n.tarfiles)){
        Sys.sleep(seconds.of.wait.time.between.runs)

        ## process one line here
        ## first read in the infodf and see if
        ## everything is done for this line of the df
        infodf <- read.table(file = infofile, header = TRUE, sep = ",", stringsAsFactors = FALSE)
        {
            if (infodf$alldone[line.to.work.on] == FALSE){
                do.one.step(line.to.work.on, infofile, failfile, tarfilenames, tarfileids, auth.token, groupname, grouplog, groupdir, tempdir, homedir, temprdatadir, complete.or.appended, pipeowner, pipeproj, unpackapp, trimapp, knifeapp, macheteapp, runid.suffix, timeout.days, seconds.of.wait.time.between.runs, allowed.fails, infile.etc.info.file)
            }
            else {
                vec.of.alldones[line.to.work.on] <- TRUE
            }
        }
        n.done <- sum(vec.of.alldones)

        ## if line.to.work.on is at the end, go to line 1,
        ## otherwise go to the next line
        line.to.work.on <- ifelse(line.to.work.on == n.tarfiles, 1, line.to.work.on + 1)
        ##
        if (as.numeric(Sys.Date())>= stop.day.numeric){
            notimeout <- FALSE
        }
    } ## end while loop
    wlogone("\n\nExiting while loop at top level of exec.n.pipelines.\n\n")
    end.time <- Sys.time()
    wlogone("The time that this stopped is ", end.time)
}




## This is like do.one.step above, but now for the case that
##   there are pairs of fastq files that are unpacked already
## 
do.one.step.starting.from.unpacked.fastqs <- function(line.to.work.on, infofile, failfile, auth.token, groupname, grouplog, groupdir, tempdir, homedir, temprdatadir, complete.or.appended, pipeowner, pipeproj, unpackapp, trimapp, knifeapp, macheteapp, runid.suffix, timeout.days, seconds.of.wait.time.between.runs, allowed.fails, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")){
    ## Read the csv files in:
    infodf <- read.table(file = infofile, header = TRUE, sep = ",", stringsAsFactors = FALSE)
    failmatrix <- as.matrix(read.table(file = failfile, header = FALSE, sep = ",", stringsAsFactors = FALSE))
    colnames(failmatrix) <- NULL

    thisnicefname <- infodf$nicefname[line.to.work.on]
    thisinfo <- infodf[line.to.work.on,]
    
    thisfiledir <- file.path(groupdir, thisnicefname)
    
    ## make a nice filename for log for this tarfile, call it thisfilelog
    thisfilelog <- file.path(thisfiledir, paste0("log",thisnicefname,".txt"))

    logs.to.write <- c(grouplog, thisfilelog)
    ## 
    ## Make shorthand so easier to type command to write to logs
    wlog <- function(...){ write.logs(text=paste0(...,"\n"), logfilenames = logs.to.write, ttappend = TRUE, screen = TRUE) }
    ## 
    print(paste0("Working on line ", line.to.work.on))
    ## print(line.to.work.on)
    ## print(paste0("Working on line ", line.to.work.on, " of file ", infofile, ", i.e. file ", thisnicefname))

    ## Only do anything if not all done.
    ## However, should have already checked this at
    ## the level of the function calling this one.
    if (thisinfo$alldone == FALSE){
        nicetime <- format(Sys.time(),"%b%d%H%M")
        nicedate<- tolower(format(Sys.time(),"%b%d"))

        aa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")
        ## mm for project, which is typically machete
        mm <- aa$project(id=paste0(pipeowner,"/",pipeproj))
        ## Now see what is the type for the latest task:
        {
        ## ####################################################    
        ## ####################################################    
        ## first case: haven't even started the first task
        ##  task type is 0, there is no 1, to retain
        ##  consistency with previous version
        ## ####################################################    
        ## ####################################################    
        if (thisinfo$type.latest.task == 0){
            ## figure out order of fastq names and clean up the
            unordered.names.unpacked.files <- c(thisinfo$fastq1.original, thisinfo$fastq2.original) 
            wlog("Fastq files for ", thisnicefname, " are:\n", paste(unordered.names.unpacked.files, collapse=","))
            if (length(unordered.names.unpacked.files)==0){
                try(wlog("Empty value of unordered.names.unpacked.files. line number ", line.to.work.on, ". thistask.details :", thistask.details$outputs))
            }
            unordered.paths.unpacked.files <- c(thisinfo$fastq1.original.id,thisinfo$fastq2.original.id)
            nicefastqnames.out <- make.nice.names.of.fastq.files(unordered.names.unpacked.files, unordered.paths.unpacked.files, pipeowner, pipeproj, auth.token, tempdir, logs.to.write)
            ## if get error when making names, should set alldone to
            ## TRUE and stop here
            {
                if (nicefastqnames.out$error.in.fastq.file.names) {
                    infodf$alldone[line.to.work.on] <- TRUE
                }
                else {
                    ## add names and whether changed to infodf
                    ##  run trim galore here after dealing
                    ##  with file names
                    name.trim.task <- paste("Trim galore for tar file ", thisnicefname, " from group ", groupname, "; first fastq file is ", nicefastqnames.out$ordered.names.unpacked.files.new.if.changed[1], "; drafted at ", nicetime, sep="")
                    inputs.trim.task <- list(error_rate=0.1,  min_read_length=20, stringency=1, quality=20, read1= Files(id=nicefastqnames.out$ordered.paths.unpacked.files.new.if.changed[1], name=nicefastqnames.out$ordered.names.unpacked.files.new.if.changed[1]), read2= Files(id=nicefastqnames.out$ordered.paths.unpacked.files.new.if.changed[2], name=nicefastqnames.out$ordered.names.unpacked.files.new.if.changed[2]))
                    wlog("About to draft and then run ", name.trim.task)
                
                    trim.task <- mm$task_add(name = name.trim.task, description = name.trim.task, app = trimapp, inputs = inputs.trim.task)
                    ## Now run the task
                    trim.task$run()
                    taskidforinfo = trim.task$id
                    wlog("\ntaskinfo,trim,running,", taskidforinfo, ",", thisnicefname, "\n")
                    infodf$type.latest.task[line.to.work.on] <- 2
                    infodf$id.latest.task[line.to.work.on] <- trim.task$id
                    infodf$status.latest.task[line.to.work.on] <- trim.task$status
                    infodf$id.trim[line.to.work.on] <- trim.task$id
                    infodf$name.trim[line.to.work.on] <- name.trim.task
                    infodf$fastq.files.renamed[line.to.work.on] <- nicefastqnames.out$files.renamed
                    infodf$fastq1.original[line.to.work.on] <- nicefastqnames.out$ordered.names.unpacked.files.original[1]
                    infodf$fastq2.original[line.to.work.on] <-  nicefastqnames.out$ordered.names.unpacked.files.original[2]
                    infodf$fastq1.new[line.to.work.on] <- nicefastqnames.out$ordered.names.unpacked.files.new.if.changed[1]
                    infodf$fastq2.new[line.to.work.on] <- nicefastqnames.out$ordered.names.unpacked.files.new.if.changed[2]
                    infodf$fastq.files.renamed[line.to.work.on] <- nicefastqnames.out$files.renamed
                } ## end else
            } ## end if/else
        } ## end else if (thisinfo$type.latest.task == 1)
        ## ####################################################    
        ## ####################################################    
        ## Now deal with the case of latest task being trim:
        ##  task.type is 2
        ## ####################################################    
        ## ####################################################    
        else if (thisinfo$type.latest.task == 2){
            task.type <- 2
            ## check the status of the task
            ## "QUEUED", "DRAFT", "RUNNING",
            ##  "COMPLETED", "ABORTED", "FAILED"
            thistask.details <- get.details.of.a.task.from.id(taskid = thisinfo$id.latest.task, auth.token=auth.token, ttwdir=tempdir)
            this.status <- thistask.details$status
            {
            ## if aborted or failed, then rerun if fails <= allowed.fails
            if (this.status %in% c("ABORTED", "FAILED")){
                if (failmatrix[line.to.work.on,task.type] < allowed.fails){
                    failmatrix[line.to.work.on,task.type] <- failmatrix[line.to.work.on,task.type] + 1
                    name.trim.task <- paste0("Rerunning at ", nicetime, " for failed task ", thisinfo$name.trim)
                    ## get info on read1 and read2 from thistask.details
                    ## changing next thing on nov 1 2016 
                    ## I don't know why, but it seems that sometimes 
                    ## thistask.details$inputs$read1 works for the
                    ## api and other times it decides that
                    ## thistask.details$inputs is character class
                    ## and has no names, not sure why. File info
                    ## is inconsistent for whatever reason, I guess??
                    ## e.g.: 
                    ## Error in thistask.details$inputs$read1$path :
                    ## $ operator is invalid for atomic vectors
                    out.try.read.name.1 <- try(read.name.1 <- thistask.details$inputs$read1$name)
                    if (class(out.try.read.name.1)=="try-error"){
                        read.name.1 <- as.character(thistask.details$inputs$read1['name'])
                    }
                    out.try.read.name.2 <- try(read.name.2 <- thistask.details$inputs$read2$name)
                    if (class(out.try.read.name.2)=="try-error"){
                        read.name.2 <- as.character(thistask.details$inputs$read2['name'])
                    }
                    out.try.read.1.id <- try(read.1.id <- thistask.details$inputs$read1$path)
                    if (class(out.try.read.1.id)=="try-error"){
                        read.1.id <- as.character(thistask.details$inputs$read1['path'])
                    }
                    out.try.read.2.id <- try(read.2.id <- thistask.details$inputs$read2$path)
                    if (class(out.try.read.2.id)=="try-error"){
                        read.2.id <- as.character(thistask.details$inputs$read2['path'])
                    }
                    inputs.trim.task <- list(error_rate=0.1,  min_read_length=20, stringency=1, quality=20, read1= Files(id=read.1.id, name=read.name.1), read2= Files(id=read.2.id, name=read.name.2))
                    wlog("About to draft and then run ", name.trim.task)

                    trim.task <- mm$task_add(name = name.trim.task, description = name.trim.task, app = trimapp, inputs = inputs.trim.task)
                    ## Now run the task
                    trim.task$run()
                    taskidforinfo = trim.task$id
                    wlog("\ntaskinfo,trim,rerunning,", taskidforinfo, ",", thisnicefname, "\n")
                    infodf$type.latest.task[line.to.work.on] <- 2
                    infodf$id.latest.task[line.to.work.on] <- trim.task$id
                    infodf$status.latest.task[line.to.work.on] <- trim.task$status
                    infodf$id.trim[line.to.work.on] <- trim.task$id
                    infodf$name.trim[line.to.work.on] <- name.trim.task
                }
                else {
                    wlog("ERROR ERROR. Too many (", allowed.fails, ") fails for trim task. Killing the pipeline for this file, namely file ", thisnicefname, " with file id ", thisinfo$id.file, "\n Task id:\n", thisinfo$id.latest.task, " . Line number of file: ", line.to.work.on)
                    infodf$alldone[line.to.work.on] <- TRUE
                }
            }
            ## if completed, run knife
            else if (this.status == "COMPLETED"){
                wlog("Task ", thisinfo$name.unpack, " finished.")
                wlog("\ntaskinfo,unpack,finished,", thisinfo$id.latest.task, ",", thisnicefname, "\n")

                ## first rename outputs from trim
                ##  Rename val files, because of e.g. _1_val
                ##    before _1.fq.gz
                ##    or _R1_val before _R1.fq.gz
                thistask.details <- get.details.of.a.task.from.id(taskid = thisinfo$id.latest.task, auth.token=auth.token, ttwdir=tempdir)
                trimmed.files.info.raw <- list(thistask.details$outputs$trim_read1, thistask.details$outputs$trim_read2)
                
                out.nice.names.validated <- make.nice.names.of.validated.fastq.files(trimmed.files.info.raw, pipeowner, pipeproj, auth.token, tempdir, logs.to.write)       
                ## if get error when making names, should set alldone to
                ## TRUE and stop here
                {
                    if (out.nice.names.validated$error.in.fastq.file.names) {
                        infodf$alldone[line.to.work.on] <- TRUE
                        infodf$error.in.fastq.file.names[line.to.work.on] <- TRUE
                        wlog("ERROR ERROR: problem with names after trim galore for file ", thisnicefname, "; line number is of file is: ", line.to.work.on)
                    }
                    else {
                        ##      now run knife task
                        ##
                        ##  first write the new filenames and ids
                        ##   to the df so that we can use
                        ##   the knife task drafting stuff below
                        ##   again when doing the code for rerunning
                        ##   a failed knife task
                        infodf$trimmed.filename1.new[line.to.work.on] <- out.nice.names.validated$trimmed.filenames.new[1]
                        infodf$trimmed.filename2.new[line.to.work.on] <- out.nice.names.validated$trimmed.filenames.new[2]
                        infodf$id.new.trimmed.file1[line.to.work.on] <- out.nice.names.validated$trimmed.paths.new[1]
                        infodf$id.new.trimmed.file2[line.to.work.on] <- out.nice.names.validated$trimmed.paths.new[2]

                        ## then do inputs.knife
                        ## We assign thisinfo here again
                        ## so that we can use the same code
                        ## below for rerunning knife
                        thisinfo <- infodf[line.to.work.on,]
                        ## Next data set includes list of
                        ##  all the "infiles",
                        ##  i.e. the 43 auxiliary input files
                        ## this data file contains object infile.array
                        load(infile.etc.info.file)
                        ## Now set up the draft knife task
                        runid = paste0(nicedate,runid.suffix)
                        name.knife.task <- paste("Knife for ", thisnicefname, ", from tar file ", thisnicefname," from group ", groupname, "; first fastq file is ", thisinfo$fastq1.new, "; ", complete.or.appended, ", drafted at ", nicetime, sep="")
                        
                        inputs.knife <- list(inputarray=infile.array,  fastqfiles=list(Files(id=thisinfo$id.new.trimmed.file1, name=thisinfo$trimmed.filename1.new), Files(id=thisinfo$id.new.trimmed.file2, name=thisinfo$trimmed.filename2.new)),  datasetname=thisnicefname,  readidstyle=complete.or.appended,  runid=runid)
                        ##
                        wlog("About to draft and then run ", name.knife.task)
                        knife.task <- mm$task_add(name = name.knife.task, description = name.knife.task,  app = knifeapp, inputs = inputs.knife)
                        ## Now run the knife task
                        knife.task$run()
                        taskidforinfo = knife.task$id
                        wlog("\ntaskinfo,knife,running,", taskidforinfo, ",", thisnicefname, "\n")

                        infodf$type.latest.task[line.to.work.on] <- 3
                        infodf$id.latest.task[line.to.work.on] <- knife.task$id
                        infodf$status.latest.task[line.to.work.on] <- knife.task$status
                        infodf$id.knife[line.to.work.on] <- knife.task$id
                        infodf$name.knife[line.to.work.on] <- name.knife.task
                        
                    } ## end else
                } ## end if/else

            }
            else if (this.status %in% c("QUEUED","RUNNING")){
                ## don't do anything
                Sys.sleep(1)
            }
            else {
                wlog("ERROR ERROR. Task ", thisinfo$name.trim, " is either in draft status or something else and this is weird. Killing the pipeline for this file, namely file ", thisnicefname, " with file id ", thisinfo$id.file, " . Line number of file: ", line.to.work.on)
                infodf$alldone[line.to.work.on] <- TRUE
            }
        } 
        } ## end else if (thisinfo$type.latest.task == 2)


        ## ####################################################    
        ## ####################################################    
        ## Now deal with the case of latest task being knife:
        ##  task.type is 3
        ## ####################################################    
        ## ####################################################    
        else if (thisinfo$type.latest.task == 3){
            task.type <- 3
            ## check the status of the task
            ## "QUEUED", "DRAFT", "RUNNING",
            ##  "COMPLETED", "ABORTED", "FAILED"
            thistask.details <- get.details.of.a.task.from.id(taskid = thisinfo$id.latest.task, auth.token=auth.token, ttwdir=tempdir)
            this.status <- thistask.details$status
            {
                ## ########################
                ## if aborted or failed, then rerun if
                ##  fails <= allowed.fails
                if (this.status %in% c("ABORTED", "FAILED")){
                    if (failmatrix[line.to.work.on,task.type] < allowed.fails){
                        failmatrix[line.to.work.on,task.type] <- failmatrix[line.to.work.on,task.type] + 1
                        name.knife.task <- paste0("Rerunning knife at ", nicetime, " for failed task ", thisinfo$name.knife)
                        ## Now set up the draft knife task
                        load(infile.etc.info.file)
                        runid = paste0(nicedate,runid.suffix)
                        inputs.knife <- list(inputarray=infile.array,  fastqfiles=list(Files(id=thisinfo$id.new.trimmed.file1, name=thisinfo$trimmed.filename1.new), Files(id=thisinfo$id.new.trimmed.file2, name=thisinfo$trimmed.filename2.new)),  datasetname=thisnicefname,  readidstyle=complete.or.appended,  runid=runid)
                        ##
                        wlog("About to draft and then run ", name.knife.task)
                        knife.task <- mm$task_add(name = name.knife.task, description = name.knife.task,  app = knifeapp, inputs = inputs.knife)
                        ## Now run the knife task
                        knife.task$run()
                        taskidforinfo = knife.task$id
                        wlog("\ntaskinfo,knife,rerunning,", taskidforinfo, ",", thisnicefname, "\n")
                        infodf$type.latest.task[line.to.work.on] <- 3
                        infodf$id.latest.task[line.to.work.on] <- knife.task$id
                        infodf$status.latest.task[line.to.work.on] <- knife.task$status
                        infodf$id.knife[line.to.work.on] <- knife.task$id
                        infodf$name.knife[line.to.work.on] <- name.knife.task
                    } ## end if (failmatrix[line.to.work.on,task.type]
                    ## < allowed.fails)
                    else {
                        wlog("ERROR ERROR. Too many (", allowed.fails, ") fails for knife task. Killing the pipeline for this file, namely file ", thisnicefname, " with file id ", thisinfo$id.file, "\n Task id:\n", thisinfo$id.latest.task, " . Line number of file: ", line.to.work.on)
                        infodf$alldone[line.to.work.on] <- TRUE
                    }
                } ## end if (this.status %in% c("ABORTED", "FAILED"))
                ##########################
                ## if completed, download knife tar and then run machete
                else if (this.status == "COMPLETED"){
                    wlog("Task ", thisinfo$name.knife, " finished.")
                    wlog("\ntaskinfo,knife,finished,", thisinfo$id.latest.task, ",", thisnicefname, "\n")
                    ##########################
                    ## download knife tar
                    ## do a try, just to be cautious
                    out.try.download.knife <- try(download.knife.text.reports(task.id = thisinfo$id.knife, task.short.name=thisnicefname, ttwdir=groupdir, ttauth=auth.token, ttproj=paste0(pipeowner,"/", pipeproj), tempdir=tempdir, datadir=groupdir))
                    {
                        if (class(out.try.download.knife)=="try-error"){
                            wlog("Failed when downloading files for knife for task ", thisinfo$id.knife, " for line ", line.to.work.on)
                        }
                        else {
                            wlog("Successfully downloaded files for knife for task ", thisinfo$id.knife, " for line ", line.to.work.on)
                        }
                    }
                    out.inputs.machete <- get.inputs.machete.from.knife.details(details.knife.task = thistask.details, infile.etc.info.file = infile.etc.info.file, logs.to.write=logs.to.write)
                    {
                        if (out.inputs.machete$error.in.getting.machete.inputs == TRUE){
                            ## if there was a problem getting inputs,
                            ## then alldone <- TRUE
                            wlog("ERROR ERROR. Problem getting inputs forthe machete task following the task ", thisinfo$name.knife, ". Killing the pipeline for this file, namely file ", thisnicefname, " with file id ", thisinfo$id.file, " . Line number of file: ", line.to.work.on)
                            infodf$alldone[line.to.work.on] <- TRUE
                            infodf$error.in.getting.machete.inputs[line.to.work.on] <- TRUE
                        }
                        else {
                            inputs.machete <- out.inputs.machete$inputs.machete
                            name.machete.task <- paste("Machete for ", thisnicefname, ", from group ", groupname, "; first fastq file is ", thisinfo$fastq1.new, "; ", complete.or.appended, ", drafted at ", nicetime, sep="")

                            machete.task <- mm$task_add(name = name.machete.task, description = name.machete.task,  app = macheteapp, inputs = inputs.machete)
                            write.logs(text=paste0("Drafting ", name.machete.task,"\nId is:\n", machete.task$id), logfilenames = logs.to.write, ttappend=TRUE, screen=TRUE)
                            ## Now run the draft task
                            write.logs(text="About to run the machete task just drafted.\n", logfilenames = logs.to.write, ttappend=TRUE, screen=TRUE)
                            machete.task$run()
                            taskidforinfo = machete.task$id
                            wlog("\ntaskinfo,machete,running,", taskidforinfo, ",", thisnicefname, "\n")
                            infodf$type.latest.task[line.to.work.on] <- 4
                            infodf$id.latest.task[line.to.work.on] <- machete.task$id
                            infodf$status.latest.task[line.to.work.on] <- machete.task$status
                            infodf$id.machete[line.to.work.on] <- machete.task$id
                            infodf$name.machete[line.to.work.on] <- name.machete.task
                        } ## end else
                    } ## end if/else re if error in getting machete inputs
                } ## end if (this.status == "COMPLETED")
                else if (this.status %in% c("QUEUED","RUNNING")){
                    ## don't do anything
                    Sys.sleep(1)
                }
                else {
                    wlog("ERROR ERROR. Task ", thisinfo$name.knife, " is either in draft status or something else and this is weird. Killing the pipeline for this file, namely file ", thisnicefname, " with file id ", thisinfo$id.file, " . Line number of file: ", line.to.work.on)
                    infodf$alldone[line.to.work.on] <- TRUE
                } ## end else for status choices
            } ## end if/else for status choices
        } ## end else if (thisinfo$type.latest.task == 3)
        ## ####################################################  
        ## ####################################################  
        ## Now deal with the case of latest task being knife:
        ##  task.type is 4
        ## ####################################################  
        ## ####################################################  
        else if (thisinfo$type.latest.task == 4){
            task.type <- 4
            ## check the status of the task
            ## "QUEUED", "DRAFT", "RUNNING",
            ##  "COMPLETED", "ABORTED", "FAILED"
            thistask.details <- get.details.of.a.task.from.id(taskid = thisinfo$id.latest.task, auth.token=auth.token, ttwdir=tempdir)
            this.status <- thistask.details$status
            {
                ## ########################
                ## if aborted or failed, then rerun if
                ##  fails <= allowed.fails
                if (this.status %in% c("ABORTED", "FAILED")){
                    if (failmatrix[line.to.work.on,task.type] < allowed.fails){
                        failmatrix[line.to.work.on,task.type] <- failmatrix[line.to.work.on,task.type] + 1
                        name.machete.task <- paste0("Rerunning machete at ", nicetime, " for failed task ", thisinfo$name.machete)

                        ## for some reason, api doesn't work to just
                        ## get machete inputs from the machete task
                        ## so just get them from the knife again
                        knifetask.details <- get.details.of.a.task.from.id(taskid = thisinfo$id.knife, auth.token=auth.token, ttwdir=tempdir)
                        out.inputs.machete <- get.inputs.machete.from.knife.details(details.knife.task = knifetask.details, infile.etc.info.file = infile.etc.info.file, logs.to.write=logs.to.write)
                        {
                            if (out.inputs.machete$error.in.getting.machete.inputs == TRUE){
                                ## if there was a problem getting inputs,
                                ## then alldone <- TRUE
                                wlog("ERROR ERROR. Problem getting inputs for a rerun of the machete task following the task ", thisinfo$name.knife, ". Killing the pipeline for this file, namely file ", thisnicefname, " with file id ", thisinfo$id.file, " . Line number of file: ", line.to.work.on)
                                infodf$alldone[line.to.work.on] <- TRUE
                                infodf$error.in.getting.machete.inputs[line.to.work.on] <- TRUE
                            }
                            else {
                                inputs.machete <- out.inputs.machete$inputs.machete
                                machete.task <- mm$task_add(name = name.machete.task, description = name.machete.task,  app = macheteapp, inputs = inputs.machete)
                                write.logs(text=paste0("Drafting ", name.machete.task,"\nId is:\n", machete.task$id), logfilenames = logs.to.write, ttappend=TRUE, screen=TRUE)
                                ## Now run the draft task
                                write.logs(text="About to run the machete task just drafted.\n", logfilenames = logs.to.write, ttappend=TRUE, screen=TRUE)
                                machete.task$run()
                                taskidforinfo = machete.task$id
                                wlog("\ntaskinfo,machete,rerunning,", taskidforinfo, ",", thisnicefname, "\n")
                                infodf$type.latest.task[line.to.work.on] <- 4
                                infodf$id.latest.task[line.to.work.on] <- machete.task$id
                                infodf$status.latest.task[line.to.work.on] <- machete.task$status
                                infodf$id.machete[line.to.work.on] <- machete.task$id
                                infodf$name.machete[line.to.work.on] <- name.machete.task
                            } ## end else
                        } ## end if/else re if error in getting machete inputs
                    } ## end if (failmatrix[line.to.work.on,task.type]
                    ## < allowed.fails)
                    else {
                        wlog("ERROR ERROR. Too many (", allowed.fails, ") fails for machete task. Killing the pipeline for this file, namely file ", thisnicefname, " with file id ", thisinfo$id.file, "\n Task id:\n", thisinfo$id.latest.task, " . Line number of file: ", line.to.work.on)
                        infodf$alldone[line.to.work.on] <- TRUE
                    }
                } ## end if (this.status %in% c("ABORTED", "FAILED"))
                ##########################
                ## if completed, download machete results
                else if (this.status == "COMPLETED"){
                    wlog("Task ", thisinfo$name.machete, " finished.")
                    wlog("\ntaskinfo,machete,finished,", thisinfo$id.latest.task, ",", thisnicefname, "\n")
                    ## now download machete results 
 
                    out.download <- download.reports.new.version(task.id=thisinfo$id.machete, task.short.name=thisnicefname, ttwdir=groupdir, ttauth=auth.token, ttproj=paste0(pipeowner,"/", pipeproj), tempdir=tempdir, datadir=groupdir)
                    ## is there any error.file at all and 
                    ## is there a YES.error file in the machete when you
                    ## download it?
                    infodf$some.error.file.present[line.to.work.on] <- as.logical(out.download$error.file.present)
                    infodf$yes.error.file.present[line.to.work.on] <- as.logical(out.download$yes.error.file.present)
                    infodf$status.latest.task[line.to.work.on] <- "COMPLETED"
                    infodf$download.attempted[line.to.work.on] <- TRUE
                    taskidforinfo = thisinfo$id.machete
                    wlog("\ntaskinfo,machete,downloadattempted,", taskidforinfo, ",", thisnicefname, "\n")
    
                    task.dir.full <- file.path(groupdir, thisnicefname)

                    wlog("\nDone with pipeline for ", thisnicefname, ", which involves, e.g., the first fastq file\n", thisinfo$fastq1.new, "\nFiles saved in \n", task.dir.full, "\nLine number of file: ", line.to.work.on)
                    infodf$alldone[line.to.work.on] <- TRUE
                } ## end if (this.status == "COMPLETED")
                else if (this.status %in% c("QUEUED","RUNNING")){
                    ## don't do anything
                    Sys.sleep(1)
                }
                else {
                    wlog("ERROR ERROR. Task ", thisinfo$name.machete, " is either in draft status or something else and this is weird. Killing the pipeline for this file, namely file ", thisnicefname, " with file id ", thisinfo$id.file, " . Line number of file: ", line.to.work.on)
                    infodf$alldone[line.to.work.on] <- TRUE
                } ## end else for status choices
            } ## end if/else for status choices
        } ## end else if (thisinfo$type.latest.task == 4)
        else {
            wlog("ERROR ERROR. Shouldn't have gotten here. This means alldone is FALSE, but task.type is not in 0,1,2,3,4. Killing the pipeline for this file, namely file ", thisnicefname, " with file id ", thisinfo$id.file, " . Line number of file: ", line.to.work.on)
            infodf$alldone[line.to.work.on] <- TRUE
        }
    } ## end if/else chain for type of latest task

         
    ## write infodf and failmatrix again
    write.table(infodf, file = infofile, row.names = FALSE, col.names = TRUE, sep = ",", append=FALSE, quote=TRUE)
    write.table(failmatrix, file = failfile, row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)

    } ## end of if (thisinfo$alldone == FALSE)
    infodf$alldone[line.to.work.on]
}

## clean.names.for.bodymap("ERR030872_1.fastq")
clean.names.for.bodymap <- function(fastqname){
    gsub(pattern="(_1.fastq|_2.fastq)", replacement="", x =fastqname)
}

## Similar to exec.n.pipelines above, but now
##  for the case that you start from two unpacked fastqs
## Note that you may want to change the way it
##  makes a "nice name"; see clean.names.for.bodymap
##
exec.n.pipelines.starting.from.unpacked.fastqs <- function(start.of.run = TRUE, fastq1names, fastq1ids, fastq2names, fastq2ids, auth.token, groupname, grouplog, groupdir, tempdir, homedir, temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp="JSALZMAN/machete/machete-light", runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails=2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")){
    ## write to one log, probably just the grouplog:
    wlogone <- function(...){ write.logs(text=paste0(...,"\n"), logfilenames = grouplog, ttappend = TRUE, screen = TRUE) }
    n.tarfiles <- length(fastq1names)
    ## 
    ## where the big data frame is stored
    infofile = file.path(groupdir, "infofile.csv")
    ## where the matrix of failed task 0/1's is stored
    failfile = file.path(groupdir, "failfile.csv")
    ##
    ## start this for this function call, whether it's the
    ##  start of all the runs or just resuming
    start.time.this.function.call <- Sys.time()
    
    nicenames <- vector("character", n.tarfiles)
    for (tti in 1:n.tarfiles){
        nicenames[tti] <- clean.names.for.bodymap(fastq1names[tti])
    }
    ##
    ## do this if it's the first time you call the function for these
    ##  files:
    ##
    {
        if (start.of.run){
            start.time <- Sys.time()
            wlogone("The start time is ", start.time)
            wlogone("Note that this function assumes that files take forms like\n_R1.fastq or _1.fastq or _R1.fq or _1.fq or with .gz also")
            wlogone("There are ", n.tarfiles, " tar files.")
            wlogone("The forward ids are:\n\"", paste(fastq1ids, collapse = "\",\""), "\"", "\n\n")
            wlogone("The forward names are:\n\"", paste(fastq1names, collapse = "\",\""), "\"", "\n\n")
            wlogone("The reverse ids are:\n\"", paste(fastq2ids, collapse = "\",\""), "\"", "\n\n")
            wlogone("The reverse names are:\n\"", paste(fastq2names, collapse = "\",\""), "\"", "\n\n")
            ## ####################################
            ## initialize the two csv info files
            ## ####################################
            failmatrix <- matrix(0, nrow= n.tarfiles, ncol = 4)
            ## make these next things so that line with
            ##  initialization of data frame
            ##  has < 1024 characters in line 
            empty.char <- vector("character", length=n.tarfiles)
            bb <- vector("logical", length=n.tarfiles)
            infodf <- data.frame(id.file = empty.char, filename = empty.char, nicefname = nicenames, type.latest.task = vector("integer", length = n.tarfiles), id.latest.task = empty.char, status.latest.task = empty.char, alldone = bb, id.unpack = empty.char, id.trim = empty.char, id.knife = empty.char, id.machete = empty.char, name.unpack = empty.char, name.trim = empty.char, name.knife = empty.char, name.machete = empty.char, fastq.files.renamed = bb, fastq1.original = fastq1names, fastq2.original = fastq2names, fastq1.original.id=fastq1ids, fastq2.original.id=fastq2ids, fastq1.new = empty.char, fastq2.new = empty.char, trimmed.filename1.new = empty.char, trimmed.filename2.new = empty.char, id.new.trimmed.file1 = empty.char, id.new.trimmed.file2 = empty.char, error.in.fastq.file.names = bb, error.in.getting.machete.inputs = bb, download.attempted = bb, some.error.file.present= bb, yes.error.file.present = bb, stringsAsFactors = FALSE)
            ## some of these are just for clarity
            infodf$type.latest.task[] <- 0
            infodf$id.latest.task[] <- NA
            infodf$status.latest.task[] <- NA
            infodf$alldone[] <- FALSE
            infodf$id.unpack[] <- NA
            infodf$id.trim[] <- NA
            infodf$id.knife[] <- NA
            infodf$id.machete[] <- NA
            infodf$name.unpack[] <- NA
            infodf$name.trim[] <- NA
            infodf$name.knife[] <- NA
            infodf$name.machete[] <- NA
            infodf$fastq.files.renamed[] <- NA
            infodf$fastq1.new[] <- NA
            infodf$fastq2.new[] <- NA
            infodf$trimmed.filename1.new[] <- NA
            infodf$trimmed.filename2.new[] <- NA
            infodf$id.new.trimmed.file1[] <- NA
            infodf$id.new.trimmed.file2[] <- NA
            infodf$error.in.fastq.file.names[] <- NA
            infodf$error.in.getting.machete.inputs[] <- FALSE
            infodf$download.attempted[] <- FALSE
            infodf$some.error.file.present[] <- NA
            infodf$yes.error.file.present[] <- NA
            ## id.file, filename, nicefname, type.latest.task, id.latest.task, status.latest.task, alldone,
            ##    id.unpack, id.trim, id.knife, id.machete, download.attempted,
            ## Now write the files for the first time
            write.table(infodf, file = infofile, row.names = FALSE, col.names = TRUE, sep = ",", append=FALSE, quote=TRUE)
            write.table(failmatrix, file = failfile, row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)
            wlogone("Just stored initialized info in infofile at\n", infofile)
            wlogone("Just stored initialized fail info in failfile at\n", failfile)
            ## Create directories for each of the tar files
            for (tti in 1:n.tarfiles){
                thisfiledir = file.path(groupdir, nicenames[tti])
                if (!dir.exists(thisfiledir)){
                    dir.create(thisfiledir)
                }
            }
        }  ## end initializing you do if start.of.run is TRUE
        else {
            resumption.time <- Sys.time()
            wlogone("The time that this started resuming is ", resumption.time)
        }
    } ## end if/else for start.of.run == TRUE
    ## Read them in, as a check:
    ## infodf <- read.table(file = infofile, header = TRUE, sep = ",", stringsAsFactors = FALSE)
    ## failmatrix <- as.matrix(read.table(file = failfile, header = FALSE, sep = ",", stringsAsFactors = FALSE))
    ## colnames(failmatrix) <- NULL
    n.done <- 0
    vec.of.alldones <- vector("logical", length = n.tarfiles)
    ## for emphasis:
    vec.of.alldones[] <- FALSE
    stop.day.numeric <- as.numeric(as.Date(start.time.this.function.call) + timeout.days)
    notimeout <- TRUE
    line.to.work.on <- 1
    ## Now start while loop
    while (notimeout & (n.done < n.tarfiles)){
        Sys.sleep(seconds.of.wait.time.between.runs)

        ## process one line here
        ## first read in the infodf and see if
        ## everything is done for this line of the df
        infodf <- read.table(file = infofile, header = TRUE, sep = ",", stringsAsFactors = FALSE)
        {
            if (infodf$alldone[line.to.work.on] == FALSE){
                do.one.step.starting.from.unpacked.fastqs(line.to.work.on, infofile, failfile, auth.token, groupname, grouplog, groupdir, tempdir, homedir, temprdatadir, complete.or.appended, pipeowner, pipeproj, unpackapp, trimapp, knifeapp, macheteapp, runid.suffix, timeout.days, seconds.of.wait.time.between.runs, allowed.fails, infile.etc.info.file)
            }
            else {
                vec.of.alldones[line.to.work.on] <- TRUE
            }
        }
        n.done <- sum(vec.of.alldones)

        ## if line.to.work.on is at the end, go to line 1,
        ## otherwise go to the next line
        line.to.work.on <- ifelse(line.to.work.on == n.tarfiles, 1, line.to.work.on + 1)
        ##
        if (as.numeric(Sys.Date())>= stop.day.numeric){
            notimeout <- FALSE
        }
    } ## end while loop
    wlogone("\n\nExiting while loop at top level of exec.n.pipelines.\n\n")
    end.time <- Sys.time()
    wlogone("The time that this stopped is ", end.time)
}






