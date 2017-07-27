## Following Amir Ziai from
## https://medium.com/@amirziai/flattening-json-objects-in-python-f5343c794b10

## for use with get.tcga.metadata.R

import csv, json, argparse, os, pandas
from pandas.io.json import json_normalize

parser = argparse.ArgumentParser()

parser.add_argument("--caseid", help="case id string to form json file")
parser.add_argument("--sampleid", help="sample uuid for choosing sample if needed")
parser.add_argument("--datadir", help="data directory for json file")
args = parser.parse_args()

caseid = args.caseid
datadir = args.datadir
sampleid = args.sampleid
jsonfile = os.path.join(datadir, "jsoninfo.caseid." + caseid + ".json")
outfile = os.path.join(datadir, "csvinfo.caseid." + caseid + ".csv")


f = open(jsonfile)
thisdata = json.load(f)
f.close()

del thisdata['data']['submitter_analyte_ids']
del thisdata['data']['analyte_ids']
del thisdata['data']['sample_ids']
del thisdata['data']['portion_ids']
del thisdata['data']['submitter_portion_ids']
del thisdata['data']['slide_ids']
del thisdata['data']['submitter_sample_ids']
del thisdata['data']['submitter_aliquot_ids']
del thisdata['data']['aliquot_ids']
del thisdata['data']['submitter_slide_ids']


# get the right sample and remove others if needed
sampledict = thisdata['data']['samples']
nsamples = len(sampledict)
savethese = []
if nsamples >1:
    for ii in range(nsamples):
        if sampledict[ii]['sample_id']==sampleid:
            savethese.append(ii)

assert(len(savethese)==1)            
thisdata['data']['samples'] = thisdata['data']['samples'][savethese[0]]

            
def flatten_json(y):
    out = {}
    def flatten(x, name=''):
        if type(x) is dict:
            for a in x:
                flatten(x[a], name + a + '.')
        elif type(x) is list:
            i = 0
            for a in x:
                flatten(a, name + str(i) + '.')
                i += 1
        else:
            out[name[:-1]] = x
    flatten(y)
    return out

z = flatten_json(thisdata)

df = json_normalize(z)

df.to_csv(outfile)

