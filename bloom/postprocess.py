# modified from code by Erik Lehnert

import subprocess
import datetime

# python3 postprocess.py --queryoutput bloomwork/all_sb_queries_10_14_sequences_only_versus__1_AML.txt --fastainput all_sb_queries_10_14.fa --numsamples 179 --namingsuffix aml.10.14


# output is a file called summary.bt.results with a naming suffix

import sevenbridges as sb
from sevenbridges.errors import SbgError
from Bio import SeqIO 
import os
import argparse

# get current working dir
workdir = os.getcwd()


parser = argparse.ArgumentParser()
parser.add_argument("--queryoutput", help="output file from bloomtree query bt query")
parser.add_argument("--fastainput", help="fasta file of which sequences only file is an input to bloomtree query bt query")
parser.add_argument("--numsamples", help="number of samples, typically tar or tar.gz files, used when building bloomtree")
parser.add_argument("--cancertype", help="short string for cancer type, e.g. aml or gbm")
parser.add_argument("--namingstring", help="naming string to name the summary report file that is output from this script")

args = parser.parse_args()

queryoutput = args.queryoutput
fastainput = args.fastainput
numsamples = args.numsamples
cancertype = args.cancertype

# if namingstring isn't blank, add a period before it
if args.namingstring:
    namingstring = "." + args.namingstring
else:
    namingstring = ""


# Changing seqToNameDict so that it contains a list of names for every seq
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


nameToFileList = {}
firstLine = True
hold = []

# I changed this on oct 25 to account for sequences attached to multiple names.
# I changed this on oct 25 by replacing name with seq
#  to be consistent with the above; here's an example:
#  seqToNameDict['AAXXXXXXGCAAA']
#   Out[8]: 'XXXX-XXXX-1111-2222_mut_11_22'
# I also changed the last line, earlier on oct 25, because it was missing the seqToNameDict part
#   the last group previously would have had the seq as a key, but it should have the name
def read_sbt(fp):
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


with open(queryoutput, 'rU') as SBT_handle:
    read_sbt(SBT_handle)

    
today = datetime.date.today()
nicedate = today.strftime('%b%d').lower()

# Name for output file that summarizes results
summary_output_file = os.path.join(workdir, "summary.bt.results." + cancertype + "." + nicedate + namingstring + ".txt")



# Make summary output

with open(summary_output_file, 'a') as temp_handle2:
    for key in nameToSeqDict:
        if key in nameToFileList:
            tmp = nameToFileList[key]
            tmp2 = float(len(tmp))/float(numsamples)
            temp_handle2.write("%s\t%s\t%s\n" % (key, str(len(tmp)),str(tmp2))) 
        else:
            temp_handle2.write("%s\t%s\t%s\n" % (key, "0", "0")) 
            
