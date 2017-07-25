## make key files from reports files for use with
## filelistprocess.py
## switching over to using sample ids, see make.sample.id.files.R

homedir = "/my/dir"
wdir = file.path(homedir, "fileinfo")
infodir = file.path(homedir, "fileinfo")

## next one has meta data also; added this in oct 2016
outcsv.with.meta <- file.path(infodir, "report.paths.with.meta.csv")

paths.with.meta <- read.table(file=outcsv.with.meta, header= TRUE, sep = ",", stringsAsFactors = FALSE)


cancer.types <- c("Acute Myeloid Leukemia", "Bladder Urothelial Carcinoma", "Brain Lower Grade Glioma", "Breast Invasive Carcinoma", "Cervical Squamous Cell Carcinoma and Endocervical Adenocarcinoma", "Colon Adenocarcinoma", "Esophageal Carcinoma", "Glioblastoma Multiforme", "Head and Neck Squamous Cell Carcinoma", "Kidney Chromophobe", "Kidney Renal Clear Cell Carcinoma", "Kidney Renal Papillary Cell Carcinoma", "Liver Hepatocellular Carcinoma", "Lung Adenocarcinoma", "Lung Squamous Cell Carcinoma", "Lymphoid Neoplasm Diffuse Large B-cell Lymphoma", "Ovarian Serous Cystadenocarcinoma", "Pancreatic Adenocarcinoma", "Prostate Adenocarcinoma", "Sarcoma", "Skin Cutaneous Melanoma", "Stomach Adenocarcinoma")
cancer.type.keys <- c("aml", "bladder", "glioma", "breast", "cesc", "colon", "esophagus", "gbm", "headneck", "kidneychromophobe", "krcc", "kirp", "liver", "lung", "lungcell", "lymphoma", "ovarian", "pancreatic", "prostate", "sarcoma", "skin", "stomach")

n.types <- length(cancer.types)
num.files.by.type <- vector("integer", length = n.types)
for (ii in 1:n.types){
    thesekeys <- paths.with.meta$base.directory[paths.with.meta$disease_type == cancer.types[ii]]
    num.files.by.type[ii] <- length(thesekeys)
    outfile <- file.path(infodir, paste0("keys.", cancer.type.keys[ii],".files.machete.done.csv"))
    ## Now deal with cases of weirdly named files (do this manually):
    if (cancer.type.keys[ii]=="gbm"){
        thesekeys[thesekeys=="1G17210.TCGA12061601A01R184901.2"] <- "G17210.TCGA12061601A01R184901.2"
    }
    writeLines(thesekeys, con=outfile, sep="\n")
}




