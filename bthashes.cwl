{
  "class": "CommandLineTool",
  "sbg:toolkitVersion": "0.3.5",
  "sbg:validationErrors": [],
  "sbg:id": "elehnert/sequence-bloom-tree-reference-apps/bt-hashes/2",
  "stdin": "",
  "successCodes": [],
  "sbg:createdOn": 1471798560,
  "temporaryFailCodes": [],
  "requirements": [
    {
      "class": "ExpressionEngineRequirement",
      "requirements": [
        {
          "class": "DockerRequirement",
          "dockerPull": "rabix/js-engine"
        }
      ],
      "id": "#cwl-js-engine"
    }
  ],
  "label": "bt hashes",
  "sbg:modifiedBy": "elehnert",
  "sbg:toolAuthor": "Kingsford Lab",
  "sbg:projectName": "Sequence Bloom Tree Dev Apps",
  "sbg:license": "GNU General Public License v3.0 only",
  "arguments": [
    {
      "separate": false,
      "valueFrom": "hashfile.hh",
      "position": 900
    }
  ],
  "sbg:toolkit": "Sequence Bloom Tree",
  "sbg:latestRevision": 2,
  "id": "https://cgc-api.sbgenomics.com/v2/apps/elehnert/sequence-bloom-tree-reference-apps/bt-hashes/2/raw/",
  "sbg:modifiedOn": 1494525729,
  "sbg:appVersion": [
    "sbg:draft-2"
  ],
  "sbg:revisionsInfo": [
    {
      "sbg:revision": 0,
      "sbg:revisionNotes": "Copy of elehnert/sequence-bloomtree-cesc/bt-hashes/0",
      "sbg:modifiedBy": "elehnert",
      "sbg:modifiedOn": 1471798560
    },
    {
      "sbg:revision": 1,
      "sbg:revisionNotes": null,
      "sbg:modifiedBy": "elehnert",
      "sbg:modifiedOn": 1493657059
    },
    {
      "sbg:revision": 2,
      "sbg:revisionNotes": null,
      "sbg:modifiedBy": "elehnert",
      "sbg:modifiedOn": 1494525729
    }
  ],
  "inputs": [
    {
      "type": [
        "null",
        "int"
      ],
      "label": "k-mer",
      "inputBinding": {
        "separate": true,
        "sbg:cmdInclude": true,
        "valueFrom": {
          "class": "Expression",
          "script": "{if ($job.inputs.kmer) {\n  return $job.inputs.kmer\n  }\n else {\n   return 20\n }\n}",
          "engine": "#cwl-js-engine"
        },
        "prefix": "-k"
      },
      "description": "The k-mer size.",
      "sbg:toolDefaultValue": "20",
      "id": "#kmer"
    },
    {
      "type": [
        "null",
        "int"
      ],
      "label": "nb_hashes",
      "inputBinding": {
        "separate": false,
        "valueFrom": {
          "class": "Expression",
          "script": "{if ($job.inputs.nb_hashes) {\n  return $job.inputs.nb_hashes\n  }\n else {\n   return 1\n }\n}",
          "engine": "#cwl-js-engine"
        },
        "position": 10000,
        "sbg:cmdInclude": true
      },
      "description": "Number of hash functions to use",
      "sbg:toolDefaultValue": "1",
      "id": "#nb_hashes"
    }
  ],
  "sbg:job": {
    "inputs": {
      "nb_hashes": 9,
      "kmer": 4
    },
    "allocatedResources": {
      "cpu": 1,
      "mem": 1000
    }
  },
  "description": "",
  "sbg:links": [
    {
      "label": "Tool GitHub",
      "id": "https://github.com/Kingsford-Group/bloomtree"
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
      "class": "DockerRequirement",
      "dockerImageId": "",
      "dockerPull": "cgc-images.sbgenomics.com/elehnert/sbt:0.3.5"
    }
  ],
  "sbg:cmdPreview": "bt hashes hashfile.hh",
  "sbg:project": "elehnert/sequence-bloom-tree-reference-apps",
  "sbg:revision": 2,
  "cwlVersion": "sbg:draft-2",
  "sbg:contributors": [
    "elehnert"
  ],
  "stdout": "",
  "baseCommand": [
    "bt",
    "hashes"
  ],
  "outputs": [
    {
      "outputBinding": {
        "glob": "hashfile.hh"
      },
      "type": [
        "null",
        "File"
      ],
      "id": "#hashfile"
    }
  ],
  "sbg:image_url": null,
  "sbg:sbgMaintained": false,
  "sbg:createdBy": "elehnert"
}
