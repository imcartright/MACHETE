#!/bin/sh

#  alignMkRprtsBowtie.sh
#  This is a script that is called by AlignAndMakeReports.sh
#
#  Created by Gillian Hsieh on 10/6/15.
#

ORIGDIR=${1}
OUTPUTDIR=${2}
NUMBASESAROUNDJUNC=${3}

## Align the previously "unaligned" reads to my Far Junctions index.

# module load sratoolkit/2.4.2
module load python/2.7.9
module load bowtie/2.2.4
# ml load python/2.7.5


UNALIGNEDDIR=${1}unaligned/
FARJUNCDIR=${2}FarJunctionAlignments/
SECONDFARJUNCDIR=${2}FarJuncSecondary/

mkdir -p ${FARJUNCDIR}
mkdir -p ${SECONDFARJUNCDIR}

for file in ${UNALIGNEDDIR}*.fq
do
FILENAME=$(basename "$file" .fq)
echo "creating ${FILENAME}"

# to feed unaligned files into a SecondFarJuncDir --un ${SECONDFARJUNCDIR}still_${FILENAME}.fq tag would be applied

bowtie2 --no-sq --no-unal --score-min L,0,-0.24 --rdg 50,50 --rfg 50,50 --un ${SECONDFARJUNCDIR}still_${FILENAME}.fq -x ${2}BowtieIndex/Index -U ${file} -S ${FARJUNCDIR}${FILENAME}.sam
done;


# This is a python script to compare FJ alignments to genome alignments

mkdir -p ${2}reports/
python /srv/gsfs0/projects/salzman/gillian/createFarJunctionsIndex/FarJuncNaiveReport.py -o ${2} -i ${1} -w ${3}

