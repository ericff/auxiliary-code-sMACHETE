args <- commandArgs(trailingOnly = TRUE)
download.folder = args[1]
## file with just authorization token in it:
auth.token.filename = args[2]
projectname = args[3]
## this should be the full url for the task
task.url = args[4]


# install.packages("RJSONIO", repos = "http://cran.cnr.berkeley.edu/")
library(RJSONIO)
library(sevenbridges)
## should install xml2, I guess; I got an error about it,
##  not clear why though 
## install.packages("xml2", repos = "http://cran.cnr.berkeley.edu/")
library(xml2)

auth.token <-scan(file=auth.token.filename, what="character")

tempdir=getwd()

filelist.thistask = file.path(tempdir,"tempfilefordownload.json")

task.id <- basename(task.url)

call.curl = paste('curl -s -H "X-SBG-Auth-Token: ', auth.token , '" -H "content-type: application/json" -X GET "https://cgc-api.sbgenomics.com/v2/files?project=', projectname, '&origin.task=', task.id, '" -o ', filelist.thistask, sep="")
system(call.curl)

rawfilelist <- RJSONIO::fromJSON(filelist.thistask)
hrefs <- sapply(rawfilelist$items, function(x) x[[1]])

system(paste("rm", filelist.thistask))

file.ids <- basename(hrefs)
    
ttaa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")
## mm for project, because it was typically machete
## ttmm <- ttaa$project(id=projectname)


## from https://github.com/sbg/sevenbridges-r/blob/c4986238938440dddc3f30831705f13097913d93/vignettes/api.Rmd
for (ii in 1:length(hrefs)){
    print(paste("Downloading file", ii, "of", length(hrefs),"\n"))
    ttaa$project(id=projectname)$file(id = file.ids[ii])$download(download.folder)
}











