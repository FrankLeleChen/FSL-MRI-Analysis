#!/bin/sh
# Sook-Lei Liew, ###sliew(at)usc(dot)edu###, 3/10/2011

cd ~
ROOTDIR=/fMRI_data/DD3			#change for your root directory
cd $ROOTDIR
pwd
for SUBJ in subj01 subj02; do		#can substitute: in `ls -ad subj*` : for all subjs
	a=`echo $SUBJ`
	echo $SUBJ 
	cd ~
	cd $ROOTDIR/$a/bold
	pwd
	for run in `ls -ad *.feat`; do		#picks all runs in feat
		b=`echo $run`	
		cd ~
		cd $ROOTDIR/$a/bold/$b/stats
		pwd
		ZSTATS=`ls zstat*`
		for STAT in $ZSTATS;  do  #change based on # of zstats in run
			c=`echo $STAT`
			d=ST
			e=.nii.gz
			cd ~
			
			#Make sure the following fits your file structure!
			
			/Applications/fsl/bin/flirt -in /fMRI_data/DD3/$a/bold/$b/stats/$c$e -applyxfm -init /fMRI_data/DD3/$a/bold/$b/reg/example_func2standard.mat -out /fMRI_data/DD3/$a/bold/$b/stats/$c$d$e -paddingsize 0.0 -interp trilinear -ref /fMRI_data/DD3/$a/bold/$b/reg/standard.nii.gz	
			echo /fMRI_data/DD3/$a/bold/$b/stats/$c
			echo DONE 
		done
	done
done
		
