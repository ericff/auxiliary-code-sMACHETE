{
  "id": "https://cgc-api.sbgenomics.com/v2/apps/ericfg/bloomtree-gbm/bt-make-sequences-file-from-fasta/2/raw/",
  "class": "CommandLineTool",
  "label": "bt-make-sequences-file-from-fasta",
  "description": "Writes new file that has only the sequences from the fasta file. It will only write sequences that have length > kmerlimit to the output file.",
  "requirements": [
    {
      "class": "CreateFileRequirement",
      "fileDef": [
        {
          "filename": "makesequencefile.py",
          "fileContent": "# modified from code by Erik Lehnert\n\n# makes sequence file from fasta file\n# Set this to ensure that your query isn't smaller than the kmer used to build the SBT\n# kmerLimit \n\n# python makesequencefile.py --fastainput all_sb_queries_10_14.fa --kmerlimit 19\n\n\nimport subprocess\n\n# output is a file called summary.bt.results with a naming suffix\n\nfrom Bio import SeqIO \nimport os, re\nimport argparse\n\n# get current working dir\nworkdir = os.getcwd()\n\n\nparser = argparse.ArgumentParser()\nparser.add_argument(\"--fastainput\", help=\"fasta file of which sequences only file is an input to bloomtree query bt query\")\nparser.add_argument(\"--kmerlimit\", help=\"Sequences must be longer than this to be included in the sequence\")\n\nargs = parser.parse_args()\n\nfastainput = args.fastainput\nkmerlimit = args.kmerlimit\n\n\nseqOnlyFile = os.path.join(workdir, re.sub(pattern='\\.txt|\\.fasta|\\.fa', repl='', string=os.path.basename(fastainput)) + \".sequenceonlyfile.txt\")\n\n# Set this to ensure that your query isn't smaller than the kmer used to build the SBT\n\nall_seqs = []\nfor seq_record in SeqIO.parse(fastainput, \"fasta\"):\n    seq = str(seq_record.seq)\n    if len(seq) > float(kmerlimit):\n        all_seqs.append(seq)\n\n# Add to make more efficient; only want to do a query once for each sequence, of course\nunique_seqs = list(set(all_seqs))\n        \nff = open(seqOnlyFile, 'w')\nfor seq in unique_seqs:\n    ff.write(\"%s\\n\" % seq)\n\nff.close()"
        }
      ]
    }
  ],
  "inputs": [
    {
      "type": [
        "null",
        "File"
      ],
      "sbg:stageInput": "copy",
      "id": "#fastainput",
      "description": "fasta file",
      "inputBinding": {
        "prefix": "--fastainput",
        "separate": true,
        "sbg:cmdInclude": true
      },
      "label": "fastainput"
    },
    {
      "id": "#kmerlimit",
      "description": "This tool will only write sequences that have length > kmerlimit to the output file. Default is 19",
      "type": [
        "null",
        "string"
      ],
      "inputBinding": {
        "prefix": "--kmerlimit",
        "separate": true,
        "sbg:cmdInclude": true
      },
      "label": "kmerlimit"
    }
  ],
  "outputs": [
    {
      "id": "#sequencesonlyfile",
      "description": "file of only the sequences from fasta file. Also will only write sequences that have length > kmer limit value to the file.",
      "type": [
        "null",
        "File"
      ],
      "label": "sequenceonlyfile",
      "outputBinding": {
        "glob": "*sequenceonlyfile.txt"
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
    }
  ],
  "baseCommand": [
    "python",
    "makesequencefile.py"
  ],
  "stdin": "",
  "stdout": "",
  "successCodes": [],
  "temporaryFailCodes": [],
  "arguments": [],
  "sbg:sbgMaintained": false,
  "sbg:cmdPreview": "python makesequencefile.py",
  "sbg:revisionNotes": "Changing the tool so that it only writes one value of sequence to 'sequences only' file even if that sequence is associated with multiple names in the fasta file",
  "sbg:validationErrors": [],
  "sbg:revision": 2,
  "sbg:image_url": null,
  "sbg:modifiedBy": "ericfg",
  "sbg:createdOn": 1476824992,
  "sbg:appVersion": [
    "sbg:draft-2"
  ],
  "cwlVersion": "sbg:draft-2",
  "sbg:contributors": [
    "ericfg"
  ],
  "sbg:modifiedOn": 1477428890,
  "sbg:latestRevision": 2,
  "sbg:projectName": "Bloomtree GBM",
  "sbg:revisionsInfo": [
    {
      "sbg:revision": 0,
      "sbg:modifiedOn": 1476824992,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 1,
      "sbg:modifiedOn": 1476825481,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 2,
      "sbg:modifiedOn": 1477428890,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": "Changing the tool so that it only writes one value of sequence to 'sequences only' file even if that sequence is associated with multiple names in the fasta file"
    }
  ],
  "sbg:createdBy": "ericfg",
  "sbg:id": "ericfg/bloomtree-gbm/bt-make-sequences-file-from-fasta/2",
  "sbg:project": "ericfg/bloomtree-gbm",
  "sbg:job": {
    "inputs": {
      "fastainput": {
        "size": 0,
        "secondaryFiles": [],
        "path": "/path/to/fastainput.ext",
        "class": "File"
      },
      "kmerlimit": "kmerlimit-string-value"
    },
    "allocatedResources": {
      "cpu": 1,
      "mem": 1000
    }
  }
}
