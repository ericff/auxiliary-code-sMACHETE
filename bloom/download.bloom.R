## download four files from a succesful bloom query postprocess task
##  of the app bt-postprocess-for-list-of-sample-ids

## IT MUST BE A URL/HREF, NOT JUST A FILE ID, SINCE IT GETS THE PROJECT
## NAME FROM THE URL/HREF

args <- commandArgs(trailingOnly = TRUE)
download.folder.summary.bt.results.and.name.to.files.matrices = args[1]
download.folder.matrices = args[2]
tempdir = args[3]
url.of.task = args[4]

## Now get project name from url which has the file.id in it

url.of.task.split <- strsplit(url.of.task,"/")[[1]]
index1 <- which(url.of.task.split=="u")
index2 <- which(url.of.task.split=="tasks")

if (!(index1 + 3 == index2)){
    stop(paste0("url.of.task\n", url.of.task, "\nis not in the expected format.\n"))
}

projectname <- paste0(url.of.task.split[index1+1], "/", url.of.task.split[index1+2])


## Remove all but last part of web address of task id:
{
if (length(grep(pattern="*http.*", x=url.of.task))> 0){
    task.id <- basename(url.of.task)
}
else {
    stop(paste0("ERROR: was expecting a url, not just a task id, for the value\n", url.of.task),"\n")
}
}


    
# install.packages("RJSONIO", repos = "http://cran.cnr.berkeley.edu/")
library(RJSONIO)

library(sevenbridges)

## should install xml2, I guess; I got an error about it,
##  not clear why though 
## install.packages("xml2", repos = "http://cran.cnr.berkeley.edu/")

library(xml2)

home.home <- TRUE


mydir <- ""
{
if (home.home){ 
    auth.token.filename <- paste0(mydir,"api/authtoken.txt")
    download.script.dir <- paste0(mydir,"api")
}
else {
    auth.token.filename <- paste0(mydir,"api/authtoken.txt")
    download.script.dir <- paste0(mydir,"api")
}
}


download.script <- file.path(download.script.dir, "download.one.file.url.last.R")

auth.token <-scan(file=auth.token.filename, what="character")



filelist.thistask = file.path(tempdir,paste("tempfile", task.id, ".json", sep=""))
call.curl = paste('curl -s -H "X-SBG-Auth-Token: ', auth.token , '" -H "content-type: application/json" -X GET "https://cgc-api.sbgenomics.com/v2/files?project=', projectname, '&origin.task=', task.id, '" -o ', filelist.thistask, sep="")
system(call.curl)
print(getwd())
print(filelist.thistask)
rawfilelist <- RJSONIO::fromJSON(filelist.thistask)
nfiles <- length(rawfilelist$items)
filenames <- sapply(rawfilelist$items, function(x) x[[3]])
hrefs <- sapply(rawfilelist$items, function(x) x[[1]])
non.matrix.file.indices <- grep(pattern = "(^name.to.files|^summary.bt)", x = filenames)
matrix.file.indices <- grep(pattern= "^matrix.name", x =filenames)



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


for (ii in non.matrix.file.indices){
    ## download.call <- paste("Rscript", download.script, download.folder.summary.bt.results.and.name.to.files.matrices, hrefs[ii])
    filename.full.path <- file.path(download.folder.summary.bt.results.and.name.to.files.matrices, filenames[ii])
    download.file.from.href(href= hrefs[ii], ttauth = auth.token, filename = filename.full.path, tempdir = tempdir)
}

for (jj in matrix.file.indices){
    filename.full.path <- file.path(download.folder.matrices, filenames[jj])
    download.file.from.href(href= hrefs[jj], ttauth = auth.token, filename = filename.full.path, tempdir = tempdir)
}










