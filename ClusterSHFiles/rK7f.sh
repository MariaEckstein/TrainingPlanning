DATADIR="/home/bunge/maria/Desktop/TrainingPlanning/datafiles/d2016"
DATASET="${SGE_TASK}"
cd /home/bunge/maria/Desktop/TrainingPlanning && matlab -nodesktop -nosplash -r "fit_parameters_with_lik_rl1_cluster('datafiles/d2016/$DATASET', 7, 'flat')"