# use with system(, wait=FALSE, intern=TRUE)

# pipeline.one.tarfile(intarname, intarpath, auth.token, groupname, grouplog, groupcsv, groupdir, tempdir, groupfailedtaskslog, mastercsv, homedir, home.home, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp="JSALZMAN/machete/machete-for-work", runid.suffix="", seconds.between.checks=60, timeout.days=4, temprdatadir=NULL)

scriptargs <- commandArgs(trailingOnly = TRUE)

intarname <- scriptargs[1]
intarpath <- scriptargs[2]
auth.token <- scriptargs[3]
groupname  <- scriptargs[4]
grouplog <- scriptargs[5]
groupcsv <- scriptargs[6]
groupdir <- scriptargs[7]
tempdir <- scriptargs[8]
groupfailedtaskslog <- scriptargs[9]
mastercsv <- scriptargs[10]
homedir <- scriptargs[11]
home.home <- as.logical(scriptargs[12])
complete.or.appended <- scriptargs[13]
pipeowner  <- scriptargs[14]
pipeproj  <- scriptargs[15]
unpackapp <- scriptargs[16]
trimapp <- scriptargs[17]
knifeapp <- scriptargs[18]
macheteapp <- scriptargs[19]
runid.suffix <- scriptargs[20]
seconds.between.checks <- as.numeric(scriptargs[21])
timeout.days <- as.numeric(scriptargs[22])
temprdatadir <- scriptargs[23]

source(file.path(homedir,"apidefs.R"))

print(scriptargs)

if (temprdatadir=="null"){
    temprdatadir <- NULL
}

# do this just in case it's not already created
# if groupdir doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}


pipeline.one.tarfile(intarname=intarname, intarpath=intarpath, auth.token=auth.token, groupname=groupname, grouplog=grouplog, groupcsv=groupcsv, groupdir=groupdir, tempdir=tempdir, groupfailedtaskslog=groupfailedtaskslog, mastercsv=mastercsv, homedir= homedir, home.home=home.home, complete.or.appended=complete.or.appended, pipeowner=pipeowner, pipeproj=pipeproj, unpackapp=unpackapp, trimapp=trimapp, knifeapp=knifeapp, macheteapp=macheteapp, runid.suffix=runid.suffix, seconds.between.checks=seconds.between.checks, timeout.days=timeout.days, temprdatadir=temprdatadir)










