{
  "id": "https://cgc-api.sbgenomics.com/v2/apps/ericfg/bloomtree-gbm/bt-count/0/raw/",
  "class": "CommandLineTool",
  "label": "bt count",
  "description": "",
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
    },
    {
      "class": "CreateFileRequirement",
      "fileDef": [
        {
          "filename": "runSBT_Count.sh",
          "fileContent": {
            "script": "{\n filepath = $job.inputs.fasta_in[0].path\n filename = filepath.split(\"/\").pop();\n file_dot_sep = filename.split(\".\"); \n new_filename = filename.substr(0,filename.lastIndexOf(\".\")) + \".concatenated.bf.bv\"\n var list = [].concat($job.inputs.fasta_in)\n tmp = \"\"\n for (index = 0; index < list.length; ++index) {\n   tmp += \" \" + list[index].path\n }\n \n if ($job.inputs.cutoff) {\n  cutoff =  $job.inputs.cutoff}\n else {\n   cutoff = \"3\"}\n \n if ($job.inputs.bf_size) {\n  bf_size = $job.inputs.bf_size\n  }\n else {\n   bf_size = \"2000000000\"\n }\n  \n  \nreturn \"bt count --cutoff \" + cutoff + \" --threads \" + $job.allocatedResources.cpu + \" \" + $job.inputs.hashfile.path + \" \" + bf_size + \" <(cat\" + tmp + \")\" + \" \" + new_filename + \" && rm \" + tmp\n}",
            "class": "Expression",
            "engine": "#cwl-js-engine"
          }
        }
      ]
    }
  ],
  "inputs": [
    {
      "id": "#cutoff",
      "sbg:toolDefaultValue": "3",
      "description": "The kmer count cutoff",
      "type": [
        "null",
        "int"
      ],
      "label": "cutoff"
    },
    {
      "sbg:toolDefaultValue": "1",
      "type": [
        "File"
      ],
      "id": "#hashfile",
      "description": "The location of the hashfile written using the \"hashes\" function",
      "sbg:fileTypes": "HH",
      "label": "hashfile"
    },
    {
      "id": "#bf_size",
      "sbg:toolDefaultValue": "2000000000",
      "description": "bf_size determines the size of bloom filters used and should be set to an approximate count of the number of unique k-mers in your dataset.",
      "type": [
        "null",
        "string"
      ],
      "label": "bf_size"
    },
    {
      "type": [
        {
          "items": "File",
          "name": "fasta_in",
          "type": "array"
        }
      ],
      "sbg:stageInput": null,
      "id": "#fasta_in",
      "description": "Input fasta/fastq being counted",
      "sbg:fileTypes": "FASTA, FASTQ",
      "label": "fasta_in"
    }
  ],
  "outputs": [
    {
      "id": "#bit_vector",
      "sbg:fileTypes": "BV",
      "outputBinding": {
        "sbg:inheritMetadataFrom": "#fasta_in",
        "glob": "*bf.bv"
      },
      "type": [
        "null",
        "File"
      ]
    },
    {
      "id": "#bashScript",
      "type": [
        "null",
        "File"
      ],
      "outputBinding": {
        "glob": "*.sh"
      }
    }
  ],
  "hints": [
    {
      "class": "sbg:MemRequirement",
      "value": 1000
    },
    {
      "dockerPull": "cgc-images.sbgenomics.com/elehnert/sbt:0.3.5",
      "dockerImageId": "",
      "class": "DockerRequirement"
    },
    {
      "class": "sbg:CPURequirement",
      "value": 4
    }
  ],
  "baseCommand": [
    "bash",
    "runSBT_Count.sh"
  ],
  "stdin": "",
  "stdout": "",
  "successCodes": [],
  "temporaryFailCodes": [],
  "arguments": [],
  "sbg:sbgMaintained": false,
  "sbg:cmdPreview": "bash runSBT_Count.sh",
  "sbg:revisionNotes": "Copy of elehnert/sequence-bloom-tree-reference-apps/bt-count/26",
  "sbg:validationErrors": [],
  "sbg:revision": 0,
  "sbg:image_url": null,
  "sbg:modifiedBy": "elehnert",
  "sbg:createdOn": 1473790332,
  "sbg:appVersion": [
    "sbg:draft-2"
  ],
  "cwlVersion": "sbg:draft-2",
  "sbg:contributors": [
    "elehnert"
  ],
  "sbg:updateModifiedBy": "elehnert",
  "sbg:modifiedOn": 1473790332,
  "sbg:latestRevision": 0,
  "sbg:updateRevisionNotes": null,
  "sbg:projectName": "Bloomtree GBM",
  "sbg:update": "elehnert/sequence-bloom-tree-reference-apps/bt-count/29",
  "sbg:revisionsInfo": [
    {
      "sbg:revision": 0,
      "sbg:modifiedOn": 1473790332,
      "sbg:modifiedBy": "elehnert",
      "sbg:revisionNotes": "Copy of elehnert/sequence-bloom-tree-reference-apps/bt-count/26"
    }
  ],
  "sbg:createdBy": "elehnert",
  "sbg:id": "ericfg/bloomtree-gbm/bt-count/0",
  "sbg:project": "ericfg/bloomtree-gbm",
  "sbg:job": {
    "inputs": {
      "hashfile": {
        "size": 0,
        "secondaryFiles": [],
        "path": "/path/to/hashfile.ext",
        "class": "File"
      },
      "fasta_in": [
        {
          "metadata": {
            "sample_id": "test"
          },
          "size": 0,
          "class": "File",
          "path": "/path/to/fasta_in-1.ext",
          "secondaryFiles": []
        },
        {
          "metadata": {
            "sample_id": "test"
          },
          "size": 0,
          "class": "File",
          "path": "/path/to/fasta_in-2.ext",
          "secondaryFiles": []
        }
      ],
      "cutoff": 4,
      "bf_size": "10000"
    },
    "allocatedResources": {
      "cpu": 4,
      "mem": 1000
    }
  },
  "sbg:copyOf": "elehnert/sequence-bloom-tree-reference-apps/bt-count/26"
}
