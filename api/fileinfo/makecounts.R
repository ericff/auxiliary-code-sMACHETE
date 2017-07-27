# makecounts.R
# for making files like counts.of.nonnormals.completed.by.disease.type....

# assumes you've run makebothpathsandmetadata.R already

###################################################################
###################################################################
## read in and cross-reference them
###################################################################
###################################################################

home.home <- TRUE

# home directory

mydir="my/dir"
{
if (home.home){ 
    homedir = file.path(mydir,"api")
    wdir = file.path(homedir, "fileinfo")
    infodir = file.path(homedir, "fileinfo")
    temprdatadir = file.path(mydir,"api/rdatatempfiles")
    outcsv.with.keys <- file.path(wdir, "report.paths.with.keys.csv")
    tempdir = file.path(mydir,"api/tempfiles")
}
else {
    homedir = file.path(mydir,"api")
    wdir = file.path(homedir, "fileinfo")
    infodir = file.path(homedir, "fileinfo")
    temprdatadir = file.path(mydir,"api/rdatatempfiles")
    outcsv.with.keys <- file.path(wdir, "report.paths.with.keys.csv")
    tempdir = file.path(mydir,"api/tempfiles")
}
}

source(file.path(homedir,"apidefs.R"))

metadata.filename <- file.path(wdir,paste0("metadata.csv"))

if (home.home){
    metadata.filename <- file.path(infodir,paste0("metadata.csv"))
}

meta <- read.csv(metadata.filename, header=TRUE, sep=",", stringsAsFactors = FALSE)



paths.with.keys <- read.csv(outcsv.with.keys, header=TRUE, sep=",", stringsAsFactors = FALSE)

paths.with.meta <- merge(x=paths.with.keys, y=meta, by.x = "base.directory", by.y="nicename")

## next one has meta data also; added this in oct 2016
outcsv.with.meta <- file.path(infodir, "report.paths.with.meta.csv")



## ttext = paths.with.keys[1,1]
get.groupdir <- function(ttext){
    tsplit = strsplit(x=ttext, split="/")
    tsplit[[1]][7]
}

matchedgroupdirs <- sapply(X= paths.with.meta$circ.junc.path, FUN = get.groupdir)
names(matchedgroupdirs) <- NULL
table(paths.with.meta$disease_type, paths.with.meta$sample_type)
table(matchedgroupdirs)
table(paths.with.meta$disease_type[paths.with.meta$sample_type %in% c("Primary Tumor", "Recurrent Tumor", "Primary Blood Derived Cancer - Peripheral Blood")])
sum(!is.na(paths.with.meta$knife.report))
table(paths.with.meta$investigation)
dim(paths.with.meta); dim(paths.with.keys); dim(meta)

nicedate<- tolower(format(Sys.time(),"%b%d"))

## To write non-normals to files:
y <- unique(cbind(tolower(gsub("TCGA-", replacement="", x=paths.with.meta$investigation)), paths.with.meta$disease_type))
y[y[,1]=="bodymap",1] <- "body"
z <- y[order(y[,2]),]
x <- table(paths.with.meta$disease_type[paths.with.meta$sample_type %in% c("Primary Tumor", "Recurrent Tumor", "Primary Blood Derived Cancer - Peripheral Blood")])
x <- append(x, values= 15)
names(x)[length(x)] <- "BODYMAP"
disease.types <- names(x)
frequencies <- as.integer(x)
investigation.types <- z[,1]
samples.used.for.bloom.query <- c(178,NA,NA,1095,304,458,NA,155,NA,NA,NA,NA,NA,516,NA,NA,422,178,497,259,NA,NA,16)
counts.file.name <- file.path(infodir, paste0("counts.of.nonnormals.completed.by.disease.type.", nicedate ,".csv"))
counts.df <- data.frame(investigation.types, disease.types, frequencies,samples.used.for.bloom.query)
write.table(x= counts.df, file = counts.file.name, col.names=FALSE, row.names=FALSE, sep=",")
dim(counts.df[!is.na(counts.df$samples.used.for.bloom.query),])
counts.df[!is.na(counts.df$samples.used.for.bloom.query),1]


###################################################################
###################################################################
## find total number of tumors for each cancer type
## non-normal and also primary only
###################################################################
###################################################################


setwd(homedir)
todaydate <- "dec23"
source(file.path(infodir, "setdefs.R"))

n.investigations <- length(investigation.types)

stopifnot(investigation.types[(n.investigations)]=="body")

n.files.non.normal.tumors <- vector("integer", length = n.investigations - 1)
## Next thing EXCLUDES recurrent and metastatic tumors
n.files.primary.or.blood.tumors <- vector("integer", length = n.investigations - 1)

n.cases.non.normal.tumors <- vector("integer", length = n.investigations - 1)
## Next thing EXCLUDES recurrent and metastatic tumors
n.cases.primary.or.blood.tumors <- vector("integer", length = n.investigations - 1)

## THIS TAKES A LONG TIME    
for (ii in 1:n.investigations){
    cat("Working on investigation ", ii, "\n")
    shortname <- investigation.types[ii]
    longname <- disease.types[ii]
    if (shortname != "body"){
        template.for.query.template.file <- file.path(tempdir, "tumorquery.json")
        query.template.file.for.particular.disease <- file.path(tempdir, paste0(shortname,".tumorquery.json"))
        outcsv <- paste0(shortname, todaydate, "query.tumor.csv")
        ## REMEMBER TO CHANGE .JSON FILE MANUALLY
        ## json files sit in api/tempfiles
        write.different.disease.to.tumor.template.file(shortname, tempdir, longname, query.template.file=template.for.query.template.file)
        if (shortname != "laml"){
            out.tumors.primary <- get.files.with.tumor.or.normal.and.return.NA.if.none(tempdir, homedir, query.template.file=query.template.file.for.particular.disease, auth.token,  tt.files.per.download= files.per.download, sample.type="Primary Tumor", output.csv = outcsv)
            n.files.primary.or.blood.tumors[ii] <- length(out.tumors.primary$ids.cases)
            n.cases.primary.or.blood.tumors[ii] <- length(unique(out.tumors.primary$ids.cases))
            ## following http://docs.cancergenomicscloud.org/v1.0/docs/complex-example-for-filtering-tcga-data
            ## out.tumors.nonnormal <- get.files.with.tumor.or.normal(tempdir, homedir, query.template.file=query.template.file.for.particular.disease, auth.token,  tt.files.per.download= files.per.download, sample.type='["Primary Tumor", "Recurrent Tumor", "Metastatic"]', output.csv = outcsv)
            out.tumors.recurrent <- get.files.with.tumor.or.normal.and.return.NA.if.none(tempdir, homedir, query.template.file=query.template.file.for.particular.disease, auth.token,  tt.files.per.download= files.per.download, sample.type="Recurrent Tumor", output.csv = outcsv)
            out.tumors.metastatic <- get.files.with.tumor.or.normal.and.return.NA.if.none(tempdir, homedir, query.template.file=query.template.file.for.particular.disease, auth.token,  tt.files.per.download= files.per.download, sample.type="Metastatic", output.csv = outcsv)
            n.files.non.normal.tumors[ii] <- n.files.primary.or.blood.tumors[ii] + out.tumors.recurrent$n.files + out.tumors.metastatic$n.files
            ## unique in next thing probably unnecessary:
            n.cases.non.normal.tumors[ii] <- length(unique(union(out.tumors.primary$ids.cases, union(out.tumors.recurrent$ids.cases, out.tumors.metastatic$ids.cases))))
        } else {
            ## Note that I double-checked using Data Browser
            ##  that this is the only type for laml:
            n.files.primary.or.blood.tumors[ii] <- 179
            n.cases.primary.or.blood.tumors[ii] <- 178
            ## n.files.primary.or.blood.tumors[ii] <- length(out.tumors.primary$ids.cases)
            ## n.cases.primary.or.blood.tumors[ii] <- length(unique(out.tumors.primary$ids.cases))
            ## Note that I double-checked using Data Browser
            ##  that there are none of these for laml:
            n.files.non.normal.tumors[ii] <- n.files.primary.or.blood.tumors[ii]
            ## unique in next thing probably unnecessary:
            n.cases.non.normal.tumors[ii] <- n.cases.primary.or.blood.tumors[ii]
        }
    }
}

investigation.types[-length(investigation.types)]
disease.types[-length(disease.types)]

percent.of.primary.or.blood.tumors.run.on.machete <- 100*(frequencies[-length(frequencies)]/n.cases.primary.or.blood.tumors)

out.df <- data.frame(investigation.types=investigation.types[-length(investigation.types)], machete.frequencies=frequencies[-length(frequencies)], disease.types=disease.types[-length(disease.types)], percent.of.primary.or.blood.tumors.run.on.machete=percent.of.primary.or.blood.tumors.run.on.machete, n.files.primary.or.blood.tumors=n.files.primary.or.blood.tumors, n.cases.primary.or.blood.tumors=n.cases.primary.or.blood.tumors, n.files.non.normal.tumors=n.files.non.normal.tumors, n.cases.non.normal.tumors= n.cases.non.normal.tumors, stringsAsFactors = FALSE)


write.table(out.df, file = file.path(infodir, "counts.of.files.by.api.csv"), sep=",", row.names =F)

out.df$investigation.types[-c(1,8,17,18)]
out.df$investigation.types[c(1,8,17,18)]
sum(out.df$machete.frequencies[-c(1,8,17,18)])

sum(out.df$n.cases.primary.or.blood.tumors[-c(1,8,17,18)])
sum(out.df$machete.frequencies[-c(1,8,17,18)])/sum(out.df$n.cases.primary.or.blood.tumors[-c(1,8,17,18)])

## save.image(file = file.path(infodir, "dec19.makecountsdata.RData"))
## save.image(file = file.path(infodir, "jan2.makecountsdata.RData"))

all.df <- merge(x=out.df , y=counts.df, by.x ="investigation.types", by.y = "investigation.types", stringsAsFactors=FALSE)
all.df$disease.types.y <- NULL
all.df$frequencies <- NULL
## for (jj in c(1,2,8)){ all.df[,jj] <- as.character(all.df[,jj]) }
investigation <- toupper(paste0("TCGA-", c(all.df$investigation.types,"body")))
investigation[investigation=="TCGA-BODY"] <- "BodyMap"
## all.df[23,] <- c("body", NA, 93.75, NA, NA, NA, NA, NA, 15, 16)
all.df[23,] <- c("body", 15, "BODYMAP", 93.75, NA, NA, NA, NA, 16)
all.df <- data.frame(all.df, investigation, stringsAsFactors = FALSE)
## for (jj in c(1,2,8,11)){ class(all.df[,jj]) <- "character" }
for (jj in c(2,5:9)) { class(all.df[,jj]) <- "integer"}
class(all.df[,4]) <- "numeric"
sapply(all.df, class)
## class(all.df[,3]) <- "numeric"


all.df$percent.of.primary.or.blood.tumors.run.on.machete <- round(all.df$percent.of.primary.or.blood.tumors.run.on.machete, digits=1)


## all.df <- all.df[,c(1,11,2,9,5,3,4,7,6,10)]
all.df <- all.df[,c(1,10,3,2,6,4,5,8,7,9)]
nice.names <- c("Investigation Types", "Investigation", "Disease Type", "Machete Counts", "Number of Cases with Primary or Blood Tumors", "Percentage of Cases with Primary or Blood Tumors Analyzed with Machete", "Number of Samples with Primary or Blood Tumors", "Number of Cases with Primary, Recurrent, Metastatic or Blood Tumors", "Number of Samples with Primary, Recurrent, Metastatic or Blood Tumors", "Number of Samples used for Building Sequence Bloom Tree")

filename <- file.path(mydir, "api/fileinfo/counts.of.files.machete.bloom.and.total.number.of.cases.with.primary.or.blood.tumors.etc.csv")
write.table(x=t(nice.names), file = filename, append =F, sep =",", row.names=F, col.names = F)
write.table(x=all.df, file = filename, append =T, sep =",", row.names=F, col.names = F)

## Then I manually dropped the columns F-I for conciseness. (These columns have labels: Percentage of Cases with Primary or Blood Tumors Analyzed with Machete    Number of Samples with Primary or Blood Tumors    Number of Cases with Primary, Recurrent, Metastatic or Blood Tumors    Number of Samples with Primary, Recurrent, Metastatic or Blood Tumors)



