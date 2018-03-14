#!/bin/bash
scram p -n $1 CMSSW CMSSW_7_6_3_patch2
cd $1/src
eval `scramv1 runtime -sh`
git cms-merge-topic --ssh vallot:cat76x
git clone --reference /cms/scratch/cmssw/mirror/CATTools.git  git@github.com:vallot/CATTools.git
cd CATTools
git submodule init
git submodule update
git checkout -b prod v7-6-6

cd $CMSSW_BASE/src
scram setup lhapdf
scram b -j 20 
cd $SRT_CMSSW_BASE_SCRAMRTDEL/src/CATTools/CatProducer/prod

catGetDatasetInfo v7-6-6
