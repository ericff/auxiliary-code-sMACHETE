# datasetapi.R
# following
# http://docs.cancergenomicscloud.org/v1.0/docs/datasets-api-overview

# and http://docs.cancergenomicscloud.org/v1.0/docs/copy-a-file

home.home <- TRUE

mydir <- "/my/dir"
{
if (home.home){ 
    homedir = file.path(mydir, "api/fileinfo")
    temprdatadir = file.path(mydir, "api/rdatatempfiles")
    tempdir = file.path(mydir, "api/tempfiles")
}
else {
    homedir = file.path(mydir, "api/fileinfo")
    temprdatadir = file.path(mydir, "api/rdatatempfiles")
    tempdir = file.path(mydir, "api/tempfiles")
}
}

setwd(homedir)

source(file.path(homedir, "setdefs.R"))


####################################################################
####################################################################
# run up to here, then do individual lines
# do next few if you need file names
####################################################################
####################################################################

out.files.list <- list.all.files.project(projname="JSALZMAN/machete", ttwdir=wdir, tempdir=tempdir, auth.token=auth.token, max.iterations=max.iterations)
allfilenames <- out.files.list$filenames 
allfileids <- out.files.list$fileids









## out.file <- file.path(tempdir, "test45.json")
## setwd(homedir)
## input.file <- "gbmqueryjul19.json"
## system(paste0('curl -s -H "X-SBG-Auth-Token: ', auth.token, ' " -H "content-type: application/json" -X POST "https://cgc-datasets-api.sbgenomics.com/datasets/tcga/v0/query" --data @',input.file,' > ', out.file))

## tumor.files <- fromJSON(out.file)


# out.gbm <- get.files.with.tumor.or.normal(disease="Glioblastoma Multiforme", tempdir, homedir, query.template.file="gbmqueryjul19.json", auth.token,  tt.files.per.download= files.per.download, sample.type="Primary Tumor", output.csv = "gbm.july19.query.tumor.csv")

# out.gbm <- get.files.with.tumor.or.normal(disease="Glioblastoma Multiforme", tempdir, homedir, query.template.file="gbmqueryjul19.json", auth.token,  tt.files.per.download= files.per.download, sample.type="Solid Tissue Normal", output.csv = "gbm.july19.query.normal.csv")


gbmjuly12.ids <- c("5785e10ce4b035347bd55a90", "5785e10ce4b035347bd55a9a", "5785e10ce4b035347bd55a97", "5785e10ce4b035347bd55a96", "5785e10ce4b035347bd55a8e", "5785e10ce4b035347bd55a91", "5785e10ce4b035347bd55a8f", "57828049e4b00a112012cb9d", "57828049e4b00a112012cba3", "57828049e4b00a112012cb99", "57828049e4b00a112012cb9a", "57828049e4b00a112012cb9f", "57828049e4b00a112012cba1", "57828049e4b00a112012cb91", "57828049e4b00a112012cb95", "57828049e4b00a112012cb97", "57828049e4b00a112012cb8f", "57828049e4b00a112012cb92", "57828049e4b00a112012cb8b", "57828049e4b00a112012cb8d", "57828049e4b00a112012cb89", "57828048e4b00a112012cb87")

gbm18mopup.ids <- c("5785e10ce4b035347bd55a8e", "5785e10ce4b035347bd55a91", "5785e10ce4b035347bd55a8f", "57828049e4b00a112012cb9d", "57828049e4b00a112012cba3", "57828049e4b00a112012cb99", "57828049e4b00a112012cb9a", "57828049e4b00a112012cb9f", "57828049e4b00a112012cba1", "57828049e4b00a112012cb91", "57828049e4b00a112012cb95", "57828049e4b00a112012cb97", "57828049e4b00a112012cb8f", "57828049e4b00a112012cb92", "57828049e4b00a112012cb8b", "57828049e4b00a112012cb8d", "57828049e4b00a112012cb89", "57828048e4b00a112012cb87")

# probably can use gbmjuly12.ids, but to be cautious:
ids.gbm.run.before.july19.in.project <- union(gbmjuly12.ids, gbm18mopup.ids)

names.gbm.run.before.july19 <- get.filenames.from.fileids(fileids = ids.gbm.run.before.july19.in.project, allnames=allfilenames, allids=allfileids)
# SHOULD VISUALLY CHECK that there are no "1_" files here and do
# something if there are!

gbm.all.tumors.df <- read.table(file=file.path(homedir, "gbm.july19.query.tumor.csv"), header=TRUE, sep =",", stringsAsFactors=FALSE) 

gbm.all.normals.df <- read.table(file=file.path(homedir, "gbm.july19.query.normal.csv"), header=TRUE, sep =",", stringsAsFactors=FALSE) 

# there are none with matched normals for gbm, data browser
#  already told us that

gbm.all.tumors.names <- gbm.all.tumors.df$names.files

gbm.not.run.before.july19.names <- setdiff(gbm.all.tumors.names, names.gbm.run.before.july19)

length(gbm.all.tumors.names); length(gbm.not.run.before.july19.names); length(names.gbm.run.before.july19)
# 157 and 135 and 22

# get the ids not run before july 19:
df.gbm.not.run.before.july19 <- gbm.all.tumors.df[gbm.all.tumors.df$names.files %in% gbm.not.run.before.july19.names,]

# Note that these are the ids for sb, not the ids in the project:
ids.gbm.not.run.before.july19 <- df.gbm.not.run.before.july19$ids.files

n.ids.gbm.not.run.before.july19 <- length(ids.gbm.not.run.before.july19)
# choose a random 53 of these:
set.seed(18455)
gbm.random.indices <- sample(n.ids.gbm.not.run.before.july19, size = 53)

ids.sb.gbm.july19.run <- ids.gbm.not.run.before.july19[gbm.random.indices]
# 
##  [1] "564a57f2e4b0298dd2cb0590" "564a3f07e4b093830b6a6cba"
##  [3] "564a35c4e4b0298dd2c698b3" "564a3917e4b0298dd2c7aa47"
##  [5] "564a3548e4b093830b674fcc" "564a411de4b0ef12181c4811"
##  [7] "564a3b8ce4b093830b6950f7" "564a35cee4b0298dd2c69c9d"
##  [9] "564a3d48e4b08c5d86921c0b" "564a38e8e4b08c5d8690b766"
## [11] "564a3d16e4b0298dd2c8f347" "564a3754e4b093830b67f75f"
## [13] "564a3c0ce4b0ef12181aa612" "564a39cae4b08c5d8690ffaa"
## [15] "564a3d8ce4b0ef12181b1fe1" "564a34e4e4b08c5d868f6f6a"
## [17] "564a3c3ae4b0298dd2c8ab9d" "564a35b1e4b0298dd2c69286"
## [19] "564a344ae4b08c5d868f3e26" "564a3529e4b09c884b227501"
## [21] "564a349de4b09c884b224a1f" "564a5809e4b0298dd2cb0e08"
## [23] "564a3355e4b093830b66b09f" "564a3375e4b0ef121817e566"
## [25] "564a351de4b09c884b227096" "564a3ec7e4b0ef12181b847f"
## [27] "564a5742e4b0ef12181cd145" "564a3a4fe4b0298dd2c80e76"
## [29] "564a35eee4b0ef121818b0bb" "564a32a7e4b0ef121817a42d"
## [31] "564a3a76e4b09c884b24135b" "564a56bde4b09c884b2662a4"
## [33] "564a37aae4b09c884b23380f" "564a397de4b093830b68a675"
## [35] "564a364fe4b0ef121818cecd" "564a3312e4b093830b669a18"
## [37] "564a4087e4b08c5d869325d5" "564a4040e4b08c5d86930fb9"
## [39] "564a32c9e4b08c5d868ec44f" "564a564ee4b093830b6b52fa"
## [41] "564a3cc8e4b08c5d8691f3ec" "564a372ee4b0298dd2c70d48"
## [43] "564a3ff2e4b0298dd2c9ddc1" "564a3894e4b09c884b237fa1"
## [45] "564a3b79e4b08c5d869187dc" "564a3fa3e4b08c5d8692dced"
## [47] "564a4000e4b093830b6abe5c" "564a3868e4b0ef1218197bd7"
## [49] "564a3acde4b0ef12181a4082" "564a58d4e4b093830b6c277f"
## [51] "564a3762e4b0ef1218192793" "564a342fe4b0298dd2c616f2"
## [53] "564a3b72e4b09c884b245f2c"

# Now copy these files to the machete project

out.sb.gbm.copy.july19 <- copy.many.files.with.sb.id.to.project(vec.sbids=ids.sb.gbm.july19.run, proj.name="JSALZMAN/machete", auth.token=auth.token, tempdir=tempdir)


out.sb.gbm.copy.july19$files.ids
#  after outputting last thing and editing, use it in runapi.R
#  Note also that I manually changed the first one, b/c
#  I had forgotten to delete the test case, and then it gave
#  a _1_ thing, so I deleted that, so then have to change the file id
# c("578eb8b9e4b02380c59dd8bd", "578eb8cfe4b02380c59dd8c1", "578eb8d0e4b02380c59dd8c3", "578eb8d0e4b02380c59dd8c5", "578eb8d1e4b02380c59dd8c7", "578eb8d2e4b02380c59dd8c9", "578eb8d2e4b02380c59dd8cb", "578eb8d3e4b02380c59dd8cd", "578eb8d4e4b02380c59dd8cf", "578eb8d4e4b02380c59dd8d1", "578eb8d5e4b02380c59dd8d3", "578eb8d5e4b02380c59dd8d5", "578eb8d6e4b02380c59dd8d7", "578eb8d6e4b02380c59dd8d9", "578eb8d7e4b02380c59dd8db", "578eb8d7e4b02380c59dd8dd", "578eb8d8e4b02380c59dd8df", "578eb8d8e4b02380c59dd8e1", "578eb8d9e4b02380c59dd8e3", "578eb8dae4b02380c59dd8e5", "578eb8dae4b02380c59dd8e7", "578eb8dbe4b02380c59dd8e9", "578eb8dbe4b02380c59dd8eb", "578eb8dce4b02380c59dd8ed", "578eb8dce4b02380c59dd8ef", "578eb8dde4b02380c59dd8f1", "578eb8dde4b02380c59dd8f3", "578eb8dee4b02380c59dd8f5", "578eb8dfe4b02380c59dd8f7", "578eb8dfe4b02380c59dd8f9", "578eb8e0e4b02380c59dd8fb", "578eb8e0e4b02380c59dd8fd", "578eb8e1e4b02380c59dd8ff", "578eb8e1e4b02380c59dd901", "578eb8e2e4b02380c59dd903", "578eb8e2e4b02380c59dd905", "578eb8e3e4b02380c59dd907", "578eb8e3e4b02380c59dd909", "578eb8e4e4b02380c59dd90b", "578eb8e4e4b02380c59dd90d", "578eb8e5e4b02380c59dd90f", "578eb8e6e4b02380c59dd911", "578eb8e6e4b02380c59dd913", "578eb8e6e4b02380c59dd915", "578eb8e7e4b02380c59dd917", "578eb8e8e4b02380c59dd919", "578eb8e8e4b02380c59dd91b", "578eb8e8e4b02380c59dd91d", "578eb8e9e4b02380c59dd91f", "578eb8e9e4b02380c59dd921", "578eb8eae4b02380c59dd923", "578eb8ebe4b02380c59dd925", "578eb8ebe4b02380c59dd927")


##################################################################
# Lung
##################################################################


# NEXT ONE HAS disease variable, but I took that out later; not
#   relevant for this function
# FOR THESE TO WORK AGAIN, TAKE THE DISEASE VARIABLE OUT
out.lung.normals <- get.files.with.tumor.or.normal(disease="Lung Adenocarcinoma", tempdir, homedir, query.template.file="lungqueryjul21.json", auth.token,  tt.files.per.download= files.per.download, sample.type="Solid Tissue Normal", output.csv = "lung.july21.query.normal.csv")

# NEXT ONE HAS disease variable, but I took that out later; not
#   relevant for this function; so ok that I previously had error
#   in disease variable
# FOR THESE TO WORK AGAIN, TAKE THE DISEASE VARIABLE OUT
out.lung.tumors <- get.files.with.tumor.or.normal(disease="Lung Adenocarcinoma", tempdir, homedir, query.template.file="lungqueryjul21.json", auth.token,  tt.files.per.download= files.per.download, sample.type="Primary Tumor", output.csv = "lung.july21.query.tumor.csv")

# READ in results
lung.all.tumors.df <- read.table(file=file.path(homedir, "lung.july21.query.tumor.csv"), header=TRUE, sep =",", stringsAsFactors=FALSE) 

lung.all.normals.df <- read.table(file=file.path(homedir, "lung.july21.query.normal.csv"), header=TRUE, sep =",", stringsAsFactors=FALSE) 

dim(lung.all.tumors.df); dim(lung.all.normals.df)
# 540 3, 59 3

# Now choose a unique file for each case:

lung.unique.tumors.df <- choose.one.file.for.each.case(lung.all.tumors.df)
lung.unique.normals.df <- choose.one.file.for.each.case(lung.all.normals.df)
dim(lung.unique.tumors.df); dim(lung.unique.normals.df)
# 516 3, 59 3


# first find cases that match with normals
ids.cases.lung.tumors.with.matched.normals <- intersect(lung.all.tumors.df$ids.cases, lung.all.normals.df$ids.cases)
length(ids.cases.lung.tumors.with.matched.normals)
# [1] 58
# matches data browser query

ids.lung.tumors.with.matched.normals <- lung.unique.tumors.df$ids.files[which(lung.unique.tumors.df$ids.cases %in% ids.cases.lung.tumors.with.matched.normals)]
length(ids.lung.tumors.with.matched.normals)
# 58


df.lung.tumors.with.matched.normals <- lung.unique.tumors.df[which(lung.unique.tumors.df$ids.cases %in% ids.cases.lung.tumors.with.matched.normals),]
dim(df.lung.tumors.with.matched.normals)
# 58 3

# 
ids.lung.run.before.july21.in.project <- c("57853411e4b035347bd55990", "57853411e4b035347bd55998", "57853411e4b035347bd55996", "57853411e4b035347bd55994", "57853411e4b035347bd55992", "57853411e4b035347bd55988", "57853411e4b035347bd5597e", "57853411e4b035347bd5597f", "57853411e4b035347bd55986", "57853411e4b035347bd55984", "57853411e4b035347bd55980", "57853411e4b035347bd5599a", "57853411e4b035347bd5598e", "57853411e4b035347bd5598c", "57853411e4b035347bd5598a")


names.lung.run.before.july21 <- get.filenames.from.fileids(fileids = ids.lung.run.before.july21.in.project, allnames=allfilenames, allids=allfileids)
# SHOULD VISUALLY CHECK that there are no "1_" files here and do
# something if there are!

# get case ids for lung runs before july 21:
ind.july12.tumors <- which(lung.all.tumors.df$names.files %in% names.lung.run.before.july21)
#  7  10  11  44  64  75  93 155 192 204 441 477 483
# 13 of them
ind.july12.normals <- which(lung.all.normals.df$names.files %in% names.lung.run.before.july21)
# 17 29
cases.july12.tumors <- lung.all.tumors.df$ids.cases[ind.july12.tumors]
cases.july12.normals <- lung.all.tumors.df$ids.cases[ind.july12.normals]
cases.july12.all <- union(cases.july12.normals, cases.july12.tumors)

# cases that have matched normals
cases.lung.tumors.with.matched.normals <- df.lung.tumors.with.matched.normals$ids.cases

lung.cases.with.matched.normals.and.not.run.before.july21 <- setdiff(cases.lung.tumors.with.matched.normals, cases.july12.all)
length(lung.cases.with.matched.normals.and.not.run.before.july21); length(cases.lung.tumors.with.matched.normals); length(cases.july12.all)
# 56 58 15


# now get the ids not run before july 21, by first creating a df:
df.lung.with.matched.normals.not.run.before.july21 <- df.lung.tumors.with.matched.normals[df.lung.tumors.with.matched.normals$ids.cases %in% lung.cases.with.matched.normals.and.not.run.before.july21,]
dim(df.lung.with.matched.normals.not.run.before.july21)
# 56 3


# Note that these are the ids for sb, not the ids in the project:
ids.lung.with.matched.normals.not.run.before.july21 <- df.lung.with.matched.normals.not.run.before.july21$ids.files

n.ids.lung.with.matched.normals.not.run.before.july21 <- length(ids.lung.with.matched.normals.not.run.before.july21)

n.ids.lung.with.matched.normals.not.run.before.july21
# 56







# choose a random 17 of these:
sample.size <- 17
set.seed(183243455)
lung.with.matched.normals.random.indices <- sample(n.ids.lung.with.matched.normals.not.run.before.july21, size = sample.size)

ids.sb.lung.with.matched.normals.july21.run <- ids.lung.with.matched.normals.not.run.before.july21[lung.with.matched.normals.random.indices]
#  " *\[[0-9]*\] "
#  these are the SB ids (not the ids for the project)
# for easy replcation:
# ids.sb.lung.with.matched.normals.july21.run <- c("564a5737e4b093830b6b9e4f", "564a39e2e4b093830b68c791", "564a5914e4b09c884b270777", "564a59f1e4b0ef12181db6dc", "564a3e4de4b0298dd2c9560c", "564a3b2ee4b0ef12181a5f13", "564a3e79e4b093830b6a3f54", "564a40f6e4b0ef12181c3bfb", "564a3c2fe4b09c884b2499a8", "564a5850e4b0ef12181d2b4e", "564a40a4e4b0298dd2ca171d", "564a3c6ee4b0298dd2c8bbfc", "564a3cd7e4b08c5d8691f813", "564a40bee4b09c884b25f4fc", "564a3916e4b0ef121819b2ee", "564a3ef7e4b08c5d8692a42c", "564a566ee4b0298dd2ca8544")


# check out the cases, compare manually a bit, and with intersect,
#  that they don't intersect with
#  ones run on july 12 
cases.sb.lung.with.matched.normals.july21.run <- df.lung.with.matched.normals.not.run.before.july21$ids.cases[lung.with.matched.normals.random.indices]
cases.july12.all
intersect(cases.sb.lung.with.matched.normals.july21.run, cases.july12.all)


# Now copy these files to the machete project

out.sb.lung.with.matched.normals.copy.july21 <- copy.many.files.with.sb.id.to.project(vec.sbids=ids.sb.lung.with.matched.normals.july21.run, proj.name="JSALZMAN/machete", auth.token=auth.token, tempdir=tempdir)

# AFTER COPYING, CHECK MANUALLY THAT THERE ARE NO _1_ PREFIXES

# In previous version, there was an error - see setdefs.R copy.file.with.sb.id.to.project
# problem with UNCID_2197473
# 564a5a07e4b0298dd2cbb5b0
# test93weird.json
# missing age at diagnosis for this one
# Looking here it's listed with a blank:
# https://cgc.sbgenomics.com/u/JSALZMAN/machete/files/564a5a07e4b0298dd2cbb5b0/


#  after outputting the next thing, copying and pasting and editing, use it in runapi.R
# 
#  " \[[0-9]*\] "
out.sb.lung.with.matched.normals.copy.july21$files.ids
#  these are the ids for the project, not the SB ids
# c("57929d38e4b02380c5a05441", "57929d39e4b02380c5a05443", "57929d3ae4b02380c5a05445", "57929d3ae4b02380c5a05447", "57929d3be4b02380c5a05449", "57929d3ce4b02380c5a0544b", "57929d3ce4b02380c5a0544d", "57929d3de4b02380c5a0544f", "57929d3ee4b02380c5a05451", "57929d3ee4b02380c5a05453", "57929d3fe4b02380c5a05455", "57929d40e4b02380c5a05457", "57929d41e4b02380c5a05459", "57929d41e4b02380c5a0545b", "57929d42e4b02380c5a0545d", "57929d42e4b02380c5a0545f", "57929d43e4b02380c5a05461")

# [1]
# \[\([0-9]

# also get names for saving them in my info file
out.files.list <- list.all.files.project(projname="JSALZMAN/machete", ttwdir=wdir, tempdir=tempdir, auth.token=auth.token, max.iterations=max.iterations)
allfilenames <- out.files.list$filenames 
allfileids <- out.files.list$fileids
lung.with.matched.normals.july21.file.names <- get.filenames.from.fileids(fileids = out.sb.lung.with.matched.normals.copy.july21$files.ids, allnames=allfilenames, allids=allfileids)

##################################################################
#
# now get ids of normals associated with these 17:
#
##################################################################
cases.sb.lung.with.matched.normals.july21.run


df.lung.normals.matching.july21.lung.tumors <- lung.unique.normals.df[which(lung.unique.normals.df$ids.cases %in% cases.sb.lung.with.matched.normals.july21.run),]

# ids in SB (not in project):
ids.sb.lung.normals.matching.july21.lung.tumors <- df.lung.normals.matching.july21.lung.tumors$ids.files
# THESE ARE SB ids
## [1] "564a3916e4b0298dd2c7a9a5" "564a39e3e4b093830b68c803"
##  [3] "564a3b2ee4b09c884b244b18" "564a3c2fe4b09c884b24996a"
##  [5] "564a3c6de4b093830b69983e" "564a3cd4e4b09c884b24cb96"
##  [7] "564a3e55e4b0298dd2c957de" "564a3e78e4b0298dd2c96374"
##  [9] "564a3ef7e4b0ef12181b937f" "564a40a5e4b0298dd2ca17bf"
## [11] "564a40bee4b0298dd2ca1eab" "564a40f7e4b0ef12181c3c66"
## [13] "564a566fe4b08c5d869398d8" "564a5738e4b093830b6b9ed8"
## [15] "564a5856e4b09c884b26d456" "564a5914e4b0ef12181d6c36"
## [17] "564a59f3e4b0298dd2cbae66"

names.sb.lung.normals.matching.july21.lung.tumors <- df.lung.normals.matching.july21.lung.tumors$names.files


# Now copy these files to the machete project

out.sb.lung.normals.matching.july21.lung.tumors <- copy.many.files.with.sb.id.to.project(vec.sbids=ids.sb.lung.normals.matching.july21.lung.tumors, proj.name="JSALZMAN/machete", auth.token=auth.token, tempdir=tempdir)

# AFTER COPYING, CHECK MANUALLY THAT THERE ARE NO _1_ PREFIXES

# file ids in the machete project:
out.sb.lung.normals.matching.july21.lung.tumors$files.ids

## [1] "579b932ee4b0dac228481ee2" "579b932fe4b0dac228481ee4"
##  [3] "579b932fe4b0dac228481ee6" "579b9330e4b0dac228481ee8"
##  [5] "579b9330e4b0dac228481eea" "579b9330e4b0dac228481eec"
##  [7] "579b9331e4b0dac228481eee" "579b9331e4b0dac228481ef0"
##  [9] "579b9332e4b0dac228481ef2" "579b9332e4b0dac228481ef4"
## [11] "579b9333e4b0dac228481ef6" "579b9333e4b0dac228481ef8"
## [13] "579b9333e4b0dac228481efa" "579b9334e4b0dac228481efc"
## [15] "579b9334e4b0dac228481efe" "579b9335e4b0dac228481f00"
## [17] "579b9335e4b0dac228481f02"


print.nice.ids.vector(out.sb.lung.normals.matching.july21.lung.tumors$files.ids)
# c("579b932ee4b0dac228481ee2", "579b932fe4b0dac228481ee4", "579b932fe4b0dac228481ee6", "579b9330e4b0dac228481ee8", "579b9330e4b0dac228481eea", "579b9330e4b0dac228481eec", "579b9331e4b0dac228481eee", "579b9331e4b0dac228481ef0", "579b9332e4b0dac228481ef2", "579b9332e4b0dac228481ef4", "579b9333e4b0dac228481ef6", "579b9333e4b0dac228481ef8", "579b9333e4b0dac228481efa", "579b9334e4b0dac228481efc", "579b9334e4b0dac228481efe", "579b9335e4b0dac228481f00", "579b9335e4b0dac228481f02")



#####################################################################
#####################################################################
# aug 1 15 aml's   
# THIS HAS NO MATCHED NORMALS
#  Indeed, only one sample type as can see by data browser query I did
# Acute Myeloid Leukemia
# Primary Blood Derived Cancer - Peripheral Blood
#####################################################################
#####################################################################


out.aml.tumors <- get.files.with.tumor.or.normal(tempdir, homedir, query.template.file="amlqueryaug1.json", auth.token,  tt.files.per.download= files.per.download, sample.type="Primary Blood Derived Cancer - Peripheral Blood", output.csv = "aml.aug1.query.tumor.csv")

out.aml.normals <- get.files.with.tumor.or.normal(tempdir, homedir, query.template.file="amlqueryaug1.json", auth.token,  tt.files.per.download= files.per.download, sample.type="Solid Tissue Normal", output.csv = "aml.aug1.query.normal.csv")
# Gives json file "NOT_FOUND" (expected something like that)

# READ in results
aml.all.tumors.df <- read.table(file=file.path(homedir, "aml.aug1.query.tumor.csv"), header=TRUE, sep =",", stringsAsFactors=FALSE) 

dim(aml.all.tumors.df)
# 179 3

# Now choose a unique file for each case:

aml.unique.tumors.df <- choose.one.file.for.each.case(aml.all.tumors.df)
dim(aml.unique.tumors.df)
# 178 3

# df.aml.tumors.with.matched.normals <- aml.unique.tumors.df[which(aml.unique.tumors.df$ids.cases %in% ids.cases.aml.tumors.with.matched.normals),]


# Get ids for aml's already in project
#  Not sure all finished, but want to get 15 other than these anyway
#   so can get them started earlier

# just do interset of all file names in the project with all file names for aml
# have to use names, because allfileids are project ids, aml ids are SB
#   ids

names.aml.run.before.aug1.in.project <- intersect(aml.all.tumors.df$names.files, allfilenames)
length(names.aml.run.before.aug1.in.project)
# 43
# SHOULD VISUALLY CHECK that there are no "1_" files here and do
# something if there are!

# get case ids for aml runs before aug 1:
ind.aug1.tumors <- which(aml.all.tumors.df$names.files %in% names.aml.run.before.aug1.in.project)
# NOTE THAT THIS IS CASES BEFORE aug1:
cases.before.aug1.tumors <- aml.all.tumors.df$ids.cases[ind.aug1.tumors]

# cases for aml tumors
cases.aml.tumors <- aml.unique.tumors.df$ids.cases

aml.cases.not.run.before.aug1 <- setdiff(cases.aml.tumors, cases.before.aug1.tumors)
length(aml.cases.not.run.before.aug1); length(cases.aml.tumors); length(cases.before.aug1.tumors)
# 135 178 43


# now get the ids not run before aug 1, by first creating a df:
df.aml.not.run.before.aug1 <- aml.unique.tumors.df[aml.unique.tumors.df$ids.cases %in% aml.cases.not.run.before.aug1,]
dim(df.aml.not.run.before.aug1)
# 135 3


# Note that these are the ids for sb, not the ids in the project:
ids.aml.not.run.before.aug1 <- df.aml.not.run.before.aug1$ids.files

n.ids.aml.not.run.before.aug1 <- length(ids.aml.not.run.before.aug1)

n.ids.aml.not.run.before.aug1
# 135







# choose a random 15 of these:
sample.size <- 15
set.seed(183243389)
aml.random.indices <- sample(n.ids.aml.not.run.before.aug1, size = sample.size)

ids.sb.aml.aug1.run <- ids.aml.not.run.before.aug1[aml.random.indices]
#  " *\[[0-9]*\] "
#  these are the SB ids (not the ids for the project)
# for easy replcation, can copy and paste results of next line:
print.nice.ids.vector(ids.sb.aml.aug1.run)
# ids.sb.aml.aug1.run <- c("564a4086e4b0ef12181c1628", "564a5903e4b0298dd2cb5fa5", "564a3f02e4b08c5d8692a830", "564a56e5e4b08c5d8693bebc", "564a3e70e4b0ef12181b690f", "564a4153e4b09c884b261fdc", "564a5704e4b093830b6b8cef", "564a4115e4b0ef12181c45fb", "564a4043e4b0298dd2c9f7fa", "564a5883e4b0ef12181d3b80", "564a5989e4b0ef12181d92f7", "564a5971e4b093830b6c5cdf", "564a586be4b09c884b26da53", "564a412fe4b0298dd2ca446e", "564a5759e4b093830b6ba95e")


# check out the cases, compare manually a bit, and with intersect,
#  that they don't intersect with
#  ones run on july 12 
cases.sb.aml.aug1.run <- df.aml.not.run.before.aug1$ids.cases[aml.random.indices]
cases.before.aug1.tumors
intersect(cases.sb.aml.aug1.run, cases.before.aug1.tumors)
# should be empty


names.sb.aml.aug1.run <- df.aml.not.run.before.aug1$names.files[aml.random.indices]
names.sb.aml.aug1.run

## > names.sb.aml.aug1.run
##  [1] "TCGA-AB-2816-03A-01T-0734-13_rnaseq_fastq.tar"
##  [2] "TCGA-AB-2810-03A-01T-0736-13_rnaseq_fastq.tar"
##  [3] "TCGA-AB-2966-03A-01T-0734-13_rnaseq_fastq.tar"
##  [4] "TCGA-AB-2834-03A-01T-0734-13_rnaseq_fastq.tar"
##  [5] "TCGA-AB-2803-03A-01T-0734-13_rnaseq_fastq.tar"
##  [6] "TCGA-AB-2959-03A-01T-0734-13_rnaseq_fastq.tar"
##  [7] "TCGA-AB-2941-03A-01T-0740-13_rnaseq_fastq.tar"
##  [8] "TCGA-AB-2969-03A-01T-0734-13_rnaseq_fastq.tar"
##  [9] "TCGA-AB-2825-03A-01T-0736-13_rnaseq_fastq.tar"
## [10] "TCGA-AB-2930-03A-01T-0740-13_rnaseq_fastq.tar"
## [11] "TCGA-AB-2820-03A-01T-0735-13_rnaseq_fastq.tar"
## [12] "TCGA-AB-3008-03A-01T-0736-13_rnaseq_fastq.tar"
## [13] "TCGA-AB-2876-03A-01T-0734-13_rnaseq_fastq.tar"
## [14] "TCGA-AB-2851-03A-01T-0736-13_rnaseq_fastq.tar"
## [15] "TCGA-AB-2919-03A-01T-0740-13_rnaseq_fastq.tar"



# Now copy these files to the machete project

out.sb.aml.copy.aug1 <- copy.many.files.with.sb.id.to.project(vec.sbids=ids.sb.aml.aug1.run, proj.name="JSALZMAN/machete", auth.token=auth.token, tempdir=tempdir)

# AFTER COPYING, CHECK MANUALLY THAT THERE ARE NO _1_ PREFIXES

# In previous version, there was an error - see setdefs.R copy.file.with.sb.id.to.project
# problem with UNCID_2197473
# 564a5a07e4b0298dd2cbb5b0
# test93weird.json
# missing age at diagnosis for this one
# Looking here it's listed with a blank:
# https://cgc.sbgenomics.com/u/JSALZMAN/machete/files/564a5a07e4b0298dd2cbb5b0/


#  after outputting the next thing, copying and pasting, use it in runapi.R
# 
#  " \[[0-9]*\] "
print.nice.ids.vector(out.sb.aml.copy.aug1$files.ids)
#  these are the ids for the project, not the SB ids
# c("579f965ee4b05eca73486dcc", "579f965ee4b05eca73486dce", "579f965fe4b05eca73486dd0", "579f965fe4b05eca73486dd2", "579f9660e4b05eca73486dd4", "579f9660e4b05eca73486dd6", "579f9661e4b05eca73486dd8", "579f9661e4b05eca73486dda", "579f9661e4b05eca73486ddc", "579f9662e4b05eca73486dde", "579f9662e4b05eca73486de0", "579f9663e4b05eca73486de2", "579f9663e4b05eca73486de4", "579f9664e4b05eca73486de6", "579f9664e4b05eca73486de8")

# [1]
# \[\([0-9]




#####################################################################
#####################################################################
## aug 5 about 20 aliquot ids from
## https://www.thermofisher.com/content/dam/LifeTech/Documents/PDFs/Oncomine/2013AACR_genefusions.pdf
## prostate
##
#####################################################################
#####################################################################

aug5.aliquot.ids <- c("TCGA-CH-5739-01A-11R-1580-07", "TCGA-CH-5740-01A-11R-1580-07", "TCGA-CH-5741-01A-11R-1580-07", "TCGA-CH-5746-01A-11R-1580-07", "TCGA-CH-5765-01A-11R-1580-07", "TCGA-CH-5768-01A-11R-1580-07", "TCGA-CH-5769-01A-11R-1580-07", "TCGA-CH-5789-01A-11R-1580-07", "TCGA-CH-5790-01A-11R-1580-07", "TCGA-EJ-5496-01A-01R-1580-07", "TCGA-EJ-5497-01A-02R-1580-07", "TCGA-EJ-5499-01A-01R-1580-07", "TCGA-EJ-5507-01A-01R-1580-07", "TCGA-EJ-5508-01A-02R-1580-07", "TCGA-EJ-5516-01A-01R-1580-07", "TCGA-EJ-5522-01A-01R-1580-07", "TCGA-EJ-5524-01A-01R-1580-07", "TCGA-EJ-5525-01A-01R-1580-07", "TCGA-EJ-5526-01A-01R-1580-07", "TCGA-EJ-5542-01A-01R-1580-07", "TCGA-G9-6332-01A-11R-1789-07", "TCGA-G9-6365-01A-11R-1789-07", "TCGA-G9-6384-01A-11R-1789-07")

n.aug5.aliquot.ids <- length(aug5.aliquot.ids)

df.aug5.aliquots <- data.frame(ids.files= vector("character", length=0), names.files =vector("character", length=0), ids.cases = vector("character", length=0))

for (tti in 1:n.aug5.aliquot.ids){
    ttout <- get.file.with.aliquot.id(aliquot.id=aug5.aliquot.ids[tti], tempdir, homedir, query.template.file="aliquotquery.json", auth.token)
    df.aug5.aliquots <- rbind(df.aug5.aliquots, ttout$files.df)
}

# above did at home
# below is home.home FALSE:

# do any of these have cases in common with things already looked at?
# use makebothpathsandmetadata.R

uuids.cases.aug5.aliquots <-c("79601D90-B198-4B94-B60F-4CFF329C7A10", "CD113DC4-915A-47D2-BCE0-9DBA915A9D29", "B3BF57D4-E31A-4740-B438-FA826FB79550", "618272C0-C2ED-4BFB-BB4B-404F0987F822", "716EB429-D7AF-4D4F-BD8D-AFCFF1A323EE", "F6C61A22-A711-416D-9E65-6A1B957E5B2E", "A7B76662-8380-4F35-9307-99C0ACACB904", "BE5411DC-3CAA-4B25-9B94-CE463E8E52B4", "2B5EF82D-E137-43F6-BFEF-B202F20EE187", "6755C231-355F-4CC3-85F1-6306C7F5D44B", "DEE02265-D8DD-4379-AE08-72D72B03A570", "FD1AA612-DF86-4D48-892D-2ACEBD76EA96", "607200F5-DF80-4F5D-90FB-FDC455A7415B", "BD18DD01-D894-4BDD-9CE2-E25705A52A57", "1FD06207-54E0-4ABA-819C-C7F671871F39", "214884EF-A932-4FC3-B6FF-16CE5164DA3E", "4048C139-1329-4E6A-8D2F-C0AA104A68EE", "554A7381-46FD-4301-B91B-5AF7F173C350", "EEC48399-5660-4B25-8D34-191B54315C72", "5A92EC4C-36EE-4588-ACA2-E3303F29C7AD", "C46022F8-B122-4367-836B-EC1AE641A87D", "6845076E-E940-4437-8618-81DB4A447544", "A279D5AA-51F7-4E75-9E14-B206B97EC4BD")


uuids.cases.pros.before.aug5 <- paths.with.meta$case_uuid[paths.with.meta$disease_type=="Prostate Adenocarcinoma"]
# 6 of these
## [1] "28689D40-03E5-4E17-ABA1-F2D571535EED"
## [2] "03C66CF8-BC68-4EE1-A322-689A29B72262"
## [3] "2C7EC330-261E-49C7-9424-6D83641DBA6D"
## [4] "0730216B-C201-443C-9092-81E23FD13C6C"
## [5] "181C6D37-9D8D-4FFA-827B-E3785450FF88"
## [6] "2DEF2A53-D2E8-46F0-8B07-F32DBF1833A4"

## NOTE THAT these are the ones done AND downloaded as of aug 5 and
##    could be some that are done but not yet downloaded   


uuids.cases.aug5.aliquots.not.done.before.aug5 <- setdiff(uuids.cases.aug5.aliquots, uuids.cases.pros.before.aug5)
n.uuids.cases.aug5.aliquots.not.done.before.aug5 <- length(uuids.cases.aug5.aliquots.not.done.before.aug5)
## 23
## so maybe no overlap? but after picking 15 of them, will see if
#  any of them are copies of files already in machete project
sample.size <- 15
set.seed(1832433229)
aliquot.random.indices <- sort(sample(n.uuids.cases.aug5.aliquots.not.done.before.aug5, size = sample.size))

ids.aug5.aliquots <- c("564a3e33e4b08c5d869265f7", "564a3acae4b093830b69117e", "564a3ad8e4b0298dd2c83ac5", "564a4088e4b0ef12181c1775", "564a3b5ae4b09c884b24579b", "564a3c27e4b0298dd2c8a58e", "564a39c1e4b08c5d8690fc83", "564a3a49e4b093830b68e918", "564a3293e4b093830b66715c", "564a40b1e4b093830b6af81c", "564a386ee4b09c884b23743e", "564a38a1e4b0ef1218198ec4", "564a3c36e4b09c884b249b86", "564a3fd4e4b08c5d8692ec02", "564a3f38e4b09c884b258455", "564a3cabe4b093830b69ac0c", "564a3753e4b0ef121819231a", "564a392ae4b0298dd2c7b086", "564a33cae4b08c5d868f168e", "564a3c1be4b09c884b2492dc", "564a383ee4b093830b68405e", "564a34a6e4b09c884b224d37", "564a39e3e4b093830b68c80b")

names.aug5.aliquots <-c("UNCID_2190559.26c39f49-cf54-41d6-8c46-c089f4a57002.120223_UNC12-SN629_0186_AC0GA2ACXX_5_GCCAAT.tar.gz", "UNCID_2190552.59173676-8eca-4a03-b37c-c726208a961a.120425_UNC11-SN627_0224_BD0VAKACXX_1_GCCAAT.tar.gz", "UNCID_2190672.639c8d3c-8719-49ca-8812-af6480b164ae.120425_UNC11-SN627_0224_BD0VAKACXX_5_GCCAAT.tar.gz", "UNCID_2190593.e129e211-8237-4842-a5f5-c3dc05607527.111219_UNC11-SN627_0175_BC0CKKACXX_4_CAGATC.tar.gz", "UNCID_2190511.b8cc1fb1-5944-431c-aeec-a4301721f667.120502_UNC14-SN744_0235_BD0YUTACXX_5_ACTTGA.tar.gz", "UNCID_2190658.78808f76-820b-439f-8223-38f2899cad5f.111216_UNC10-SN254_0314_AD0JVAACXX_2_ACTTGA.tar.gz", "UNCID_2190676.2d12fd80-ba3f-49c3-aa15-1f67b9bbd443.120223_UNC12-SN629_0186_AC0GA2ACXX_8_GATCAG.tar.gz", "UNCID_2190673.f659e8f2-3d29-4170-bd40-84e54c70fcd4.120425_UNC11-SN627_0224_BD0VAKACXX_6_GATCAG.tar.gz", "UNCID_2235475.743ad0e2-903e-4438-a575-1f06c286c079.120425_UNC11-SN627_0224_BD0VAKACXX_7_GATCAG.tar.gz", "UNCID_2190566.1059fbc0-46bf-4135-99d0-080ec225391b.120215_UNC10-SN254_0327_AC0CMCACXX_5_GATCAG.tar.gz", "UNCID_2235687.86961468-9e93-469a-b812-03ef327bf5fb.120215_UNC10-SN254_0327_AC0CMCACXX_7_GATCAG.tar.gz", "UNCID_2190491.b1d3e9ee-f0d0-4efd-a505-ea1a9f7fa6df.120502_UNC14-SN744_0235_BD0YUTACXX_6_GATCAG.tar.gz", "UNCID_2190555.487c555b-81bb-4b70-8219-9abac8394b9f.120223_UNC12-SN629_0186_AC0GA2ACXX_7_TAGCTT.tar.gz", "UNCID_2190549.f4463436-536d-412e-824c-0c623a244da5.120425_UNC11-SN627_0224_BD0VAKACXX_4_TAGCTT.tar.gz", "UNCID_2190565.6320daab-3fdb-45d2-bbc8-bbba33e4af37.120215_UNC10-SN254_0327_AC0CMCACXX_7_TAGCTT.tar.gz", "UNCID_2235383.f1441277-65a1-486c-b8e1-2b947734cb17.120502_UNC14-SN744_0235_BD0YUTACXX_2_TAGCTT.tar.gz", "UNCID_2190506.c88d608d-79c7-41af-a3b3-e27b413cba28.120502_UNC14-SN744_0235_BD0YUTACXX_3_TAGCTT.tar.gz", "UNCID_2190492.ad22630d-693d-46c9-b785-5343b08679b5.120502_UNC14-SN744_0235_BD0YUTACXX_4_TAGCTT.tar.gz", "UNCID_2190494.8536a0fb-4aed-4db0-80b0-994606c87ace.120502_UNC14-SN744_0235_BD0YUTACXX_5_TAGCTT.tar.gz", "UNCID_2190656.71b37147-df4c-40ef-b57a-57c2f692de06.111216_UNC10-SN254_0314_AD0JVAACXX_2_TAGCTT.tar.gz", "UNCID_2190623.22ec0a34-74ad-48d6-80f4-b88ef082101d.111212_UNC15-SN850_0155_AD087AACXX_3_ACTTGA.tar.gz", "UNCID_2190614.67816085-c038-4c4f-86f0-b03e6da18aee.111219_UNC11-SN627_0175_BC0CKKACXX_1_ACTTGA.tar.gz", "UNCID_2190703.30e19950-9bbe-4952-8308-41689e57430c.111219_UNC11-SN627_0175_BC0CKKACXX_8_ACTTGA.tar.gz")

# these are the ones we'll do:
ids.aliquots.doing.on.aug5 <- ids.aug5.aliquots[aliquot.random.indices]
names.aliquots.doing.on.aug5 <- names.aug5.aliquots[aliquot.random.indices]




# out.sb.aliquot.copy.aug5 <- copy.many.files.with.sb.id.to.project(vec.sbids=ids.aliquots.doing.on.aug5, proj.name="JSALZMAN/machete", auth.token=auth.token, tempdir=tempdir)


# don't seem to be any duplicates, luckily
print.nice.ids.vector(out.sb.aliquot.copy.aug5$files.ids)
# c("57a4dface4b05eca734c1847", "57a4dface4b05eca734c1849", "57a4dfade4b05eca734c184b", "57a4dfade4b05eca734c184d", "57a4dfade4b05eca734c184f", "57a4dfaee4b05eca734c1851", "57a4dfaee4b05eca734c1853", "57a4dfafe4b05eca734c1855", "57a4dfafe4b05eca734c1857", "57a4dfb0e4b05eca734c1859", "57a4dfb0e4b05eca734c185b", "57a4dfb0e4b05eca734c185d", "57a4dfb1e4b05eca734c185f", "57a4dfb1e4b05eca734c1861", "57a4dfb2e4b05eca734c1863")

print.nice.ids.vector(out.sb.aliquot.copy.aug5$files.names)
# c("UNCID_2190559.26c39f49-cf54-41d6-8c46-c089f4a57002.120223_UNC12-SN629_0186_AC0GA2ACXX_5_GCCAAT.tar.gz", "UNCID_2190593.e129e211-8237-4842-a5f5-c3dc05607527.111219_UNC11-SN627_0175_BC0CKKACXX_4_CAGATC.tar.gz", "UNCID_2190511.b8cc1fb1-5944-431c-aeec-a4301721f667.120502_UNC14-SN744_0235_BD0YUTACXX_5_ACTTGA.tar.gz", "UNCID_2190658.78808f76-820b-439f-8223-38f2899cad5f.111216_UNC10-SN254_0314_AD0JVAACXX_2_ACTTGA.tar.gz", "UNCID_2190676.2d12fd80-ba3f-49c3-aa15-1f67b9bbd443.120223_UNC12-SN629_0186_AC0GA2ACXX_8_GATCAG.tar.gz", "UNCID_2190673.f659e8f2-3d29-4170-bd40-84e54c70fcd4.120425_UNC11-SN627_0224_BD0VAKACXX_6_GATCAG.tar.gz", "UNCID_2235475.743ad0e2-903e-4438-a575-1f06c286c079.120425_UNC11-SN627_0224_BD0VAKACXX_7_GATCAG.tar.gz", "UNCID_2190566.1059fbc0-46bf-4135-99d0-080ec225391b.120215_UNC10-SN254_0327_AC0CMCACXX_5_GATCAG.tar.gz", "UNCID_2235687.86961468-9e93-469a-b812-03ef327bf5fb.120215_UNC10-SN254_0327_AC0CMCACXX_7_GATCAG.tar.gz", "UNCID_2190555.487c555b-81bb-4b70-8219-9abac8394b9f.120223_UNC12-SN629_0186_AC0GA2ACXX_7_TAGCTT.tar.gz", "UNCID_2190549.f4463436-536d-412e-824c-0c623a244da5.120425_UNC11-SN627_0224_BD0VAKACXX_4_TAGCTT.tar.gz", "UNCID_2235383.f1441277-65a1-486c-b8e1-2b947734cb17.120502_UNC14-SN744_0235_BD0YUTACXX_2_TAGCTT.tar.gz", "UNCID_2190506.c88d608d-79c7-41af-a3b3-e27b413cba28.120502_UNC14-SN744_0235_BD0YUTACXX_3_TAGCTT.tar.gz", "UNCID_2190494.8536a0fb-4aed-4db0-80b0-994606c87ace.120502_UNC14-SN744_0235_BD0YUTACXX_5_TAGCTT.tar.gz", "UNCID_2190614.67816085-c038-4c4f-86f0-b03e6da18aee.111219_UNC11-SN627_0175_BC0CKKACXX_1_ACTTGA.tar.gz")





##################################################################
# Breast cancer
##################################################################


## from runapi.R:

brjuly12.ids <- c("5785f43ee4b035347bd55ad3", "5785f168e4b035347bd55ab4", "5785f168e4b035347bd55ab7", "5785f168e4b035347bd55a9f", "5785f168e4b035347bd55a9d", "5785f168e4b035347bd55aa0", "5785f168e4b035347bd55aa8", "5785f168e4b035347bd55ab8", "5785f168e4b035347bd55abb", "5785f168e4b035347bd55aaf", "5785f168e4b035347bd55aa6", "5785f168e4b035347bd55aad", "5785f168e4b035347bd55ab1", "5785f168e4b035347bd55ab2", "5785f168e4b035347bd55abe", "5785f168e4b035347bd55aa7", "5785f168e4b035347bd55aa5", "5785f168e4b035347bd55a9e")
length(brjuly12.ids)

brjuly12.names <- get.filenames.from.fileids(fileids = brjuly12.ids, allnames=allfilenames, allids=allfileids)

# REMEMBER TO CHANGE .JSON FILE MANUALLY
out.bre.normals <- get.files.with.tumor.or.normal(tempdir, homedir, query.template.file="brequeryaug5.json", auth.token,  tt.files.per.download= files.per.download, sample.type="Solid Tissue Normal", output.csv = "bre.aug5.query.normal.csv")


out.bre.tumors <- get.files.with.tumor.or.normal(tempdir, homedir, query.template.file="brequeryaug5.json", auth.token,  tt.files.per.download= files.per.download, sample.type="Primary Tumor", output.csv = "bre.aug5.query.tumor.csv")

# to get the cases for the july 12 runs (they are in wrong
#  order in my records, it seems), use the names:
indices.brjuly12 <- vector("integer", length = length(brjuly12.ids))
for (tti in 1:length(brjuly12.names)){
    indices.brjuly12[tti] <- which(out.bre.tumors$names.files == brjuly12.names[tti])
}

brjuly12.cases <- out.bre.tumors$ids.cases[indices.brjuly12]
print.nice.ids.vector(brjuly12.cases)
# c("02BBB632-0F7F-439D-B8F0-C86A06237424", "F06F09F3-8133-4A92-AC86-FBE64295E0D8", "EE554215-BEA2-4268-AAF9-784E68CDB969", "D6F911B5-E895-43F8-8F86-0AC2F1BC6FAE", "FA176764-A76F-44C7-B97A-CD6D21E052BE", "DBA9BEEC-5E51-48C0-9229-0EE286A02A1A", "C348A9B3-C901-4384-A222-144387BAC0C5", "DD3BFB26-B534-4917-9C4D-9FE7B6477762", "E666081B-CAAF-4E8B-9446-807BE71201A5", "DB4BC6AA-2E7D-4BCB-8519-A455F624D33B", "BF3B1481-AE31-4406-B084-B6CC1D7163E3", "F63722C1-A0BB-4BF9-8A10-1D76A8E1A0BA", "F6581EEE-61B9-43D4-AB0D-CE5CE3BA1C74", "CC074B7F-D3B2-4880-902E-BF10E667B665", "F6E1EC78-5AD9-4879-9B7E-262D17B166AD", "DDCBDAC6-9E43-4146-A611-D033125EBA14", "F2BBFA9D-9A9D-4F46-9FDE-378E4C44E2AD", "D4E7426C-9739-4585-9114-E564B13C7C02")


## then get normals with those cases
indices.normals.matching.july12.cases <- vector("integer", length = length(brjuly12.ids))
for (tti in 1:length(brjuly12.names)){
    indices.normals.matching.july12.cases[tti] <- which(out.bre.normals$ids.cases == brjuly12.cases[tti])
}


sample.size <- 10
set.seed(1816943389)
bre.random.indices <- sort(sample(indices.normals.matching.july12.cases, size = sample.size))

print.nice.ids.vector(out.bre.normals$ids.files[bre.random.indices])

print.nice.ids.vector(out.bre.normals$names.files[bre.random.indices])

## THESE ARE SB IDS, NOT PROJECT IDS:

sb.ids.bre.aug5 <- c("564a36a2e4b0298dd2c6dfb0", "564a3708e4b0298dd2c70021", "564a3791e4b09c884b2330a5", "564a3b24e4b09c884b244831", "564a3f15e4b0298dd2c99687", "564a40b3e4b0ef12181c2562", "564a56dbe4b0298dd2caa7d9", "564a56e9e4b0298dd2caad3f", "564a5750e4b0298dd2cad0b0", "564a59aee4b0298dd2cb97c3")
## c("UNCID_2206776.4c1d73ba-31f8-4652-a83d-cc367dde9f43.110912_UNC13-SN749_0111_AD0DEAABXX_5.tar.gz", "UNCID_2206525.7391b882-0be5-45b0-aa01-43c3381a476d.110919_UNC13-SN749_0113_AB00WUABXX_1_CGATGT.tar.gz", "UNCID_2206832.c2db17b1-c288-4f73-8e22-22929d846678.110829_UNC10-SN254_0271_AC00PWABXX_3_CTTGTA.tar.gz", "UNCID_2206871.a521a6fa-da2b-48ef-94e8-3307030427b6.110824_UNC13-SN749_0098_AC03YVABXX_5.tar.gz", "UNCID_2207028.ef84a69f-37bc-46fa-98ac-b3976212e11d.110801_UNC12-SN629_0115_BD0DVEABXX_4_ACAGTG.tar.gz", "UNCID_2207146.120bc298-f016-4c80-aa5f-a9006444942c.110715_UNC10-SN254_0245_BD0DG6ABXX_3.tar.gz", "UNCID_2206503.3078c384-b624-4f5a-ae36-fc896212e616.110921_UNC9-SN296_0242_AD0DDEABXX_7_TGACCA.tar.gz", "UNCID_2206939.df661ba2-098b-49e0-884c-27cf2ecd87f2.110805_UNC11-SN627_0135_BD0DKJABXX_1_ACTTGA.tar.gz", "UNCID_2207416.9fa440b0-6e8d-4c48-a425-50abc2682f6e.110711_UNC10-SN254_0242_AD0DK5ABXX_1.tar.gz", "UNCID_2206622.f18b2ff7-eddb-40b5-9bbe-7ef09787ddef.111003_UNC13-SN749_0121_AB020YABXX_2_TAGCTT.tar.gz")






# Now copy these files to the machete project

out.sb.bre.normals.aug5 <- copy.many.files.with.sb.id.to.project(vec.sbids=sb.ids.bre.aug5, proj.name="JSALZMAN/machete", auth.token=auth.token, tempdir=tempdir)

# AFTER COPYING, CHECK MANUALLY THAT THERE ARE NO _1_ PREFIXES

print.nice.ids.vector(out.sb.bre.normals.aug5$files.ids)
##  these are the ids for the project, not the SB ids
## c("57a51fa0e4b05eca734c96ed", "57a51fa0e4b05eca734c96ef", "57a51fa0e4b05eca734c96f1", "57a51fa1e4b05eca734c96f3", "57a51fa1e4b05eca734c96f5", "57a51fa2e4b05eca734c96f7", "57a51fa2e4b05eca734c96f9", "57a51fa2e4b05eca734c96fb", "57a51fa3e4b05eca734c96fd", "57a51fa3e4b05eca734c96ff")
## names:
## c("UNCID_2206776.4c1d73ba-31f8-4652-a83d-cc367dde9f43.110912_UNC13-SN749_0111_AD0DEAABXX_5.tar.gz", "UNCID_2206525.7391b882-0be5-45b0-aa01-43c3381a476d.110919_UNC13-SN749_0113_AB00WUABXX_1_CGATGT.tar.gz", "UNCID_2206832.c2db17b1-c288-4f73-8e22-22929d846678.110829_UNC10-SN254_0271_AC00PWABXX_3_CTTGTA.tar.gz", "UNCID_2206871.a521a6fa-da2b-48ef-94e8-3307030427b6.110824_UNC13-SN749_0098_AC03YVABXX_5.tar.gz", "UNCID_2207028.ef84a69f-37bc-46fa-98ac-b3976212e11d.110801_UNC12-SN629_0115_BD0DVEABXX_4_ACAGTG.tar.gz", "UNCID_2207146.120bc298-f016-4c80-aa5f-a9006444942c.110715_UNC10-SN254_0245_BD0DG6ABXX_3.tar.gz", "UNCID_2206503.3078c384-b624-4f5a-ae36-fc896212e616.110921_UNC9-SN296_0242_AD0DDEABXX_7_TGACCA.tar.gz", "UNCID_2206939.df661ba2-098b-49e0-884c-27cf2ecd87f2.110805_UNC11-SN627_0135_BD0DKJABXX_1_ACTTGA.tar.gz", "UNCID_2207416.9fa440b0-6e8d-4c48-a425-50abc2682f6e.110711_UNC10-SN254_0242_AD0DK5ABXX_1.tar.gz", "UNCID_2206622.f18b2ff7-eddb-40b5-9bbe-7ef09787ddef.111003_UNC13-SN749_0121_AB020YABXX_2_TAGCTT.tar.gz")






##################################################################
##  Prostate
##  prosnormalaug7
##################################################################


## from runapi.R:

prosaug5.ids <- c("57a4dface4b05eca734c1847", "57a4dface4b05eca734c1849", "57a4dfade4b05eca734c184b", "57a4dfade4b05eca734c184d", "57a4dfade4b05eca734c184f", "57a4dfaee4b05eca734c1851", "57a4dfaee4b05eca734c1853", "57a4dfafe4b05eca734c1855", "57a4dfafe4b05eca734c1857", "57a4dfb0e4b05eca734c1859", "57a4dfb0e4b05eca734c185b", "57a4dfb0e4b05eca734c185d", "57a4dfb1e4b05eca734c185f", "57a4dfb1e4b05eca734c1861", "57a4dfb2e4b05eca734c1863")

## have to split into parts because of weird control G thing:
prosaug5.names.part1 <- c("UNCID_2190559.26c39f49-cf54-41d6-8c46-c089f4a57002.120223_UNC12-SN629_0186_AC0GA2ACXX_5_GCCAAT.tar.gz", "UNCID_2190593.e129e211-8237-4842-a5f5-c3dc05607527.111219_UNC11-SN627_0175_BC0CKKACXX_4_CAGATC.tar.gz", "UNCID_2190511.b8cc1fb1-5944-431c-aeec-a4301721f667.120502_UNC14-SN744_0235_BD0YUTACXX_5_ACTTGA.tar.gz", "UNCID_2190658.78808f76-820b-439f-8223-38f2899cad5f.111216_UNC10-SN254_0314_AD0JVAACXX_2_ACTTGA.tar.gz", "UNCID_2190676.2d12fd80-ba3f-49c3-aa15-1f67b9bbd443.120223_UNC12-SN629_0186_AC0GA2ACXX_8_GATCAG.tar.gz", "UNCID_2190673.f659e8f2-3d29-4170-bd40-84e54c70fcd4.120425_UNC11-SN627_0224_BD0VAKACXX_6_GATCAG.tar.gz", "UNCID_2235475.743ad0e2-903e-4438-a575-1f06c286c079.120425_UNC11-SN627_0224_BD0VAKACXX_7_GATCAG.tar.gz", "UNCID_2190566.1059fbc0-46bf-4135-99d0-080ec225391b.120215_UNC10-SN254_0327_AC0CMCACXX_5_GATCAG.tar.gz", "UNCID_2235687.86961468-9e93-469a-b812-03ef327bf5fb.120215_UNC10-SN254_0327_AC0CMCACXX_7_GATCAG.tar.gz")
prosaug5.names.part2 <- c("UNCID_2190555.487c555b-81bb-4b70-8219-9abac8394b9f.120223_UNC12-SN629_0186_AC0GA2ACXX_7_TAGCTT.tar.gz", "UNCID_2190549.f4463436-536d-412e-824c-0c623a244da5.120425_UNC11-SN627_0224_BD0VAKACXX_4_TAGCTT.tar.gz", "UNCID_2235383.f1441277-65a1-486c-b8e1-2b947734cb17.120502_UNC14-SN744_0235_BD0YUTACXX_2_TAGCTT.tar.gz", "UNCID_2190506.c88d608d-79c7-41af-a3b3-e27b413cba28.120502_UNC14-SN744_0235_BD0YUTACXX_3_TAGCTT.tar.gz", "UNCID_2190494.8536a0fb-4aed-4db0-80b0-994606c87ace.120502_UNC14-SN744_0235_BD0YUTACXX_5_TAGCTT.tar.gz", "UNCID_2190614.67816085-c038-4c4f-86f0-b03e6da18aee.111219_UNC11-SN627_0175_BC0CKKACXX_1_ACTTGA.tar.gz")
prosaug5.names <- c(prosaug5.names.part1, prosaug5.names.part2)


## get these next ones manually:
prosjuly10.names <- c("UNCID_2189776.2ff3af27-d43b-4707-a337-0ff988ac2763.120514_UNC16-SN851_0159_BC0TARACXX_4_CAGATC.tar.gz", "UNCID_2189821.d8765abc-befa-49b5-893e-04de2ddb2ee1.120514_UNC16-SN851_0159_BC0TARACXX_5_GATCAG.tar.gz", "UNCID_2190523.0cc5f629-5046-4d05-8a5f-923ce5c04b9e.120501_UNC11-SN627_0226_AC0TGKACXX_8_ACAGTG.tar.gz")

prosjuly10.ids <- c("578279b2e4b00a112012cb72", "578279b1e4b00a112012cb6a", "578279b2e4b00a112012cb7a")

ids.pros.downloaded.by.aug7 <- c(prosaug5.ids, prosjuly10.ids)
names.pros.downloaded.by.aug7 <- c(prosaug5.names, prosjuly10.names)



# REMEMBER TO CHANGE .JSON FILE MANUALLY
out.pros.normals <- get.files.with.tumor.or.normal(tempdir, homedir, query.template.file="prosqueryaug7.json", auth.token,  tt.files.per.download= files.per.download, sample.type="Solid Tissue Normal", output.csv = "pros.aug7.query.normal.csv")
length(out.pros.normals$ids.files)
# 52

out.pros.tumors <- get.files.with.tumor.or.normal(tempdir, homedir, query.template.file="prosqueryaug7.json", auth.token,  tt.files.per.download= files.per.download, sample.type="Primary Tumor", output.csv = "pros.aug7.query.tumor.csv")
length(out.pros.tumors$ids.files)
# 505

# to get the cases for the runs pre aug 7, use the names:
indices.pros.downloaded.by.aug7 <- vector("integer", length = length(ids.pros.downloaded.by.aug7))
for (tti in 1:length(ids.pros.downloaded.by.aug7)){
    indices.pros.downloaded.by.aug7[tti] <- which(out.pros.tumors$names.files == names.pros.downloaded.by.aug7[tti])
}

pros.downloaded.by.aug7.cases <- out.pros.tumors$ids.cases[indices.pros.downloaded.by.aug7]
print.nice.ids.vector(pros.downloaded.by.aug7.cases)
#  c("79601D90-B198-4B94-B60F-4CFF329C7A10", "618272C0-C2ED-4BFB-BB4B-404F0987F822", "716EB429-D7AF-4D4F-BD8D-AFCFF1A323EE", "F6C61A22-A711-416D-9E65-6A1B957E5B2E", "A7B76662-8380-4F35-9307-99C0ACACB904", "BE5411DC-3CAA-4B25-9B94-CE463E8E52B4", "2B5EF82D-E137-43F6-BFEF-B202F20EE187", "6755C231-355F-4CC3-85F1-6306C7F5D44B", "DEE02265-D8DD-4379-AE08-72D72B03A570", "607200F5-DF80-4F5D-90FB-FDC455A7415B", "BD18DD01-D894-4BDD-9CE2-E25705A52A57", "214884EF-A932-4FC3-B6FF-16CE5164DA3E", "4048C139-1329-4E6A-8D2F-C0AA104A68EE", "EEC48399-5660-4B25-8D34-191B54315C72", "6845076E-E940-4437-8618-81DB4A447544", "03C66CF8-BC68-4EE1-A322-689A29B72262", "0730216B-C201-443C-9092-81E23FD13C6C", "2DEF2A53-D2E8-46F0-8B07-F32DBF1833A4")


## then get normals with those cases
indices.normals.matching.downloaded.by.aug7.cases <- vector("integer", length = length(ids.pros.downloaded.by.aug7))
indices.normals.matching.downloaded.by.aug7.cases[] <- NA
# length 18 as of aug 7
#  see if any of the previous runs have matching normals:
for (tti in 1:length(ids.pros.downloaded.by.aug7)){
    out.temp.indices <- which(out.pros.normals$ids.cases == pros.downloaded.by.aug7.cases[tti])
    # if the pros already run has a matching normal:
    if (length(out.temp.indices)>0){
        indices.normals.matching.downloaded.by.aug7.cases[tti] <- out.temp.indices
    }
}
# only 5 of them

n.pros.matching.pre.aug7 <- sum(!is.na(indices.normals.matching.downloaded.by.aug7.cases))
ids.pros.matching.pre.aug7 <- vector("character", length = n.pros.matching.pre.aug7)
names.pros.matching.pre.aug7 <- vector("character", length = n.pros.matching.pre.aug7)
cases.pros.matching.pre.aug7 <- vector("character", length = n.pros.matching.pre.aug7)
ii.matching <- 0
for (tti in 1:length(ids.pros.downloaded.by.aug7)){
    if (!is.na(indices.normals.matching.downloaded.by.aug7.cases[tti])){
        ii.matching <- ii.matching + 1
        ids.pros.matching.pre.aug7[ii.matching] <- ids.pros.downloaded.by.aug7[tti]
        names.pros.matching.pre.aug7[ii.matching] <- names.pros.downloaded.by.aug7[tti]
        cases.pros.matching.pre.aug7[ii.matching] <- pros.downloaded.by.aug7.cases[tti]
    }
}

## ids.pros.matching.pre.aug7
## [1] "57a4dfade4b05eca734c184d" "57a4dfade4b05eca734c184f"
## [3] "57a4dfb2e4b05eca734c1863" "578279b1e4b00a112012cb6a"
## [5] "578279b2e4b00a112012cb7a"
## > names.pros.matching.pre.aug7
## [1] "UNCID_2190658.78808f76-820b-439f-8223-38f2899cad5f.111216_UNC10-SN254_0314_AD0JVAACXX_2_ACTTGA.tar.gz"
## [2] "UNCID_2190676.2d12fd80-ba3f-49c3-aa15-1f67b9bbd443.120223_UNC12-SN629_0186_AC0GA2ACXX_8_GATCAG.tar.gz"
## [3] "UNCID_2190614.67816085-c038-4c4f-86f0-b03e6da18aee.111219_UNC11-SN627_0175_BC0CKKACXX_1_ACTTGA.tar.gz"
## [4] "UNCID_2189821.d8765abc-befa-49b5-893e-04de2ddb2ee1.120514_UNC16-SN851_0159_BC0TARACXX_5_GATCAG.tar.gz"
## [5] "UNCID_2190523.0cc5f629-5046-4d05-8a5f-923ce5c04b9e.120501_UNC11-SN627_0226_AC0TGKACXX_8_ACAGTG.tar.gz"
## > cases.pros.matching.pre.aug7
## [1] "F6C61A22-A711-416D-9E65-6A1B957E5B2E"
## [2] "A7B76662-8380-4F35-9307-99C0ACACB904"
## [3] "6845076E-E940-4437-8618-81DB4A447544"
## [4] "0730216B-C201-443C-9092-81E23FD13C6C"
## [5] "2DEF2A53-D2E8-46F0-8B07-F32DBF1833A4"

## find normals that match cases pre aug 7:
## first remove the NAs
## Note that these are not sorted, in order to keep the above order
indices.of.normals.matching.pre.aug7.without.NAs <- indices.normals.matching.downloaded.by.aug7.cases[!is.na(indices.normals.matching.downloaded.by.aug7.cases)]
        
sb.ids.normals.matching.pre.aug7 <- out.pros.normals$ids.files[indices.of.normals.matching.pre.aug7.without.NAs]

names.normals.matching.pre.aug7 <- out.pros.normals$names.files[indices.of.normals.matching.pre.aug7.without.NAs]


## Now let's choose 5 other matched normals, because
## 
## Excludes last one b/c we ran that already
## 
## "UNCID_2190513.2d8faa2d-336f-46e9-992d-4a5a5dbc4ece.120430_UNC10-SN254_0353_AC0TGUACXX_6_TGACCA.tar.gz"


sb.ids.normals.matching.pre.aug7.minus.last.one <- sb.ids.normals.matching.pre.aug7[-5]

names.normals.matching.pre.aug7.minus.last.one <- names.normals.matching.pre.aug7[-5]

indices.of.normals.not.matching.pre.aug7 <- sort(setdiff(c(1:length(out.pros.normals$ids.files)), indices.of.normals.matching.pre.aug7.without.NAs))


sample.size <- 6
set.seed(1816463389)
pros.aug7.random.indices <- sort(sample(indices.of.normals.not.matching.pre.aug7, size = sample.size))



# combine the 4 normals that match previously run ones with
#  6 new randomly chosen normals:
print.nice.ids.vector(c(sb.ids.normals.matching.pre.aug7.minus.last.one, out.pros.normals$ids.files[pros.aug7.random.indices]))

print.nice.ids.vector(c(names.normals.matching.pre.aug7.minus.last.one, out.pros.normals$names.files[pros.aug7.random.indices]))

## THESE ARE SB IDS, NOT PROJECT IDS:


sb.ids.prosnormalsaug7 <- c("564a3c27e4b08c5d8691bff7", "564a39c0e4b0ef121819e9f9", "564a34a6e4b08c5d868f5bcd", "564a3fb3e4b09c884b25a6b9", "564a3516e4b0298dd2c66118", "564a3a1ae4b0ef12181a06e7", "564a3a81e4b093830b68fa04", "564a3c4ee4b093830b698edb", "564a3c92e4b0298dd2c8c78e", "564a3d97e4b08c5d86923499")


## OLD:   c("564a3c27e4b08c5d8691bff7", "564a39c0e4b0ef121819e9f9", "564a34a6e4b08c5d868f5bcd", "564a3fb3e4b09c884b25a6b9", "564a355ce4b093830b67560d", "564a3516e4b0298dd2c66118", "564a3a1ae4b0ef12181a06e7", "564a3a81e4b093830b68fa04", "564a3c4ee4b093830b698edb", "564a3d97e4b08c5d86923499")

## have to split into parts because of weird control G thing:
names.prosnormalaug7.part1 <- c("UNCID_2190663.3c3a7016-6270-4c87-af7d-53b46f7f8fd1.120223_UNC12-SN629_0186_AC0GA2ACXX_7_GATCAG.tar.gz", "UNCID_2339220.4e169e09-37da-42c9-bed4-2649212d9c6b.130221_UNC9-SN296_0338_BC1PYCACXX_8_ACAGTG.tar.gz", "UNCID_2190620.40c411e7-c0cb-4aff-8418-fd7400562bad.111219_UNC11-SN627_0175_BC0CKKACXX_2_ACTTGA.tar.gz", "UNCID_2189557.12358445-06b8-4055-8454-69b8544774fc.120521_UNC12-SN629_0212_AC0RWNACXX_4_CAGATC.tar.gz", "UNCID_2190618.f2ad4c22-c476-44af-a8ca-dffcae313ae2.111212_UNC15-SN850_0155_AD087AACXX_8_ACTTGA.tar.gz") 

names.prosnormalaug7.part2 <- c("UNCID_2189823.e95f79a8-15ea-4b95-9f8e-b63ada04c51e.120508_UNC13-SN749_0172_AD101FACXX_7_GATCAG.tar.gz", "UNCID_2187739.575740a1-6467-4f58-b462-6fd1a4f63c51.120814_UNC12-SN629_0220_AD13JAACXX_1_CTTGTA.tar.gz", "UNCID_2339218.d5a6b5e2-f1af-4b1f-bfbe-2b3c05f3f642.130226_UNC14-SN744_0315_AD1V5TACXX_5_TTAGGC.tar.gz", "UNCID_2339219.6b264e41-b852-4221-8e09-692a6a639ccf.130226_UNC14-SN744_0315_AD1V5TACXX_5_CGATGT.tar.gz", "UNCID_2339217.1eda4d9f-e9a1-4ee7-8c71-559c8940b751.130226_UNC14-SN744_0315_AD1V5TACXX_6_TGACCA.tar.gz")

names.prosnormalaug7 <- c(names.prosnormalaug7.part1, names.prosnormalaug7.part2)

## OLD:    c("UNCID_2190663.3c3a7016-6270-4c87-af7d-53b46f7f8fd1.120223_UNC12-SN629_0186_AC0GA2ACXX_7_GATCAG.tar.gz", "UNCID_2339220.4e169e09-37da-42c9-bed4-2649212d9c6b.130221_UNC9-SN296_0338_BC1PYCACXX_8_ACAGTG.tar.gz", "UNCID_2190620.40c411e7-c0cb-4aff-8418-fd7400562bad.111219_UNC11-SN627_0175_BC0CKKACXX_2_ACTTGA.tar.gz", "UNCID_2189557.12358445-06b8-4055-8454-69b8544774fc.120521_UNC12-SN629_0212_AC0RWNACXX_4_CAGATC.tar.gz")
## OLD:   c("UNCID_2190618.f2ad4c22-c476-44af-a8ca-dffcae313ae2.111212_UNC15-SN850_0155_AD087AACXX_8_ACTTGA.tar.gz", "UNCID_2189823.e95f79a8-15ea-4b95-9f8e-b63ada04c51e.120508_UNC13-SN749_0172_AD101FACXX_7_GATCAG.tar.gz", "UNCID_2187739.575740a1-6467-4f58-b462-6fd1a4f63c51.120814_UNC12-SN629_0220_AD13JAACXX_1_CTTGTA.tar.gz", "UNCID_2339218.d5a6b5e2-f1af-4b1f-bfbe-2b3c05f3f642.130226_UNC14-SN744_0315_AD1V5TACXX_5_TTAGGC.tar.gz", "UNCID_2339217.1eda4d9f-e9a1-4ee7-8c71-559c8940b751.130226_UNC14-SN744_0315_AD1V5TACXX_6_TGACCA.tar.gz")


## 

# Now copy these files to the machete project

out.sb.prosnormalsaug7 <- copy.many.files.with.sb.id.to.project(vec.sbids=sb.ids.prosnormalsaug7, proj.name="JSALZMAN/machete", auth.token=auth.token, tempdir=tempdir)

# AFTER COPYING, CHECK MANUALLY THAT THERE ARE NO _1_ PREFIXES


print.nice.ids.vector(out.sb.prosnormalsaug7$files.ids)
##  these are the ids for the project, not the SB ids
## c("57a7b986e4b05eca734dd5e4", "57a7b986e4b05eca734dd5e6", "57a7b987e4b05eca734dd5e8", "57a7b987e4b05eca734dd5ea", "57a7b988e4b05eca734dd5ec", "57a7b988e4b05eca734dd5ee", "57a7b988e4b05eca734dd5f0", "57a7b989e4b05eca734dd5f2", "57a7b989e4b05eca734dd5f4", "57a7b98ae4b05eca734dd5f6")
## names:
## names.prosnormalaug7.part1 <- c("UNCID_2190663.3c3a7016-6270-4c87-af7d-53b46f7f8fd1.120223_UNC12-SN629_0186_AC0GA2ACXX_7_GATCAG.tar.gz", "UNCID_2339220.4e169e09-37da-42c9-bed4-2649212d9c6b.130221_UNC9-SN296_0338_BC1PYCACXX_8_ACAGTG.tar.gz", "UNCID_2190620.40c411e7-c0cb-4aff-8418-fd7400562bad.111219_UNC11-SN627_0175_BC0CKKACXX_2_ACTTGA.tar.gz", "UNCID_2189557.12358445-06b8-4055-8454-69b8544774fc.120521_UNC12-SN629_0212_AC0RWNACXX_4_CAGATC.tar.gz", "UNCID_2190618.f2ad4c22-c476-44af-a8ca-dffcae313ae2.111212_UNC15-SN850_0155_AD087AACXX_8_ACTTGA.tar.gz") 

## names.prosnormalaug7.part2 <- c("UNCID_2189823.e95f79a8-15ea-4b95-9f8e-b63ada04c51e.120508_UNC13-SN749_0172_AD101FACXX_7_GATCAG.tar.gz", "UNCID_2187739.575740a1-6467-4f58-b462-6fd1a4f63c51.120814_UNC12-SN629_0220_AD13JAACXX_1_CTTGTA.tar.gz", "UNCID_2339218.d5a6b5e2-f1af-4b1f-bfbe-2b3c05f3f642.130226_UNC14-SN744_0315_AD1V5TACXX_5_TTAGGC.tar.gz", "UNCID_2339219.6b264e41-b852-4221-8e09-692a6a639ccf.130226_UNC14-SN744_0315_AD1V5TACXX_5_CGATGT.tar.gz", "UNCID_2339217.1eda4d9f-e9a1-4ee7-8c71-559c8940b751.130226_UNC14-SN744_0315_AD1V5TACXX_6_TGACCA.tar.gz")

## names.prosnormalaug7 <- c(names.prosnormalaug7.part1, names.prosnormalaug7.part2)



##################################################################
# more lung normals for aug 10 run
## BUT I MADE A MISTAKE- THESE ARE ACTUALLY TUMOR
## BUT I MADE A MISTAKE- THESE ARE ACTUALLY TUMOR
# lungnormalsaug10
##################################################################

# Already got the results, so just read them in:

# READ in results
lung.all.tumors.df <- read.table(file=file.path(homedir, "lung.july21.query.tumor.csv"), header=TRUE, sep =",", stringsAsFactors=FALSE) 

lung.all.normals.df <- read.table(file=file.path(homedir, "lung.july21.query.normal.csv"), header=TRUE, sep =",", stringsAsFactors=FALSE) 

dim(lung.all.tumors.df); dim(lung.all.normals.df)
# 540 3, 59 3

# Now choose a unique file for each case:

lung.unique.tumors.df <- choose.one.file.for.each.case(lung.all.tumors.df)
lung.unique.normals.df <- choose.one.file.for.each.case(lung.all.normals.df)
dim(lung.unique.tumors.df); dim(lung.unique.normals.df)
# 516 3, 59 3


# first find cases that match with normals
ids.cases.lung.tumors.with.matched.normals <- intersect(lung.all.tumors.df$ids.cases, lung.all.normals.df$ids.cases)
length(ids.cases.lung.tumors.with.matched.normals)
# [1] 58
# matches data browser query

ids.lung.tumors.with.matched.normals <- lung.unique.tumors.df$ids.files[which(lung.unique.tumors.df$ids.cases %in% ids.cases.lung.tumors.with.matched.normals)]
length(ids.lung.tumors.with.matched.normals)
# 58


df.lung.tumors.with.matched.normals <- lung.unique.tumors.df[which(lung.unique.tumors.df$ids.cases %in% ids.cases.lung.tumors.with.matched.normals),]
dim(df.lung.tumors.with.matched.normals)
# 58 3


ids.lung.run.before.july21.in.project <- c("57853411e4b035347bd55990", "57853411e4b035347bd55998", "57853411e4b035347bd55996", "57853411e4b035347bd55994", "57853411e4b035347bd55992", "57853411e4b035347bd55988", "57853411e4b035347bd5597e", "57853411e4b035347bd5597f", "57853411e4b035347bd55986", "57853411e4b035347bd55984", "57853411e4b035347bd55980", "57853411e4b035347bd5599a", "57853411e4b035347bd5598e", "57853411e4b035347bd5598c", "57853411e4b035347bd5598a")

lungjuly22.ids <- c("57929d38e4b02380c5a05441", "57929d39e4b02380c5a05443", "57929d3ae4b02380c5a05445", "57929d3ae4b02380c5a05447", "57929d3be4b02380c5a05449", "57929d3ce4b02380c5a0544b", "57929d3ce4b02380c5a0544d", "57929d3de4b02380c5a0544f", "57929d3ee4b02380c5a05451", "57929d3ee4b02380c5a05453", "57929d3fe4b02380c5a05455", "57929d40e4b02380c5a05457", "57929d41e4b02380c5a05459", "57929d41e4b02380c5a0545b", "57929d42e4b02380c5a0545d", "57929d42e4b02380c5a0545f", "57929d43e4b02380c5a05461")

## ids in project, NOT sb ids
ids.lung.tumors.run.before.aug8.in.project <- c(ids.lung.run.before.july21.in.project, lungjuly22.ids)
length(ids.lung.tumors.run.before.aug8.in.project)
## 32

## ids in project, NOT sb ids, from normals-pre-july-13 
## looked at these manually to get these
ids.lung.normals.pre.july13 <- c("57853411e4b035347bd55990", "57853411e4b035347bd55980")

## ids in project, NOT sb ids, from normalsjuly29.ids
ids.normalsjuly29 <- c("579b932ee4b0dac228481ee2", "579b932fe4b0dac228481ee4", "579b932fe4b0dac228481ee6", "579b9330e4b0dac228481ee8", "579b9330e4b0dac228481eea", "579b9330e4b0dac228481eec", "579b9331e4b0dac228481eee", "579b9331e4b0dac228481ef0", "579b9332e4b0dac228481ef2", "579b9332e4b0dac228481ef4", "579b9333e4b0dac228481ef6", "579b9333e4b0dac228481ef8", "579b9333e4b0dac228481efa", "579b9334e4b0dac228481efc", "579b9334e4b0dac228481efe", "579b9335e4b0dac228481f00")

ids.lung.normals.run.before.aug8.in.project <- c(ids.normalsjuly29, ids.lung.normals.pre.july13)
length(ids.lung.normals.run.before.aug8.in.project)
## 18

names.lung.tumors.run.before.aug8 <- get.filenames.from.fileids(fileids = ids.lung.tumors.run.before.aug8.in.project, allnames=allfilenames, allids=allfileids)
# SHOULD VISUALLY CHECK that there are no "1_" files here and do
# something if there are!

names.lung.normals.run.before.aug8 <- get.filenames.from.fileids(fileids = ids.lung.normals.run.before.aug8.in.project, allnames=allfilenames, allids=allfileids)


# get case ids for lung runs before aug8:
ind.preaug8.tumors <- which(lung.all.tumors.df$names.files %in% names.lung.tumors.run.before.aug8)
#    7  10  11  19  44  46  64  75  84  93 112 119 132 155 179 184 192 200 204
## [20] 261 263 270 298 327 366 396 441 451 477 483
##
setdiff(names.lung.tumors.run.before.aug8, lung.all.tumors.df$names.files)
## "UNCID_2200015.4cc61cbe-fa79-499b-9fd5-9b454030154c.111208_UNC10-SN254_0312_AD0JRVACXX_3_TAGCTT.tar.gz"
## actually a normal
## https://cgc.sbgenomics.com/u/JSALZMAN/machete/files/57853411e4b035347bd55990/

## "UNCID_2200412.d3b983d1-2665-4cdd-893e-4f120dc43346.111130_UNC10-SN254_0310_BC06BYACXX_6_ATCACG.tar.gz"
## actually a normal
## https://cgc.sbgenomics.com/u/JSALZMAN/machete/files/57853411e4b035347bd55980/
## both were run in lungjuly12.ids
## 


ind.preaug8.normals <- which(lung.all.normals.df$names.files %in% names.lung.normals.run.before.aug8)
ind.preaug8.normals
## [1]  4  6 14 17 20 22 24 29 32 33 34 37 38 39 42 43 45 49
length(ind.preaug8.normals)
## [1] 18

ind.preaug8.mislabeled.1 <- which(lung.all.tumors.df$names.files %in% names.lung.normals.run.before.aug8)
ind.preaug8.mislabeled.2 <- which(lung.all.normals.df$names.files %in% names.lung.tumors.run.before.aug8)
## 17 29 (only in the second one, the first one is empty)
## These are the ones described above, which ran in lungjuly12 before we knew that
##   there were normals in the files.
## lung.all.normals.df$names.files[c(17,29)]
## [1] "UNCID_2200015.4cc61cbe-fa79-499b-9fd5-9b454030154c.111208_UNC10-SN254_0312_AD0JRVACXX_3_TAGCTT.tar.gz"
## [2] "UNCID_2200412.d3b983d1-2665-4cdd-893e-4f120dc43346.111130_UNC10-SN254_0310_BC06BYACXX_6_ATCACG.tar.gz"



cases.preaug8.tumors <- lung.all.tumors.df$ids.cases[ind.preaug8.tumors]
cases.preaug8.normals <- lung.all.normals.df$ids.cases[ind.preaug8.normals]
cases.preaug8.mislabeled.1 <- lung.all.tumors.df$ids.cases[ind.preaug8.mislabeled.1]
cases.preaug8.mislabeled.2 <- lung.all.normals.df$ids.cases[ind.preaug8.mislabeled.2]
cases.preaug8.all <- union(cases.preaug8.normals, union(cases.preaug8.tumors, cases.preaug8.mislabeled))
length(cases.preaug8.tumors);  length(cases.preaug8.normals); length(cases.preaug8.mislabeled.1); length(cases.preaug8.mislabeled.2); length(cases.preaug8.all)
## 30  18  0  2  34

# cases that have matched normals
cases.lung.tumors.with.matched.normals <- df.lung.tumors.with.matched.normals$ids.cases
length(cases.lung.tumors.with.matched.normals)
## 58
length(intersect(cases.lung.tumors.with.matched.normals, cases.preaug8.tumors)); length(intersect(cases.lung.tumors.with.matched.normals, cases.preaug8.normals)); length(intersect(cases.lung.tumors.with.matched.normals, cases.preaug8.mislabeled.1)) ; length(intersect(cases.lung.tumors.with.matched.normals, cases.preaug8.mislabeled.2))
## 19   18  0  2

lung.cases.with.matched.normals.and.not.run.before.aug8 <- setdiff(cases.lung.tumors.with.matched.normals, cases.preaug8.all)
length(lung.cases.with.matched.normals.and.not.run.before.aug8); length(cases.lung.tumors.with.matched.normals); length(cases.preaug8.all)
# 37 58 34

## HERE IS WHERE I MADE A MISTAKE; I WAS USING THE TUMORS INSTEAD OF
## THE NORMALS

########################################
# start skipping here to go to new stuff to get normals
########################################



# now get the ids not run before aug 8, by first creating a df:
df.lung.tumors.with.matched.normals.not.run.before.aug8 <- df.lung.tumors.with.matched.normals[df.lung.tumors.with.matched.normals$ids.cases %in% lung.cases.with.matched.normals.and.not.run.before.aug8,]
dim(df.lung.tumors.with.matched.normals.not.run.before.aug8)
# 37 3


# Note that these are the ids for sb, not the ids in the project:
ids.lung.with.matched.normals.not.run.before.aug8 <- df.lung.tumors.with.matched.normals.not.run.before.aug8$ids.files

n.ids.lung.with.matched.normals.not.run.before.aug8 <- length(ids.lung.with.matched.normals.not.run.before.aug8)

n.ids.lung.with.matched.normals.not.run.before.aug8
## 37


# choose a random 17 of these:
sample.size <- 10
set.seed(18390455)
lung.with.matched.normals.random.indices <- sample(n.ids.lung.with.matched.normals.not.run.before.aug8, size = sample.size)
## 32 26 34  7 36  6 15 21 30 11

ids.sb.lung.with.matched.normals.aug10.run <- ids.lung.with.matched.normals.not.run.before.aug8[lung.with.matched.normals.random.indices]
print.nice.ids.vector(ids.sb.lung.with.matched.normals.aug10.run)
#  these are the SB ids (not the ids for the project)
# for easy replication:
ids.sb.lung.with.matched.normals.aug10.run <- c("564a5a00e4b093830b6c8c36", "564a58b6e4b0298dd2cb45d5", "564a5a60e4b09c884b27624b", "564a3aa0e4b08c5d8691428f", "564a5aa2e4b08c5d8694fab9", "564a3a68e4b0298dd2c816ce", "564a3cfce4b093830b69c793", "564a3f4ae4b0ef12181baed1", "564a598ee4b0298dd2cb8cc4", "564a3befe4b0298dd2c89353")


# check out the cases, compare manually a bit, and with intersect,
#  that they don't intersect with
#  ones run before aug 8
cases.sb.lung.with.matched.normals.aug10.run <- df.lung.tumors.with.matched.normals.not.run.before.aug8$ids.cases[lung.with.matched.normals.random.indices]
cases.preaug8.all
intersect(cases.sb.lung.with.matched.normals.aug10.run, cases.preaug8.all)
## empty



# Now copy these files to the machete project

# out.sb.lung.with.matched.normals.copy.aug10 <- copy.many.files.with.sb.id.to.project(vec.sbids=ids.sb.lung.with.matched.normals.aug10.run, proj.name="JSALZMAN/machete", auth.token=auth.token, tempdir=tempdir)

# AFTER COPYING, CHECK MANUALLY THAT THERE ARE NO _1_ PREFIXES

# In previous version, there was an error - see setdefs.R copy.file.with.sb.id.to.project
# problem with UNCID_2197473
# 564a5a07e4b0298dd2cbb5b0
# test93weird.json
# missing age at diagnosis for this one
# Looking here it's listed with a blank:
# https://cgc.sbgenomics.com/u/JSALZMAN/machete/files/564a5a07e4b0298dd2cbb5b0/


#  after outputting the next thing, copying and pasting and editing, use it in runapi.R
# 
print.nice.ids.vector(out.sb.lung.with.matched.normals.copy.aug10$files.ids)
#  these are the ids for the project, not the SB ids
# c("57a91b11e4b054ebb03814e9", "57a91b12e4b054ebb03814eb", "57a91b12e4b054ebb03814ed", "57a91b13e4b054ebb03814ef", "57a91b13e4b054ebb03814f1", "57a91b13e4b054ebb03814f3", "57a91b14e4b054ebb03814f5", "57a91b14e4b054ebb03814f7", "57a91b15e4b054ebb03814f9", "57a91b15e4b054ebb03814fb")

## Just copied file UNCID_2200473.5969b621-a81e-42aa-ac40-4849df285060.111130_UNC10-SN254_0310_BC06BYACXX_2_TTAGGC.tar.gz 
## Just copied file UNCID_2188026.bc6c762f-727f-43c8-a4bc-4c41351c7f13.120724_UNC11-SN627_0247_AC0Y10ACXX_2_GATCAG.tar.gz 
## Just copied file UNCID_2200118.4502921a-1650-4721-b814-c9435fe6042d.111208_UNC10-SN254_0313_BD087RACXX_1_TTAGGC.tar.gz 
## Just copied file UNCID_2200550.29af0307-5d76-462d-beee-18e8c4f179b8.111118_UNC11-SN627_0168_BC059VACXX_8_ATCACG.tar.gz 
## Just copied file UNCID_2197655.4f5215c3-7763-49f8-afe7-b3ce3474afe2.120113_UNC14-SN744_0200_AC0F4CACXX_2_CTTGTA.tar.gz 
## Just copied file UNCID_2206635.847f00ce-5f09-4e12-90c5-ebdf7612d707.111003_UNC9-SN296_0247_BB01WJABXX_3_ACTTGA.tar.gz 
## Just copied file UNCID_2197271.8b0a1ab6-e7ea-45f9-9e3a-bd98b3f59972.111122_UNC13-SN749_0137_BD098JACXX_1_GATCAG.tar.gz 
## Just copied file UNCID_2198771.bf920e10-514e-4623-b92e-c83a3e32485f.120104_UNC16-SN851_0120_BD0J72ACXX_1_ATCACG.tar.gz 
## Just copied file UNCID_2200852.c54cd39c-c7fc-4a0c-9d33-9c1f78c80871.111122_UNC16-SN851_0111_BD09J2ACXX_8_TTAGGC.tar.gz 
## Just copied file UNCID_2200262.e3958992-3206-4cdd-8bc9-38fd43853800.111129_UNC10-SN254_0309_AD095JACXX_7_ATCACG.tar.gz 

# also get names for saving them in my info file
out.files.list <- list.all.files.project(projname="JSALZMAN/machete", ttwdir=wdir, tempdir=tempdir, auth.token=auth.token, max.iterations=max.iterations)
allfilenames <- out.files.list$filenames 
allfileids <- out.files.list$fileids
lung.with.matched.normals.aug10.file.names <- get.filenames.from.fileids(fileids = out.sb.lung.with.matched.normals.copy.aug10$files.ids, allnames=allfilenames, allids=allfileids)
print.nice.ids.vector(lung.with.matched.normals.aug10.file.names)
print.nice.ids.vector(lung.with.matched.normals.aug10.file.names)
## c("UNCID_2200473.5969b621-a81e-42aa-ac40-4849df285060.111130_UNC10-SN254_0310_BC06BYACXX_2_TTAGGC.tar.gz", "UNCID_2188026.bc6c762f-727f-43c8-a4bc-4c41351c7f13.120724_UNC11-SN627_0247_AC0Y10ACXX_2_GATCAG.tar.gz", "UNCID_2200118.4502921a-1650-4721-b814-c9435fe6042d.111208_UNC10-SN254_0313_BD087RACXX_1_TTAGGC.tar.gz", "UNCID_2200550.29af0307-5d76-462d-beee-18e8c4f179b8.111118_UNC11-SN627_0168_BC059VACXX_8_ATCACG.tar.gz", "UNCID_2197655.4f5215c3-7763-49f8-afe7-b3ce3474afe2.120113_UNC14-SN744_0200_AC0F4CACXX_2_CTTGTA.tar.gz", "UNCID_2206635.847f00ce-5f09-4e12-90c5-ebdf7612d707.111003_UNC9-SN296_0247_BB01WJABXX_3_ACTTGA.tar.gz", "UNCID_2197271.8b0a1ab6-e7ea-45f9-9e3a-bd98b3f59972.111122_UNC13-SN749_0137_BD098JACXX_1_GATCAG.tar.gz", "UNCID_2198771.bf920e10-514e-4623-b92e-c83a3e32485f.120104_UNC16-SN851_0120_BD0J72ACXX_1_ATCACG.tar.gz", "UNCID_2200852.c54cd39c-c7fc-4a0c-9d33-9c1f78c80871.111122_UNC16-SN851_0111_BD09J2ACXX_8_TTAGGC.tar.gz", "UNCID_2200262.e3958992-3206-4cdd-8bc9-38fd43853800.111129_UNC10-SN254_0309_AD095JACXX_7_ATCACG.tar.gz")


########################################
# resume here to do new stuff to get normals
########################################

df.lung.normals.with.matched.tumors <- lung.unique.normals.df[which(lung.unique.normals.df$ids.cases %in% ids.cases.lung.tumors.with.matched.normals),]
dim(df.lung.normals.with.matched.tumors)
## 58 3


# now get the ids not run before aug 8, by first creating a df:
df.lung.normals.with.matched.tumors.not.run.before.aug8 <- df.lung.normals.with.matched.tumors[df.lung.normals.with.matched.tumors$ids.cases %in% lung.cases.with.matched.normals.and.not.run.before.aug8,]
dim(df.lung.normals.with.matched.tumors.not.run.before.aug8)
# 37 3


## Note that these are the ids for sb, not the ids in the project: 
ids.lung.with.matched.tumors.not.run.before.aug8 <- df.lung.normals.with.matched.tumors.not.run.before.aug8$ids.files

n.ids.lung.with.matched.tumors.not.run.before.aug8 <- length(ids.lung.with.matched.tumors.not.run.before.aug8)

n.ids.lung.with.matched.tumors.not.run.before.aug8
## 37


# choose a random 10 of these:
sample.size <- 10
set.seed(1346455)
lung.with.matched.tumors.random.indices <- sort(sample(n.ids.lung.with.matched.tumors.not.run.before.aug8, size = sample.size))
##  3  5  7 12 13 17 21 23 33 36


ids.sb.lung.with.matched.tumors.aug11.run <- ids.lung.with.matched.tumors.not.run.before.aug8[lung.with.matched.tumors.random.indices]
print.nice.ids.vector(ids.sb.lung.with.matched.tumors.aug11.run)
#  these are the SB ids (not the ids for the project)
# for easy replication:
ids.sb.lung.with.matched.tumors.aug11.run <- c("564a3968e4b08c5d8690dfc2", "564a3a5ee4b0ef12181a1c21", "564a3aa1e4b0298dd2c82899", "564a3c01e4b08c5d8691b46b", "564a3c35e4b093830b698655", "564a3da6e4b09c884b250c00", "564a3f4ae4b09c884b2588b9", "564a5650e4b08c5d86938ef4", "564a5a1fe4b09c884b27507b", "564a5aa2e4b0298dd2cbe8bd")



# check out the cases, compare manually a bit, and with intersect,
#  that they don't intersect with
#  ones run before aug 8
cases.sb.lung.with.matched.tumors.aug11.run <- df.lung.normals.with.matched.tumors.not.run.before.aug8$ids.cases[lung.with.matched.tumors.random.indices]
cases.preaug8.all
intersect(cases.sb.lung.with.matched.tumors.aug11.run, cases.preaug8.all)
## empty



# Now copy these files to the machete project

out.sb.lung.with.matched.tumors.copy.aug11 <- copy.many.files.with.sb.id.to.project(vec.sbids=ids.sb.lung.with.matched.tumors.aug11.run, proj.name="JSALZMAN/machete", auth.token=auth.token, tempdir=tempdir)

## AFTER COPYING, CHECK MANUALLY THAT THERE ARE NO _1_ PREFIXES


#  after outputting the next thing, copying and pasting and editing, use it in runapi.R
# 
print.nice.ids.vector(out.sb.lung.with.matched.tumors.copy.aug11$files.ids)
#  these are the ids for the project, not the SB ids
#   c("57acefa1e4b054ebb03943ee", "57acefa2e4b054ebb03943f0", "57acefa2e4b054ebb03943f2", "57acefa3e4b054ebb03943f4", "57acefa3e4b054ebb03943f6", "57acefa4e4b054ebb03943f8", "57acefa4e4b054ebb03943fa", "57acefa5e4b054ebb03943fc", "57acefa5e4b054ebb03943fe", "57acefa6e4b054ebb0394400")

## Just copied file UNCID_2197545.e448d6d2-be85-4164-be3f-fd7e5a0c53ec.120113_UNC14-SN744_0200_AC0F4CACXX_3_TGACCA.tar.gz 
## Just copied file UNCID_2199986.c6722ce9-8824-4721-9e95-96e9b0b09066.111208_UNC10-SN254_0312_AD0JRVACXX_3_GATCAG.tar.gz 
## Just copied file UNCID_2200018.2f16ddcc-8a98-4734-9878-645ff102fb14.111208_UNC10-SN254_0312_AD0JRVACXX_2_ATCACG.tar.gz 
## Just copied file UNCID_2187834.ca16fef9-9795-4a33-899f-9bf111ee093e.120723_UNC10-SN254_0372_AC0T70ACXX_7_GATCAG.tar.gz 
## Just copied file UNCID_2197175.0569af63-9a1d-4f03-9a67-1269c7973677.111122_UNC13-SN749_0137_BD098JACXX_5_GGCTAC.tar.gz 
## Just copied file UNCID_2199338.2b7e9552-e34f-4c68-96af-1c01a605df60.111229_UNC15-SN850_0157_AD0MHHACXX_7_TGACCA.tar.gz 
## Just copied file UNCID_2197582.d777ced1-c519-4281-b0c0-9e9188303e87.120113_UNC14-SN744_0200_AC0F4CACXX_5_ACAGTG.tar.gz 
## Just copied file UNCID_2198729.b3b1d4f3-1511-40a5-bf62-0ddf0893eac5.120104_UNC16-SN851_0120_BD0J72ACXX_4_TGACCA.tar.gz 
## Just copied file UNCID_2198748.0ab304f8-0976-4637-8955-199e1782ab16.120104_UNC16-SN851_0120_BD0J72ACXX_3_TAGCTT.tar.gz 
## Just copied file UNCID_2199367.fc4df3f7-2c4b-4a4d-9e5d-faac9e84fde8.111229_UNC15-SN850_0157_AD0MHHACXX_4_TTAGGC.tar.gz

# also get names for saving them in my info file
out.files.list <- list.all.files.project(projname="JSALZMAN/machete", ttwdir=wdir, tempdir=tempdir, auth.token=auth.token, max.iterations=max.iterations)
allfilenames <- out.files.list$filenames 
allfileids <- out.files.list$fileids
lung.with.matched.tumors.aug11.file.names <- get.filenames.from.fileids(fileids = out.sb.lung.with.matched.tumors.copy.aug11$files.ids, allnames=allfilenames, allids=allfileids)
print.nice.ids.vector(lung.with.matched.tumors.aug11.file.names)
## c("UNCID_2197545.e448d6d2-be85-4164-be3f-fd7e5a0c53ec.120113_UNC14-SN744_0200_AC0F4CACXX_3_TGACCA.tar.gz", "UNCID_2199986.c6722ce9-8824-4721-9e95-96e9b0b09066.111208_UNC10-SN254_0312_AD0JRVACXX_3_GATCAG.tar.gz", "UNCID_2200018.2f16ddcc-8a98-4734-9878-645ff102fb14.111208_UNC10-SN254_0312_AD0JRVACXX_2_ATCACG.tar.gz", "UNCID_2187834.ca16fef9-9795-4a33-899f-9bf111ee093e.120723_UNC10-SN254_0372_AC0T70ACXX_7_GATCAG.tar.gz", "UNCID_2197175.0569af63-9a1d-4f03-9a67-1269c7973677.111122_UNC13-SN749_0137_BD098JACXX_5_GGCTAC.tar.gz", "UNCID_2199338.2b7e9552-e34f-4c68-96af-1c01a605df60.111229_UNC15-SN850_0157_AD0MHHACXX_7_TGACCA.tar.gz", "UNCID_2197582.d777ced1-c519-4281-b0c0-9e9188303e87.120113_UNC14-SN744_0200_AC0F4CACXX_5_ACAGTG.tar.gz", "UNCID_2198729.b3b1d4f3-1511-40a5-bf62-0ddf0893eac5.120104_UNC16-SN851_0120_BD0J72ACXX_4_TGACCA.tar.gz", "UNCID_2198748.0ab304f8-0976-4637-8955-199e1782ab16.120104_UNC16-SN851_0120_BD0J72ACXX_3_TAGCTT.tar.gz", "UNCID_2199367.fc4df3f7-2c4b-4a4d-9e5d-faac9e84fde8.111229_UNC15-SN850_0157_AD0MHHACXX_4_TTAGGC.tar.gz")



#####################################################################
#####################################################################
# aug 15 10 lymphomas   
# Doesn't have any MATCHED NORMALS
# Lymphoid Neoplasm Diffuse Large B-cell Lymphoma
#####################################################################
#####################################################################


out.lymph.tumors <- get.files.with.tumor.or.normal(tempdir, homedir, query.template.file="lymphqueryaug15.json", auth.token,  tt.files.per.download= files.per.download, sample.type="Primary Tumor", output.csv = "lymph.aug15.query.tumor.csv")

out.lymph.normals <- get.files.with.tumor.or.normal(tempdir, homedir, query.template.file="lymphqueryaug15.json", auth.token,  tt.files.per.download= files.per.download, sample.type="Solid Tissue Normal", output.csv = "lymph.aug15.query.normal.csv")
# Gives json file "NOT_FOUND" (expected something like that)

# READ in results
lymph.all.tumors.df <- read.table(file=file.path(homedir, "lymph.aug15.query.tumor.csv"), header=TRUE, sep =",", stringsAsFactors=FALSE) 

dim(lymph.all.tumors.df)
# 48 3

# Now choose a unique file for each case:

lymph.unique.tumors.df <- choose.one.file.for.each.case(lymph.all.tumors.df)
dim(lymph.unique.tumors.df)
# 48 3

# cases for lymph tumors
cases.lymph.tumors <- lymph.unique.tumors.df$ids.cases


# now get the ids not run before aug 1, by first creating a df:


# Note that these are the ids for sb, not the ids in the project:
ids.lymph.all <- lymph.unique.tumors.df$ids.files

n.ids.lymph.all <- length(ids.lymph.all)

n.ids.lymph.all
# 48





# choose a random 10 of these:
sample.size <- 10
set.seed(18323479)
lymph.random.indices <- sample(n.ids.lymph.all, size = sample.size)

ids.sb.lymph.aug15.run <- ids.lymph.all[lymph.random.indices]
#  these are the SB ids (not the ids for the project)
# for easy replcation, can copy and paste results of next line:
print.nice.ids.vector(ids.sb.lymph.aug15.run)
# ids.sb.lymph.aug15.run <- c("564a32a3e4b08c5d868eb7c7", "564a32b4e4b0298dd2c59f86", "564a321be4b0298dd2c56e97", "564a32ebe4b08c5d868ecf9a", "564a3313e4b09c884b21cf21", "564a32c6e4b0298dd2c5a584", "564a31b4e4b0298dd2c54e48", "564a32afe4b09c884b21b0ba", "564a3222e4b08c5d868e8f5a", "564a3214e4b0ef121817736c")


names.sb.lymph.aug15.run <- lymph.unique.tumors.df$names.files[lymph.random.indices]
names.sb.lymph.aug15.run

## > names.sb.lymph.aug15.run
##  [1] "UNCID_2272258.144739d3-b2d3-493c-8731-d652f03a5b37.130926_SN254_0496_AD2DY9ACXX_6_ACAGTG.tar.gz"      
##  [2] "UNCID_2581261.bc8a3747-bd29-4388-94b9-74d92b6db3a3.140509_UNC12-SN629_0368_BC4241ACXX_5_GCCAAT.tar.gz"
##  [3] "UNCID_2272264.c6930a35-3476-46a0-adde-da76ee758390.130909_UNC15-SN850_0327_BD2DT1ACXX_8_ACAGTG.tar.gz"
##  [4] "UNCID_2272274.5bce51af-fa6e-4fd2-b3b0-114eb8a275a9.130814_UNC10-SN254_0487_AC2BD1ACXX_3_TGACCA.tar.gz"
##  [5] "UNCID_2272268.95db81b0-d9e6-4cbf-b13f-7c1b92c26484.130909_UNC15-SN850_0327_BD2DT1ACXX_6_CGATGT.tar.gz"
##  [6] "UNCID_2272266.52ece957-8f21-4f13-a61d-7b2e1c850ef5.130909_UNC15-SN850_0327_BD2DT1ACXX_7_GCCAAT.tar.gz"
##  [7] "UNCID_2580232.827ebf10-230a-442b-aaae-80e1e0210bb5.140521_UNC13-SN749_0354_BC4GJ7ACXX_1_GATCAG.tar.gz"
##  [8] "UNCID_2580360.a3ca2450-1f4e-4372-bdd4-46f83e2e9602.140603_UNC11-SN627_0360_AC4H72ACXX_5_CAGATC.tar.gz"
##  [9] "UNCID_2272273.d15202c0-099f-46c9-99c0-cc6bdf3e82b1.130814_UNC10-SN254_0487_AC2BD1ACXX_4_CTTGTA.tar.gz"
## [10] "UNCID_2580725.7c955c67-e0be-4c07-b0e9-b70da3a7f116.140603_UNC15-SN850_0369_BC4H6YACXX_6_AGTCAA.tar.gz"



# Now copy these files to the machete project

out.sb.lymph.copy.aug15 <- copy.many.files.with.sb.id.to.project(vec.sbids=ids.sb.lymph.aug15.run, proj.name="JSALZMAN/machete", auth.token=auth.token, tempdir=tempdir)

# AFTER COPYING, CHECK MANUALLY THAT THERE ARE NO _1_ PREFIXES



#  after outputting the next thing, copying and pasting, use it in runapi.R
# 
print.nice.ids.vector(out.sb.lymph.copy.aug15$files.ids)
# c("57b25cafe4b0192c34a4b2c7", "57b25cb0e4b0192c34a4b2c9", "57b25cb0e4b0192c34a4b2cb", "57b25cb1e4b0192c34a4b2cd", "57b25cb1e4b0192c34a4b2cf", "57b25cb2e4b0192c34a4b2d1", "57b25cb2e4b0192c34a4b2d3", "57b25cb3e4b0192c34a4b2d5", "57b25cb3e4b0192c34a4b2d7", "57b25cb3e4b0192c34a4b2d9")

print.nice.ids.vector(names.sb.lymph.aug15.run)
# c("UNCID_2272258.144739d3-b2d3-493c-8731-d652f03a5b37.130926_SN254_0496_AD2DY9ACXX_6_ACAGTG.tar.gz", "UNCID_2581261.bc8a3747-bd29-4388-94b9-74d92b6db3a3.140509_UNC12-SN629_0368_BC4241ACXX_5_GCCAAT.tar.gz", "UNCID_2272264.c6930a35-3476-46a0-adde-da76ee758390.130909_UNC15-SN850_0327_BD2DT1ACXX_8_ACAGTG.tar.gz", "UNCID_2272274.5bce51af-fa6e-4fd2-b3b0-114eb8a275a9.130814_UNC10-SN254_0487_AC2BD1ACXX_3_TGACCA.tar.gz", "UNCID_2272268.95db81b0-d9e6-4cbf-b13f-7c1b92c26484.130909_UNC15-SN850_0327_BD2DT1ACXX_6_CGATGT.tar.gz", "UNCID_2272266.52ece957-8f21-4f13-a61d-7b2e1c850ef5.130909_UNC15-SN850_0327_BD2DT1ACXX_7_GCCAAT.tar.gz", "UNCID_2580232.827ebf10-230a-442b-aaae-80e1e0210bb5.140521_UNC13-SN749_0354_BC4GJ7ACXX_1_GATCAG.tar.gz", "UNCID_2580360.a3ca2450-1f4e-4372-bdd4-46f83e2e9602.140603_UNC11-SN627_0360_AC4H72ACXX_5_CAGATC.tar.gz", "UNCID_2272273.d15202c0-099f-46c9-99c0-cc6bdf3e82b1.130814_UNC10-SN254_0487_AC2BD1ACXX_4_CTTGTA.tar.gz", "UNCID_2580725.7c955c67-e0be-4c07-b0e9-b70da3a7f116.140603_UNC15-SN850_0369_BC4H6YACXX_6_AGTCAA.tar.gz")
















##################################################################
## sqaug16
## Lung Squamous Cell Carcinoma
##################################################################


out.sq.tumors <- get.files.with.tumor.or.normal(tempdir, homedir, query.template.file="sqqueryaug16.json", auth.token,  tt.files.per.download= files.per.download, sample.type="Primary Tumor", output.csv = "sq.aug16.query.tumor.csv")

out.sq.normals <- get.files.with.tumor.or.normal(tempdir, homedir, query.template.file="sqqueryaug16.json", auth.token,  tt.files.per.download= files.per.download, sample.type="Solid Tissue Normal", output.csv = "sq.aug16.query.normal.csv")

# READ in results
sq.all.tumors.df <- read.table(file=file.path(homedir, "sq.aug16.query.tumor.csv"), header=TRUE, sep =",", stringsAsFactors=FALSE) 

sq.all.normals.df <- read.table(file=file.path(homedir, "sq.aug16.query.normal.csv"), header=TRUE, sep =",", stringsAsFactors=FALSE) 

dim(sq.all.tumors.df); dim(sq.all.normals.df)
# 504 3  51 3

# Now choose a unique file for each case:

sq.unique.tumors.df <- choose.one.file.for.each.case(sq.all.tumors.df)
sq.unique.normals.df <- choose.one.file.for.each.case(sq.all.normals.df)
dim(sq.unique.tumors.df); dim(sq.unique.normals.df)
## 504 3 51 3 


# find cases that match with normals
cases.sq.tumors.with.matched.normals <- intersect(sq.all.tumors.df$ids.cases, sq.all.normals.df$ids.cases)
length(cases.sq.tumors.with.matched.normals)
# [1] 51
# data browser query gives 51 of them, so this matches

sb.ids.sq.tumors.with.matched.normals <- sq.unique.tumors.df$ids.files[which(sq.unique.tumors.df$ids.cases %in% cases.sq.tumors.with.matched.normals)]
n.sb.ids.sq.tumors.with.matched.normals <- length(sb.ids.sq.tumors.with.matched.normals)
n.sb.ids.sq.tumors.with.matched.normals
## 51


df.sq.tumors.with.matched.normals <- sq.unique.tumors.df[which(sq.unique.tumors.df$ids.cases %in% cases.sq.tumors.with.matched.normals),]
dim(df.sq.tumors.with.matched.normals)
## 51 3




# choose a random 10 of these:
sample.size <- 10
set.seed(183327455)
sq.with.matched.normals.random.indices <- sample(n.sb.ids.sq.tumors.with.matched.normals, size = sample.size)

ids.sb.sq.with.matched.normals.aug16.run <- sb.ids.sq.tumors.with.matched.normals[sq.with.matched.normals.random.indices]
print.nice.ids.vector(ids.sb.sq.with.matched.normals.aug16.run)
#  these are the SB ids (not the ids for the project)
# for easy replcation:
# ids.sb.sq.with.matched.normals.aug16.run <- c("564a5a78e4b0ef12181de341", "564a588fe4b09c884b26e43e", "564a3d90e4b0298dd2c91a77", "564a59bae4b08c5d8694adb6", "564a40fbe4b093830b6b1142", "564a3da9e4b08c5d86923ae6", "564a3cdfe4b0298dd2c8e0f0", "564a5b5ae4b0298dd2cc211a", "564a58cbe4b08c5d86945e9c", "564a3b1ae4b0298dd2c84f50")


cases.sb.sq.with.matched.normals.aug16.run <- df.sq.tumors.with.matched.normals$ids.cases[sq.with.matched.normals.random.indices]
print.nice.ids.vector(cases.sb.sq.with.matched.normals.aug16.run)
## c("B0818BEE-C32C-405C-BA09-956091FBE09B", "BEF26F5E-A17E-49B7-8EB4-2BC079983764", "7B236171-2E7A-4018-B297-560EA8279EC0", "CE8612AB-3149-4A6A-B424-29C0C21C9B8B", "8FBE1F9E-F2A6-4550-AABF-B06607B821F0", "A3583FFC-ADB9-40F5-8EC5-8A4F6F432220", "37A0AB12-44AF-4815-B7CC-961D44851470", "BD3BF142-7C14-4538-8A76-3C6E140FA01A", "513C5F34-DC6E-4CAA-81CC-907FD6A825B1", "4718E180-C166-4826-B5A1-945F4A56EB16")


# Now copy these files to the machete project

out.sb.sq.with.matched.normals.copy.aug16 <- copy.many.files.with.sb.id.to.project(vec.sbids=ids.sb.sq.with.matched.normals.aug16.run, proj.name="JSALZMAN/machete", auth.token=auth.token, tempdir=tempdir)

# AFTER COPYING, CHECK MANUALLY THAT THERE ARE NO _1_ PREFIXES

#  after outputting the next thing, copying and pasting and editing, use it in runapi.R
# 
#  
print.nice.ids.vector(out.sb.sq.with.matched.normals.copy.aug16$files.ids)
## c("57b35e24e4b0192c34a4b60b", "57b35e25e4b0192c34a4b60d", "57b35e25e4b0192c34a4b60f", "57b35e26e4b0192c34a4b611", "57b35e26e4b0192c34a4b613", "57b35e27e4b0192c34a4b615", "57b35e27e4b0192c34a4b617", "57b35e27e4b0192c34a4b619", "57b35e28e4b0192c34a4b61b", "57b35e28e4b0192c34a4b61d")

print.nice.ids.vector(out.sb.sq.with.matched.normals.copy.aug16$files.names)





##################################################################
## ovaug18
## Ovarian, 20 more runs, tumors
## don't worry about matched normals at all
##################################################################


# REMEMBER TO CHANGE .JSON FILE MANUALLY

out.ov.tumors <- get.files.with.tumor.or.normal(tempdir, homedir, query.template.file="ovqueryaug18.json", auth.token,  tt.files.per.download= files.per.download, sample.type="Primary Tumor", output.csv = "ov.aug18.query.tumor.csv")
length(out.ov.tumors$ids.files)
# 422

out.ov.normals <- get.files.with.tumor.or.normal(tempdir, homedir, query.template.file="ovqueryaug18.json", auth.token,  tt.files.per.download= files.per.download, sample.type="Solid Tissue Normal", output.csv = "ov.aug18.query.normal.csv")
length(out.ov.normals$ids.files)
## Error in fromJSON(content, handler, default.size, depth, allowComments,  (from setdefs.R#98) :   invalid JSON input


## get indices of out.ov.tumors which
##  are in allfilenames, i.e. which we already downloaded
##  might get some that were downloaded but weren't run;
## skip these for now, more work, and don't need to in this setting

indices.ov.tumors.downloaded.by.aug18 <- sort(which(out.ov.tumors$names.files %in% allfilenames))
length(indices.ov.tumors.downloaded.by.aug18)
## 103

# now get the cases for the runs pre aug 18

ov.downloaded.by.aug18.cases <- out.ov.tumors$ids.cases[indices.ov.tumors.downloaded.by.aug18]
print.nice.ids.vector(ov.downloaded.by.aug18.cases)

# READ in results
ov.all.tumors.df <- read.table(file=file.path(homedir, "ov.aug18.query.tumor.csv"), header=TRUE, sep =",", stringsAsFactors=FALSE) 
dim(ov.all.tumors.df)
## 422 3

# Now choose a unique file for each case:
# although actually data browser tells us
#   as does this, that there is only one file per case
#   at least for the tumor
#   Note that there are 8 recurrent tumors, most of these overlap
#   with a primary tumor case

length(unique(ov.all.tumors.df$ids.cases))
## 422

ov.unique.tumors.df <- choose.one.file.for.each.case(ov.all.tumors.df)

n.total.ov.cases <- length(ov.unique.tumors.df$ids.cases)
n.total.ov.cases
## 422

indices.ov.tumors.not.downloaded.by.aug18 <- setdiff(c(1:n.total.ov.cases), indices.ov.tumors.downloaded.by.aug18)
n.ov.tumors.not.downloaded.by.aug18 <- length(indices.ov.tumors.not.downloaded.by.aug18)
n.ov.tumors.not.downloaded.by.aug18
## 319


# choose a random 20 of these:
sample.size <- 20
set.seed(2968455)
ov.random.indices <- sample(indices.ov.tumors.not.downloaded.by.aug18, size = sample.size)

sb.ids.ov.tumors.aug18.run <- ov.unique.tumors.df$ids.files[ov.random.indices]
cases.ov.tumors.aug18.run <- ov.unique.tumors.df$ids.cases[ov.random.indices]
names.ov.tumors.aug18.run <- ov.unique.tumors.df$names.files[ov.random.indices]
print.nice.ids.vector(names.ov.tumors.aug18.run)
## c("TCGA-23-1026-01B-01R-1569-13_rnaseq_fastq.tar", "TCGA-13-0924-01A-01R-1564-13_rnaseq_fastq.tar", "TCGA-13-0890-01A-01R-1564-13_rnaseq_fastq.tar", "TCGA-24-0979-01A-01R-1565-13_rnaseq_fastq.tar", "TCGA-24-1544-01A-01R-1566-13_rnaseq_fastq.tar", "TCGA-36-1578-01A-01R-1566-13_rnaseq_fastq.tar", "TCGA-29-1778-01A-01R-1567-13_rnaseq_fastq.tar", "TCGA-13-1499-01A-01R-1565-13_rnaseq_fastq.tar", "TCGA-13-1507-01A-01R-1565-13_rnaseq_fastq.tar", "TCGA-23-1113-01A-01R-1564-13_rnaseq_fastq.tar", "TCGA-20-1686-01A-01R-1566-13_rnaseq_fastq.tar", "TCGA-09-1659-01B-01R-1564-13_rnaseq_fastq.tar", "TCGA-30-1853-01A-02R-1567-13_rnaseq_fastq.tar", "TCGA-61-1910-01A-01R-1567-13_rnaseq_fastq.tar", "TCGA-25-2392-01A-01R-1569-13_rnaseq_fastq.tar", "TCGA-25-1313-01A-01R-1565-13_rnaseq_fastq.tar", "TCGA-24-1556-01A-01R-1566-13_rnaseq_fastq.tar", "TCGA-13-0762-01A-01R-1564-13_rnaseq_fastq.tar", "TCGA-23-1120-01A-02R-1565-13_rnaseq_fastq.tar", "TCGA-25-1633-01A-01R-1566-13_rnaseq_fastq.tar")


# Now copy these files to the machete project

out.ov.tumors.aug18.copying.process <- copy.many.files.with.sb.id.to.project(vec.sbids=sb.ids.ov.tumors.aug18.run, proj.name="JSALZMAN/machete", auth.token=auth.token, tempdir=tempdir)
## AFTER COPYING, CHECK MANUALLY THAT THERE ARE NO _1_ PREFIXES
## AFTER COPYING, CHECK MANUALLY THAT THERE ARE NO _1_ PREFIXES

##  after outputting the next thing, copying and pasting and editing, use it in runapi.R
## these are the ids in the project (so they are NOT the sb ids)
## 
print.nice.ids.vector(out.ov.tumors.aug18.copying.process$files.ids)
## c("57b5dd54e4b0192c34a4ee2b", "57b5dd55e4b0192c34a4ee2d", "57b5dd55e4b0192c34a4ee2f", "57b5dd55e4b0192c34a4ee31", "57b5dd56e4b0192c34a4ee33", "57b5dd56e4b0192c34a4ee35", "57b5dd57e4b0192c34a4ee37", "57b5dd57e4b0192c34a4ee39", "57b5dd58e4b0192c34a4ee3b", "57b5dd58e4b0192c34a4ee3d", "57b5dd58e4b0192c34a4ee3f", "57b5dd59e4b0192c34a4ee41", "57b5dd59e4b0192c34a4ee43", "57b5dd5ae4b0192c34a4ee45", "57b5dd5ae4b0192c34a4ee47", "57b5dd5be4b0192c34a4ee49", "57b5dd5be4b0192c34a4ee4b", "57b5dd5ce4b0192c34a4ee4d", "57b5dd5ce4b0192c34a4ee4f", "57b5dd5ce4b0192c34a4ee51")




##################################################################
## amlaug18
## aml, 10 more runs, tumors
## don't worry about matched normals at all (and there aren't any
## for aml, I don't think)
##################################################################



# REMEMBER TO CHANGE .JSON FILE MANUALLY

out.aml.tumors <- get.files.with.tumor.or.normal(tempdir, homedir, query.template.file="amlqueryaug18.json", auth.token,  tt.files.per.download= files.per.download, sample.type="Primary Blood Derived Cancer - Peripheral Blood", output.csv = "aml.aug18.query.tumor.csv")
length(out.aml.tumors$ids.files)
# 179


## get indices of out.aml.tumors which
##  are in allfilenames, i.e. which we already downloaded
##  might get some that were downloaded but weren't run;
## skip these for now, more work, and don't need to in this setting


# READ in results
aml.all.tumors.df <- read.table(file=file.path(homedir, "aml.aug18.query.tumor.csv"), header=TRUE, sep =",", stringsAsFactors=FALSE) 
dim(aml.all.tumors.df)
## 179 3

# Now choose a unique file for each case:
# data browser tells us
#   there is one fewer case
#   at least for the tumor
#   Note that there are 8 recurrent tumors, most of these overlap
#   with a primary tumor case

length(unique(aml.all.tumors.df$ids.cases))
## 178

aml.unique.tumors.df <- choose.one.file.for.each.case(aml.all.tumors.df)

n.total.aml.cases <- length(aml.unique.tumors.df$ids.cases)
n.total.aml.cases
## 178


indices.aml.tumors.downloaded.by.aug18 <- sort(which(aml.unique.tumors.df$names.files %in% allfilenames))
length(indices.aml.tumors.downloaded.by.aug18)
## 58
# now get the cases for the runs pre aug 18

aml.downloaded.by.aug18.cases <- out.aml.tumors$ids.cases[indices.aml.tumors.downloaded.by.aug18]
print.nice.ids.vector(aml.downloaded.by.aug18.cases)


indices.aml.tumors.not.downloaded.by.aug18 <- setdiff(c(1:n.total.aml.cases), indices.aml.tumors.downloaded.by.aug18)
n.aml.tumors.not.downloaded.by.aug18 <- length(indices.aml.tumors.not.downloaded.by.aug18)
n.aml.tumors.not.downloaded.by.aug18
## 120

# choose a random 10 of these:
sample.size <- 10
set.seed(2968432)
aml.random.indices <- sample(indices.aml.tumors.not.downloaded.by.aug18, size = sample.size)

sb.ids.aml.tumors.aug18.run <- aml.unique.tumors.df$ids.files[aml.random.indices]
cases.aml.tumors.aug18.run <- aml.unique.tumors.df$ids.cases[aml.random.indices]
names.aml.tumors.aug18.run <- aml.unique.tumors.df$names.files[aml.random.indices]
print.nice.ids.vector(names.aml.tumors.aug18.run)
## c("TCGA-AB-2859-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2943-03A-01T-0740-13_rnaseq_fastq.tar", "TCGA-AB-2822-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2847-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2971-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2912-03A-01T-0734-13_rnaseq_fastq.tar", "TCGA-AB-2869-03A-01T-0735-13_rnaseq_fastq.tar", "TCGA-AB-2940-03A-01T-0736-13_rnaseq_fastq.tar", "TCGA-AB-2944-03A-01T-0740-13_rnaseq_fastq.tar", "TCGA-AB-2908-03A-01T-0740-13_rnaseq_fastq.tar")


# Now copy these files to the machete project

out.aml.tumors.aug18.copying.process <- copy.many.files.with.sb.id.to.project(vec.sbids=sb.ids.aml.tumors.aug18.run, proj.name="JSALZMAN/machete", auth.token=auth.token, tempdir=tempdir)
## AFTER COPYING, CHECK MANUALLY THAT THERE ARE NO _1_ PREFIXES
## AFTER COPYING, CHECK MANUALLY THAT THERE ARE NO _1_ PREFIXES

##  after outputting the next thing, copying and pasting and editing, use it in runapi.R
## these are the ids in the project (so they are NOT the sb ids)
## 
print.nice.ids.vector(out.aml.tumors.aug18.copying.process$files.ids)
## c("57b64bbae4b0192c34a4f8b3", "57b64bbbe4b0192c34a4f8b5", "57b64bbbe4b0192c34a4f8b7", "57b64bbce4b0192c34a4f8b9", "57b64bbce4b0192c34a4f8bb", "57b64bbce4b0192c34a4f8bd", "57b64bbde4b0192c34a4f8bf", "57b64bbde4b0192c34a4f8c1", "57b64bbee4b0192c34a4f8c3", "57b64bbee4b0192c34a4f8c5")




##################################################################
## ovaug30
## Ovarian, 20 more runs, tumors
## don't worry about matched normals at all
##################################################################


# REMEMBER TO CHANGE .JSON FILE MANUALLY

out.ov.tumors <- get.files.with.tumor.or.normal(tempdir, homedir, query.template.file="ovqueryaug18.json", auth.token,  tt.files.per.download= files.per.download, sample.type="Primary Tumor", output.csv = "ov.aug30.query.tumor.csv")
length(out.ov.tumors$ids.files)
# 422

## out.ov.normals <- get.files.with.tumor.or.normal(tempdir, homedir, query.template.file="ovqueryaug30.json", auth.token,  tt.files.per.download= files.per.download, sample.type="Solid Tissue Normal", output.csv = "ov.aug30.query.normal.csv")
## length(out.ov.normals$ids.files)
## Error in fromJSON(content, handler, default.size, depth, allowComments,  (from setdefs.R#98) :   invalid JSON input


## get indices of out.ov.tumors which
##  are in allfilenames, i.e. which we already downloaded
##  might get some that were downloaded but weren't run;
## skip these for now, more work, and don't need to in this setting

## by downloaded, we mean in the project, not that all report files
##   are downloaded

indices.ov.tumors.downloaded.by.aug30 <- sort(which(out.ov.tumors$names.files %in% allfilenames))
length(indices.ov.tumors.downloaded.by.aug30)
## 123

# now get the cases for the runs pre aug 30

ov.downloaded.by.aug30.cases <- out.ov.tumors$ids.cases[indices.ov.tumors.downloaded.by.aug30]
print.nice.ids.vector(ov.downloaded.by.aug30.cases)

# READ in results
ov.all.tumors.df <- read.table(file=file.path(homedir, "ov.aug30.query.tumor.csv"), header=TRUE, sep =",", stringsAsFactors=FALSE) 
dim(ov.all.tumors.df)
## 422 3

# Now choose a unique file for each case:
# although actually data browser tells us
#   as does this, that there is only one file per case
#   at least for the tumor
#   Note that there are 8 recurrent tumors, most of these overlap
#   with a primary tumor case

length(unique(ov.all.tumors.df$ids.cases))
## 422

ov.unique.tumors.df <- choose.one.file.for.each.case(ov.all.tumors.df)

n.total.ov.cases <- length(ov.unique.tumors.df$ids.cases)
n.total.ov.cases
## 422

indices.ov.tumors.not.downloaded.by.aug30 <- setdiff(c(1:n.total.ov.cases), indices.ov.tumors.downloaded.by.aug30)
n.ov.tumors.not.downloaded.by.aug30 <- length(indices.ov.tumors.not.downloaded.by.aug30)
n.ov.tumors.not.downloaded.by.aug30
## 299

# choose a random 50 of these:
## do first 20 now, then 20, then maybe 10 if don't have enough
## successful runs
sample.size <- 50
set.seed(2925455)
ov.random.indices <- sample(indices.ov.tumors.not.downloaded.by.aug30, size = sample.size)

sb.ids.ov.tumors.aug30.selection <- ov.unique.tumors.df$ids.files[ov.random.indices]
cases.ov.tumors.aug30.selection <- ov.unique.tumors.df$ids.cases[ov.random.indices]
names.ov.tumors.aug30.selection <- ov.unique.tumors.df$names.files[ov.random.indices]
print.nice.ids.vector(names.ov.tumors.aug30.selection)
## 50 files, using first 40 now, in two runs
## print.nice.ids.vector(names.ov.tumors.aug30.selection)
[1] c("TCGA-61-2094-01A-01R-1568-13_rnaseq_fastq.tar", "TCGA-61-1737-01A-01R-1567-13_rnaseq_fastq.tar", "TCGA-25-1320-01A-01R-1565-13_rnaseq_fastq.tar", "TCGA-31-1950-01A-01R-1568-13_rnaseq_fastq.tar", "TCGA-24-1555-01A-01R-1566-13_rnaseq_fastq.tar", "TCGA-13-1487-01A-01R-1565-13_rnaseq_fastq.tar", "TCGA-61-2109-01A-01R-1568-13_rnaseq_fastq.tar", "TCGA-24-1928-01A-01R-1567-13_rnaseq_fastq.tar", "TCGA-29-1701-01A-01R-1567-13_rnaseq_fastq.tar", "TCGA-25-1328-01A-01R-1565-13_rnaseq_fastq.tar", "TCGA-09-2054-01A-01R-1568-13_rnaseq_fastq.tar", "TCGA-24-2033-01A-01R-1568-13_rnaseq_fastq.tar", "TCGA-13-1510-01A-02R-1565-13_rnaseq_fastq.tar", "TCGA-30-1892-01A-01R-1568-13_rnaseq_fastq.tar", "TCGA-24-1423-01A-01R-1565-13_rnaseq_fastq.tar", "TCGA-24-2027-01A-01R-1567-13_rnaseq_fastq.tar", "TCGA-04-1356-01A-01R-1569-13_rnaseq_fastq.tar", "TCGA-09-1673-01A-01R-1566-13_rnaseq_fastq.tar", "TCGA-09-2056-01B-01R-1568-13_rnaseq_fastq.tar", "TCGA-29-1691-01A-01R-1566-13_rnaseq_fastq.tar", "TCGA-23-1021-01B-01R-1564-13_rnaseq_fastq.tar", "TCGA-13-1505-01A-01R-1565-13_rnaseq_fastq.tar", "TCGA-13-0727-01A-01R-1564-13_rnaseq_fastq.tar", "TCGA-24-2288-01A-01R-1568-13_rnaseq_fastq.tar", "TCGA-61-2092-01A-01R-1568-13_rnaseq_fastq.tar", "TCGA-04-1357-01A-01R-1565-13_rnaseq_fastq.tar", "TCGA-61-2097-01A-02R-1568-13_rnaseq_fastq.tar", "TCGA-25-2398-01A-01R-1569-13_rnaseq_fastq.tar", "TCGA-57-1994-01A-01R-1568-13_rnaseq_fastq.tar", "TCGA-24-1850-01A-01R-1567-13_rnaseq_fastq.tar", "TCGA-13-1410-01A-01R-1565-13_rnaseq_fastq.tar", "TCGA-24-1436-01A-01R-1566-13_rnaseq_fastq.tar", "TCGA-3P-A9WA-01A-11R-A406-31_rnaseq_fastq.tar", "TCGA-10-0931-01A-01R-1564-13_rnaseq_fastq.tar", "TCGA-04-1361-01A-01R-1565-13_rnaseq_fastq.tar", "TCGA-23-1107-01A-01R-1564-13_rnaseq_fastq.tar", "TCGA-25-2401-01A-01R-1569-13_rnaseq_fastq.tar", "TCGA-23-1119-01A-02R-1565-13_rnaseq_fastq.tar", "TCGA-29-1705-01A-01R-1567-13_rnaseq_fastq.tar", "TCGA-13-0885-01A-02R-1569-13_rnaseq_fastq.tar", "TCGA-30-1714-01A-02R-1567-13_rnaseq_fastq.tar", "TCGA-20-1682-01A-01R-1564-13_rnaseq_fastq.tar", "TCGA-29-1768-01A-01R-1567-13_rnaseq_fastq.tar", "TCGA-61-1995-01A-01R-1568-13_rnaseq_fastq.tar", "TCGA-20-0991-01A-01R-1564-13_rnaseq_fastq.tar", "TCGA-10-0934-01A-02R-1564-13_rnaseq_fastq.tar", "TCGA-24-1548-01A-01R-1566-13_rnaseq_fastq.tar", "TCGA-24-1428-01A-01R-1564-13_rnaseq_fastq.tar", "TCGA-09-0364-01A-02R-1564-13_rnaseq_fastq.tar", "TCGA-13-1482-01A-01R-1565-13_rnaseq_fastq.tar")

## Take first 20 and second 20 for two aug 30 runs
## Save 10 extra in case not enough successful runs

sb.ids.ov.tumors.aug30.first.run <- sb.ids.ov.tumors.aug30.selection[1:20]
sb.ids.ov.tumors.aug30.second.run <- sb.ids.ov.tumors.aug30.selection[21:40]
sb.ids.ov.tumors.aug30.extra <- sb.ids.ov.tumors.aug30.selection[41:50]

names.ov.tumors.aug30.first.run <- names.ov.tumors.aug30.selection[1:20]
names.ov.tumors.aug30.second.run <- names.ov.tumors.aug30.selection[21:40]
names.ov.tumors.aug30.extra <- names.ov.tumors.aug30.selection[41:50]


print.nice.ids.vector(sb.ids.ov.tumors.aug30.first.run)
print.nice.ids.vector(names.ov.tumors.aug30.first.run)

print.nice.ids.vector(sb.ids.ov.tumors.aug30.second.run)
print.nice.ids.vector(names.ov.tumors.aug30.second.run)

print.nice.ids.vector(sb.ids.ov.tumors.aug30.extra)
print.nice.ids.vector(names.ov.tumors.aug30.extra)


# Now copy these files to the machete project

out.ov.tumors.aug30.first.copying.process <- copy.many.files.with.sb.id.to.project(vec.sbids=sb.ids.ov.tumors.aug30.first.run, proj.name="JSALZMAN/machete", auth.token=auth.token, tempdir=tempdir)
## AFTER COPYING, CHECK MANUALLY THAT THERE ARE NO _1_ PREFIXES
## AFTER COPYING, CHECK MANUALLY THAT THERE ARE NO _1_ PREFIXES

##  after outputting the next thing, copying and pasting and editing, use it in runapi.R
## these are the ids in the project (so they are NOT the sb ids)
## 
print.nice.ids.vector(out.ov.tumors.aug30.first.copying.process$files.ids)
## c("57c67cdae4b0192c34a77f57", "57c67cdae4b0192c34a77f59", "57c67cdbe4b0192c34a77f5b", "57c67cdbe4b0192c34a77f5d", "57c67cdce4b0192c34a77f5f", "57c67cdce4b0192c34a77f61", "57c67cdce4b0192c34a77f63", "57c67cdde4b0192c34a77f65", "57c67cdde4b0192c34a77f67", "57c67cdee4b0192c34a77f69", "57c67cdee4b0192c34a77f6b", "57c67cdfe4b0192c34a77f6d", "57c67cdfe4b0192c34a77f6f", "57c67ce0e4b0192c34a77f71", "57c67ce0e4b0192c34a77f73", "57c67ce0e4b0192c34a77f75", "57c67ce1e4b0192c34a77f77", "57c67ce1e4b0192c34a77f79", "57c67ce2e4b0192c34a77f7b", "57c67ce2e4b0192c34a77f7d")

out.ov.tumors.aug30.second.copying.process <- copy.many.files.with.sb.id.to.project(vec.sbids=sb.ids.ov.tumors.aug30.second.run, proj.name="JSALZMAN/machete", auth.token=auth.token, tempdir=tempdir)
## AFTER COPYING, CHECK MANUALLY THAT THERE ARE NO _1_ PREFIXES
## AFTER COPYING, CHECK MANUALLY THAT THERE ARE NO _1_ PREFIXES

##  after outputting the next thing, copying and pasting and editing, use it in runapi.R
## these are the ids in the project (so they are NOT the sb ids)
## 
print.nice.ids.vector(out.ov.tumors.aug30.second.copying.process$files.ids)







##################################################################
## amlaug31
## AML, primary blood
##  at this point, get list of all remaining ones,
##  put sb ids in random order, and then save to file
##  date the file and save copy but also keep a "most recent" version
##  make function to do that, and also to get the next n of them
## don't worry about matched normals at all
##################################################################

todaydate <- "aug31"
shortname <- "aml"


outcsv <- paste0(shortname, todaydate, "query.tumor.csv")
# REMEMBER TO CHANGE .JSON FILE MANUALLY
## json files sit in api/tempfiles
out.tumors <- get.files.with.tumor.or.normal(tempdir, homedir, query.template.file="amlqueryaug18.json", auth.token,  tt.files.per.download= files.per.download, sample.type="Primary Blood Derived Cancer - Peripheral Blood", output.csv = outcsv)

length(out.tumors$ids.files)

## get indices of out.ov.tumors which
##  are in allfilenames, i.e. which we already downloaded
##  might get some that were downloaded but weren't run;
## skip these for now, more work, and don't need to in this setting

## by downloaded, we mean in the project, not that all report files
##   are downloaded

indices.tumors.downloaded.by.today <- sort(which(out.tumors$names.files %in% allfilenames))
length(indices.tumors.downloaded.by.today)
## 68

# now get the cases for the runs pre today

downloaded.by.today.cases <- out.tumors$ids.cases[indices.tumors.downloaded.by.today]
print.nice.ids.vector(downloaded.by.today.cases)

# READ in results
all.tumors.df <- read.table(file=file.path(homedir, outcsv), header=TRUE, sep =",", stringsAsFactors=FALSE) 
dim(all.tumors.df)
## 179 3 for aml

# Now choose a unique file for each case:

length(unique(all.tumors.df$ids.cases))
## 178 for aml

unique.tumors.df <- choose.one.file.for.each.case(all.tumors.df)

n.total.cases <- length(unique.tumors.df$ids.cases)
n.total.cases
## 178 for aml


indices.cases.downloaded.by.today <- sort(which(unique.tumors.df$ids.cases %in% downloaded.by.today.cases))


indices.tumors.not.downloaded.by.today <- setdiff(c(1:n.total.cases), indices.cases.downloaded.by.today)
n.tumors.not.downloaded.by.today <- length(indices.tumors.not.downloaded.by.today)
n.tumors.not.downloaded.by.today
## 110

## Now put these in a random order
## Then can go back to get them out of a csv file

set.seed(29254551)
random.ordering.of.indices <- sample(indices.tumors.not.downloaded.by.today, size = n.tumors.not.downloaded.by.today)

sb.ids.tumors.with.random.ordering <- unique.tumors.df$ids.files[random.ordering.of.indices]
cases.tumors.with.random.ordering <- unique.tumors.df$ids.cases[random.ordering.of.indices]
names.tumors.with.random.ordering <- unique.tumors.df$names.files[random.ordering.of.indices]
df.tumors.with.random.ordering <- data.frame(sb.ids.tumors.with.random.ordering, names.tumors.with.random.ordering, cases.tumors.with.random.ordering)


amlaug31part1.ids <- sb.ids.tumors.with.random.ordering[1:45]
amlaug31part1.names <- names.tumors.with.random.ordering[1:45]

amlaug31part2.ids <- sb.ids.tumors.with.random.ordering[46:90]
amlaug31part2.names <- names.tumors.with.random.ordering[46:90]

## NOT including these:
## write to file
## both one with current date, and one that's most recent

filename.with.date = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.", todaydate, ".csv"))
filename.mostrecent = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.most.recent.csv"))

n.tumors.with.random.ordering <- dim(df.tumors.with.random.ordering)[1]

write.table(df.tumors.with.random.ordering[91:n.tumors.with.random.ordering,], file = filename.with.date,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)
write.table(df.tumors.with.random.ordering[91:n.tumors.with.random.ordering,], file = filename.mostrecent,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)

# Now copy these files to the machete project

out.tumors.today.first.copying.process <- copy.many.files.with.sb.id.to.project(vec.sbids=amlaug31part1.ids, proj.name="JSALZMAN/machete", auth.token=auth.token, tempdir=tempdir)
out.tumors.today.second.copying.process <- copy.many.files.with.sb.id.to.project(vec.sbids=amlaug31part2.ids, proj.name="JSALZMAN/machete", auth.token=auth.token, tempdir=tempdir)
## AFTER COPYING, CHECK MANUALLY THAT THERE ARE NO _1_ PREFIXES
## AFTER COPYING, CHECK MANUALLY THAT THERE ARE NO _1_ PREFIXES




##  after outputting the next thing, copying and pasting and editing, use it in runapi.R
## these are the ids in the project (so they are NOT the sb ids)
## 
print.nice.ids.vector(out.tumors.today.first.copying.process$files.ids)
print.nice.ids.vector(names.tumors.with.random.ordering[1:45])
## 
##  after outputting the next thing, copying and pasting and editing, use it in runapi.R
## these are the ids in the project (so they are NOT the sb ids)
## 
print.nice.ids.vector(out.tumors.today.second.copying.process$files.ids)
print.nice.ids.vector(names.tumors.with.random.ordering[46:90])






##################################################################
## gbmsep5
## GBM, primary tumor
##  at this point, get list of all remaining ones,
##  put sb ids in random order, and then save to file
##  date the file and save copy but also keep a "most recent" version
##  make function to do that, and also to get the next n of them
## don't worry about matched normals at all
##################################################################

todaydate <- "sep5"
shortname <- "gbm"
n.use.this.many.files.now <- 65


outcsv <- paste0(shortname, todaydate, "query.tumor.csv")
# REMEMBER TO CHANGE .JSON FILE MANUALLY
## json files sit in api/tempfiles
out.tumors <- get.files.with.tumor.or.normal(tempdir, homedir, query.template.file="gbmqueryjul19.json", auth.token,  tt.files.per.download= files.per.download, sample.type="Primary Tumor", output.csv = outcsv)
length(out.tumors$ids.files)

## get indices of out.tumors which
##  are in allfilenames, i.e. which we already downloaded
##  might get some that were downloaded but weren't run;
## skip these for now, more work, and don't need to in this setting

## by downloaded, we mean in the project, not that all report files
##   are downloaded

indices.tumors.downloaded.by.today <- sort(which(out.tumors$names.files %in% allfilenames))
length(indices.tumors.downloaded.by.today)
## 

# now get the cases for the runs pre today

downloaded.by.today.cases <- out.tumors$ids.cases[indices.tumors.downloaded.by.today]
print.nice.ids.vector(downloaded.by.today.cases)

# READ in results
all.tumors.df <- read.table(file=file.path(homedir, outcsv), header=TRUE, sep =",", stringsAsFactors=FALSE) 
dim(all.tumors.df)
## 

# Now choose a unique file for each case:

length(unique(all.tumors.df$ids.cases))
## 

unique.tumors.df <- choose.one.file.for.each.case(all.tumors.df)

n.total.cases <- length(unique.tumors.df$ids.cases)
n.total.cases
## 


indices.cases.downloaded.by.today <- sort(which(unique.tumors.df$ids.cases %in% downloaded.by.today.cases))


indices.tumors.not.downloaded.by.today <- setdiff(c(1:n.total.cases), indices.cases.downloaded.by.today)
n.tumors.not.downloaded.by.today <- length(indices.tumors.not.downloaded.by.today)
n.tumors.not.downloaded.by.today
## 

## Now put these in a random order
## Then can go back to get them out of a csv file

set.seed(2923651)
random.ordering.of.indices <- sample(indices.tumors.not.downloaded.by.today, size = n.tumors.not.downloaded.by.today)

sb.ids.tumors.with.random.ordering <- unique.tumors.df$ids.files[random.ordering.of.indices]
cases.tumors.with.random.ordering <- unique.tumors.df$ids.cases[random.ordering.of.indices]
names.tumors.with.random.ordering <- unique.tumors.df$names.files[random.ordering.of.indices]
df.tumors.with.random.ordering <- data.frame(sb.ids.tumors.with.random.ordering, names.tumors.with.random.ordering, cases.tumors.with.random.ordering)

use.these.now.ids <- sb.ids.tumors.with.random.ordering[1:n.use.this.many.files.now]
use.these.now.names <- names.tumors.with.random.ordering[1:n.use.this.many.files.now]

## NOT using these right now:
## write to file
## both one with current date, and one that's most recent

filename.pre.downloads.with.date = file.path(homedir,paste0(shortname, ".files.not.downloaded.before.", todaydate, ".csv"))
filename.downloads.with.date = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.as.of.", todaydate, ".csv"))
filename.mostrecent = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.most.recent.csv"))

n.tumors.with.random.ordering <- dim(df.tumors.with.random.ordering)[1]

write.table(df.tumors.with.random.ordering[1:n.tumors.with.random.ordering,], file = filename.pre.downloads.with.date,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)
write.table(df.tumors.with.random.ordering[(n.use.this.many.files.now+1):n.tumors.with.random.ordering,], file = filename.downloads.with.date,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)
write.table(df.tumors.with.random.ordering[(n.use.this.many.files.now+1):n.tumors.with.random.ordering,], file = filename.mostrecent,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)

# Now copy these files to the machete project

out.tumors.today.first.copying.process <- copy.many.files.with.sb.id.to.project(vec.sbids=use.these.now.ids, proj.name="JSALZMAN/machete", auth.token=auth.token, tempdir=tempdir)
## AFTER COPYING, CHECK MANUALLY THAT THERE ARE NO _1_ PREFIXES




##  after outputting the next thing, copying and pasting and editing, use it in runapi.R
## these are the ids in the project (so they are NOT the sb ids)
## 
print.nice.ids.vector(out.tumors.today.first.copying.process$files.ids)
print.nice.ids.vector(names.tumors.with.random.ordering[1:n.use.this.many.files.now])



##################################################################
## pancsep6  70 files; 36 tumor already done before today
## pancreatic, primary tumor
##
## NOTE THAT THIS ONE IS VERY DIFFERENT BECAUSE AT ONE POINT
## WE COPIED _ALL_ (OR ALMOST ALL?) THE PANCREATIC FILES TO THE PROJECT
##
##  at this point, get list of all remaining ones,
##  put sb ids in random order, and then save to file
##  date the file and save copy but also keep a "most recent" version
##  make function to do that, and also to get the next n of them
## don't worry about matched normals at all
##
## panc different since they are all already in the project
##################################################################


todaydate <- "sep5"
shortname <- "panc"
longname <- "Pancreatic Adenocarcinoma"
n.use.this.many.files.now <- 70


## first one is the one with zzzz where the disease will go
template.for.query.template.file <- file.path(tempdir, "tumorquery.json")
query.template.file.for.particular.disease <- file.path(tempdir, paste0(shortname,".tumorquery.json"))
outcsv <- paste0(shortname, todaydate, "query.tumor.csv")
# REMEMBER TO CHANGE .JSON FILE MANUALLY
## json files sit in api/tempfiles
write.different.disease.to.tumor.template.file(shortname, tempdir, longname, query.template.file=template.for.query.template.file)
out.tumors <- get.files.with.tumor.or.normal(tempdir, homedir, query.template.file=query.template.file.for.particular.disease, auth.token,  tt.files.per.download= files.per.download, sample.type="Primary Tumor", output.csv = outcsv)
length(out.tumors$ids.files)


all.tumors.df <- read.table(file=file.path(homedir,outcsv), header=TRUE, sep =",", stringsAsFactors=FALSE) 

dim(all.tumors.df)
## 178 3

# Now choose a unique file for each case:

unique.tumors.df <- choose.one.file.for.each.case(all.tumors.df)


niceishnames.unique.tumors.df <- gsub(pattern="\\.tar\\.gz", replacement="", x =gsub(pattern="(_|-)", replacement="", x=gsub(pattern="_rnaseq_fastq.tar", replacement="", x=unique.tumors.df$names.files)))


## get indices of out.tumors which
##  are in allfilenames, i.e. which we already downloaded
##  might get some that were downloaded but weren't run;
## FOR pancreatic, all of them all arleady in the file
## so need to do more

## by downloaded, we mean in the project, not that all report files
##   are downloaded

indices.tumors.downloaded.by.today <- sort(which(out.tumors$names.files %in% allfilenames))
length(indices.tumors.downloaded.by.today)
## 178 for panc

source(file.path(homedir,"apidefs.R"))

metadata.filename <- file.path(wdir,paste0("metadata.csv"))
outcsv.with.keys <- file.path(wdir,paste0("report.paths.with.keys.csv"))


meta <- read.csv(metadata.filename, header=TRUE, sep=",", stringsAsFactors = FALSE)



paths.with.keys <- read.csv(outcsv.with.keys, header=TRUE, sep=",", stringsAsFactors = FALSE)

paths.with.meta <- merge(x=paths.with.keys, y=meta, by.x = "base.directory", by.y="nicename")

meta.panc <- meta[meta$disease_type==longname,]
# 183 22

paths.with.meta.panc <- paths.with.meta[paths.with.meta$disease_type==longname,]
# 38 25

## which panc's are not in paths file?

panc.in.meta.not.in.paths <- setdiff(niceishnames.unique.tumors.df, paths.with.meta.panc$base.directory)
length(panc.in.meta.not.in.paths)
## 142



indices.tumors.not.run.by.today <- sort(which(niceishnames.unique.tumors.df %in% panc.in.meta.not.in.paths))
length(indices.tumors.not.run.by.today)


# now get the cases for the runs pre today

not.run.by.today.cases <- unique.tumors.df$ids.cases[indices.tumors.not.run.by.today]
print.nice.ids.vector(not.run.by.today.cases)

n.tumors.not.run.by.today <- length(indices.tumors.not.run.by.today)
n.tumors.not.run.by.today
## 

## really these are files not completed/downloaded -
## might find later that they were downloaded
names.of.files.not.run.by.today <- unique.tumors.df$names.files[indices.tumors.not.run.by.today]
## length(names.of.files.not.run.by.today)
## [1] 142

## Now get the file ids (ids within the project) for these
## from the names get

project.ids.of.files.not.run.by.today <- get.fileids.from.filenames(filenames=names.of.files.not.run.by.today, allnames = allfilenames, allids = allfileids)

## make analogue of get.filenames.from.fileids in setdefs

## Now put these in a random order
## Then can go back to get them out of a csv file

set.seed(295651)
random.ordering.of.indices <- sample(n.tumors.not.run.by.today, size = n.tumors.not.run.by.today)

project.ids.tumors.with.random.ordering <- project.ids.of.files.not.run.by.today[random.ordering.of.indices]
cases.tumors.with.random.ordering <- not.run.by.today.cases[random.ordering.of.indices]
names.tumors.with.random.ordering <- names.of.files.not.run.by.today[random.ordering.of.indices]
df.tumors.with.random.ordering <- data.frame(project.ids.tumors.with.random.ordering, names.tumors.with.random.ordering, cases.tumors.with.random.ordering)

## as check:
niceish.names.tumors.with.random.ordering <- gsub(pattern="\\.tar\\.gz", replacement="", x =gsub(pattern="(_|-)", replacement="", x=gsub(pattern="_rnaseq_fastq.tar", replacement="", x=names.tumors.with.random.ordering)))
intersect(niceish.names.tumors.with.random.ordering, paths.with.keys$base.directory)

use.these.now.ids <- project.ids.tumors.with.random.ordering[1:n.use.this.many.files.now]
use.these.now.names <- names.tumors.with.random.ordering[1:n.use.this.many.files.now]

## NOT using the latter two right now:
## write to file
## first one is the info before downloading
## both one with current date, and one that's most recent

filename.pre.downloads.with.date = file.path(homedir,paste0(shortname, ".files.not.downloaded.before.", todaydate, ".csv"))
filename.downloads.with.date = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.as.of.", todaydate, ".csv"))
filename.mostrecent = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.most.recent.csv"))

n.tumors.with.random.ordering <- dim(df.tumors.with.random.ordering)[1]
## 142

write.table(df.tumors.with.random.ordering[1:n.tumors.with.random.ordering,], file = filename.pre.downloads.with.date,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)
write.table(df.tumors.with.random.ordering[(n.use.this.many.files.now+1):n.tumors.with.random.ordering,], file = filename.downloads.with.date,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)
write.table(df.tumors.with.random.ordering[(n.use.this.many.files.now+1):n.tumors.with.random.ordering,], file = filename.mostrecent,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)


##  after outputting the next thing, copying and pasting and editing, use it in runapi.R
## these are the ids in the project (so they are NOT the sb ids)
## 
print.nice.ids.vector(use.these.now.ids)
print.nice.ids.vector(use.these.now.names)





















##################################################################
## bladdersep8
## Bladder Urothelial Carcinoma
## primary tumor
##  at this point, get list of all remaining ones,
##  put sb ids in random order, and then save to file
##  date the file and save copy but also keep a "most recent" version
##  make function to do that, and also to get the next n of them
## don't worry about matched normals at all
##################################################################

todaydate <- "sep8"
shortname <- "bladder"
longname <- "Bladder Urothelial Carcinoma"
n.use.this.many.files.now <- 22


## first one is the one with zzzz where the disease will go
template.for.query.template.file <- file.path(tempdir, "tumorquery.json")
query.template.file.for.particular.disease <- file.path(tempdir, paste0(shortname,".tumorquery.json"))
outcsv <- paste0(shortname, todaydate, "query.tumor.csv")
write.different.disease.to.tumor.template.file(shortname, tempdir, longname, query.template.file=template.for.query.template.file)
out.tumors <- get.files.with.tumor.or.normal(tempdir, homedir, query.template.file=query.template.file.for.particular.disease, auth.token,  tt.files.per.download= files.per.download, sample.type="Primary Tumor", output.csv = outcsv)
length(out.tumors$ids.files)




## get indices of out.tumors which
##  are in allfilenames, i.e. which we already downloaded
##  might get some that were downloaded but weren't run;
## skip these for now, more work, and don't need to in this setting

## by downloaded, we mean in the project, not that all report files
##   are downloaded

indices.tumors.downloaded.by.today <- sort(which(out.tumors$names.files %in% allfilenames))
length(indices.tumors.downloaded.by.today)
## 

# now get the cases for the runs pre today

downloaded.by.today.cases <- out.tumors$ids.cases[indices.tumors.downloaded.by.today]
print.nice.ids.vector(downloaded.by.today.cases)

# READ in results
all.tumors.df <- read.table(file=file.path(homedir, outcsv), header=TRUE, sep =",", stringsAsFactors=FALSE) 
dim(all.tumors.df)
## 

# Now choose a unique file for each case:

length(unique(all.tumors.df$ids.cases))
## 

unique.tumors.df <- choose.one.file.for.each.case(all.tumors.df)

n.total.cases <- length(unique.tumors.df$ids.cases)
n.total.cases
## 


indices.cases.downloaded.by.today <- sort(which(unique.tumors.df$ids.cases %in% downloaded.by.today.cases))


indices.tumors.not.downloaded.by.today <- setdiff(c(1:n.total.cases), indices.cases.downloaded.by.today)
n.tumors.not.downloaded.by.today <- length(indices.tumors.not.downloaded.by.today)
n.tumors.not.downloaded.by.today
## 

## Now put these in a random order
## Then can go back to get them out of a csv file

set.seed(1923651)
random.ordering.of.indices <- sample(indices.tumors.not.downloaded.by.today, size = n.tumors.not.downloaded.by.today)

sb.ids.tumors.with.random.ordering <- unique.tumors.df$ids.files[random.ordering.of.indices]
cases.tumors.with.random.ordering <- unique.tumors.df$ids.cases[random.ordering.of.indices]
names.tumors.with.random.ordering <- unique.tumors.df$names.files[random.ordering.of.indices]
df.tumors.with.random.ordering <- data.frame(sb.ids.tumors.with.random.ordering, names.tumors.with.random.ordering, cases.tumors.with.random.ordering)

use.these.now.ids <- sb.ids.tumors.with.random.ordering[1:n.use.this.many.files.now]
use.these.now.names <- names.tumors.with.random.ordering[1:n.use.this.many.files.now]

## NOT using these right now:
## write to file
## both one with current date, and one that's most recent

filename.pre.downloads.with.date = file.path(homedir,paste0(shortname, ".files.not.downloaded.before.", todaydate, ".csv"))
filename.downloads.with.date = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.as.of.", todaydate, ".csv"))
filename.mostrecent = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.most.recent.csv"))

n.tumors.with.random.ordering <- dim(df.tumors.with.random.ordering)[1]

write.table(df.tumors.with.random.ordering[1:n.tumors.with.random.ordering,], file = filename.pre.downloads.with.date,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)
write.table(df.tumors.with.random.ordering[(n.use.this.many.files.now+1):n.tumors.with.random.ordering,], file = filename.downloads.with.date,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)
write.table(df.tumors.with.random.ordering[(n.use.this.many.files.now+1):n.tumors.with.random.ordering,], file = filename.mostrecent,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)

# Now copy these files to the machete project

out.tumors.today.first.copying.process <- copy.many.files.with.sb.id.to.project(vec.sbids=use.these.now.ids, proj.name="JSALZMAN/machete", auth.token=auth.token, tempdir=tempdir)
## AFTER COPYING, CHECK MANUALLY THAT THERE ARE NO _1_ PREFIXES




##  after outputting the next thing, copying and pasting and editing, use it in runapi.R
## these are the ids in the project (so they are NOT the sb ids)
## 
print.nice.ids.vector(out.tumors.today.first.copying.process$files.ids)
print.nice.ids.vector(names.tumors.with.random.ordering[1:n.use.this.many.files.now])







##################################################################
## gliomasep9
## Brain Lower Grade Glioma
## primary tumor
##  get list of all files
##  put sb ids in random order, and then save to file
##  date the file and save copy but also keep a "most recent" version
##  make function to do that, and also to get the next n of them
## don't worry about matched normals at all
##################################################################

## I used this one to test get.new.tar.files line by line

todaydate <- "sep9"
shortname <- "glioma"
longname <- "Brain Lower Grade Glioma"
n.use.this.many.files.now <- 22




##################################################################
## cervicalsep9
## Cervical Squamous Cell Carcinoma and Endocervical Adenocarcinoma
## tumor
##  get list of all files
##  put sb ids in random order, and then save to file
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "sep9"
shortname <- "cervical"
longname <- "Cervical Squamous Cell Carcinoma and Endocervical Adenocarcinoma"
n.use.this.many.files.now <- 22

get.new.tar.files(todaydate, shortname, longname, n.use.this.many.files.now, tempdir, homedir, auth.token, files.per.download, allfilenames, random.seed=19875)




##################################################################
## esophagussep9
## tumor
##  get list of all files
##  put sb ids in random order, and then save to file
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "sep9"
shortname <- "esophagus"
longname <- "Esophageal Carcinoma"
n.use.this.many.files.now <- 22

get.new.tar.files(todaydate, shortname, longname, n.use.this.many.files.now, tempdir, homedir, auth.token, files.per.download, allfilenames, random.seed=19471)


##################################################################
## headnecksep10
## tumor
##  get list of all files
##  put sb ids in random order, and then save to file
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "sep10"
shortname <- "headneck"
longname <- "Head and Neck Squamous Cell Carcinoma"
n.use.this.many.files.now <- 22

get.new.tar.files(todaydate, shortname, longname, n.use.this.many.files.now, tempdir, homedir, auth.token, files.per.download, allfilenames, random.seed=19471)


##################################################################
## kidneychromophobesep10
## tumor
##  get list of all files
##  put sb ids in random order, and then save to file
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "sep10"
shortname <- "kidneychromophobe"
longname <- "Kidney Chromophobe"
n.use.this.many.files.now <- 22

get.new.tar.files(todaydate, shortname, longname, n.use.this.many.files.now, tempdir, homedir, auth.token, files.per.download, allfilenames, random.seed=194221)




##################################################################
## kidneyrenalclearsep11
## tumor
##  get list of all files
##  put sb ids in random order, and then save to file
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "sep11"
shortname <- "kidneyrenalclear"
longname <- "Kidney Renal Clear Cell Carcinoma"
n.use.this.many.files.now <- 22

get.new.tar.files(todaydate, shortname, longname, n.use.this.many.files.now, tempdir, homedir, auth.token, files.per.download, allfilenames, random.seed=194521)



##################################################################
## kidneyrenalpapillarysep11
## tumor
##  get list of all files
##  put sb ids in random order, and then save to file
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "sep11"
shortname <- "kidneyrenalpapillary"
longname <- "Kidney Renal Papillary Cell Carcinoma"
n.use.this.many.files.now <- 22

get.new.tar.files(todaydate, shortname, longname, n.use.this.many.files.now, tempdir, homedir, auth.token, files.per.download, allfilenames, random.seed=194290)


##################################################################
## liversep11
## tumor
##  get list of all files
##  put sb ids in random order, and then save to file
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "sep11"
shortname <- "liver"
longname <- "Liver Hepatocellular Carcinoma"
n.use.this.many.files.now <- 22

get.new.tar.files(todaydate, shortname, longname, n.use.this.many.files.now, tempdir, homedir, auth.token, files.per.download, allfilenames, random.seed=19490)




##################################################################
## sarcomasep11
## tumor
##  get list of all files
##  put sb ids in random order, and then save to file
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "sep11"
shortname <- "sarcoma"
longname <- "Sarcoma"
n.use.this.many.files.now <- 22

get.new.tar.files(todaydate, shortname, longname, n.use.this.many.files.now, tempdir, homedir, auth.token, files.per.download, allfilenames, random.seed=12690)




##################################################################
## skinsep11
## tumor
##  get list of all files
##  put sb ids in random order, and then save to file
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "sep11"
shortname <- "skin"
longname <- "Skin Cutaneous Melanoma"
n.use.this.many.files.now <- 22

get.new.tar.files(todaydate, shortname, longname, n.use.this.many.files.now, tempdir, homedir, auth.token, files.per.download, allfilenames, random.seed=12420)




##################################################################
## colonsep12
## tumor
##  get list of all files
##  put sb ids in random order, and then save to file
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "sep12"
shortname <- "colon"
longname <- "Colon Adenocarcinoma"
n.use.this.many.files.now <- 22


## first one is the one with zzzz where the disease will go
template.for.query.template.file <- file.path(tempdir, "tumorquery.json")
query.template.file.for.particular.disease <- file.path(tempdir, paste0(shortname,".tumorquery.json"))

outcsv <- paste0(shortname, todaydate, "query.tumor.csv")

write.different.disease.to.tumor.template.file(shortname, tempdir, longname, query.template.file=template.for.query.template.file)
out.tumors <- get.files.with.tumor.or.normal(tempdir, homedir, query.template.file=query.template.file.for.particular.disease, auth.token,  tt.files.per.download= files.per.download, sample.type="Primary Tumor", output.csv = outcsv)
length(out.tumors$ids.files)

## get indices of out.tumors which
##  are in allfilenames, i.e. which we already downloaded
##  might get some that were downloaded but weren't run;
## skip these for now, more work, and don't need to in this setting

## by downloaded, we mean in the project, not that all report files
##   are downloaded

indices.tumors.downloaded.by.today <- sort(which(out.tumors$names.files %in% allfilenames))
length(indices.tumors.downloaded.by.today)
## 

# now get the cases for the runs pre today

downloaded.by.today.cases <- out.tumors$ids.cases[indices.tumors.downloaded.by.today]
print.nice.ids.vector(downloaded.by.today.cases)

# READ in results as nice data frame (instead of as a list)
all.tumors.df <- read.table(file=file.path(homedir, outcsv), header=TRUE, sep =",", stringsAsFactors=FALSE) 
dim(all.tumors.df)
## 

# Now choose a unique file for each case:

length(unique(all.tumors.df$ids.cases))
## 

unique.tumors.df <- choose.one.file.for.each.case(all.tumors.df)

n.total.cases <- length(unique.tumors.df$ids.cases)
n.total.cases
## 


indices.cases.downloaded.by.today <- sort(which(unique.tumors.df$ids.cases %in% downloaded.by.today.cases))


indices.tumors.not.downloaded.by.today <- setdiff(c(1:n.total.cases), indices.cases.downloaded.by.today)
n.tumors.not.downloaded.by.today <- length(indices.tumors.not.downloaded.by.today)
## These could be different, but first should be greater than the
##  second.
n.tumors.not.downloaded.by.today; n.total.cases - length(downloaded.by.today.cases)
## 

## Now put these in a random order
## Then can go back to get them out of a csv file

set.seed(2965)
random.ordering.of.indices <- sample(indices.tumors.not.downloaded.by.today, size = n.tumors.not.downloaded.by.today)

sb.ids.tumors.with.random.ordering <- unique.tumors.df$ids.files[random.ordering.of.indices]
cases.tumors.with.random.ordering <- unique.tumors.df$ids.cases[random.ordering.of.indices]
names.tumors.with.random.ordering <- unique.tumors.df$names.files[random.ordering.of.indices]
df.tumors.with.random.ordering <- data.frame(sb.ids.tumors.with.random.ordering, names.tumors.with.random.ordering, cases.tumors.with.random.ordering)

use.these.now.ids <- sb.ids.tumors.with.random.ordering[1:n.use.this.many.files.now]
use.these.now.names <- names.tumors.with.random.ordering[1:n.use.this.many.files.now]

## NOT using these right now:
## write to file
## both one with current date, and one that's most recent

filename.pre.downloads.with.date = file.path(homedir,paste0(shortname, ".files.not.downloaded.before.", todaydate, ".csv"))
filename.downloads.with.date = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.as.of.", todaydate, ".csv"))
filename.mostrecent = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.most.recent.csv"))

n.tumors.with.random.ordering <- dim(df.tumors.with.random.ordering)[1]

write.table(df.tumors.with.random.ordering[1:n.tumors.with.random.ordering,], file = filename.pre.downloads.with.date,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)
write.table(df.tumors.with.random.ordering[(n.use.this.many.files.now+1):n.tumors.with.random.ordering,], file = filename.downloads.with.date,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)
write.table(df.tumors.with.random.ordering[(n.use.this.many.files.now+1):n.tumors.with.random.ordering,], file = filename.mostrecent,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)

# Now copy these files to the machete project

out.tumors.today.first.copying.process <- copy.many.files.with.sb.id.to.project(vec.sbids=use.these.now.ids, proj.name="JSALZMAN/machete", auth.token=auth.token, tempdir=tempdir)
## AFTER COPYING, CHECK MANUALLY THAT THERE ARE NO _1_ PREFIXES




##  after outputting the next thing, copying and pasting and editing, use it in runapi.R
## these are the ids in the project (so they are NOT the sb ids)
## 
print.nice.ids.vector(out.tumors.today.first.copying.process$files.ids)
print.nice.ids.vector(names.tumors.with.random.ordering[1:n.use.this.many.files.now])

## also write files in case these are very long
nice.ids.file = file.path(homedir,paste0(shortname, ".nice.ids.", todaydate, ".csv"))
nice.names.file = file.path(homedir,paste0(shortname, ".nice.names.", todaydate, ".csv"))
write.table(out.tumors.today.first.copying.process$files.ids, file = nice.ids.file,  row.names = FALSE, col.names = FALSE, sep = "\n", append=FALSE, quote=FALSE)
write.table(names.tumors.with.random.ordering[1:n.use.this.many.files.now], file = nice.names.file,  row.names = FALSE, col.names = FALSE, sep = "\n", append=FALSE, quote=FALSE)
cat(paste0("Also writing files\n", nice.ids.file, "\n and \n", nice.names.file),"\n")




##################################################################
## brsep12
## tumor
##  get list of all files
##  put sb ids in random order, and then save to file
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "sep12"
shortname <- "br"
longname <- "Breast Invasive Carcinoma"
n.use.this.many.files.now <- 95


## first one is the one with zzzz where the disease will go
template.for.query.template.file <- file.path(tempdir, "tumorquery.json")
query.template.file.for.particular.disease <- file.path(tempdir, paste0(shortname,".tumorquery.json"))

outcsv <- paste0(shortname, todaydate, "query.tumor.csv")

write.different.disease.to.tumor.template.file(shortname, tempdir, longname, query.template.file=template.for.query.template.file)
out.tumors <- get.files.with.tumor.or.normal(tempdir, homedir, query.template.file=query.template.file.for.particular.disease, auth.token,  tt.files.per.download= files.per.download, sample.type="Primary Tumor", output.csv = outcsv)
length(out.tumors$ids.files)

## get indices of out.tumors which
##  are in allfilenames, i.e. which we already downloaded
##  might get some that were downloaded but weren't run;
## skip these for now, more work, and don't need to in this setting

## by downloaded, we mean in the project, not that all report files
##   are downloaded

indices.tumors.downloaded.by.today <- sort(which(out.tumors$names.files %in% allfilenames))
length(indices.tumors.downloaded.by.today)
## 

# now get the cases for the runs pre today

downloaded.by.today.cases <- out.tumors$ids.cases[indices.tumors.downloaded.by.today]
print.nice.ids.vector(downloaded.by.today.cases)

# READ in results as nice data frame (instead of as a list)
all.tumors.df <- read.table(file=file.path(homedir, outcsv), header=TRUE, sep =",", stringsAsFactors=FALSE) 
dim(all.tumors.df)
## 

# Now choose a unique file for each case:

length(unique(all.tumors.df$ids.cases))
## 

unique.tumors.df <- choose.one.file.for.each.case(all.tumors.df)

n.total.cases <- length(unique.tumors.df$ids.cases)
n.total.cases
## 


indices.cases.downloaded.by.today <- sort(which(unique.tumors.df$ids.cases %in% downloaded.by.today.cases))


indices.tumors.not.downloaded.by.today <- setdiff(c(1:n.total.cases), indices.cases.downloaded.by.today)
n.tumors.not.downloaded.by.today <- length(indices.tumors.not.downloaded.by.today)
## These could be different, but first should be greater than the
##  second.
n.tumors.not.downloaded.by.today; n.total.cases - length(downloaded.by.today.cases)
## 

## Now put these in a random order
## Then can go back to get them out of a csv file

set.seed(2965)
random.ordering.of.indices <- sample(indices.tumors.not.downloaded.by.today, size = n.tumors.not.downloaded.by.today)

sb.ids.tumors.with.random.ordering <- unique.tumors.df$ids.files[random.ordering.of.indices]
cases.tumors.with.random.ordering <- unique.tumors.df$ids.cases[random.ordering.of.indices]
names.tumors.with.random.ordering <- unique.tumors.df$names.files[random.ordering.of.indices]
df.tumors.with.random.ordering <- data.frame(sb.ids.tumors.with.random.ordering, names.tumors.with.random.ordering, cases.tumors.with.random.ordering)

use.these.now.ids <- sb.ids.tumors.with.random.ordering[1:n.use.this.many.files.now]
use.these.now.names <- names.tumors.with.random.ordering[1:n.use.this.many.files.now]

## NOT using these right now:
## write to file
## both one with current date, and one that's most recent

filename.pre.downloads.with.date = file.path(homedir,paste0(shortname, ".files.not.downloaded.before.", todaydate, ".csv"))
filename.downloads.with.date = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.as.of.", todaydate, ".csv"))
filename.mostrecent = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.most.recent.csv"))

n.tumors.with.random.ordering <- dim(df.tumors.with.random.ordering)[1]

write.table(df.tumors.with.random.ordering[1:n.tumors.with.random.ordering,], file = filename.pre.downloads.with.date,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)
write.table(df.tumors.with.random.ordering[(n.use.this.many.files.now+1):n.tumors.with.random.ordering,], file = filename.downloads.with.date,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)
write.table(df.tumors.with.random.ordering[(n.use.this.many.files.now+1):n.tumors.with.random.ordering,], file = filename.mostrecent,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)

# Now copy these files to the machete project

out.tumors.today.first.copying.process <- copy.many.files.with.sb.id.to.project(vec.sbids=use.these.now.ids, proj.name="JSALZMAN/machete", auth.token=auth.token, tempdir=tempdir)
## AFTER COPYING, CHECK MANUALLY THAT THERE ARE NO _1_ PREFIXES




##  after outputting the next thing, copying and pasting and editing, use it in runapi.R
## these are the ids in the project (so they are NOT the sb ids)
## 
print.nice.ids.vector(out.tumors.today.first.copying.process$files.ids)
print.nice.ids.vector(names.tumors.with.random.ordering[1:n.use.this.many.files.now])

## also write files in case these are very long
nice.ids.file = file.path(homedir,paste0(shortname, ".nice.ids.", todaydate, ".csv"))
nice.names.file = file.path(homedir,paste0(shortname, ".nice.names.", todaydate, ".csv"))
write.table(out.tumors.today.first.copying.process$files.ids, file = nice.ids.file,  row.names = FALSE, col.names = FALSE, sep = "\n", append=FALSE, quote=FALSE)
write.table(names.tumors.with.random.ordering[1:n.use.this.many.files.now], file = nice.names.file,  row.names = FALSE, col.names = FALSE, sep = "\n", append=FALSE, quote=FALSE)
cat(paste0("Also writing files\n", nice.ids.file, "\n and \n", nice.names.file),"\n")











##################################################################
## lungadenosep12
## tumor
##  get list of all files
##  put sb ids in random order, and then save to file
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "sep12"
shortname <- "lungadeno"
longname <- "Lung Adenocarcinoma"
n.use.this.many.files.now <- 80


## first one is the one with zzzz where the disease will go
template.for.query.template.file <- file.path(tempdir, "tumorquery.json")
query.template.file.for.particular.disease <- file.path(tempdir, paste0(shortname,".tumorquery.json"))

outcsv <- paste0(shortname, todaydate, "query.tumor.csv")

write.different.disease.to.tumor.template.file(shortname, tempdir, longname, query.template.file=template.for.query.template.file)
out.tumors <- get.files.with.tumor.or.normal(tempdir, homedir, query.template.file=query.template.file.for.particular.disease, auth.token,  tt.files.per.download= files.per.download, sample.type="Primary Tumor", output.csv = outcsv)
length(out.tumors$ids.files)

## get indices of out.tumors which
##  are in allfilenames, i.e. which we already downloaded
##  might get some that were downloaded but weren't run;
## skip these for now, more work, and don't need to in this setting

## by downloaded, we mean in the project, not that all report files
##   are downloaded

indices.tumors.downloaded.by.today <- sort(which(out.tumors$names.files %in% allfilenames))
length(indices.tumors.downloaded.by.today)
## 

# now get the cases for the runs pre today

downloaded.by.today.cases <- out.tumors$ids.cases[indices.tumors.downloaded.by.today]
print.nice.ids.vector(downloaded.by.today.cases)

# READ in results as nice data frame (instead of as a list)
all.tumors.df <- read.table(file=file.path(homedir, outcsv), header=TRUE, sep =",", stringsAsFactors=FALSE) 
dim(all.tumors.df)
## 

# Now choose a unique file for each case:

length(unique(all.tumors.df$ids.cases))
## 

unique.tumors.df <- choose.one.file.for.each.case(all.tumors.df)

n.total.cases <- length(unique.tumors.df$ids.cases)
n.total.cases
## 


indices.cases.downloaded.by.today <- sort(which(unique.tumors.df$ids.cases %in% downloaded.by.today.cases))


indices.tumors.not.downloaded.by.today <- setdiff(c(1:n.total.cases), indices.cases.downloaded.by.today)
n.tumors.not.downloaded.by.today <- length(indices.tumors.not.downloaded.by.today)
## These could be different, but first should be greater than the
##  second.
n.tumors.not.downloaded.by.today; n.total.cases - length(downloaded.by.today.cases)
## 

## Now put these in a random order
## Then can go back to get them out of a csv file

set.seed(2962)
random.ordering.of.indices <- sample(indices.tumors.not.downloaded.by.today, size = n.tumors.not.downloaded.by.today)

sb.ids.tumors.with.random.ordering <- unique.tumors.df$ids.files[random.ordering.of.indices]
cases.tumors.with.random.ordering <- unique.tumors.df$ids.cases[random.ordering.of.indices]
names.tumors.with.random.ordering <- unique.tumors.df$names.files[random.ordering.of.indices]
df.tumors.with.random.ordering <- data.frame(sb.ids.tumors.with.random.ordering, names.tumors.with.random.ordering, cases.tumors.with.random.ordering)

use.these.now.ids <- sb.ids.tumors.with.random.ordering[1:n.use.this.many.files.now]
use.these.now.names <- names.tumors.with.random.ordering[1:n.use.this.many.files.now]

## NOT using these right now:
## write to file
## both one with current date, and one that's most recent

filename.pre.downloads.with.date = file.path(homedir,paste0(shortname, ".files.not.downloaded.before.", todaydate, ".csv"))
filename.downloads.with.date = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.as.of.", todaydate, ".csv"))
filename.mostrecent = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.most.recent.csv"))

n.tumors.with.random.ordering <- dim(df.tumors.with.random.ordering)[1]

write.table(df.tumors.with.random.ordering[1:n.tumors.with.random.ordering,], file = filename.pre.downloads.with.date,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)
write.table(df.tumors.with.random.ordering[(n.use.this.many.files.now+1):n.tumors.with.random.ordering,], file = filename.downloads.with.date,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)
write.table(df.tumors.with.random.ordering[(n.use.this.many.files.now+1):n.tumors.with.random.ordering,], file = filename.mostrecent,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)

# Now copy these files to the machete project

out.tumors.today.first.copying.process <- copy.many.files.with.sb.id.to.project(vec.sbids=use.these.now.ids, proj.name="JSALZMAN/machete", auth.token=auth.token, tempdir=tempdir)
## AFTER COPYING, CHECK MANUALLY THAT THERE ARE NO _1_ PREFIXES




##  after outputting the next thing, copying and pasting and editing, use it in runapi.R
## these are the ids in the project (so they are NOT the sb ids)
## 
print.nice.ids.vector(out.tumors.today.first.copying.process$files.ids)
print.nice.ids.vector(names.tumors.with.random.ordering[1:n.use.this.many.files.now])

## also write files in case these are very long
nice.ids.file = file.path(homedir,paste0(shortname, ".nice.ids.", todaydate, ".csv"))
nice.names.file = file.path(homedir,paste0(shortname, ".nice.names.", todaydate, ".csv"))
write.table(out.tumors.today.first.copying.process$files.ids, file = nice.ids.file,  row.names = FALSE, col.names = FALSE, sep = "\n", append=FALSE, quote=FALSE)
write.table(names.tumors.with.random.ordering[1:n.use.this.many.files.now], file = nice.names.file,  row.names = FALSE, col.names = FALSE, sep = "\n", append=FALSE, quote=FALSE)
cat(paste0("Also writing files\n", nice.ids.file, "\n and \n", nice.names.file),"\n")







##################################################################
## lungcellsep12
## tumor
##  get list of all files
##  put sb ids in random order, and then save to file
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "sep12"
shortname <- "lungcell"
longname <- "Lung Squamous Cell Carcinoma"
n.use.this.many.files.now <- 21


## first one is the one with zzzz where the disease will go
template.for.query.template.file <- file.path(tempdir, "tumorquery.json")
query.template.file.for.particular.disease <- file.path(tempdir, paste0(shortname,".tumorquery.json"))

outcsv <- paste0(shortname, todaydate, "query.tumor.csv")

write.different.disease.to.tumor.template.file(shortname, tempdir, longname, query.template.file=template.for.query.template.file)
out.tumors <- get.files.with.tumor.or.normal(tempdir, homedir, query.template.file=query.template.file.for.particular.disease, auth.token,  tt.files.per.download= files.per.download, sample.type="Primary Tumor", output.csv = outcsv)
length(out.tumors$ids.files)

## get indices of out.tumors which
##  are in allfilenames, i.e. which we already downloaded
##  might get some that were downloaded but weren't run;
## skip these for now, more work, and don't need to in this setting

## by downloaded, we mean in the project, not that all report files
##   are downloaded

indices.tumors.downloaded.by.today <- sort(which(out.tumors$names.files %in% allfilenames))
length(indices.tumors.downloaded.by.today)
## 

# now get the cases for the runs pre today

downloaded.by.today.cases <- out.tumors$ids.cases[indices.tumors.downloaded.by.today]
print.nice.ids.vector(downloaded.by.today.cases)

# READ in results as nice data frame (instead of as a list)
all.tumors.df <- read.table(file=file.path(homedir, outcsv), header=TRUE, sep =",", stringsAsFactors=FALSE) 
dim(all.tumors.df)
## 

# Now choose a unique file for each case:

length(unique(all.tumors.df$ids.cases))
## 

unique.tumors.df <- choose.one.file.for.each.case(all.tumors.df)

n.total.cases <- length(unique.tumors.df$ids.cases)
n.total.cases
## 


indices.cases.downloaded.by.today <- sort(which(unique.tumors.df$ids.cases %in% downloaded.by.today.cases))


indices.tumors.not.downloaded.by.today <- setdiff(c(1:n.total.cases), indices.cases.downloaded.by.today)
n.tumors.not.downloaded.by.today <- length(indices.tumors.not.downloaded.by.today)
## These could be different, but first should be greater than the
##  second.
n.tumors.not.downloaded.by.today; n.total.cases - length(downloaded.by.today.cases)
## 

## Now put these in a random order
## Then can go back to get them out of a csv file

set.seed(2960)
random.ordering.of.indices <- sample(indices.tumors.not.downloaded.by.today, size = n.tumors.not.downloaded.by.today)

sb.ids.tumors.with.random.ordering <- unique.tumors.df$ids.files[random.ordering.of.indices]
cases.tumors.with.random.ordering <- unique.tumors.df$ids.cases[random.ordering.of.indices]
names.tumors.with.random.ordering <- unique.tumors.df$names.files[random.ordering.of.indices]
df.tumors.with.random.ordering <- data.frame(sb.ids.tumors.with.random.ordering, names.tumors.with.random.ordering, cases.tumors.with.random.ordering)

use.these.now.ids <- sb.ids.tumors.with.random.ordering[1:n.use.this.many.files.now]
use.these.now.names <- names.tumors.with.random.ordering[1:n.use.this.many.files.now]

## NOT using these right now:
## write to file
## both one with current date, and one that's most recent

filename.pre.downloads.with.date = file.path(homedir,paste0(shortname, ".files.not.downloaded.before.", todaydate, ".csv"))
filename.downloads.with.date = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.as.of.", todaydate, ".csv"))
filename.mostrecent = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.most.recent.csv"))

n.tumors.with.random.ordering <- dim(df.tumors.with.random.ordering)[1]

write.table(df.tumors.with.random.ordering[1:n.tumors.with.random.ordering,], file = filename.pre.downloads.with.date,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)
write.table(df.tumors.with.random.ordering[(n.use.this.many.files.now+1):n.tumors.with.random.ordering,], file = filename.downloads.with.date,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)
write.table(df.tumors.with.random.ordering[(n.use.this.many.files.now+1):n.tumors.with.random.ordering,], file = filename.mostrecent,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)

# Now copy these files to the machete project

out.tumors.today.first.copying.process <- copy.many.files.with.sb.id.to.project(vec.sbids=use.these.now.ids, proj.name="JSALZMAN/machete", auth.token=auth.token, tempdir=tempdir)
## AFTER COPYING, CHECK MANUALLY THAT THERE ARE NO _1_ PREFIXES




##  after outputting the next thing, copying and pasting and editing, use it in runapi.R
## these are the ids in the project (so they are NOT the sb ids)
## 
print.nice.ids.vector(out.tumors.today.first.copying.process$files.ids)
print.nice.ids.vector(names.tumors.with.random.ordering[1:n.use.this.many.files.now])

## also write files in case these are very long
nice.ids.file = file.path(homedir,paste0(shortname, ".nice.ids.", todaydate, ".csv"))
nice.names.file = file.path(homedir,paste0(shortname, ".nice.names.", todaydate, ".csv"))
write.table(out.tumors.today.first.copying.process$files.ids, file = nice.ids.file,  row.names = FALSE, col.names = FALSE, sep = "\n", append=FALSE, quote=FALSE)
write.table(names.tumors.with.random.ordering[1:n.use.this.many.files.now], file = nice.names.file,  row.names = FALSE, col.names = FALSE, sep = "\n", append=FALSE, quote=FALSE)
cat(paste0("Also writing files\n", nice.ids.file, "\n and \n", nice.names.file),"\n")





##################################################################
## lymphomasep12
## tumor  15 files
##  get list of all files
##  put sb ids in random order, and then save to file
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "sep12"
shortname <- "lymphoma"
longname <- "Lymphoid Neoplasm Diffuse Large B-cell Lymphoma"
n.use.this.many.files.now <- 15


## first one is the one with zzzz where the disease will go
template.for.query.template.file <- file.path(tempdir, "tumorquery.json")
query.template.file.for.particular.disease <- file.path(tempdir, paste0(shortname,".tumorquery.json"))

outcsv <- paste0(shortname, todaydate, "query.tumor.csv")

write.different.disease.to.tumor.template.file(shortname, tempdir, longname, query.template.file=template.for.query.template.file)
out.tumors <- get.files.with.tumor.or.normal(tempdir, homedir, query.template.file=query.template.file.for.particular.disease, auth.token,  tt.files.per.download= files.per.download, sample.type="Primary Tumor", output.csv = outcsv)
length(out.tumors$ids.files)

## get indices of out.tumors which
##  are in allfilenames, i.e. which we already downloaded
##  might get some that were downloaded but weren't run;
## skip these for now, more work, and don't need to in this setting

## by downloaded, we mean in the project, not that all report files
##   are downloaded

indices.tumors.downloaded.by.today <- sort(which(out.tumors$names.files %in% allfilenames))
length(indices.tumors.downloaded.by.today)
## 

# now get the cases for the runs pre today

downloaded.by.today.cases <- out.tumors$ids.cases[indices.tumors.downloaded.by.today]
print.nice.ids.vector(downloaded.by.today.cases)

# READ in results as nice data frame (instead of as a list)
all.tumors.df <- read.table(file=file.path(homedir, outcsv), header=TRUE, sep =",", stringsAsFactors=FALSE) 
dim(all.tumors.df)
## 

# Now choose a unique file for each case:

length(unique(all.tumors.df$ids.cases))
## 

unique.tumors.df <- choose.one.file.for.each.case(all.tumors.df)

n.total.cases <- length(unique.tumors.df$ids.cases)
n.total.cases
## 


indices.cases.downloaded.by.today <- sort(which(unique.tumors.df$ids.cases %in% downloaded.by.today.cases))


indices.tumors.not.downloaded.by.today <- setdiff(c(1:n.total.cases), indices.cases.downloaded.by.today)
n.tumors.not.downloaded.by.today <- length(indices.tumors.not.downloaded.by.today)
## These could be different, but first should be greater than the
##  second.
n.tumors.not.downloaded.by.today; n.total.cases - length(downloaded.by.today.cases)
## 

## Now put these in a random order
## Then can go back to get them out of a csv file

set.seed(2910)
random.ordering.of.indices <- sample(indices.tumors.not.downloaded.by.today, size = n.tumors.not.downloaded.by.today)

sb.ids.tumors.with.random.ordering <- unique.tumors.df$ids.files[random.ordering.of.indices]
cases.tumors.with.random.ordering <- unique.tumors.df$ids.cases[random.ordering.of.indices]
names.tumors.with.random.ordering <- unique.tumors.df$names.files[random.ordering.of.indices]
df.tumors.with.random.ordering <- data.frame(sb.ids.tumors.with.random.ordering, names.tumors.with.random.ordering, cases.tumors.with.random.ordering)

use.these.now.ids <- sb.ids.tumors.with.random.ordering[1:n.use.this.many.files.now]
use.these.now.names <- names.tumors.with.random.ordering[1:n.use.this.many.files.now]

## NOT using these right now:
## write to file
## both one with current date, and one that's most recent

filename.pre.downloads.with.date = file.path(homedir,paste0(shortname, ".files.not.downloaded.before.", todaydate, ".csv"))
filename.downloads.with.date = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.as.of.", todaydate, ".csv"))
filename.mostrecent = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.most.recent.csv"))

n.tumors.with.random.ordering <- dim(df.tumors.with.random.ordering)[1]

write.table(df.tumors.with.random.ordering[1:n.tumors.with.random.ordering,], file = filename.pre.downloads.with.date,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)
write.table(df.tumors.with.random.ordering[(n.use.this.many.files.now+1):n.tumors.with.random.ordering,], file = filename.downloads.with.date,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)
write.table(df.tumors.with.random.ordering[(n.use.this.many.files.now+1):n.tumors.with.random.ordering,], file = filename.mostrecent,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)

# Now copy these files to the machete project

out.tumors.today.first.copying.process <- copy.many.files.with.sb.id.to.project(vec.sbids=use.these.now.ids, proj.name="JSALZMAN/machete", auth.token=auth.token, tempdir=tempdir)
## AFTER COPYING, CHECK MANUALLY THAT THERE ARE NO _1_ PREFIXES




##  after outputting the next thing, copying and pasting and editing, use it in runapi.R
## these are the ids in the project (so they are NOT the sb ids)
## 
print.nice.ids.vector(out.tumors.today.first.copying.process$files.ids)
print.nice.ids.vector(names.tumors.with.random.ordering[1:n.use.this.many.files.now])

## also write files in case these are very long
nice.ids.file = file.path(homedir,paste0(shortname, ".nice.ids.", todaydate, ".csv"))
nice.names.file = file.path(homedir,paste0(shortname, ".nice.names.", todaydate, ".csv"))
write.table(out.tumors.today.first.copying.process$files.ids, file = nice.ids.file,  row.names = FALSE, col.names = FALSE, sep = "\n", append=FALSE, quote=FALSE)
write.table(names.tumors.with.random.ordering[1:n.use.this.many.files.now], file = nice.names.file,  row.names = FALSE, col.names = FALSE, sep = "\n", append=FALSE, quote=FALSE)
cat(paste0("Also writing files\n", nice.ids.file, "\n and \n", nice.names.file),"\n")





##################################################################
## prossep12
## tumor
##  get list of all files
##  put sb ids in random order, and then save to file
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "sep12"
shortname <- "pros"
longname <- "Prostate Adenocarcinoma"
n.use.this.many.files.now <- 90


## first one is the one with zzzz where the disease will go
template.for.query.template.file <- file.path(tempdir, "tumorquery.json")
query.template.file.for.particular.disease <- file.path(tempdir, paste0(shortname,".tumorquery.json"))

outcsv <- paste0(shortname, todaydate, "query.tumor.csv")

write.different.disease.to.tumor.template.file(shortname, tempdir, longname, query.template.file=template.for.query.template.file)
out.tumors <- get.files.with.tumor.or.normal(tempdir, homedir, query.template.file=query.template.file.for.particular.disease, auth.token,  tt.files.per.download= files.per.download, sample.type="Primary Tumor", output.csv = outcsv)
length(out.tumors$ids.files)

## get indices of out.tumors which
##  are in allfilenames, i.e. which we already downloaded
##  might get some that were downloaded but weren't run;
## skip these for now, more work, and don't need to in this setting

## by downloaded, we mean in the project, not that all report files
##   are downloaded

indices.tumors.downloaded.by.today <- sort(which(out.tumors$names.files %in% allfilenames))
length(indices.tumors.downloaded.by.today)
## 

# now get the cases for the runs pre today

downloaded.by.today.cases <- out.tumors$ids.cases[indices.tumors.downloaded.by.today]
print.nice.ids.vector(downloaded.by.today.cases)

# READ in results as nice data frame (instead of as a list)
all.tumors.df <- read.table(file=file.path(homedir, outcsv), header=TRUE, sep =",", stringsAsFactors=FALSE) 
dim(all.tumors.df)
## 

# Now choose a unique file for each case:

length(unique(all.tumors.df$ids.cases))
## 

unique.tumors.df <- choose.one.file.for.each.case(all.tumors.df)

n.total.cases <- length(unique.tumors.df$ids.cases)
n.total.cases
## 


indices.cases.downloaded.by.today <- sort(which(unique.tumors.df$ids.cases %in% downloaded.by.today.cases))


indices.tumors.not.downloaded.by.today <- setdiff(c(1:n.total.cases), indices.cases.downloaded.by.today)
n.tumors.not.downloaded.by.today <- length(indices.tumors.not.downloaded.by.today)
## These could be different, but first should be greater than the
##  second.
n.tumors.not.downloaded.by.today; n.total.cases - length(downloaded.by.today.cases)
## 

## Now put these in a random order
## Then can go back to get them out of a csv file

set.seed(2950)
random.ordering.of.indices <- sample(indices.tumors.not.downloaded.by.today, size = n.tumors.not.downloaded.by.today)

sb.ids.tumors.with.random.ordering <- unique.tumors.df$ids.files[random.ordering.of.indices]
cases.tumors.with.random.ordering <- unique.tumors.df$ids.cases[random.ordering.of.indices]
names.tumors.with.random.ordering <- unique.tumors.df$names.files[random.ordering.of.indices]
df.tumors.with.random.ordering <- data.frame(sb.ids.tumors.with.random.ordering, names.tumors.with.random.ordering, cases.tumors.with.random.ordering)

use.these.now.ids <- sb.ids.tumors.with.random.ordering[1:n.use.this.many.files.now]
use.these.now.names <- names.tumors.with.random.ordering[1:n.use.this.many.files.now]

## NOT using these right now:
## write to file
## both one with current date, and one that's most recent

filename.pre.downloads.with.date = file.path(homedir,paste0(shortname, ".files.not.downloaded.before.", todaydate, ".csv"))
filename.downloads.with.date = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.as.of.", todaydate, ".csv"))
filename.mostrecent = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.most.recent.csv"))

n.tumors.with.random.ordering <- dim(df.tumors.with.random.ordering)[1]

write.table(df.tumors.with.random.ordering[1:n.tumors.with.random.ordering,], file = filename.pre.downloads.with.date,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)
write.table(df.tumors.with.random.ordering[(n.use.this.many.files.now+1):n.tumors.with.random.ordering,], file = filename.downloads.with.date,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)
write.table(df.tumors.with.random.ordering[(n.use.this.many.files.now+1):n.tumors.with.random.ordering,], file = filename.mostrecent,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)

# Now copy these files to the machete project

out.tumors.today.first.copying.process <- copy.many.files.with.sb.id.to.project(vec.sbids=use.these.now.ids, proj.name="JSALZMAN/machete", auth.token=auth.token, tempdir=tempdir)
## AFTER COPYING, CHECK MANUALLY THAT THERE ARE NO _1_ PREFIXES




##  after outputting the next thing, copying and pasting and editing, use it in runapi.R
## these are the ids in the project (so they are NOT the sb ids)
## 
print.nice.ids.vector(out.tumors.today.first.copying.process$files.ids)
print.nice.ids.vector(names.tumors.with.random.ordering[1:n.use.this.many.files.now])

## also write files in case these are very long
nice.ids.file = file.path(homedir,paste0(shortname, ".nice.ids.", todaydate, ".csv"))
nice.names.file = file.path(homedir,paste0(shortname, ".nice.names.", todaydate, ".csv"))
write.table(out.tumors.today.first.copying.process$files.ids, file = nice.ids.file,  row.names = FALSE, col.names = FALSE, sep = "\n", append=FALSE, quote=FALSE)
write.table(names.tumors.with.random.ordering[1:n.use.this.many.files.now], file = nice.names.file,  row.names = FALSE, col.names = FALSE, sep = "\n", append=FALSE, quote=FALSE)
cat(paste0("Also writing files\n", nice.ids.file, "\n and \n", nice.names.file),"\n")






##################################################################
## gliomasep20
## run 5 more to try to get from 13 up to 15
## Brain Lower Grade Glioma
## primary tumor
## don't worry about matched normals at all
## use previously saved list of randomly ordered files
##################################################################

todaydate <- "sep20"
shortname <- "glioma"
longname <- "Brain Lower Grade Glioma"
n.use.this.many.files.now <- 5


filename.mostrecent = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.most.recent.csv"))

df.tumors.with.random.ordering <- read.table(filename.mostrecent, sep=",", header = FALSE, col.names = c("sb.id", "filename", "case"), stringsAsFactors = FALSE)

n.tumors.with.random.ordering <- dim(df.tumors.with.random.ordering)[1]


stopifnot(n.use.this.many.files.now < n.tumors.with.random.ordering)


use.these.now.ids <- df.tumors.with.random.ordering$sb.id[1:n.use.this.many.files.now]

use.these.now.names <- df.tumors.with.random.ordering$filename[1:n.use.this.many.files.now]


## filename.pre.downloads.with.date = file.path(homedir,paste0(shortname, todaydate, ".files.not.downloaded.before.csv"))
filename.downloads.with.date = file.path(homedir,paste0(shortname, ".", todaydate, ".files.not.yet.downloaded.as.of.csv"))


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
cat(paste0("Also writing files\n", nice.ids.file, "\n and \n", nice.names.file),"\n")



##################################################################
## headnecksep21
## tumor
##  doing 20 more to try to get up to 15
##  get list of all files
##  put sb ids in random order, and then save to file
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "sep21"
shortname <- "headneck"
longname <- "Head and Neck Squamous Cell Carcinoma"
n.use.this.many.files.now <- 20

filename.mostrecent = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.most.recent.csv"))

df.tumors.with.random.ordering <- read.table(filename.mostrecent, sep=",", header = FALSE, col.names = c("sb.id", "filename", "case"), stringsAsFactors = FALSE)

n.tumors.with.random.ordering <- dim(df.tumors.with.random.ordering)[1]


stopifnot(n.use.this.many.files.now < n.tumors.with.random.ordering)


use.these.now.ids <- df.tumors.with.random.ordering$sb.id[1:n.use.this.many.files.now]

use.these.now.names <- df.tumors.with.random.ordering$filename[1:n.use.this.many.files.now]


## filename.pre.downloads.with.date = file.path(homedir,paste0(shortname, todaydate, ".files.not.downloaded.before.csv"))
filename.downloads.with.date = file.path(homedir,paste0(shortname, ".", todaydate, ".files.not.yet.downloaded.as.of.csv"))


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
cat(paste0("Also writing files\n", nice.ids.file, "\n and \n", nice.names.file),"\n")




##################################################################
## kidneychromophobesep21
## run 3 more to try to get up to 15 from 14
## tumor
##  get list of all files
##  put sb ids in random order, and then save to file
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "sep21"
shortname <- "kidneychromophobe"
longname <- "Kidney Chromophobe"
n.use.this.many.files.now <- 3



filename.mostrecent = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.most.recent.csv"))

df.tumors.with.random.ordering <- read.table(filename.mostrecent, sep=",", header = FALSE, col.names = c("sb.id", "filename", "case"), stringsAsFactors = FALSE)

n.tumors.with.random.ordering <- dim(df.tumors.with.random.ordering)[1]
n.tumors.with.random.ordering

stopifnot(n.use.this.many.files.now < n.tumors.with.random.ordering)


use.these.now.ids <- df.tumors.with.random.ordering$sb.id[1:n.use.this.many.files.now]

use.these.now.names <- df.tumors.with.random.ordering$filename[1:n.use.this.many.files.now]
use.these.now.names

## filename.pre.downloads.with.date = file.path(homedir,paste0(shortname, todaydate, ".files.not.downloaded.before.csv"))
filename.downloads.with.date = file.path(homedir,paste0(shortname, ".", todaydate, ".files.not.yet.downloaded.as.of.csv"))


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
cat(paste0("Also writing files\n", nice.ids.file, "\n and \n", nice.names.file),"\n")




##

##################################################################
## kidneyrenalclearsep22
## tumor
## run 3 more to try to get up to 15 from 14
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "sep22"
shortname <- "kidneyrenalclear"
longname <- "Kidney Renal Clear Cell Carcinoma"
n.use.this.many.files.now <- 3



filename.mostrecent = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.most.recent.csv"))

df.tumors.with.random.ordering <- read.table(filename.mostrecent, sep=",", header = FALSE, col.names = c("sb.id", "filename", "case"), stringsAsFactors = FALSE)

n.tumors.with.random.ordering <- dim(df.tumors.with.random.ordering)[1]
n.tumors.with.random.ordering

stopifnot(n.use.this.many.files.now < n.tumors.with.random.ordering)


use.these.now.ids <- df.tumors.with.random.ordering$sb.id[1:n.use.this.many.files.now]

use.these.now.names <- df.tumors.with.random.ordering$filename[1:n.use.this.many.files.now]
use.these.now.names

## filename.pre.downloads.with.date = file.path(homedir,paste0(shortname, todaydate, ".files.not.downloaded.before.csv"))
filename.downloads.with.date = file.path(homedir,paste0(shortname, ".", todaydate, ".files.not.yet.downloaded.as.of.csv"))


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
cat(paste0("Also writing files\n", nice.ids.file, "\n and \n", nice.names.file),"\n")




##################################################################
## kidneyrenalpapillarysep22
## tumor
## run 3 more to try to get up to 15 from 14
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "sep22"
shortname <- "kidneyrenalpapillary"
longname <- "Kidney Renal Papillary Cell Carcinoma"
n.use.this.many.files.now <- 3



filename.mostrecent = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.most.recent.csv"))

df.tumors.with.random.ordering <- read.table(filename.mostrecent, sep=",", header = FALSE, col.names = c("sb.id", "filename", "case"), stringsAsFactors = FALSE)

n.tumors.with.random.ordering <- dim(df.tumors.with.random.ordering)[1]
n.tumors.with.random.ordering

stopifnot(n.use.this.many.files.now < n.tumors.with.random.ordering)


use.these.now.ids <- df.tumors.with.random.ordering$sb.id[1:n.use.this.many.files.now]

use.these.now.names <- df.tumors.with.random.ordering$filename[1:n.use.this.many.files.now]
use.these.now.names

## filename.pre.downloads.with.date = file.path(homedir,paste0(shortname, todaydate, ".files.not.downloaded.before.csv"))
filename.downloads.with.date = file.path(homedir,paste0(shortname, ".", todaydate, ".files.not.yet.downloaded.as.of.csv"))


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
cat(paste0("Also writing files\n", nice.ids.file, "\n and \n", nice.names.file),"\n")




##################################################################
## liversep22
## tumor
## run 3 more to try to get up to 15 from 14
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "sep22"
shortname <- "liver"
longname <- "Liver Hepatocellular Carcinoma"
n.use.this.many.files.now <- 3



filename.mostrecent = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.most.recent.csv"))

df.tumors.with.random.ordering <- read.table(filename.mostrecent, sep=",", header = FALSE, col.names = c("sb.id", "filename", "case"), stringsAsFactors = FALSE)

n.tumors.with.random.ordering <- dim(df.tumors.with.random.ordering)[1]
n.tumors.with.random.ordering

stopifnot(n.use.this.many.files.now < n.tumors.with.random.ordering)


use.these.now.ids <- df.tumors.with.random.ordering$sb.id[1:n.use.this.many.files.now]

use.these.now.names <- df.tumors.with.random.ordering$filename[1:n.use.this.many.files.now]
use.these.now.names

## filename.pre.downloads.with.date = file.path(homedir,paste0(shortname, todaydate, ".files.not.downloaded.before.csv"))
filename.downloads.with.date = file.path(homedir,paste0(shortname, ".", todaydate, ".files.not.yet.downloaded.as.of.csv"))


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
cat(paste0("Also writing files\n", nice.ids.file, "\n and \n", nice.names.file),"\n")





##################################################################
## lungcellsep22
## tumor
## run 3 more to try to get up to 15 from 14
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "sep22"
shortname <- "lungcell"
longname <- "Lung Squamous Cell Carcinoma"
n.use.this.many.files.now <- 6



filename.mostrecent = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.most.recent.csv"))

df.tumors.with.random.ordering <- read.table(filename.mostrecent, sep=",", header = FALSE, col.names = c("sb.id", "filename", "case"), stringsAsFactors = FALSE)

n.tumors.with.random.ordering <- dim(df.tumors.with.random.ordering)[1]
n.tumors.with.random.ordering

stopifnot(n.use.this.many.files.now < n.tumors.with.random.ordering)


use.these.now.ids <- df.tumors.with.random.ordering$sb.id[1:n.use.this.many.files.now]

use.these.now.names <- df.tumors.with.random.ordering$filename[1:n.use.this.many.files.now]
use.these.now.names

## filename.pre.downloads.with.date = file.path(homedir,paste0(shortname, todaydate, ".files.not.downloaded.before.csv"))
filename.downloads.with.date = file.path(homedir,paste0(shortname, ".", todaydate, ".files.not.yet.downloaded.as.of.csv"))


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
cat(paste0("Also writing files\n", nice.ids.file, "\n and \n", nice.names.file),"\n")




##################################################################
## skinsep22
## tumor
## run 10 more to try to get up to 15 from 11
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "sep22"
shortname <- "skin"
longname <- "Skin Cutaneous Melanoma"
n.use.this.many.files.now <- 10



filename.mostrecent = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.most.recent.csv"))

df.tumors.with.random.ordering <- read.table(filename.mostrecent, sep=",", header = FALSE, col.names = c("sb.id", "filename", "case"), stringsAsFactors = FALSE)

n.tumors.with.random.ordering <- dim(df.tumors.with.random.ordering)[1]
n.tumors.with.random.ordering

stopifnot(n.use.this.many.files.now < n.tumors.with.random.ordering)


use.these.now.ids <- df.tumors.with.random.ordering$sb.id[1:n.use.this.many.files.now]

use.these.now.names <- df.tumors.with.random.ordering$filename[1:n.use.this.many.files.now]

use.these.now.ids
use.these.now.names

## filename.pre.downloads.with.date = file.path(homedir,paste0(shortname, todaydate, ".files.not.downloaded.before.csv"))
filename.downloads.with.date = file.path(homedir,paste0(shortname, ".", todaydate, ".files.not.yet.downloaded.as.of.csv"))


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
cat(paste0("Also writing files\n", nice.ids.file, "\n and \n", nice.names.file),"\n")


##################################################################
## stomachsep22
## tumor
## run 10 more to try to get up to 15 from 11
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "sep22"
shortname <- "stomach"
longname <- "Stomach Adenocarcinoma"
n.use.this.many.files.now <- 10



filename.mostrecent = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.most.recent.csv"))

df.tumors.with.random.ordering <- read.table(filename.mostrecent, sep=",", header = FALSE, col.names = c("sb.id", "filename", "case"), stringsAsFactors = FALSE)

n.tumors.with.random.ordering <- dim(df.tumors.with.random.ordering)[1]
n.tumors.with.random.ordering

stopifnot(n.use.this.many.files.now < n.tumors.with.random.ordering)


use.these.now.ids <- df.tumors.with.random.ordering$sb.id[1:n.use.this.many.files.now]

use.these.now.names <- df.tumors.with.random.ordering$filename[1:n.use.this.many.files.now]

use.these.now.ids
use.these.now.names

## filename.pre.downloads.with.date = file.path(homedir,paste0(shortname, todaydate, ".files.not.downloaded.before.csv"))
filename.downloads.with.date = file.path(homedir,paste0(shortname, ".", todaydate, ".files.not.yet.downloaded.as.of.csv"))


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
cat(paste0("Also writing files\n", nice.ids.file, "\n and \n", nice.names.file),"\n")




##################################################################
## headnecksep28
## tumor
## run 6 more to try to get up to 15 from 3
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "sep28"
shortname <- "headneck"
longname <- "Head and Neck Squamous Cell Carcinoma"
n.use.this.many.files.now <- 6


filename.mostrecent = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.most.recent.csv"))

df.tumors.with.random.ordering <- read.table(filename.mostrecent, sep=",", header = FALSE, col.names = c("sb.id", "filename", "case"), stringsAsFactors = FALSE)

n.tumors.with.random.ordering <- dim(df.tumors.with.random.ordering)[1]
n.tumors.with.random.ordering

stopifnot(n.use.this.many.files.now < n.tumors.with.random.ordering)


use.these.now.ids <- df.tumors.with.random.ordering$sb.id[1:n.use.this.many.files.now]

use.these.now.names <- df.tumors.with.random.ordering$filename[1:n.use.this.many.files.now]

use.these.now.ids
use.these.now.names

## filename.pre.downloads.with.date = file.path(homedir,paste0(shortname, todaydate, ".files.not.downloaded.before.csv"))
filename.downloads.with.date = file.path(homedir,paste0(shortname, ".", todaydate, ".files.not.yet.downloaded.as.of.csv"))


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
cat(paste0("Also writing files\n", nice.ids.file, "\n and \n", nice.names.file),"\n")





##################################################################
## kidneyrenalpapillarysep28
## tumor
## run 5 more to try to get up to 15 from 14
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "sep28"
shortname <- "kidneyrenalpapillary"
longname <- "Kidney Renal Papillary Cell Carcinoma"
n.use.this.many.files.now <- 5


filename.mostrecent = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.most.recent.csv"))

df.tumors.with.random.ordering <- read.table(filename.mostrecent, sep=",", header = FALSE, col.names = c("sb.id", "filename", "case"), stringsAsFactors = FALSE)

n.tumors.with.random.ordering <- dim(df.tumors.with.random.ordering)[1]
n.tumors.with.random.ordering

stopifnot(n.use.this.many.files.now < n.tumors.with.random.ordering)


use.these.now.ids <- df.tumors.with.random.ordering$sb.id[1:n.use.this.many.files.now]

use.these.now.names <- df.tumors.with.random.ordering$filename[1:n.use.this.many.files.now]

use.these.now.ids
use.these.now.names

## filename.pre.downloads.with.date = file.path(homedir,paste0(shortname, todaydate, ".files.not.downloaded.before.csv"))
filename.downloads.with.date = file.path(homedir,paste0(shortname, ".", todaydate, ".files.not.yet.downloaded.as.of.csv"))


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
cat(paste0("Also writing files\n", nice.ids.file, "\n and \n", nice.names.file),"\n")




##################################################################
## bladderoct30
## tumor
## run 20 more to try to get up to 25 from 15
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "oct30"
shortname <- "bladder"
longname <- "Bladder Urothelial Carcinoma"
n.use.this.many.files.now <- 20


filename.mostrecent = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.most.recent.csv"))

df.tumors.with.random.ordering <- read.table(filename.mostrecent, sep=",", header = FALSE, col.names = c("sb.id", "filename", "case"), stringsAsFactors = FALSE)

n.tumors.with.random.ordering <- dim(df.tumors.with.random.ordering)[1]
n.tumors.with.random.ordering

stopifnot(n.use.this.many.files.now < n.tumors.with.random.ordering)


use.these.now.ids <- df.tumors.with.random.ordering$sb.id[1:n.use.this.many.files.now]

use.these.now.names <- df.tumors.with.random.ordering$filename[1:n.use.this.many.files.now]

use.these.now.ids
use.these.now.names

## filename.pre.downloads.with.date = file.path(homedir,paste0(shortname, todaydate, ".files.not.downloaded.before.csv"))
filename.downloads.with.date = file.path(homedir,paste0(shortname, ".", todaydate, ".files.not.yet.downloaded.as.of.csv"))


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
cat(paste0("Also writing files\n", nice.ids.file, "\n and \n", nice.names.file),"\n")




##################################################################
## gliomaoct31
## tumor
## run 20 more to try to get up to 25 from 15
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "oct31"
shortname <- "glioma"
longname <- "Brain Lower Grade Glioma"
n.use.this.many.files.now <- 20


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
print(paste0("Also writing files\n", nice.ids.file, "\n and \n", nice.names.file),"\n")


##################################################################
##################################################################
## Start doing this using a function
##################################################################
##################################################################


##################################################################
## cervicaloct31
## tumor
## run 20 more to try to get up to 25 from 16
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "oct31"
shortname <- "cervical"
longname <- "Cervical Squamous Cell Carcinoma and Endocervical Adenocarcinoma"
n.use.this.many.files.now <- 20



put.n.more.files.in.machete.project(todaydate=todaydate, shortname=shortname, longname=longname, n.use.this.many.files.now=n.use.this.many.files.now, homedir=homedir, tempdir=tempdir, auth.token=auth.token)


##################################################################
## colonoct31
## tumor
## run 18 more to try to get up to 25 from 17
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "oct31"
shortname <- "colon"
longname <- "Colon Adenocarcinoma"
n.use.this.many.files.now <- 18

put.n.more.files.in.machete.project(todaydate=todaydate, shortname=shortname, longname=longname, n.use.this.many.files.now=n.use.this.many.files.now, homedir=homedir, tempdir=tempdir, auth.token=auth.token)





##################################################################
## esophagusoct31
## tumor
## run 20 more to try to get up to 25 from 15
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "oct31"
shortname <- "esophagus"
longname <- "Esophageal Carcinoma"
n.use.this.many.files.now <- 20

put.n.more.files.in.machete.project(todaydate=todaydate, shortname=shortname, longname=longname, n.use.this.many.files.now=n.use.this.many.files.now, homedir=homedir, tempdir=tempdir, auth.token=auth.token)





##################################################################
## kidneychromophobeoct31
## tumor
## run 20 more to try to get up to 25 from 15
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "oct31"
shortname <- "kidneychromophobe"
longname <- "Kidney Chromophobe"
n.use.this.many.files.now <- 20

put.n.more.files.in.machete.project(todaydate=todaydate, shortname=shortname, longname=longname, n.use.this.many.files.now=n.use.this.many.files.now, homedir=homedir, tempdir=tempdir, auth.token=auth.token)


##################################################################
## kidneyrenalclearoct31
## tumor
## run 18 more to try to get up to 25 from 16
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "oct31"
shortname <- "kidneyrenalclear"
longname <- "Kidney Renal Clear Cell Carcinoma"
n.use.this.many.files.now <- 18

put.n.more.files.in.machete.project(todaydate=todaydate, shortname=shortname, longname=longname, n.use.this.many.files.now=n.use.this.many.files.now, homedir=homedir, tempdir=tempdir, auth.token=auth.token)



##################################################################
## kidneyrenalpapillarynov1
## tumor
## run more to try to get up to 25 from 18
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "nov1"
shortname <- "kidneyrenalpapillary"
longname <- "Kidney Renal Papillary Cell Carcinoma"
n.use.this.many.files.now <- 15

put.n.more.files.in.machete.project(todaydate=todaydate, shortname=shortname, longname=longname, n.use.this.many.files.now=n.use.this.many.files.now, homedir=homedir, tempdir=tempdir, auth.token=auth.token)




##################################################################
## livernov1
## tumor
## run more to try to get up to 25 from 15
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "nov1"
shortname <- "liver"
longname <- "Liver Hepatocellular Carcinoma"
n.use.this.many.files.now <- 20

put.n.more.files.in.machete.project(todaydate=todaydate, shortname=shortname, longname=longname, n.use.this.many.files.now=n.use.this.many.files.now, homedir=homedir, tempdir=tempdir, auth.token=auth.token)






##################################################################
## lungcellnov1 18 to try to get up to 25 from 16
## tumor
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "nov1"
shortname <- "lungcell"
longname <- "Lung Squamous Cell Carcinoma"
n.use.this.many.files.now <- 18

put.n.more.files.in.machete.project(todaydate=todaydate, shortname=shortname, longname=longname, n.use.this.many.files.now=n.use.this.many.files.now, homedir=homedir, tempdir=tempdir, auth.token=auth.token)



##################################################################
## lymphomanov1 12 to try to get up to 25 from 20
## tumor
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "nov1"
shortname <- "lymphoma"
longname <- "Lymphoid Neoplasm Diffuse Large B-cell Lymphoma"
n.use.this.many.files.now <- 12

put.n.more.files.in.machete.project(todaydate=todaydate, shortname=shortname, longname=longname, n.use.this.many.files.now=n.use.this.many.files.now, homedir=homedir, tempdir=tempdir, auth.token=auth.token)





##################################################################
## sarcomanov1 20 to try to get up to 25 from 15
## tumor
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "nov1"
shortname <- "sarcoma"
longname <- "Sarcoma"
n.use.this.many.files.now <- 20

put.n.more.files.in.machete.project(todaydate=todaydate, shortname=shortname, longname=longname, n.use.this.many.files.now=n.use.this.many.files.now, homedir=homedir, tempdir=tempdir, auth.token=auth.token)



##################################################################
## skinnov1 20 to try to get up to 25 from 15
## tumor
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "nov1"
shortname <- "skin"
longname <- "Skin Cutaneous Melanoma"
n.use.this.many.files.now <- 20

put.n.more.files.in.machete.project(todaydate=todaydate, shortname=shortname, longname=longname, n.use.this.many.files.now=n.use.this.many.files.now, homedir=homedir, tempdir=tempdir, auth.token=auth.token)



##################################################################
## stomachnov1 18 to try to get up to 25 from 17
## tumor
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "nov1"
shortname <- "stomach"
longname <- "Stomach Adenocarcinoma"
n.use.this.many.files.now <- 18

put.n.more.files.in.machete.project(todaydate=todaydate, shortname=shortname, longname=longname, n.use.this.many.files.now=n.use.this.many.files.now, homedir=homedir, tempdir=tempdir, auth.token=auth.token)





##################################################################
## lungadenonov1 10 to try to get up to 25 from 22
## tumor
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
##################################################################

todaydate <- "nov1"
shortname <- "lungadeno"
longname <- "Lung Adenocarcinoma"
n.use.this.many.files.now <- 10

put.n.more.files.in.machete.project(todaydate=todaydate, shortname=shortname, longname=longname, n.use.this.many.files.now=n.use.this.many.files.now, homedir=homedir, tempdir=tempdir, auth.token=auth.token)




##################################################################
## prosnov1 20 to try to get up to 25 from 15
## tumor
##  date the file and save copy but also keep a "most recent" version
## don't worry about matched normals at all
## DON'T HAVE A FILE YET SO HAVE TO DO THIS DIFFERENTLY
##################################################################

todaydate <- "nov1"
shortname <- "pros"
longname <- "Prostate Adenocarcinoma"
n.use.this.many.files.now <- 20


out.files.list <- list.all.files.project(projname="JSALZMAN/machete", ttwdir=wdir, tempdir=tempdir, auth.token=auth.token, max.iterations=max.iterations)
allfilenames <- out.files.list$filenames 
allfileids <- out.files.list$fileids


## first one is the one with zzzz where the disease will go
template.for.query.template.file <- file.path(tempdir, "tumorquery.json")
query.template.file.for.particular.disease <- file.path(tempdir, paste0(shortname,".tumorquery.json"))

outcsv <- paste0(shortname, todaydate, "query.tumor.csv")

write.different.disease.to.tumor.template.file(shortname, tempdir, longname, query.template.file=template.for.query.template.file)
out.tumors <- get.files.with.tumor.or.normal(tempdir, homedir, query.template.file=query.template.file.for.particular.disease, auth.token,  tt.files.per.download= files.per.download, sample.type="Primary Tumor", output.csv = outcsv)
length(out.tumors$ids.files)

## get indices of out.tumors which
##  are in allfilenames, i.e. which we already downloaded
##  might get some that were downloaded but weren't run;
## skip that issue for now- it's more work, and
##  we don't need to do that in this setting

## by downloaded, we mean in the project, not that all report files
##   are downloaded

indices.tumors.downloaded.by.today <- sort(which(out.tumors$names.files %in% allfilenames))
length(indices.tumors.downloaded.by.today)
## 24

# now get the cases for the runs pre today

downloaded.by.today.cases <- out.tumors$ids.cases[indices.tumors.downloaded.by.today]
print.nice.ids.vector(downloaded.by.today.cases)

# READ in results as nice data frame (instead of as a list)
all.tumors.df <- read.table(file=file.path(homedir, outcsv), header=TRUE, sep =",", stringsAsFactors=FALSE) 
dim(all.tumors.df)
## 

# Now choose a unique file for each case:

length(unique(all.tumors.df$ids.cases))
## 

unique.tumors.df <- choose.one.file.for.each.case(all.tumors.df)

n.total.cases <- length(unique.tumors.df$ids.cases)
n.total.cases
## 


indices.cases.downloaded.by.today <- sort(which(unique.tumors.df$ids.cases %in% downloaded.by.today.cases))


indices.tumors.not.downloaded.by.today <- setdiff(c(1:n.total.cases), indices.cases.downloaded.by.today)
n.tumors.not.downloaded.by.today <- length(indices.tumors.not.downloaded.by.today)
## These could be different, but first should be greater than the
##  second.
n.tumors.not.downloaded.by.today; n.total.cases - length(downloaded.by.today.cases)
## 

## Now put these in a random order
## Then can go back to get them out of a csv file

set.seed(2921)
random.ordering.of.indices <- sample(indices.tumors.not.downloaded.by.today, size = n.tumors.not.downloaded.by.today)

sb.ids.tumors.with.random.ordering <- unique.tumors.df$ids.files[random.ordering.of.indices]
cases.tumors.with.random.ordering <- unique.tumors.df$ids.cases[random.ordering.of.indices]
names.tumors.with.random.ordering <- unique.tumors.df$names.files[random.ordering.of.indices]
df.tumors.with.random.ordering <- data.frame(sb.ids.tumors.with.random.ordering, names.tumors.with.random.ordering, cases.tumors.with.random.ordering)

use.these.now.ids <- sb.ids.tumors.with.random.ordering[1:n.use.this.many.files.now]
use.these.now.names <- names.tumors.with.random.ordering[1:n.use.this.many.files.now]

## write to file
## both one with current date, and one that's most recent

filename.mostrecent = file.path(homedir,paste0(shortname, ".files.not.yet.downloaded.most.recent.csv"))
filename.downloads.with.date = file.path(homedir,paste0(shortname, ".", todaydate, ".files.not.yet.downloaded.as.of.csv"))

n.tumors.with.random.ordering <- dim(df.tumors.with.random.ordering)[1]

write.table(df.tumors.with.random.ordering[(n.use.this.many.files.now+1):n.tumors.with.random.ordering,], file = filename.downloads.with.date,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)
write.table(df.tumors.with.random.ordering[(n.use.this.many.files.now+1):n.tumors.with.random.ordering,], file = filename.mostrecent,   row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)

# Now copy these files to the machete project

out.tumors.today.first.copying.process <- copy.many.files.with.sb.id.to.project(vec.sbids=use.these.now.ids, proj.name="JSALZMAN/machete", auth.token=auth.token, tempdir=tempdir)
## AFTER COPYING, CHECK MANUALLY THAT THERE ARE NO _1_ PREFIXES




##  after outputting the next thing, copying and pasting and editing, use it in runapi.R
## these are the ids in the project (so they are NOT the sb ids)
## 
print.nice.ids.vector(out.tumors.today.first.copying.process$files.ids)
print.nice.ids.vector(names.tumors.with.random.ordering[1:n.use.this.many.files.now])

## also write files in case these are very long
nice.ids.file = file.path(homedir,paste0(shortname, ".", todaydate, ".nice.ids.csv"))
nice.names.file = file.path(homedir,paste0(shortname, ".", todaydate, ".nice.names.csv"))
write.table(out.tumors.today.first.copying.process$files.ids, file = nice.ids.file,  row.names = FALSE, col.names = FALSE, sep = "\n", append=FALSE, quote=FALSE)
write.table(names.tumors.with.random.ordering[1:n.use.this.many.files.now], file = nice.names.file,  row.names = FALSE, col.names = FALSE, sep = "\n", append=FALSE, quote=FALSE)
cat(paste0("Also writing files\n", nice.ids.file, "\n and \n", nice.names.file),"\n")


## put.n.more.files.in.machete.project(todaydate=todaydate, shortname=shortname, longname=longname, n.use.this.many.files.now=n.use.this.many.files.now, homedir=homedir, tempdir=tempdir, auth.token=auth.token)

