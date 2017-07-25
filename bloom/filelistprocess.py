# modified from code by Erik Lehnert

import subprocess
import datetime
import sevenbridges as sb
from sevenbridges.errors import SbgError
from Bio import SeqIO 
import os, re
import argparse

# get current working dir
workdir = os.getcwd()


parser = argparse.ArgumentParser()
parser.add_argument("--queryoutput", help="output file from bloomtree query bt query")
parser.add_argument("--fastainput", help="fasta file of which sequences only file is an input to bloomtree query bt query")
parser.add_argument("--cancertype", help="short string for cancer type, e.g. aml or gbm")
parser.add_argument("--namingstring", help="naming string to name the summary report file that is output from this script")
parser.add_argument("--fileofkeys", help="file containing keys, i.e. parts of file names, to identify the set of files we want to search in; optional argument")
parser.add_argument("--numsamples", help="number of total samples, typically tar or tar.gz files, used when building bloomtree")

args = parser.parse_args()

queryoutput = args.queryoutput
fastainput = args.fastainput
cancertype = args.cancertype
numsamples= int(args.numsamples)

# if namingstring isn't blank, add a period before it
if args.namingstring:
    namingstring = "." + args.namingstring
else:
    namingstring = ""



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
    nameToFileList = {}
    seq, files = None, []
    for line in fp:
        line = line.rstrip()
        if line.startswith("*"):
            if seq:
                # if it's time to write for this sequence, write
                # the nameToFileList for all names that have that sequence:
                for name in seqToNameDict[seq]:
                    nameToFileList[name] = files
            tmp = line.split()
            tmp = tmp[0][1:]
            seq, files = tmp, []
        else:
            line = line.split("/")[-1].strip(".rrr")
            files.append(line)
    if seq: 
        # if it's time to write for this sequence, write
        # the nameToFileList for all names that have that sequence:
        for name in seqToNameDict[seq]:
            nameToFileList[name] = files
    return nameToFileList

### Do for full file:
with open(queryoutput, 'rU') as SBT_handle:
    name_to_file_list_for_all_files = read_sbt(SBT_handle)

# make nice date for use in naming files
today = datetime.date.today()
nicedate = today.strftime('%b%d').lower()

# Change file names so that names of files will be matched by the keys, because
#  we change the names when doing machete (in hindsight, shouldn't have)
#  This function is used for the keys in the file of keys
def clean_names(filename) :
    ttemp = re.sub(pattern="(_|-)", repl="", string=filename)
    return ttemp 

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


        
    
####################################################################
# Do stuff if there is a file of keys:
####################################################################
    
if args.fileofkeys:    
    fileofkeys = args.fileofkeys
    with open(fileofkeys) as ff:
        filekeys = [line.rstrip('\n') for line in ff.readlines()]
    num_samples_in_file_of_keys = len(filekeys)
    if numsamples==num_samples_in_file_of_keys:
        name_to_file_list_for_keys = name_to_file_list_for_all_files
        # Define number of samples in complement to be 1 if the file sizes are the same
        num_samples_complement = 1
    else:
        ## Do check to make sure that the file of keys actually picks up
        ## all of the files it should. E.g. 1G17210.TCGA12061601A01R184901.2
        ## causes a problem for GBM
        ## Check for this by checking that everything in the file of keys
        ##  has an associated file in the query output file
        files_in_query_output_file = get_all_files_from_query_ouput_file(queryoutput)
        filekeys_regex = [re.sub(pattern = "\.", repl = r"\.", string = x) for x in filekeys]
        n_matching_keys = 0
        for key in filekeys_regex:
            for thisfile in files_in_query_output_file:
                out_re = re.search(pattern=key, string = clean_names(thisfile))
                if out_re:
                    n_matching_keys += 1
                    break
        assert(n_matching_keys==len(filekeys_regex))
        ## Now continue
        num_samples_complement = numsamples - num_samples_in_file_of_keys
        modified_query_output_file = os.path.join(workdir, "tempoutput." + nicedate + namingstring + ".txt")
        # Read in output from query
        # Keep only lines that have one of the keys in them
        # Presumably there is a better way, but for ease, loop over all lines
        #  if it has a star at beginning of line, keep it
        #  if not, do grep with all the keys; stop if you find one that works
        #  move to next line if you find a match
        #  if NONE match, then remove it and move to next line
        #  Then write new file and send to read_sbt
        out_list = []
        ff = open(queryoutput, 'r')
        for line in ff:
            line = line.rstrip()
            if line.startswith("*"):
                out_list.append(line)
            else:
                for key in filekeys_regex:
                    out_re = re.search(pattern=key, string = clean_names(line))
                    if out_re:
                        out_list.append(line)
                        break
        # Write modified file
        with open(modified_query_output_file, 'w') as gg:
            gg.write('\n'.join([str(x) for x in out_list]))
        # Use read_sbt function to process modified output file
        with open(modified_query_output_file, 'rU') as SBT_handle:
            name_to_file_list_for_keys = read_sbt(SBT_handle)
else:
    fileofkeys = None
    num_samples_in_file_of_keys = 1
    num_samples_complement = 1
    name_to_file_list_for_keys= {}

assert(numsamples >= num_samples_in_file_of_keys)


# Name for output file that summarizes results
summary_output_file = os.path.join(workdir, "summary.bt.results." + cancertype + "." + nicedate + namingstring + ".txt")



# Make summary output 

with open(summary_output_file, 'w') as temp_handle2:
    for seqname in nameToSeqDict:
        if seqname in name_to_file_list_for_all_files:
            all_files_with_seqname = name_to_file_list_for_all_files[seqname]
            n_all_files_with_seqname = len(all_files_with_seqname)
            ratio_all_files_with_seqname = float(n_all_files_with_seqname)/float(numsamples)
            temp_handle2.write("%s\t%s\t%s\t" % (seqname, str(n_all_files_with_seqname),str(ratio_all_files_with_seqname)))
            # if seqname in the files associated with keys, do this
            if seqname in name_to_file_list_for_keys:
                key_files_with_seqname = name_to_file_list_for_keys[seqname]
                n_key_files_with_seqname = len(key_files_with_seqname)
                ratio_key_files_with_seqname = float(n_key_files_with_seqname)/float(num_samples_in_file_of_keys)
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
            assert(seqname not in name_to_file_list_for_keys)
            temp_handle2.write("%s\t%s\t%s\t%s\t%s\t%s\t%s\n" % (seqname, "0", "0", "0", "0", "0", "0"))


            
