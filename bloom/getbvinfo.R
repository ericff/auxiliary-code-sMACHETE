## getbvinfo.R
## See getbloomtreemanybvinfo.R
##  for getting info on bv files regarding
##  cancer types in the bloomtreemany project



# NOTE: it is a problem if
#  any inputs, especially e.g. runid.suffix, are ""

# home.home is TRUE if using home computer 
home.home <- TRUE

# max.iterations for loop in out.project.list function
max.iterations <- 10000


# home directory

mydir <-"/my/dir"
{
if (home.home){ 
    homedir = paste0(mydir, "api")
    temprdatadir = paste0(mydir, "api/rdatatempfiles")
    auth.token.filename <- paste0(mydir, "api/authtoken.txt")
}
else {
    homedir = paste0(mydir, "api")
    temprdatadir = paste0(mydir, "api/rdatatempfiles")
    auth.token.filename <- paste0(mydir, "api/authtoken.txt")
}
}



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


## projowner <- "ericfg"
## shortproj <- "bloomtree-pancreatic"
## fullprojname <- paste0(projowner,"/",shortproj)

all.fullprojnames <- c(paste0("ericfg/",c("bloomtree-gbm", "bloomtree-pancreatic", "bloomtree-aml", "bloomtree-ovarian", "bloomtree-br")), "elehnert/sequence-bloomtree-cesc-largescale", "elehnert/sequence-bloomtree-prad-largescale", "ericfg/bloomtreelung")

cancer.type.keys <- c("gbm", "pancreatic", "aml", "ovarian", "breast", "cesc", "prostate", "lung")

stopifnot(length(all.fullprojnames)==length(cancer.type.keys))

## cancer.types <- c("Acute Myeloid Leukemia", "Bladder Urothelial Carcinoma", "Brain Lower Grade Glioma", "Breast Invasive Carcinoma", "Cervical Squamous Cell Carcinoma and Endocervical Adenocarcinoma", "Colon Adenocarcinoma", "Esophageal Carcinoma", "Glioblastoma Multiforme", "Head and Neck Squamous Cell Carcinoma", "Kidney Chromophobe", "Kidney Renal Clear Cell Carcinoma", "Kidney Renal Papillary Cell Carcinoma", "Liver Hepatocellular Carcinoma", "Lung Adenocarcinoma", "Lung Squamous Cell Carcinoma", "Lymphoid Neoplasm Diffuse Large B-cell Lymphoma", "Ovarian Serous Cystadenocarcinoma", "Pancreatic Adenocarcinoma", "Prostate Adenocarcinoma", "Sarcoma", "Skin Cutaneous Melanoma", "Stomach Adenocarcinoma")
## cancer.type.keys <- c("aml", "bladder", "glioma", "breast", "cesc", "colon", "esophagus", "gbm", "headneck", "kidneychromophobe", "krcc", "kirp", "liver", "lung", "lungcell", "lymphoma", "ovarian", "pancreatic", "prostate", "sarcoma", "skin", "stomach")
nicedate <-  tolower(format(Sys.time(),"%b%d"))


n.projects <- length(all.fullprojnames)

for (ii.project in 1:n.projects){
    aa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")
    fullprojname <- all.fullprojnames[ii.project]
    ## mm for project, which typically had been machete
    mm <- aa$project(id=fullprojname)

    ## wrapper call doesn't work
    ## files.all <- mm$file(complete=TRUE)
    ##
    files.all <- list.all.files.project(projname=fullprojname, ttwdir=wdir, tempdir=tempdir, auth.token=auth.token, max.iterations=max.iterations)
    indices.files.bv <- grep(pattern=".bv", ignore.case = TRUE, x = files.all$filenames) 
    ids.bv <- files.all$fileids[indices.files.bv]
    names.bv <- files.all$filenames[indices.files.bv]
    n.bv <- length(ids.bv)
    sample.ids.bv <- vector("character", length = n.bv)
    ## this.origin.task <- thisfileinfo$origin$task
    ## origintaskinfo <- mm$task(id=this.origin.task)
    ##
    ## get sample ids from .bv files
    for (ii in 1:n.bv){
        if (ii %% 10 == 0){
            cat("Working on bv file ", ii, " of ", n.bv, "\n")
        }
        thisfileinfo <- mm$file(id = ids.bv[ii])
        if (is.null(thisfileinfo$metadata)){
            stop(paste0("No metadata for file with id\n", ids.bv[ii], "\nin project ", fullprojname))
        }
        sample.ids.bv[ii] <- thisfileinfo$metadata$sample_id
    }

    bv.filename <- file.path(fileinfodir, paste0("bv.", cancer.type.keys[ii.project], ".files.info.", nicedate, ".csv"))

    ## Write file with bv name, bv file id, sample id
    write.table(t(c("bv.file.name", "file.id", "sample.id")), file=bv.filename, append = FALSE, col.names = FALSE, row.names = FALSE, sep=",")
    write.table(cbind(names.bv, ids.bv, sample.ids.bv), file=bv.filename, append = TRUE, col.names = FALSE, row.names = FALSE, sep=",")
}



