{
  "id": "https://cgc-api.sbgenomics.com/v2/apps/ericfg/mach1/knife-for-work/4/raw/",
  "class": "CommandLineTool",
  "label": "knife-for-work",
  "description": "A version of knife that is hopefully somewhat user-friendly. It uses a docker image that clones from git, so the knife and machete code is stable. It outputs a tarball of the output directory from the knife called, e.g., mydatasetknifeoutputdir.tar.gz, that should in turn be used as one of the inputs to the machete-for-work tool. Note that it is very important that the dataset input string should be exactly the same as the one inputted into the machete.",
  "requirements": [
    {
      "class": "CreateFileRequirement",
      "fileDef": [
        {
          "filename": "callknifenomachete.py",
          "fileContent": "import re, os, glob, subprocess\n\n \nWORK_DIR = os.getcwd()\n#########################################################################\n# PARAMETERS, I.E. INPUTS TO KNIFE CALL; need to add these here\n#########################################################################\n\n# dataset_name CANNOT HAVE ANY SPACES IN IT\nimport argparse\nparser = argparse.ArgumentParser()\nparser.add_argument(\"--dataset\", help=\"name of dataset-NO SPACES- will be used for naming files\")\nparser.add_argument(\"--readidstyle\", help=\"read_id_style MUST BE either complete or appended\")\nparser.add_argument(\"--runid\", help=\"run_id to use for naming runs with the same data set; defaults to aa\")\nargs = parser.parse_args()\nif args.dataset:\n    dataset_name = args.dataset\nelse:\n    dataset_name = \"noname\"\n\nif args.readidstyle:\n    read_id_style = args.readidstyle\n    if (read_id_style not in ['complete','appended']):\n        raise ValueError(\"Error: readidstyle must be one of complete or appended\")\nelse:\n    raise ValueError(\"Error: readidstyle must be one of complete or appended\")\n    \nif args.runid:\n    run_id = args.runid\nelse:\n    run_id =\"aa\"\n    \nmode = \"skipDenovo\"\n# read_id_style= \"appended\"\njunction_overlap =  8\nreport_directory_name = \"circReads\"\nntrim= 40\n\n# Not really used, just doing so it mimics test Data call\nlogstdout_from_knife = \"logofstdoutfromknife\"\n\n##########################\n### USAGE\n############################\n\n#sh completeRun.sh read_directory read_id_style alignment_parent_directory \n# dataset_name junction_overlap mode report_directory_name ntrim denovoCircMode \n# junction_id_suffix 2>&1 | tee out.log\n# https://github.com/lindaszabo/KNIFE/tree/master/circularRNApipeline_Standalone\n\n#########################################################################\n# End of parameters\n#########################################################################\n \n# first have to create directories (if they don't already exist)\n#   and change file names and mv them to the right directories\n\n# get current working dir\n\nlogfile = WORK_DIR + \"/logknifenocomb\" + run_id + dataset_name + \".txt\"\n\nwith open(logfile, 'w') as ff:\n    ff.write(WORK_DIR)\n    ff.write('\\n\\n\\n')\n\n    \n# main directory to be used when running the knife:\n# \nknifedir = \"/srv/software/knife/circularRNApipeline_Standalone\"\n\n    \n    \ntargetdir_list = [knifedir + \"/index\", knifedir + \"/index\", knifedir + \"/denovo_scripts\", knifedir + \"/denovo_scripts/index\"]\n    \n# check that there is a directory called circularRNApipeline_Standalone and all the subdirectories; there should be!\n\nif not os.path.isdir(knifedir):\n    os.makedirs(knifedir)\n    \nthisdir = targetdir_list[0]\nif not os.path.exists(thisdir):\n    os.makedirs(thisdir)\n\nthisdir = targetdir_list[2]\nif not os.path.exists(thisdir):\n    os.makedirs(thisdir)\n\nthisdir = targetdir_list[3]\nif not os.path.exists(thisdir):\n    os.makedirs(thisdir)\n\n# Input file names are in an unusual format so they are easy to select when doing a run on\n#   seven bridges. They should start in the home directory, as copies, because\n#   they are entered as stage inputs.\n#   Move them to the directories where KNIFE\n#   expects them to be, then change their names.\n\n# make function to do this for each of the four types of files\n#  prefix is one of \"infilebt1\", \"infilebt2\", \"infilefastas\", or \"infilegtf\"\ndef move_and_rename(prefix, targetdir):\n    globpattern = prefix + \"*\"\n    matching_files = glob.glob(globpattern)\n    if (len(matching_files)>= 1):\n        for thisfile in matching_files:\n            fullpatholdfile = WORK_DIR + \"/\" + thisfile\n            fullpathnewfile = targetdir + \"/\" + re.sub(pattern=prefix, repl=\"\", string= thisfile)\n            subprocess.check_call([\"mv\", fullpatholdfile, fullpathnewfile])\n            with open(logfile, 'a') as ff:\n                ff.write('mv '+ fullpatholdfile + ' ' + fullpathnewfile + '\\n')\n\n#        os.rename(fullpatholdfile, fullpathnewfile)\n\nprefix_list = [\"infilebt2\", \"infilefastas\", \"infilegtf\", \"infilebt1\"]\n\nfor ii in range(4):\n    move_and_rename(prefix=prefix_list[ii], targetdir= targetdir_list[ii])\n\n    \n# cd into the knife directory\nos.chdir(knifedir)\n\nwith open(logfile, 'a') as ff:\n    ff.write('\\n\\n\\n')\n    subprocess.check_call([\"ls\", \"-R\"], stdout=ff)\n    ff.write('\\n\\n\\n')\n    \n\n# run test of knife\n# sh completeRun.sh READ_DIRECTORY complete OUTPUT_DIRECTORY testData 8 phred64 circReads 40 2>&1 | tee out.log\n\ntry:\n    with open(logfile, 'a') as ff:\n        ff.write('\\n\\n\\n')\n        # changing so as to remove calls to perl:\n        subprocess.check_call(\"sh completeRun.sh \" + WORK_DIR + \" \" + read_id_style + \" \" + WORK_DIR + \" \" + dataset_name + \" \" + str(junction_overlap) + \" \" + mode + \" \" + report_directory_name + \" \" + str(ntrim) + \" 2>&1 | tee \" + logstdout_from_knife , stdout = ff, shell=True)\n        # original test call:\n        # subprocess.check_call(\"sh completeRun.sh \" + WORK_DIR + \" complete \" + WORK_DIR + \" testData 8 phred64 circReads 40 2>&1 | tee outknifelog.txt\", stdout = ff, shell=True)\nexcept:\n    with open(logfile, 'a') as ff:\n        ff.write('Error in running completeRun.sh')\n\n\n#############################################################################\n# tar all files in data set folder (but not Swapped files)  and its\n#  subdirectories and tar them\n# It WILL output them with the directory structure, e.g. WITH a top level folder\n#   with the name of the aata set, e.g. these:\n# I.e. it will create a folder with a name\n#   of the dataset like testData\n# And below this will be subfolders such as\n#    circReads  orig  sampleStats\n# with a top level folder such as \"testData\" above them.\n# I did it differently before, thus all the explanation.\n#############################################################################\n\ndatadirlocation = WORK_DIR + \"/\" + dataset_name  \n\n# Change to WORK_DIR, then get all files in WORK_DIR/[dataset_name] folder, tar them.\n\n\nos.chdir(WORK_DIR)\ntry:\n   fullcall = \"tar -cvzf \" + dataset_name + \"knifeoutputdir.tar.gz \" + dataset_name \n   with open(logfile, 'a') as ff:\n       subprocess.check_call(fullcall, stderr=ff, stdout = ff, shell=True)\nexcept:\n   with open(logfile, 'a') as ff:\n       ff.write(\"\\nError in tarring the knife output files in the \" + dataset_name + \" directory\\n\")\n\n#############################################################################\n# Get two report files and tar and zip them\n#  Technically looks for all files with names ending in .report.txt\n# testData/circReads/combinedReports:\n# -rw-r--r--@ 1 awk  staff    12M May 22 00:57 naiveinfSRR1027187_1_report.txt\n#\n# testData/circReads/reports:\n# -rw-r--r--@ 1 awk  staff    12M May 22 00:04 infSRR1027187_1_report.txt\n#\n# Does not include the directory structure when tarring them\n#############################################################################\n\n\n\n\n\n\nos.chdir(WORK_DIR)\n\nfile_list = []\nfor root, subFolders, files in os.walk(\".\"):\n    for file in files:\n        file_list.append(os.path.join(root,file))\n        \ntry:\n    text_file_list = filter(lambda x:re.search('report.txt$', x), file_list)\nexcept:\n    with open(logfile, 'a') as ff:\n        ff.write(\"\\nError in matching report.txt for the two text files\\n\")\n\ntry:\n    text_file_list_without_paths = [os.path.basename(x) for x in text_file_list]\n    text_file_dirs = [os.path.dirname(x) for x in text_file_list]\nexcept:\n    with open(logfile, 'a') as ff:\n        ff.write(\"\\nError in getting basenames or dirnames for the two text files\\n\")\n\ntry:\n    for ii, thisfilename in enumerate(text_file_list_without_paths):\n        if ii==0:\n            fullcall = \"tar -cvf \" + dataset_name + \"knifetextfiles\" + run_id + \".tar -C \"+ text_file_dirs[ii] + \" \" +  thisfilename\n        elif ii>0:\n            fullcall = \"tar -rvf \" + dataset_name + \"knifetextfiles\" + run_id + \".tar  -C \" + text_file_dirs[ii]  +  \" \" + thisfilename\n        subprocess.check_call(fullcall, shell=True)\nexcept:\n    with open(logfile, 'a') as ff:\n        ff.write(\"\\nError in tarring the two knife text output files in the \" + dataset_name + \" directory\\n\")\n\ntry:\n    subprocess.check_call(\"gzip \" + dataset_name + \"knifetextfiles\" + run_id + \".tar\", shell=True)\nexcept:\n    with open(logfile, 'a') as ff:\n        ff.write(\"\\nProblem with gzipping.\\n\")\n        \nos.chdir(WORK_DIR)\n\n\n\n\n#############################################################################\n# Get all files in either circReads/glmReport or circReads/reports or sampleStats/\n# \n# tar should unpack files as relative to the output directory\n#  so, e.g. at the top level, it will create directories like circReads/glmReports, ...\n#############################################################################\n\nwdir = WORK_DIR\ndatadir = wdir + \"/\" + dataset_name\nos.chdir(datadir)\n\nwith open(logfile, 'a') as ff:\n    ff.write(\"\\nRecursively listing files in data dir before tarring files in\\n\")\n    ff.write(\"circReads/glmReport or circReads/reports or sampleStats \\n\")\n    ff.write(\"datadir is\\n\" + datadir)\n    ff.write('\\n\\n\\n')\n\nwith open(logfile, 'a') as ff:\n    subprocess.check_call([\"ls\", \"-R\"], stdout=ff)\n\nos.chdir(wdir)\n    \n        \ndirs_to_get_files = ['circReads/glmReports','circReads/reports','sampleStats']\nfull_path_dirs_to_get_files = [datadir + '/' + x for x in dirs_to_get_files]\n\n\ntempfilename = datadir + \"/tempfilelist\"\n\n\n# get names of all files in these directories with paths relative to datadir:\ntry:\n    txtfilelist =[]\n    for thisdir in dirs_to_get_files:\n        os.chdir(datadir)\n        if os.path.isdir(thisdir):\n            txtfilelist.extend([os.path.join(thisdir,x) for x in [f for f in os.listdir(thisdir) if os.path.isfile(os.path.join(thisdir,f))] ])\n        else:\n            os.chdir(datadir)\n            with open(logfile, 'a') as ff:\n                ff.write(\"\\nNo directory\\n\" + thisdir + \"\\n\")\n                ff.write('\\n\\n\\n')\n                subprocess.check_call([\"ls\", \"-R\"], stdout=ff)\n                ff.write('\\n\\n\\n')\nexcept:\n    os.chdir(datadir)\n    with open(logfile, 'a') as ff:\n        ff.write(\"\\nError when getting the names of the txt files in circReads/glmReport or circReads/reports or sampleStats \\n\")\n\n# append list of files to log file\nwith open(logfile, 'a') as ff:\n    ff.write('\\nList of files that will be tarred:\\n')\n    ff.write('\\n'.join([str(x) for x in txtfilelist]))\n\n\nos.chdir(wdir)\n\ntarfile = dataset_name + \"knifereportfiles.tar\"\n\nfor ii, thisfile in enumerate(txtfilelist):\n    try:\n        if ii==0:\n            fullcall = \"tar -cvf \" +  tarfile + \" -C \" + datadir + \" \" + thisfile \n        else:\n            fullcall = \"tar -rvf \" +  tarfile + \" -C \" + datadir + \" \" + thisfile \n        with open(logfile, 'a') as ff:\n            ff.write('\\nCall to use for tar:\\n')\n            ff.write(fullcall)\n        subprocess.check_call(fullcall, shell=True)\n    except:\n        with open(logfile, 'a') as ff:\n            ff.write(\"\\nError when tarring the reports output files for call:\\n\")\n            ff.write(fullcall)\n\nos.chdir(wdir)\n\nsubprocess.check_call(\"gzip \" + tarfile, shell=True)\n            \n        \nos.chdir(wdir)\n\n#############################################################################\n# List some files\n#############################################################################\n\n\n\nwith open(logfile, 'a') as ff:\n    ff.write('\\n\\n\\nWriting recursive list of entire working directory.\\n\\n')\n\n    \nwith open(logfile, 'a') as ff:\n    subprocess.check_call([\"ls\", \"-R\"], stdout=ff)\n    ff.write('\\n\\n\\n')\n    \nos.chdir(knifedir)\n    \nwith open(logfile, 'a') as ff:\n    ff.write('\\n\\n\\nWriting recursive list of knife directory.\\n\\n')\n\n    \nwith open(logfile, 'a') as ff:\n    subprocess.check_call([\"ls\", \"-R\"], stdout=ff)\n    ff.write('\\n\\n\\n')"
        }
      ]
    }
  ],
  "inputs": [
    {
      "id": "#inputarray",
      "description": "Type infile (NO ASTERISK) in search box. The interface should narrow the file list to 43 files. Click in the box to the left of Refresh to select all 43 files.",
      "type": [
        {
          "items": "File",
          "name": "inputarray",
          "type": "array"
        }
      ],
      "label": "Type infile in box Click in box to left of Refresh",
      "sbg:stageInput": "link"
    },
    {
      "id": "#datasetname",
      "description": "Name used in naming files- no spaces!!! Remember this EXACTLY for the machete.",
      "type": [
        "string"
      ],
      "inputBinding": {
        "separate": true,
        "prefix": "--dataset",
        "position": 1,
        "sbg:cmdInclude": true
      },
      "label": "Name of data set- NO SPACES"
    },
    {
      "id": "#readidstyle",
      "description": "Must be \"complete\" or \"appended\" exactly. See knife README for details.",
      "type": [
        "string"
      ],
      "inputBinding": {
        "separate": true,
        "prefix": "--readidstyle",
        "position": 2,
        "sbg:cmdInclude": true
      },
      "label": "read id style complete or appended"
    },
    {
      "id": "#runid",
      "description": "run id to use for naming runs with the same data set",
      "type": [
        "null",
        "string"
      ],
      "inputBinding": {
        "separate": true,
        "prefix": "--runid",
        "position": 3,
        "sbg:cmdInclude": true
      },
      "label": "run id- NO SPACES or weird characters"
    },
    {
      "id": "#fastqfiles",
      "description": "These should be named as in the knife github README. In testing, trim galore was run on these files first.",
      "type": [
        {
          "items": "File",
          "name": "fastqfiles",
          "type": "array"
        }
      ],
      "label": "Pair of .fastq or .fastq.gz or .fq or .fq.gz files",
      "sbg:stageInput": "link"
    }
  ],
  "outputs": [
    {
      "id": "#outputtarballs",
      "description": "The tarball of the whole output directory is an input to machete-for-work.",
      "type": [
        "null",
        {
          "items": "File",
          "name": "outputtarballs",
          "type": "array"
        }
      ],
      "label": "three tarballs one w text files one w orig dir files and one w whole output dir",
      "outputBinding": {
        "glob": "*tar.gz"
      }
    },
    {
      "id": "#logfile",
      "type": [
        "null",
        "File"
      ],
      "label": "log file only one file",
      "outputBinding": {
        "glob": "log*.txt"
      }
    }
  ],
  "hints": [
    {
      "class": "sbg:CPURequirement",
      "value": 16
    },
    {
      "class": "sbg:MemRequirement",
      "value": 25000
    },
    {
      "dockerPull": "cgc-images.sbgenomics.com/ericfg/mach1:jun16pmstablewithmachandknifecode",
      "dockerImageId": "",
      "class": "DockerRequirement"
    },
    {
      "class": "sbg:AWSInstanceType",
      "value": "c4.8xlarge"
    }
  ],
  "baseCommand": [
    "python",
    "callknifenomachete.py"
  ],
  "stdin": "",
  "stdout": "",
  "successCodes": [],
  "temporaryFailCodes": [],
  "arguments": [],
  "sbg:sbgMaintained": false,
  "sbg:cmdPreview": "python callknifenomachete.py --dataset datasetname-string-value --readidstyle readidstyle-string-value",
  "sbg:validationErrors": [],
  "sbg:revision": 4,
  "sbg:image_url": null,
  "sbg:modifiedBy": "ericfg",
  "sbg:createdOn": 1466144540,
  "sbg:appVersion": [
    "sbg:draft-2"
  ],
  "cwlVersion": "sbg:draft-2",
  "sbg:contributors": [
    "ericfg"
  ],
  "sbg:modifiedOn": 1466146808,
  "sbg:latestRevision": 5,
  "sbg:projectName": "mach1",
  "sbg:revisionsInfo": [
    {
      "sbg:revision": 0,
      "sbg:modifiedOn": 1466144540,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 1,
      "sbg:modifiedOn": 1466145625,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 2,
      "sbg:modifiedOn": 1466146219,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 3,
      "sbg:modifiedOn": 1466146469,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 4,
      "sbg:modifiedOn": 1466146808,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 5,
      "sbg:modifiedOn": 1480704458,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": "Using new docker image mach1:dec2, which includes change to predictJunctions.sh in KNIFE in order to remove _cdf from files in glmReports"
    }
  ],
  "sbg:createdBy": "ericfg",
  "sbg:id": "ericfg/mach1/knife-for-work/4",
  "sbg:project": "ericfg/mach1",
  "sbg:job": {
    "inputs": {
      "fastqfiles": [
        {
          "size": 0,
          "class": "File",
          "path": "/path/to/fastqfiles-1.ext",
          "secondaryFiles": []
        },
        {
          "size": 0,
          "class": "File",
          "path": "/path/to/fastqfiles-2.ext",
          "secondaryFiles": []
        }
      ],
      "datasetname": "datasetname-string-value",
      "readidstyle": "readidstyle-string-value",
      "runid": "runid-string-value",
      "inputarray": [
        {
          "size": 0,
          "class": "File",
          "path": "/path/to/inputarray-1.ext",
          "secondaryFiles": []
        },
        {
          "size": 0,
          "class": "File",
          "path": "/path/to/inputarray-2.ext",
          "secondaryFiles": []
        }
      ]
    },
    "allocatedResources": {
      "cpu": 16,
      "mem": 25000
    }
  }
}
