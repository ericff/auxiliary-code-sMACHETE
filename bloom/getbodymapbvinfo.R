## this is for getting info on bv files regarding
##  cancer types in the bodymap project
## See also getbvinfo.R and getbloomtreemanybvinfo.R for other projects



# NOTE: it is a problem if
#  any inputs, especially e.g. runid.suffix, are ""

# home.home is TRUE if using home computer 
home.home <- TRUE

# max.iterations for loop in out.project.list function
max.iterations <- 10000


# home directory

mydir <- "/my/dir"
{
if (home.home){ 
    homedir = file.path(mydir, "api")
    temprdatadir = file.path(mydir,"api/rdatatempfiles")
    auth.token.filename <- file.path(mydir,"api/authtoken.txt")
}
else {
    homedir = file.path(mydir, "api")
    temprdatadir = file.path(mydir,"api/rdatatempfiles")
    auth.token.filename <- file.path(mydir,"api/authtoken.txt")
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




projname <- "elehnert/sbt-bodymap"

cancer.type.keys <- c("bodymap")

cancer.types <- c("BodyMap")

stopifnot(length(cancer.type.keys)==length(cancer.types))

## cancer.types <- c("Acute Myeloid Leukemia", "Bladder Urothelial Carcinoma", "Brain Lower Grade Glioma", "Breast Invasive Carcinoma", "Cervical Squamous Cell Carcinoma and Endocervical Adenocarcinoma", "Colon Adenocarcinoma", "Esophageal Carcinoma", "Glioblastoma Multiforme", "Head and Neck Squamous Cell Carcinoma", "Kidney Chromophobe", "Kidney Renal Clear Cell Carcinoma", "Kidney Renal Papillary Cell Carcinoma", "Liver Hepatocellular Carcinoma", "Lung Adenocarcinoma", "Lung Squamous Cell Carcinoma", "Lymphoid Neoplasm Diffuse Large B-cell Lymphoma", "Ovarian Serous Cystadenocarcinoma", "Pancreatic Adenocarcinoma", "Prostate Adenocarcinoma", "Sarcoma", "Skin Cutaneous Melanoma", "Stomach Adenocarcinoma")
## cancer.type.keys <- c("aml", "bladder", "glioma", "breast", "cesc", "colon", "esophagus", "gbm", "headneck", "kidneychromophobe", "krcc", "kirp", "liver", "lung", "lungcell", "lymphoma", "ovarian", "pancreatic", "prostate", "sarcoma", "skin", "stomach")
nicedate <-  tolower(format(Sys.time(),"%b%d"))


n.keys <- length(cancer.type.keys)

## First get names of all the bv files
## this takes a while.

## Write it to a file

aa <- Auth(token= auth.token, url = "https://cgc-api.sbgenomics.com/v2/")
## mm for project, which typically had been machete
mm <- aa$project(id=projname)

## wrapper call doesn't work
## files.all <- mm$file(complete=TRUE)
##
files.all <- list.all.files.project(projname=projname, ttwdir=wdir, tempdir=tempdir, auth.token=auth.token, max.iterations=max.iterations)
indices.files.bv <- grep(pattern=".bv", ignore.case = TRUE, x = files.all$filenames) 
ids.bv <- files.all$fileids[indices.files.bv]
names.bv <- files.all$filenames[indices.files.bv]
n.bv <- length(ids.bv)
sample.ids.bv <- vector("character", length = n.bv)
cancer.types.bv <- vector("character", length = n.bv)
## this.origin.task <- thisfileinfo$origin$task
## origintaskinfo <- mm$task(id=this.origin.task)
##
## get sample ids and investigations from .bv files
for (ii in 1:n.bv){
    if (ii %% 10 == 0){
        cat("Working on bv file ", ii, " of ", n.bv, "\n")
    }
    thisfileinfo <- mm$file(id = ids.bv[ii])
    if (is.null(thisfileinfo$metadata)){
        stop(paste0("No metadata for file with id\n", ids.bv[ii], "\nin project ", fullprojname))
    }
    sample.ids.bv[ii] <- thisfileinfo$metadata$sample_id
    cancer.types.bv[ii] <- thisfileinfo$metadata$investigation
}


cancer.type.keys.bv.files <- cancer.types.bv
for (ii in 1:length(cancer.types)){
    cancer.type.keys.bv.files[cancer.type.keys.bv.files==cancer.types[ii]] <- cancer.type.keys[ii]
}

bv.all.filename <- file.path(fileinfodir, paste0("bv.bodymap.files.info.", nicedate, ".csv"))

bv.all.df <- data.frame(bv.file.name=names.bv, file.id=ids.bv, sample.id=sample.ids.bv, disease.type=cancer.types.bv, key=cancer.type.keys.bv.files, stringsAsFactors=FALSE)




## Write file with bv name, bv file id, sample id, disease type
write.table(bv.all.df, file=bv.all.filename, append = FALSE, col.names = TRUE, row.names = FALSE, sep=",")



