ApplyXFM.sh : This script runs ApplyXFM to apply an existing transformation matrix (example_func2standard.mat) to an image (zstats) so you can overlay them in FSLView. [SLL]

MakeThenRunFeat.sh : This script uses a multiple template .fsf files made in the Feat GUI to make the design for multiple subjects and then runs first, second, and third-level feat analyses. [SLL]

RunFeat.sh : This script more elegantly uses one subject's template to run first-level feat analyses for multiple participants, sessions, and scans in FSL and is adaptable for any first-level design. [AS]

ReadFeatQuery.sh : This script reads betas for multiple subjects, copes, and masks as a percent signal change, and compiles pertinent data columns onto a master sheet for easy reading. [SLL] Importantly, see Jeanette Mumford's page for a PDF on accurately calculating %PE in featquery.
