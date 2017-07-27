# make directory of group before calling next function
# 


# NOTE: it is a problem if
#  any inputs, especially e.g. runid.suffix, are ""

# home.home is TRUE if using home computer 
home.home <- FALSE

# max.iterations for loop in out.project.list function
max.iterations <- 10000


# home directory
mydir <- "/my/dir"
{
if (home.home){ 
    homedir = file.path(mydir, "api")
    temprdatadir = file.path(mydir, "api/rdatatempfiles")
    auth.token.filename <- file.path(mydir, "api/authtoken.txt")
}
else {
    homedir = file.path(mydir, "api")
    temprdatadir = file.path(mydir, "api/rdatatempfiles")
    auth.token.filename <- file.path(mydir, "api/authtoken.txt")
}
}



wdir = file.path(homedir,"sbdata")
tempdir = file.path(homedir,"tempfiles")
fileinfodir <- file.path(homedir, "fileinfo")
spachetedir <- file.path(homedir, "spachetedata")
    
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





























## groupname <- "amlaug31part2"
## groupname <- "amlaug31secondtest"
## groupname <- "amlaug31thirdtest"
## groupname <- "amlaug31part2"
## groupname <- "gbmsep5"
## groupname <- "amlaug31part3"
## groupname <- "pancsep7"

## groupname <- "bladdersep8"

































######################################################################
## amlaug31  machete-new-glm-script  machete-light
##  part1 and part2 each with 45 files
##  did part1 elsewhere
## amlaug31thirdtest
## Note that I accidentally put tarfilenames = amlaug31thirdtest.ids
##  for this
##  when I ran it
######################################################################


## NOTE: should do files 53-90; used 45 and 46 and 47 ... 51 for testing


amlaug31.46to90ids <- c("57c76ccce4b0f9890b16d3b0", "57c76ccce4b0f9890b16d3b2", "57c76ccce4b0f9890b16d3b4", "57c76ccde4b0f9890b16d3b6", "57c76ccde4b0f9890b16d3b8", "57c76ccee4b0f9890b16d3ba", "57c76ccee4b0f9890b16d3bc", "57c76ccfe4b0f9890b16d3be", "57c76ccfe4b0f9890b16d3c0", "57c76ccfe4b0f9890b16d3c2", "57c76cd0e4b0f9890b16d3c4", "57c76cd0e4b0f9890b16d3c6", "57c76cd1e4b0f9890b16d3c8", "57c76cd1e4b0f9890b16d3ca", "57c76cd1e4b0f9890b16d3cc", "57c76cd2e4b0f9890b16d3ce", "57c76cd2e4b0f9890b16d3d0", "57c76cd3e4b0f9890b16d3d2", "57c76cd3e4b0f9890b16d3d4", "57c76cd3e4b0f9890b16d3d6", "57c76cd4e4b0f9890b16d3d8", "57c76cd6e4b0f9890b16d3da", "57c76cd7e4b0f9890b16d3dc", "57c76cd7e4b0f9890b16d3de", "57c76cd8e4b0f9890b16d3e0", "57c76cd8e4b0f9890b16d3e2", "57c76cd8e4b0f9890b16d3e4", "57c76cd9e4b0f9890b16d3e6", "57c76cd9e4b0f9890b16d3e8", "57c76cdae4b0f9890b16d3ea", "57c76cdae4b0f9890b16d3ec", "57c76cdae4b0f9890b16d3ee", "57c76cdbe4b0f9890b16d3f0", "57c76cdbe4b0f9890b16d3f2", "57c76cdce4b0f9890b16d3f4", "57c76cdce4b0f9890b16d3f6", "57c76cdce4b0f9890b16d3f8", "57c76cdde4b0f9890b16d3fa", "57c76cdee4b0f9890b16d3fc", "57c76cdee4b0f9890b16d3fe", "57c76cdfe4b0f9890b16d400", "57c76cdfe4b0f9890b16d402", "57c76cdfe4b0f9890b16d404", "57c76ce0e4b0f9890b16d406", "57c76ce0e4b0f9890b16d408")

amlaug31.46to90names <- c("TCGA-AB-2874-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2900-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2877-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2860-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2862-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2967-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2898-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2872-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2977-03B-01T-0760-13_rnaseq_fastq.tar", "TCGA-AB-2891-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2965-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2824-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2849-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2894-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2889-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2942-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2853-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2863-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2954-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2932-03A-01T-0740-13_rnaseq_fastq.tar", "TCGA-AB-2887-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2973-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2806-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2861-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2858-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2875-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2855-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2994-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2896-03B-01T-0751-13_rnaseq_fastq.tar", "TCGA-AB-2895-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2828-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2928-03A-01T-0740-13_rnaseq_fastq.tar", "TCGA-AB-2873-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2854-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2936-03A-01T-0740-13_rnaseq_fastq.tar", "TCGA-AB-2819-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2856-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2935-03A-01T-0740-13_rnaseq_fastq.tar", "TCGA-AB-2946-03A-01T-0740-13_rnaseq_fastq.tar", "TCGA-AB-2978-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2899-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2933-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2878-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2813-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2815-03A-01T-0734-13_rnaseq_fastq.tar")


amlaug31thirdtest.ids <- amlaug31.46to90ids[(51-45):(52-45)]

amlaug31thirdtest.names <- amlaug31.46to90names[(51-45):(52-45)]

## amlaug31thirdtest.ids
## [1] "57c76ccee4b0f9890b16d3ba" "57c76ccee4b0f9890b16d3bc"
## > amlaug31thirdtest.names
## [1] "TCGA-AB-2967-03A-01T-0734-13_rnaseq_fastq.tar"
## [2] "TCGA-AB-2898-03A-01T-0735-13_rnaseq_fastq.tar"

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## I accidentally put tarfilenames = amlaug31thirdtest.ids for this
##  when I ran it
exec.n.pipelines(start.of.run = TRUE, tarfilenames = amlaug31thirdtest.names, tarfileids = amlaug31thirdtest.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp="JSALZMAN/machete/machete-light", runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata"))

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = amlaug31thirdtest.names, tarfileids = amlaug31thirdtest.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp="JSALZMAN/machete/machete-light", runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata"))





##############################################
## part 2: 
##  numbers 53 through 90 from above; so 38 files

amlaug31.46to90ids <- c("57c76ccce4b0f9890b16d3b0", "57c76ccce4b0f9890b16d3b2", "57c76ccce4b0f9890b16d3b4", "57c76ccde4b0f9890b16d3b6", "57c76ccde4b0f9890b16d3b8", "57c76ccee4b0f9890b16d3ba", "57c76ccee4b0f9890b16d3bc", "57c76ccfe4b0f9890b16d3be", "57c76ccfe4b0f9890b16d3c0", "57c76ccfe4b0f9890b16d3c2", "57c76cd0e4b0f9890b16d3c4", "57c76cd0e4b0f9890b16d3c6", "57c76cd1e4b0f9890b16d3c8", "57c76cd1e4b0f9890b16d3ca", "57c76cd1e4b0f9890b16d3cc", "57c76cd2e4b0f9890b16d3ce", "57c76cd2e4b0f9890b16d3d0", "57c76cd3e4b0f9890b16d3d2", "57c76cd3e4b0f9890b16d3d4", "57c76cd3e4b0f9890b16d3d6", "57c76cd4e4b0f9890b16d3d8", "57c76cd6e4b0f9890b16d3da", "57c76cd7e4b0f9890b16d3dc", "57c76cd7e4b0f9890b16d3de", "57c76cd8e4b0f9890b16d3e0", "57c76cd8e4b0f9890b16d3e2", "57c76cd8e4b0f9890b16d3e4", "57c76cd9e4b0f9890b16d3e6", "57c76cd9e4b0f9890b16d3e8", "57c76cdae4b0f9890b16d3ea", "57c76cdae4b0f9890b16d3ec", "57c76cdae4b0f9890b16d3ee", "57c76cdbe4b0f9890b16d3f0", "57c76cdbe4b0f9890b16d3f2", "57c76cdce4b0f9890b16d3f4", "57c76cdce4b0f9890b16d3f6", "57c76cdce4b0f9890b16d3f8", "57c76cdde4b0f9890b16d3fa", "57c76cdee4b0f9890b16d3fc", "57c76cdee4b0f9890b16d3fe", "57c76cdfe4b0f9890b16d400", "57c76cdfe4b0f9890b16d402", "57c76cdfe4b0f9890b16d404", "57c76ce0e4b0f9890b16d406", "57c76ce0e4b0f9890b16d408")

amlaug31.46to90names <- c("TCGA-AB-2874-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2900-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2877-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2860-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2862-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2967-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2898-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2872-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2977-03B-01T-0760-13_rnaseq_fastq.tar", "TCGA-AB-2891-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2965-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2824-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2849-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2894-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2889-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2942-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2853-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2863-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2954-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2932-03A-01T-0740-13_rnaseq_fastq.tar", "TCGA-AB-2887-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2973-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2806-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2861-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2858-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2875-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2855-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2994-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2896-03B-01T-0751-13_rnaseq_fastq.tar", "TCGA-AB-2895-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2828-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2928-03A-01T-0740-13_rnaseq_fastq.tar", "TCGA-AB-2873-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2854-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2936-03A-01T-0740-13_rnaseq_fastq.tar", "TCGA-AB-2819-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2856-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2935-03A-01T-0740-13_rnaseq_fastq.tar", "TCGA-AB-2946-03A-01T-0740-13_rnaseq_fastq.tar", "TCGA-AB-2978-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2899-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2933-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2878-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2813-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2815-03A-01T-0734-13_rnaseq_fastq.tar")


amlaug31part2.ids <- amlaug31.46to90ids[(53-45):(90-45)]

amlaug31part2.names <- amlaug31.46to90names[(53-45):(90-45)]

## spotcheck:
## amlaug31part2.ids[16]; amlaug31part2.names[16]
## [1] "57c76cd7e4b0f9890b16d3dc"
## [1] "TCGA-AB-2806-03A-01T-0734-13_rnaseq_fastq.tar"

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = amlaug31part2.names, tarfileids = amlaug31part2.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata"))

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = amlaug31part2.names, tarfileids = amlaug31part2.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata"))











######################################################################
## gbmsep5  machete-new-glm-script  machete-light
##  65 files
## 
######################################################################


## split up lines so don't run afoul of R maximum line length issue
tt1 <- c("57cdb5bee4b0f5e3020fd524", "57cdb5bfe4b0f5e3020fd526", "57cdb5bfe4b0f5e3020fd528", "57cdb5c0e4b0f5e3020fd52a", "57cdb5c0e4b0f5e3020fd52c", "57cdb5c0e4b0f5e3020fd52e", "57cdb5c1e4b0f5e3020fd530", "57cdb5c1e4b0f5e3020fd532", "57cdb5c2e4b0f5e3020fd534", "57cdb5c2e4b0f5e3020fd536", "57cdb5c3e4b0f5e3020fd538", "57cdb5c3e4b0f5e3020fd53a", "57cdb5c3e4b0f5e3020fd53c", "57cdb5c4e4b0f5e3020fd53e", "57cdb5c4e4b0f5e3020fd540", "57cdb5c5e4b0f5e3020fd542", "57cdb5c5e4b0f5e3020fd544", "57cdb5c6e4b0f5e3020fd546", "57cdb5c6e4b0f5e3020fd548", "57cdb5c6e4b0f5e3020fd54a", "57cdb5c7e4b0f5e3020fd54c", "57cdb5c7e4b0f5e3020fd54e", "57cdb5c8e4b0f5e3020fd550", "57cdb5c8e4b0f5e3020fd552", "57cdb5c8e4b0f5e3020fd554", "57cdb5c9e4b0f5e3020fd556", "57cdb5c9e4b0f5e3020fd558", "57cdb5cae4b0f5e3020fd55a", "57cdb5cae4b0f5e3020fd55c", "57cdb5cbe4b0f5e3020fd55e", "57cdb5cbe4b0f5e3020fd560", "57cdb5cbe4b0f5e3020fd562")
tt2 <- c("57cdb5cce4b0f5e3020fd564", "57cdb5cce4b0f5e3020fd566", "57cdb5cde4b0f5e3020fd568", "57cdb5cde4b0f5e3020fd56a", "57cdb5cee4b0f5e3020fd56c", "57cdb5cee4b0f5e3020fd56e", "57cdb5cfe4b0f5e3020fd570", "57cdb5cfe4b0f5e3020fd572", "57cdb5d0e4b0f5e3020fd574", "57cdb5d0e4b0f5e3020fd576", "57cdb5d0e4b0f5e3020fd578", "57cdb5d1e4b0f5e3020fd57a", "57cdb5d1e4b0f5e3020fd57c", "57cdb5d2e4b0f5e3020fd57e", "57cdb5d2e4b0f5e3020fd580", "57cdb5d2e4b0f5e3020fd582", "57cdb5d3e4b0f5e3020fd584", "57cdb5d3e4b0f5e3020fd586", "57cdb5d4e4b0f5e3020fd588", "57cdb5d4e4b0f5e3020fd58a", "57cdb5d5e4b0f5e3020fd58c", "57cdb5d5e4b0f5e3020fd58e", "57cdb5d6e4b0f5e3020fd590", "57cdb5d6e4b0f5e3020fd592", "57cdb5d6e4b0f5e3020fd594", "57cdb5d7e4b0f5e3020fd596", "57cdb5d7e4b0f5e3020fd598", "57cdb5d8e4b0f5e3020fd59a", "57cdb5d8e4b0f5e3020fd59c", "57cdb5d8e4b0f5e3020fd59e", "57cdb5d9e4b0f5e3020fd5a0", "57cdb5d9e4b0f5e3020fd5a2", "57cdb5dae4b0f5e3020fd5a4")
gbmsep5.ids <- c(tt1, tt2)

uu1 <- c("G17805.TCGA-14-0781-01B-01R-1849-01.4.tar.gz", "G17666.TCGA-06-5415-01A-01R-1849-01.2.tar.gz", "G17492.TCGA-27-1834-01A-01R-1850-01.2.tar.gz", "G17223.TCGA-06-0750-01A-01R-1849-01.2.tar.gz", "G17648.TCGA-41-3915-01A-01R-1850-01.2.tar.gz", "G17808.TCGA-76-4926-01B-01R-1850-01.4.tar.gz", "G17217.TCGA-06-0749-01A-01R-1849-01.2.tar.gz", "G17787.TCGA-26-5139-01A-01R-1850-01.4.tar.gz", "G17802.TCGA-28-5208-01A-01R-1850-01.4.tar.gz", "G17651.TCGA-19-1390-01A-01R-1850-01.2.tar.gz", "G17661.TCGA-26-5133-01A-01R-1850-01.2.tar.gz", "G17819.TCGA-26-1442-01A-01R-1850-01.4.tar.gz", "G17649.TCGA-12-5299-01A-02R-1849-01.2.tar.gz", "G17672.TCGA-06-5416-01A-01R-1849-01.2.tar.gz", "G17234.TCGA-06-0686-01A-01R-1849-01.2.tar.gz", "G17784.TCGA-76-4929-01A-01R-1850-01.4.tar.gz", "G17809.TCGA-06-5410-01A-01R-1849-01.4.tar.gz", "G17204.TCGA-08-0386-01A-01R-1849-01.2.tar.gz", "G17227.TCGA-06-0238-01A-02R-1849-01.2.tar.gz", "G17634.TCGA-19-2625-01A-01R-1850-01.2.tar.gz", "G17678.TCGA-06-5417-01A-01R-1849-01.2.tar.gz", "G17813.TCGA-76-4927-01A-01R-1850-01.4.tar.gz", "G17804.TCGA-06-5408-01A-01R-1849-01.4.tar.gz", "G17502.TCGA-14-0871-01A-01R-1849-01.2.tar.gz", "G17205.TCGA-06-0745-01A-01R-1849-01.2.tar.gz", "G17473.TCGA-14-1034-01A-01R-1849-01.2.tar.gz")
uu2 <-c("G17193.TCGA-06-0743-01A-01R-1849-01.2.tar.gz", "G17501.TCGA-27-2528-01A-01R-1850-01.2.tar.gz", "G17482.TCGA-06-2570-01A-01R-1849-01.2.tar.gz", "G17676.TCGA-41-2571-01A-01R-1850-01.2.tar.gz", "G17209.TCGA-06-0219-01A-01R-1849-01.2.tar.gz", "G17646.TCGA-32-2615-01A-01R-1850-01.2.tar.gz", "G17790.TCGA-06-5856-01A-01R-1849-01.4.tar.gz", "G17799.TCGA-06-1804-01A-01R-1849-01.4.tar.gz", "G17785.TCGA-06-5413-01A-01R-1849-01.4.tar.gz", "G17499.TCGA-06-2563-01A-01R-1849-01.2.tar.gz", "G17509.TCGA-14-1829-01A-01R-1850-01.2.tar.gz", "G17782.TCGA-26-5136-01B-01R-1850-01.4.tar.gz", "G17818.TCGA-06-5412-01A-01R-1849-01.4.tar.gz", "G17471.TCGA-27-2519-01A-01R-1850-01.2.tar.gz", "G17211.TCGA-06-0747-01A-01R-1849-01.2.tar.gz", "G17470.TCGA-06-2567-01A-01R-1849-01.2.tar.gz", "G17208.TCGA-06-0187-01A-01R-1849-01.2.tar.gz", "G17632.TCGA-28-1753-01A-01R-1850-01.2.tar.gz", "G17812.TCGA-28-5213-01A-01R-1850-01.4.tar.gz", "G17814.TCGA-06-5411-01A-01R-1849-01.4.tar.gz", "G17800.TCGA-06-5859-01A-01R-1849-01.4.tar.gz", "G17810.TCGA-15-1444-01A-02R-1850-01.4.tar.gz", "G17657.TCGA-19-1787-01B-01R-1850-01.2.tar.gz", "G17796.TCGA-41-5651-01A-01R-1850-01.4.tar.gz", "G17505.TCGA-06-2564-01A-01R-1849-01.2.tar.gz", "G17658.TCGA-32-2632-01A-01R-1850-01.2.tar.gz", "G17224.TCGA-06-0139-01A-01R-1849-01.2.tar.gz", "G17233.TCGA-06-0644-01A-02R-1849-01.2.tar.gz", "G17213.TCGA-06-0157-01A-01R-1849-01.2.tar.gz", "G17662.TCGA-32-1970-01A-01R-1850-01.2.tar.gz", "G17656.TCGA-28-2514-01A-02R-1850-01.2.tar.gz", "G17202.TCGA-06-0184-01A-01R-1849-01.2.tar.gz", "G17216.TCGA-12-0618-01A-01R-1849-01.2.tar.gz", "G17640.TCGA-19-2629-01A-01R-1850-01.2.tar.gz", "G17508.TCGA-16-0846-01A-01R-1850-01.2.tar.gz", "G17792.TCGA-28-5204-01A-01R-1850-01.4.tar.gz", "G17490.TCGA-14-0789-01A-01R-1849-01.2.tar.gz", "G17497.TCGA-14-1823-01A-01R-1849-01.2.tar.gz", "G17504.TCGA-02-2485-01A-01R-1849-01.2.tar.gz")

gbmsep5.names <- c(uu1, uu2)

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = gbmsep5.names, tarfileids = gbmsep5.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata"))

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = gbmsep5.names, tarfileids = gbmsep5.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata"))










##############################################
## part 3: 
## amlaug31part3 - first two of amlaug31part1, used for
##    test of downloading knife text files

amlaug31part3.ids <- c("57c76cb0e4b0f9890b16d356", "57c76cb1e4b0f9890b16d358")

amlaug31part3.names <- c("TCGA-AB-2817-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2955-03A-01T-0734-13_rnaseq_fastq.tar")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = amlaug31part3.names, tarfileids = amlaug31part3.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata"))

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = amlaug31part3.names, tarfileids = amlaug31part3.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata"))




######################################################################
## pancsep7  machete-new-glm-script  machete-light
##  65 files
## 
######################################################################


## split up lines so don't run afoul of R maximum line length issue
tt1 <- c("5780417fe4b00a112012bf12", "5780417fe4b00a112012be58", "5780417fe4b00a112012bf34", "5780417fe4b00a112012beee", "5780417fe4b00a112012be6a", "5780417fe4b00a112012be3b", "5780417fe4b00a112012be20", "57804180e4b00a112012bf58", "5775a4e2e4b03bb2bc27298c", "5780417fe4b00a112012bf0f", "5780417fe4b00a112012bea9", "57804180e4b00a112012bf5a", "57804180e4b00a112012bf51", "5780417fe4b00a112012bea3", "5780417fe4b00a112012be24", "5780417fe4b00a112012be56", "5780417fe4b00a112012be96", "5775a4e2e4b03bb2bc272987", "5780417fe4b00a112012befc", "5780417fe4b00a112012be46", "5780417fe4b00a112012be28", "5780417fe4b00a112012be5a", "57804180e4b00a112012bf56", "57804180e4b00a112012bf46", "5780417fe4b00a112012bee8", "5780417fe4b00a112012bf0c", "5780417be4b00a112012bdfc", "5780417fe4b00a112012be42", "5780417fe4b00a112012bed2", "5780417fe4b00a112012be92", "5780417fe4b00a112012bea8", "57804180e4b00a112012bf54", "5780417fe4b00a112012bed6", "57804180e4b00a112012bf60", "5780417fe4b00a112012be78", "5780417fe4b00a112012bf2c") 
tt2 <- c("5780417fe4b00a112012be1e", "5780417ce4b00a112012be02", "5780417fe4b00a112012bf36", "5780417fe4b00a112012beb0", "5780417fe4b00a112012be7c", "5780417fe4b00a112012be30", "5780417fe4b00a112012bebc", "5780417fe4b00a112012be74", "57804172e4b00a112012bdf8", "57804172e4b00a112012bdf4", "5780417fe4b00a112012bf14", "5780417ce4b00a112012be06", "5780417fe4b00a112012be80", "57804172e4b00a112012bdfa", "57804180e4b00a112012bf40", "5780417fe4b00a112012beda", "5780417fe4b00a112012beba", "5780417fe4b00a112012be48", "5780417fe4b00a112012be2c", "5780417fe4b00a112012be90", "5780417fe4b00a112012bf01", "5780417fe4b00a112012bee0", "5780417fe4b00a112012be7e", "57804172e4b00a112012bdf5", "5780417fe4b00a112012bf18", "5780417fe4b00a112012be2e", "5780417fe4b00a112012be52", "5780417fe4b00a112012bf31", "5780417fe4b00a112012be6c", "5780417ce4b00a112012be0a", "5780417fe4b00a112012bec3", "5780417fe4b00a112012bf28", "5775a4e2e4b03bb2bc272989", "5780417fe4b00a112012bea6")
pancsep7.ids <- c(tt1, tt2)
length(pancsep7.ids)

## c("UNCID_2650387.90761efe-5691-4b39-ae34-c586c0293816.140603_UNC15-SN850_0368_AC4GHHACXX_6_TGACCA.tar.gz", "UNCID_2641181.cf245652-8ced-4d0a-8838-98e5bba556e6.140828_UNC11-SN627_0379_BC5FDFACXX_1_ATCACG.tar.gz", "UNCID_2187525.49daff5e-1e6b-4e22-85e6-d828dbd94fca.120820_UNC15-SN850_0229_AD13JBACXX_6_GATCAG.tar.gz", "UNCID_2650771.557c5369-74e7-4610-badc-922a6a467d73.140611_UNC13-SN749_0355_BC4K53ACXX_3_CGATGT.tar.gz", "UNCID_2187530.a76a8a5d-b85e-4494-9cf6-d6be34d3fdb9.120820_UNC15-SN850_0229_AD13JBACXX_5_TAGCTT.tar.gz", "UNCID_2328718.8fa20d18-8c73-4857-91cb-cf4e6bc180d0.131008_UNC11-SN627_0326_AC2KLPACXX_2_CTTGTA.tar.gz", "UNCID_2521633.6a8e387e-eb2f-49a8-baca-2c81046ad383.140424_UNC12-SN629_0365_AC4368ACXX_8_CTTGTA.tar.gz", "UNCID_2521569.b81dc563-908a-4107-af13-fa70e8c5202f.140506_UNC15-SN850_0363_BC3YJYACXX_1_ACTTGA.tar.gz", "UNCID_2179101.4054bea5-0f95-4fbe-86e2-821f3c0f71b5.130325_UNC16-SN851_0231_BC20VNACXX_3_TGACCA.tar.gz", "UNCID_2641219.36296a46-a401-447f-a01b-060a5444ad40.140710_UNC15-SN850_0376_AC4HV7ACXX_1_TAGCTT.tar.gz", "UNCID_2641218.918a606c-3b19-4292-862c-f8437d00ab00.140721_UNC15-SN850_0379_AC4V28ACXX_8_TGACCA.tar.gz", "UNCID_2521500.a5a14aad-0709-4782-b922-ec8226372af3.140502_UNC12-SN629_0366_AC3UT1ACXX_7_ATCACG.tar.gz", "UNCID_2641216.4e4ce7d0-661e-4663-a7e2-038ab9c44fcf.140821_UNC11-SN627_0377_BC5ERUACXX_6_GTCCGC.tar.gz", "UNCID_2362248.87f5581e-e594-4ea5-a80f-788cbc0247be.131217_UNC15-SN850_0343_AC330UACXX_7_CTTGTA.tar.gz", "UNCID_2186023.9ad4cb9a-b29f-41cc-beab-46fad52897f4.121127_UNC16-SN851_0192_AC0YN3ACXX_3_GTGAAA.tar.gz", "UNCID_2520706.22b6124f-dc14-4221-96a0-74cbc6236cf2.140516_UNC12-SN629_0369_AC4GGKACXX_5_CGTACG.tar.gz", "UNCID_2187815.a7519980-7225-4e6e-b0d3-cbbd7a61afda.120730_UNC14-SN744_0252_BC0VLGACXX_2_ATCACG.tar.gz", "UNCID_2179131.ba050b6a-1b01-494c-8efc-ab0bd107a724.130325_UNC16-SN851_0231_BC20VNACXX_1_CAGATC.tar.gz", "UNCID_2331504.1643e566-9e21-4231-85bf-a663df99119c.130930_UNC12-SN629_0331_BD2F2JACXX_4_CAGATC.tar.gz", "UNCID_2179641.1cdadacf-34ad-464a-9faa-d501e2caab06.130319_UNC12-SN629_0267_BC22Y1ACXX_2_GCCAAT.tar.gz", "UNCID_2187844.7accb08d-acdb-46bc-bf7f-b9f678193115.120730_UNC14-SN744_0252_BC0VLGACXX_1_ATCACG.tar.gz", "UNCID_2641176.435de9a0-3c2b-4b4f-87d1-92f37a0765b5.140828_UNC11-SN627_0379_BC5FDFACXX_7_ACTGAT.tar.gz", "UNCID_2328562.3648cb64-1da6-455b-8259-95574dde606f.131008_UNC11-SN627_0326_AC2KLPACXX_5_CTTGTA.tar.gz", "UNCID_2650624.b99146ef-3f38-42f4-aa4b-08543a5ae7d9.140603_UNC15-SN850_0369_BC4H6YACXX_4_CCGTCC.tar.gz", "UNCID_2479338.bd94eed7-220d-4a0f-a09b-17a90c5545e7.140318_UNC14-SN744_0403_AC3M3WACXX_8_GTCCGC.tar.gz", "UNCID_2641171.d7b71b54-934d-4c8e-bf39-c5dc66265739.140908_UNC11-SN627_0380_AC58DMACXX_5_CTTGTA.tar.gz", "UNCID_2328645.2e691339-21b8-452d-a399-41247febd91f.131008_UNC11-SN627_0326_AC2KLPACXX_2_CAGATC.tar.gz", "UNCID_2358883.b8032c8e-4a6d-403a-837e-0ecafe3001e0.140102_UNC15-SN850_0344_AC384WACXX_3_TTAGGC.tar.gz", "UNCID_2641129.79779bb1-b381-4d71-8821-83b82533c47c.140908_UNC11-SN627_0380_AC58DMACXX_5_AGTCAA.tar.gz", "UNCID_2641132.d1b4d16a-0198-4b4e-94c8-d36c555f8858.140908_UNC11-SN627_0380_AC58DMACXX_1_ATCACG.tar.gz", "UNCID_2185892.e867a2e9-dd1a-4da5-b786-1df0e5352030.121126_UNC9-SN296_0314_BC11Y0ACXX_8_CTTGTA.tar.gz", "UNCID_2329051.29499c48-d9ce-4f3a-a1be-eeb3f60c3b97.131008_UNC11-SN627_0326_AC2KLPACXX_1_TGACCA.tar.gz", "UNCID_2641180.e998f821-2f01-480b-a3f4-9a7dbb4ad7be.140828_UNC11-SN627_0379_BC5FDFACXX_5_AGTCAA.tar.gz", "UNCID_2327184.329903de-677b-453d-a2be-00f59bc22184.131021_UNC9-SN296_0409_BC2M6NACXX_6_GGCTAC.tar.gz", "UNCID_2187813.6e7c5435-acde-4de9-a8bc-bb912a208756.120730_UNC14-SN744_0252_BC0VLGACXX_8_ATCACG.tar.gz", "UNCID_2187553.c3ad6e29-a29b-4090-85ac-2d349ae487ed.120820_UNC15-SN850_0229_AD13JBACXX_1_TAGCTT.tar.gz", "UNCID_2187796.aaf4883f-911b-4a55-a271-e197b2ca6ab6.120730_UNC14-SN744_0252_BC0VLGACXX_8_TTAGGC.tar.gz", "UNCID_2520698.d637192a-b7cc-4791-a3ac-318519c9e262.140521_UNC13-SN749_0354_BC4GJ7ACXX_3_ACTGAT.tar.gz", "UNCID_2641137.98498920-e1fe-447a-929f-ff975eef9c32.140828_UNC11-SN627_0379_BC5FDFACXX_6_ATGTCA.tar.gz", "UNCID_2187471.34d78c1c-7631-4546-89e1-60f4eb9bf12c.120823_UNC14-SN744_0266_BD12TFACXX_8_GGCTAC.tar.gz", "UNCID_2185966.dbac085b-714a-408e-9e7f-cf0f5d79d52f.121127_UNC16-SN851_0192_AC0YN3ACXX_2_CCGTCC.tar.gz", "UNCID_2362772.edaedcb6-1b6b-4e9a-8c8b-a7880dd95495.131217_UNC15-SN850_0343_AC330UACXX_4_ATGTCA.tar.gz", "UNCID_2479110.b2323204-612b-44a0-a268-ac8f07f01462.140404_UNC11-SN627_0350_BC3K66ACXX_5_TTAGGC.tar.gz", "UNCID_2650646.acb2a050-f12f-4a83-8c9e-5e69afcfdd66.140603_UNC15-SN850_0369_BC4H6YACXX_1_GTGAAA.tar.gz", "UNCID_2520703.e6193af8-e8a4-4af7-8279-59f46c5502ba.140603_UNC15-SN850_0369_BC4H6YACXX_1_ACAGTG.tar.gz", "UNCID_2187370.bebddc30-e74e-426f-b5f8-ba739b8db54f.120910_UNC10-SN254_0376_AC10HBACXX_7_GGCTAC.tar.gz", "UNCID_2641182.9725eda0-0a92-463c-bc35-bc7e673914cb.140828_UNC11-SN627_0378_AC5FAWACXX_6_CCGTCC.tar.gz", "UNCID_2641215.6e7b59c2-e4a6-4e28-b2a7-4ef6787347b9.140821_UNC11-SN627_0377_BC5ERUACXX_6_ATGTCA.tar.gz", "UNCID_2650805.fb3c0c98-a0f4-43d0-be73-4f4007723507.140611_UNC13-SN749_0355_BC4K53ACXX_1_ATGTCA.tar.gz", "UNCID_2521476.3ee96f1d-ae1d-4725-a70d-ccd8fb4dc413.140509_UNC12-SN629_0368_BC4241ACXX_2_CGATGT.tar.gz", "UNCID_2187534.d41e3959-2f2c-4c5e-a79b-3869d0f60485.120820_UNC15-SN850_0229_AD13JBACXX_7_TAGCTT.tar.gz", "UNCID_2521635.f23c75c7-8065-4718-b93c-5b8bc77391fa.140424_UNC12-SN629_0365_AC4368ACXX_5_ACTTGA.tar.gz", "UNCID_2327200.c0e22978-a96f-4b2d-bbad-b702817a00df.131015_UNC11-SN627_0328_BC2NN6ACXX_4_CAGATC.tar.gz", "UNCID_2641187.69c20a0f-f982-4974-b4ba-88b1cb9d72e5.140828_UNC11-SN627_0378_AC5FAWACXX_5_AGTCAA.tar.gz", "UNCID_2641213.23da230e-1c63-4e5b-bf92-8a1bec33073c.140826_UNC9-SN296_0432_AC5CAJACXX_1_AGTCAA.tar.gz", "UNCID_2520702.3d8d1b81-2fd0-4170-9a6c-f7aef5af5446.140603_UNC15-SN850_0369_BC4H6YACXX_5_TTAGGC.tar.gz", "UNCID_2641130.bf71da3a-93c2-450a-aa78-b95ae34d285a.140908_UNC11-SN627_0380_AC58DMACXX_2_TTAGGC.tar.gz", "UNCID_2329052.6fa6cf43-bd3f-47bc-b95d-a6a805f64517.131008_UNC15-SN850_0331_AC2KJ8ACXX_8_AGTCAA.tar.gz", "UNCID_2648871.ac2b7bb6-0d88-49ab-8812-2cb71acec8bf.140625_UNC11-SN627_0364_AC4HLGACXX_6_CGTACG.tar.gz", "UNCID_2648865.7593746a-940c-4867-97b7-35fbe564d57d.140625_UNC11-SN627_0364_AC4HLGACXX_8_ACTTGA.tar.gz", "UNCID_2187522.b36262a1-0c6b-4112-b690-3e8d508f3415.120820_UNC15-SN850_0229_AD13JBACXX_7_GATCAG.tar.gz", "UNCID_2479350.0f074dc4-7b72-4670-ba09-55ad645b394b.140318_UNC12-SN629_0354_AC3K7VACXX_7_AGTTCC.tar.gz", "UNCID_2187807.9715811a-fe94-4991-b850-5d50793de443.120730_UNC14-SN744_0252_BC0VLGACXX_5_TTAGGC.tar.gz", "UNCID_2479333.42285149-d0bc-418b-8802-ad59565516a0.140325_UNC11-SN627_0349_AC3KB8ACXX_1_ACTTGA.tar.gz", "UNCID_2520712.563461ba-d9db-4b4a-8e43-ef420422f6f1.140516_UNC12-SN629_0369_AC4GGKACXX_1_ACAGTG.tar.gz", "UNCID_2641138.9692d44e-91d7-430b-a72d-c720062f7274.140828_UNC11-SN627_0379_BC5FDFACXX_5_AGTTCC.tar.gz", "UNCID_2329176.a19584d8-e215-40aa-8284-78a1b4a5cf9b.131008_UNC15-SN850_0331_AC2KJ8ACXX_8_CTTGTA.tar.gz", "UNCID_2650752.ecd432eb-db83-4987-b252-4765d83c3b55.140611_UNC13-SN749_0355_BC4K53ACXX_4_GTCCGC.tar.gz", "UNCID_2179043.6cc98e3f-c0ff-4c3c-992a-c717393c13bb.130325_UNC16-SN851_0231_BC20VNACXX_4_CGATGT.tar.gz", "UNCID_2641131.a0f29436-5ded-49e0-803e-847d7c2f0b23.140908_UNC11-SN627_0380_AC58DMACXX_1_CGATGT.tar.gz")


pancsep7.names <- scan(file = file.path(homedir, "pancsep7.names.csv"), sep=",", what = "character", strip.white = TRUE)
## check:
## pancsep7.ids[16]; pancsep7.names[16]
## [1] "5780417fe4b00a112012be56"
## [1] " UNCID_2520706.22b6124f-dc14-4221-96a0-74cbc6236cf2.140516_UNC12-SN629_0369_AC4GGKACXX_5_CGTACG.tar.gz"

                          

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = pancsep7.names, tarfileids = pancsep7.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata"))

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = pancsep7.names, tarfileids = pancsep7.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata"))




######################################################################
## bladdersep8  machete-new-glm-script  machete-light
##  22 files
## 
######################################################################


## split up lines so don't run afoul of R maximum line length issue
bladdersep8.ids <- c("57d1e008e4b0f5e302110b33", "57d1e008e4b0f5e302110b35", "57d1e009e4b0f5e302110b37", "57d1e009e4b0f5e302110b39", "57d1e00ae4b0f5e302110b3b", "57d1e00ae4b0f5e302110b3d", "57d1e00ae4b0f5e302110b3f", "57d1e00be4b0f5e302110b41", "57d1e00be4b0f5e302110b43", "57d1e00ce4b0f5e302110b45", "57d1e00ce4b0f5e302110b47", "57d1e00ce4b0f5e302110b49", "57d1e00de4b0f5e302110b4b", "57d1e00de4b0f5e302110b4d", "57d1e00ee4b0f5e302110b4f", "57d1e00ee4b0f5e302110b51", "57d1e00ee4b0f5e302110b53", "57d1e00fe4b0f5e302110b55", "57d1e00fe4b0f5e302110b57", "57d1e010e4b0f5e302110b59", "57d1e010e4b0f5e302110b5b", "57d1e010e4b0f5e302110b5d")

uu1 <- c("UNCID_2328597.3833acbb-2ea2-4442-90af-6b009ae2543b.131008_UNC11-SN627_0326_AC2KLPACXX_1_CAGATC.tar.gz", "UNCID_2331366.088b27e8-38f6-41ff-a861-d371415fd7f0.131008_UNC15-SN850_0331_AC2KJ8ACXX_2_GCCAAT.tar.gz", "UNCID_2196751.968143b4-2bc1-4c77-88e7-a907a7cd018c.120207_UNC10-SN254_0325_AC0C6MACXX_8_TAGCTT.tar.gz", "UNCID_2187853.66132B23-E10A-49D9-89C5-129D7D98C17B.120723_UNC10-SN254_0372_AC0T70ACXX_2_ATCACG.tar.gz", "UNCID_2198660.d22b6ef3-9b08-44d9-b37f-e7f61ce89404.120110_UNC13-SN749_0142_BD0HK1ACXX_8_ATCACG.tar.gz", "UNCID_2187848.DAFC2AF2-7B91-45A4-AE67-FE22AB060F06.120723_UNC10-SN254_0372_AC0T70ACXX_3_TTAGGC.tar.gz", "UNCID_2257948.159e6f18-943e-4e7b-af13-da273c52dc16.130807_UNC12-SN629_0325_BD2BD7ACXX_3_ACTTGA.tar.gz", "UNCID_2198590.5b0896f2-8fd9-42ee-b56d-b140f8d8657e.120118_UNC12-SN629_0180_BC0BWMACXX_2_TAGCTT.tar.gz", "UNCID_2188007.BD1BA628-0CB5-4103-BAA4-3F430D24D359.120724_UNC14-SN744_0249_AC0T3HACXX_7_TTAGGC.tar.gz", "UNCID_2641062.f29aacd1-503d-4f56-8faa-2ba309ce4f23.140603_UNC11-SN627_0361_BC4K54ACXX_2_GGCTAC.tar.gz") 
uu2 <- c("UNCID_2324332.fe6853dd-864f-4257-869f-a425aab32346.131016_UNC10-SN254_0498_BC2KTUACXX_6_GATCAG.tar.gz", "UNCID_2178805.dbffd0f0-d063-45a2-8cdb-e6ffa6c9e66d.130325_UNC12-SN629_0268_AC22W1ACXX_5_GTTTCG.tar.gz", "UNCID_2185898.10e3d6b9-8f72-4902-94ca-f89811b98e35.121126_UNC9-SN296_0314_BC11Y0ACXX_6_ACTGAT.tar.gz", "UNCID_2580868.1dac1d16-2bc6-44db-b05a-30e8f2fb703f.140513_UNC15-SN850_0365_BC4BYLACXX_5_GCCAAT.tar.gz", "UNCID_2188079.024BC00E-0419-4DC6-8DF4-AD3AF476314D.120724_UNC14-SN744_0249_AC0T3HACXX_2_CTTGTA.tar.gz", "UNCID_2443810.7fe70e80-a35e-4a3d-bfb5-e044aec3e6a2.140312_UNC11-SN627_0348_AC3KRYACXX_1_CGATGT.tar.gz", "UNCID_2178570.90c55ddf-3ac3-4599-80f6-e29e486d2070.130402_UNC11-SN627_0289_AD22HMACXX_4_GATCAG.tar.gz", "UNCID_2332590.f36d565e-7fea-4fae-87b2-70d7e75b36ef.130718_UNC12-SN629_0321_AC2E6WACXX_7_ATGTCA.tar.gz", "UNCID_2661052.f18b7d09-aace-4a7e-839a-6f6eeb189f63.140611_UNC11-SN627_0362_BC4K5NACXX_2_CAGATC.tar.gz", "UNCID_2188211.C7F36DBA-A507-46D3-8E68-7F98B8B645E9.120717_UNC14-SN744_0245_AC0WYWACXX_4_TAGCTT.tar.gz", "UNCID_2193634.4c4fbc19-727b-48b0-82e0-42ca8309f315.120409_UNC14-SN744_0226_AC0M8NACXX_3_GGCTAC.tar.gz", "UNCID_2581547.689c1593-3903-4c82-9cb1-1471d8bca178.140513_UNC15-SN850_0364_AC4DVGACXX_1_ATCACG.tar.gz")

bladdersep8.names <- c(uu1, uu2)

## check:
## bladdersep8.ids[14]; bladdersep8.names[14]

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = bladdersep8.names, tarfileids = bladdersep8.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata"))

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = bladdersep8.names, tarfileids = bladdersep8.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata"))  ## RESUMING




######################################################################
## gliomasep9  machete-new-glm-script  machete-light
##  22 files
## 
######################################################################

todaydate <- "sep9"
shortname <- "glioma"
longname <- "Brain Lower Grade Glioma"





groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


nice.ids.file = file.path(fileinfodir,paste0(shortname, ".nice.ids.", todaydate, ".csv"))
nice.names.file = file.path(fileinfodir,paste0(shortname, ".nice.names.", todaydate, ".csv"))


## scan in so don't run afoul of R maximum line length issue
these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)

these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)

## check:
cat("glfid ", these.ids[14], "\n", these.names[14], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata"))

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata"))















######################################################################
## cervicalsep9  machete-new-glm-script  machete-light
##  22 files
## 
######################################################################

todaydate <- "sep9"
shortname <- "cervical"
longname <- "Cervical Squamous Cell Carcinoma and Endocervical Adenocarcinoma"





groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


nice.ids.file = file.path(fileinfodir,paste0(shortname, ".nice.ids.", todaydate, ".csv"))
nice.names.file = file.path(fileinfodir,paste0(shortname, ".nice.names.", todaydate, ".csv"))


## scan in so don't run afoul of R maximum line length issue
these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)

these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)

## check:
cat("glfid ", these.ids[14], "\n", these.names[14], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata"))

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING









######################################################################
## esophagussep9  machete-new-glm-script  machete-light
##  22 files
## 
######################################################################

todaydate <- "sep9"
shortname <- "esophagus"
longname <- "Esophageal Carcinoma"





groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


nice.ids.file = file.path(fileinfodir,paste0(shortname, ".nice.ids.", todaydate, ".csv"))
nice.names.file = file.path(fileinfodir,paste0(shortname, ".nice.names.", todaydate, ".csv"))


## scan in so don't run afoul of R maximum line length issue
these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)

these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)

## check:
cat("glfid ", these.ids[14], "\n", these.names[14], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata"))

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata"))



######################################################################
## headnecksep10  machete-new-glm-script  machete-light
##  22 files
## 
######################################################################

todaydate <- "sep10"
shortname <- "headneck"
longname <- "Head and Neck Squamous Cell Carcinoma"





groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


nice.ids.file = file.path(fileinfodir,paste0(shortname, ".nice.ids.", todaydate, ".csv"))
nice.names.file = file.path(fileinfodir,paste0(shortname, ".nice.names.", todaydate, ".csv"))


## scan in so don't run afoul of R maximum line length issue
these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)

these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)

## check:
cat("glfid ", these.ids[14], "\n", these.names[14], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata"))

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING


######################################################################
## kidneychromophobesep10  machete-new-glm-script  machete-light
##  22 files
## 
######################################################################

todaydate <- "sep10"
shortname <- "kidneychromophobe"
longname <- "Kidney Chromophobe"



groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


nice.ids.file = file.path(fileinfodir,paste0(shortname, ".nice.ids.", todaydate, ".csv"))
nice.names.file = file.path(fileinfodir,paste0(shortname, ".nice.names.", todaydate, ".csv"))


## scan in so don't run afoul of R maximum line length issue
these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)

these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)

## check:
cat("glfid ", these.ids[14], "\n", these.names[14], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
## comment on end helps to easily identify the command when looking
##  at command history
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## comment on end helps to easily identify the command when looking
##  at command history
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING









######################################################################
## kidneyrenalclearsep11  machete-new-glm-script  machete-light
##  22 files
## 
######################################################################

todaydate <- "sep11"
shortname <- "kidneyrenalclear"
longname <- "Kidney Renal Clear Cell Carcinoma"



groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


nice.ids.file = file.path(fileinfodir,paste0(shortname, ".nice.ids.", todaydate, ".csv"))
nice.names.file = file.path(fileinfodir,paste0(shortname, ".nice.names.", todaydate, ".csv"))


## scan in so don't run afoul of R maximum line length issue
these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)

these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)

## check:
cat("glfid ", these.ids[14], "\n", these.names[14], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
## comment on end helps to easily identify the command when looking
##  at command history
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## comment on end helps to easily identify the command when looking
##  at command history
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING












######################################################################
## kidneyrenalpapillarysep11  machete-new-glm-script  machete-light
##  22 files
## 
######################################################################

todaydate <- "sep11"
shortname <- "kidneyrenalpapillary"
longname <- "Kidney Renal Papillary Cell Carcinoma"



groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


nice.ids.file = file.path(fileinfodir,paste0(shortname, ".nice.ids.", todaydate, ".csv"))
nice.names.file = file.path(fileinfodir,paste0(shortname, ".nice.names.", todaydate, ".csv"))


## scan in so don't run afoul of R maximum line length issue
these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)

these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)

## check:
cat("glfid ", these.ids[14], "\n", these.names[14], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
## comment on end helps to easily identify the command when looking
##  at command history
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## comment on end helps to easily identify the command when looking
##  at command history
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING







######################################################################
## liversep11  machete-new-glm-script  machete-light
##  22 files
## 
######################################################################

todaydate <- "sep11"
shortname <- "liver"
longname <- "Liver Hepatocellular Carcinoma"




groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


nice.ids.file = file.path(fileinfodir,paste0(shortname, ".nice.ids.", todaydate, ".csv"))
nice.names.file = file.path(fileinfodir,paste0(shortname, ".nice.names.", todaydate, ".csv"))


## scan in so don't run afoul of R maximum line length issue
these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)

these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)

## check:
cat("glfid ", these.ids[14], "\n", these.names[14], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
## comment on end helps to easily identify the command when looking
##  at command history
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## comment on end helps to easily identify the command when looking
##  at command history
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING

















######################################################################
## sarcomasep11  machete-new-glm-script  machete-light
##  22 files
## 
######################################################################

todaydate <- "sep11"
shortname <- "sarcoma"
longname <- "Sarcoma"




groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


nice.ids.file = file.path(fileinfodir,paste0(shortname, ".nice.ids.", todaydate, ".csv"))
nice.names.file = file.path(fileinfodir,paste0(shortname, ".nice.names.", todaydate, ".csv"))


## scan in so don't run afoul of R maximum line length issue
these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)

these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)

## check:
cat("glfid ", these.ids[14], "\n", these.names[14], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
## comment on end helps to easily identify the command when looking
##  at command history
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## comment on end helps to easily identify the command when looking
##  at command history
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING











######################################################################
## skinsep11  machete-new-glm-script  machete-light
##  22 files
## 
######################################################################

todaydate <- "sep11"
shortname <- "skin"
longname <- "Skin Cutaneous Melanoma"




groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


nice.ids.file = file.path(fileinfodir,paste0(shortname, ".nice.ids.", todaydate, ".csv"))
nice.names.file = file.path(fileinfodir,paste0(shortname, ".nice.names.", todaydate, ".csv"))


## scan in so don't run afoul of R maximum line length issue
these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)

these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)

## check:
cat("glfid ", these.ids[14], "\n", these.names[14], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
## comment on end helps to easily identify the command when looking
##  at command history
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## comment on end helps to easily identify the command when looking
##  at command history
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING


######################################################################
## stomachsep11  machete-new-glm-script  machete-light
##  22 files
## 
######################################################################

todaydate <- "sep11"
shortname <- "stomach"
longname <- "Stomach Adenocarcinoma"




groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


nice.ids.file = file.path(fileinfodir,paste0(shortname, ".nice.ids.", todaydate, ".csv"))
nice.names.file = file.path(fileinfodir,paste0(shortname, ".nice.names.", todaydate, ".csv"))


## scan in so don't run afoul of R maximum line length issue
these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)

these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)

## check:
cat("glfid ", these.ids[14], "\n", these.names[14], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
## comment on end helps to easily identify the command when looking
##  at command history
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## comment on end helps to easily identify the command when looking
##  at command history
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING





######################################################################
## colonsep12 machete-new-glm-script  machete-light
##  22 files
##
## NOTE: HAD PROBLEM WITH 2ND TAR FILE B/C IT ONLY HAD ONE FASTQ FILE
##   SO RUNNING BELOW WITHOUT IT
##
## LATER: REMOVED PROBLEMATIC TAR FILES SYSTEMATICALLY,
##   THEN JUST TOOK FIRST 10 OF GOOD ONES, JUST NEED TO GET UP TO 15
##   FROM 11
## 
######################################################################

todaydate <- "sep12"
shortname <- "colon"
longname <- "Colon Adenocarcinoma"





groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


nice.ids.file = file.path(fileinfodir,paste0(shortname, ".nice.ids.", todaydate, ".csv"))
nice.names.file = file.path(fileinfodir,paste0(shortname, ".nice.names.", todaydate, ".csv"))


## scan in so don't run afoul of R maximum line length issue
these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)

these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)

## check:
cat("glfid ", these.ids[14], "\n", these.names[14], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING

####################
# AFTER REMOVING 2nd LINE FROM infofile b/c of problematic tarfile
# with only one fastq file:


todaydate <- "sep12"
shortname <- "colon"
longname <- "Colon Adenocarcinoma"





groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


nice.ids.file = file.path(fileinfodir,paste0(shortname, ".nice.ids.", todaydate, ".csv"))
nice.names.file = file.path(fileinfodir,paste0(shortname, ".nice.names.", todaydate, ".csv"))


## scan in so don't run afoul of R maximum line length issue
these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)

these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)

## NOW DROP THE 2ND ONE
## NOW DROP THE 2ND ONE
## NOW DROP THE 2ND ONE

these.ids <- these.ids[-2]
these.names <- these.names[-2]

## check:
cat("glfid ", these.ids[2], "\n", these.names[2], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING



####################
# AFTER REMOVING 5th LINE FROM 2nd infofile b/c of problematic tarfile
# WITH ONLY ONE FASTQ FILE:
# AND THEN LOOKING SYSTEMATICALLY FOR PROBLEMATIC TAR FILES, FINDING
#  SIX AND THEN RUNNING ONLY 10 OF THOSE REMAINING

todaydate <- "sep12"
shortname <- "colon"
longname <- "Colon Adenocarcinoma"





groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


nice.ids.file = file.path(fileinfodir,paste0(shortname, ".nice.ids.", todaydate, ".csv"))
nice.names.file = file.path(fileinfodir,paste0(shortname, ".nice.names.", todaydate, ".csv"))


## scan in so don't run afoul of R maximum line length issue
these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)

these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)

## NOW DROP THE 2ND ONE
## NOW DROP THE 2ND ONE
## NOW DROP THE 2ND ONE

these.ids <- these.ids[-2]
these.names <- these.names[-2]

## NOW DROP THE ONE THAT IS NOW 5TH
## NOW DROP THE ONE THAT IS NOW 5TH
## NOW DROP THE ONE THAT IS NOW 5TH

these.ids <- these.ids[-5]
these.names <- these.names[-5]

more.indices.to.remove <- which(these.ids %in% c("57d6e5a7e4b05f663c0f457a", "57d6e5a9e4b05f663c0f4584", "57d6e5ade4b05f663c0f4592", "57d6e5aee4b05f663c0f4596"))
more.indices.to.remove

## should be 6,11,18,20

these.ids <- these.ids[-more.indices.to.remove]
these.names <- these.names[-more.indices.to.remove]

these.ids <- these.ids[1:10]
these.names <- these.names[1:10]

## then just take first 10, just need to get up to 15


## check:
cat("glfid ", these.ids[1], "\n", these.names[1], "\n", sep="")
cat("glfid ", these.ids[10], "\n", these.names[10], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING






######################################################################
## brsep12 machete-new-glm-script  machete-light
##  95 files
## 
######################################################################

todaydate <- "sep12"
shortname <- "br"
longname <- "Breast Invasive Carcinoma"





groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


nice.ids.file = file.path(fileinfodir,paste0(shortname, ".nice.ids.", todaydate, ".csv"))
nice.names.file = file.path(fileinfodir,paste0(shortname, ".nice.names.", todaydate, ".csv"))


## scan in so don't run afoul of R maximum line length issue
these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)

these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)

## check:
cat("glfid ", these.ids[14], "\n", these.names[14], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING


## SPECIAL SITUATION: RESUMING AFTER STOP B/C OF CASH LIMIT
##  ONLY RESTARTING SOME OF THEM
##

## read in file names
br.info <- read.table(file = file.path(groupdir,"infofile.csv"), header = TRUE, sep = ",", stringsAsFactors=FALSE)
these.ids <- br.info$id.file
these.names <- br.info$filename
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING





######################################################################
## lungadenosep12 machete-new-glm-script  machete-light
##  80 files
## 
######################################################################

todaydate <- "sep12"
shortname <- "lungadeno"
longname <- "Lung Adenocarcinoma"





groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


nice.ids.file = file.path(fileinfodir,paste0(shortname, ".nice.ids.", todaydate, ".csv"))
nice.names.file = file.path(fileinfodir,paste0(shortname, ".nice.names.", todaydate, ".csv"))


## scan in so don't run afoul of R maximum line length issue
these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)

these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)

## check:
cat("glfid ", these.ids[14], "\n", these.names[14], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING




######################################################################
## lungcellsep12 machete-new-glm-script  machete-light
##  21 files
## 
######################################################################

todaydate <- "sep12"
shortname <- "lungcell"
longname <- "Lung Squamous Cell Carcinoma"





groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


nice.ids.file = file.path(fileinfodir,paste0(shortname, ".nice.ids.", todaydate, ".csv"))
nice.names.file = file.path(fileinfodir,paste0(shortname, ".nice.names.", todaydate, ".csv"))


## scan in so don't run afoul of R maximum line length issue
these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)

these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)

## check:
cat("glfid ", these.ids[14], "\n", these.names[14], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING


######################################################################
## lymphomasep12 machete-new-glm-script  machete-light
##  21 files
##  really started on sep 15
######################################################################

todaydate <- "sep12"
shortname <- "lymphoma"
longname <- "Lymphoid Neoplasm Diffuse Large B-cell Lymphoma"





groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


nice.ids.file = file.path(fileinfodir,paste0(shortname, ".nice.ids.", todaydate, ".csv"))
nice.names.file = file.path(fileinfodir,paste0(shortname, ".nice.names.", todaydate, ".csv"))


## scan in so don't run afoul of R maximum line length issue
these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)

these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)

## check:
cat("glfid ", these.ids[14], "\n", these.names[14], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING







######################################################################
## gliomasep20  machete-new-glm-script  machete-light
##  5 files
## 
######################################################################

todaydate <- "sep20"
shortname <- "glioma"
longname <- "Brain Lower Grade Glioma"





groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


## nice.ids.file = file.path(fileinfodir,paste0(shortname, ".nice.ids.", todaydate, ".csv"))
## nice.names.file = file.path(fileinfodir,paste0(shortname, ".nice.names.", todaydate, ".csv"))


## scan in so don't run afoul of R maximum line length issue
## these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)
## these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)

these.ids <- c("57e1792ee4b05f663c151032", "57e1792fe4b05f663c151034", "57e1792fe4b05f663c151036", "57e17930e4b05f663c151038", "57e17930e4b05f663c15103a") 
these.names <- c("UNCID_2187375.ba1613b5-3076-4fc5-8da0-f0e951d077ef.120910_UNC10-SN254_0377_BD14K4ACXX_7_ACTTGA.tar.gz", "UNCID_2185544.f68cffac-4db9-470c-b726-01fb876a381a.130108_UNC15-SN850_0251_AD1NUNACXX_5_CAGATC.tar.gz", "UNCID_2318837.46bc5230-2912-4e5e-a5c0-7a2f5aa6b682.131112_UNC12-SN629_0335_BC34FKACXX_6_ACAGTG.tar.gz", "UNCID_2366646.6ff9c39a-7992-411e-a14a-631589199c3a.140102_UNC15-SN850_0344_AC384WACXX_4_TGACCA.tar.gz", "UNCID_2258223.f2249fe9-e838-4895-9e46-98fa8f30655e.130606_UNC9-SN296_0372_AC277JACXX_7_CGATGT.tar.gz")




## check:
cat("glfid ", these.ids[2], "\n", these.names[2], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING




######################################################################
## headnecksep21  machete-new-glm-script  machete-light
##  doing 20 more to try to get up to 15
## 
######################################################################

todaydate <- "sep21"
shortname <- "headneck"
longname <- "Head and Neck Squamous Cell Carcinoma"






groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


nice.ids.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.ids.csv"))
nice.names.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.names.csv"))


## scan in so don't run afoul of R maximum line length issue
these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)

these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)

## check:
cat("glfid ", these.ids[14], "\n", these.names[14], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING





######################################################################
## kidneychromophobesep21
## run 3 more to try to get up to 15 from 14
##   machete-new-glm-script  machete-light
## 
## 
######################################################################

todaydate <- "sep21"
shortname <- "kidneychromophobe"
longname <- "Kidney Chromophobe"




groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


## nice.ids.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.ids.csv"))
## nice.names.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.names.csv"))



## scan in so don't run afoul of R maximum line length issue
## these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)
## these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)

these.ids <- c("57e2cf18e4b05f663c159396", "57e2cf18e4b05f663c159398", "57e2cf19e4b05f663c15939a")
these.names <- c("UNCID_2186428.ee8417b7-5d4b-42e7-b0f1-094a9990fda8.121029_UNC15-SN850_0239_AD13T9ACXX_6_CTTGTA.tar.gz", "UNCID_2186038.2a70e115-e2dd-4c26-bd20-b09c58f551c7.121106_UNC11-SN627_0258_AC11WRACXX_6_CCGTCC.tar.gz", "UNCID_2186560.17aa0cc6-c07e-4512-8c0a-e520863a58e4.121029_UNC11-SN627_0257_AC0Y16ACXX_5_ATGTCA.tar.gz") 





## check:
cat("glfid ", these.ids[2], "\n", these.names[2], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING



##################################################################
## kidneyrenalclearsep22
## tumor
##   machete-new-glm-script  machete-light
##################################################################

todaydate <- "sep22"
shortname <- "kidneyrenalclear"
longname <- "Kidney Renal Clear Cell Carcinoma"


groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


## nice.ids.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.ids.csv"))
## nice.names.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.names.csv"))



## scan in so don't run afoul of R maximum line length issue
## these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)
## these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)

these.ids <- c("57e4536be4b05f663c15a724", "57e4536ce4b05f663c15a726", "57e4536ce4b05f663c15a728")
these.names <- c("UNCID_2369416.785bc0fb-25a2-4f44-a897-685faec6f2eb.131210_UNC12-SN629_0339_AC2UJ6ACXX_1_AGTTCC.tar.gz", "UNCID_2203325.a96a9ca8-fefa-42f9-b0bb-1bd238647513.111025_UNC13-SN749_0130_AD0EYTABXX_4_CAGATC.tar.gz", "UNCID_2206577.65c2eee5-e7bb-40db-9a59-43c6f9bf2220.110926_UNC16-SN851_0092_BD0E5BABXX_6_TTAGGC.tar.gz")





## check:
cat("glfid ", these.ids[2], "\n", these.names[2], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING





##



##################################################################
## kidneyrenalpapillarysep22
## tumor
##   machete-new-glm-script  machete-light
##################################################################

todaydate <- "sep22"
shortname <- "kidneyrenalpapillary"
longname <- "Kidney Renal Papillary Cell Carcinoma"


groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


## nice.ids.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.ids.csv"))
## nice.names.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.names.csv"))



## scan in so don't run afoul of R maximum line length issue
## these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)
## these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)

these.ids <- c("57e455c5e4b05f663c15a72a", "57e455c6e4b05f663c15a72c", "57e455c6e4b05f663c15a72e")

these.names <- c("UNCID_2264256.71ddb672-ef76-48b7-a76b-3d97dcf4d6d1.130924_UNC9-SN296_0404_BD2DM6ACXX_2_GCCAAT.tar.gz", "UNCID_2189216.01fb6e45-0552-4af8-8723-3631dada7a90.120625_UNC14-SN744_0243_AD12W2ACXX_4_ATCACG.tar.gz", "UNCID_2209626.92fed6cd-4439-4c1f-af25-97ed083b9499.110503_UNC15-SN850_0066_Ab0bh8abxx_4.tar.gz")





## check:
cat("glfid ", these.ids[2], "\n", these.names[2], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING









##################################################################
## liversep22
## tumor
##   machete-new-glm-script  machete-light
##################################################################

todaydate <- "sep22"
shortname <- "liver"
longname <- "Liver Hepatocellular Carcinoma"


groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


## nice.ids.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.ids.csv"))
## nice.names.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.names.csv"))



## scan in so don't run afoul of R maximum line length issue
## these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)
## these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)

these.ids <- c("57e45adae4b05f663c15a730", "57e45adae4b05f663c15a732", "57e45adbe4b05f663c15a734")

these.names <- c("UNCID_2660995.439c718c-5d13-4516-9343-0a0b8c5869c4.140826_UNC9-SN296_0433_BC5FWDACXX_4_CGATGT.tar.gz", "UNCID_2664274.931985c4-6972-4fa5-9890-ba58b4ab3b6a.141030_UNC15-SN850_0397_AC5F8LACXX_3_ACTGAT.tar.gz", "UNCID_2580840.fe0ae39e-cbfd-416c-9485-036d0f77531f.140513_UNC15-SN850_0365_BC4BYLACXX_7_GAGTGG.tar.gz")





## check:
cat("glfid ", these.ids[2], "\n", these.names[2], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING


##################################################################
## lungcellsep22
## tumor
##   machete-new-glm-script  machete-light
##################################################################

todaydate <- "sep22"
shortname <- "lungcell"
longname <- "Lung Squamous Cell Carcinoma"


groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


## nice.ids.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.ids.csv"))
## nice.names.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.names.csv"))



## scan in so don't run afoul of R maximum line length issue
## these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)
## these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)

these.ids <- c("57e45d9de4b05f663c15a956", "57e45d9ee4b05f663c15a958", "57e45d9fe4b05f663c15a95a", "57e45d9fe4b05f663c15a95c", "57e45d9fe4b05f663c15a95e", "57e45da0e4b05f663c15a960")

these.names <- c("UNCID_2209858.e1d11ec9-09e9-4cbb-b3a6-6724f4379cc7.110427_UNC11-SN627_0080_AC016RABXX_4.tar.gz", "UNCID_2207041.a3196a69-230e-4dfe-ba2d-d8c5a8310d29.110726_UNC12-SN629_0113_BD0E5WABXX_5.tar.gz", "UNCID_2167418.56947d0d-2959-4746-9955-e085fd9afc32.130716_UNC9-SN296_0383_AC29HFACXX_7_TTAGGC.tar.gz", "UNCID_2194571.c291c855-abe4-4805-973f-e29ee22c4667.120313_UNC9-SN296_0281_BD0UM8ACXX_7_ACAGTG.tar.gz", "UNCID_2214710.e049e194-d224-41cf-99b6-a4e7490674f9.110204_UNC9-SN296_0125_A81DV8ABXX_3.tar.gz", "UNCID_2189647.c9016384-8eed-48c1-9fb0-cdd96cd66b81.120518_UNC14-SN744_0238_AC0PR4ACXX_5_TAGCTT.tar.gz")





## check:
cat("glfid ", these.ids[2], "\n", these.names[2], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING




##################################################################
## skinsep22
## tumor
##   machete-new-glm-script  machete-light
##################################################################

todaydate <- "sep22"
shortname <- "skin"
longname <- "Skin Cutaneous Melanoma"

groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


## nice.ids.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.ids.csv"))
## nice.names.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.names.csv"))



## scan in so don't run afoul of R maximum line length issue
## these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)
## these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)

these.ids <- c("57e4bd99e4b05f663c15b844", "57e4bd99e4b05f663c15b846", "57e4bd9ae4b05f663c15b848", "57e4bd9ae4b05f663c15b84a", "57e4bd9be4b05f663c15b84c", "57e4bd9be4b05f663c15b84e", "57e4bd9ce4b05f663c15b850", "57e4bd9ce4b05f663c15b852", "57e4bd9de4b05f663c15b854", "57e4bd9de4b05f663c15b856")


uu1 <- c("UNCID_2650103.f473687f-b6b0-41cd-95a9-d5051299507c.140603_UNC11-SN627_0360_AC4H72ACXX_7_ATGTCA.tar.gz", "UNCID_2173923.eb7d8769-1014-4a97-bf28-c6bdd257b9b7.130503_UNC9-SN296_0361_AC23VLACXX_1_GTGGCC.tar.gz", "UNCID_2268801.8e85bc75-8765-4c92-b167-94ed8390f5e9.130718_UNC11-SN627_0316_BD2AUNACXX_1_CTTGTA.tar.gz", "UNCID_2185384.c64dae2c-79f4-475b-92cc-b6080752040e.130115_UNC11-SN627_0275_AD1MF3ACXX_5_AGTTCC.tar.gz", "UNCID_2176769.66a4ff31-c95c-4c76-8e91-1ae3c76e313c.130412_UNC10-SN254_0451_AC22EDACXX_5_GTGGCC.tar.gz")
uu2 <- c("UNCID_2647692.c63ade29-1f1b-4290-8c2f-8d63fa96616c.140716_UNC13-SN749_0364_BC4V7WACXX_4_TAGCTT.tar.gz", "UNCID_2197984.f684abbc-ff21-4042-a5d8-2a0f3e22bd59.120124_UNC16-SN851_0123_AC0FDJACXX_4_GGCTAC.tar.gz", "UNCID_2197687.73b2e2ac-aafd-40e7-8759-ffa226f04a3b.120118_UNC15-SN850_0163_AD0J87ACXX_7_TAGCTT.tar.gz", "UNCID_2196701.24b64a2a-72d2-49a7-b6ac-33654632b85a.120207_UNC10-SN254_0325_AC0C6MACXX_2_ATCACG.tar.gz", "UNCID_2648224.eee95aed-9ab0-42cf-80ca-f8bd5e994037.140617_UNC12-SN629_0374_AC4KA5ACXX_7_GTGAAA.tar.gz")

these.names <- c(uu1,uu2)





## check:
cat("glfid ", these.ids[8], "\n", these.names[8], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING








##################################################################
## skinsep22
## tumor
##   machete-new-glm-script  machete-light
##################################################################

todaydate <- "sep22"
shortname <- "stomach"
longname <- "Stomach Adenocarcinoma"


groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


## nice.ids.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.ids.csv"))
## nice.names.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.names.csv"))



## scan in so don't run afoul of R maximum line length issue
## these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)
## these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)

these.ids <- c("57e4c04be4b05f663c15b85b", "57e4c04be4b05f663c15b85d", "57e4c04ce4b05f663c15b85f", "57e4c04ce4b05f663c15b861", "57e4c04de4b05f663c15b863", "57e4c04de4b05f663c15b865", "57e4c04ee4b05f663c15b867", "57e4c04ee4b05f663c15b869", "57e4c04fe4b05f663c15b86b", "57e4c04fe4b05f663c15b86d")


these.names <- c("TCGA-RD-A8N9-01A-12R-A39E-31_rnaseq_fastq.tar", "TCGA-R5-A7O7-01A-11R-A33Y-31_rnaseq_fastq.tar", "TCGA-CD-8525-01A-11R-2343-13_rnaseq_fastq.tar", "TCGA-VQ-A91V-01A-11R-A414-31_rnaseq_fastq.tar", "TCGA-BR-6802-01A-11R-1884-13_rnaseq_fastq.tar", "TCGA-BR-8365-01A-21R-2343-13_rnaseq_fastq.tar", "TCGA-F1-A448-01A-11R-A24K-31_rnaseq_fastq.tar", "TCGA-CD-A486-01A-11R-A24K-31_rnaseq_fastq.tar", "TCGA-D7-A6EX-01A-11R-A31P-31_rnaseq_fastq.tar", "TCGA-VQ-A8PF-01A-11R-A414-31_rnaseq_fastq.tar")





## check:
cat("glfid ", these.ids[8], "\n", these.names[8], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING






######################################################################
## headnecksep28  machete-new-glm-script  machete-light
##  doing 6 more to try to get up to 15 from 13
## 
######################################################################

todaydate <- "sep28"
shortname <- "headneck"
longname <- "Head and Neck Squamous Cell Carcinoma"


groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


## nice.ids.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.ids.csv"))
## nice.names.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.names.csv"))



## scan in so don't run afoul of R maximum line length issue
## these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)
## these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)

these.ids <- c("57ec4639e4b05f663c1764cd", "57ec463ae4b05f663c1764cf", "57ec463ae4b05f663c1764d1", "57ec463be4b05f663c1764d3", "57ec463be4b05f663c1764d5", "57ec463ce4b05f663c1764d7")

these.names <- c("UNCID_2257343.ac684e9d-d9d3-424e-a2fe-dc3df4204472.130304_UNC12-SN629_0261_AD1VABACXX_2_GATCAG.tar.gz", "UNCID_2661020.25e408b2-3a9c-4f25-b698-19d8f468acb7.140617_UNC11-SN627_0363_AC4HN7ACXX_1_TGACCA.tar.gz", "UNCID_2199571.e7e06ded-74f0-40a0-952c-4b036040d51d.111229_UNC15-SN850_0157_AD0MHHACXX_2_ATCACG.tar.gz", "UNCID_2266643.c721e2a5-6639-45b4-8c5e-539383379c13.130611_UNC15-SN850_0311_AC29PLACXX_8_AGTCAA.tar.gz", "UNCID_2189481.7a0c1c74-9ab2-4faf-9061-6a4ccbea5de8.120605_UNC11-SN627_0238_BD1265ACXX_7_GATCAG.tar.gz", "UNCID_2519958.51e19a14-fcd5-429d-9f78-7004afb8cbaa.140124_UNC12-SN629_0346_BC375JACXX_2_CCGTCC.tar.gz")





## check:
cat("glfid ", these.ids[2], "\n", these.names[2], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING




## ki

##################################################################
## kidneyrenalpapillarysep28
## tumor
##   machete-new-glm-script  machete-light
##################################################################

todaydate <- "sep28"
shortname <- "kidneyrenalpapillary"
longname <- "Kidney Renal Papillary Cell Carcinoma"



groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


## nice.ids.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.ids.csv"))
## nice.names.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.names.csv"))



## scan in so don't run afoul of R maximum line length issue
## these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)
## these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)

these.ids <- c("57ec4987e4b05f663c1764dd", "57ec4988e4b05f663c1764df", "57ec4988e4b05f663c1764e1", "57ec4989e4b05f663c1764e3", "57ec4989e4b05f663c1764e5")

these.names <- c("UNCID_2196746.e836c0b0-a1c7-4db0-8785-6d3a9864f363.120207_UNC9-SN296_0271_BC0CB8ACXX_8_ACAGTG.tar.gz", "UNCID_2209836.33fb74dc-e9cf-4cd1-b997-6e1b239fb9e4.110426_UNC10-SN254_0212_AB067PABXX_2.tar.gz", "UNCID_2579993.66afc4fd-c1f7-4ae9-be1b-8168d7b5e350.140521_UNC13-SN749_0354_BC4GJ7ACXX_5_GTTTCG.tar.gz", "UNCID_2412088.1a8d61cf-2341-4f85-9da8-60a314be5860.140102_UNC15-SN850_0344_AC384WACXX_5_CCGTCC.tar.gz", "UNCID_2179858.59b6740e-5e20-4993-9a1e-9b2ef87e4ab6.130311_UNC12-SN629_0264_AC1WVCACXX_7_GTTTCG.tar.gz")





## check:
cat("glfid ", these.ids[2], "\n", these.names[2], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=2, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING




##################################################################
## bladderoct30
## tumor
##   machete-new-glm-script  machete-light
##
## ABOUT HERE, STARTED CHANGING TO
##    seconds.of.wait.time.between.runs=10
##    from
##    seconds.of.wait.time.between.runs=2
##    because could go up against the API limit of 1000 per 5 mins
## but actually only did halfway through many of the above runs
##################################################################

todaydate <- "oct30"
shortname <- "bladder"
longname <- "Bladder Urothelial Carcinoma"



groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


nice.ids.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.ids.csv"))
nice.names.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.names.csv"))



## scan in so don't run afoul of R maximum line length issue
these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)
these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)




## check:
cat("glfid ", these.ids[2], "\n", these.names[2], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING




##################################################################
## gliomaoct31
## tumor
##   machete-new-glm-script  machete-light
##################################################################

todaydate <- "oct31"
shortname <- "glioma"

groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


nice.ids.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.ids.csv"))
nice.names.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.names.csv"))



## scan in so don't run afoul of R maximum line length issue
these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)
these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)




## check:
cat("glfid ", these.ids[2], "\n", these.names[2], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING



##################################################################
## cervicaloct31 (really started on nov 1)
## tumor
##   machete-new-glm-script  machete-light
##################################################################

todaydate <- "oct31"
shortname <- "cervical"

groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


nice.ids.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.ids.csv"))
nice.names.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.names.csv"))



## scan in so don't run afoul of R maximum line length issue
these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)
these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)




## check:
cat("glfid ", these.ids[2], "\n", these.names[2], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING


##

##################################################################
## colonoct31 (really started on nov 1)
## tumor
##   machete-new-glm-script  machete-light
##################################################################

todaydate <- "oct31"
shortname <- "colon"

groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


nice.ids.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.ids.csv"))
nice.names.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.names.csv"))



## scan in so don't run afoul of R maximum line length issue
these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)
these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)




## check:
cat("glfid ", these.ids[2], "\n", these.names[2], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING





##################################################################
## esophagusoct31 (really started on nov 1)
## tumor
##   machete-new-glm-script  machete-light
##################################################################

todaydate <- "oct31"
shortname <- "esophagus"

groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


nice.ids.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.ids.csv"))
nice.names.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.names.csv"))



## scan in so don't run afoul of R maximum line length issue
these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)
these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)




## check:
cat("glfid ", these.ids[2], "\n", these.names[2], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING








##################################################################
## kidneychromophobeoct31 (really started on nov 1)
## tumor
##   machete-new-glm-script  machete-light
##################################################################

todaydate <- "oct31"
shortname <- "kidneychromophobe"

groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


nice.ids.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.ids.csv"))
nice.names.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.names.csv"))



## scan in so don't run afoul of R maximum line length issue
these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)
these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)




## check:
cat("glfid ", these.ids[2], "\n", these.names[2], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING








##################################################################
## kidneyrenalclearoct31 (really started on nov 1)
## tumor
##   machete-new-glm-script  machete-light
##################################################################

todaydate <- "oct31"
shortname <- "kidneyrenalclear"

groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


nice.ids.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.ids.csv"))
nice.names.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.names.csv"))



## scan in so don't run afoul of R maximum line length issue
these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)
these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)




## check:
cat("glfid ", these.ids[2], "\n", these.names[2], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING




##################################################################
## kidneyrenalpapillarynov1
## tumor
##   machete-new-glm-script  machete-light
##################################################################

todaydate <- "nov1"
shortname <- "kidneyrenalpapillary"

groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


nice.ids.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.ids.csv"))
nice.names.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.names.csv"))



## scan in so don't run afoul of R maximum line length issue
these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)
these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)




## check:
cat("glfid ", these.ids[2], "\n", these.names[2], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING






##################################################################
## livernov1
## tumor
##   machete-new-glm-script  machete-light
##################################################################

todaydate <- "nov1"
shortname <- "liver"

groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


nice.ids.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.ids.csv"))
nice.names.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.names.csv"))



## scan in so don't run afoul of R maximum line length issue
these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)
these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)




## check:
cat("glfid ", these.ids[2], "\n", these.names[2], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING







##################################################################
## lungcellnov1
## tumor
##   machete-new-glm-script  machete-light
##################################################################

todaydate <- "nov1"
shortname <- "lungcell"

groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


nice.ids.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.ids.csv"))
nice.names.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.names.csv"))



## scan in so don't run afoul of R maximum line length issue
these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)
these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)




## check:
cat("glfid ", these.ids[2], "\n", these.names[2], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING





##################################################################
## lymphomanov1
## tumor
##   machete-new-glm-script  machete-light
##################################################################

todaydate <- "nov1"
shortname <- "lymphoma"

groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


nice.ids.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.ids.csv"))
nice.names.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.names.csv"))



## scan in so don't run afoul of R maximum line length issue
these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)
these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)




## check:
cat("glfid ", these.ids[2], "\n", these.names[2], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING




##################################################################
## sarcomanov1
## tumor
##   machete-new-glm-script  machete-light
##################################################################

todaydate <- "nov1"
shortname <- "sarcoma"

groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


nice.ids.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.ids.csv"))
nice.names.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.names.csv"))



## scan in so don't run afoul of R maximum line length issue
these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)
these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)




## check:
cat("glfid ", these.ids[2], "\n", these.names[2], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING



##################################################################
## skinnov1
## tumor
##   machete-new-glm-script  machete-light
##################################################################

todaydate <- "nov1"
shortname <- "skin"

groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


nice.ids.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.ids.csv"))
nice.names.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.names.csv"))



## scan in so don't run afoul of R maximum line length issue
these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)
these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)




## check:
cat("glfid ", these.ids[2], "\n", these.names[2], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING



##################################################################
## stomachnov1
## tumor
##   machete-new-glm-script  machete-light
##################################################################

todaydate <- "nov1"
shortname <- "stomach"

groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


nice.ids.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.ids.csv"))
nice.names.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.names.csv"))



## scan in so don't run afoul of R maximum line length issue
these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)
these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)




## check:
cat("glfid ", these.ids[2], "\n", these.names[2], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING






##################################################################
## lungadenonov1
## tumor
##   machete-new-glm-script  machete-light
##################################################################

todaydate <- "nov1"
shortname <- "lungadeno"

groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


nice.ids.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.ids.csv"))
nice.names.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.names.csv"))



## scan in so don't run afoul of R maximum line length issue
these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)
these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)




## check:
cat("glfid ", these.ids[2], "\n", these.names[2], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING


##################################################################
## prosnov1
## tumor
##   machete-new-glm-script  machete-light
##################################################################

todaydate <- "nov1"
shortname <- "pros"

groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


nice.ids.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.ids.csv"))
nice.names.file = file.path(fileinfodir,paste0(shortname, ".", todaydate, ".nice.names.csv"))



## scan in so don't run afoul of R maximum line length issue
these.ids <- scan(file = nice.ids.file, sep="\n", what = "character", strip.white = TRUE)
these.names <- scan(file = nice.names.file, sep="\n", what = "character", strip.white = TRUE)




## check:
cat("glfid ", these.ids[2], "\n", these.names[2], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines(start.of.run = TRUE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## 
exec.n.pipelines(start.of.run = FALSE, tarfilenames = these.names, tarfileids = these.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING


############################################################
### Running spachete for aml
## grep "amlaug31part2" report.paths.with.keys.csv | wc -l
##  34 of these (out of 38)
## this part picks out
## files that were run with machete (and finished) in amlaug31part2

### first do this part for testing

todaydate <- "nov8"
shortname <- "amlspach"

groupname <- paste0(shortname,todaydate)

groupdir <- file.path(spachetedir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

amlaug31part2.ids.part1 <- c("57c76ccfe4b0f9890b16d3be", "57c76ccfe4b0f9890b16d3c0", "57c76ccfe4b0f9890b16d3c2", "57c76cd0e4b0f9890b16d3c4", "57c76cd0e4b0f9890b16d3c6", "57c76cd1e4b0f9890b16d3c8", "57c76cd1e4b0f9890b16d3ca", "57c76cd1e4b0f9890b16d3cc", "57c76cd2e4b0f9890b16d3ce", "57c76cd2e4b0f9890b16d3d0", "57c76cd3e4b0f9890b16d3d2", "57c76cd3e4b0f9890b16d3d4", "57c76cd3e4b0f9890b16d3d6", "57c76cd4e4b0f9890b16d3d8", "57c76cd6e4b0f9890b16d3da", "57c76cd7e4b0f9890b16d3dc", "57c76cd7e4b0f9890b16d3de", "57c76cd8e4b0f9890b16d3e0", "57c76cd8e4b0f9890b16d3e2", "57c76cd8e4b0f9890b16d3e4", "57c76cd9e4b0f9890b16d3e6")
amlaug31part2.ids.part2 <- c("57c76cd9e4b0f9890b16d3e8", "57c76cdae4b0f9890b16d3ea", "57c76cdae4b0f9890b16d3ec", "57c76cdae4b0f9890b16d3ee", "57c76cdbe4b0f9890b16d3f0", "57c76cdbe4b0f9890b16d3f2", "57c76cdce4b0f9890b16d3f4", "57c76cdce4b0f9890b16d3f6", "57c76cdce4b0f9890b16d3f8", "57c76cdde4b0f9890b16d3fa", "57c76cdee4b0f9890b16d3fc", "57c76cdee4b0f9890b16d3fe", "57c76cdfe4b0f9890b16d400", "57c76cdfe4b0f9890b16d402", "57c76cdfe4b0f9890b16d404", "57c76ce0e4b0f9890b16d406", "57c76ce0e4b0f9890b16d408")
amlaug31part2.ids <- c(amlaug31part2.ids.part1, amlaug31part2.ids.part2)

amlaug31part2.names.1 <- c("TCGA-AB-2872-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2977-03B-01T-0760-13_rnaseq_fastq.tar", "TCGA-AB-2891-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2965-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2824-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2849-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2894-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2889-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2942-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2853-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2863-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2954-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2932-03A-01T-0740-13_rnaseq_fastq.tar", "TCGA-AB-2887-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2973-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2806-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2861-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2858-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2875-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2855-03A-01T-0736-13_rnaseq_fastq.tar")
amlaug31part2.names.2 <- c("TCGA-AB-2994-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2896-03B-01T-0751-13_rnaseq_fastq.tar", "TCGA-AB-2895-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2828-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2928-03A-01T-0740-13_rnaseq_fastq.tar", "TCGA-AB-2873-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2854-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2936-03A-01T-0740-13_rnaseq_fastq.tar", "TCGA-AB-2819-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2856-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2935-03A-01T-0740-13_rnaseq_fastq.tar", "TCGA-AB-2946-03A-01T-0740-13_rnaseq_fastq.tar", "TCGA-AB-2978-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2899-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2933-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2878-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2813-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2815-03A-01T-0734-13_rnaseq_fastq.tar")
amlaug31part2.names <- c(amlaug31part2.names.1, amlaug31part2.names.2)
n.files <- length(amlaug31part2.names)

nicefnames.amlaug31part2 <- vector("character", length = n.files)
for (tti in 1:n.files){
    nicefnames.amlaug31part2[tti] <- clean.names(amlaug31part2.names[tti])
}

## do this manually- get indices to repeat when running
## report.paths.table <- read.table(file=file.path(fileinfodir, "report.paths.with.keys.csv"), header= TRUE, sep=",", stringsAsFactors = FALSE)
## successful.nicefnames <- report.paths.table$base.directory[grep(pattern="amlaug31part2", x = report.paths.table$circ.junc.path)]

## which amlaug31part2 files above were successful? Then choose first 30
## of those to run 30.

## amlaug31part2.indices.to.run <- which(nicefnames.amlaug31part2 %in% successful.nicefnames)[1:30]
## print out for repeating this later, so don't
##  need to do the manual part again
## gsub(pattern="\"", replacement = "", print.nice.ids.vector(amlaug31part2.indices.to.run))

amlaug31part2.indices.to.run <- c(1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14, 15, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32)

amlnov8.indices <- c(1,2)
amlnov9.indices <- amlaug31part2.indices.to.run[3:30]


nicefnames.amlspachnov8 <- nicefnames.amlaug31part2[amlaug31part2.indices.to.run]
file.ids.amlspachnov8 <- amlaug31part2.ids[amlaug31part2.indices.to.run]
file.names.amlspachnov8 <- amlaug31part2.names[amlaug31part2.indices.to.run]

## do this manually to get knife.ids for use with spachete run
amlaug31part2.info <- read.table(file=file.path(mydir, "api/sptest/amlaug31part2.infofile.csv"), header= TRUE, sep=",", stringsAsFactors = FALSE)
knife.ids.amlspachnov8 <- amlaug31part2.info$id.knife[amlaug31part2.info$nicefname %in% nicefnames.amlspachnov8]



##############################################
### First do 2 of them as a test
nicefnames.amlspachtest <- nicefnames.amlspachnov8[1:2]
file.ids.amlspachtest <- file.ids.amlspachnov8[1:2]
file.names.amlspachtest <- file.names.amlspachnov8[1:2]
knife.ids.amlspachtest <- knife.ids.amlspachnov8[1:2]


## tarfilenames = file.names.amlspachnov8; nicenames = nicefnames.amlspachnov8; tarfileids = file.ids.amlspachnov8; groupdir = file.path(mydir, "api/sptest"); infile.etc.info.file = file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata"); projname = "JSALZMAN/machete"; knife.ids = knife.ids.amlspachnov8; auth.token=auth.token; spacheteapp="JSALZMAN/machete/spachetealpha", tempdir=tempdir, max.iterations=max.iterations, runid.suffix="", complete.or.appended="appended"; grouplog = grouplog

## run spachete from runs of knife; typically expect this to come
## from runs of machete using api, specifically using exec.n.pipelines
##  
run.n.spachetes.from.knife.task.ids(auth.token=auth.token, groupdir=groupdir, grouplog=grouplog, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata"), projname= "JSALZMAN/machete", tarfileids = file.ids.amlspachtest, tarfilenames=file.names.amlspachtest, nicenames=nicefnames.amlspachtest, knife.ids=knife.ids.amlspachtest, tempdir=tempdir, max.iterations=max.iterations, seconds.of.wait.time.between.runs=10, run.id.suffix="", complete.or.appended = "appended", spacheteapp="JSALZMAN/machete/spachetealpha", timeout.days=4)





############################################################
### Running spachete for aml nov8 for just two files
## amlspachnov8
## files that were run with machete (and finished) amlaug31part2
############################################################

todaydate <- "nov8"
shortname <- "amlspach"

groupname <- paste0(shortname,todaydate)

groupdir <- file.path(spachetedir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

amlaug31part2.ids.part1 <- c("57c76ccfe4b0f9890b16d3be", "57c76ccfe4b0f9890b16d3c0", "57c76ccfe4b0f9890b16d3c2", "57c76cd0e4b0f9890b16d3c4", "57c76cd0e4b0f9890b16d3c6", "57c76cd1e4b0f9890b16d3c8", "57c76cd1e4b0f9890b16d3ca", "57c76cd1e4b0f9890b16d3cc", "57c76cd2e4b0f9890b16d3ce", "57c76cd2e4b0f9890b16d3d0", "57c76cd3e4b0f9890b16d3d2", "57c76cd3e4b0f9890b16d3d4", "57c76cd3e4b0f9890b16d3d6", "57c76cd4e4b0f9890b16d3d8", "57c76cd6e4b0f9890b16d3da", "57c76cd7e4b0f9890b16d3dc", "57c76cd7e4b0f9890b16d3de", "57c76cd8e4b0f9890b16d3e0", "57c76cd8e4b0f9890b16d3e2", "57c76cd8e4b0f9890b16d3e4", "57c76cd9e4b0f9890b16d3e6")
amlaug31part2.ids.part2 <- c("57c76cd9e4b0f9890b16d3e8", "57c76cdae4b0f9890b16d3ea", "57c76cdae4b0f9890b16d3ec", "57c76cdae4b0f9890b16d3ee", "57c76cdbe4b0f9890b16d3f0", "57c76cdbe4b0f9890b16d3f2", "57c76cdce4b0f9890b16d3f4", "57c76cdce4b0f9890b16d3f6", "57c76cdce4b0f9890b16d3f8", "57c76cdde4b0f9890b16d3fa", "57c76cdee4b0f9890b16d3fc", "57c76cdee4b0f9890b16d3fe", "57c76cdfe4b0f9890b16d400", "57c76cdfe4b0f9890b16d402", "57c76cdfe4b0f9890b16d404", "57c76ce0e4b0f9890b16d406", "57c76ce0e4b0f9890b16d408")
amlaug31part2.ids <- c(amlaug31part2.ids.part1, amlaug31part2.ids.part2)

amlaug31part2.names.1 <- c("TCGA-AB-2872-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2977-03B-01T-0760-13_rnaseq_fastq.tar", "TCGA-AB-2891-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2965-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2824-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2849-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2894-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2889-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2942-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2853-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2863-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2954-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2932-03A-01T-0740-13_rnaseq_fastq.tar", "TCGA-AB-2887-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2973-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2806-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2861-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2858-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2875-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2855-03A-01T-0736-13_rnaseq_fastq.tar")
amlaug31part2.names.2 <- c("TCGA-AB-2994-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2896-03B-01T-0751-13_rnaseq_fastq.tar", "TCGA-AB-2895-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2828-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2928-03A-01T-0740-13_rnaseq_fastq.tar", "TCGA-AB-2873-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2854-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2936-03A-01T-0740-13_rnaseq_fastq.tar", "TCGA-AB-2819-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2856-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2935-03A-01T-0740-13_rnaseq_fastq.tar", "TCGA-AB-2946-03A-01T-0740-13_rnaseq_fastq.tar", "TCGA-AB-2978-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2899-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2933-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2878-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2813-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2815-03A-01T-0734-13_rnaseq_fastq.tar")
amlaug31part2.names <- c(amlaug31part2.names.1, amlaug31part2.names.2)
n.files <- length(amlaug31part2.names)

nicefnames.amlaug31part2 <- vector("character", length = n.files)
for (tti in 1:n.files){
    nicefnames.amlaug31part2[tti] <- clean.names(amlaug31part2.names[tti])
}

## do this manually- get indices to repeat when running
## report.paths.table <- read.table(file=file.path(fileinfodir, "report.paths.with.keys.csv"), header= TRUE, sep=",", stringsAsFactors = FALSE)
## successful.nicefnames <- report.paths.table$base.directory[grep(pattern="amlaug31part2", x = report.paths.table$circ.junc.path)]

## which amlaug31part2 files above were successful? Then choose first 30
## of those to run 30.

## amlaug31part2.indices.to.run <- which(nicefnames.amlaug31part2 %in% successful.nicefnames)[1:30]
## print out for repeating this later, so don't
##  need to do the manual part again
## gsub(pattern="\"", replacement = "", print.nice.ids.vector(amlaug31part2.indices.to.run))

amlaug31part2.indices.to.run <- c(1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14, 15, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32)

amlnov8.indices <- c(1,2)


nicefnames.amlspachnov8 <- nicefnames.amlaug31part2[amlnov8.indices]
file.ids.amlspachnov8 <- amlaug31part2.ids[amlnov8.indices]
file.names.amlspachnov8 <- amlaug31part2.names[amlnov8.indices]

## do this to get knife.ids for use with spachete run 
amlaug31part2.info <- read.table(file=file.path(wdir, "/amlaug31part2/infofile.csv"), header= TRUE, sep=",", stringsAsFactors = FALSE)
knife.ids.amlspachnov8 <- amlaug31part2.info$id.knife[amlaug31part2.info$nicefname %in% nicefnames.amlspachnov8]

  
## run 2 files:
run.n.spachetes.from.knife.task.ids(auth.token=auth.token, groupdir=groupdir, grouplog=grouplog, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata"), projname= "JSALZMAN/machete", tarfileids = file.ids.amlspachnov8, tarfilenames=file.names.amlspachnov8, nicenames=nicefnames.amlspachnov8, knife.ids=knife.ids.amlspachnov8, tempdir=tempdir, max.iterations=max.iterations, seconds.of.wait.time.between.runs=10, run.id.suffix="", complete.or.appended = "appended", spacheteapp="JSALZMAN/machete/spachetealpha", timeout.days=4)




############################################################
### Running spachete for aml nov9 for 28 files to get to 30 aml
## amlspachnov9
## files that were run with machete (and finished) amlaug31part2
############################################################

todaydate <- "nov9"
shortname <- "amlspach"

groupname <- paste0(shortname,todaydate)

groupdir <- file.path(spachetedir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

amlaug31part2.ids.part1 <- c("57c76ccfe4b0f9890b16d3be", "57c76ccfe4b0f9890b16d3c0", "57c76ccfe4b0f9890b16d3c2", "57c76cd0e4b0f9890b16d3c4", "57c76cd0e4b0f9890b16d3c6", "57c76cd1e4b0f9890b16d3c8", "57c76cd1e4b0f9890b16d3ca", "57c76cd1e4b0f9890b16d3cc", "57c76cd2e4b0f9890b16d3ce", "57c76cd2e4b0f9890b16d3d0", "57c76cd3e4b0f9890b16d3d2", "57c76cd3e4b0f9890b16d3d4", "57c76cd3e4b0f9890b16d3d6", "57c76cd4e4b0f9890b16d3d8", "57c76cd6e4b0f9890b16d3da", "57c76cd7e4b0f9890b16d3dc", "57c76cd7e4b0f9890b16d3de", "57c76cd8e4b0f9890b16d3e0", "57c76cd8e4b0f9890b16d3e2", "57c76cd8e4b0f9890b16d3e4", "57c76cd9e4b0f9890b16d3e6")
amlaug31part2.ids.part2 <- c("57c76cd9e4b0f9890b16d3e8", "57c76cdae4b0f9890b16d3ea", "57c76cdae4b0f9890b16d3ec", "57c76cdae4b0f9890b16d3ee", "57c76cdbe4b0f9890b16d3f0", "57c76cdbe4b0f9890b16d3f2", "57c76cdce4b0f9890b16d3f4", "57c76cdce4b0f9890b16d3f6", "57c76cdce4b0f9890b16d3f8", "57c76cdde4b0f9890b16d3fa", "57c76cdee4b0f9890b16d3fc", "57c76cdee4b0f9890b16d3fe", "57c76cdfe4b0f9890b16d400", "57c76cdfe4b0f9890b16d402", "57c76cdfe4b0f9890b16d404", "57c76ce0e4b0f9890b16d406", "57c76ce0e4b0f9890b16d408")
amlaug31part2.ids <- c(amlaug31part2.ids.part1, amlaug31part2.ids.part2)

amlaug31part2.names.1 <- c("TCGA-AB-2872-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2977-03B-01T-0760-13_rnaseq_fastq.tar", "TCGA-AB-2891-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2965-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2824-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2849-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2894-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2889-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2942-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2853-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2863-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2954-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2932-03A-01T-0740-13_rnaseq_fastq.tar", "TCGA-AB-2887-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2973-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2806-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2861-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2858-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2875-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2855-03A-01T-0736-13_rnaseq_fastq.tar")
amlaug31part2.names.2 <- c("TCGA-AB-2994-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2896-03B-01T-0751-13_rnaseq_fastq.tar", "TCGA-AB-2895-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2828-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2928-03A-01T-0740-13_rnaseq_fastq.tar", "TCGA-AB-2873-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2854-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2936-03A-01T-0740-13_rnaseq_fastq.tar", "TCGA-AB-2819-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2856-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2935-03A-01T-0740-13_rnaseq_fastq.tar", "TCGA-AB-2946-03A-01T-0740-13_rnaseq_fastq.tar", "TCGA-AB-2978-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2899-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2933-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2878-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2813-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2815-03A-01T-0734-13_rnaseq_fastq.tar")
amlaug31part2.names <- c(amlaug31part2.names.1, amlaug31part2.names.2)
n.files <- length(amlaug31part2.names)

nicefnames.amlaug31part2 <- vector("character", length = n.files)
for (tti in 1:n.files){
    nicefnames.amlaug31part2[tti] <- clean.names(amlaug31part2.names[tti])
}

## do this manually- get indices to repeat when running
## report.paths.table <- read.table(file=file.path(fileinfodir, "report.paths.with.keys.csv"), header= TRUE, sep=",", stringsAsFactors = FALSE)
## successful.nicefnames <- report.paths.table$base.directory[grep(pattern="amlaug31part2", x = report.paths.table$circ.junc.path)]

## which amlaug31part2 files above were successful? Then choose first 30
## of those to run 30.

## amlaug31part2.indices.to.run <- which(nicefnames.amlaug31part2 %in% successful.nicefnames)[1:30]
## print out for repeating this later, so don't
##  need to do the manual part again
## gsub(pattern="\"", replacement = "", print.nice.ids.vector(amlaug31part2.indices.to.run))

amlaug31part2.indices.to.run <- c(1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14, 15, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32)

amlnov9.indices <- amlaug31part2.indices.to.run[3:30]


nicefnames.amlspachnov9 <- nicefnames.amlaug31part2[amlnov9.indices]
file.ids.amlspachnov9 <- amlaug31part2.ids[amlnov9.indices]
file.names.amlspachnov9 <- amlaug31part2.names[amlnov9.indices]

## do this  to get knife.ids for use with spachete run 
amlaug31part2.info <- read.table(file=file.path(wdir, "/amlaug31part2/infofile.csv"), header= TRUE, sep=",", stringsAsFactors = FALSE)
knife.ids.amlspachnov9 <- amlaug31part2.info$id.knife[amlaug31part2.info$nicefname %in% nicefnames.amlspachnov9]

# Check:
print(paste0("gltad ", knife.ids.amlspachnov9[5], "\n"))
print(paste0(nicefnames.amlspachnov9[5], "\n"))
  
## run 28 files:
run.n.spachetes.from.knife.task.ids(auth.token=auth.token, groupdir=groupdir, grouplog=grouplog, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata"), projname= "JSALZMAN/machete", tarfileids = file.ids.amlspachnov9, tarfilenames=file.names.amlspachnov9, nicenames=nicefnames.amlspachnov9, knife.ids=knife.ids.amlspachnov9, tempdir=tempdir, max.iterations=max.iterations, seconds.of.wait.time.between.runs=10, run.id.suffix="", complete.or.appended = "appended", spacheteapp="JSALZMAN/machete/spachetealpha", timeout.days=4)

############################################################
### Running spachete for ovarian for 30 files
## ovspachnov9
## trying first to get file info
##  ACTUAL RUN BELOW
##  for files that were run with machete (and finished) in
##  ovrun2
##
##  Using files from ovrun2; 31 that finished, but some didn't
##    match so also using some from ovaug31
##
##    for ovaug30 and ovaug31
##  45 total files
##    BUT ONLY 21 of these finished; so didn't use ovaug30
##  (using successful.nicefnames <- report.paths.table$base.directory[grep(pattern="ovaug30|ovaug31", x = report.paths.table$circ.junc.path)])
## 
## NOTE: seems that names for tarfiles are not
##   actually needed to run run.n.spachete
##   and id's are not used except in two 
##     error messages; so would be ok to give vector of
##     blank strings
##   so mainly need the knife task ids (and nice names, but
##   those are easy to get from paths file)
############################################################


todaydate <- "nov11"
shortname <- "ovspach"

groupname <- paste0(shortname,todaydate)

groupdir <- file.path(spachetedir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

## do this manually- get indices to repeat when running
##    run.n.spachetes.from.knife.task.ids
report.paths.table <- read.table(file=file.path(fileinfodir, "report.paths.with.keys.csv"), header= TRUE, sep=",", stringsAsFactors = FALSE)
successful.nicefnames.ovrun2 <- report.paths.table$base.directory[grep(pattern="ovrun2", x = report.paths.table$circ.junc.path)]
length(successful.nicefnames.ovrun2)
## 31

successful.nicefnames.ovaug31 <- report.paths.table$base.directory[grep(pattern="ovaug31", x = report.paths.table$circ.junc.path)]
length(successful.nicefnames.ovaug31)
## 15

ovaug31.ids <- c("57c67d52e4b0192c34a77f7f", "57c67d52e4b0192c34a77f81", "57c67d53e4b0192c34a77f83", "57c67d53e4b0192c34a77f85", "57c67d54e4b0192c34a77f87", "57c67d54e4b0192c34a77f89", "57c67d54e4b0192c34a77f8b", "57c67d55e4b0192c34a77f8d", "57c67d56e4b0192c34a77f8f", "57c67d56e4b0192c34a77f91", "57c67d56e4b0192c34a77f93", "57c67d57e4b0192c34a77f95", "57c67d58e4b0192c34a77f97", "57c67d58e4b0192c34a77f99", "57c67d58e4b0192c34a77f9b", "57c67d59e4b0192c34a77f9d", "57c67d59e4b0192c34a77f9f", "57c67d5ae4b0192c34a77fa1", "57c67d5ae4b0192c34a77fa3", "57c67d5be4b0192c34a77fa5")
    
ovaug31.names <- c("TCGA-23-1021-01B-01R-1564-13_rnaseq_fastq.tar", "TCGA-13-1505-01A-01R-1565-13_rnaseq_fastq.tar", "TCGA-13-0727-01A-01R-1564-13_rnaseq_fastq.tar", "TCGA-24-2288-01A-01R-1568-13_rnaseq_fastq.tar", "TCGA-61-2092-01A-01R-1568-13_rnaseq_fastq.tar", "TCGA-04-1357-01A-01R-1565-13_rnaseq_fastq.tar", "TCGA-61-2097-01A-02R-1568-13_rnaseq_fastq.tar", "TCGA-25-2398-01A-01R-1569-13_rnaseq_fastq.tar", "TCGA-57-1994-01A-01R-1568-13_rnaseq_fastq.tar", "TCGA-24-1850-01A-01R-1567-13_rnaseq_fastq.tar", "TCGA-13-1410-01A-01R-1565-13_rnaseq_fastq.tar", "TCGA-24-1436-01A-01R-1566-13_rnaseq_fastq.tar", "TCGA-3P-A9WA-01A-11R-A406-31_rnaseq_fastq.tar", "TCGA-10-0931-01A-01R-1564-13_rnaseq_fastq.tar", "TCGA-04-1361-01A-01R-1565-13_rnaseq_fastq.tar", "TCGA-23-1107-01A-01R-1564-13_rnaseq_fastq.tar", "TCGA-25-2401-01A-01R-1569-13_rnaseq_fastq.tar", "TCGA-23-1119-01A-02R-1565-13_rnaseq_fastq.tar", "TCGA-29-1705-01A-01R-1567-13_rnaseq_fastq.tar", "TCGA-13-0885-01A-02R-1569-13_rnaseq_fastq.tar")

nicefnames.ovaug31 <- vector("character", length = length(ovaug31.names))
for (tti in 1:length(ovaug31.names)){
    nicefnames.ovaug31[tti] <- clean.names(ovaug31.names[tti])
}


ovaug31.indices.to.run <- which(nicefnames.ovaug31 %in% successful.nicefnames.ovaug31)
length(ovaug31.indices.to.run)
## 15


ovrun2.ids.1 <- c("577fc108e4b00a112012a70d", "577fc108e4b00a112012a70b", "577fc10ae4b00a112012a767", "577fc109e4b00a112012a737", "577fc10ae4b00a112012a765", "577fc108e4b00a112012a6da", "577fc10ae4b00a112012a763", "577fc108e4b00a112012a6dd", "577fc10ae4b00a112012a74f", "577fc10ae4b00a112012a74d", "577fc108e4b00a112012a6f4", "577fc10ae4b00a112012a74b", "577fc108e4b00a112012a6f1", "577fc10ae4b00a112012a761", "577fc108e4b00a112012a6f5", "576d6a09e4b01be096f370a6", "577fc108e4b00a112012a6f9", "577fc10ae4b00a112012a758") 
ovrun2.ids.2 <- c("577fc10ae4b00a112012a757", "577fc108e4b00a112012a6ec", "577fc10ae4b00a112012a754", "577fc108e4b00a112012a6ea", "577fc10ae4b00a112012a753", "577fc108e4b00a112012a6ed", "577fc10ae4b00a112012a73f", "577fc10ae4b00a112012a751", "577fc10ae4b00a112012a747", "577fc10ae4b00a112012a745", "577fc10ae4b00a112012a743", "577fc10ae4b00a112012a741", "577fc108e4b00a112012a6bd", "577fc108e4b00a112012a6bc", "577fc108e4b00a112012a6bb", "577fc108e4b00a112012a6be", "577fc10ae4b00a112012a749", "577fc108e4b00a112012a6d2", "577fc108e4b00a112012a6d6", "577fc108e4b00a112012a6d4", "577fc108e4b00a112012a6d7", "577fc108e4b00a112012a6ce", "577fc108e4b00a112012a6cc", "577fc108e4b00a112012a6cb", "577fc108e4b00a112012a6cf", "577fc108e4b00a112012a6e3", "577fc108e4b00a112012a6e2", "577fc108e4b00a112012a6e1", "577fc108e4b00a112012a6e4", "577fc108e4b00a112012a6e9")
ovrun2.ids <- c(ovrun2.ids.1, ovrun2.ids.2)


out.files.list <- list.all.files.project(projname="JSALZMAN/machete", ttwdir=wdir, tempdir=tempdir, auth.token=auth.token, max.iterations=max.iterations)
allfilenames <- out.files.list$filenames 
allfileids <- out.files.list$fileids


ovrun2.names <- get.filenames.from.fileids(fileids = ovrun2.ids, allnames=allfilenames, allids=allfileids)

nicefnames.ovrun2 <- vector("character", length = length(ovrun2.names))
for (tti in 1:length(ovrun2.names)){
    nicefnames.ovrun2[tti] <- clean.names(ovrun2.names[tti])
}


## which ovrun2 files above were successful? Then choose first 15
## of these to get to 30 when combined with ovaug31.

setdiff(successful.nicefnames.ovrun2, nicefnames.ovrun2)
## [1] "TCGA24193001A01R156713" "TCGA24202601A01R156713" "TCGA25131401A01R156513"
## [4] "TCGA36157001A01R156613" "TCGA61191801A01R156813" "TCGA61200801A02R156813"

ovrun2.indices.to.run <- which(nicefnames.ovrun2 %in% successful.nicefnames.ovrun2)[1:15]

## print out for repeating this later, so don't
##  need to do the manual part again
## gsub(pattern="\"", replacement = "", print.nice.ids.vector(ovrun2.indices.to.run))

ovrun2.indices.to.run <- c(2, 3, 5, 6, 11, 12, 13, 18, 19, 22, 23, 25, 26, 29, 30)

## gsub(pattern="\"", replacement = "", print.nice.ids.vector(ovaug31.indices.to.run))

ovaug31.indices.to.run <- c(2, 3, 5, 6, 7, 8, 9, 10, 11, 12, 13, 16, 17, 18, 19)



ovnov9.ids <- c(ovrun2.ids[ovrun2.indices.to.run], ovaug31.ids[ovaug31.indices.to.run])
ovnov9.names <- c(ovrun2.names[ovrun2.indices.to.run], ovaug31.names[ovaug31.indices.to.run])
print.nice.ids.vector(ovnov9.ids)
print.nice.ids.vector(ovnov9.names)

nicefnames.ovnov9 <- vector("character", length = length(ovnov9.names))
for (tti in 1:length(ovnov9.names)){
    nicefnames.ovnov9[tti] <- clean.names(ovnov9.names[tti])
}
print.nice.ids.vector(nicefnames.ovnov9)

## get ovaug31 knife ids
ovaug31loglines <- read.table(file=file.path(mydir, "api/fileinfo/ovaug31knifelinesfromlog.txt"), header=F, sep=",", stringsAsFactors = FALSE)

nicefnames.running.these.ovaug31 <- nicefnames.ovaug31[ovaug31.indices.to.run]

ovaug31knife.ids <- vector("character", length = length(nicefnames.running.these.ovaug31))
for (ii in 1:length(nicefnames.running.these.ovaug31)){
    ovaug31knife.ids[ii] <- ovaug31loglines$V4[ovaug31loglines$V5==nicefnames.running.these.ovaug31[ii]]
}
cbind(nicefnames.running.these.ovaug31, ovaug31knife.ids)

print.nice.ids.vector(ovaug31knife.ids)

## ovrun2
ovrun2loglines <- read.table(file=file.path(mydir, "api/fileinfo/ovrun2knifelinesfromlog.txt"), header=F, sep=" ", stringsAsFactors = FALSE)

nicefnames.running.these.ovrun2 <- nicefnames.ovrun2[ovrun2.indices.to.run]

ovrun2knife.ids <- vector("character", length = length(nicefnames.running.these.ovrun2))
for (ii in 1:length(nicefnames.running.these.ovrun2)){
    ovrun2knife.ids[ii] <- ovrun2loglines$V3[ovrun2loglines$V9==nicefnames.running.these.ovrun2[ii]]
}
cbind(nicefnames.running.these.ovrun2, ovrun2knife.ids)


print.nice.ids.vector(ovrun2knife.ids)



ovrun2knife.ids <- c("48e7679d-66f4-42cd-a7b5-a0b3ad5403f9", "292b473a-2c17-4bc0-bca5-9131c9a7ebd2", "bf198c43-c544-4f57-b97e-36134614bf9f", "84f5bc49-8ba5-4819-bfef-d6affb44d18a", "9608657b-1c71-47c6-a91c-da3b737a353d", "0bf8892e-a78d-4052-bc59-a9dc47164692", "d2eb3417-0256-46a4-8ec5-089f2c9cec2b", "65cca8a8-6179-43d8-9c62-a018246e202b", "7472a574-f4fe-476f-9ce7-6ca5150708d3", "2b5a9951-5b33-494d-88e7-e312198a8ce4", "4b484c36-7881-4f83-959d-b13e208ebf54", "53309aca-bdc6-4058-8ba1-329cbb7bed66", "e0842be7-457c-49ca-95fd-2ff3f48c14e4", "53661499-4afc-476a-84a2-f33a0e97c0a1", "335c8852-8981-4404-a9c0-0cea45b86dc4")
ovaug31knife.ids <- c("9fc1092a-6aee-4f12-82f0-d80ca7056075", "c91ceb32-3652-4d9e-b541-18aa06261f58", "c135b030-3207-4e89-8d90-a2f9280e13a2", "594d19f8-736f-457e-b635-c68b7921219f", "ca54edd4-a57f-4971-99da-7e3e61b2573d", "19e2db10-c28d-4cc4-b68d-189d246e7400", "0c514741-5c32-4518-b816-3f83ef062855", "85261d84-5574-457e-898b-a95722f25ae5", "f1c286a6-06c9-4c4b-889c-231368abedd3", "7e4cc26b-8eeb-40f7-8050-eed0143973a1", "94449278-d8f1-44d3-9c94-8fc360324990", "8b9c249b-355b-4c1c-8fb0-2f9f18dcd575", "472c8fc6-805b-4875-8067-905645a8b4b9", "529d722c-f9c9-47eb-ae73-c2fb526bf5c6", "25b36c20-7338-4a60-815d-5ad3253769f2")

ovnov9knife.ids <- c(ovrun2knife.ids, ovaug31knife.ids)










############################################################
### Running spachete for ovarian for 30 files
## ovspachnov12
## See above for how we got all the file info
############################################################

todaydate <- "nov12"
shortname <- "ovspach"

groupname <- paste0(shortname,todaydate)

groupdir <- file.path(spachetedir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))


ovnov9.ids <- c("577fc108e4b00a112012a70b", "577fc10ae4b00a112012a767", "577fc10ae4b00a112012a765", "577fc108e4b00a112012a6da", "577fc108e4b00a112012a6f4", "577fc10ae4b00a112012a74b", "577fc108e4b00a112012a6f1", "577fc10ae4b00a112012a758", "577fc10ae4b00a112012a757", "577fc108e4b00a112012a6ea", "577fc10ae4b00a112012a753", "577fc10ae4b00a112012a73f", "577fc10ae4b00a112012a751", "577fc10ae4b00a112012a743", "577fc10ae4b00a112012a741", "57c67d52e4b0192c34a77f81", "57c67d53e4b0192c34a77f83", "57c67d54e4b0192c34a77f87", "57c67d54e4b0192c34a77f89", "57c67d54e4b0192c34a77f8b", "57c67d55e4b0192c34a77f8d", "57c67d56e4b0192c34a77f8f", "57c67d56e4b0192c34a77f91", "57c67d56e4b0192c34a77f93", "57c67d57e4b0192c34a77f95", "57c67d58e4b0192c34a77f97", "57c67d59e4b0192c34a77f9d", "57c67d59e4b0192c34a77f9f", "57c67d5ae4b0192c34a77fa1", "57c67d5ae4b0192c34a77fa3")


ovnov9.names <- c("TCGA-61-1736-01B-01R-1568-13_rnaseq_fastq.tar", "TCGA-13-1489-01A-01R-1565-13_rnaseq_fastq.tar", "TCGA-20-1684-01A-01R-1566-13_rnaseq_fastq.tar", "TCGA-25-1630-01A-01R-1566-13_rnaseq_fastq.tar", "TCGA-61-2088-01A-01R-1568-13_rnaseq_fastq.tar", "TCGA-29-1694-01A-01R-1567-13_rnaseq_fastq.tar", "TCGA-29-2425-01A-01R-1569-13_rnaseq_fastq.tar", "TCGA-13-0804-01A-01R-1564-13_rnaseq_fastq.tar", "TCGA-30-1860-01A-01R-1568-13_rnaseq_fastq.tar", "TCGA-61-1998-01A-01R-1568-13_rnaseq_fastq.tar", "TCGA-61-2003-01A-01R-1568-13_rnaseq_fastq.tar", "TCGA-61-2098-01A-01R-1568-13_rnaseq_fastq.tar", "TCGA-29-1707-02A-01R-1567-13_rnaseq_fastq.tar", "TCGA-24-1424-01A-01R-1565-13_rnaseq_fastq.tar", "TCGA-25-1634-01A-01R-1566-13_rnaseq_fastq.tar", "TCGA-13-1505-01A-01R-1565-13_rnaseq_fastq.tar", "TCGA-13-0727-01A-01R-1564-13_rnaseq_fastq.tar", "TCGA-61-2092-01A-01R-1568-13_rnaseq_fastq.tar", "TCGA-04-1357-01A-01R-1565-13_rnaseq_fastq.tar", "TCGA-61-2097-01A-02R-1568-13_rnaseq_fastq.tar", "TCGA-25-2398-01A-01R-1569-13_rnaseq_fastq.tar", "TCGA-57-1994-01A-01R-1568-13_rnaseq_fastq.tar", "TCGA-24-1850-01A-01R-1567-13_rnaseq_fastq.tar", "TCGA-13-1410-01A-01R-1565-13_rnaseq_fastq.tar", "TCGA-24-1436-01A-01R-1566-13_rnaseq_fastq.tar", "TCGA-3P-A9WA-01A-11R-A406-31_rnaseq_fastq.tar", "TCGA-23-1107-01A-01R-1564-13_rnaseq_fastq.tar", "TCGA-25-2401-01A-01R-1569-13_rnaseq_fastq.tar", "TCGA-23-1119-01A-02R-1565-13_rnaseq_fastq.tar", "TCGA-29-1705-01A-01R-1567-13_rnaseq_fastq.tar")


nicefnames.ovnov9 <- c("TCGA61173601B01R156813", "TCGA13148901A01R156513", "TCGA20168401A01R156613", "TCGA25163001A01R156613", "TCGA61208801A01R156813", "TCGA29169401A01R156713", "TCGA29242501A01R156913", "TCGA13080401A01R156413", "TCGA30186001A01R156813", "TCGA61199801A01R156813", "TCGA61200301A01R156813", "TCGA61209801A01R156813", "TCGA29170702A01R156713", "TCGA24142401A01R156513", "TCGA25163401A01R156613", "TCGA13150501A01R156513", "TCGA13072701A01R156413", "TCGA61209201A01R156813", "TCGA04135701A01R156513", "TCGA61209701A02R156813", "TCGA25239801A01R156913", "TCGA57199401A01R156813", "TCGA24185001A01R156713", "TCGA13141001A01R156513", "TCGA24143601A01R156613", "TCGA3PA9WA01A11RA40631", "TCGA23110701A01R156413", "TCGA25240101A01R156913", "TCGA23111901A02R156513", "TCGA29170501A01R156713")

length(ovnov9.ids); length(ovnov9.names); length(nicefnames.ovnov9)

ovrun2knife.ids <- c("48e7679d-66f4-42cd-a7b5-a0b3ad5403f9", "292b473a-2c17-4bc0-bca5-9131c9a7ebd2", "bf198c43-c544-4f57-b97e-36134614bf9f", "84f5bc49-8ba5-4819-bfef-d6affb44d18a", "9608657b-1c71-47c6-a91c-da3b737a353d", "0bf8892e-a78d-4052-bc59-a9dc47164692", "d2eb3417-0256-46a4-8ec5-089f2c9cec2b", "65cca8a8-6179-43d8-9c62-a018246e202b", "7472a574-f4fe-476f-9ce7-6ca5150708d3", "2b5a9951-5b33-494d-88e7-e312198a8ce4", "4b484c36-7881-4f83-959d-b13e208ebf54", "53309aca-bdc6-4058-8ba1-329cbb7bed66", "e0842be7-457c-49ca-95fd-2ff3f48c14e4", "53661499-4afc-476a-84a2-f33a0e97c0a1", "335c8852-8981-4404-a9c0-0cea45b86dc4")
ovaug31knife.ids <- c("9fc1092a-6aee-4f12-82f0-d80ca7056075", "c91ceb32-3652-4d9e-b541-18aa06261f58", "c135b030-3207-4e89-8d90-a2f9280e13a2", "594d19f8-736f-457e-b635-c68b7921219f", "ca54edd4-a57f-4971-99da-7e3e61b2573d", "19e2db10-c28d-4cc4-b68d-189d246e7400", "0c514741-5c32-4518-b816-3f83ef062855", "85261d84-5574-457e-898b-a95722f25ae5", "f1c286a6-06c9-4c4b-889c-231368abedd3", "7e4cc26b-8eeb-40f7-8050-eed0143973a1", "94449278-d8f1-44d3-9c94-8fc360324990", "8b9c249b-355b-4c1c-8fb0-2f9f18dcd575", "472c8fc6-805b-4875-8067-905645a8b4b9", "529d722c-f9c9-47eb-ae73-c2fb526bf5c6", "25b36c20-7338-4a60-815d-5ad3253769f2")

ovnov9knife.ids <- c(ovrun2knife.ids, ovaug31knife.ids)

print(paste0("gltad ", ovnov9knife.ids[5]))
print(nicefnames.ovnov9[5])

print(paste0("gltad ", ovnov9knife.ids[25]))
print(nicefnames.ovnov9[25])

## run 30 files:
run.n.spachetes.from.knife.task.ids(auth.token=auth.token, groupdir=groupdir, grouplog=grouplog, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata"), projname= "JSALZMAN/machete", tarfileids = ovnov9.ids, tarfilenames=ovnov9.names, nicenames=nicefnames.ovnov9, knife.ids=ovnov9knife.ids, tempdir=tempdir, max.iterations=max.iterations, seconds.of.wait.time.between.runs=10, run.id.suffix="", complete.or.appended = "appended", spacheteapp="JSALZMAN/machete/spachetealpha", timeout.days=4)


###################################################################
## for aml and ovarian, download knife text reports
## because put that into run.one.step.spachete.given.knife.task.id
##  function after running aml and ovarian spachetes
###################################################################

## HAVE TO RUN RELEVANT LINES ABOVE FOR EACH OF AML, OVARIAN

## ovarian
## ovspachnov12

spinfofile = file.path(groupdir, "spinfofile.csv")
spinfodf <- read.table(file = spinfofile, header = TRUE, sep = ",", stringsAsFactors = FALSE)
projname= "JSALZMAN/machete"

for (tti in 1:length(ovnov9knife.ids)){
    out.try.download.knife <- try(download.knife.text.reports(task.id = spinfodf$id.knife[tti], task.short.name=nicefnames.ovnov9[tti], ttwdir=groupdir, ttauth=auth.token, ttproj=projname, tempdir=tempdir, datadir=groupdir))
}


# 2 amls

# amlspachnov8

projname= "JSALZMAN/machete"


for (tti in 1:length(knife.ids.amlspachnov8)){
    out.try.download.knife <- try(download.knife.text.reports(task.id = knife.ids.amlspachnov8[tti], task.short.name=nicefnames.amlspachnov8[tti], ttwdir=groupdir, ttauth=auth.token, ttproj=projname, tempdir=tempdir, datadir=groupdir))
}






# amlspachnov9

projname= "JSALZMAN/machete"


for (tti in 1:length(knife.ids.amlspachnov9)){
    out.try.download.knife <- try(download.knife.text.reports(task.id = knife.ids.amlspachnov9[tti], task.short.name=nicefnames.amlspachnov9[tti], ttwdir=groupdir, ttauth=auth.token, ttproj=projname, tempdir=tempdir, datadir=groupdir))
}



###########################################################
## bodymap
## Uses a different version of exec to run these b/c
## the fastq files are already unpacked
###########################################################


todaydate <- "nov18"
shortname <- "bodymap"

groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


## out.files.list <- list.all.files.project(projname="JSALZMAN/machete", ttwdir=wdir, tempdir=tempdir, auth.token=auth.token, max.iterations=max.iterations)
## allfilenames <- out.files.list$filenames 
## allfileids <- out.files.list$fileids

## ## Get names of files starting with ERR0308, could also use bodymap
## ## tag if wanted

## bodymap.allfastq.indices <- grep(pattern="ERR0308", x = allfilenames)
## bodymap.allfastq.filenames <- allfilenames[bodymap.allfastq.indices]
## bodymap.allfastq.fileids <- allfileids[bodymap.allfastq.indices]
## sort.order.filenames <- order(bodymap.allfastq.filenames)
## sorted.filenames <- bodymap.allfastq.filenames[sort.order.filenames]
## sorted.fileids <- bodymap.allfastq.fileids[sort.order.filenames]

## ## DO THIS MANUALLY
## indices.first.files <- seq(from=1,to=31, by=2)
## indices.second.files <- seq(from=2,to=32, by=2)

## first.files.names <- sorted.filenames[indices.first.files]
## second.files.names <- sorted.filenames[indices.second.files]
## first.files.ids <- sorted.fileids[indices.first.files]
## second.files.ids <- sorted.fileids[indices.second.files]

## print.nice.ids.vector(first.files.names)
## print.nice.ids.vector(first.files.ids)
## print.nice.ids.vector(second.files.names)
## print.nice.ids.vector(second.files.ids)

## do the following, so it's easy to redo this all later:
first.files.names <- c("ERR030872_1.fastq", "ERR030873_1.fastq", "ERR030874_1.fastq", "ERR030875_1.fastq", "ERR030876_1.fastq", "ERR030877_1.fastq", "ERR030878_1.fastq", "ERR030879_1.fastq", "ERR030880_1.fastq", "ERR030881_1.fastq", "ERR030882_1.fastq", "ERR030883_1.fastq", "ERR030884_1.fastq", "ERR030885_1.fastq", "ERR030886_1.fastq", "ERR030887_1.fastq")
first.files.ids <- c("582f550ee4b0e05ac2a81a8b", "582f550ee4b0e05ac2a81a8e", "582f550ee4b0e05ac2a81aac", "582f550ee4b0e05ac2a81ab2", "582f550ee4b0e05ac2a81a92", "582f550ee4b0e05ac2a81a80", "582f550ee4b0e05ac2a81aba", "582f550ee4b0e05ac2a81a8a", "582f550ee4b0e05ac2a81a96", "582f550ee4b0e05ac2a81a87", "582f550ee4b0e05ac2a81a86", "582f550ee4b0e05ac2a81aa1", "582f550ee4b0e05ac2a81a94", "582f550ee4b0e05ac2a81aae", "582f550ee4b0e05ac2a81aa8", "582f550ee4b0e05ac2a81a82")
second.files.names <- c("ERR030872_2.fastq", "ERR030873_2.fastq", "ERR030874_2.fastq", "ERR030875_2.fastq", "ERR030876_2.fastq", "ERR030877_2.fastq", "ERR030878_2.fastq", "ERR030879_2.fastq", "ERR030880_2.fastq", "ERR030881_2.fastq", "ERR030882_2.fastq", "ERR030883_2.fastq", "ERR030884_2.fastq", "ERR030885_2.fastq", "ERR030886_2.fastq", "ERR030887_2.fastq")
second.files.ids <- c("582f550ee4b0e05ac2a81ab8", "582f550ee4b0e05ac2a81a9d", "582f550ee4b0e05ac2a81aa0", "582f550ee4b0e05ac2a81a98", "582f550ee4b0e05ac2a81aa4", "582f550ee4b0e05ac2a81ab6", "582f550ee4b0e05ac2a81a9a", "582f550ee4b0e05ac2a81a7c", "582f550ee4b0e05ac2a81aa5", "582f550ee4b0e05ac2a81ab0", "582f550ee4b0e05ac2a81a7e", "582f550ee4b0e05ac2a81ab4", "582f550ee4b0e05ac2a81a9c", "582f550ee4b0e05ac2a81a90", "582f550ee4b0e05ac2a81aaa", "582f550ee4b0e05ac2a81a84")


## check:
cat("glfid ", second.files.ids[11], "\n", second.files.names[11], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-light"

## to start
exec.n.pipelines.starting.from.unpacked.fastqs(start.of.run = TRUE, fastq1names=first.files.names, fastq1ids=first.files.ids, fastq2names=second.files.names, fastq2ids=second.files.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## 
exec.n.pipelines.starting.from.unpacked.fastqs(start.of.run = FALSE, fastq1names=first.files.names, fastq1ids=first.files.ids, fastq2names=second.files.names, fastq2ids=second.files.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING




###########################################################
## bodymap
## Uses a different version of exec to run these b/c
## the fastq files are already unpacked
## NOW rerun to see if it will work better with bigger
## machete app
## copy failfile.csv and modified infofile.csv over to this one
## and also the ERR file directories and their contents
###########################################################


todaydate <- "nov22"
shortname <- "bodymap"

groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


## out.files.list <- list.all.files.project(projname="JSALZMAN/machete", ttwdir=wdir, tempdir=tempdir, auth.token=auth.token, max.iterations=max.iterations)
## allfilenames <- out.files.list$filenames 
## allfileids <- out.files.list$fileids

## ## Get names of files starting with ERR0308, could also use bodymap
## ## tag if wanted

## bodymap.allfastq.indices <- grep(pattern="ERR0308", x = allfilenames)
## bodymap.allfastq.filenames <- allfilenames[bodymap.allfastq.indices]
## bodymap.allfastq.fileids <- allfileids[bodymap.allfastq.indices]
## sort.order.filenames <- order(bodymap.allfastq.filenames)
## sorted.filenames <- bodymap.allfastq.filenames[sort.order.filenames]
## sorted.fileids <- bodymap.allfastq.fileids[sort.order.filenames]

## ## DO THIS MANUALLY
## indices.first.files <- seq(from=1,to=31, by=2)
## indices.second.files <- seq(from=2,to=32, by=2)

## first.files.names <- sorted.filenames[indices.first.files]
## second.files.names <- sorted.filenames[indices.second.files]
## first.files.ids <- sorted.fileids[indices.first.files]
## second.files.ids <- sorted.fileids[indices.second.files]

## print.nice.ids.vector(first.files.names)
## print.nice.ids.vector(first.files.ids)
## print.nice.ids.vector(second.files.names)
## print.nice.ids.vector(second.files.ids)

## do the following, so it's easy to redo this all later:
first.files.names <- c("ERR030872_1.fastq", "ERR030873_1.fastq", "ERR030874_1.fastq", "ERR030875_1.fastq", "ERR030876_1.fastq", "ERR030877_1.fastq", "ERR030878_1.fastq", "ERR030879_1.fastq", "ERR030880_1.fastq", "ERR030881_1.fastq", "ERR030882_1.fastq", "ERR030883_1.fastq", "ERR030884_1.fastq", "ERR030885_1.fastq", "ERR030886_1.fastq", "ERR030887_1.fastq")
first.files.ids <- c("582f550ee4b0e05ac2a81a8b", "582f550ee4b0e05ac2a81a8e", "582f550ee4b0e05ac2a81aac", "582f550ee4b0e05ac2a81ab2", "582f550ee4b0e05ac2a81a92", "582f550ee4b0e05ac2a81a80", "582f550ee4b0e05ac2a81aba", "582f550ee4b0e05ac2a81a8a", "582f550ee4b0e05ac2a81a96", "582f550ee4b0e05ac2a81a87", "582f550ee4b0e05ac2a81a86", "582f550ee4b0e05ac2a81aa1", "582f550ee4b0e05ac2a81a94", "582f550ee4b0e05ac2a81aae", "582f550ee4b0e05ac2a81aa8", "582f550ee4b0e05ac2a81a82")
second.files.names <- c("ERR030872_2.fastq", "ERR030873_2.fastq", "ERR030874_2.fastq", "ERR030875_2.fastq", "ERR030876_2.fastq", "ERR030877_2.fastq", "ERR030878_2.fastq", "ERR030879_2.fastq", "ERR030880_2.fastq", "ERR030881_2.fastq", "ERR030882_2.fastq", "ERR030883_2.fastq", "ERR030884_2.fastq", "ERR030885_2.fastq", "ERR030886_2.fastq", "ERR030887_2.fastq")
second.files.ids <- c("582f550ee4b0e05ac2a81ab8", "582f550ee4b0e05ac2a81a9d", "582f550ee4b0e05ac2a81aa0", "582f550ee4b0e05ac2a81a98", "582f550ee4b0e05ac2a81aa4", "582f550ee4b0e05ac2a81ab6", "582f550ee4b0e05ac2a81a9a", "582f550ee4b0e05ac2a81a7c", "582f550ee4b0e05ac2a81aa5", "582f550ee4b0e05ac2a81ab0", "582f550ee4b0e05ac2a81a7e", "582f550ee4b0e05ac2a81ab4", "582f550ee4b0e05ac2a81a9c", "582f550ee4b0e05ac2a81a90", "582f550ee4b0e05ac2a81aaa", "582f550ee4b0e05ac2a81a84")


## check:
cat("glfid ", second.files.ids[11], "\n", second.files.names[11], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-BIG-instance-new-glm-script"

## to start
## don't start for this one
## exec.n.pipelines.starting.from.unpacked.fastqs(start.of.run = TRUE, fastq1names=first.files.names, fastq1ids=first.files.ids, fastq2names=second.files.names, fastq2ids=second.files.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## 
exec.n.pipelines.starting.from.unpacked.fastqs(start.of.run = FALSE, fastq1names=first.files.names, fastq1ids=first.files.ids, fastq2names=second.files.names, fastq2ids=second.files.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING





###########################################################
## bodymap
## Uses a different version of exec to run these b/c
## the fastq files are already unpacked
## NOW rerun to see if it will work better with bigger
## machete app
## AND NOW RERUN with COMPLETE instead of appended
## copy failfile.csv and modified infofile.csv over to this one
## and also the ERR file directories and their contents
###########################################################



todaydate <- "dec6"
shortname <- "bodymap"

groupname <- paste0(shortname,todaydate)

groupdir <- file.path(wdir, groupname)

# if it doesn't exist, create it
if (!dir.exists(groupdir)){
    dir.create(groupdir)
}

grouplog <- file.path(groupdir, paste("logforgroup", groupname, ".txt", sep=""))

groupcsv <- file.path(groupdir, paste("infoforgroup", groupname, ".csv", sep=""))

groupfailedtaskslog <- file.path(groupdir, paste("failedtasks.group", groupname, ".org", sep=""))


## remove so don't accidentally use previous one somehow, though unlikely
##  of course
rm(these.ids, these.names)


## out.files.list <- list.all.files.project(projname="JSALZMAN/machete", ttwdir=wdir, tempdir=tempdir, auth.token=auth.token, max.iterations=max.iterations)
## allfilenames <- out.files.list$filenames 
## allfileids <- out.files.list$fileids

## ## Get names of files starting with ERR0308, could also use bodymap
## ## tag if wanted

## bodymap.allfastq.indices <- grep(pattern="ERR0308", x = allfilenames)
## bodymap.allfastq.filenames <- allfilenames[bodymap.allfastq.indices]
## bodymap.allfastq.fileids <- allfileids[bodymap.allfastq.indices]
## sort.order.filenames <- order(bodymap.allfastq.filenames)
## sorted.filenames <- bodymap.allfastq.filenames[sort.order.filenames]
## sorted.fileids <- bodymap.allfastq.fileids[sort.order.filenames]

## ## DO THIS MANUALLY
## indices.first.files <- seq(from=1,to=31, by=2)
## indices.second.files <- seq(from=2,to=32, by=2)

## first.files.names <- sorted.filenames[indices.first.files]
## second.files.names <- sorted.filenames[indices.second.files]
## first.files.ids <- sorted.fileids[indices.first.files]
## second.files.ids <- sorted.fileids[indices.second.files]

## print.nice.ids.vector(first.files.names)
## print.nice.ids.vector(first.files.ids)
## print.nice.ids.vector(second.files.names)
## print.nice.ids.vector(second.files.ids)

## do the following, so it's easy to redo this all later:
first.files.names <- c("ERR030872_1.fastq", "ERR030873_1.fastq", "ERR030874_1.fastq", "ERR030875_1.fastq", "ERR030876_1.fastq", "ERR030877_1.fastq", "ERR030878_1.fastq", "ERR030879_1.fastq", "ERR030880_1.fastq", "ERR030881_1.fastq", "ERR030882_1.fastq", "ERR030883_1.fastq", "ERR030884_1.fastq", "ERR030885_1.fastq", "ERR030886_1.fastq", "ERR030887_1.fastq")
first.files.ids <- c("582f550ee4b0e05ac2a81a8b", "582f550ee4b0e05ac2a81a8e", "582f550ee4b0e05ac2a81aac", "582f550ee4b0e05ac2a81ab2", "582f550ee4b0e05ac2a81a92", "582f550ee4b0e05ac2a81a80", "582f550ee4b0e05ac2a81aba", "582f550ee4b0e05ac2a81a8a", "582f550ee4b0e05ac2a81a96", "582f550ee4b0e05ac2a81a87", "582f550ee4b0e05ac2a81a86", "582f550ee4b0e05ac2a81aa1", "582f550ee4b0e05ac2a81a94", "582f550ee4b0e05ac2a81aae", "582f550ee4b0e05ac2a81aa8", "582f550ee4b0e05ac2a81a82")
second.files.names <- c("ERR030872_2.fastq", "ERR030873_2.fastq", "ERR030874_2.fastq", "ERR030875_2.fastq", "ERR030876_2.fastq", "ERR030877_2.fastq", "ERR030878_2.fastq", "ERR030879_2.fastq", "ERR030880_2.fastq", "ERR030881_2.fastq", "ERR030882_2.fastq", "ERR030883_2.fastq", "ERR030884_2.fastq", "ERR030885_2.fastq", "ERR030886_2.fastq", "ERR030887_2.fastq")
second.files.ids <- c("582f550ee4b0e05ac2a81ab8", "582f550ee4b0e05ac2a81a9d", "582f550ee4b0e05ac2a81aa0", "582f550ee4b0e05ac2a81a98", "582f550ee4b0e05ac2a81aa4", "582f550ee4b0e05ac2a81ab6", "582f550ee4b0e05ac2a81a9a", "582f550ee4b0e05ac2a81a7c", "582f550ee4b0e05ac2a81aa5", "582f550ee4b0e05ac2a81ab0", "582f550ee4b0e05ac2a81a7e", "582f550ee4b0e05ac2a81ab4", "582f550ee4b0e05ac2a81a9c", "582f550ee4b0e05ac2a81a90", "582f550ee4b0e05ac2a81aaa", "582f550ee4b0e05ac2a81a84")


## check:
cat("glfid ", second.files.ids[11], "\n", second.files.names[11], "\n", sep="")

macheteapp.for.this.group <- "JSALZMAN/machete/machete-BIG-instance-new-glm-script"

## to start
## don't start for this one
## exec.n.pipelines.starting.from.unpacked.fastqs(start.of.run = TRUE, fastq1names=first.files.names, fastq1ids=first.files.ids, fastq2names=second.files.names, fastq2ids=second.files.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="appended", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## STARTING

## to resume, rather than to start:
## 
exec.n.pipelines.starting.from.unpacked.fastqs(start.of.run = FALSE, fastq1names=first.files.names, fastq1ids=first.files.ids, fastq2names=second.files.names, fastq2ids=second.files.ids, auth.token=auth.token, groupname = groupname, grouplog = grouplog, groupdir = groupdir, tempdir = tempdir, homedir = homedir, temprdatadir = temprdatadir, complete.or.appended="complete", pipeowner="JSALZMAN", pipeproj="machete", unpackapp="JSALZMAN/machete/sbg-unpack-fastqs-1-0", trimapp="JSALZMAN/machete/trimgalorev2/0", knifeapp="JSALZMAN/machete/knife-for-work", macheteapp=macheteapp.for.this.group, runid.suffix= groupname, timeout.days=4, seconds.of.wait.time.between.runs=10, allowed.fails = 2, infile.etc.info.file=file.path(homedir,"infile.array.etc.names.and.ids.in.machete.project.Rdata")) ## RESUMING




