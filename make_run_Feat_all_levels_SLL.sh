#!/bin/sh
# Sook-Lei Liew, ####sliew(at)usc(dot)edu#####, made 3/24/2011, updated 7/26/2011
# Uses templates (e.g. from 'visual_creativity/subj02' for 1st and 2nd levels (discarded subj01))
# And a template for cope1 for 3rd level
# Prior to running this: run DCM2nii, place .nii.gzs into appropriate BOLD folders, mkdirs if needed, complete BET, have files for condition onsets
# This script contains modules for each step so that you can manually check data after each step.
# You should comment out the steps NOT being used on each step!! And manually check all outputs! :)
# Steps are: 1) Prestats with MELODIC ICA Data exploration (followed by you manually denoising the data)
#            2) Stats+Poststats+Registration
#			 3) Second level analysis
# 			 4) Third level analyses for as many copes as your heart desires!

cd ~
ROOTDIR=/fMRI_data/visual_creativity		#root directory
cd $ROOTDIR
pwd
SUBJS=`ls -d subj*`		#Collects all subjects in main folder

###############################################################################

# IF you don't wish to do MELOIDIC denoising, you can just start at MODULE 2, assuming a full feat template file.

#################### MODULE 1 #################################################

for SUBJ in $SUBJS; do    #set all subjs to run	
	echo Now making $SUBJ

######SETTING UP FEAT PRESTATS#######

#Just set up the Pre-Stats to run first

RUNS=`ls -d run0*`		#Collects all runs - use this if desired instead of entering the # of runs below 

	for RUNNUM in run01 run02 run03 run04; do	#Set your # of runs! This design is for runs 01-04; can also do in $RUNS
		echo Now processing $RUNNUM

#This part is tailored for the DNI Scanner ouput + my file naming conventions; tailor for yours!

		if [ "$RUNNUM" = run01 ] ; then sed "s/subj02/$SUBJ/g;s/run01/$RUNNUM/g" ./subj02/bold/run01.fsf > ./$SUBJ/bold/$RUNNUM.fsf
		elif [ "$RUNNUM" = run02 ] ; then sed "s/subj02/$SUBJ/g;s/run01/$RUNNUM/g;s/run1/run1A/g" ./subj02/bold/run01.fsf > ./$SUBJ/bold/$RUNNUM.fsf
		elif [ "$RUNNUM" = run03 ] ; then sed "s/subj02/$SUBJ/g;s/run01/$RUNNUM/g;s/run1/run1B/g" ./subj02/bold/run01.fsf > ./$SUBJ/bold/$RUNNUM.fsf
		elif [ "$RUNNUM" = run04 ] ; then sed "s/subj02/$SUBJ/g;s/run01/$RUNNUM/g;s/run1/run1C/g" ./subj02/bold/run01.fsf > ./$SUBJ/bold/$RUNNUM.fsf
		else echo PROBLEM! in $SUBJ and $RUNNUM
		fi		
	done


####RUNNING FEAT PRESTATS#######
# 	
	echo Now running feat on $SUBJ
	cd $ROOTDIR/$SUBJ/bold
	pwd
	
	for RUN in run01 run02 run03 run04; do		#Set your # of runs!
		echo Now processing feat $RUN
		feat $RUN.fsf
	done
	
done

###############################################################################

# Check each MELODIC report
# Note noise components, then denoise data using:
# fsl_regfilt -i denoise -d ./denoise.ica/melodic_mix -o denoise_ICAfiltered -f "a,b,c,d,e,f,..."
# which yields output of denoise_ICAfiltered.nii.gz
# which should be inputted into the rest of the model below.
# IF you don't wish to do MELOIDIC denoising, you can just start here, assuming a full feat template file.

#################### MODULE 2 #################################################

for SUBJ in $SUBJS; do    #set all subjs to run	
	echo Now on $SUBJ

######SETTING UP FEAT STATS+POSTSTATS+REG#######

#
	for RUNNUM in run01 run02 run03 run04; do	#design for runs 01-04
		echo Now processing $RUNNUM
		
		if [ "$RUNNUM" = run01 ] ; then sed "s/subj02/$SUBJ/g;s/run01/$RUNNUM/g" ./subj02/bold/run01.fsf > ./$SUBJ/bold/$RUNNUM.fsf
		elif [ "$RUNNUM" = run02 ] ; then sed "s/subj02/$SUBJ/g;s/run01/$RUNNUM/g;s/run1/run1A/g" ./subj02/bold/run01.fsf > ./$SUBJ/bold/$RUNNUM.fsf
		elif [ "$RUNNUM" = run03 ] ; then sed "s/subj02/$SUBJ/g;s/run01/$RUNNUM/g;s/run1/run1B/g" ./subj02/bold/run01.fsf > ./$SUBJ/bold/$RUNNUM.fsf
		elif [ "$RUNNUM" = run04 ] ; then sed "s/subj02/$SUBJ/g;s/run01/$RUNNUM/g;s/run1/run1C/g" ./subj02/bold/run01.fsf > ./$SUBJ/bold/$RUNNUM.fsf
		else echo PROBLEM! in $SUBJ and $RUNNUM
		fi		
	done


####RUNNING FEAT STATS+POSTSTATS+REG#######
# 	
	echo Now running feat on $SUBJ
	cd $ROOTDIR/$SUBJ/bold
	pwd
	
	for RUN in run01 run02 run03 run04; do		
		echo Now processing feat $RUN
		feat $RUN.fsf
	done
done


###############################################################################

# Check each subject's output for individual runs!
# Then run second level with all runs per subj together

#################### MODULE 3 #################################################

for SUBJ in $SUBJS; do    #set all subjs to run	
	echo Now on $SUBJ

######SETTING UP SECOND LEVEL#######

	for BOLD in bold1234; do		#may need to make this directory in subjects if not already there
		cd $ROOTDIR
		echo Now making design $BOLD
		sed "s/subj02/$SUBJ/g" ./subj02/$BOLD.fsf > ./$SUBJ/$BOLD.fsf
	done

######RUNNING SECOND LEVEL#######		
	for BOLDRUN in bold1234; do
		cd $ROOTDIR/$SUBJ
		pwd
		echo Now processing feat $BOLDRUN
		feat $BOLDRUN.fsf
	done

	echo Finished processing $SUBJ
done

###############################################################################

# Check each subjects' bold1234
# Then run third level with all subjs per cope

#################### MODULE 4 #################################################

######SETTING UP THIRD LEVEL#######
#Remember, it assumes a template from cope1

for COPE in cope2 cope3 cope4 cope5 cope6 cope7 cope8 cope9 cope10; do    #set all copes to run	
	echo Now on $COPE
	cd $ROOTDIR
	sed "s/cope1/$COPE/g" ./3_Third_Level_EqDur/cope1.fsf > ./3_Third_Level_EqDur/$COPE.fsf
done

######RUNNING THIRD LEVEL#######		
cd $ROOTDIR/3_Third_Level_EqDur
for COPE in cope2 cope3 cope4 cope5 cope6 cope7 cope8 cope9 cope10; do    #set all copes to run	
	echo Now processing third level $COPE
	feat $COPE.fsf
	echo Finished processing $COPE
done