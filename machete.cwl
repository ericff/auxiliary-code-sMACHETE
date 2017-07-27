{
  "id": "https://cgc-api.sbgenomics.com/v2/apps/JSALZMAN/machete/machete-light/2/raw/",
  "class": "CommandLineTool",
  "label": "machete-new-glm-script",
  "description": "Machete using new version of GLM_script_UseIndel.r. Note that it is very important that the dataset input string should be exactly the same as the one inputted into the knife-for-work tool.",
  "requirements": [
    {
      "class": "CreateFileRequirement",
      "fileDef": [
        {
          "filename": "callmachonly.py",
          "fileContent": "import re, os, glob, subprocess\n\n \n# get current working dir\nWORK_DIR = os.getcwd()\n#########################################################################\n# PARAMETERS, I.E. INPUTS TO KNIFE CALL; need to add these here\n#########################################################################\n\n# should you use the toy indel indices; use them for testing; generally this should be False\nuse_toy_indel = True\n\n# dataset_name CANNOT HAVE ANY SPACES IN IT\nimport argparse\nparser = argparse.ArgumentParser()\nparser.add_argument(\"--dataset\", help=\"name of dataset-NO SPACES- will be used for naming files\")\n# Should fix this later: not so good, no time now; get rid of dataset argument\n# and search for dataset name\nparser.add_argument(\"--knifeoutputtarball\", help=\"path to tarred and zipped file of knife output directory, the tarball should unpack with the name of the directory the same as the dataset name\")\nparser.add_argument(\"--runid\", help=\"name of dataset-NO SPACES- will be used for naming files\")\n\n\nargs = parser.parse_args()\nif args.dataset:\n    dataset_name = args.dataset\nelse:\n    dataset_name = \"nodatasetname\"\n\nknife_output_tarball = args.knifeoutputtarball\n\nif args.runid:\n    run_id = args.runid\nelse:\n    run_id = \"norunid\"\n    \n\n    \n# e.g. dataset_name = \"4ep18\" \n\nreport_directory_name = \"circReads\"\n\n\n# mode = \"skipDenovo\"\n# read_id_style= \"appended\"\n# junction_overlap =  8\n# ntrim= 40\n\n# Not really used, just doing so it mimics test Data call\n# logstdout_from_knife = \"logofstdoutfromknife\"\n\n\nlogfile = WORK_DIR + \"/logmachonly\" + dataset_name + run_id +\".txt\"\n\nwith open(logfile, 'w') as ff:\n    ff.write(WORK_DIR)\n    ff.write('\\n\\n\\n')\n\n    \n# main directory to be used when running the knife:\nknifedir = \"/srv/software/knife/circularRNApipeline_Standalone\"\n\n#########################################################################\n#\n# tar and unpack the knife output directory\n#   check that there is then a directory called dataset_name\n#   this is a hack for now\n#\n#########################################################################\n\nos.chdir(WORK_DIR)\nwith open(logfile, 'a') as ff:\n    ff.write(\"\\nAbout to try to unpack the tarfile \" + knife_output_tarball + \"\\n\")\ntry:\n    fullcall = \"tar -xvzf \" + knife_output_tarball\n    with open(logfile, 'a') as ff:\n        subprocess.check_call(fullcall, stderr=ff, stdout = ff, shell=True)\nexcept:\n    with open(logfile, 'a') as ff:\n        ff.write(\"\\nError in unpacking the tarfile \" + knife_output_tarball + \"\\n\")\n\ndatadir = os.path.join(WORK_DIR,dataset_name)\nif not os.path.isdir(datadir):\n    with open(logfile, 'a') as ff:\n        ff.write('ERROR: no directory\\n' + datadir + '\\nMake sure input of dataset matches dataset folder name unpacked from tarball.\\n All later work is suspect.\\n')\n        \n        \n\n#########################################################################\n#\n# Note: should have unpacked tar of knife output results before doing\n#   next part.\n#\n#########################################################################\n\n\n###Run MACHETE\n#Nathaniel Watson\n#05-26-2016 \n\nCIRCPIPE_DIR = os.path.join(WORK_DIR,dataset_name)\nif not os.path.isdir(CIRCPIPE_DIR):\n    with open(logfile, 'a') as ff:\n        ff.write('Problem: no directory\\n' + CIRCPIPE_DIR + '\\nMaking one.')\n    os.mkdir(CIRCPIPE_DIR)\nCIRCREF = os.path.join(knifedir,\"index\")\n# CIRCREF = os.path.join(WORK_DIR,dataset_name,report_directory_name,\"index\")\nif not os.path.isdir(CIRCREF):\n    with open(logfile, 'a') as ff:\n        ff.write('No directory\\n' + CIRCREF + '\\nNot so surprising.\\nMaking one.')\n    os.mkdir(CIRCREF)\nMACH_OUTPUT_DIR = os.path.join(WORK_DIR,\"mach\")\nos.mkdir(MACH_OUTPUT_DIR)\nEXONS = os.path.join(WORK_DIR,\"HG19exons\")\n\nif use_toy_indel:\n    REG_INDEL_INDICES = os.path.join(WORK_DIR,\"toyIndelIndices\") #test indices for faster runs\nelse:\n    REG_INDEL_INDICES = os.path.join(WORK_DIR,\"IndelIndices\")\n\n#########################################################################\n#\n# unpack HG19exons.tar.gz and IndelIndices.tar.gz\n#\n#########################################################################\n\nos.chdir(WORK_DIR)\n\n# Note that you have to choose a directory to start in, to unpack there\ndef unpack_tarball_with_checking(tarball, thislogfile, thisworkdir):\n    os.chdir(thisworkdir)\n    if os.path.isfile(tarball):\n        with open(thislogfile, 'a') as ff:\n            ff.write(\"\\nAbout to try to unpack the tarfile \" + tarball + \"\\n\")\n        try:\n            fullcall = \"tar -xvzf \" + tarball\n            with open(thislogfile, 'a') as ff:\n                subprocess.check_call(fullcall, stderr=ff, stdout = ff, shell=True)\n        except:\n            with open(thislogfile, 'a') as ff:\n                ff.write(\"\\nError in unpacking the tarfile \" + tarball + \" \\n\")\n    else:\n        with open(thislogfile, 'a') as ff:\n            ff.write(\"\\nERROR: No tarball found called \" + tarball + \" \\n\")\n\nunpack_tarball_with_checking(tarball = \"HG19exons.tar.gz\", thislogfile=logfile, thisworkdir=WORK_DIR)\nif use_toy_indel:\n    unpack_tarball_with_checking(tarball = \"toyIndelIndices.tar.gz\", thislogfile=logfile, thisworkdir=WORK_DIR)\nelse:\n    unpack_tarball_with_checking(tarball = \"IndelIndices.tar.gz\", thislogfile=logfile, thisworkdir=WORK_DIR)\n            \n            \n\n#########################################################################\n#\n# move reference libraries output by KNIFE to directory CIRC_REF that\n#   contains hg19_genome, hg19_transcriptome, hg19_junctions_reg and\n#   hg19_junctions_scrambled bowtie indices\n#\n#########################################################################\n    \n \n# first have to \n#   change file names and mv them to the right directories\n\n\n# Input file names are in an unusual format so they are easy to select when doing a run on\n#   seven bridges. They should start in the home directory, as copies, because\n#   they are entered as stage inputs. They start with the prefix \"infile\"\n#   Move them to the directory where MACHETE\n#   expects them to be, then change their names.\n\n\n\n\nknifedir = \"/srv/software/knife/circularRNApipeline_Standalone\"\n\n    \n    \ntargetdir_list = [knifedir + \"/index\", knifedir + \"/index\", knifedir + \"/denovo_scripts\", knifedir + \"/denovo_scripts/index\"]\n    \n# check that there is a directory called circularRNApipeline_Standalone and all the subdirectories; there should be!\n\nif not os.path.isdir(knifedir):\n    os.makedirs(knifedir)\n    \nthisdir = targetdir_list[0]\nif not os.path.exists(thisdir):\n    os.makedirs(thisdir)\n\nthisdir = targetdir_list[2]\nif not os.path.exists(thisdir):\n    os.makedirs(thisdir)\n\nthisdir = targetdir_list[3]\nif not os.path.exists(thisdir):\n    os.makedirs(thisdir)\n\n# Input file names are in an unusual format so they are easy to select when doing a run on\n#   seven bridges. They should start in the home directory, as copies, because\n#   they are entered as stage inputs.\n#   Move them to the directories where KNIFE\n#   expects them to be, then change their names.\n\n# make function to do this for each of the four types of files\n#  prefix is one of \"infilebt1\", \"infilebt2\", \"infilefastas\", or \"infilegtf\"\ndef move_and_rename(prefix, targetdir):\n    globpattern = prefix + \"*\"\n    matching_files = glob.glob(globpattern)\n    if (len(matching_files)>= 1):\n        for thisfile in matching_files:\n            fullpatholdfile = WORK_DIR + \"/\" + thisfile\n            fullpathnewfile = targetdir + \"/\" + re.sub(pattern=prefix, repl=\"\", string= thisfile)\n            subprocess.check_call([\"mv\", fullpatholdfile, fullpathnewfile])\n            with open(logfile, 'a') as ff:\n                ff.write('mv '+ fullpatholdfile + ' ' + fullpathnewfile + '\\n')\n\n#        os.rename(fullpatholdfile, fullpathnewfile)\n\nprefix_list = [\"infilebt2\", \"infilefastas\", \"infilegtf\", \"infilebt1\"]\n\nfor ii in range(4):\n    move_and_rename(prefix=prefix_list[ii], targetdir= targetdir_list[ii])\n\n    \n# cd into the knife directory\nos.chdir(knifedir)\n\nwith open(logfile, 'a') as ff:\n    ff.write('\\n\\n\\n')\n    ff.write('Listing files in knifedir ' + knifedir) \n    \nwith open(logfile, 'a') as ff:\n    ff.write('\\n\\n\\n')\n    subprocess.check_call([\"ls\", \"-R\"], stdout=ff)\n    ff.write('\\n\\n\\n')\n\n\n# Did the below in past, but now just change name of CIRCREF in run.py\n    \n# # Should still be in working dir now, but in case not\n# os.chdir(WORK_DIR)\n\n# # Note that files have prefixes like infilebt1 and infilebt2 b/c the extra\n# #  bt1 and bt2 told the knife program where to send them\n\n# prefix = \"infile\"\n# globpattern = prefix + \"*\"\n# matching_files = glob.glob(globpattern)\n# if (len(matching_files)>= 1):\n#     for thisfile in matching_files:\n#         fullpatholdfile = WORK_DIR + \"/\" + thisfile\n#         fullpathnewfile = CIRCREF + \"/\" + re.sub(pattern=prefix, repl=\"\", string= thisfile)\n#         with open(logfile, 'a') as ff:\n#             ff.write('About to do mv '+ fullpatholdfile + ' ' + fullpathnewfile + '\\n')\n#         with open(logfile, 'a') as ff:\n#             subprocess.check_call([\"mv\", fullpatholdfile, fullpathnewfile], stderr=ff, stdout=ff)\n        \n\n# # run test of knife\n# # sh completeRun.sh READ_DIRECTORY complete OUTPUT_DIRECTORY testData 8 phred64 circReads 40 2>&1 | tee out.log\n\n# try:\n#     with open(logfile, 'a') as ff:\n#         ff.write('\\n\\n\\n')\n#         # changing so as to remove calls to perl:\n#         subprocess.check_call(\"sh completeRun.sh \" + WORK_DIR + \" \" + read_id_style + \" \" + WORK_DIR + \" \" + dataset_name + \" \" + str(junction_overlap) + \" \" + mode + \" \" + report_directory_name + \" \" + str(ntrim) + \" 2>&1 | tee \" + logstdout_from_knife , stdout = ff, shell=True)\n#         # original test call:\n#         # subprocess.check_call(\"sh completeRun.sh \" + WORK_DIR + \" complete \" + WORK_DIR + \" testData 8 phred64 circReads 40 2>&1 | tee outknifelog.txt\", stdout = ff, shell=True)\n# except:\n#     with open(logfile, 'a') as ff:\n#         ff.write('Error in running completeRun.sh')\n\n\n\n# datadirlocation = WORK_DIR + \"/\" + dataset_name  \n\n#############################################################################\n#\n# Now run the machete\n#\n#############################################################################\n\n\n\n\nMACH_DIR = \"/srv/software/machete\"\nMACH_RUN_SCRIPT = os.path.join(MACH_DIR,\"run.py\")\n\ncmd = \"python {MACH_RUN_SCRIPT} --circpipe-dir {CIRCPIPE_DIR} --output-dir {MACH_OUTPUT_DIR} --hg19Exons {EXONS} --reg-indel-indices {REG_INDEL_INDICES} --circref-dir {CIRCREF}\".format(MACH_RUN_SCRIPT=MACH_RUN_SCRIPT,CIRCPIPE_DIR=CIRCPIPE_DIR,MACH_OUTPUT_DIR=MACH_OUTPUT_DIR,EXONS=EXONS,REG_INDEL_INDICES=REG_INDEL_INDICES,CIRCREF=CIRCREF)\n\nwith open(logfile, 'a') as ff:\n        ff.write('\\n\\n\\nAbout to run run.py\\n')\n        ff.write('\\n\\n\\n')\n\nwith open(logfile, 'a') as ff:\n        retcode = subprocess.call(cmd,shell=True, stdout=ff, stderr=ff)\n#        popen = subprocess.check_call(cmd,shell=True, stdout=ff, stderr=ff)\n\n## Write either YES*.error.in.subprocess.txt with 1 or\n##     NO*.error.in.subprocess.txt with 0\n## This allows you to see quickly in the results on Seven Bridges if there is \n##     an error in the subprocess call in run.py\n## File ends in error.in.subprocess.txt; the name changes depending on the value.\n\nerrorfiles = [os.path.join(WORK_DIR, x + \".error.\" + dataset_name + run_id + '.is.error.in.subprocess.txt')  for x in ['YES','NO']]\n\nif retcode:\n    with open(errorfiles[0], 'w') as ff:\n        ff.write('1')\nelse:\n    with open(errorfiles[1], 'w') as ff:\n        ff.write('0')\n\n\n        \n\nos.chdir(WORK_DIR)\n\n\nwith open(logfile, 'a') as ff:\n    ff.write('\\n\\n\\nListing working directory but not recursively.\\n\\n\\n')\n    \nwith open(logfile, 'a') as ff:\n    subprocess.check_call(\"ls -alh\", stdout=ff, stderr=ff, shell=True)\n    \nos.chdir(MACH_OUTPUT_DIR)\n\n\nwith open(logfile, 'a') as ff:\n    ff.write('\\n\\n\\nListing machete ouput directory recursively.\\n\\n\\n')\n    \nwith open(logfile, 'a') as ff:\n    subprocess.check_call(\"ls -alRh\", stdout=ff, stderr=ff, shell=True)\n    \nwith open(logfile, 'a') as ff:\n    ff.write('\\n\\n\\nMasterError.txt should start here.\\n\\n\\n')\n\nos.chdir(WORK_DIR)\n    \nfullpatholderrorfile = MACH_OUTPUT_DIR + \"/MasterError.txt\"\nif os.path.isfile(fullpatholderrorfile):\n    subprocess.check_call(\"cat \" + fullpatholderrorfile + \" >> \" + logfile, shell=True)\nelse:\n    with open(logfile, 'a') as ff:\n        ff.write('\\n\\n\\nNo MasterError.txt file found.\\n\\n\\n')\n\n# tar everything in mach_output_dir/reports \n#   Tar if it exists\nos.chdir(WORK_DIR)\nmach_output_reports_dir = os.path.join(MACH_OUTPUT_DIR,\"reports\")\nif os.path.isdir(mach_output_reports_dir):\n    try:\n        fullcall = \"tar -cvzf \" + dataset_name + run_id + \"machreportsout.tar.gz -C \" + MACH_OUTPUT_DIR + \" reports\"  \n        with open(logfile, 'a') as ff:\n            subprocess.check_call(fullcall, stderr=ff, stdout = ff, shell=True)\n    except:\n        with open(logfile, 'a') as ff:\n            ff.write(\"\\nError in tarring the machete output report files in the \" + mach_output_reports_dir + \" directory\\n\")\nelse:\n    with open(logfile, 'a') as ff:\n        ff.write(\"\\nNo directory of machete output reports called \" + mach_output_reports_dir + \", but expected that there was one.\\n\")\n    \n\n# tar everything in mach_output_dir/err_and_out if the directory exists\nos.chdir(WORK_DIR)\nmach_err_dir = os.path.join(MACH_OUTPUT_DIR,\"err_and_out\")\nif os.path.isdir(mach_err_dir):\n    try:\n        fullcall = \"tar -cvzf \" + dataset_name + run_id + \"macherrout.tar.gz -C \" + MACH_OUTPUT_DIR + \" err_and_out\"  \n        with open(logfile, 'a') as ff:\n            subprocess.check_call(fullcall, stderr=ff, stdout = ff, shell=True)\n    except:\n        with open(logfile, 'a') as ff:\n            ff.write(\"\\nError in tarring the machete err_and_out directory, namely the \" + mach_err_dir + \" directory\\n\")\nelse:\n    with open(logfile, 'a') as ff:\n        ff.write(\"\\nNo directory of machete errors and output called \" + mach_err_dir + \", but expected that there was one.\\n\")\n\n# tar everything in mach_output_dir/BadFJ_ver2 if the directory exists- changing name on jun 20\nos.chdir(WORK_DIR)\nmach_err_dir = os.path.join(MACH_OUTPUT_DIR,\"BadFJ_ver2\")\nif os.path.isdir(mach_err_dir):\n    try:\n        fullcall = \"tar -cvzf \" + dataset_name + run_id + \"machbadfjver2out.tar.gz -C \" + MACH_OUTPUT_DIR + \" BadFJ_ver2\"  \n        with open(logfile, 'a') as ff:\n            subprocess.check_call(fullcall, stderr=ff, stdout = ff, shell=True)\n    except:\n        with open(logfile, 'a') as ff:\n            ff.write(\"\\nError in tarring the machete BadFJ_ver2 directory, namely the \" + mach_err_dir + \" directory\\n\")\nelse:\n    with open(logfile, 'a') as ff:\n        ff.write(\"\\nNo directory of machete errors and output called \" + mach_err_dir + \", but expected that there was one.\\n\")\n\n\n# tar everything in mach_output_dir/x if the directory exists\n\ndef tar_subdirectory_of_mach_output_dir(thisdir, text_for_naming, MACH_OUTPUT_DIR, WORK_DIR, dataset_name, run_id, logfile):\n    os.chdir(WORK_DIR)\n    thisfulldir = os.path.join(MACH_OUTPUT_DIR,thisdir)\n    if os.path.isdir(thisfulldir):\n        try:\n            fullcall = \"tar -cvzf \" + dataset_name + run_id + \"mach\" + text_for_naming + \"out.tar.gz -C \" + MACH_OUTPUT_DIR + \" \" + thisdir  \n            with open(logfile, 'a') as ff:\n                subprocess.check_call(fullcall, stderr=ff, stdout = ff, shell=True)\n        except:\n            with open(logfile, 'a') as ff:\n                ff.write(\"\\nError in tarring the machete \" + thisdir + \" directory, namely the \" + thisfulldir + \" directory\\n\")\n    else:\n        with open(logfile, 'a') as ff:\n            ff.write(\"\\nNo directory within machete output directory called \" + thisfulldir + \", but expected that there was one.\\n\")\n\ntar_subdirectory_of_mach_output_dir(thisdir = \"GLM_classInput\", text_for_naming = \"glmclassinput\", MACH_OUTPUT_DIR=MACH_OUTPUT_DIR, WORK_DIR=WORK_DIR, dataset_name=dataset_name, run_id=run_id, logfile=logfile)\n\ntar_subdirectory_of_mach_output_dir(thisdir = \"reports\", text_for_naming = \"reports\", MACH_OUTPUT_DIR=MACH_OUTPUT_DIR, WORK_DIR=WORK_DIR, dataset_name=dataset_name, run_id=run_id, logfile=logfile)\n\ntar_subdirectory_of_mach_output_dir(thisdir = \"BadFJ\", text_for_naming = \"badfj\", MACH_OUTPUT_DIR=MACH_OUTPUT_DIR, WORK_DIR=WORK_DIR, dataset_name=dataset_name, run_id=run_id, logfile=logfile)\n\n# Now also get tar file of glm reports from knife for convenient reading together with\n#  machete output.\n\nos.chdir(WORK_DIR)\n\nglmdirlocation = os.path.join(WORK_DIR, dataset_name, \"circReads\")\n\nknifeglmreportstarfile = dataset_name + run_id + \"knifeglmreportfilesout.tar.gz\"\n\nfullcall = \"tar -cvzf \" + knifeglmreportstarfile + \" -C \" + glmdirlocation + \" glmReports\"\n\nwith open(logfile, 'a') as ff:\n    subprocess.check_call(fullcall, stdout=ff, stderr=ff, shell=True)\n\n# Now copy StemList.txt and MasterError.txt to\n#  files with better names so that they have unique names for each run\nstemoutfile = WORK_DIR + \"/StemList\" + dataset_name + run_id +\".txt\"\nstemorigfile = os.path.join(MACH_OUTPUT_DIR, \"StemList.txt\")\nfullcall = \"cp \" + stemorigfile + \" \" + stemoutfile \nwith open(logfile, 'a') as ff:\n    subprocess.check_call(fullcall, stdout=ff, stderr=ff, shell=True)\n\nmastererroroutfile = WORK_DIR + \"/MasterError\" + dataset_name + run_id +\".txt\"\nmastererrororigfile = os.path.join(MACH_OUTPUT_DIR, \"MasterError.txt\")\nfullcall = \"cp \" + mastererrororigfile + \" \" + mastererroroutfile\nwith open(logfile, 'a') as ff:\n    subprocess.check_call(fullcall, stdout=ff, stderr=ff, shell=True)"
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
      "label": "type infile in box Click in box to left of Refresh",
      "sbg:stageInput": "link"
    },
    {
      "id": "#datasetname",
      "description": "Name used in naming files- NO SPACES!!! Must exactly match name of data set in output from knife",
      "type": [
        "string"
      ],
      "inputBinding": {
        "prefix": "--dataset",
        "separate": true,
        "position": 1,
        "sbg:cmdInclude": true
      },
      "label": "Name of data set-MUST EXACTLY MATCH name from knife"
    },
    {
      "type": [
        "File"
      ],
      "sbg:stageInput": "link",
      "id": "#knifeoutputtarball",
      "description": "Tarred and Zipped File of Knife Output Directory. If your datasetname variable for knife-for-work was mydataset, then the file should be called  mydatasetknifeoutputdir.tar.gz",
      "inputBinding": {
        "prefix": "--knifeoutputtarball",
        "separate": true,
        "position": 1,
        "sbg:cmdInclude": true
      },
      "label": "Tarred and Zipped File of Knife Output Directory"
    },
    {
      "id": "#runid",
      "description": "run id used to name log file for use in distinguishing runs with the same data set",
      "type": [
        "null",
        "string"
      ],
      "inputBinding": {
        "prefix": "--runid",
        "separate": true,
        "position": 1,
        "sbg:cmdInclude": true
      },
      "label": "run id- NO SPACES or weird characters"
    },
    {
      "id": "#exons",
      "description": "Exons Tarball. Select the tarball containing the exons. Currently, this is the HG19exons.tar.gz file within the same projects as this app. MUST UNPACK to directory HG19exons.",
      "type": [
        "File"
      ],
      "label": "Select HG19exons.tar.gz",
      "sbg:stageInput": "link"
    },
    {
      "id": "#indel_indices",
      "description": "Indel Indices Tarball. The indel indices tarball. Currently, this is probably toyIndelIndices.tar.gz or IndelIndices.tar.gz file. The former was used in testing and the latter is much bigger. They both exist in the same project as this app. Either MUST UNPACK to directory IndelIndices; both of the earlier mentioned tarballs do.",
      "type": [
        "File"
      ],
      "label": "Select toyIndelIndices.tar.gz probably.",
      "sbg:stageInput": "link"
    }
  ],
  "outputs": [
    {
      "id": "#tarfiles",
      "description": "Tarballs of various sets of files, including tar of reports and err_and_out directory in mach output directory. All outputs end in out.tar.gz",
      "type": [
        "null",
        {
          "items": "File",
          "name": "tarfiles",
          "type": "array"
        }
      ],
      "label": "Tarballs of various sets of files",
      "outputBinding": {
        "glob": "*out.tar.gz"
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
    },
    {
      "id": "#stemlist",
      "description": "Sits in machete output directory, e.g. called mach.",
      "type": [
        "null",
        "File"
      ],
      "label": "StemList.txt",
      "outputBinding": {
        "glob": "StemList*.txt"
      }
    },
    {
      "id": "#MasterError",
      "type": [
        "null",
        "File"
      ],
      "label": "Master Error file",
      "outputBinding": {
        "glob": "MasterError*.txt"
      }
    },
    {
      "id": "#fastafile",
      "type": [
        "null",
        "File"
      ],
      "label": "fasta file",
      "outputBinding": {
        "glob": "mach/fasta/*.fa"
      }
    },
    {
      "id": "#errorfile",
      "description": "Name is either YES.error.in.subprocess.txt or NO.error.in.subprocess.txt for ease of viewing on SB. It contains a 1 if YES and 0 if NO.",
      "type": [
        "null",
        "File"
      ],
      "label": "Error file",
      "outputBinding": {
        "glob": "*.error.in.subprocess.txt"
      }
    }
  ],
  "hints": [
    {
      "class": "sbg:CPURequirement",
      "value": 2
    },
    {
      "class": "sbg:MemRequirement",
      "value": 16000
    },
    {
      "dockerPull": "cgc-images.sbgenomics.com/ericfg/mach1:aug15",
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
    "callmachonly.py"
  ],
  "stdin": "",
  "stdout": "",
  "successCodes": [],
  "temporaryFailCodes": [],
  "arguments": [],
  "sbg:sbgMaintained": false,
  "sbg:cmdPreview": "python callmachonly.py --dataset datasetname-string-value --knifeoutputtarball /path/to/knifeoutputtarball.ext",
  "sbg:revisionNotes": "Changing name of app",
  "sbg:validationErrors": [],
  "sbg:revision": 2,
  "sbg:image_url": null,
  "sbg:modifiedBy": "ericfg",
  "sbg:createdOn": 1471365481,
  "sbg:appVersion": [
    "sbg:draft-2"
  ],
  "cwlVersion": "sbg:draft-2",
  "sbg:contributors": [
    "ericfg"
  ],
  "sbg:modifiedOn": 1471563740,
  "sbg:latestRevision": 2,
  "sbg:projectName": "machete",
  "sbg:revisionsInfo": [
    {
      "sbg:revision": 0,
      "sbg:modifiedOn": 1471365481,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": "Copy of JSALZMAN/machete/machete-for-work/15"
    },
    {
      "sbg:revision": 1,
      "sbg:modifiedOn": 1471365712,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": "Uses new version of GLM_script_UseIndel.r. Copied from machete-for-work on aug 15."
    },
    {
      "sbg:revision": 2,
      "sbg:modifiedOn": 1471563740,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": "Changing name of app"
    }
  ],
  "sbg:createdBy": "ericfg",
  "sbg:id": "JSALZMAN/machete/machete-light/2",
  "sbg:project": "JSALZMAN/machete",
  "sbg:job": {
    "inputs": {
      "inputarray": [
        {
          "size": 0,
          "secondaryFiles": [],
          "path": "/path/to/inputarray-1.ext",
          "class": "File"
        },
        {
          "size": 0,
          "secondaryFiles": [],
          "path": "/path/to/inputarray-2.ext",
          "class": "File"
        }
      ],
      "exons": {
        "size": 0,
        "secondaryFiles": [],
        "path": "/path/to/exons.ext",
        "class": "File"
      },
      "knifeoutputtarball": {
        "size": 0,
        "secondaryFiles": [],
        "path": "/path/to/knifeoutputtarball.ext",
        "class": "File"
      },
      "indel_indices": {
        "size": 0,
        "secondaryFiles": [],
        "path": "/path/to/indel_indices.ext",
        "class": "File"
      },
      "runid": "runid-string-value",
      "datasetname": "datasetname-string-value"
    },
    "allocatedResources": {
      "cpu": 2,
      "mem": 16000
    }
  }
}
