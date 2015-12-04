#!/bin/sh
# updated on 3/25/2011 to read betas for each subject, for multiple copes and masks, as a percent signal change 
# then reads the report and adds them to a master sheet
# Sook-Lei Liew, ######sliew(at)usc(dot)edu######


cd ~						#SET VARIABLE LISTS for SUBJ and MASKS
ROOTDIR=/fmri_data/DD2		#root directory
cd $ROOTDIR
SUBJS=`ls -d subj*`		#Collects all subjects in main folder

MASKPATH=/fMRI_data/DD2/Analyses_Group16subjs/4_MNS_Localizer/ROIs/15SUBJS/Final 	#Set mask pathway
cd $MASKPATH
MASKS=`ls *.nii.gz`	#Collects all masks in folder Final

for M in $MASKS; do
	echo Now on ROI $M
	for SUBJ in $SUBJS; do
#	for SUBJ in subj02; do		#FOR DEBUGGING ONLY
		echo Now on $SUBJ
		for RUN in runs12 runs34 runs1234; do
			echo Now on $RUN
			for COPE in cope1 cope2 cope9 cope10; do
				echo Now on $COPE
				WD=$ROOTDIR/$SUBJ/bold/$RUN.gfeat/$COPE.feat/featquery_$M		#Define the working directory WD			
				cd $WD				
				pwd
				#/Applications/fsl/bin/featquery 1 $WD 1  stats/pe1 featquery_$M -p -s $MASKPATH/$M
				FILE1=$MASKPATH/$M-$RUN-$COPE-ALL.txt
				FILE2=$MASKPATH/$M-$RUN-$COPE-MEANS.txt				
 				touch $FILE1 $FILE2		#create above-named file
 				echo $SUBJ >> $FILE1
 				cat $WD/report.txt | grep stats/pe1 | awk '{print}' >> $FILE1
 				cat $WD/report.txt | grep stats/pe1 | awk '{print $7}' >> $FILE2
			done
		done
	done
done