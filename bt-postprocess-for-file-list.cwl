{
  "id": "https://cgc-api.sbgenomics.com/v2/apps/ericfg/bloomtree-gbm/bt-postprocess-for-file-list/3/raw/",
  "class": "CommandLineTool",
  "label": "bt-postprocess-for-file-list",
  "description": "Takes list of files as input and processes output from bt-query to preferred format; for each sequence description, gives fraction of files in the list in which sequence is present.",
  "requirements": [
    {
      "class": "CreateFileRequirement",
      "fileDef": [
        {
          "filename": "filelistprocess.py",
          "fileContent": "# modified from code by Erik Lehnert\n\nimport subprocess\nimport datetime\nimport sevenbridges as sb\nfrom sevenbridges.errors import SbgError\nfrom Bio import SeqIO \nimport os, re\nimport argparse\n\n# get current working dir\nworkdir = os.getcwd()\n\n\nparser = argparse.ArgumentParser()\nparser.add_argument(\"--queryoutput\", help=\"output file from bloomtree query bt query\")\nparser.add_argument(\"--fastainput\", help=\"fasta file of which sequences only file is an input to bloomtree query bt query\")\nparser.add_argument(\"--cancertype\", help=\"short string for cancer type, e.g. aml or gbm\")\nparser.add_argument(\"--namingstring\", help=\"naming string to name the summary report file that is output from this script\")\nparser.add_argument(\"--fileofkeys\", help=\"file containing keys, i.e. parts of file names, to identify the set of files we want to search in; optional argument\")\nparser.add_argument(\"--numsamples\", help=\"number of total samples, typically tar or tar.gz files, used when building bloomtree\")\n\nargs = parser.parse_args()\n\nqueryoutput = args.queryoutput\nfastainput = args.fastainput\ncancertype = args.cancertype\nnumsamples= int(args.numsamples)\n\n# if namingstring isn't blank, add a period before it\nif args.namingstring:\n    namingstring = \".\" + args.namingstring\nelse:\n    namingstring = \"\"\n\n\n\nseqToNameDict = {}\nnameToSeqDict = {}\n\n# I'm changing this on oct 25 to account for sequences that have\n#  multiple names associated with them.\nfor seq_record in SeqIO.parse(fastainput, \"fasta\"):\n    name = str(seq_record.id)\n    seq = str(seq_record.seq)\n    nameToSeqDict[name] = seq\n    if (seq not in seqToNameDict):\n        # if seq not already in the dictionary, add it with value\n        #  being a list of length 1 with name as the entry\n        seqToNameDict[seq] = [name]\n    else:\n        # if seq IS already in the dictionary, append the name\n        #    to the list\n        seqToNameDict.get(seq).append(name)\n\n##Process SBT output\n\n# I changed this on oct 25 to account for sequences attached to multiple names.\n# I changed this on oct 25 by replacing name with seq\n#  to be consistent with the above; here's an example:\n# I also changed the last line, earlier on oct 25, because it was missing the seqToNameDict part\n#   the last group previously would have had the seq as a key, but it should have the name\ndef read_sbt(fp):\n    nameToFileList = {}\n    seq, files = None, []\n    for line in fp:\n        line = line.rstrip()\n        if line.startswith(\"*\"):\n            if seq:\n                # if it's time to write for this sequence, write\n                # the nameToFileList for all names that have that sequence:\n                for name in seqToNameDict[seq]:\n                    nameToFileList[name] = files\n            tmp = line.split()\n            tmp = tmp[0][1:]\n            seq, files = tmp, []\n        else:\n            line = line.split(\"/\")[-1].strip(\".rrr\")\n            files.append(line)\n    if seq: \n        # if it's time to write for this sequence, write\n        # the nameToFileList for all names that have that sequence:\n        for name in seqToNameDict[seq]:\n            nameToFileList[name] = files\n    return nameToFileList\n\n### Do for full file:\nwith open(queryoutput, 'rU') as SBT_handle:\n    name_to_file_list_for_all_files = read_sbt(SBT_handle)\n\n# make nice date for use in naming files\ntoday = datetime.date.today()\nnicedate = today.strftime('%b%d').lower()\n\n# Change file names so that names of files will be matched by the keys, because\n#  we change the names when doing machete (in hindsight, shouldn't have)\n#  This function is used for the keys in the file of keys\ndef clean_names(filename) :\n    ttemp = re.sub(pattern=\"(_|-)\", repl=\"\", string=filename)\n    return ttemp \n\n# Get all the file names from the query output file\n# This is a hack to get all the file names so we don't have to use\n# the python api to get a list of all files in the project\n# Note that it need not get all files in the project, just the files\n# in the query output file.\ndef get_all_files_from_query_ouput_file(filename):\n    files =[]\n    with open(filename, 'rU') as ff:\n        for line in ff:\n            line = line.rstrip()\n            if not line.startswith(\"*\"):\n                line = line.split(\"/\")[-1].strip(\".rrr\")\n                files.append(line)\n    files = list(set(files))\n    return files\n\n\n        \n    \n####################################################################\n# Do stuff if there is a file of keys:\n####################################################################\n    \nif args.fileofkeys:    \n    fileofkeys = args.fileofkeys\n    with open(fileofkeys) as ff:\n        filekeys = [line.rstrip('\\n') for line in ff.readlines()]\n    num_samples_in_file_of_keys = len(filekeys)\n    if numsamples==num_samples_in_file_of_keys:\n        name_to_file_list_for_keys = name_to_file_list_for_all_files\n        # Define number of samples in complement to be 1 if the file sizes are the same\n        num_samples_complement = 1\n    else:\n        ## Do check to make sure that the file of keys actually picks up\n        ## all of the files it should. E.g. 1G17210.TCGA12061601A01R184901.2\n        ## causes a problem for GBM\n        ## Check for this by checking that everything in the file of keys\n        ##  has an associated file in the query output file\n        files_in_query_output_file = get_all_files_from_query_ouput_file(queryoutput)\n        filekeys_regex = [re.sub(pattern = \"\\.\", repl = r\"\\.\", string = x) for x in filekeys]\n        n_matching_keys = 0\n        for key in filekeys_regex:\n            for thisfile in files_in_query_output_file:\n                out_re = re.search(pattern=key, string = clean_names(thisfile))\n                if out_re:\n                    n_matching_keys += 1\n                    break\n        assert(n_matching_keys==len(filekeys_regex))\n        ## Now continue\n        num_samples_complement = numsamples - num_samples_in_file_of_keys\n        modified_query_output_file = os.path.join(workdir, \"tempoutput.\" + nicedate + namingstring + \".txt\")\n        # Read in output from query\n        # Keep only lines that have one of the keys in them\n        # Presumably there is a better way, but for ease, loop over all lines\n        #  if it has a star at beginning of line, keep it\n        #  if not, do grep with all the keys; stop if you find one that works\n        #  move to next line if you find a match\n        #  if NONE match, then remove it and move to next line\n        #  Then write new file and send to read_sbt\n        out_list = []\n        ff = open(queryoutput, 'r')\n        for line in ff:\n            line = line.rstrip()\n            if line.startswith(\"*\"):\n                out_list.append(line)\n            else:\n                for key in filekeys_regex:\n                    out_re = re.search(pattern=key, string = clean_names(line))\n                    if out_re:\n                        out_list.append(line)\n                        break\n        # Write modified file\n        with open(modified_query_output_file, 'w') as gg:\n            gg.write('\\n'.join([str(x) for x in out_list]))\n        # Use read_sbt function to process modified output file\n        with open(modified_query_output_file, 'rU') as SBT_handle:\n            name_to_file_list_for_keys = read_sbt(SBT_handle)\nelse:\n    fileofkeys = None\n    num_samples_in_file_of_keys = 1\n    num_samples_complement = 1\n    name_to_file_list_for_keys= {}\n\nassert(numsamples >= num_samples_in_file_of_keys)\n\n\n# Name for output file that summarizes results\nsummary_output_file = os.path.join(workdir, \"summary.bt.results.\" + cancertype + \".\" + nicedate + namingstring + \".txt\")\n\n\n\n# Make summary output \n\nwith open(summary_output_file, 'w') as temp_handle2:\n    for seqname in nameToSeqDict:\n        if seqname in name_to_file_list_for_all_files:\n            all_files_with_seqname = name_to_file_list_for_all_files[seqname]\n            n_all_files_with_seqname = len(all_files_with_seqname)\n            ratio_all_files_with_seqname = float(n_all_files_with_seqname)/float(numsamples)\n            temp_handle2.write(\"%s\\t%s\\t%s\\t\" % (seqname, str(n_all_files_with_seqname),str(ratio_all_files_with_seqname)))\n            # if seqname in the files associated with keys, do this\n            if seqname in name_to_file_list_for_keys:\n                key_files_with_seqname = name_to_file_list_for_keys[seqname]\n                n_key_files_with_seqname = len(key_files_with_seqname)\n                ratio_key_files_with_seqname = float(n_key_files_with_seqname)/float(num_samples_in_file_of_keys)\n                # Also do complement\n                n_complement = float(n_all_files_with_seqname - n_key_files_with_seqname)\n                ratio_complement = n_complement/float(num_samples_complement)\n                temp_handle2.write(\"%s\\t%s\\t%s\\t%s\\n\" % (str(n_key_files_with_seqname),str(ratio_key_files_with_seqname), str(n_complement), str(ratio_complement)))\n            else:\n                # if seqname not in the files associated with keys but it's in\n                #   the list of all files, then \n                #   n_complement should equal n_all_files_with_seqname\n                n_complement = n_all_files_with_seqname\n                ratio_complement = n_complement/float(num_samples_complement)\n                # add NA's for all four of these last ones\n                temp_handle2.write(\"%s\\t%s\\t%s\\t%s\\n\" % (\"0\", \"0\", str(n_complement), str(ratio_complement)))\n        else:\n            assert(seqname not in name_to_file_list_for_keys)\n            temp_handle2.write(\"%s\\t%s\\t%s\\t%s\\t%s\\t%s\\t%s\\n\" % (seqname, \"0\", \"0\", \"0\", \"0\", \"0\", \"0\"))"
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
      "id": "#queryoutput",
      "description": "output file from bloomtree query bt query",
      "inputBinding": {
        "prefix": "--queryoutput",
        "separate": true,
        "sbg:cmdInclude": true
      },
      "label": "queryoutput"
    },
    {
      "type": [
        "null",
        "File"
      ],
      "sbg:stageInput": "copy",
      "id": "#fastainput",
      "description": "\", help=\"fasta file of which sequences only file is an input to bloomtree query bt query",
      "inputBinding": {
        "prefix": "--fastainput",
        "separate": true,
        "sbg:cmdInclude": true
      },
      "label": "fastainput"
    },
    {
      "type": [
        "null",
        "string"
      ],
      "sbg:stageInput": null,
      "id": "#numsamples",
      "description": "number of samples, typically tar or tar.gz files, used when building bloomtree",
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
        "null",
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
      "id": "#fileofkeys",
      "description": "File of keys (i.e. parts of file names) to use to determine from query output file if a sequence is in the file. Each line should have exactly one key.",
      "type": [
        "null",
        "File"
      ],
      "inputBinding": {
        "prefix": "--fileofkeys",
        "separate": true,
        "sbg:cmdInclude": true
      },
      "label": "fileofkeys"
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
    "filelistprocess.py"
  ],
  "stdin": "",
  "stdout": "",
  "successCodes": [],
  "temporaryFailCodes": [],
  "arguments": [],
  "sbg:sbgMaintained": false,
  "sbg:cmdPreview": "python filelistprocess.py",
  "sbg:revisionNotes": "Fixed float typo.",
  "sbg:validationErrors": [],
  "sbg:revision": 3,
  "sbg:image_url": null,
  "sbg:modifiedBy": "ericfg",
  "sbg:createdOn": 1477435459,
  "sbg:appVersion": [
    "sbg:draft-2"
  ],
  "cwlVersion": "sbg:draft-2",
  "sbg:contributors": [
    "ericfg"
  ],
  "sbg:modifiedOn": 1477629665,
  "sbg:latestRevision": 3,
  "sbg:projectName": "Bloomtree GBM",
  "sbg:revisionsInfo": [
    {
      "sbg:revision": 0,
      "sbg:modifiedOn": 1477435459,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": "Copy of ericfg/bloomtree-gbm/bt-postprocess/10"
    },
    {
      "sbg:revision": 1,
      "sbg:modifiedOn": 1477435860,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 2,
      "sbg:modifiedOn": 1477606882,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": "This version gives counts and ratios for all files, and for the subset of files associated with the file of keywords for the files, and for the complement of the latter."
    },
    {
      "sbg:revision": 3,
      "sbg:modifiedOn": 1477629665,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": "Fixed float typo."
    }
  ],
  "sbg:createdBy": "ericfg",
  "sbg:id": "ericfg/bloomtree-gbm/bt-postprocess-for-file-list/3",
  "sbg:project": "ericfg/bloomtree-gbm",
  "sbg:job": {
    "inputs": {
      "namingstring": "namingsuffix-string-value",
      "numsamples": "numsamples-string-value",
      "queryoutput": {
        "size": 0,
        "secondaryFiles": [],
        "path": "/path/to/queryoutput.ext",
        "class": "File"
      },
      "fastainput": {
        "size": 0,
        "secondaryFiles": [],
        "path": "/path/to/fastainput.ext",
        "class": "File"
      },
      "fileofkeys": {
        "size": 0,
        "secondaryFiles": [],
        "path": "/path/to/fileofkeys.ext",
        "class": "File"
      },
      "cancertype": "cancertype-string-value"
    },
    "allocatedResources": {
      "cpu": 1,
      "mem": 1000
    }
  }
}
