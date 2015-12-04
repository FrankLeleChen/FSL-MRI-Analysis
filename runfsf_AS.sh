#!/bin/bash
# Andrej Schoeke, ####schoeke(at)usc(dot)edu#####

# Purpose: Running arbitrary designs with feat for the fRAL study or similiar folder structures.
# Arguments:    $1: folder in $ROOT/designs containing the design files of the same name
#
# Outcome: The script is not ending on itself. Once the all anlysis have been run, press Ctrl-C to stop.
# Callbacks: All finished analysis is labeled green in Finder. 
#
# SECURITY NOTE: THIS SCRIPT DOES ALLOW TO ENTER e.g. ../../../../../../.. and therefore to get information about the underlying system.
# http://en.wikipedia.org/wiki/Directory_traversal

# Test if design has been given by the command line
if [[ -z $1 ]]; then
    # If not, ask for the design
    echo -n "Please enter a folder name existent in the design folder: "
    read $1
fi
while [ true ]; do
    # folder for participants
    for part in {100..120}; do
        #folder for sessions
        for day in day1 day2; do
        
          #######################
          ### STRUCTURAL TEST ###
          #######################
  
          unset structural
  
          cd ../2structural   
          # Test if extracted brain is there and labeled green
          if [ `mdls -name kMDItemFSLabel $part/$day | awk '{ print $3 }'` -eq 2 ] ; then
              if [  -e $part/$day/structural_brain.nii.gz ]; then structural=$part/$day/structural_brain.nii.gz;
              fi
          fi

          cd ../scripts

          # For each of the scan blocks
          for block in {1..6}; do
             
              # Unset all possible conditions to empty  
              fmri=""
              win=""
              none=""
              lose="" 
              miss=""
              hit=""
              miss_ISI=""
              hit_ISI=""
              pic=""
              correct=""
              gist=""
              incorrect=""
			  gistincorrect=""
              hitWin=""
              missLose=""
              hitWin_ITI=""
              missLose_ITI=""
              correct_hit=""
              gistcorrect_hit=""
              incorrect_hit=""
              correct_miss=""
              gistcorrect_miss=""
              incorrect_miss=""
			  Win_correct=""
			  Win_incorrect=""
			  Win_gistcorrect=""
			  Win_gistincorrect=""
			  Lose_correct=""
			  Lose_incorrect=""
			  Lose_gistcorrect=""
			  Lose_gistincorrect=""
			  None_correct=""
			  None_incorrect=""
			  None_gistcorrect=""
			  None_gistincorrect=""
			  
			  # Experimenting with other way
			  # num=`cat design.fsf | grep fmri\(custom | sed 's/".*//' | sort  | uniq`
			  # for i in num; do
			  #     cope$i=""      
			  
          
              ######################
              ### RAL_BLOCK TEST ###
              ######################
       
              cd ../RAL_Block
              # Check for denoised or prestats scan block file
              ## Reason for this is that we do ICA denoising for each participant and therefore we take the prestats
              # Take denoised if available
              if  [ -e $part/$day/${block}_denoised.nii.gz ]; then fmri=$part/$day/${block}_denoised.nii.gz;
                # If not, take prestats
                elif [ -e $part/$day/${block}_pre.nii.gz ]; then fmri=$part/$day/${block}_pre.nii.gz;
                # If none is available, print error and skip the block
			    else echo "No Prestats avail yet."; continue
              fi
              
              cd ../scripts
  
              ########################    
              ### TIMING FILE TEST ###
              ########################
  
              cd ../timing
              
              # If the design name is
              if [[ $1 == "anticipation_feedback" ]]; then
              
    	          # CUES
    	          # Check if the file exists and assign it to variable
                  if  [ -e $part/$day/${1}/RAL_block_${block}_timing_win_cue_ISI.txt ]; then win=$part/$day/${1}/RAL_block_${block}_timing_win_cue_ISI.txt; fi
                  if  [ -e $part/$day/${1}/RAL_block_${block}_timing_lose_cue_ISI.txt ]; then lose=$part/$day/${1}/RAL_block_${block}_timing_lose_cue_ISI.txt; fi
                  if  [ -e $part/$day/${1}/RAL_block_${block}_timing_none_cue_ISI.txt ]; then none=$part/$day/${1}/RAL_block_${block}_timing_none_cue_ISI.txt; fi
              
                  # Check if the variable is set, if not skip this block.
                  ## Below another way of doing this...    
                  if [ -z $win ]; then echo "Win missing in " $part $day $block; sleep 0.1;
                        continue;
                  elif [ -z $lose ]; then echo "Lose missing in " $part $day $block ; sleep 0.1;
                        continue;
                  elif [ -z $none ]; then echo "None missing in " $part $day $block; sleep 0.1;
                        continue;
                  fi
	       
                  # ... cut out more of the same ... #
                
                # Here a different way of checking for set variable. Longer line, but just one long if.
                elif [[ $1 == "monetary_outcome2" ]]; then
                    if  [ -e $part/$day/monetary_outcome/RAL_block_${block}_timing_feedback_hitWin.txt -a `cat $part/$day/monetary_outcome/RAL_block_${block}_timing_feedback_hitWin.txt | wc -l` -gt 0 ]; then hitWin=$part/$day/monetary_outcome/RAL_block_${block}_timing_feedback_hitWin.txt;echo $hitWin; else echo "$part/$day $block problem in hitWin. Skipping"; continue; fi
                    if  [ -e $part/$day/monetary_outcome/RAL_block_${block}_timing_feedback_missLose.txt -a `cat $part/$day/monetary_outcome/RAL_block_${block}_timing_feedback_missLose.txt | wc -l` -gt 0 ]; then missLose=$part/$day/monetary_outcome/RAL_block_${block}_timing_feedback_missLose.txt; else echo "$part/$day $block problem in missLose. Skipping"; continue; fi
                    if  [ -e $part/$day/monetary_outcome/RAL_block_${block}_timing_feedback+ITI_hitWin.txt -a `cat $part/$day/monetary_outcome/RAL_block_${block}_timing_feedback+ITI_hitWin.txt | wc -l` -gt 0 ]; then hitWin_ITI=$part/$day/monetary_outcome/RAL_block_${block}_timing_feedback+ITI_hitWin.txt; else echo "$part/$day $block problem in hitWin ITI. Skipping"; continue; fi
                    if  [ -e $part/$day/monetary_outcome/RAL_block_${block}_timing_feedback+ITI_missLose.txt -a `cat $part/$day/monetary_outcome/RAL_block_${block}_timing_feedback+ITI_missLose.txt | wc -l` -gt 0 ]; then missLose_ITI=$part/$day/monetary_outcome/RAL_block_${block}_timing_feedback+ITI_missLose.txt; else echo "$part/$day $block problem in missLose ITI. Skipping"; continue; fi                        
		      fi
    

               ########################    
               ### Sanity checks   ###
               #######################
                
               cd ../scripts
                 
                 # Check for Scan block
                 if [ -z $fmri ]; then echo "MRI missing in " $part $day $block; sleep 0.1;
                     continue;
                    # Check for structural 
                    elif [ -z $structural ]; then echo "Struct missing in " $part $day; sleep 0.1;
                     continue;
                 # If Functional image exists, record how many slices there are.
                    else tot_vol=`fslnvols /Volumes/MacintoshHD2/2010_RAL_fMRI/RAL_block/$fmri`
                 fi
                  
                  # Check if the block has been already analysed                             
                  if [ -d ../Analysis/RAL/Subject/$part/$day/$1/block$block.feat ]; then
                    # If yes, then check if it is labeled green  
                    if [ `mdls -name kMDItemFSLabel /Volumes/MacintoshHD2/2010_RAL_fMRI/Analysis/RAL/Subject/$part/$day/$1/block$block.feat | awk '{ print $3 }'` -eq 2 ] ; then
                        echo "test";continue;
                    # If it's not green, let's assume it is still running.
                    else echo "$part $day $block Analysis still going on.";continue;
                    fi
                else
                    # If there is no analysis folder, analysis has not yet been done.
                    echo "Not Done $part $day block$block"
                    sleep 0.3
                    
                    # Lets set up the design file:
                    # The design get read in. If there are multiple entries for certain values, only the last is executed.
                    # We use this, so that we have a log what analysis were run already.
                    
                    # Document which participant, session and scan block we analyse.
                    # Attach that to template design file.
                    echo "### BEGINNING $part $day $block ... ###" >> ../designs/$1/$1.fsf 
                    
                    # Set output directory
                    echo 'set fmri(outputdir) "/Volumes/MacintoshHD2/2010_RAL_fMRI/Analysis/RAL/Subject/'$part'/'$day'/'$1'/block'$block'"' >> ../designs/$1/$1.fsf 
                    
                    # Set fMRI scan block
                    echo 'set feat_files(1) "/Volumes/MacintoshHD2/2010_RAL_fMRI/RAL_block/'$fmri'"' >> ../designs/$1/$1.fsf 
                    
                    # Set structural file
                    echo 'set highres_files(1) "/Volumes/MacintoshHD2/2010_RAL_fMRI/2structural/'$structural'"' >> ../designs/$1/$1.fsf 

                    # Set total volumes slices
                    echo "set fmri(npts) $tot_vol" >> ../designs/$1/$1.fsf 

                    # Design specific changes. Basically, we need to give them the right 3 colum format files for the EVs.
                    # The overall design is the same for each block.
                    if [[ $1 == "anticipation_feedback" ]]; then
                
                        echo 'set fmri(custom1) "/Volumes/MacintoshHD2/2010_RAL_fMRI/timing/'$win'"' >> ../designs/$1/$1.fsf 
                        echo 'set fmri(custom2) "/Volumes/MacintoshHD2/2010_RAL_fMRI/timing/'$lose'"' >> ../designs/$1/$1.fsf 
                        echo 'set fmri(custom3) "/Volumes/MacintoshHD2/2010_RAL_fMRI/timing/'$none'"' >> ../designs/$1/$1.fsf 

                        echo 'set fmri(custom4) "/Volumes/MacintoshHD2/2010_RAL_fMRI/timing/'$hit'"' >> ../designs/$1/$1.fsf
                        echo 'set fmri(custom5) "/Volumes/MacintoshHD2/2010_RAL_fMRI/timing/'$miss'"' >> ../designs/$1/$1.fsf

                        echo 'set fmri(custom6) "/Volumes/MacintoshHD2/2010_RAL_fMRI/timing/'$hit_ISI'"' >> ../designs/$1/$1.fsf
                        echo 'set fmri(custom7) "/Volumes/MacintoshHD2/2010_RAL_fMRI/timing/'$miss_ISI'"' >> ../designs/$1/$1.fsf
                        echo 'set fmri(custom8) "/Volumes/MacintoshHD2/2010_RAL_fMRI/timing/'$pic'"' >> ../designs/$1/$1.fsf

                                     
                     elif [[ $1 == "monetary_outcome2" ]]; then
                         echo "/Volumes/MacintoshHD2/2010_RAL_fMRI/timing/$hitWin"
                         echo 'set fmri(custom1) "/Volumes/MacintoshHD2/2010_RAL_fMRI/timing/'$hitWin'"' >> ../designs/$1/$1.fsf 
                         echo 'set fmri(custom2) "/Volumes/MacintoshHD2/2010_RAL_fMRI/timing/'$missLose'"' >> ../designs/$1/$1.fsf 
                         echo 'set fmri(custom3) "/Volumes/MacintoshHD2/2010_RAL_fMRI/timing/'$hitWin_ITI'"' >> ../designs/$1/$1.fsf 
                         echo 'set fmri(custom4) "/Volumes/MacintoshHD2/2010_RAL_fMRI/timing/'$missLose_ITI'"' >> ../designs/$1/$1.                               
                    fi

                    # Check if fsl_motion_outliers made an output file, see "fsl_motion_outliers --help"
                    if [[ -e "/Volumes/MacintoshHD2/2010_RAL_fMRI/RAL_block/$part/$day/${block}_MoCo.txt"  ]]; then
                        echo '# Confound EVs text file for analysis 1' >> ../designs/$1/$1.fsf
                        echo 'set confoundev_files(1) "/Volumes/MacintoshHD2/2010_RAL_fMRI/RAL_block/'$part'/'$day'/'$block'_MoCo.txt"' >> ../designs/$1/$1.fsf
                    fi    
                    
            		
                    echo "### END $part $day $block ... ###" >> ../designs/$1/$1.fsf 
                    echo >> ../designs/$1/$1.fsf 
                    echo >> ../designs/$1/$1.fsf 
                                
                    # Start the analysis
                    # In this version, we start every 450/60 = 7.5 mins a new analysis. Can be tweaked to your computer ability.            
                    feat ../designs/$1/$1.fsf & sleep 450 &&
                    
                    # Once we are done, label teh result folder green, so that we know it is done.
                    # It doesn't check whether the analysis ran through correctly though! Careful!
                    label=6; filename="/Volumes/MacintoshHD2/2010_RAL_fMRI/Analysis/RAL/Subject/'$part'/'$day'/'$1'/block'$block'" ;osascript -e "tell application \"Finder\" to set label index of alias POSIX file \"$filename\" to $label" > /dev/null;
         		    sleep 1
                 fi
             done
        done
    done

done
