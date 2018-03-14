#!/bin/bash
scram p -n $1 CMSSW CMSSW_8_0_26_patch1
cd $1/src
eval `scramv1 runtime -sh`
git cms-init
git checkout -b cat80x

git-cms-addpkg RecoEgamma/ElectronIdentification
git-cms-addpkg EgammaAnalysis/ElectronTools

git-cms-merge-topic -u jhgoh:PseudoTop-TOPLHCWG2016-from8024p1
git cms-merge-topic -u cms-met:METRecipe_8020 
## from https://twiki.cern.ch/twiki/bin/view/CMSPublic/ReMiniAOD03Feb2017Notes#EGM
git cms-merge-topic -u ikrav:egm_id_80X_v3_photons
git-cms-merge-topic -u rafaellopesdesa:EgammaAnalysis80_EGMSmearer_Moriond17_23Jan
git cms-merge-topic -u Sam-Harper:HEEPV70VID_8010_ReducedCheckout
git cms-merge-topic -u mverzett:DeepFlavour-from-CMSSW_8_0_21

git clone -b egm_id_80X_v1 https://github.com/ikrav/RecoEgamma-ElectronIdentification.git data1 
git clone -b egm_id_80X_v1 https://github.com/ikrav/RecoEgamma-PhotonIdentification.git data2
git clone https://github.com/cms-data/RecoEgamma-ElectronIdentification.git data3

rsync -avz data1/* RecoEgamma/ElectronIdentification/data/
rsync -avz data2/* RecoEgamma/ElectronIdentification/data/
rsync -avz data3/* RecoEgamma/PhotonIdentification/data/

cd EgammaAnalysis/ElectronTools/data
wget https://github.com/cms-egamma/RegressionDatabase/blob/master/SQLiteFiles/GED_80X_Winter2016/ged_regression_20170114.db?raw=true -O ged_regression_20170114.db
cd -

cd EgammaAnalysis/ElectronTools/data/
git clone https://github.com/ECALELFS/ScalesSmearings.git
cd ScalesSmearings/
git checkout Moriond17_23Jan_v1 -b Moriond17_23Jan_v1
cd ../../../..

mkdir RecoBTag/DeepFlavour/data
wget http://home.fnal.gov/~verzetti//DeepFlavour/training/DeepFlavourNoSL.json -O  RecoBTag/DeepFlavour/data/DeepFlavourNoSL.json

rm -rf data1 data2 data3

git clone --reference /cms/scratch/cmssw/mirror/CATTools.git https://github.com/vallot/CATTools
cd CATTools
git checkout -b v8-0-6 v8-0-6
git submodule init
git submodule update
cd ..
scram b -j 20
catGetDatasetInfo v8-0-6

