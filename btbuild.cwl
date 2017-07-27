{
  "id": "https://cgc-api.sbgenomics.com/v2/apps/ericfg/bloomtreemany/bt-build/0/raw/",
  "class": "CommandLineTool",
  "label": "bt build",
  "description": "",
  "requirements": [
    {
      "class": "CreateFileRequirement",
      "fileDef": [
        {
          "filename": "filterListFile.txt",
          "fileContent": {
            "script": "{\n  var list = [].concat($job.inputs.bf_inputs);\n  var listLength = list.length;\n  hold = \"\";\n  \n  for (var i = 0; i < listLength; i++) {\n    temp = list[i].path\n    temp2 = temp.split(\"/\")\n    temp3 = temp2[temp2.length-1]\n    hold = hold + \"/srv/\" + temp3 + \"\\n\"\n  }\n  return hold\n  }\n\n",
            "class": "Expression",
            "engine": "#cwl-js-engine"
          }
        },
        {
          "filename": "prepareDirectory.sh",
          "fileContent": {
            "script": "{\n\thashInput = $job.inputs.hashfile.path\n\ttmp = hashInput.split(\"/\")\n    tmp.pop()\n    inputDir = tmp.join(\"/\")\n\treturn \"cp filterListFile.txt /srv/;\\nfor f in `ls \" + inputDir + \"/*.bv` ; do\\n  mv $f /srv/;\\ndone\\nmv \" + $job.inputs.hashfile.path + \" /srv/\"\n}",
            "class": "Expression",
            "engine": "#cwl-js-engine"
          }
        }
      ]
    },
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
      "type": [
        "null",
        {
          "items": "File",
          "name": "bf_inputs",
          "type": "array"
        }
      ],
      "sbg:stageInput": "link",
      "id": "#bf_inputs",
      "description": "Bloom filters to be used to build tree.",
      "sbg:fileTypes": "BV",
      "label": "Bloomfilters"
    },
    {
      "type": [
        "null",
        "File"
      ],
      "id": "#hashfile",
      "description": "Hashfile used to build bloomfilters",
      "sbg:fileTypes": "HH",
      "inputBinding": {
        "valueFrom": {
          "script": "{\n  temp = $job.inputs.hashfile.path\n  temp2 = temp.split(\"/\")\n  temp3 = temp2[temp2.length-1]\n  return temp3\n}\n \n  ",
          "class": "Expression",
          "engine": "#cwl-js-engine"
        },
        "separate": false,
        "position": 2,
        "sbg:cmdInclude": true
      },
      "label": "hashfile"
    },
    {
      "id": "#sim_type",
      "description": "sim-type is an option that defines the similarity metric used. (0) uses the default Hamming distance between two bit vectors while (1) uses a Jaccard index metric.",
      "type": [
        "null",
        {
          "symbols": [
            "0",
            "1"
          ],
          "name": "sim_type",
          "type": "enum"
        }
      ],
      "inputBinding": {
        "separate": true,
        "prefix": "--sim-type",
        "position": 1,
        "sbg:cmdInclude": true
      },
      "label": "sim-type"
    },
    {
      "id": "#output_prefix",
      "description": "The location of the SBT structure file being written.",
      "type": [
        "null",
        "string"
      ],
      "label": "Bloomtree output file prefix"
    }
  ],
  "outputs": [
    {
      "id": "#srv_tar",
      "type": [
        "null",
        "File"
      ],
      "outputBinding": {
        "glob": "*tar"
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
    },
    {
      "class": "sbg:AWSInstanceType",
      "value": "m1.xlarge"
    }
  ],
  "baseCommand": [
    {
      "script": "\"bash ./prepareDirectory.sh && cwd=$(pwd) && cd /srv && bt build\"",
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
      "valueFrom": "filterListFile.txt",
      "separate": false,
      "position": 3
    },
    {
      "valueFrom": {
        "script": "\"&& tar -cvf \\\"$cwd/\" + $job.inputs.output_prefix + \".tar\\\" /srv\"",
        "class": "Expression",
        "engine": "#cwl-js-engine"
      },
      "separate": false,
      "position": 10
    },
    {
      "valueFrom": "mySBT.bloomtree",
      "separate": false,
      "position": 4
    }
  ],
  "sbg:sbgMaintained": false,
  "sbg:cmdPreview": "bash ./prepareDirectory.sh && cwd=$(pwd) && cd /srv && bt build filterListFile.txt mySBT.bloomtree && tar -cvf \"$cwd/mySBT.tar\" /srv",
  "sbg:revisionNotes": "Copy of elehnert/sequence-bloom-tree-reference-apps/bt-build/8",
  "sbg:validationErrors": [],
  "sbg:revision": 0,
  "sbg:image_url": null,
  "sbg:modifiedBy": "ericfg",
  "sbg:createdOn": 1479626885,
  "sbg:appVersion": [
    "sbg:draft-2"
  ],
  "cwlVersion": "sbg:draft-2",
  "sbg:contributors": [
    "ericfg"
  ],
  "sbg:modifiedOn": 1479626885,
  "sbg:latestRevision": 0,
  "sbg:projectName": "bloomtreemany",
  "sbg:revisionsInfo": [
    {
      "sbg:revision": 0,
      "sbg:modifiedOn": 1479626885,
      "sbg:modifiedBy": "ericfg",
      "sbg:revisionNotes": "Copy of elehnert/sequence-bloom-tree-reference-apps/bt-build/8"
    }
  ],
  "sbg:createdBy": "ericfg",
  "sbg:id": "ericfg/bloomtreemany/bt-build/0",
  "sbg:project": "ericfg/bloomtreemany",
  "sbg:job": {
    "inputs": {
      "sim_type": "0",
      "hashfile": {
        "size": 0,
        "class": "File",
        "path": "/path/to/hashfile.ext",
        "secondaryFiles": []
      },
      "output_prefix": "mySBT",
      "bf_inputs": [
        {
          "size": 0,
          "class": "File",
          "path": "/path/to/SEQUENCE_INPUTS-1.ext",
          "secondaryFiles": []
        },
        {
          "size": 0,
          "class": "File",
          "path": "/path/to/SEQUENCE_INPUTS-2.ext",
          "secondaryFiles": []
        }
      ]
    },
    "allocatedResources": {
      "cpu": 1,
      "mem": 1000
    }
  },
  "sbg:copyOf": "elehnert/sequence-bloom-tree-reference-apps/bt-build/8"
}
