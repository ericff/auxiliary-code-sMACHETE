# modified from code by Erik Lehnert

# makes sequence file from fasta file
# Set this to ensure that your query isn't smaller than the kmer used to build the SBT
# kmerLimit 

# python makesequencefile.py --fastainput all_sb_queries_10_14.fa --kmerlimit 19


import subprocess

# output is a file called summary.bt.results with a naming suffix

from Bio import SeqIO 
import os, re
import argparse

# get current working dir
workdir = os.getcwd()


parser = argparse.ArgumentParser()
parser.add_argument("--fastainput", help="fasta file of which sequences only file is an input to bloomtree query bt query")
parser.add_argument("--kmerlimit", help="Sequences must be longer than this to be included in the sequence")

args = parser.parse_args()

fastainput = args.fastainput
kmerlimit = args.kmerlimit


seqOnlyFile = os.path.join(workdir, re.sub(pattern='\.txt|\.fasta|\.fa', repl='', string=os.path.basename(fastainput)) + ".sequenceonlyfile.txt")

# Set this to ensure that your query isn't smaller than the kmer used to build the SBT

all_seqs = []
for seq_record in SeqIO.parse(fastainput, "fasta"):
    seq = str(seq_record.seq)
    if len(seq) > float(kmerlimit):
        all_seqs.append(seq)

# Add to make more efficient; only want to do a query once for each sequence, of course
unique_seqs = list(set(all_seqs))
        
ff = open(seqOnlyFile, 'w')
for seq in unique_seqs:
    ff.write("%s\n" % seq)

ff.close()

