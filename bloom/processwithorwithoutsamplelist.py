# modified from some initial code by Erik Lehnert
## This version allows you to have a list of sample ids to process , or not
## In the first case, you get output with one column of sequence names and 6 other columns:
#     Processes output from bt-query to preferred format. The output from
#     bt-query is given in terms of a list of sequences, followed by the
#     file names (which have a .bv.rrr suffix) that the sequence is found
#     in. This tool uses a list of sample IDs to identify a subset of
#     files to look at, and determine, for each sequence identifier
#     string, the number and fraction within that subset in which the
#     corresponding sequence is found. It actually also does this for ALL
#     files, and for the complementary subset. The exact format of the
#     output of this tool is a line for each sequence identifier string
#     with first that string, then 6 columns. The first two columns after
#     the string give the number and ratio for the full list of files. The
#     second two columns give the number and ratio for the subset of
#     files. The third two columns give the number and ratio for the
#     complement of the subset. 0 0 (so not NAs) are given if the sequence
#     is not found.
## In the latter, you get output with one column of sequence names and only 2 other columns
##  AND then 4 columns of 0's.

import subprocess
import datetime
import sevenbridges as sb
from sevenbridges.errors import SbgError
from Bio import SeqIO 
import os, re
import argparse
import csv

# get current working dir
workdir = os.getcwd()


parser = argparse.ArgumentParser()
parser.add_argument("--queryoutput", help="output file from bloomtree query bt query")
parser.add_argument("--fastainput", help="fasta file of which sequences only file is an input to bloomtree query bt query")
parser.add_argument("--cancertype", help="short string for cancer type, e.g. aml or gbm")
parser.add_argument("--namingstring", help="naming string to name the summary report file that is output from this script")
parser.add_argument("--fileofsampleids", help="file containing sample ids to identify the set of files we want to search in")
parser.add_argument("--numsamples", help="number of total samples, typically tar or tar.gz files, used when building bloomtree")
parser.add_argument("--bvinfofile", help="file containing sample ids and file ids and file names for the bv files, so that we can match samples with bv files")
parser.add_argument("--listoffilesnottouse", help="file containing parts of file names for files not to count when processing output from queries")
parser.add_argument("--usedatewhennamingfile", help="generate a nice date and use it when naming summary output file?? default if blank is to not do so; use yes or 1 if you want to use date. Note that removed files string will always have date in the name.")
parser.add_argument("--namingstringfornametofiles", help="naming string to name the name-to-files file that is output from this script; uses namingstring if left blank")

args = parser.parse_args()

queryoutput = args.queryoutput
fastainput = args.fastainput
cancertype = args.cancertype
numsamples= int(args.numsamples)

if args.fileofsampleids:
    using_sample_ids = True
    fileofsampleids = args.fileofsampleids
    bvinfofile = args.bvinfofile
else:
    using_sample_ids = False

# if namingstring isn't blank, add a period before it
if args.namingstring:
    namingstring = "." + args.namingstring
else:
    namingstring = ""

if args.namingstringfornametofiles:
    namingstringfornametofiles = "." + args.namingstringfornametofiles
else:
    namingstringfornametofiles = namingstring
    
# make nice date for use in naming files
today = datetime.date.today()
nicedate = today.strftime('%b%d').lower()

if (args.usedatewhennamingfile==1 or args.usedatewhennamingfile=="yes"):
    date_string_for_naming_file = "." + today
else:
    date_string_for_naming_file = ""
    
modifiedqueryoutputfile = os.path.join(os.path.dirname(queryoutput), "modified" + os.path.basename(queryoutput))
removedfilenames = os.path.join(workdir, "removed.files." + cancertype + "." + nicedate + namingstring + ".txt")

    
# If there is a list of files not to use (it's optional), then
#  process the query output first by removing lines containing any of
#  the keys    
#  Also save a file containing a list of distinct lines removed, for inspection afterward
if args.listoffilesnottouse:
    listoffilesnottouse = args.listoffilesnottouse
    with open(listoffilesnottouse, 'r') as ff:
        files_not_to_use = [line.rstrip('\n') for line in ff.readlines()]
    lines =[]
    removed = []
    with open(queryoutput, 'rU') as gg:
        for thisline in gg:
            savethisline = True
            for no_use_this in files_not_to_use:
                # if you haven't already found it, keep checking other values of no_use_this:
                if savethisline:
                    if re.search(pattern=no_use_this, string=thisline):
                        savethisline = False
                        removed.append(thisline)
            if savethisline:
                lines.append(thisline)
    distinct_removed = list(set(removed))
    ## write distinct_removed and lines to file
    with open(removedfilenames, 'w') as ff:
        ff.write(''.join([str(x) for x in distinct_removed]))
    with open(modifiedqueryoutputfile, 'w') as ff:
        ff.write(''.join([str(x) for x in lines]))
else:
    # Keep using the original file if no list of files not to use given
    modifiedqueryoutputfile = queryoutput
    

    

seqToNameDict = {}
nameToSeqDict = {}

# I'm changing this on oct 25 to account for sequences that have
#  multiple names associated with them.
for seq_record in SeqIO.parse(fastainput, "fasta"):
    name = str(seq_record.id)
    seq = str(seq_record.seq)
    nameToSeqDict[name] = seq
    if (seq not in seqToNameDict):
        # if seq not already in the dictionary, add it with value
        #  being a list of length 1 with name as the entry
        seqToNameDict[seq] = [name]
    else:
        # if seq IS already in the dictionary, append the name
        #    to the list
        seqToNameDict.get(seq).append(name)

##Process SBT output

# I changed this on oct 25 to account for sequences attached to multiple names.
# I changed this on oct 25 by replacing name with seq
#  to be consistent with the above; here's an example:
#  seqToNameDict['AAXXXXXXGCAAA']
#   Out[8]: 'XXXX-XXXX-1111-2222_mut_11_22'
# I also changed the last line, earlier on oct 25, because it was missing the seqToNameDict part
#   the last group previously would have had the seq as a key, but it should have the name
def read_sbt(fp):
    nameToFileDict = {}
    seq, files = None, []
    for line in fp:
        line = line.rstrip()
        if line.startswith("*"):
            if seq:
                # if it's time to write for this sequence, write
                # the nameToFileDict for all names that have that sequence:
                for name in seqToNameDict[seq]:
                    nameToFileDict[name] = files
            tmp = line.split()
            tmp = tmp[0][1:]
            seq, files = tmp, []
        else:
            line = line.split("/")[-1].strip(".rrr")
            files.append(line)
    if seq: 
        # if it's time to write for this sequence, write
        # the nameToFileDict for all names that have that sequence:
        for name in seqToNameDict[seq]:
            nameToFileDict[name] = files
    return nameToFileDict

### Do for full file:
with open(modifiedqueryoutputfile, 'rU') as SBT_handle:
    name_to_file_dict_for_all_files = read_sbt(SBT_handle)



## Write name-to-file dict to a txt file
name_to_file_output_file = os.path.join(workdir, "name.to.files.dict." + cancertype + date_string_for_naming_file + namingstring + ".txt")

with open(name_to_file_output_file, 'w') as hh:
    for seqname in name_to_file_dict_for_all_files:
        all_files_with_seqname = name_to_file_dict_for_all_files[seqname]
        hh.write("*%s\n" % seqname)
        for thisfile in all_files_with_seqname:
            hh.write("%s\n" % thisfile)



    
### Make name-to-sample-id dictionary from name-to-file-list dictionary
def make_name_to_sample_id_dict_from_name_to_file_list(name_to_file_list, tempbvinfohandle):
    name_to_sample_id_dict = {}
    bvfile_to_sample_id_dict = {}
    rawdatacsv = csv.reader(tempbvinfohandle, delimiter=',')
    next(rawdatacsv)
    for row in rawdatacsv:
        bvfile_to_sample_id_dict[row[0]] = row[2]
    for name in name_to_file_list.keys():
        this_file_list = name_to_file_list[name]
        this_sample_id_list = []
        for thisfile in this_file_list:
            this_sample_id_list.append(bvfile_to_sample_id_dict[thisfile])
        name_to_sample_id_dict[name] = this_sample_id_list
        assert(len(this_sample_id_list) == len(this_file_list))
    return name_to_sample_id_dict
    

if using_sample_ids:
    with open(bvinfofile, 'rU') as tempbvinfohandle:
        name_to_sample_list_for_all_files = make_name_to_sample_id_dict_from_name_to_file_list(name_to_file_list = name_to_file_dict_for_all_files, tempbvinfohandle = tempbvinfohandle)


# Get all the file names from the query output file
# This is a hack to get all the file names so we don't have to use
# the python api to get a list of all files in the project
# Note that it need not get all files in the project, just the files
# in the query output file.
def get_all_files_from_query_ouput_file(filename):
    files =[]
    with open(filename, 'rU') as ff:
        for line in ff:
            line = line.rstrip()
            if not line.startswith("*"):
                line = line.split("/")[-1].strip(".rrr")
                files.append(line)
    files = list(set(files))
    return files


        
    
if using_sample_ids:
    with open(fileofsampleids) as ff:
        sampleids = [line.rstrip('\n') for line in ff.readlines()]
    num_samples_in_file_of_sampleids = len(sampleids)
    if numsamples==num_samples_in_file_of_sampleids:
        name_to_file_list_for_keys = name_to_file_dict_for_all_files
        # Define number of samples in complement to be 1 if the file sizes are the same
        num_samples_complement = 1
    else:
        # make dict that gives the sample id from the bv file (technically, this is doing
        #   this twice)
        bvfile_to_sample_id_dict = {}
        with open(bvinfofile, 'rU') as tempbvinfohandle:
            rawdatacsv = csv.reader(tempbvinfohandle, delimiter=',')
            next(rawdatacsv)
            for row in rawdatacsv:
                bvfile_to_sample_id_dict[row[0]] = row[2]
        ## Do check to make sure that the file of sample ids actually picks up
        ## all of the files it should.
        ## Check for this by checking that everything in the file of sample ids
        ##  has an associated file in the query output file
        files_in_query_output_file = get_all_files_from_query_ouput_file(modifiedqueryoutputfile)
        n_matching_sample_ids = 0
        for thissampleid in sampleids:
            matching_id_yes_no = False
            for thisfile in files_in_query_output_file:
                bvsampleid = bvfile_to_sample_id_dict[thisfile]
                if (thissampleid == bvsampleid):
                    n_matching_sample_ids += 1
                    matching_id_yes_no = True
                    break
            if (not matching_id_yes_no):
                print("No file in query output file with sample ID matching sample ID " + thissampleid + ", which is in the sample id file\n")
        ## Note that if you had a small enough set of query output where
        ##  there was some file with none of the sequences in it, you wouldn't pick
        ##  up all files. So we check for this, as well as this being a general check
        ##  on our logic and inputs.
        assert(n_matching_sample_ids==len(sampleids))
        ## Now continue
        num_samples_complement = numsamples - num_samples_in_file_of_sampleids
        modified_query_output_file = os.path.join(workdir, "tempoutput." + nicedate + namingstring + ".txt")
        # Read in output from query
        # Keep only lines associated with at least one of the sample ids
        # Presumably there is a better way, but for ease, loop over all lines
        #  if it has a star at beginning of line, keep the line
        #  if not, look through all the sample ids; stop if you find one that works
        #  move to next line if you find a match
        #  if NONE match, then do not write it, and move to next line
        #  Then write new file and send to read_sbt
        out_list = []
        ff = open(modifiedqueryoutputfile, 'r')
        for line in ff:
            line = line.rstrip()
            if line.startswith("*"):
                out_list.append(line)
            else:
                line = re.sub(pattern='/srv/', repl='', string=line)
                line = re.sub(pattern='\.rrr', repl='', string=line)
                sample_associated_with_file = bvfile_to_sample_id_dict[line]
                if sample_associated_with_file in sampleids:
                    out_list.append(line)
        # Write modified file
        with open(modified_query_output_file, 'w') as gg:
            gg.write('\n'.join([str(x) for x in out_list]))
        # Use read_sbt function to process modified output file and make
        # name to file list for it
        with open(modified_query_output_file, 'rU') as SBT_handle:
            name_to_file_list_for_input_sample_ids = read_sbt(SBT_handle)
        with open(bvinfofile, 'rU') as tempbvinfohandle:
            name_to_sample_list_for_all_files = make_name_to_sample_id_dict_from_name_to_file_list(name_to_file_list = name_to_file_list_for_input_sample_ids, tempbvinfohandle = tempbvinfohandle)
    assert(numsamples >= num_samples_in_file_of_sampleids)

## end if using_sample_ids

        
# Name for output file that summarizes results
summary_output_file = os.path.join(workdir, "summary.bt.results." + cancertype + date_string_for_naming_file + namingstring + ".txt")



# Make summary output

# First do for the case that we are using sample ids:

if using_sample_ids:
    with open(summary_output_file, 'w') as temp_handle2:
        for seqname in nameToSeqDict:
            if seqname in name_to_sample_list_for_all_files:
                all_files_with_seqname = name_to_file_dict_for_all_files[seqname]
                n_all_files_with_seqname = len(all_files_with_seqname)
                ratio_all_files_with_seqname = float(n_all_files_with_seqname)/float(numsamples)
                temp_handle2.write("%s\t%s\t%s\t" % (seqname, str(n_all_files_with_seqname),str(ratio_all_files_with_seqname)))
                # if seqname in the files associated with keys, do this
                if seqname in name_to_file_list_for_input_sample_ids:
                    key_files_with_seqname = name_to_file_list_for_input_sample_ids[seqname]
                    n_key_files_with_seqname = len(key_files_with_seqname)
                    ratio_key_files_with_seqname = float(n_key_files_with_seqname)/float(num_samples_in_file_of_sampleids)
                    # Also do complement
                    n_complement = float(n_all_files_with_seqname - n_key_files_with_seqname)
                    ratio_complement = n_complement/float(num_samples_complement)
                    temp_handle2.write("%s\t%s\t%s\t%s\n" % (str(n_key_files_with_seqname),str(ratio_key_files_with_seqname), str(n_complement), str(ratio_complement)))
                else:
                    # if seqname not in the files associated with keys but it's in
                    #   the list of all files, then 
                    #   n_complement should equal n_all_files_with_seqname
                    n_complement = n_all_files_with_seqname
                    ratio_complement = n_complement/float(num_samples_complement)
                    # add NA's for all four of these last ones
                    temp_handle2.write("%s\t%s\t%s\t%s\n" % ("0", "0", str(n_complement), str(ratio_complement)))
            else:
                assert(seqname not in name_to_file_list_for_input_sample_ids)
                temp_handle2.write("%s\t%s\t%s\t%s\t%s\t%s\t%s\n" % (seqname, "0", "0", "0", "0", "0", "0"))

## end if using_sample_ids

if not using_sample_ids:
    with open(summary_output_file, 'w') as temp_handle2:
        for seqname in nameToSeqDict:
            if seqname in name_to_file_dict_for_all_files:
                all_files_with_seqname = name_to_file_dict_for_all_files[seqname]
                n_all_files_with_seqname = len(all_files_with_seqname)
                ratio_all_files_with_seqname = float(n_all_files_with_seqname)/float(numsamples)
                temp_handle2.write("%s\t%s\t%s\t%s\t%s\t%s\t%s\n" % (seqname, str(n_all_files_with_seqname),str(ratio_all_files_with_seqname) , "0", "0", "0", "0"))
            else:
                temp_handle2.write("%s\t%s\t%s\t%s\t%s\t%s\t%s\n" % (seqname, "0", "0", "0", "0", "0", "0"))

## end if NOT using_sample_ids

## Call this to make two matrix files with rows being sequence identifiers and
## columns being sample ids
## only for sequences with full in them but not decoy in them

name_to_file_output_file_full_no_decoy = os.path.join(workdir, "full.no.decoy.name.to.files.dict." + cancertype + date_string_for_naming_file + namingstring + ".txt")

with open(name_to_file_output_file_full_no_decoy, 'w') as hh:
    for seqname in name_to_file_dict_for_all_files:
        if (re.search(pattern = "full", string = seqname) and not (re.search(pattern = "decoy", string = seqname))):
            files_for_this_seqname = name_to_file_dict_for_all_files[seqname]
            hh.write("%s" % seqname)
            for thisfile in files_for_this_seqname:
                hh.write(",%s" % thisfile)
            hh.write("\n")


naming_string_for_r_script = "." + cancertype + namingstringfornametofiles

if not args.listoffilesnottouse:
    listoffilesnottouse = ""

matrixcall = "Rscript matrixfullnodecoypostprocess.R {name_to_file_output_file_full_no_decoy} {fileofsampleids} {bvinfofile} {naming_string_for_r_script} {listoffilesnottouse}".format(name_to_file_output_file_full_no_decoy=name_to_file_output_file_full_no_decoy, fileofsampleids=fileofsampleids, bvinfofile=bvinfofile, naming_string_for_r_script=naming_string_for_r_script, listoffilesnottouse=listoffilesnottouse)
subprocess.check_call(matrixcall, shell=True)

