#!/bin/bash

ssh-agent 
ssh-add 
source /cvmfs/cms.cern.ch/cmsset_default.sh

for f in $(ls /home/cmsbuilder/cmsbuilder/setup/*.sh)
do
  cd /home/cmsbuilder/cmsbuilder/build
  name=$(basename /home/cmsbuilder/cmsbuilder/setup/*.sh .sh)
  runname=$(readlink -f ${f})
  echo ${name}, ${f}
  ${runname} ${name}
  tar -czvf /cms/scratch/cmssw/${name}.tar.gz ${name}
  rm -rf ${name}
done


