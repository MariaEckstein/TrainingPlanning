DATADIR="/home/bunge/maria/Desktop/TrainingPlanning/datafiles/d2016"
DATASET="${SGE_TASK}"
# cd /home/bunge/maria/Desktop/TrainingPlanning && matlab -nodesktop -nosplash -r "fit_parameters_with_computeNLL1('datafiles/d2016/TS_222_2D.mat', 6)"
cd /home/bunge/maria/Desktop/TrainingPlanning && matlab -nodesktop -nosplash -r "fit_parameters_with_computeNLL1('datafiles/d2016/$DATASET', 6)"