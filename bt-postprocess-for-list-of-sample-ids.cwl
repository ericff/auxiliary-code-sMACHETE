{
  "id": "https://cgc-api.sbgenomics.com/v2/apps/ericfg/bloomtree-gbm/bt-postprocess-for-list-of-sample-ids/18/raw/",
  "class": "CommandLineTool",
  "label": "bt-postprocess-for-list-of-sample-ids",
  "description": "Processes output from bt-query to preferred format. The output from bt-query is given in terms of a list of sequences, followed by the file names (which have a .bv.rrr suffix) that the sequence is found in. \n\nIF A LIST of sample ids is given, THEN this tool uses a list of sample IDs to identify a subset of files to look at, and determine, for each sequence identifier string, the number and fraction within that subset in which the corresponding sequence is found. It actually also does this for ALL files, and for the complementary subset.  The exact format of the output of this tool is a line for each sequence identifier string with first that string, then 6 columns. The first two columns after the string give the number and ratio for the full list of files. The second two columns give the number and ratio for the subset of files. The third two columns give the number and ratio for the complement of the subset. 0 0 (so not NAs) are given if the sequence is not found.\n\nIF A LIST of sample ids is NOT given, THEN this tool does the above ONLY for the list of all files. he exact format of the output of this tool is then a line for each sequence identifier string with first that string, then two columns after the string that give the number and ratio for the full list of files, AND THEN four columns of zeros (so that the format stays the same as it would be if there were a list of sample ids given.)\n\nAlso outputs a list of files removed using the listoffilesnottouse, as a check.\n\nAlso outputs a text file containing a name-to-files dictionary, i.e. something just like the original query output but now with a sequence identifier followed by the list of files that the sequence is in, as opposed to the query output in which the sequence itself is followed by the list of files that it is in.\n\nNow also produces two \"matrix\" files, namely csv files, in a long file format. The first has a line for each pair of a sequence name (e.g. a name of a FUSION) and a sample ID. The row lists the sequence name, then the file name, then 1 if the sequence with that name is found in that sample, and 0 otherwise. The second file is the same but restricted to samples already run through machete.",
  "requirements": [
    {
      "class": "CreateFileRequirement",
      "fileDef": [
        {
          "filename": "processwithorwithoutsamplelist.py",
          "fileContent": "# modified from some initial code by Erik Lehnert\n## This version allows you to have a list of sample ids to process , or not\n## In the first case, you get output with one column of sequence names and 6 other columns:\n#     Processes output from bt-query to preferred format. The output from\n#     bt-query is given in terms of a list of sequences, followed by the\n#     file names (which have a .bv.rrr suffix) that the sequence is found\n#     in. This tool uses a list of sample IDs to identify a subset of\n#     files to look at, and determine, for each sequence identifier\n#     string, the number and fraction within that subset in which the\n#     corresponding sequence is found. It actually also does this for ALL\n#     files, and for the complementary subset. The exact format of the\n#     output of this tool is a line for each sequence identifier string\n#     with first that string, then 6 columns. The first two columns after\n#     the string give the number and ratio for the full list of files. The\n#     second two columns give the number and ratio for the subset of\n#     files. The third two columns give the number and ratio for the\n#     complement of the subset. 0 0 (so not NAs) are given if the sequence\n#     is not found.\n## In the latter, you get output with one column of sequence names and only 2 other columns\n##  AND then 4 columns of 0's.\n\nimport subprocess\nimport datetime\nimport sevenbridges as sb\nfrom sevenbridges.errors import SbgError\nfrom Bio import SeqIO \nimport os, re\nimport argparse\nimport csv\n\n# get current working dir\nworkdir = os.getcwd()\n\n\nparser = argparse.ArgumentParser()\nparser.add_argument(\"--queryoutput\", help=\"output file from bloomtree query bt query\")\nparser.add_argument(\"--fastainput\", help=\"fasta file of which sequences only file is an input to bloomtree query bt query\")\nparser.add_argument(\"--cancertype\", help=\"short string for cancer type, e.g. aml or gbm\")\nparser.add_argument(\"--namingstring\", help=\"naming string to name the summary report file that is output from this script\")\nparser.add_argument(\"--fileofsampleids\", help=\"file containing sample ids to identify the set of files we want to search in\")\nparser.add_argument(\"--numsamples\", help=\"number of total samples, typically tar or tar.gz files, used when building bloomtree\")\nparser.add_argument(\"--bvinfofile\", help=\"file containing sample ids and file ids and file names for the bv files, so that we can match samples with bv files\")\nparser.add_argument(\"--listoffilesnottouse\", help=\"file containing parts of file names for files not to count when processing output from queries\")\nparser.add_argument(\"--usedatewhennamingfile\", help=\"generate a nice date and use it when naming summary output file?? default if blank is to not do so; use yes or 1 if you want to use date. Note that removed files string will always have date in the name.\")\nparser.add_argument(\"--namingstringfornametofiles\", help=\"naming string to name the name-to-files file that is output from this script; uses namingstring if left blank\")\n\nargs = parser.parse_args()\n\nqueryoutput = args.queryoutput\nfastainput = args.fastainput\ncancertype = args.cancertype\nnumsamples= int(args.numsamples)\n\nif args.fileofsampleids:\n    using_sample_ids = True\n    fileofsampleids = args.fileofsampleids\n    bvinfofile = args.bvinfofile\nelse:\n    using_sample_ids = False\n\n# if namingstring isn't blank, add a period before it\nif args.namingstring:\n    namingstring = \".\" + args.namingstring\nelse:\n    namingstring = \"\"\n\nif args.namingstringfornametofiles:\n    namingstringfornametofiles = \".\" + args.namingstringfornametofiles\nelse:\n    namingstringfornametofiles = namingstring\n    \n# make nice date for use in naming files\ntoday = datetime.date.today()\nnicedate = today.strftime('%b%d').lower()\n\nif (args.usedatewhennamingfile==1 or args.usedatewhennamingfile==\"yes\"):\n    date_string_for_naming_file = \".\" + today\nelse:\n    date_string_for_naming_file = \"\"\n    \nmodifiedqueryoutputfile = os.path.join(os.path.dirname(queryoutput), \"modified\" + os.path.basename(queryoutput))\nremovedfilenames = os.path.join(workdir, \"removed.files.\" + cancertype + \".\" + nicedate + namingstring + \".txt\")\n\n    \n# If there is a list of files not to use (it's optional), then\n#  process the query output first by removing lines containing any of\n#  the keys    \n#  Also save a file containing a list of distinct lines removed, for inspection afterward\nif args.listoffilesnottouse:\n    listoffilesnottouse = args.listoffilesnottouse\n    with open(listoffilesnottouse, 'r') as ff:\n        files_not_to_use = [line.rstrip('\\n') for line in ff.readlines()]\n    lines =[]\n    removed = []\n    with open(queryoutput, 'rU') as gg:\n        for thisline in gg:\n            savethisline = True\n            for no_use_this in files_not_to_use:\n                # if you haven't already found it, keep checking other values of no_use_this:\n                if savethisline:\n                    if re.search(pattern=no_use_this, string=thisline):\n                        savethisline = False\n                        removed.append(thisline)\n            if savethisline:\n                lines.append(thisline)\n    distinct_removed = list(set(removed))\n    ## write distinct_removed and lines to file\n    with open(removedfilenames, 'w') as ff:\n        ff.write(''.join([str(x) for x in distinct_removed]))\n    with open(modifiedqueryoutputfile, 'w') as ff:\n        ff.write(''.join([str(x) for x in lines]))\nelse:\n    # Keep using the original file if no list of files not to use given\n    modifiedqueryoutputfile = queryoutput\n    \n\n    \n\nseqToNameDict = {}\nnameToSeqDict = {}\n\n# I'm changing this on oct 25 to account for sequences that have\n#  multiple names associated with them.\nfor seq_record in SeqIO.parse(fastainput, \"fasta\"):\n    name = str(seq_record.id)\n    seq = str(seq_record.seq)\n    nameToSeqDict[name] = seq\n    if (seq not in seqToNameDict):\n        # if seq not already in the dictionary, add it with value\n        #  being a list of length 1 with name as the entry\n        seqToNameDict[seq] = [name]\n    else:\n        # if seq IS already in the dictionary, append the name\n        #    to the list\n        seqToNameDict.get(seq).append(name)\n\n##Process SBT output\n\n# I changed this on oct 25 to account for sequences attached to multiple names.\n# I changed this on oct 25 by replacing name with seq\n#  to be consistent with the above; here's an example:\n# I also changed the last line, earlier on oct 25, because it was missing the seqToNameDict part\n#   the last group previously would have had the seq as a key, but it should have the name\ndef read_sbt(fp):\n    nameToFileDict = {}\n    seq, files = None, []\n    for line in fp:\n        line = line.rstrip()\n        if line.startswith(\"*\"):\n            if seq:\n                # if it's time to write for this sequence, write\n                # the nameToFileDict for all names that have that sequence:\n                for name in seqToNameDict[seq]:\n                    nameToFileDict[name] = files\n            tmp = line.split()\n            tmp = tmp[0][1:]\n            seq, files = tmp, []\n        else:\n            line = line.split(\"/\")[-1].strip(\".rrr\")\n            files.append(line)\n    if seq: \n        # if it's time to write for this sequence, write\n        # the nameToFileDict for all names that have that sequence:\n        for name in seqToNameDict[seq]:\n            nameToFileDict[name] = files\n    return nameToFileDict\n\n### Do for full file:\nwith open(modifiedqueryoutputfile, 'rU') as SBT_handle:\n    name_to_file_dict_for_all_files = read_sbt(SBT_handle)\n\n\n\n## Write name-to-file dict to a txt file\nname_to_file_output_file = os.path.join(workdir, \"name.to.files.dict.\" + cancertype + date_string_for_naming_file + namingstring + \".txt\")\n\nwith open(name_to_file_output_file, 'w') as hh:\n    for seqname in name_to_file_dict_for_all_files:\n        all_files_with_seqname = name_to_file_dict_for_all_files[seqname]\n        hh.write(\"*%s\\n\" % seqname)\n        for thisfile in all_files_with_seqname:\n            hh.write(\"%s\\n\" % thisfile)\n\n\n\n    \n### Make name-to-sample-id dictionary from name-to-file-list dictionary\ndef make_name_to_sample_id_dict_from_name_to_file_list(name_to_file_list, tempbvinfohandle):\n    name_to_sample_id_dict = {}\n    bvfile_to_sample_id_dict = {}\n    rawdatacsv = csv.reader(tempbvinfohandle, delimiter=',')\n    next(rawdatacsv)\n    for row in rawdatacsv:\n        bvfile_to_sample_id_dict[row[0]] = row[2]\n    for name in name_to_file_list.keys():\n        this_file_list = name_to_file_list[name]\n        this_sample_id_list = []\n        for thisfile in this_file_list:\n            this_sample_id_list.append(bvfile_to_sample_id_dict[thisfile])\n        name_to_sample_id_dict[name] = this_sample_id_list\n        assert(len(this_sample_id_list) == len(this_file_list))\n    return name_to_sample_id_dict\n    \n\nif using_sample_ids:\n    with open(bvinfofile, 'rU') as tempbvinfohandle:\n        name_to_sample_list_for_all_files = make_name_to_sample_id_dict_from_name_to_file_list(name_to_file_list = name_to_file_dict_for_all_files, tempbvinfohandle = tempbvinfohandle)\n\n\n# Get all the file names from the query output file\n# This is a hack to get all the file names so we don't have to use\n# the python api to get a list of all files in the project\n# Note that it need not get all files in the project, just the files\n# in the query output file.\ndef get_all_files_from_query_ouput_file(filename):\n    files =[]\n    with open(filename, 'rU') as ff:\n        for line in ff:\n            line = line.rstrip()\n            if not line.startswith(\"*\"):\n                line = line.split(\"/\")[-1].strip(\".rrr\")\n                files.append(line)\n    files = list(set(files))\n    return files\n\n\n        \n    \nif using_sample_ids:\n    with open(fileofsampleids) as ff:\n        sampleids = [line.rstrip('\\n') for line in ff.readlines()]\n    num_samples_in_file_of_sampleids = len(sampleids)\n    if numsamples==num_samples_in_file_of_sampleids:\n        name_to_file_list_for_keys = name_to_file_dict_for_all_files\n        # Define number of samples in complement to be 1 if the file sizes are the same\n        num_samples_complement = 1\n    else:\n        # make dict that gives the sample id from the bv file (technically, this is doing\n        #   this twice)\n        bvfile_to_sample_id_dict = {}\n        with open(bvinfofile, 'rU') as tempbvinfohandle:\n            rawdatacsv = csv.reader(tempbvinfohandle, delimiter=',')\n            next(rawdatacsv)\n            for row in rawdatacsv:\n                bvfile_to_sample_id_dict[row[0]] = row[2]\n        ## Do check to make sure that the file of sample ids actually picks up\n        ## all of the files it should.\n        ## Check for this by checking that everything in the file of sample ids\n        ##  has an associated file in the query output file\n        files_in_query_output_file = get_all_files_from_query_ouput_file(modifiedqueryoutputfile)\n        n_matching_sample_ids = 0\n        for thissampleid in sampleids:\n            matching_id_yes_no = False\n            for thisfile in files_in_query_output_file:\n                bvsampleid = bvfile_to_sample_id_dict[thisfile]\n                if (thissampleid == bvsampleid):\n                    n_matching_sample_ids += 1\n                    matching_id_yes_no = True\n                    break\n            if (not matching_id_yes_no):\n                print(\"No file in query output file with sample ID matching sample ID \" + thissampleid + \", which is in the sample id file\\n\")\n        ## Note that if you had a small enough set of query output where\n        ##  there was some file with none of the sequences in it, you wouldn't pick\n        ##  up all files. So we check for this, as well as this being a general check\n        ##  on our logic and inputs.\n        assert(n_matching_sample_ids==len(sampleids))\n        ## Now continue\n        num_samples_complement = numsamples - num_samples_in_file_of_sampleids\n        modified_query_output_file = os.path.join(workdir, \"tempoutput.\" + nicedate + namingstring + \".txt\")\n        # Read in output from query\n        # Keep only lines associated with at least one of the sample ids\n        # Presumably there is a better way, but for ease, loop over all lines\n        #  if it has a star at beginning of line, keep the line\n        #  if not, look through all the sample ids; stop if you find one that works\n        #  move to next line if you find a match\n        #  if NONE match, then do not write it, and move to next line\n        #  Then write new file and send to read_sbt\n        out_list = []\n        ff = open(modifiedqueryoutputfile, 'r')\n        for line in ff:\n            line = line.rstrip()\n            if line.startswith(\"*\"):\n                out_list.append(line)\n            else:\n                line = re.sub(pattern='/srv/', repl='', string=line)\n                line = re.sub(pattern='\\.rrr', repl='', string=line)\n                sample_associated_with_file = bvfile_to_sample_id_dict[line]\n                if sample_associated_with_file in sampleids:\n                    out_list.append(line)\n        # Write modified file\n        with open(modified_query_output_file, 'w') as gg:\n            gg.write('\\n'.join([str(x) for x in out_list]))\n        # Use read_sbt function to process modified output file and make\n        # name to file list for it\n        with open(modified_query_output_file, 'rU') as SBT_handle:\n            name_to_file_list_for_input_sample_ids = read_sbt(SBT_handle)\n        # do analogue of next thing by changing next two lines:\n        with open(bvinfofile, 'rU') as tempbvinfohandle:\n            name_to_sample_list_for_all_files = make_name_to_sample_id_dict_from_name_to_file_list(name_to_file_list = name_to_file_list_for_input_sample_ids, tempbvinfohandle = tempbvinfohandle)\n    assert(numsamples >= num_samples_in_file_of_sampleids)\n\n## end if using_sample_ids\n\n        \n# Name for output file that summarizes results\nsummary_output_file = os.path.join(workdir, \"summary.bt.results.\" + cancertype + date_string_for_naming_file + namingstring + \".txt\")\n\n\n\n# Make summary output\n\n# First do for the case that we are using sample ids:\n\nif using_sample_ids:\n    with open(summary_output_file, 'w') as temp_handle2:\n        for seqname in nameToSeqDict:\n            if seqname in name_to_sample_list_for_all_files:\n                all_files_with_seqname = name_to_file_dict_for_all_files[seqname]\n                n_all_files_with_seqname = len(all_files_with_seqname)\n                ratio_all_files_with_seqname = float(n_all_files_with_seqname)/float(numsamples)\n                temp_handle2.write(\"%s\\t%s\\t%s\\t\" % (seqname, str(n_all_files_with_seqname),str(ratio_all_files_with_seqname)))\n                # if seqname in the files associated with keys, do this\n                if seqname in name_to_file_list_for_input_sample_ids:\n                    key_files_with_seqname = name_to_file_list_for_input_sample_ids[seqname]\n                    n_key_files_with_seqname = len(key_files_with_seqname)\n                    ratio_key_files_with_seqname = float(n_key_files_with_seqname)/float(num_samples_in_file_of_sampleids)\n                    # Also do complement\n                    n_complement = float(n_all_files_with_seqname - n_key_files_with_seqname)\n                    ratio_complement = n_complement/float(num_samples_complement)\n                    temp_handle2.write(\"%s\\t%s\\t%s\\t%s\\n\" % (str(n_key_files_with_seqname),str(ratio_key_files_with_seqname), str(n_complement), str(ratio_complement)))\n                else:\n                    # if seqname not in the files associated with keys but it's in\n                    #   the list of all files, then \n                    #   n_complement should equal n_all_files_with_seqname\n                    n_complement = n_all_files_with_seqname\n                    ratio_complement = n_complement/float(num_samples_complement)\n                    # add NA's for all four of these last ones\n                    temp_handle2.write(\"%s\\t%s\\t%s\\t%s\\n\" % (\"0\", \"0\", str(n_complement), str(ratio_complement)))\n            else:\n                assert(seqname not in name_to_file_list_for_input_sample_ids)\n                temp_handle2.write(\"%s\\t%s\\t%s\\t%s\\t%s\\t%s\\t%s\\n\" % (seqname, \"0\", \"0\", \"0\", \"0\", \"0\", \"0\"))\n\n## end if using_sample_ids\n\nif not using_sample_ids:\n    with open(summary_output_file, 'w') as temp_handle2:\n        for seqname in nameToSeqDict:\n            if seqname in name_to_file_dict_for_all_files:\n                all_files_with_seqname = name_to_file_dict_for_all_files[seqname]\n                n_all_files_with_seqname = len(all_files_with_seqname)\n                ratio_all_files_with_seqname = float(n_all_files_with_seqname)/float(numsamples)\n                temp_handle2.write(\"%s\\t%s\\t%s\\t%s\\t%s\\t%s\\t%s\\n\" % (seqname, str(n_all_files_with_seqname),str(ratio_all_files_with_seqname) , \"0\", \"0\", \"0\", \"0\"))\n            else:\n                temp_handle2.write(\"%s\\t%s\\t%s\\t%s\\t%s\\t%s\\t%s\\n\" % (seqname, \"0\", \"0\", \"0\", \"0\", \"0\", \"0\"))\n\n## end if NOT using_sample_ids\n\n## Call this to make two matrix files with rows being sequence identifiers and\n## columns being sample ids\n## only for sequences with full in them but not decoy in them\n## test this\n\nname_to_file_output_file_full_no_decoy = os.path.join(workdir, \"full.no.decoy.name.to.files.dict.\" + cancertype + date_string_for_naming_file + namingstring + \".txt\")\n\nwith open(name_to_file_output_file_full_no_decoy, 'w') as hh:\n    for seqname in name_to_file_dict_for_all_files:\n        if (re.search(pattern = \"full\", string = seqname) and not (re.search(pattern = \"decoy\", string = seqname))):\n            files_for_this_seqname = name_to_file_dict_for_all_files[seqname]\n            hh.write(\"%s\" % seqname)\n            for thisfile in files_for_this_seqname:\n                hh.write(\",%s\" % thisfile)\n            hh.write(\"\\n\")\n\n\nnaming_string_for_r_script = \".\" + cancertype + namingstringfornametofiles\n\nif not args.listoffilesnottouse:\n    listoffilesnottouse = \"\"\n\nmatrixcall = \"Rscript matrixfullnodecoypostprocess.R {name_to_file_output_file_full_no_decoy} {fileofsampleids} {bvinfofile} {naming_string_for_r_script} {listoffilesnottouse}\".format(name_to_file_output_file_full_no_decoy=name_to_file_output_file_full_no_decoy, fileofsampleids=fileofsampleids, bvinfofile=bvinfofile, naming_string_for_r_script=naming_string_for_r_script, listoffilesnottouse=listoffilesnottouse)\nsubprocess.check_call(matrixcall, shell=True)"
        },
        {
          "filename": "matrixfullnodecoypostprocess.R",
          "fileContent": "## matrixfullnodecoypostprocess.R\n## letting processwithorwithoutsamplelist.py do the culling so as\n## to only get sequences with full in the name and not decoy\n## in the name, and then writing a file\n## of form seqname, filename1, filename2, ... (i.e. in different format)\n## and then feeding that into\n## this, which writes files of matrices\n## in other words, processing name-to-file-list files into matrices\n##\n\nargs <- commandArgs(trailingOnly = TRUE)\nname.to.files.input <- args[1]\nsample.file <- args[2]\nbv.file <- args[3]\nnaming.suffix <- args[4]\nif (length(args)==5){\n    listoffilesnottouse <- args[5]\n} else {\n    listoffilesnottouse <- NA\n}\n\n\nrawinput <- readLines(con=name.to.files.input)\n\n\nbvraw.1 <- read.table(file=bv.file, header=T, sep=\",\", stringsAsFactors = FALSE)\nsampleraw <- read.table(file=sample.file, header=F, sep=\",\", stringsAsFactors = FALSE)[,1]\n\n# if there are files not to use, remove them from bvraw now\n\nif (!is.na(listoffilesnottouse)){\n    files.to.not.use <- readLines(con=listoffilesnottouse)\n    bvraw <- bvraw.1[!(bvraw.1$bv.file.name %in% files.to.not.use),]\n} else {\n    bvraw <- bvraw.1\n}\n\n\nmachete.indices <- bvraw$sample.id %in% sampleraw\n\nsample.ids.all <- bvraw$sample.id\n## Note that next things are just like sampleraw, but in the\n## order we want for labeling the output:\nsample.ids.machete <- sample.ids.all[machete.indices]\n\nbv.files.for.machete.tasks <- bvraw$bv.file.name[machete.indices]\nbv.files.all <- bvraw[,1]\n\nget.bv.index <- function(this.bv.file, bv.files.all){\n    ttout <- which(bv.files.all == this.bv.file)\n    if (length(ttout)!=1){\n        stop(paste0(\"ERROR for this.bv.file =\", this.bv.file, \"; ttout is\\n\", paste0(ttout, collapse = \",\")))\n    }\n    ttout\n}\n\nn.bv <- length(bv.files.all)\n\n\nn.raw.input <- length(rawinput)\n\n\nbv.all.matrix <- matrix(data=NA, nrow = 0, ncol = n.bv)\nseqnames.vec <- vector(\"character\", length = 0) \n\n\n## NOTE that there shouldn't be any files in listoffilesnottouse that\n##  show up in rawinput because they should have been removed\n##  if they do show up, that means there is an error and it\n##  would occur in the get.bv.index line below\n## This loop doesn't take much time at all.\ntti <- 1\nwhile (tti <= n.raw.input){\n    if (tti %% 1000 ==0){\n        cat(\"Working on \", tti, \"\\n\")\n    }\n    thisline <- rawinput[tti]\n    ## first get the sequence name\n    splitline <- strsplit(thisline, split=\",\")[[1]]\n    ## if it starts with a *, and it definitely should, continue;\n    ##    if not, stop with error\n    seqnames.vec <- append(seqnames.vec, splitline[1])\n    newrow <- vector(\"integer\", length = n.bv)\n    newrow[]<- 0\n    n.files.for.this.seqname <- length(splitline)-1\n    if (n.files.for.this.seqname > 0){\n        files.for.this.sequence.only <- splitline[-1]\n        for (ii.files in 1:n.files.for.this.seqname){\n            this.bv.index <- get.bv.index(this.bv.file=files.for.this.sequence.only[ii.files], bv.files.all=bv.files.all)\n            newrow[this.bv.index] <- 1\n        }\n    }\n    bv.all.matrix <- rbind(bv.all.matrix, newrow)\n    tti <- tti + 1\n} ## end while\n\n\nbv.machete.matrix <- bv.all.matrix[, bvraw$sample.id %in% sampleraw]\n\nall.file.name <- file.path(getwd(), paste0(\"matrix.name.to.sample.ids.all\", naming.suffix, \".csv\"))\nmachete.file.name <- file.path(getwd(), paste0(\"matrix.name.to.sample.ids.machete.samples.only\", naming.suffix, \".csv\"))\n\nn.samples <- length(sample.ids.all)\n\nwrite.table(t(c(\"sequence.name,sample.id,is.sequence.present\")), file = all.file.name, row.names = FALSE, col.names = FALSE, sep = \",\", append=FALSE, quote=FALSE)\n\n## Now just do a slightly quicker loop, numbers of files aren't too big\nfor (ii in 1:nrow(bv.all.matrix)){\n    if (ii %% 100 ==0){\n        cat(\"Working on row\", ii, \"\\n\")\n    }\n    thisdf <- data.frame(rep(seqnames.vec[ii],n.samples),sample.ids.all,bv.all.matrix[ii,])\n    write.table(thisdf, file = all.file.name, row.names = FALSE, col.names = FALSE, sep = \",\", append=TRUE, quote=FALSE)\n}\n\nn.samples.machete <- length(sampleraw)\n\nwrite.table(t(c(\"sequence.name,sample.id,is.sequence.present\")), file = machete.file.name, row.names = FALSE, col.names = FALSE, sep = \",\", append=FALSE, quote=FALSE)\n\nfor (ii in 1:nrow(bv.machete.matrix)){\n    if (ii %% 100 ==0){\n        cat(\"Working on row\", ii, \"\\n\")\n    }\n    thismachdf <- data.frame(rep(seqnames.vec[ii],n.samples.machete),sample.ids.machete,bv.machete.matrix[ii,])\n    write.table(thismachdf, file = machete.file.name, row.names = FALSE, col.names = FALSE, sep = \",\", append=TRUE, quote=FALSE)\n}"
        }
      ]
    }
  ],
  "inputs": [
    {
      "type": [
        "File"
      ],
      "sbg:stageInput": "copy",
      "id": "#queryoutput",
      "description": "output file from bloomtree query bt query",
      "sbg:fileTypes": "TXT",
      "inputBinding": {
        "prefix": "--queryoutput",
        "separate": true,
        "sbg:cmdInclude": true
      },
      "label": "queryoutput"
    },
    {
      "type": [
        "File"
      ],
      "sbg:stageInput": "copy",
      "id": "#fastainput",
      "description": "\", help=\"fasta file of which sequences only file is an input to bloomtree query bt query",
      "sbg:fileTypes": "FA",
      "inputBinding": {
        "prefix": "--fastainput",
        "separate": true,
        "sbg:cmdInclude": true
      },
      "label": "fastainput"
    },
    {
      "id": "#numsamples",
      "description": "number of samples, typically tar or tar.gz files, used when building bloomtree",
      "type": [
        "string"
      ],
      "inputBinding": {
        "loadContents": true,
        "separate": true,
        "prefix": "--numsamples",
        "sbg:cmdInclude": true
      },
      "label": "numsamples"
    },
    {
      "id": "#namingstring",
      "description": "CAN LEAVE THIS BLANK; naming suffix to name the summary report file that is output from this script. The script also adds a date, and \".txt\" to the end of the file name, in addition to this input string.",
      "type": [
        "null",
        "string"
      ],
      "inputBinding": {
        "prefix": "--namingstring",
        "separate": true,
        "sbg:cmdInclude": true
      },
      "label": "namingstring"
    },
    {
      "id": "#cancertype",
      "description": "string for type of cancer, for use in naming output file. E.g. gbm or aml.",
      "type": [
        "string"
      ],
      "inputBinding": {
        "prefix": "--cancertype",
        "separate": true,
        "sbg:cmdInclude": true
      },
      "label": "cancertype"
    },
    {
      "type": [
        "null",
        "File"
      ],
      "id": "#fileofsampleids",
      "description": "OPTIONAL. File of sample IDs to use to determine from query output file if a sequence is in the file. (The bv info file is used to link file names with .bv suffixes with sample IDs.) Each line should have exactly one sample id. If no file given, this will return an output file with a column of sequence identifiers and 2 columns of results. If you DO input a file, you must also input a bvinfofile.",
      "sbg:fileTypes": "CSV",
      "inputBinding": {
        "prefix": "--fileofsampleids",
        "separate": true,
        "sbg:cmdInclude": true
      },
      "label": "fileofsampleids"
    },
    {
      "type": [
        "null",
        "File"
      ],
      "id": "#bvinfofile",
      "description": "OPTIONAL. See fileofsampleids. This file containing sample ids and file ids for the bv files, so that we can match samples with bv files. The file names are used to match the files with a .bv suffix with their sample IDs.",
      "sbg:fileTypes": "CSV",
      "inputBinding": {
        "prefix": "--bvinfofile",
        "separate": true,
        "sbg:cmdInclude": true
      },
      "label": "bvinfofile"
    },
    {
      "type": [
        "null",
        "File"
      ],
      "sbg:stageInput": "copy",
      "id": "#listoffilesnottouse",
      "description": "File containing one file name (or part of file name) per line. The app will remove lines containing these strings from the output from a query, and then process the query. So NOTE that it could remove more files than expected if one is not careful.",
      "sbg:fileTypes": "CSV",
      "inputBinding": {
        "prefix": "--listoffilesnottouse",
        "separate": true,
        "sbg:cmdInclude": true
      },
      "label": "listoffilesnottouse"
    },
    {
      "id": "#usedatewhennamingfile",
      "description": "Generate a nice date and use it when naming summary output file?? default if blank is to not do so; use yes or 1 (exactly) if you want to use date. Note that removed files string will always have date in the name.",
      "type": [
        "null",
        "string"
      ],
      "inputBinding": {
        "prefix": "--usedatewhennamingfile",
        "separate": true,
        "sbg:cmdInclude": true
      },
      "label": "usedatewhennamingfile"
    },
    {
      "id": "#namingstringfornametofiles",
      "description": "Naming string to name the name-to-files file that is output from this script. CAN LEAVE THIS BLANK. Uses the variable namingstring if this is left blank",
      "type": [
        "null",
        "string"
      ],
      "inputBinding": {
        "prefix": "--namingstringfornametofiles",
        "separate": true,
        "sbg:cmdInclude": true
      },
      "label": "namingstringfornametofiles"
    }
  ],
  "outputs": [
    {
      "id": "#summaryoutputfile",
      "type": [
        "null",
        "File"
      ],
      "label": "summary output file",
      "outputBinding": {
        "glob": "*summary.bt.results*"
      }
    },
    {
      "id": "#removedfilenames",
      "description": "A list of the (distinct) names of files that are removed, mainly for checking purposes.",
      "type": [
        "null",
        "File"
      ],
      "label": "removedfilenames",
      "outputBinding": {
        "glob": "removed.*"
      }
    },
    {
      "id": "#nametofilesdictionary",
      "description": "A text file containing a name-to-files dictionary, i.e. something just like the original query output but now with a sequence identifier followed by the list of files that the sequence is in, as opposed to the query output in which the sequence itself is followed by the list of files that it is in.",
      "type": [
        "null",
        "File"
      ],
      "label": "nametofilesdictionary",
      "outputBinding": {
        "glob": "name.to.files.dict.*"
      }
    },
    {
      "id": "#matrixSequencesFoundBySampleIDs",
      "type": [
        "null",
        "File"
      ],
      "label": "matrixSequencesFoundBySampleIDs",
      "outputBinding": {
        "glob": "matrix.name.to.sample.ids.all*"
      }
    },
    {
      "id": "#matrixSequencesFoundBySampleIDsSUBSET",
      "type": [
        "null",
        "File"
      ],
      "label": "matrixSequencesFoundBySampleIDsSUBSET",
      "outputBinding": {
        "glob": "matrix.name.to.sample.ids.machete*"
      }
    }
  ],
  "hints": [
    {
      "class": "sbg:CPURequirement",
      "value": 1
    },
    {
      "class": "sbg:MemRequirement",
      "value": 1000
    },
    {
      "dockerPull": "cgc-images.sbgenomics.com/ericfg/mach1:bloomoct18",
      "dockerImageId": "",
      "class": "DockerRequirement"
    },
    {
      "class": "sbg:AWSInstanceType",
      "value": "c4.4xlarge"
    }
  ],
  "baseCommand": [
    "python",
    "processwithorwithoutsamplelist.py"
  ],
  "stdin": "",
  "stdout": "",
  "successCodes": [],
  "temporaryFailCodes": [],
  "arguments": [],
  "sbg:sbgMaintained": false,
  "sbg:cmdPreview": "python processwithorwithoutsamplelist.py --queryoutput /path/to/queryoutput.ext --fastainput /path/to/fastainput.ext --numsamples numsamples-string-value --cancertype cancertype-string-value",
  "sbg:revisionNotes": "Making matrixfullnodecoypostprocess.R a lot more efficient",
  "sbg:validationErrors": [],
  "sbg:revision": 18,
  "sbg:image_url": null,
  "sbg:modifiedBy": "ericfg",
  "sbg:createdOn": 1478280864,
  "sbg:appVersion": [
    "sbg:draft-2"
  ],
  "cwlVersion": "sbg:draft-2",
  "sbg:contributors": [
    "ericfg"
  ],
  "sbg:modifiedOn": 1483821934,
  "sbg:latestRevision": 18,
  "sbg:projectName": "Bloomtree GBM",
  "sbg:revisionsInfo": [
    {
      "sbg:revision": 0,
      "sbg:modifiedOn": 1478280864,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": "Copy of ericfg/bloomtree-gbm/bt-postprocess-for-file-list/3"
    },
    {
      "sbg:revision": 1,
      "sbg:modifiedOn": 1478281920,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 2,
      "sbg:modifiedOn": 1478302812,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": "Changing inputs so that it gives suggested file suffixes."
    },
    {
      "sbg:revision": 3,
      "sbg:modifiedOn": 1478303466,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": "Fixing changing of inputs so that it gives suggested file suffixes; they need to be uppercase."
    },
    {
      "sbg:revision": 4,
      "sbg:modifiedOn": 1478303841,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": "Fixing changing of inputs so that it gives suggested file suffixes; they need to be uppercase AND can't have a period I guess even though that seemed to work in bt-build."
    },
    {
      "sbg:revision": 5,
      "sbg:modifiedOn": 1478713347,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": "Changing so that .fa is recommended file type for fastainput."
    },
    {
      "sbg:revision": 6,
      "sbg:modifiedOn": 1478974941,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": "Changing samplelistprocess.py to ignore files that we don't want to count, e.g. copies or normals etc., when processing query output. Uses keys in listoffilesnottouse to identify these files."
    },
    {
      "sbg:revision": 7,
      "sbg:modifiedOn": 1479409840,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": "Changing so that one does not have to enter a list of sample IDs, i.e. so that one has the option to do both. Also now can include or not include the date on the day of the run, depending on one's preference."
    },
    {
      "sbg:revision": 8,
      "sbg:modifiedOn": 1479423420,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": "Fixed mistake- had forgot to include usedatewhennamingfile in command line."
    },
    {
      "sbg:revision": 9,
      "sbg:modifiedOn": 1479592536,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": "Changed output format so that it gives 4 columns of 0's on the end if there is not a subset, i.e. if there is not a list of sample IDs. Therefore the format stays the same as it would be if there were a list of sample ids given."
    },
    {
      "sbg:revision": 10,
      "sbg:modifiedOn": 1480789033,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": "Now outputs a file with a name-to-files dictionary, i.e. something just like the original query output but now with a sequence identifier followed by the list of files that the sequence is in, as opposed to the query output where the sequence itself is followed by the list of files that it is in."
    },
    {
      "sbg:revision": 11,
      "sbg:modifiedOn": 1481237095,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": "Now also produces two \"matrix\" files, namely csv files. The first has rows identified by the sequence names, e.g. a name of a FUSION, and the columns are identified by the sample IDs; the entry is 1 if the sequence with that name is found in that sample, and 0 otherwise. The second file is the same but restricted to samples already run through machete."
    },
    {
      "sbg:revision": 12,
      "sbg:modifiedOn": 1481238052,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": "Fixing file naming of matrix files so it includes cancertype"
    },
    {
      "sbg:revision": 13,
      "sbg:modifiedOn": 1481239120,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": "Fixing naming of files of cancer types again."
    },
    {
      "sbg:revision": 14,
      "sbg:modifiedOn": 1481568506,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": "Fixing problems with matrix file generation. Note that it now only produces lines in matrix file for sequences with \"full\" in the name and not having \"decoy\" in the name. Now putting in matrixfullnodecoypostprocess.R ."
    },
    {
      "sbg:revision": 15,
      "sbg:modifiedOn": 1481569469,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": "Changing name of file name_to_file_output_file_full_no_decoy value in processwithorwithoutsamplelist.py so that output glob only catches one file."
    },
    {
      "sbg:revision": 16,
      "sbg:modifiedOn": 1481655870,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": "Changing processwithorwithoutsamplelist.py and matrixfullnodecoypostprocess.R to fix bug and so not write columns that weren't analyzed in listoffilesnottouse; these columns had zeros in them, but they still shouldn't be there"
    },
    {
      "sbg:revision": 17,
      "sbg:modifiedOn": 1481669767,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": "Changing matrix files to long file format, i.e. one row for each pair of a sequence name and sample ID."
    },
    {
      "sbg:revision": 18,
      "sbg:modifiedOn": 1483821934,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": "Making matrixfullnodecoypostprocess.R a lot more efficient"
    }
  ],
  "sbg:createdBy": "ericfg",
  "sbg:id": "ericfg/bloomtree-gbm/bt-postprocess-for-list-of-sample-ids/18",
  "sbg:project": "ericfg/bloomtree-gbm",
  "sbg:job": {
    "inputs": {
      "namingstring": "namingsuffix-string-value",
      "numsamples": "numsamples-string-value",
      "fileofsampleids": {
        "size": 0,
        "class": "File",
        "path": "/path/to/fileofkeys.ext",
        "secondaryFiles": []
      },
      "bvinfofile": {
        "size": 0,
        "class": "File",
        "path": "/path/to/bvinfofile.ext",
        "secondaryFiles": []
      },
      "fastainput": {
        "size": 0,
        "class": "File",
        "path": "/path/to/fastainput.ext",
        "secondaryFiles": []
      },
      "cancertype": "cancertype-string-value",
      "queryoutput": {
        "size": 0,
        "class": "File",
        "path": "/path/to/queryoutput.ext",
        "secondaryFiles": []
      },
      "usedatewhennamingfile": "usedatewhennamingfile-string-value",
      "listoffilesnottouse": {
        "size": 0,
        "class": "File",
        "path": "/path/to/listoffilesnottouse.ext",
        "secondaryFiles": []
      },
      "namingstringfornametofiles": "namingstringfornametofiles-string-value"
    },
    "allocatedResources": {
      "cpu": 1,
      "mem": 1000
    }
  }
}
