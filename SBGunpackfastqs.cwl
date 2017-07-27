{
  "id": "https://cgc-api.sbgenomics.com/v2/apps/JSALZMAN/machete/sbg-unpack-fastqs-1-0/3/raw/",
  "class": "CommandLineTool",
  "label": "SBG Unpack FASTQs",
  "description": "SBG Unpack FASTQs performs the extraction of the input archive, containing FASTQ files.  \nThis tool also sets the \"paired_end\" metadata field. It assumes that FASTQ file names are formatted in this manner:\nfirst pair reads FASTQ file        -  *1.fastq\nsecond pair reads FASTQ file  -  * 2.fastq. \nwhere * represents any string.\nThe names of the FASTQ files from the archive are retained. The aliquote prefix in the filename is not part of the paired end FASTQ file names on the output and it is not propagated downstream. \nSupported formats are:\n1. TAR\n2. TAR.GZ (TGZ)\n3. TAR.BZ2 (TBZ2)\n4. GZ\n5. BZ2\n6. ZIP",
  "requirements": [
    {
      "id": "#cwl-js-engine",
      "requirements": [
        {
          "dockerPull": "rabix/js-engine",
          "class": "DockerRequirement"
        }
      ],
      "class": "ExpressionEngineRequirement"
    }
  ],
  "inputs": [
    {
      "sbg:category": "",
      "type": [
        "File"
      ],
      "id": "#input_archive_file",
      "description": "The input archive file, containing FASTQ files, to be unpacked.",
      "sbg:fileTypes": "TAR, TAR.GZ, TGZ, TAR.BZ2, TBZ2,  GZ, BZ2, ZIP",
      "inputBinding": {
        "separate": true,
        "prefix": "--input_archive_file",
        "position": 0,
        "sbg:cmdInclude": true
      },
      "label": "Input archive file"
    }
  ],
  "outputs": [
    {
      "type": [
        {
          "items": "File",
          "type": "array"
        }
      ],
      "id": "#output_fastq_files",
      "description": "Output FASTQ files.",
      "sbg:fileTypes": "FASTQ",
      "label": "Output FASTQ files",
      "outputBinding": {
        "sbg:inheritMetadataFrom": "#input_archive_file",
        "glob": "decompressed_files/*.fastq",
        "sbg:metadata": {
          "paired_end": {
            "script": "{\n  filepath = $self.path\n  filename = filepath.split(\"/\").pop();\n  if (filename.lastIndexOf(\".fastq\") !== 0)\n  \treturn filename[filename.lastIndexOf(\".fastq\") - 1 ]\n  else\n  \treturn \"\"\n}",
            "class": "Expression",
            "engine": "#cwl-js-engine"
          }
        }
      }
    }
  ],
  "hints": [
    {
      "dockerPull": "images.sbgenomics.com/markop/sbg-unpack-fastqs:1.0",
      "dockerImageId": "df9e1c169beb",
      "class": "DockerRequirement"
    },
    {
      "class": "sbg:CPURequirement",
      "value": 1
    },
    {
      "class": "sbg:MemRequirement",
      "value": 1000
    }
  ],
  "baseCommand": [
    "/opt/sbg_unpack_fastqs.py"
  ],
  "stdin": "",
  "stdout": "out.txt",
  "successCodes": [],
  "temporaryFailCodes": [],
  "arguments": [],
  "sbg:toolkitVersion": "v1.0",
  "sbg:revision": 3,
  "sbg:modifiedOn": 1467244537,
  "sbg:latestRevision": 4,
  "cwlVersion": "sbg:draft-2",
  "sbg:sbgMaintained": false,
  "sbg:homepage": "https://igor.sbgenomics.com/",
  "sbg:cmdPreview": "/opt/sbg_unpack_fastqs.py --input_archive_file input_file.tar > out.txt",
  "sbg:validationErrors": [],
  "sbg:toolAuthor": "Marko Petkovic, Seven Bridges Genomics",
  "sbg:license": "Apache License 2.0",
  "sbg:image_url": null,
  "sbg:modifiedBy": "ericfg",
  "sbg:projectName": "machete",
  "sbg:revisionsInfo": [
    {
      "sbg:revision": 0,
      "sbg:modifiedOn": 1464908367,
      "sbg:modifiedBy": "JSALZMAN",
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 1,
      "sbg:modifiedOn": 1467240887,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 2,
      "sbg:modifiedOn": 1467242049,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 3,
      "sbg:modifiedOn": 1467244537,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 4,
      "sbg:modifiedOn": 1470953840,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": "Using c4.large now because of initializing instances issue."
    }
  ],
  "sbg:createdOn": 1464908367,
  "sbg:id": "JSALZMAN/machete/sbg-unpack-fastqs-1-0/3",
  "sbg:project": "JSALZMAN/machete",
  "sbg:appVersion": [
    "sbg:draft-2"
  ],
  "sbg:job": {
    "inputs": {
      "input_archive_file": {
        "size": 0,
        "class": "File",
        "path": "input_file.tar",
        "secondaryFiles": []
      }
    },
    "allocatedResources": {
      "cpu": 1,
      "mem": 1000
    }
  },
  "sbg:categories": [
    "Other"
  ],
  "sbg:toolkit": "SBGTools",
  "sbg:contributors": [
    "ericfg",
    "JSALZMAN"
  ],
  "sbg:createdBy": "JSALZMAN"
}
