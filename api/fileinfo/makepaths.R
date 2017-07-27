# makepaths.R

# mostly superseded by makebothpathsandmetadata.R

# FOR NORMALS, SEE BELOW

# make csv file re jul 14 email

mydir <- "/my/dir"

setwd(file.path(mydir,"sbdata"))

nicedate<- tolower(format(Sys.time(),"%b%d"))

outcsv <- file.path(mydir,paste0("fileinfo/report.paths.",nicedate,".csv"))
# next one does NOT have NAs, and does not have full paths to dir
outcsv.with.keys <- file.path(mydir,"sbdata/report.paths.with.keys.csv")

# next one has NAs
#  also allows you to keep track of changes by keeping the dates
outcsv.with.dirnames <- file.path(mydir,paste0("fileinfo/report.paths.with.directory.",nicedate,".csv"))

#
dirs.one.level <- list.dirs(recursive=FALSE, full.names=FALSE)

# alldirs is all directories 2 levels deep, which is what we care about
alldirs.short.path <- vector("character", length=0)
alldirs.base.dir <- vector("character", length=0)
for (ttdir in dirs.one.level){
    alldirs.short.path <- append(alldirs.short.path, list.dirs(ttdir, recursive=FALSE))
    alldirs.base.dir <- append(alldirs.base.dir, list.dirs(ttdir, recursive=FALSE, full.names=FALSE))
}

n.dirs <- length(alldirs.short.path)

# then make alldirs have fullpath
alldirs <- file.path(rep(x=getwd(),n.dirs),alldirs.short.path) 

write.table(t(c("circ.junc.path","linear.junc.path","appended.report.path")), file = outcsv, row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE)

write.table(t(c("circ.junc.path","linear.junc.path","appended.report.path", "base.directory")), file = outcsv.with.keys, row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE)

write.table(t(c("circ.junc.path","linear.junc.path","appended.report.path", "directory.full.path","base.directory")), file = outcsv.with.dirnames, row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE)

ttcounter <- 0

for (tti in 1:n.dirs){
    allfiles.thisdir.recursive <- dir(path=alldirs[tti],recursive=TRUE)
    circ.junc.path <- file.path(alldirs[tti],allfiles.thisdir.recursive[grep(pattern="glmReports/.*circJuncProbs.txt_cdf$", x=allfiles.thisdir.recursive)])
    linear.junc.path <- file.path(alldirs[tti],allfiles.thisdir.recursive[grep(pattern="glmReports/.*linearJuncProbs.txt_cdf$", x=allfiles.thisdir.recursive)])
    appended.report.path <- file.path(alldirs[tti],allfiles.thisdir.recursive[grep(pattern="reports/AppendedReports/.*naive_report_Appended.txt$", x=allfiles.thisdir.recursive)])
    {
    if ((length(circ.junc.path)==1) & (length(linear.junc.path)==1) & (length(appended.report.path)==1)){
        write.table(t(c(circ.junc.path,linear.junc.path,appended.report.path)), file = outcsv, row.names = FALSE, col.names = FALSE, sep = ",", append=TRUE)
        write.table(t(c(circ.junc.path,linear.junc.path,appended.report.path, alldirs.base.dir[tti])), file = outcsv.with.keys, row.names = FALSE, col.names = FALSE, sep = ",", append=TRUE)
        write.table(t(c(circ.junc.path,linear.junc.path,appended.report.path, alldirs[tti],alldirs.base.dir[tti])), file = outcsv.with.dirnames, row.names = FALSE, col.names = FALSE, sep = ",", append=TRUE)
        ttcounter <- ttcounter + 1
    }
    else {
        if (length(circ.junc.path)==0){
            circ.junc.path <- NA
        }
        if (length(linear.junc.path)==0){
            linear.junc.path <- NA
        }
        if (length(appended.report.path)==0){
            appended.report.path <- NA
        }
        write.table(t(c(circ.junc.path,linear.junc.path,appended.report.path, alldirs[tti],alldirs.base.dir[tti])), file = outcsv.with.dirnames, row.names = FALSE, col.names = FALSE, sep = ",", append=TRUE)
    }
    }
    # else {
    #    write.table(t(c(NA,NA,NA, alldirs[tti], alldirs.base.dir[tti])), file = outcsv.with.dirnames, row.names = FALSE, col.names = FALSE, sep = ",", append=TRUE)
    # }
}

cat("\nNumber of files in report.paths.*csv: ", ttcounter, "\n")
# 122 
# 144 on july 21

# 169 on july 28
# 192 on aug 2

# should include normals now

###############################################################
# for normals, doing on july 20
###############################################################

setwd(file.path(mydir,"normals-pre-july13"))

nicedate <- tolower(format(Sys.time(),"%b%d"))

normals.csv <- file.path(mydir,paste0("sbdata/normals.report.paths.with.keys.",nicedate,".csv"))

normals.with.fulldirs.csv <- file.path(mydir,paste0("normals.report.paths.with.directory.names.",nicedate,".csv"))


# dirs.normals.one.level <- list.dirs(recursive=FALSE, full.names=FALSE)

# alldirs.normals is all directories 1 level deep in normals-pre-july13, which is what we care about
alldirs.normals.short.path <- list.dirs(recursive=FALSE)
alldirs.normals.base.dir <- list.dirs(recursive=FALSE, full.names=FALSE)


## alldirs.normals.short.path <- vector("character", length=0)
## alldirs.normals.base.dir <- vector("character", length=0)
## for (ttdir in dirs.normals.one.level){
##     alldirs.normals.short.path <- append(alldirs.normals.short.path, list.dirs(ttdir, recursive=FALSE))
##     alldirs.normals.base.dir <- append(alldirs.normals.base.dir, list.dirs(ttdir, recursive=FALSE, full.names=FALSE))
## }

n.dirs.normals <- length(alldirs.normals.short.path)

# then make alldirs.normals have fullpath
alldirs.normals <- file.path(rep(x=getwd(),n.dirs.normals),alldirs.normals.base.dir) 

write.table(t(c("circ.junc.path","linear.junc.path","appended.report.path", "base.directory")), file = normals.csv, row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE)


ttcounter.normals <- 0

for (tti in 1:n.dirs.normals){
    allfiles.thisdir.recursive <- dir(path=alldirs.normals[tti],recursive=TRUE)
    circ.junc.path <- file.path(alldirs.normals[tti],allfiles.thisdir.recursive[grep(pattern="glmReports/.*circJuncProbs.txt_cdf$", x=allfiles.thisdir.recursive)])
    linear.junc.path <- file.path(alldirs.normals[tti],allfiles.thisdir.recursive[grep(pattern="glmReports/.*linearJuncProbs.txt_cdf$", x=allfiles.thisdir.recursive)])
    appended.report.path <- file.path(alldirs.normals[tti],allfiles.thisdir.recursive[grep(pattern="reports/AppendedReports/.*naive_report_Appended.txt$", x=allfiles.thisdir.recursive)])
    {
    if ((length(circ.junc.path)==1) & (length(linear.junc.path)==1) & (length(appended.report.path)==1)){
        write.table(t(c(circ.junc.path,linear.junc.path,appended.report.path, alldirs.normals.base.dir[tti])), file = normals.csv, row.names = FALSE, col.names = FALSE, sep = ",", append=TRUE)
        write.table(t(c(circ.junc.path,linear.junc.path,appended.report.path, alldirs.normals[tti],alldirs.normals.base.dir[tti])), file = normals.with.fulldirs.csv , row.names = FALSE, col.names = FALSE, sep = ",", append=TRUE)
        ttcounter.normals  <- ttcounter.normals + 1
    }
    else {
        if (length(circ.junc.path)==0){
            circ.junc.path <- NA
        }
        if (length(linear.junc.path)==0){
            linear.junc.path <- NA
        }
        if (length(appended.report.path)==0){
            appended.report.path <- NA
        }
        write.table(t(c(circ.junc.path,linear.junc.path,appended.report.path, alldirs.normals[tti],alldirs.normals.base.dir[tti])), file = normals.with.fulldirs.csv , row.names = FALSE, col.names = FALSE, sep = ",", append=TRUE)
    }
    }
    # else {
    #    write.table(t(c(NA,NA,NA, alldirs.normals[tti], alldirs.normals.base.dir[tti])), file = outcsv.with.dirnames, row.names = FALSE, col.names = FALSE, sep = ",", append=TRUE)
    # }
}

cat("\nNumber of files in normals.report.paths.with.keys*csv: ", ttcounter.normals, "\n")










