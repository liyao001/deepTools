#!/bin/bash
blah=`mktemp -d`
/home/travis/build/fidelram/deepTools/foo/bin/planemo conda_init --conda_prefix $blah/conda
export PATH=$blah/conda/bin:$PATH
conda create -y --name deeptools_galaxy numpy matplotlib scipy
source activate deeptools_galaxy
conda install -c bioconda samtools
git clone --depth 1 https://github.com/galaxyproject/galaxy.git clone
cd clone
#Add the custom data types
sed -i '4i\    <datatype extension="deeptools_compute_matrix_archive" type="galaxy.datatypes.binary:CompressedArchive" subclass="True" display_in_upload="True"/>' config/datatypes_conf.xml.sample
sed -i '5i\    <datatype extension="deeptools_coverage_matrix" type="galaxy.datatypes.binary:CompressedArchive" subclass="True" display_in_upload="True"/>' config/datatypes_conf.xml.sample
./scripts/common_startup.sh --skip-venv --dev-wheels
cd ..
pip install . 
/home/travis/build/fidelram/deepTools/foo/bin/planemo test --galaxy_root clone --test_data galaxy/wrapper/test-data/ --skip_venv -r galaxy/wrapper 2>&1 | grep -v -e "^galaxy" | grep -v -e "^requests"
test ${PIPESTATUS[0]} -eq 0
