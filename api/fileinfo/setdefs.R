

wdir = homedir


# make sure there is a directory homedir
if (!dir.exists(wdir)){
    dir.create(wdir)
}

# make sure there is a directory tempdir
if (!dir.exists(tempdir)){
    dir.create(tempdir)
}

setwd(dir=wdir)

mydir <- "/my/dir"
{
if (home.home){ 
    auth.token.filename <- file.path(mydir, "api/authtoken.txt")
}
else {
    auth.token.filename <- file.path(mydir, "api/authtoken.txt")
}
}


auth.token <-scan(file=auth.token.filename, what="character")



max.iterations <- 10000

files.per.download <- 100
library(RJSONIO)


# gets all files, NOT just one for each case; you have to do that later

# NEXT ONES HAVE disease variable, but I took that out later; not
#   relevant for this function
# out.gbm <- get.files.with.tumor.or.normal(disease="Glioblastoma Multiforme", tempdir, homedir, query.template.file="gbmqueryjul19.json", auth.token,  tt.files.per.download= files.per.download, sample.type="Primary Tumor", output.csv = "gbm.july19.query.tumor.csv")
# disease="Glioblastoma Multiforme";  query.template.file="gbmqueryjul19.json";  tt.files.per.download= files.per.download; sample.type="Primary Tumor"; output.csv = "gbm.july19.query.tumor.csv"
# ASSUMES template file is in tempdir
#  and that output.csv should be a file in homedir

get.files.with.tumor.or.normal <- function(tempdir, homedir, query.template.file, auth.token, tt.files.per.download, sample.type, output.csv){
    currentdir <- getwd()
    setwd(tempdir)
    # read in template file, will edit its offset value
    tt.template <- scan(file= query.template.file, what="character", sep="\n")
    # 
    # which line of template file has offset in it?
    #
    offset.line.number <- grep(pattern="offset", x=tt.template)
    if (length(offset.line.number)!=1){
        stop(paste0("ERROR in file ", query.template.file, ": there should be exactly one line with the word offset in it.\n"))
    }
    # which line of template file has hasSampleType in it?
    #
    sample.type.line.number <- grep(pattern="hasSampleType", x=tt.template)
    if (length(sample.type.line.number)!=1){
        stop(paste0("ERROR in file ", query.template.file, ": there should be exactly one line with the word hasSampleType in it.\n"))
    }
    # get count of number of files
    system(paste0('curl -s -H "X-SBG-Auth-Token: ', auth.token, ' " -H "content-type: application/json" -X POST "https://cgc-datasets-api.sbgenomics.com/datasets/tcga/v0/query/total" --data @', query.template.file,' > test35.json'))
    tt.nfiles <- as.numeric(fromJSON("test35.json"))
    tt.files <- vector("list", length=0)
    n.loops <- ceiling(tt.nfiles/tt.files.per.download)
    for (tti in 1:n.loops){
        cat("Working on loop ", tti , " of ", n.loops, "\n")
        this.offset <- tt.files.per.download*(tti-1)
        # make file with offset in it
        tt.changed.template <- tt.template
        tt.changed.template[offset.line.number] <- paste0("    \"offset\": ", this.offset)
        tt.changed.template[sample.type.line.number] <- paste0("\"hasSampleType\": \"", sample.type, "\"")
        writeLines(tt.changed.template, con = "test58.json", sep = "\n")
        system(paste0('curl -s -H "X-SBG-Auth-Token: ', auth.token, ' " -H "content-type: application/json" -X POST "https://cgc-datasets-api.sbgenomics.com/datasets/tcga/v0/query" --data @test58.json > test63.json'))
        these.files.raw <- fromJSON("test63.json")
        tt.files <- append(tt.files, these.files.raw$`_embedded`$files)
     
    }
    ids.files <- sapply(tt.files, FUN= function(x){ x$id})
    names.files <- sapply(tt.files, FUN= function(x){ x$label})
    ids.cases <- vector("character", length=0)
    # Get the cases for these file
    for (ttj in 1:length(ids.files)){
        if (ttj %% 10== 0){
            cat("Working on loop ", ttj, " of ", length(ids.files),"\n")
        }
        system(paste0('curl -s -H "X-SBG-Auth-Token: ', auth.token, ' " -H "content-type: application/json" -X GET "https://cgc-datasets-api.sbgenomics.com/datasets/tcga/v0/files/', ids.files[ttj], '/cases" > test35.json'))
        tt.case.info <- fromJSON("test35.json")
        ids.cases <- append(ids.cases, tt.case.info$`_embedded`$cases[[1]]$id)
        if (length(tt.case.info$`_embedded`$cases)>1){
            stop(paste0("ERROR: length(tt.case.info$`_embedded`$cases)>1 for file id\n", ids.files[ttj]))
        }
    }
    if (length(ids.cases)!= length(ids.files)){
        stop(paste0("ERROR: length(ids.cases)!= length(ids.files), i.e.", length(ids.cases), "!=", length(ids.files)))
    }
    files.df <- data.frame(ids.files, names.files, ids.cases)
    write.table(files.df, file = file.path(homedir, output.csv),   row.names = FALSE, col.names = TRUE, sep = ",", append=FALSE, quote=TRUE)    
    setwd(currentdir)
    list(tt.files=tt.files,ids.files=ids.files, names.files=names.files, ids.cases=ids.cases)
}

## added dec 19 2016
get.files.with.tumor.or.normal.and.return.NA.if.none <- function(tempdir, homedir, query.template.file, auth.token, tt.files.per.download, sample.type, output.csv){
    currentdir <- getwd()
    setwd(tempdir)
    # read in template file, will edit its offset value
    tt.template <- scan(file= query.template.file, what="character", sep="\n")
    # 
    # which line of template file has offset in it?
    #
    offset.line.number <- grep(pattern="offset", x=tt.template)
    if (length(offset.line.number)!=1){
        stop(paste0("ERROR in file ", query.template.file, ": there should be exactly one line with the word offset in it.\n"))
    }
    # which line of template file has hasSampleType in it?
    #
    sample.type.line.number <- grep(pattern="hasSampleType", x=tt.template)
    if (length(sample.type.line.number)!=1){
        stop(paste0("ERROR in file ", query.template.file, ": there should be exactly one line with the word hasSampleType in it.\n"))
    }
    # get count of number of files
    system(paste0('curl -s -H "X-SBG-Auth-Token: ', auth.token, ' " -H "content-type: application/json" -X POST "https://cgc-datasets-api.sbgenomics.com/datasets/tcga/v0/query/total" --data @', query.template.file,' > test35.json'))
    tt.nfiles <- as.numeric(fromJSON("test35.json"))
    tt.files <- vector("list", length=0)
    n.loops <- ceiling(tt.nfiles/tt.files.per.download)
    for (tti in 1:n.loops){
        cat("Working on loop ", tti , " of ", n.loops, "\n")
        this.offset <- tt.files.per.download*(tti-1)
        # make file with offset in it
        tt.changed.template <- tt.template
        tt.changed.template[offset.line.number] <- paste0("    \"offset\": ", this.offset)
        tt.changed.template[sample.type.line.number] <- paste0("\"hasSampleType\": \"", sample.type, "\"")
        writeLines(tt.changed.template, con = "test58.json", sep = "\n")
        system(paste0('curl -s -H "X-SBG-Auth-Token: ', auth.token, ' " -H "content-type: application/json" -X POST "https://cgc-datasets-api.sbgenomics.com/datasets/tcga/v0/query" --data @test58.json > test63.json'))
        these.files.raw <- fromJSON("test63.json")
        tt.files <- append(tt.files, these.files.raw$`_embedded`$files)
     
    }
    if (length(tt.files)>0){
        ids.files <- sapply(tt.files, FUN= function(x){ x$id})
        names.files <- sapply(tt.files, FUN= function(x){ x$label})
        ids.cases <- vector("character", length=0)
        ## Get the cases for these file
        for (ttj in 1:length(ids.files)){
            if (ttj %% 10== 0){
                cat("Working on loop ", ttj, " of ", length(ids.files),"\n")
            }
            system(paste0('curl -s -H "X-SBG-Auth-Token: ', auth.token, ' " -H "content-type: application/json" -X GET "https://cgc-datasets-api.sbgenomics.com/datasets/tcga/v0/files/', ids.files[ttj], '/cases" > test35.json'))
            tt.case.info <- fromJSON("test35.json")
            ids.cases <- append(ids.cases, tt.case.info$`_embedded`$cases[[1]]$id)
            if (length(tt.case.info$`_embedded`$cases)>1){
                stop(paste0("ERROR: length(tt.case.info$`_embedded`$cases)>1 for file id\n", ids.files[ttj]))
            }
        }
        if (length(ids.cases)!= length(ids.files)){
            stop(paste0("ERROR: length(ids.cases)!= length(ids.files), i.e.", length(ids.cases), "!=", length(ids.files)))
        }
        files.df <- data.frame(ids.files, names.files, ids.cases)
        write.table(files.df, file = file.path(homedir, output.csv),   row.names = FALSE, col.names = TRUE, sep = ",", append=FALSE, quote=TRUE)
        n.files <- length(ids.files)
    } else {
        n.files <- 0
        ids.files <- NULL
        names.files <- NULL
        ids.cases <- vector("character", length=0)
    }
    setwd(currentdir)
    list(tt.files=tt.files,ids.files=ids.files, names.files=names.files, ids.cases=ids.cases, n.files=n.files)
}


## write a tumor template file for use with get.files.with.tumor.or.normal
## of course, could have done this in that function, but that
## is already written and don't want to change it
## ONLY FOR tumors, NOT FOR normals, DOESN'T work for "primary
##  blood ..." or for "recurrent tumor"
## NOT for any of these:
## Primary Blood Derived Cancer - Peripheral Blood
## Additional - New Primary
## Additional Metastatic
## Blood Derived Normal
## Bone Marrow Normal
## Buccal Cell Normal
## Metastatic
## Recurrent Tumor
## Solid Tissue Normal
## Note that there are just 2 sample for Additional Metastatic, and
## it's for skin cancer
write.different.disease.to.tumor.template.file <- function(shortname, tempdir, longname, query.template.file=file.path(tempdir, "tumorquery.json")){
    currentdir <- getwd()
    setwd(tempdir)
    out.template.file <- file.path(tempdir, paste0(shortname,".tumorquery.json"))
    ## read in template file, will edit its disease value from zzzz
    tt.template <- scan(file= query.template.file, what="character", sep="\n")
    tt.changed.template <- gsub(pattern="zzzz", replacement = longname, x=tt.template)
    writeLines(tt.changed.template, con = out.template.file, sep="\n")
    setwd(currentdir)
}

# df.query = lung.all.tumors.df
# take data frame read in from csv outputted by
#  get.files.with.tumor.or.normal
#  and pick one file for each case
choose.one.file.for.each.case <- function(df.query){
    tt.unique.cases <- unique(df.query$ids.cases)
    n.unique.cases <- length(tt.unique.cases)
    new.df.query <- data.frame(ids.files= vector("character", length=0), names.files= vector("character", length=0), ids.cases= vector("character", length=0))
    for (tti in 1:n.unique.cases){
        # get df of files with this case
        subdf <- df.query[df.query$ids.cases== tt.unique.cases[tti],]
        if (dim(subdf)[1]==0){
            stop(paste("ERROR: no rows for case ", tt.unique.cases[tti]))
        }
        # else if there is exactly one row:
        else if (dim(subdf)[1]==1){
            new.df.query <- rbind(new.df.query, subdf)
        }
        else {
            new.df.query <- rbind(new.df.query, subdf[1,])
        }
    }
    new.df.query
}



# df.query = lung.all.tumors.df
# take data frame read in from csv outputted by
#  get.files.with.tumor.or.normal
#  and pick one file for each case
## DIFFERS from choose.one.file.for.each.case in that
## if given a choice, it will choose the one
##  already made when choosing one sample for each case
##  when running machete
## ALSO will check if choices were already made in datasetapi.R
##   and a filename.mostrecent is given as an input 
choose.one.file.for.each.case.using.the.choice.already.made.when.choosing.for.machete.runs <- function(df.query, allfilenames, filename.mostrecent=NULL){
    indices.tumors.downloaded.by.today <- sort(which(df.query$names.files %in% allfilenames))
    print(paste0("length(indices.tumors.downloaded.by.today) is ", length(indices.tumors.downloaded.by.today)))
    ## 
    ## now get the cases for the runs pre today
    downloaded.by.today.cases <- df.query$ids.cases[indices.tumors.downloaded.by.today]
    tt.unique.cases <- unique(df.query$ids.cases)
    n.unique.cases <- length(tt.unique.cases)
    new.df.query <- data.frame(ids.files= vector("character", length=0), names.files= vector("character", length=0), ids.cases= vector("character", length=0))
    if (!is.null(filename.mostrecent)){
        mostrecent.df <- read.table(filename.mostrecent, sep=",", header = FALSE, col.names = c("sb.id", "filename", "case"), stringsAsFactors = FALSE)
    }
    for (tti in 1:n.unique.cases){
        pick.first.one <- TRUE
        if (tt.unique.cases[tti] %in% downloaded.by.today.cases){
            subdf.first.cut <- df.query[(df.query$ids.cases== tt.unique.cases[tti]),]
            subdf <- subdf.first.cut[(subdf.first.cut$names.files %in% allfilenames),]
            stopifnot(dim(subdf)[1]==1)
            new.df.query <- rbind(new.df.query, subdf)
            pick.first.one <- FALSE
        }
        else if (!is.null(filename.mostrecent)){
            if (tt.unique.cases[tti] %in% mostrecent.df$case){
                subdf.first.cut <- df.query[(df.query$ids.cases== tt.unique.cases[tti]),]
                subdf <- subdf.first.cut[(subdf.first.cut$names.files %in% mostrecent.df$filename),]
                stopifnot(dim(subdf)[1]==1)
                new.df.query <- rbind(new.df.query, subdf)
                pick.first.one <- FALSE
            }
        }
        ## Do next if test, no matter what, because you can't test
        ##  if it's in the filename.mostrecent if it doesn't exist
        ##  only pick the first one if you haven't already
        if (pick.first.one) {
            ## get df of files with this case
            subdf <- df.query[df.query$ids.cases== tt.unique.cases[tti],]
            if (dim(subdf)[1]==0){
                stop(paste("ERROR: no rows for case ", tt.unique.cases[tti]))
            }
            ## else if there is exactly one row:
            else if (dim(subdf)[1]==1){
                new.df.query <- rbind(new.df.query, subdf)
            }
            else {
                new.df.query <- rbind(new.df.query, subdf[1,])
            }
        }
    }
    new.df.query
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


# get.one.fileid.from.filename(filename="UNCID_2179117.260fce5f-8aea-4c0b-868a-ca514b130dff.130325_UNC16-SN851_0231_BC20VNACXX_2_ACAGTG.tar.gz", allnames=allfilenames, allids=allfileids)
get.one.fileid.from.filename <- function(filename, allnames, allids){
    tfvec <- (allnames == filename)
    { # start if/else
    if (any(is.na(tfvec))){
        stop(paste0("Error: filename ", filename, " is giving NAs\n"))
    }
    else if (sum(tfvec)>=2){
        stop(paste0("Error: filename ", filename, " is giving more than two matches\n"))
    }
    else if (sum(tfvec)==0){
        stop(paste0("Error: filename ", filename, " is giving 0 matches\n"))
    }
    }
    allids[which(tfvec==1)]
}

# get.fileids.from.filenames(filenames=c("UNCID_2179117.260fce5f-8aea-4c0b-868a-ca514b130dff.130325_UNC16-SN851_0231_BC20VNACXX_2_ACAGTG.tar.gz", "UNCID_2641218.918a606c-3b19-4292-862c-f8437d00ab00.140721_UNC15-SN850_0379_AC4V28ACXX_8_TGACCA.tar.gz"), allnames = allfilenames, allids = allfileids)
# vectorized version of the above
get.fileids.from.filenames <- function(filenames, allnames, allids){
	sapply(seq(along=filenames),FUN =function(i) get.one.fileid.from.filename(filenames[i],allnames=allnames, allids=allids))
}

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
        #  to big list of file names:
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

# out.copy <- copy.file.with.sb.id.to.project(sbid="564a57f2e4b0298dd2cb0590", proj.name="JSALZMAN/machete", auth.token=auth.token, tempdir=tempdir)
# returns new file id, i.e. id in project
    # CHECK FOR SOMETHING WITH THAT NAME FIRST?
# FOR NOW, CHECK MANUALLY
copy.file.with.sb.id.to.project <- function(sbid, proj.name, auth.token, tempdir){
    currentdir <- getwd()
    setwd(tempdir)
    system(paste0("curl --data '{\"project\": \"" , proj.name, "\"}'", ' -s -H "X-SBG-Auth-Token: ', auth.token, ' " -H "content-type: application/json" -X POST "https://cgc-api.sbgenomics.com/v2/files/',sbid, '/actions/copy" > test93.json'))
    out.file.info <- fromJSON("test93.json")
    file.name <- out.file.info$name
    file.id <- out.file.info$id
    # for next thing, use as.list because in one case,
    #  when age at diagnosis was missing, it converted it to
    #  a character vector and then it gave an error when I asked
    #  for out.file.info$metadata$experimental_strategy
    # problem with UNCID_2197473
    # 564a5a07e4b0298dd2cbb5b0
    # test93weird.json
    # missing age at diagnosis for this one
    # Looking here it's listed with a blank:
    # https://cgc.sbgenomics.com/u/JSALZMAN/machete/files/564a5a07e4b0298dd2cbb5b0/
    file.metadata <- as.list(out.file.info$metadata)
    setwd(currentdir)
    # list(file.id=file.id, file.name=file.name, exp.strategy = out.file.info$metadata$experimental_strategy, data.subtype=out.file.info$metadata$data_subtype, disease.type =out.file.info$metadata$disease_type)
    list(file.id=file.id, file.name=file.name, exp.strategy = file.metadata$experimental_strategy, data.subtype=file.metadata$data_subtype, disease.type =file.metadata$disease_type)
}

copy.many.files.with.sb.id.to.project <- function(vec.sbids, proj.name, auth.token, tempdir){
    files.ids <- vector("character", length = 0)
    files.names <- vector("character", length = 0)
    exp.strategies <- vector("character", length = 0)
    data.subtypes <- vector("character", length = 0)
    disease.types <- vector("character", length = 0)
    for (tti in 1:length(vec.sbids)){
        out.copy <- copy.file.with.sb.id.to.project(sbid=vec.sbids[tti], proj.name=proj.name, auth.token=auth.token, tempdir=tempdir)
        files.ids <- append(files.ids, out.copy$file.id) 
        files.names <- append(files.names, out.copy$file.name)
        exp.strategies <- append(exp.strategies, out.copy$exp.strategy)
        data.subtypes <- append(data.subtypes, out.copy$data.subtype)
        disease.types <- append(disease.types, out.copy$disease.type)
        cat("Just copied file", out.copy$file.name, "\n")
    }
    list(files.ids=files.ids, files.names=files.names, exp.strategies=exp.strategies, data.subtypes= data.subtypes, disease.types=disease.types)
}


# for printing out vectors of file ids in form c("","") for easy
#  copying and pasting to use them later or in other files, e.g.
#  to transfer from datasetapi.R to runapi.R
print.nice.ids.vector <- function(ttvec){
    noquote(paste0("c(\"", paste(ttvec, collapse = "\", \""), "\")"))
}

# for printing out vectors of file ids in form c("","") for easy
#  copying and pasting to use them later or in other files, e.g.
#  to transfer from datasetapi.R to runapi.R
print.nice.ids.vector.within.function <- function(ttvec){
    cat(noquote(paste0("c(\"", paste(ttvec, collapse = "\", \""), "\")\n")))
}


# get.file.with.aliquot.id(aliquot.id="TCGA-CH-5739-01A-11R-1580-07", tempdir, homedir, query.template.file="aliquotquery.json", auth.token)
# aliquot.id="TCGA-CH-5739-01A-11R-1580-07"; query.template.file="aliquotquery.json"

# FOR NOW, ONLY DOES TUMOR, NOT NORMAL
# ASSUMES THERE IS AT MOST 1 FILE WITH THIS ALIQUOT ID; FAILS IF NOT
get.file.with.aliquot.id <- function(aliquot.id, tempdir, homedir, query.template.file, auth.token){
    currentdir <- getwd()
    setwd(tempdir)
    # read in template file, will edit its offset value
    tt.template <- scan(file= query.template.file, what="character", sep="\n")
    # 
    # which line of template file has zzzz in it?
    #
    zzzz.line.number <- grep(pattern="zzzz", x=tt.template)
    if (length(zzzz.line.number)!=1){
        stop(paste0("ERROR in file ", query.template.file, ": there should be exactly one line with the string zzzz in it.\n"))
    }
    tt.changed.template <- tt.template
    tt.changed.template[zzzz.line.number] <- gsub(pattern = "zzzz", replacement = aliquot.id, x = tt.changed.template[zzzz.line.number])
    writeLines(tt.changed.template, con = "test58.json", sep = "\n")
    # 
    ## get count of number of files
    system(paste0('curl -s -H "X-SBG-Auth-Token: ', auth.token, ' " -H "content-type: application/json" -X POST "https://cgc-datasets-api.sbgenomics.com/datasets/tcga/v0/query/total" --data @test58.json > test35.json'))
    tt.nfiles <- as.numeric(fromJSON("test35.json"))
    stopifnot(tt.nfiles<=1)
    ## initialize data frames, particularly in case tt.nfiles = 0
    ids.files <- vector("character", length=0)
    names.files <- vector("character", length=0)
    ids.cases <- vector("character", length=0)
    { # begin if/else
    if (tt.nfiles >0){
        system(paste0('curl -s -H "X-SBG-Auth-Token: ', auth.token, ' " -H "content-type: application/json" -X POST "https://cgc-datasets-api.sbgenomics.com/datasets/tcga/v0/query" --data @test58.json > test63.json'))
        tt.files.raw <- fromJSON("test63.json")
        tt.files <- tt.files.raw$`_embedded`$files
        ids.files <- sapply(tt.files, FUN= function(x){ x$id})
        names.files <- sapply(tt.files, FUN= function(x){ x$label})
        ## Get the cases for this file
        system(paste0('curl -s -H "X-SBG-Auth-Token: ', auth.token, ' " -H "content-type: application/json" -X GET "https://cgc-datasets-api.sbgenomics.com/datasets/tcga/v0/files/', ids.files[1], '/cases" > test35.json'))
        tt.case.info <- fromJSON("test35.json")
        ids.cases <- append(ids.cases, tt.case.info$`_embedded`$cases[[1]]$id)
        if (length(tt.case.info$`_embedded`$cases)>1){
            stop(paste0("ERROR: length(tt.case.info$`_embedded`$cases)>1 for file id\n", ids.files[1]))
        }
        if (length(ids.cases)!= length(ids.files)){
            stop(paste0("ERROR: length(ids.cases)!= length(ids.files), i.e.", length(ids.cases), "!=", length(ids.files)))
        }
    }
    else {
        # put in empty values for all these vectors, actually should do
        #  it first
    }
} # end if/e
    files.df <- data.frame(ids.files=ids.files, names.files=names.files, ids.cases=ids.cases)
    setwd(currentdir)
    list(files.df=files.df, tt.files=tt.files)
}

## todaydate <- "sep9"; shortname <- "glioma"; longname <- "Brain Lower Grade Glioma"; n.use.this.many.files.now <- 22; random.seed=19651

##  get list of all files
##  put sb ids in random order, and then save to file
##  date the file and save copy but also keep a "most recent" version
##  don't worry about matched normals at all
## 
## use this in datasetapi.R to get files for a particular cancer
##  THAT THERE ARE NOT ALREADY FILES FOR IN THE PROJECT
##  do other cases manually; it will give error if there
##  are already in the project
##
## ASSUMES you've already gotten a vector allfilenames
##  of all file names in the project
## Also ASSUMES that the project is machete, although that
##  could easily be changed.
## 
## get.new.tar.files
##
get.new.tar.files <- function(todaydate, shortname, longname, n.use.this.many.files.now, tempdir, homedir, auth.token, files.per.download, allfilenames, random.seed=19651){
    ## first one is the one with zzzz where the disease will go
    template.for.query.template.file <- file.path(tempdir, "tumorquery.json")
    query.template.file.for.particular.disease <- file.path(tempdir, paste0(shortname,".tumorquery.json"))
    outcsv <- paste0(shortname, todaydate, "query.tumor.csv")
    write.different.disease.to.tumor.template.file(shortname, tempdir, longname, query.template.file=template.for.query.template.file)
    out.tumors <- get.files.with.tumor.or.normal(tempdir, homedir, query.template.file=query.template.file.for.particular.disease, auth.token,  tt.files.per.download= files.per.download, sample.type="Primary Tumor", output.csv = outcsv)
    cat("Number of files for ", shortname, " (", longname, ") is ", length(out.tumors$ids.files), "\nNote that this could include multiple files for one case, so this might be larger than the number of cases.\n", sep="")
    ## get indices of out.tumors which
    ##  are in allfilenames, i.e. which we already downloaded

    ## This should have length 0 for this function; if not, give error
    indices.tumors.downloaded.by.today <- sort(which(out.tumors$names.files %in% allfilenames))
    length(indices.tumors.downloaded.by.today)
    ##
    if (length(indices.tumors.downloaded.by.today)>0){
        stop(paste0("ERROR ERROR: there are some tumors downloaded before today and there should not be for this function; an example name is \n", out.tumors$names.files[1]))
    }
    ## READ in results, just to get them as a nice data frame
    all.tumors.df <- read.table(file=file.path(homedir, outcsv), header=TRUE, sep =",", stringsAsFactors=FALSE) 
    dim(all.tumors.df)
    ## 

    ## Now choose a unique file for each case:
    unique.tumors.df <- choose.one.file.for.each.case(all.tumors.df)

    n.total.cases <- length(unique.tumors.df$ids.cases)
    ##
    print(paste0("Number of unique files- one for each case- for ", shortname, " (", longname, ") is ", length(out.tumors$ids.files)))
    ## Now put these in a random order
    ## Then can go back to get them out of a csv file
    set.seed(random.seed)
    random.ordering.of.indices <- sample(n.total.cases, size = n.total.cases)

    sb.ids.tumors.with.random.ordering <- unique.tumors.df$ids.files[random.ordering.of.indices]
    cases.tumors.with.random.ordering <- unique.tumors.df$ids.cases[random.ordering.of.indices]
    names.tumors.with.random.ordering <- unique.tumors.df$names.files[random.ordering.of.indices]
    df.tumors.with.random.ordering <- data.frame(sb.ids.tumors.with.random.ordering, names.tumors.with.random.ordering, cases.tumors.with.random.ordering)

    print(paste0("Randomly ordering files now and then selecting the first ", n.use.this.many.files.now, "."))

    use.these.now.ids <- sb.ids.tumors.with.random.ordering[1:n.use.this.many.files.now]
    use.these.now.names <- names.tumors.with.random.ordering[1:n.use.this.many.files.now]

    ## NOT using these right now:
    ## write to file
    ## both one with current date, and one that's most recent

    filename.pre.downloads.with.date = file.path(homedir,paste0(shortname, ".files.not.downloaded.before.", todaydate, ".csv"))
    filename.downloads.with.date = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.as.of.", todaydate, ".csv"))
    filename.mostrecent = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.most.recent.csv"))

    cat("Writing files:\n", filename.pre.downloads.with.date, "\n", filename.downloads.with.date, "\n", filename.mostrecent, "\n") 
    
    n.tumors.with.random.ordering <- dim(df.tumors.with.random.ordering)[1]

    write.table(df.tumors.with.random.ordering[1:n.tumors.with.random.ordering,], file = filename.pre.downloads.with.date,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)
    write.table(df.tumors.with.random.ordering[(n.use.this.many.files.now+1):n.tumors.with.random.ordering,], file = filename.downloads.with.date,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)
    write.table(df.tumors.with.random.ordering[(n.use.this.many.files.now+1):n.tumors.with.random.ordering,], file = filename.mostrecent,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)

    ## Now copy these files to the machete project
    print(paste0("About to copy ", n.use.this.many.files.now, " files to the machete project."))

    out.tumors.today.first.copying.process <- copy.many.files.with.sb.id.to.project(vec.sbids=use.these.now.ids, proj.name="JSALZMAN/machete", auth.token=auth.token, tempdir=tempdir)
    ## AFTER COPYING, CHECK MANUALLY THAT THERE ARE NO _1_ PREFIXES
    print("AFTER COPYING, CHECK MANUALLY THAT THERE ARE NO _1_ PREFIXES")

    ##  after outputting the next thing, copying and pasting and editing, use it in runapi.R
    ## these are the ids in the project (so they are NOT the sb ids)
    ## 
    print.nice.ids.vector.within.function(out.tumors.today.first.copying.process$files.ids)
    print.nice.ids.vector.within.function(names.tumors.with.random.ordering[1:n.use.this.many.files.now])
    ## also write files in case these are very long
    nice.ids.file = file.path(homedir,paste0(shortname, ".nice.ids.", todaydate, ".csv"))
    nice.names.file = file.path(homedir,paste0(shortname, ".nice.names.", todaydate, ".csv"))
    write.table(out.tumors.today.first.copying.process$files.ids, file = nice.ids.file,  row.names = FALSE, col.names = FALSE, sep = "\n", append=FALSE, quote=FALSE)
    write.table(names.tumors.with.random.ordering[1:n.use.this.many.files.now], file = nice.names.file,  row.names = FALSE, col.names = FALSE, sep = "\n", append=FALSE, quote=FALSE)
    cat(paste0("Also writing files\n", nice.ids.file, "\n and \n", nice.names.file),"\n")
    cat("Number of characters in ids output is ", nchar(print.nice.ids.vector(out.tumors.today.first.copying.process$files.ids)), " and number of characters in ids output is ", nchar(print.nice.ids.vector(names.tumors.with.random.ordering[1:n.use.this.many.files.now])), "\n", sep="")
}

## Assuming you already have a list of randomly ordered file names
## and ids in a "most recent" file, 
## put n more on machete; also writes two files, the "most recent" file
## and a file with a date on it
## used in datasetapi.R
put.n.more.files.in.machete.project <- function(todaydate, shortname, longname, n.use.this.many.files.now, homedir=homedir, tempdir=tempdir, auth.token=auth.token){
    filename.mostrecent = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.most.recent.csv"))
    df.tumors.with.random.ordering <- read.table(filename.mostrecent, sep=",", header = FALSE, col.names = c("sb.id", "filename", "case"), stringsAsFactors = FALSE)
    n.tumors.with.random.ordering <- dim(df.tumors.with.random.ordering)[1]
    print(paste0("n.tumors.with.random.ordering is: ", n.tumors.with.random.ordering, "\n"))
    stopifnot(n.use.this.many.files.now < n.tumors.with.random.ordering)
    use.these.now.ids <- df.tumors.with.random.ordering$sb.id[1:n.use.this.many.files.now]
    use.these.now.names <- df.tumors.with.random.ordering$filename[1:n.use.this.many.files.now]
    ## print.nice.ids.vector(use.these.now.ids)
    ## print.nice.ids.vector(use.these.now.names)
    ## filename.pre.downloads.with.date = file.path(homedir,paste0(shortname, todaydate, ".files.not.downloaded.before.csv"))
    filename.downloads.with.date = file.path(homedir,paste0(shortname, ".", todaydate, ".files.not.yet.downloaded.as.of.csv"))
    print(paste0("About to write files\n", filename.downloads.with.date, "\nand\n", filename.mostrecent))
    write.table(df.tumors.with.random.ordering[(n.use.this.many.files.now+1):n.tumors.with.random.ordering,], file = filename.downloads.with.date,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)
    ## NOTE: next thing overwrites previous file
    write.table(df.tumors.with.random.ordering[(n.use.this.many.files.now+1):n.tumors.with.random.ordering,], file = filename.mostrecent,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)
    out.tumors.today.first.copying.process <- copy.many.files.with.sb.id.to.project(vec.sbids=use.these.now.ids, proj.name="JSALZMAN/machete", auth.token=auth.token, tempdir=tempdir)
    ## AFTER COPYING, CHECK MANUALLY THAT THERE ARE NO _1_ PREFIXES
    ##  after outputting the next thing, copying and pasting and editing, use it in runapi.R
    ## these are the ids in the project (so they are NOT the sb ids)
    ## 
    print.nice.ids.vector(out.tumors.today.first.copying.process$files.ids)
    print.nice.ids.vector(use.these.now.names)
    ## also write files in case these are very long
    nice.ids.file = file.path(homedir,paste0(shortname, ".", todaydate, ".nice.ids.csv"))
    nice.names.file = file.path(homedir,paste0(shortname, ".", todaydate, ".nice.names.csv"))
    write.table(out.tumors.today.first.copying.process$files.ids, file = nice.ids.file,  row.names = FALSE, col.names = FALSE, sep = "\n", append=FALSE, quote=FALSE)
    write.table(use.these.now.names, file = nice.names.file,  row.names = FALSE, col.names = FALSE, sep = "\n", append=FALSE, quote=FALSE)
    print(paste0("Also writing files\n", nice.ids.file, "\n and \n", nice.names.file,"\n"))
}


## NOT SURE IF THIS WORKS; haven't used it yet; I was trying it for
## something but it didn't work for what I wanted it for.
# out34 <- get.details.of.a.file.from.id(fileid = "564a31abe4b0ef121817527b", auth.token=auth.token, ttwdir=tempdir)
# taskid = "0bb0a961-41fd-4617-a9d4-f2392445a04e"
# http://docs.cancergenomicscloud.org/docs/get-details-of-a-task
#
get.details.of.a.file.from.id <- function(fileid, auth.token, ttwdir=tempdir){
    filename.t <- file.path(ttwdir, "temptaskdetails.json")
    system(paste('curl -s -H "X-SBG-Auth-Token: ', auth.token, ' " -H "content-type: application/json" -X GET "https://cgc-api.sbgenomics.com/v2/files/',fileid, '" > ', filename.t, sep =""))
    RJSONIO::fromJSON(filename.t)
}




