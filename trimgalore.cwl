{
  "id": "https://cgc-api.sbgenomics.com/v2/apps/ericfg/mach1/trimgalorev2/1/raw/",
  "class": "CommandLineTool",
  "label": "trimgalorev2",
  "description": "Runs v0.4.1. The --gzip and --fastqc switches are always included. The --output_dir argument is hardcoded to \"Trimmed\".",
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
      "id": "#quality",
      "description": "Trim low-quality ends from reads in addition to adapter removal. For RRBS samples, quality trimming will be performed first, and adapter trimming is carried in a second round. Other files are quality and adapter trimmed in a single pass. The algorithm is the same as the one used by BWA (Subtract INT from all qualities; compute partial sums from all indices to the end of the sequence; cut sequence at the index at which the sum is minimal). Default Phred score: 20.",
      "type": [
        "null",
        "int"
      ],
      "inputBinding": {
        "separate": true,
        "valueFrom": {
          "script": "$job.inputs.quality || 20",
          "class": "Expression",
          "engine": "#cwl-js-engine"
        },
        "prefix": "--quality",
        "position": 2,
        "sbg:cmdInclude": true
      },
      "label": "Quality"
    },
    {
      "id": "#phred64",
      "description": "Instructs Cutadapt to use ASCII+64 quality scores as Phred scores (Illumina 1.5 encoding) for quality trimming.",
      "type": [
        "null",
        "boolean"
      ],
      "inputBinding": {
        "separate": true,
        "prefix": "--phred64",
        "position": 3,
        "sbg:cmdInclude": true
      },
      "label": "phred64"
    },
    {
      "id": "#stringency",
      "description": "Overlap with adapter sequence required to trim a sequence. Defaults to a very stringent setting of '1', i.e. even a single bp of overlapping sequence will be trimmed of the 3' end of any read.",
      "type": [
        "null",
        "int"
      ],
      "inputBinding": {
        "separate": true,
        "valueFrom": {
          "script": "$job.inputs.stringency || 1",
          "class": "Expression",
          "engine": "#cwl-js-engine"
        },
        "prefix": "--stringency",
        "position": 4,
        "sbg:cmdInclude": true
      },
      "label": "Stringency"
    },
    {
      "id": "#error_rate",
      "description": "Maximum allowed error rate (no. of errors divided by the length of the matching region) (default: 0.1).",
      "type": [
        "null",
        "float"
      ],
      "inputBinding": {
        "separate": true,
        "valueFrom": {
          "script": "$job.inputs.error_rate || 0.1",
          "class": "Expression",
          "engine": "#cwl-js-engine"
        },
        "prefix": "-e",
        "position": 5,
        "sbg:cmdInclude": true
      },
      "label": "Error Rate"
    },
    {
      "id": "#min_read_length",
      "description": "Discard reads that became shorter than length INT because of either quality or adapter trimming. A value of '0' effectively disables this behaviour. Default: 20 bp.",
      "type": [
        "null",
        "int"
      ],
      "inputBinding": {
        "separate": true,
        "valueFrom": {
          "script": "$job.inputs.min_read_length || 20",
          "class": "Expression",
          "engine": "#cwl-js-engine"
        },
        "prefix": "--length",
        "position": 6,
        "sbg:cmdInclude": true
      },
      "label": "Minimum Read Length"
    },
    {
      "id": "#read1",
      "description": "Path to the forward reads FASTQ file.",
      "type": [
        "File"
      ],
      "inputBinding": {
        "separate": true,
        "position": 7,
        "sbg:cmdInclude": true
      },
      "label": "Forward FASTQ Reads File"
    },
    {
      "id": "#read2",
      "description": "Path to the reverse FASTQ file.",
      "type": [
        "File"
      ],
      "inputBinding": {
        "separate": true,
        "position": 8,
        "sbg:cmdInclude": true
      },
      "label": "Reverse FASTQ Reads File"
    }
  ],
  "outputs": [
    {
      "id": "#trim_reports",
      "type": [
        {
          "items": "File",
          "name": "trim_reports",
          "type": "array"
        }
      ],
      "label": "FASTQC HTML Reports",
      "outputBinding": {
        "glob": "*_trimming_report.txt"
      }
    },
    {
      "id": "#fastqc_reports",
      "type": [
        {
          "items": "File",
          "name": "fastqc_reports",
          "type": "array"
        }
      ],
      "label": "FASTQ Reports",
      "outputBinding": {
        "glob": "*_fastqc.html"
      }
    },
    {
      "id": "#trim_read1",
      "type": [
        "File"
      ],
      "label": "Trimmed Forward Reads",
      "outputBinding": {
        "glob": "*_val_1.fq.gz",
        "sbg:metadata": {
          "file_type": "$self.path.split('.').slice(-1)[0]"
        }
      }
    },
    {
      "id": "#trim_read2",
      "type": [
        "File"
      ],
      "label": "Trimmed Reverse Reads",
      "outputBinding": {
        "sbg:inheritMetadataFrom": "#read2",
        "glob": "*_val_2.fq.gz",
        "sbg:metadata": {
          "file_type": "$self.path.split('.').slice(-1)[0]"
        }
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
      "value": 5000
    },
    {
      "dockerPull": "cgc-images.sbgenomics.com/nathankw/trimgalore:latest",
      "dockerImageId": "",
      "class": "DockerRequirement"
    }
  ],
  "baseCommand": [
    "trim_galore"
  ],
  "stdin": "",
  "stdout": "",
  "successCodes": [],
  "temporaryFailCodes": [],
  "arguments": [
    {
      "valueFrom": "--gzip",
      "separate": false,
      "position": 0
    },
    {
      "valueFrom": "--fastqc",
      "separate": false,
      "position": 0
    },
    {
      "valueFrom": "--paired",
      "separate": false
    }
  ],
  "sbg:sbgMaintained": false,
  "sbg:cmdPreview": "trim_galore --gzip --fastqc --paired  /path/to/read1.ext  /path/to/read2.ext",
  "sbg:validationErrors": [],
  "sbg:revision": 1,
  "sbg:image_url": null,
  "sbg:modifiedBy": "ericfg",
  "sbg:createdOn": 1463764516,
  "sbg:appVersion": [
    "sbg:draft-2"
  ],
  "cwlVersion": "sbg:draft-2",
  "sbg:contributors": [
    "ericfg",
    "nathankw"
  ],
  "sbg:modifiedOn": 1463767261,
  "sbg:latestRevision": 2,
  "sbg:projectName": "mach1",
  "sbg:revisionsInfo": [
    {
      "sbg:revision": 0,
      "sbg:modifiedOn": 1463764516,
      "sbg:modifiedBy": "nathankw",
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 1,
      "sbg:modifiedOn": 1463767261,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 2,
      "sbg:modifiedOn": 1465455716,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": null
    }
  ],
  "sbg:createdBy": "nathankw",
  "sbg:id": "ericfg/mach1/trimgalorev2/1",
  "sbg:project": "ericfg/mach1",
  "sbg:job": {
    "inputs": {
      "stringency": 8,
      "read1": {
        "size": 0,
        "secondaryFiles": [],
        "path": "/path/to/read1.ext",
        "class": "File"
      },
      "read2": {
        "size": 0,
        "secondaryFiles": [],
        "path": "/path/to/read2.ext",
        "class": "File"
      },
      "min_read_length": 5,
      "phred64": true,
      "quality": 2,
      "error_rate": 8.07220902980666
    },
    "allocatedResources": {
      "cpu": 1,
      "mem": 5000
    }
  },
  "sbg:categories": [
    "read-trimming",
    "read-processing",
    "read-preprocessing"
  ]
}
