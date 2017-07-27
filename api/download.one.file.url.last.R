## same as download.one.file.R but url goes last (i.e. 2nd) to make it easier
## use this with Rscript to get a file with some href
## and download to a particular spot
## IT MUST BE A URL/HREF, NOT JUST A FILE ID, SINCE IT GETS THE PROJECT
## NAME FROM THE URL/HREF
## to download with project name, see download.one.file.using.project.name.R

## This should now get the project from the file id

## example syntax:

## Rscript download.one.file.url.last.R "/my/dir/downloadfolder" "https://cgc.sbgenomics.com/u/ericfg/bloomtree-pancreatic/files/5800123ee4b0cc144d20bc1a/"

args <- commandArgs(trailingOnly = TRUE)
download.folder = args[1]
url.with.file.id = args[2]

## directory with file with authorization token in it:
mydir <- "/my/dir"

## Now get project name from url which has the file.id in it

url.with.file.id.split <- strsplit(url.with.file.id,"/")[[1]]
index1 <- which(url.with.file.id.split=="u")
index2 <- which(url.with.file.id.split=="files")

if (!(index1 + 3 == index2)){
    stop(paste0("url.with.file.id\n", url.with.file.id, "\nis not in the expected format.\n"))
}

projectname <- paste0(url.with.file.id.split[index1+1], "/", url.with.file.id.split[index1+2])


## Remove all but last part of web address of file id:
{
if (length(grep(pattern="*http.*", x=url.with.file.id))> 0){
    file.id <- basename(url.with.file.id)
}
else {
    stop(paste0("ERROR: was expecting a url, not just a file id, for the value\n", url.with.file.id),"\n")
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

{
if (home.home){ 
    auth.token.filename <- file.path(mydir,"authorizationtoken.txt")
}
else {
    auth.token.filename <- file.path(mydir,"authorizationtoken.txt")
}
}






auth.token <-scan(file=auth.token.filename, what="character")



ttaa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")
## mm for project, because it was typically machete
## ttmm <- ttaa$project(id=projectname)

## from https://github.com/sbg/sevenbridges-r/blob/c4986238938440dddc3f30831705f13097913d93/vignettes/api.Rmd
ttaa$project(id=projectname)$file(id = file.id)$download(download.folder)


