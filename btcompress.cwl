{
  "id": "https://cgc-api.sbgenomics.com/v2/apps/ericfg/bloomtree-gbm/bt-compress/0/raw/",
  "class": "CommandLineTool",
  "label": "bt compress",
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
      "id": "#srv_tar",
      "type": [
        "null",
        "File"
      ]
    }
  ],
  "outputs": [
    {
      "id": "#srv_tar_out",
      "type": [
        "null",
        "File"
      ],
      "outputBinding": {
        "glob": "*.tar"
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
    "tar",
    "-xvf",
    {
      "script": "$job.inputs.srv_tar.path",
      "class": "Expression",
      "engine": "#cwl-js-engine"
    },
    "&&",
    "cwd=$(pwd)",
    "&&",
    "mv",
    "srv/*",
    "/srv/",
    "&&",
    "cd",
    "/srv",
    "&&",
    "bt",
    "compress",
    "mySBT.bloomtree",
    "mySBT.compressed.bloomtree"
  ],
  "stdin": "",
  "stdout": "",
  "successCodes": [],
  "temporaryFailCodes": [],
  "arguments": [
    {
      "valueFrom": {
        "script": "{\n  basename = $job.inputs.srv_tar.path.split(\"/\").pop()\n  return \"&& rm *.bv && tar -cvf \\\"$cwd/\" + basename + \"\\\" /srv\" \n}\n\n",
        "class": "Expression",
        "engine": "#cwl-js-engine"
      },
      "separate": false,
      "position": 10
    }
  ],
  "sbg:sbgMaintained": false,
  "sbg:cmdPreview": "tar -xvf /path/to/srv_tar.ext && cwd=$(pwd) && mv srv/* /srv/ && cd /srv && bt compress mySBT.bloomtree mySBT.compressed.bloomtree && rm *.bv && tar -cvf \"$cwd/srv_tar.ext\" /srv",
  "sbg:revisionNotes": "Copy of elehnert/sequence-bloom-tree-reference-apps/bt-compress/8",
  "sbg:validationErrors": [],
  "sbg:revision": 0,
  "sbg:image_url": null,
  "sbg:modifiedBy": "elehnert",
  "sbg:createdOn": 1473790337,
  "sbg:appVersion": [
    "sbg:draft-2"
  ],
  "cwlVersion": "sbg:draft-2",
  "sbg:contributors": [
    "elehnert"
  ],
  "sbg:updateModifiedBy": "elehnert",
  "sbg:modifiedOn": 1473790337,
  "sbg:latestRevision": 0,
  "sbg:updateRevisionNotes": null,
  "sbg:projectName": "Bloomtree GBM",
  "sbg:update": "elehnert/sequence-bloom-tree-reference-apps/bt-compress/10",
  "sbg:revisionsInfo": [
    {
      "sbg:revision": 0,
      "sbg:modifiedOn": 1473790337,
      "sbg:modifiedBy": "elehnert",
      "sbg:revisionNotes": "Copy of elehnert/sequence-bloom-tree-reference-apps/bt-compress/8"
    }
  ],
  "sbg:createdBy": "elehnert",
  "sbg:id": "ericfg/bloomtree-gbm/bt-compress/0",
  "sbg:project": "ericfg/bloomtree-gbm",
  "sbg:job": {
    "inputs": {
      "srv_tar": {
        "size": 0,
        "secondaryFiles": [],
        "path": "/path/to/srv_tar.ext",
        "class": "File"
      }
    },
    "allocatedResources": {
      "cpu": 1,
      "mem": 1000
    }
  },
  "sbg:copyOf": "elehnert/sequence-bloom-tree-reference-apps/bt-compress/8"
}
