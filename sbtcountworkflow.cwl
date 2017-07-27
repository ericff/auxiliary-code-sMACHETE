{
  "class": "Workflow",
  "steps": [
    {
      "id": "#SBG_Unpack_FASTQs",
      "run": {
        "sbg:toolkitVersion": "v1.0",
        "sbg:toolAuthor": "Marko Petkovic, Seven Bridges Genomics",
        "temporaryFailCodes": [],
        "class": "CommandLineTool",
        "sbg:modifiedBy": "admin",
        "sbg:modifiedOn": 1471952990,
        "x": 611,
        "sbg:latestRevision": 4,
        "cwlVersion": "sbg:draft-2",
        "sbg:homepage": "https://igor.sbgenomics.com/",
        "label": "SBG Unpack FASTQs",
        "sbg:sbgMaintained": false,
        "sbg:createdBy": "markop",
        "sbg:cmdPreview": "/opt/sbg_unpack_fastqs.py --input_archive_file input_file.tar > out.txt",
        "stdout": "out.txt",
        "sbg:revisionNotes": "Changed paired-end metadata for single end reads.",
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
        "inputs": [
          {
            "required": true,
            "type": [
              "File"
            ],
            "sbg:category": "",
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
        "sbg:revision": 4,
        "y": 564,
        "sbg:license": "Apache License 2.0",
        "sbg:image_url": null,
        "stdin": "",
        "arguments": [],
        "description": "**SBG Unpack FASTQs** performs the extraction of the input archive, containing FASTQ files. \nThis tool also sets the \"paired_end\" metadata field. It assumes that FASTQ file names are formatted in this manner:\nfirst pair reads FASTQ file        -  *1.fastq\nsecond pair reads FASTQ file  -  * 2.fastq. \nwhere * represents any string.\n**This tool is designed to be used for paired-end metadata with above mentioned name formatting only.**\nSupported formats are:\n1. TAR\n2. TAR.GZ (TGZ)\n3. TAR.BZ2 (TBZ2)\n4. GZ\n5. BZ2\n6. ZIP",
        "sbg:revisionsInfo": [
          {
            "sbg:revision": 0,
            "sbg:modifiedOn": 1447782696,
            "sbg:modifiedBy": "markop",
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 1,
            "sbg:modifiedOn": 1448463456,
            "sbg:modifiedBy": "markop",
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 2,
            "sbg:modifiedOn": 1451493832,
            "sbg:modifiedBy": "markop",
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 3,
            "sbg:modifiedOn": 1471952990,
            "sbg:modifiedBy": "admin",
            "sbg:revisionNotes": "Changed description."
          },
          {
            "sbg:revision": 4,
            "sbg:modifiedOn": 1471952990,
            "sbg:modifiedBy": "admin",
            "sbg:revisionNotes": "Changed paired-end metadata for single end reads."
          }
        ],
        "sbg:createdOn": 1447782696,
        "outputs": [
          {
            "type": [
              {
                "items": "File",
                "name": "output_fastq_files",
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
                  "script": "{\n  filepath = $self.path\n  filename = filepath.split(\"/\").pop();\n  if (filename.lastIndexOf(\".fastq\") !== 0)\n  \tp = filename[filename.lastIndexOf(\".fastq\") - 1 ]\n  if ((p == 1) || (p == 2))\n    return p\n  else\n    return \"\"\n}",
                  "class": "Expression",
                  "engine": "#cwl-js-engine"
                }
              }
            }
          }
        ],
        "successCodes": [],
        "sbg:validationErrors": [],
        "sbg:id": "admin/sbg-public-data/sbg-unpack-fastqs-1-0/4",
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
        "appUrl": "/public/apps/#tool/admin/sbg-public-data/sbg-unpack-fastqs-1-0/4",
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
        "id": "admin/sbg-public-data/sbg-unpack-fastqs-1-0/4",
        "sbg:categories": [
          "Other"
        ],
        "sbg:toolkit": "SBGTools",
        "sbg:project": "admin/sbg-public-data",
        "sbg:contributors": [
          "admin",
          "markop"
        ]
      },
      "inputs": [
        {
          "id": "#SBG_Unpack_FASTQs.input_archive_file",
          "source": [
            "#input_archive_file"
          ]
        }
      ],
      "outputs": [
        {
          "id": "#SBG_Unpack_FASTQs.output_fastq_files"
        }
      ],
      "sbg:x": 611,
      "sbg:y": 564,
      "scatter": "#SBG_Unpack_FASTQs.input_archive_file"
    },
    {
      "id": "#bt_count",
      "run": {
        "sbg:modifiedOn": 1473781214,
        "temporaryFailCodes": [],
        "inputs": [
          {
            "sbg:toolDefaultValue": "1",
            "type": [
              "File"
            ],
            "required": true,
            "id": "#hashfile",
            "description": "The location of the hashfile written using the \"hashes\" function",
            "sbg:fileTypes": "HH",
            "label": "hashfile"
          },
          {
            "required": true,
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
          },
          {
            "sbg:toolDefaultValue": "3",
            "type": [
              "null",
              "int"
            ],
            "required": false,
            "id": "#cutoff",
            "description": "The kmer count cutoff",
            "label": "cutoff"
          },
          {
            "sbg:toolDefaultValue": "2000000000",
            "type": [
              "null",
              "string"
            ],
            "required": false,
            "id": "#bf_size",
            "description": "bf_size determines the size of bloom filters used and should be set to an approximate count of the number of unique k-mers in your dataset.",
            "label": "bf_size"
          }
        ],
        "sbg:modifiedBy": "elehnert",
        "x": 904,
        "sbg:latestRevision": 26,
        "cwlVersion": "sbg:draft-2",
        "label": "bt count",
        "appUrl": "/u/elehnert/sequence-bloom-tree-reference-apps/apps/#elehnert/sequence-bloom-tree-reference-apps/bt-count/26",
        "sbg:createdBy": "elehnert",
        "sbg:cmdPreview": "bash runSBT_Count.sh",
        "stdout": "",
        "sbg:sbgMaintained": false,
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
        "sbg:validationErrors": [],
        "baseCommand": [
          "bash",
          "runSBT_Count.sh"
        ],
        "class": "CommandLineTool",
        "sbg:revision": 26,
        "y": 451.6875,
        "sbg:image_url": null,
        "stdin": "",
        "arguments": [],
        "description": "",
        "sbg:revisionsInfo": [
          {
            "sbg:revision": 0,
            "sbg:modifiedOn": 1471798566,
            "sbg:modifiedBy": "elehnert",
            "sbg:revisionNotes": "Copy of elehnert/sequence-bloomtree-cesc/bt-count/2"
          },
          {
            "sbg:revision": 1,
            "sbg:modifiedOn": 1471798973,
            "sbg:modifiedBy": "elehnert",
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 2,
            "sbg:modifiedOn": 1471798986,
            "sbg:modifiedBy": "elehnert",
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 3,
            "sbg:modifiedOn": 1471891377,
            "sbg:modifiedBy": "elehnert",
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 4,
            "sbg:modifiedOn": 1472593170,
            "sbg:modifiedBy": "elehnert",
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 5,
            "sbg:modifiedOn": 1472593664,
            "sbg:modifiedBy": "elehnert",
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 6,
            "sbg:modifiedOn": 1472593802,
            "sbg:modifiedBy": "elehnert",
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 7,
            "sbg:modifiedOn": 1472595684,
            "sbg:modifiedBy": "elehnert",
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 8,
            "sbg:modifiedOn": 1472596318,
            "sbg:modifiedBy": "elehnert",
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 9,
            "sbg:modifiedOn": 1472596378,
            "sbg:modifiedBy": "elehnert",
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 10,
            "sbg:modifiedOn": 1472597035,
            "sbg:modifiedBy": "elehnert",
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 11,
            "sbg:modifiedOn": 1472603024,
            "sbg:modifiedBy": "elehnert",
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 12,
            "sbg:modifiedOn": 1472661597,
            "sbg:modifiedBy": "elehnert",
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 13,
            "sbg:modifiedOn": 1472661619,
            "sbg:modifiedBy": "elehnert",
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 14,
            "sbg:modifiedOn": 1473380340,
            "sbg:modifiedBy": "elehnert",
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 15,
            "sbg:modifiedOn": 1473380360,
            "sbg:modifiedBy": "elehnert",
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 16,
            "sbg:modifiedOn": 1473381027,
            "sbg:modifiedBy": "elehnert",
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 17,
            "sbg:modifiedOn": 1473381457,
            "sbg:modifiedBy": "elehnert",
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 18,
            "sbg:modifiedOn": 1473381531,
            "sbg:modifiedBy": "elehnert",
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 19,
            "sbg:modifiedOn": 1473381576,
            "sbg:modifiedBy": "elehnert",
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 20,
            "sbg:modifiedOn": 1473382187,
            "sbg:modifiedBy": "elehnert",
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 21,
            "sbg:modifiedOn": 1473384204,
            "sbg:modifiedBy": "elehnert",
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 22,
            "sbg:modifiedOn": 1473391687,
            "sbg:modifiedBy": "elehnert",
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 23,
            "sbg:modifiedOn": 1473393564,
            "sbg:modifiedBy": "elehnert",
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 24,
            "sbg:modifiedOn": 1473779253,
            "sbg:modifiedBy": "elehnert",
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 25,
            "sbg:modifiedOn": 1473780173,
            "sbg:modifiedBy": "elehnert",
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 26,
            "sbg:modifiedOn": 1473781214,
            "sbg:modifiedBy": "elehnert",
            "sbg:revisionNotes": null
          }
        ],
        "sbg:createdOn": 1471798566,
        "outputs": [
          {
            "id": "#bit_vector",
            "type": [
              "null",
              "File"
            ],
            "sbg:fileTypes": "BV",
            "outputBinding": {
              "sbg:inheritMetadataFrom": "#fasta_in",
              "glob": "*bf.bv"
            }
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
        "successCodes": [],
        "sbg:id": "elehnert/sequence-bloom-tree-reference-apps/bt-count/26",
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
        "sbg:job": {
          "inputs": {
            "hashfile": {
              "size": 0,
              "class": "File",
              "path": "/path/to/hashfile.ext",
              "secondaryFiles": []
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
        "id": "elehnert/sequence-bloom-tree-reference-apps/bt-count/26",
        "sbg:project": "elehnert/sequence-bloom-tree-reference-apps",
        "sbg:contributors": [
          "elehnert"
        ]
      },
      "inputs": [
        {
          "id": "#bt_count.hashfile",
          "source": [
            "#hashfile"
          ]
        },
        {
          "id": "#bt_count.fasta_in",
          "source": [
            "#SBG_Unpack_FASTQs.output_fastq_files"
          ]
        },
        {
          "id": "#bt_count.cutoff",
          "source": [
            "#cutoff"
          ]
        },
        {
          "id": "#bt_count.bf_size",
          "source": [
            "#bf_size"
          ]
        }
      ],
      "outputs": [
        {
          "id": "#bt_count.bit_vector"
        },
        {
          "id": "#bt_count.bashScript"
        }
      ],
      "hints": [
        {
          "class": "sbg:AWSInstanceType",
          "value": "c4.4xlarge"
        },
        {
          "class": "sbg:CPURequirement",
          "value": 6
        }
      ],
      "sbg:x": 904,
      "sbg:y": 451.6875,
      "scatter": "#bt_count.fasta_in"
    }
  ],
  "requirements": [],
  "inputs": [
    {
      "id": "#hashfile",
      "sbg:y": 307,
      "type": [
        "File"
      ],
      "sbg:x": 236,
      "label": "hashfile",
      "sbg:fileTypes": "HH"
    },
    {
      "sbg:y": 537,
      "type": [
        {
          "items": "File",
          "type": "array"
        }
      ],
      "sbg:x": 262,
      "id": "#input_archive_file",
      "sbg:includeInPorts": true,
      "sbg:fileTypes": "TAR, TAR.GZ, TGZ, TAR.BZ2, TBZ2,  GZ, BZ2, ZIP",
      "label": "input_archive_file"
    },
    {
      "sbg:toolDefaultValue": "3",
      "type": [
        "null",
        "int"
      ],
      "required": false,
      "id": "#cutoff",
      "description": "The kmer count cutoff",
      "label": "cutoff",
      "sbg:includeInPorts": false
    },
    {
      "sbg:toolDefaultValue": "2000000000",
      "type": [
        "null",
        "string"
      ],
      "required": false,
      "id": "#bf_size",
      "description": "bf_size determines the size of bloom filters used and should be set to an approximate count of the number of unique k-mers in your dataset.",
      "label": "bf_size",
      "sbg:includeInPorts": false
    }
  ],
  "outputs": [
    {
      "required": false,
      "type": [
        "null",
        "File"
      ],
      "id": "#bit_vector",
      "sbg:includeInPorts": true,
      "sbg:y": 432,
      "label": "bit_vector",
      "sbg:x": 1544,
      "sbg:fileTypes": "BV",
      "source": [
        "#bt_count.bit_vector"
      ]
    }
  ],
  "sbg:modifiedOn": 1479590650,
  "sbg:modifiedBy": "ericfg",
  "sbg:latestRevision": 0,
  "sbg:canvas_zoom": 1,
  "sbg:sbgMaintained": false,
  "sbg:revisionNotes": "Copy of ericfg/bloomtree-gbm/TCGA-Archive-SBT-count-2/4",
  "sbg:canvas_y": -191,
  "sbg:canvas_x": -123,
  "sbg:revision": 0,
  "sbg:validationErrors": [],
  "sbg:image_url": "https://cgc-brood.sbgenomics.com/static/ericfg/bloomtreemany/TCGA-Archive-SBT-count-2/0.png",
  "sbg:projectName": "bloomtreemany",
  "sbg:revisionsInfo": [
    {
      "sbg:revision": 0,
      "sbg:modifiedOn": 1479590650,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": "Copy of ericfg/bloomtree-gbm/TCGA-Archive-SBT-count-2/4"
    }
  ],
  "sbg:createdOn": 1479590650,
  "sbg:id": "ericfg/bloomtreemany/TCGA-Archive-SBT-count-2/0",
  "sbg:project": "ericfg/bloomtreemany",
  "sbg:appVersion": [
    "sbg:draft-2"
  ],
  "sbg:copyOf": "ericfg/bloomtree-gbm/TCGA-Archive-SBT-count-2/4",
  "sbg:contributors": [
    "ericfg"
  ],
  "sbg:createdBy": "ericfg",
  "id": "ericfg/bloomtreemany/TCGA-Archive-SBT-count-2/0",
  "label": "SBT count - TCGA Archive",
  "description": "",
  "hints": [
    {
      "class": "sbg:maxNumberOfParallelInstances",
      "value": "1"
    },
    {
      "class": "sbg:UseSbgFS",
      "value": "true"
    }
  ]
}
