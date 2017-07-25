## matrixfullnodecoypostprocess.R
## letting processwithorwithoutsamplelist.py do the culling so as
## to only get sequences with full in the name and not decoy
## in the name, and then writing a file
## of form seqname, filename1, filename2, ... (i.e. in different format)
## and then feeding that into
## this, which writes files of matrices
## in other words, processing name-to-file-list files into matrices
##

args <- commandArgs(trailingOnly = TRUE)
name.to.files.input <- args[1]
sample.file <- args[2]
bv.file <- args[3]
naming.suffix <- args[4]
if (length(args)==5){
    listoffilesnottouse <- args[5]
} else {
    listoffilesnottouse <- NA
}


rawinput <- readLines(con=name.to.files.input)


bvraw.1 <- read.table(file=bv.file, header=T, sep=",", stringsAsFactors = FALSE)
sampleraw <- read.table(file=sample.file, header=F, sep=",", stringsAsFactors = FALSE)[,1]

# if there are files not to use, remove them from bvraw now

if (!is.na(listoffilesnottouse)){
    files.to.not.use <- readLines(con=listoffilesnottouse)
    bvraw <- bvraw.1[!(bvraw.1$bv.file.name %in% files.to.not.use),]
} else {
    bvraw <- bvraw.1
}


machete.indices <- bvraw$sample.id %in% sampleraw

sample.ids.all <- bvraw$sample.id
## Note that next things are just like sampleraw, but in the
## order we want for labeling the output:
sample.ids.machete <- sample.ids.all[machete.indices]

bv.files.for.machete.tasks <- bvraw$bv.file.name[machete.indices]
bv.files.all <- bvraw[,1]

get.bv.index <- function(this.bv.file, bv.files.all){
    ttout <- which(bv.files.all == this.bv.file)
    if (length(ttout)!=1){
        stop(paste0("ERROR for this.bv.file =", this.bv.file, "; ttout is\n", paste0(ttout, collapse = ",")))
    }
    ttout
}

n.bv <- length(bv.files.all)


n.raw.input <- length(rawinput)


bv.all.matrix <- matrix(data=NA, nrow = 0, ncol = n.bv)
seqnames.vec <- vector("character", length = 0) 


## NOTE that there shouldn't be any files in listoffilesnottouse that
##  show up in rawinput because they should have been removed
##  if they do show up, that means there is an error and it
##  would occur in the get.bv.index line below
## This loop doesn't take much time at all.
tti <- 1
while (tti <= n.raw.input){
    if (tti %% 1000 ==0){
        cat("Working on ", tti, "\n")
    }
    thisline <- rawinput[tti]
    ## first get the sequence name
    splitline <- strsplit(thisline, split=",")[[1]]
    ## if it starts with a *, and it definitely should, continue;
    ##    if not, stop with error
    seqnames.vec <- append(seqnames.vec, splitline[1])
    newrow <- vector("integer", length = n.bv)
    newrow[]<- 0
    n.files.for.this.seqname <- length(splitline)-1
    if (n.files.for.this.seqname > 0){
        files.for.this.sequence.only <- splitline[-1]
        for (ii.files in 1:n.files.for.this.seqname){
            this.bv.index <- get.bv.index(this.bv.file=files.for.this.sequence.only[ii.files], bv.files.all=bv.files.all)
            newrow[this.bv.index] <- 1
        }
    }
    bv.all.matrix <- rbind(bv.all.matrix, newrow)
    tti <- tti + 1
} ## end while


bv.machete.matrix <- bv.all.matrix[, bvraw$sample.id %in% sampleraw]

all.file.name <- file.path(getwd(), paste0("matrix.name.to.sample.ids.all", naming.suffix, ".csv"))
machete.file.name <- file.path(getwd(), paste0("matrix.name.to.sample.ids.machete.samples.only", naming.suffix, ".csv"))

n.samples <- length(sample.ids.all)

write.table(t(c("sequence.name,sample.id,is.sequence.present")), file = all.file.name, row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)

## Now just do a slightly quicker loop, numbers of files aren't too big
for (ii in 1:nrow(bv.all.matrix)){
    if (ii %% 100 ==0){
        cat("Working on row", ii, "\n")
    }
    thisdf <- data.frame(rep(seqnames.vec[ii],n.samples),sample.ids.all,bv.all.matrix[ii,])
    write.table(thisdf, file = all.file.name, row.names = FALSE, col.names = FALSE, sep = ",", append=TRUE, quote=FALSE)
}

n.samples.machete <- length(sampleraw)

write.table(t(c("sequence.name,sample.id,is.sequence.present")), file = machete.file.name, row.names = FALSE, col.names = FALSE, sep = ",", append=FALSE, quote=FALSE)

for (ii in 1:nrow(bv.machete.matrix)){
    if (ii %% 100 ==0){
        cat("Working on row", ii, "\n")
    }
    thismachdf <- data.frame(rep(seqnames.vec[ii],n.samples.machete),sample.ids.machete,bv.machete.matrix[ii,])
    write.table(thismachdf, file = machete.file.name, row.names = FALSE, col.names = FALSE, sep = ",", append=TRUE, quote=FALSE)
}


