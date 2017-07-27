{
  "id": "https://cgc-api.sbgenomics.com/v2/apps/ericfg/bloomtree-gbm/bt-query/1/raw/",
  "class": "CommandLineTool",
  "label": "bt query",
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
    }
  ],
  "inputs": [
    {
      "sbg:toolDefaultValue": "0.8",
      "type": [
        "null",
        "float"
      ],
      "id": "#threshold",
      "description": "A float between 0 and 1 that defines the proportion of query k-mers that must be present in any bloom filter to define a \"hit.\"",
      "inputBinding": {
        "separate": true,
        "valueFrom": {
          "script": "{ if (filepath = $job.inputs.threshold) {\n  return $job.inputs.threshold\n}\n else {\n   return 0.8\n }\n}",
          "class": "Expression",
          "engine": "#cwl-js-engine"
        },
        "prefix": "-t",
        "sbg:cmdInclude": true
      },
      "label": "threshold"
    },
    {
      "sbg:toolDefaultValue": "1",
      "type": [
        "null",
        "int"
      ],
      "id": "#max_filters",
      "description": "Defines the total number of filters that can be loaded at one time into memory.",
      "inputBinding": {
        "separate": true,
        "valueFrom": {
          "script": "{if ($job.inputs.max_filters) {\n  return $job.inputs.max_filters\n}\n else {\n   return 1\n }\n}\n   ",
          "class": "Expression",
          "engine": "#cwl-js-engine"
        },
        "prefix": "--max-filters",
        "sbg:cmdInclude": true
      },
      "label": "max_filters"
    },
    {
      "sbg:toolDefaultValue": "0",
      "type": [
        "null",
        {
          "symbols": [
            "0",
            "1"
          ],
          "name": "leaf_only",
          "type": "enum"
        }
      ],
      "id": "#leaf_only",
      "description": "(0) is the default and searches the entire SBT, whereas (1) ignores the tree structure and only searches leaf nodes.",
      "inputBinding": {
        "separate": true,
        "valueFrom": {
          "script": "{if ($job.inputs.leaf_only) {\n  return $job.inputs.leaf_only\n}\n else {\n   return 0\n }\n}",
          "class": "Expression",
          "engine": "#cwl-js-engine"
        },
        "prefix": "--leaf-only",
        "sbg:cmdInclude": true
      },
      "label": "leaf-only"
    },
    {
      "id": "#query_file",
      "type": [
        "File"
      ],
      "inputBinding": {
        "separate": false,
        "position": 2,
        "sbg:cmdInclude": true
      }
    },
    {
      "id": "#srv_input",
      "type": [
        "null",
        "File"
      ],
      "sbg:stageInput": null
    }
  ],
  "outputs": [
    {
      "id": "#output",
      "type": [
        "null",
        "File"
      ],
      "label": "Bloomtree output",
      "outputBinding": {
        "glob": "*versus*.txt"
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
      "dockerPull": "cgc-images.sbgenomics.com/elehnert/sbt:0.3.5",
      "dockerImageId": "",
      "class": "DockerRequirement"
    }
  ],
  "baseCommand": [
    {
      "script": "{\n  return \"tar -xvf \" + $job.inputs.srv_input.path + \" && mv srv/* /srv/ && cwd=$(pwd) && cd /srv && bt query\"\n}",
      "class": "Expression",
      "engine": "#cwl-js-engine"
    }
  ],
  "stdin": "",
  "stdout": "",
  "successCodes": [],
  "temporaryFailCodes": [],
  "arguments": [
    {
      "valueFrom": {
        "script": "\"\\\"$cwd/\" + $job.inputs.query_file.path.split(\"/\").pop().split(\".\")[0] + \"_versus_\" + $job.inputs.srv_input.path.split(\"/\").pop().split(\".\")[0] +\".txt\\\"\"",
        "class": "Expression",
        "engine": "#cwl-js-engine"
      },
      "separate": false,
      "position": 100
    },
    {
      "valueFrom": "mySBT.compressed.bloomtree",
      "separate": false,
      "position": 1
    }
  ],
  "sbg:sbgMaintained": false,
  "sbg:cmdPreview": "tar -xvf /path/to/test.tar && mv srv/* /srv/ && cwd=$(pwd) && cd /srv && bt query mySBT.compressed.bloomtree query.txt \"$cwd/query_versus_test.txt\"",
  "sbg:revisionNotes": "Copy of elehnert/sequence-bloom-tree-reference-apps/bt-query/4",
  "sbg:validationErrors": [],
  "sbg:revision": 1,
  "sbg:image_url": null,
  "sbg:modifiedBy": "ericfg",
  "sbg:createdOn": 1473790358,
  "sbg:appVersion": [
    "sbg:draft-2"
  ],
  "cwlVersion": "sbg:draft-2",
  "sbg:contributors": [
    "elehnert",
    "ericfg"
  ],
  "sbg:modifiedOn": 1477427308,
  "sbg:latestRevision": 1,
  "sbg:projectName": "Bloomtree GBM",
  "sbg:revisionsInfo": [
    {
      "sbg:revision": 0,
      "sbg:modifiedOn": 1473790358,
      "sbg:modifiedBy": "elehnert",
      "sbg:revisionNotes": "Copy of elehnert/sequence-bloom-tree-reference-apps/bt-query/0"
    },
    {
      "sbg:revision": 1,
      "sbg:modifiedOn": 1477427308,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": "Copy of elehnert/sequence-bloom-tree-reference-apps/bt-query/4"
    }
  ],
  "sbg:createdBy": "elehnert",
  "sbg:id": "ericfg/bloomtree-gbm/bt-query/1",
  "sbg:project": "ericfg/bloomtree-gbm",
  "sbg:job": {
    "inputs": {
      "srv_input": {
        "size": 0,
        "secondaryFiles": [],
        "path": "/path/to/test.tar",
        "class": "File"
      },
      "max_filters": 5,
      "threshold": 0.5,
      "query_file": {
        "size": 0,
        "secondaryFiles": [],
        "path": "query.txt",
        "class": "File"
      },
      "leaf_only": "0"
    },
    "allocatedResources": {
      "cpu": 1,
      "mem": 1000
    }
  },
  "sbg:copyOf": "elehnert/sequence-bloom-tree-reference-apps/bt-query/4"
}
