## make sample ids files (and files of keys,
#   because already have done it) from reports files for use with
##  filelistprocess.py


homedir = "/my/dir"
wdir = file.path(homedir, "fileinfo")
infodir = file.path(homedir, "fileinfo")

## next one has meta data also; added this in oct 2016
outcsv.with.meta <- file.path(infodir, "report.paths.with.meta.csv")

paths.with.meta <- read.table(file=outcsv.with.meta, header= TRUE, sep = ",", stringsAsFactors = FALSE)

## Note that last one is BodyMap
cancer.types <- c("Acute Myeloid Leukemia", "Bladder Urothelial Carcinoma", "Brain Lower Grade Glioma", "Breast Invasive Carcinoma", "Cervical Squamous Cell Carcinoma and Endocervical Adenocarcinoma", "Colon Adenocarcinoma", "Esophageal Carcinoma", "Glioblastoma Multiforme", "Head and Neck Squamous Cell Carcinoma", "Kidney Chromophobe", "Kidney Renal Clear Cell Carcinoma", "Kidney Renal Papillary Cell Carcinoma", "Liver Hepatocellular Carcinoma", "Lung Adenocarcinoma", "Lung Squamous Cell Carcinoma", "Lymphoid Neoplasm Diffuse Large B-cell Lymphoma", "Ovarian Serous Cystadenocarcinoma", "Pancreatic Adenocarcinoma", "Prostate Adenocarcinoma", "Sarcoma", "Skin Cutaneous Melanoma", "Stomach Adenocarcinoma", "BodyMap")
cancer.type.keys <- c("laml", "blca", "lgg", "brca", "cesc", "coad", "esca", "gbm", "hnsc", "kich", "kirc", "kirp", "lihc", "luad", "lusc", "dlbc", "ov", "paad", "prad", "sarc", "skcm", "stad")

short.investigations <- c(cancer.type.keys,"bodymap")
investigations <- c(paste0("TCGA-", toupper(cancer.type.keys)),"BodyMap")
all.keys <- c(cancer.type.keys, "bodymap")

n.keys <- length(all.keys)

## Select particular tumor types, in case there are, e.g. Recurrent
##  Tumor analyses done with machete but not used when building the
##  bloom tree filter. This is the case with ovarian cancer for
##  example. There are two recurrent tumors there machete was run
##  on, but that are not in the bloomtree-ovarian project.
cancer.tumor.types <- rep("Primary Tumor", n.keys)
cancer.tumor.types[which(cancer.type.keys=="laml")] <- "Primary Blood Derived Cancer - Peripheral Blood"
cancer.tumor.types[length(cancer.tumor.types)] <- ""

## To make the following code cleaner, if Investigation is BodyMap
## assign "bodymap" or similar to sample type and disease type
paths.with.meta$disease_type[paths.with.meta$investigation=="BodyMap"] <- "bodymapdiseasetype"
paths.with.meta$sample_type[paths.with.meta$investigation=="BodyMap"] <- "bodymapsampletype"

## NOTE THAT this excludes normals, so will be less than the total
## number of files in paths.with.meta

num.files.by.type <- vector("integer", length = n.keys)
for (ii in 1:n.keys){
    ## do separately for bodymap
    if (ii != n.keys){
        thesekeys <- paths.with.meta$base.directory[(paths.with.meta$disease_type == cancer.types[ii] & paths.with.meta$sample_type== cancer.tumor.types[ii])]
        ## Now deal with cases of weirdly named files (do this manually):
        if (cancer.type.keys[ii]=="gbm"){
            thesekeys[thesekeys=="1G17210.TCGA12061601A01R184901.2"] <- "G17210.TCGA12061601A01R184901.2"
        }
    } else {
        thesekeys <- paths.with.meta$base.directory[(paths.with.meta$investigation == "BodyMap")]
    }
    ## thesekeys <- paths.with.meta$base.directory[(paths.with.meta$Investigation == investigations[ii] & paths.with.meta$sample_type== cancer.tumor.types[ii])]
    ## Write files of keys; was using this before, not anymore, but
    ## still do anyway in case helpful
    outfile <- file.path(infodir, paste0("keys.", short.investigations[ii],".files.machete.dec10.done.csv"))
    writeLines(thesekeys, con=outfile, sep="\n")
    ## 
    if (ii != n.keys){
        thesesampleids <- paths.with.meta$sample_id[(paths.with.meta$disease_type == cancer.types[ii] & paths.with.meta$sample_type== cancer.tumor.types[ii])]
        ## Now deal with individual weird cases (do this manually):
        ## E.g. for breast cancer, there is one sample that had the machete
        ## run on it, but it just didn't get picked as one of the samples
        ## to be included in the bloom tree. 
        if (cancer.type.keys[ii]=="brca"){
            thesesampleids <- thesesampleids[thesesampleids!="TCGA-AC-A2QH-01A"]
        }
    } else {
        thesesampleids <- paths.with.meta$sample_id[(paths.with.meta$investigation == "BodyMap")]
    }
    ## Write files of sample ids
    samplefile <- file.path(infodir, paste0("sample.ids.", short.investigations[ii],".files.machete.dec10.done.csv"))
    writeLines(thesesampleids, con=samplefile, sep="\n")
    num.files.by.type[ii] <- length(thesesampleids)
}

















