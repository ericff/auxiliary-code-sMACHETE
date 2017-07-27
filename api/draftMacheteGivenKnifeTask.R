# Given a task id for a finished knife task and a dataset name,
#  SET UP A DRAFT of the machete


#   NOTE: it gets datasetname and runid from
#     the entries "inputted" into the knife
#     even though runid is actually allowed to be different from
#     the one for the knife 


# arguments:
# 0th is of course the name of the script with full path
# taskid, niceish.name, homedir, home.home, logfile1, logfile2, niceish.name.tar, macheteapp

scriptargs <- commandArgs(trailingOnly = TRUE)

taskid <- scriptargs[1]
niceish.name<- scriptargs[2]
homedir<- scriptargs[3]
home.home <- as.logical(scriptargs[4])
logfile1 <- scriptargs[5]
logfile2 <- scriptargs[6]
niceish.name.tar <- scriptargs[7]
macheteapp <- scriptargs[8]
rdata.file <- scriptargs[9]
    
print(scriptargs)


# for testing:
# taskid <- "0bb0a961-41fd-4617-a9d4-f2392445a04e"


source(file.path(homedir,"apidefs.R"))

logs.to.write <- c(logfile1, logfile2)

# Make authentication object
aa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")

# Make project object
# mm for project, because it is typically machete
pipeproj<- "JSALZMAN/machete"
mm <- aa$project(id=pipeproj)

# get filename and id of knife directory output from knife from task id
#   also get datasetname and runid that were inputted into it
#   even though runid could be different from the one for the knife
details.knife.task <- get.details.of.a.task.from.id(taskid = taskid, auth.token=auth.token, ttwdir=tempdir)

datasetname <- details.knife.task$inputs$datasetname
runid <- details.knife.task$inputs$runid

knifeoutputtarballs <- details.knife.task$outputs$outputtarballs
knifeoutputtarballnames <- sapply(knifeoutputtarballs, FUN=function(x){ x[2]})
index.knifeoutput.within.tarballs <- grep(pattern="*outputdir", knifeoutputtarballnames)
# Check that the index has length 1
if (length(index.knifeoutput.within.tarballs)!=1){
    errtext <- paste0("ERROR in draftMacheteGivenKnifeTask.R: length(index.knifeoutput.within.tarballs)!=1, but it should be 1.\n knifeoutputtarballs look like\n", paste(knifeoutputtarballs, collapse="\n"), "\nIndex is\n", paste(index.knifeoutput.within.tarballs, collapse = "\n"))
    if (!is.null(logs.to.write)){
        write.logs(text=errtext, logfilenames = logs.to.write, ttappend = TRUE)
    }
    stop(errtext) 
}

knifeoutputdetails <- details.knife.task$outputs$outputtarballs[[index.knifeoutput.within.tarballs]]
names(knifeoutputdetails) <- NULL
knifeoutputtarname <- knifeoutputdetails[2]
knifeoutputtarpath <- knifeoutputdetails[1]

# get project and project owner from task
projname <- details.knife.task$project


# get names and ids of infile files, output list of Files object
out.try <- try(infile.array <- get.infile.names.and.ids(projname=projname, auth.token=auth.token, tempdir=tempdir, max.iterations=max.iterations))

## if it doesn't work, try again:
if (class(out.try)=="try-error"){
    ## wlog("\n\nERROR:", out.try[1])
    infile.array <- get.infile.names.and.ids(projname=projname, auth.token=auth.token, tempdir=tempdir, max.iterations=max.iterations)
}



# USES files HG19exons.tar.gz and
#   toyIndelIndices.tar.gz; could change code if needed
# gets file info from the project
out.try.two <- try(out.project.list <- list.all.files.project(projname=projname, max.iterations=max.iterations,  auth.token=auth.token, ttwdir=wdir, tempdir=tempdir))
## if it doesn't work, try again:
if (class(out.try.two)=="try-error"){
    ## wlog("\n\nERROR:", out.try.two[1])
    out.project.list <- list.all.files.project(projname=projname, max.iterations=max.iterations,  auth.token=auth.token, ttwdir=wdir, tempdir=tempdir)
}
project.filenames <- out.project.list$filenames
project.fileids <- out.project.list$fileids

# 
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

# desc.machete.task <- paste("Machete for ", niceish.name, ", from tar file", niceish.name.tar, ", drafted at ", nicetime.machete.task, sep="")

# name.machete.task <-  paste("Machete for ", niceish.name, ", drafted at ", nicetime.machete.task, sep="")
name.machete.task <-  paste("Machete for ", niceish.name, ", from tar file", niceish.name.tar, ", drafted at ", nicetime.machete.task, sep="")

desc.machete.task <- name.machete.task

inputs.machete <- list(inputarray=infile.array, knifeoutputtarball = Files(id= knifeoutputtarpath, name=knifeoutputtarname), exons= exons.Files.object, indel_indices=indelindices.Files.object, datasetname=datasetname, runid=runid)

machete.task <- mm$task_add(name = name.machete.task, description = desc.machete.task,  app = macheteapp, inputs = inputs.machete)


write.logs(text=paste0("Drafting ", desc.machete.task,"\nId is:\n", machete.task$id), logfilenames = logs.to.write, ttappend=TRUE, screen=TRUE)

# Output name of saved .RData file
save(machete.task, inputs.machete, file = rdata.file)



# list(machete.task.status=machete.task.status, machete.task=machete.task)
# machete.task$id
rdata.file



