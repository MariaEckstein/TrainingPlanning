###############
### General ###
###############

calculate_r_from_t = function(t, df) {
  r <- sqrt((t^2) / (t^2 + df))
  d <- (t * 2) / sqrt(df)
  return(r)
}

####################
### Read in data ###
####################

read_in_and_combine_several_files = function(file_dir, output_dir, column_headers, output_file_name) {

  file_names = list.files(file_dir, pattern = "*.csv")
  
  all_files = column_headers
  
  for (file_name in file_names) {
    
    file = vector()
    file = read.csv(file = file.path(file_dir, file_name), header = F, col.names = column_headers)
    
    all_files = rbind(all_files, file)
  }
  
  all_files = all_files[2:nrow(all_files),]
  
  write.csv(all_files, paste(output_dir, output_file_name, sep = ""))
}

# file_dir = "C:/Users/maria/MEGAsync/TrainingPlanningProject/TwoStepTask/Results/simulated_data/"
# output_dir = "C:/Users/maria/MEGAsync/TrainingPlanningProject/TwoStepTask/Results/simulated_data/"
# column_headers = paste("c", 1:18, sep = "")
# output_file_name = "all_simulations.csv"
# read_in_and_combine_several_files(file_dir, output_dir, column_headers, output_file_name)
# 
# file_dir = "C:/Users/maria/MEGAsync/TrainingPlanningProject/TwoStepTask/Results/all/k_can_be_negative/"
# output_dir = "C:/Users/maria/MEGAsync/TrainingPlanningProject/TwoStepTask/Results/all/k_can_be_negative/"
# column_headers = paste("c", 1:15, sep = "")
# output_file_name = "parameter_data_ga_fmincon_abpkw.csv"
# 
# column_headers = c("alpha1", "alpha2", "beta1", "beta2", "lambda", "p", "k", "w", "BIC", "SubjID", "session", "run", "functionvalue")
# output_file_name = "parameter_data_ga_fmincon.csv"
  

### ToL ###

read_in_ToL = function() {
  
  dat = read.table("TowerOfLondonTask/auswertung_alle.txt",
             header = T,
             sep = " ", na.strings = "",
             colClasses = c("factor", "factor", "factor", "factor", "numeric", "factor", "factor", "numeric", "factor", "numeric", "factor", "numeric", "numeric", "numeric", "numeric"))
  
  dat$run     = factor(dat$run, levels = unique(dat$run), labels = paste("Run", unique(dat$run)))
  dat$session = factor(dat$session, levels = unique(dat$session), labels = paste("Session", unique(dat$session)))
  
  dat[dat$SubjID %in% as.character(seq(10,100)),]
  
}

### Lab & Ass ###

read_in_labass = function(data) {
  
  dat = read.table(paste("NavigationAssociationTask/Results/", data, sep = ""),
                   header = F, col.names = c("SubjID", "session", "run", "trial", "testtrial", "ACC", "RT", "pos", "stime", "key", "keytime", "forbidden_step"),
                   colClasses = c("factor", "factor", "factor", "numeric", "factor", "numeric", "numeric", "numeric", "numeric", "factor", "numeric", "factor"),
                   sep = ",", na.strings = "")
  
  dat$run     = factor(dat$run, levels = unique(dat$run), labels = paste("Run", unique(dat$run)))
  dat$session = factor(dat$session, levels = unique(dat$session), labels = paste("Session", unique(dat$session)))
  
  dat[dat$SubjID %in% as.character(seq(10,100)),]
  
}

### GoNogo ###

read_in_GN = function() {
  
  dat = read.table("GoNogo/Results/all/GN.csv",
             header = F, col.names = c("SubjID", "session", "run", "trial", "upper_case", "ACC", "RT", "key", "time_start", "block"),
             colClasses = c("factor", "factor", "factor", "numeric", "factor", "numeric", "numeric", "factor", "numeric", "factor"),
             sep = ",", na.strings = "")
  
  dat$run     = factor(dat$run, levels = unique(dat$run), labels = paste("Run", unique(dat$run)))
  dat$session = factor(dat$session, levels = unique(dat$session), labels = paste("Session", unique(dat$session)))
  
  dat[dat$SubjID %in% as.character(seq(10,100)),]
  
}

### 2-step ###

read_in_2step = function(data) {
  
  dat = read.table(paste("TwoStepTask/Results/", data, sep = ""),
                   header = F, col.names = c("trial", "key1", "key2", "choice1", "choice2", "pair2", "RT1", "RT2", "ITI", "reward", "stim1_l", "stim1_r", "stim2_l", "stim2_r", "uncommon_trans", "SubjID", "session", "run"),
                   colClasses = c("numeric", "factor", "factor", "factor", "factor", "factor", "numeric", "numeric", "numeric", "numeric", "factor", "factor", "factor", "factor", "numeric", "factor", "factor", "factor"),
#                    header = F, col.names = c("trial", "key1", "key2", "choice1", "choice2", "pair2", "RT1", "RT2", "ITI", "reward", "stim1_l", "stim1_r", "stim2_l", "stim2_r", "uncommon_trans", "ch_stim1", "ch_stim2", "stay_stim1", "stay_stim2", "stay_first_stage", "ch_key1", "ch_key2", "stay_key1", "stay_key2", "stay_first_stage_key", "SubjID", "session", "run"),
#                    colClasses = c("numeric", "factor", "factor", "factor", "factor", "factor", "numeric", "numeric", "numeric", "numeric", "factor", "factor", "factor", "factor", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "factor", "factor", "factor"),
                   # col.names = c("SubjID", "session", "run", "trial", "key1", "key2", "choice1", "choice2", "pair2", "RT1", "RT2", "ITI", "reward", "stim1_l", "stim1_r", "stim2_l", "stim2_r", "uncommon_trans", "ch_stim1", "ch_stim2", "stay_stim1", "stay_stim2", "stay_first_stage", "ch_key1", "ch_key2", "stay_key1", "stay_key2", "stay_first_stage_key"),
                   #colClasses = c("factor", "factor", "factor", "numeric", "factor", "factor", "factor", "factor", "factor", "numeric", "numeric", "numeric", "factor", "factor", "factor", "factor", "factor", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"),
                   sep = ",", na.strings = "NA")
  
  dat$stim1_l = dat$stim1_r = dat$stim2_l = dat$stim2_r = dat$ITI = NULL
  
  dat$reward_prev_trial = c(NA, dat$reward[1:(length(dat$reward) - 1)])
  dat$transi_prev_trial = c(NA, dat$uncommon_trans[1:length(dat$uncommon_trans) - 1])
  dat$stay_first_stage  = dat$choice1 == c(NA, dat$choice1[1:(nrow(dat)-1)])
  dat$repeat_first_key  = dat$key1    == c(NA, dat$key1[1:(nrow(dat)-1)])
  dat$reward_prev_trial[dat$trial == 1] = NA
  dat$transi_prev_trial[dat$trial == 1] = NA
  dat$stay_first_stage[dat$trial  == 1] = NA
  dat$repeat_first_key[dat$trial  == 1] = NA
    
  dat$run               = factor(dat$run, levels = unique(dat$run), labels = paste("Run", unique(dat$run)))
  dat$session           = factor(dat$session, levels = unique(dat$session), labels = paste("Session", unique(dat$session)))
  dat$reward            = factor(dat$reward, levels = c("1", "0"), labels = c("Reward", "No reward"))
  dat$reward_prev_trial = factor(dat$reward_prev_trial, levels = c("1", "0"), labels = c("Reward", "No reward"))
  dat$uncommon_trans    = factor(dat$uncommon_trans, levels = c("0", "1"), labels = c("Common transition", "Uncommon transition"))
  dat$transi_prev_trial = factor(dat$transi_prev_trial, levels = c("0", "1"), labels = c("Common transition", "Uncommon transition"))
  
  dat[dat$SubjID %in% seq(10,100)[seq(10,100) != 33],]   # exclude Subject 33 (missing data in session 2)
}


create_lagged_regr_data = function(dat = ts) {
  
  #  The model uses a set of 4 predictors at each lag, each of which captures how a given combination of transition (common/rare) and outcome (rewarded/not) predicts whether the agent will repeat the choice a given number of trials in the future. E.g, the 'rewarded, rare' predictor at lag -2 captures the extent to which receiving a reward following a rare transition predicts that the agent will choose the same action two trials later.
  # In other words: (repeat_choice ~ reward_common + reward_rare + noreward_common + noreward_rare)
  
  ## Prepare lagged_effects data frame
  class_lagged_effects = expand.grid(lag = -1:-10, run = unique(ts$run), SubjID = unique(ts$SubjID), condition = c("rew_com", "rew_unc", "nor_com", "nor_unc"), log_odds = NA)
  new_lagged_effects   = expand.grid(lag = -1:-10, run = unique(ts$run), SubjID = unique(ts$SubjID), condition = c("rew_com", "rew_unc", "nor_com", "nor_unc", "rep_key", "stay"), log_odds = NA)
  lagged_switch_stay   = expand.grid(lag = -1:-10, run = unique(ts$run), SubjID = unique(ts$SubjID), condition = c("rew_com", "rew_unc", "nor_com", "nor_unc"), stay_percent = NA)
  lagged_switch_stay_stage2 = expand.grid(lag = -1:-10, run = unique(ts$run), SubjID = unique(ts$SubjID), condition = c("reward", "no_rew"), stay_percent = NA)
  
  ## Bring ts into the same form as Daw
  # Make reward and transition factors with 0s and 1s
  dat$reward          = factor(dat$reward, levels = c("No reward", "Reward"), labels = c(0, 1))
  dat$uncommon_trans  = factor(dat$uncommon_trans, levels = c("Uncommon transition", "Common transition"), labels = c(0, 1))   # For the logistic regression, 0 is UNcommon trans.!
  # Create 4 variables: reward & common trans.; no reward & common tr.; reward & uncommon tr.; no reward & uncommon tr.
  dat$rew_com = dat$nor_com = dat$rew_unc = dat$nor_unc = rep(0, nrow(dat))
  dat$rew_com[dat$reward == 1 & dat$uncommon_trans == 1] = 0.5
  dat$nor_com[dat$reward == 0 & dat$uncommon_trans == 1] = 0.5
  dat$rew_unc[dat$reward == 1 & dat$uncommon_trans == 0] = 0.5
  dat$nor_unc[dat$reward == 0 & dat$uncommon_trans == 0] = 0.5
  dat$rep_key[dat$repeat_first_key == T] =  0.5
  dat$rep_key[dat$repeat_first_key == F] = -0.5
  
  for (subj in unique(dat$SubjID)) {
    for (runi in unique(dat$run)) {
      
      # Stage 1 stuff
      subj_dat = subset(dat, SubjID == subj & run == runi, select = c("trial", "choice1", "rew_com", "rew_unc", "nor_com", "nor_unc", "rep_key", "pair2", "choice2", "reward"))
      choice1 = subj_dat$choice1
      
      # Stage 2 stuff
      subj_dat_pair1 = subset(subj_dat, pair2 == 1, select = c("choice2", "reward"))
      subj_dat_pair1$choice2 = as.numeric(as.character(subj_dat_pair1$choice2))
      subj_dat_pair2 = subset(subj_dat, pair2 == 2, select = c("choice2", "reward"))
      subj_dat_pair2$choice2 = as.numeric(as.character(subj_dat_pair2$choice2))
      
      if (!empty(subj_dat)) {
        
        for (lagi in -1:-10) {
          ## Get the right lag for 'stay_first_stage' (lag1: stay2 ~ rew1+trans1; lag2: stay3 ~ rew1+trans1; lag3: stay4 ~ rew1+trans1; etc)
          # Stage 1
          lagged_choice1 = c(rep(NA, -lagi), choice1[1:(length(choice1)+lagi)])
          lagged_stay_first_stage = choice1 == lagged_choice1
          mean_stays_first_stage = mean(lagged_stay_first_stage, na.rm = T)
          moved_lagged_stay_first_stage = lagged_stay_first_stage[(-lagi+1):(length(lagged_stay_first_stage)-lagi)]
          subj_dat$lagged_stay_first_stage = moved_lagged_stay_first_stage
          # Stage 2
          if (length(subj_dat_pair1$choice2) > -lagi) {     # if there are enough trials in the past to compare
            lagged_choice2_p1 = c(rep(NA, -lagi), subj_dat_pair1$choice2[1:(length(subj_dat_pair1$choice2)+lagi)])
          } else {
            lagged_choice2_p1 = rep(NA, length(subj_dat_pair1$choice2))
          }
          if (length(subj_dat_pair2$choice2) > -lagi) {
            lagged_choice2_p2 = c(rep(NA, -lagi), subj_dat_pair2$choice2[1:(length(subj_dat_pair2$choice2)+lagi)])
          } else {
            lagged_choice2_p2 = rep(NA, length(subj_dat_pair2$choice2))
          }
          lagged_stay_sec_stage_p1 = subj_dat_pair1$choice2 == lagged_choice2_p1
          lagged_stay_sec_stage_p2 = subj_dat_pair2$choice2 == lagged_choice2_p2
          mean_stays_sec_stage = mean(c(lagged_stay_sec_stage_p1, lagged_stay_sec_stage_p2), na.rm = T)
          moved_lagged_stay_sec_stage_p1 = lagged_stay_sec_stage_p1[(-lagi+1):(length(lagged_stay_sec_stage_p1)-lagi)]
          moved_lagged_stay_sec_stage_p2 = lagged_stay_sec_stage_p2[(-lagi+1):(length(lagged_stay_sec_stage_p2)-lagi)]
          subj_dat_pair1$lagged_stay_sec_stage_p1 = moved_lagged_stay_sec_stage_p1
          subj_dat_pair2$lagged_stay_sec_stage_p2 = moved_lagged_stay_sec_stage_p2
          
          ## Switch-stay analysis (1st stage)
          rew_com_stays = with(subj_dat, mean(lagged_stay_first_stage[rew_com == 0.5], na.rm = T)) - mean_stays_first_stage
          rew_unc_stays = with(subj_dat, mean(lagged_stay_first_stage[rew_unc == 0.5], na.rm = T)) - mean_stays_first_stage
          nor_com_stays = with(subj_dat, mean(lagged_stay_first_stage[nor_com == 0.5], na.rm = T)) - mean_stays_first_stage
          nor_unc_stays = with(subj_dat, mean(lagged_stay_first_stage[nor_unc == 0.5], na.rm = T)) - mean_stays_first_stage
          lagged_switch_stay[lagged_switch_stay$SubjID == subj & lagged_switch_stay$run == runi & lagged_switch_stay$lag == lagi, "stay_percent"] = c(rew_com_stays, rew_unc_stays, nor_com_stays, nor_unc_stays)
          
          ## Switch-stay analysis (2nd stage)
#           rew_p1_stays = with(subj_dat_pair1, mean(lagged_stay_sec_stage_p1[reward == 1], na.rm = T))
#           rew_p2_stays = with(subj_dat_pair2, mean(lagged_stay_sec_stage_p2[reward == 1], na.rm = T))
#           nor_p1_stays = with(subj_dat_pair1, mean(lagged_stay_sec_stage_p1[reward == 0], na.rm = T))
#           nor_p2_stays = with(subj_dat_pair2, mean(lagged_stay_sec_stage_p2[reward == 0], na.rm = T))
          rew_stay_p1 = subset(subj_dat_pair1, reward == 1)$lagged_stay_sec_stage_p1
          rew_stay_p2 = subset(subj_dat_pair2, reward == 1)$lagged_stay_sec_stage_p2
          rew_stays = mean(c(rew_stay_p1, rew_stay_p2), na.rm = T) - mean_stays_sec_stage
          nor_stay_p1 = subset(subj_dat_pair1, reward == 0)$lagged_stay_sec_stage_p1
          nor_stay_p2 = subset(subj_dat_pair2, reward == 0)$lagged_stay_sec_stage_p2
          nor_stays = mean(c(nor_stay_p1, nor_stay_p2), na.rm = T) - mean_stays_sec_stage
          # lagged_switch_stay_stage2[lagged_switch_stay_stage2$SubjID == subj & lagged_switch_stay_stage2$run == runi & lagged_switch_stay_stage2$lag == lagi, "stay_percent"] = c(rew_p1_stays, rew_p2_stays, nor_p1_stays, nor_p2_stays)
          lagged_switch_stay_stage2[lagged_switch_stay_stage2$SubjID == subj & lagged_switch_stay_stage2$run == runi & lagged_switch_stay_stage2$lag == lagi, "stay_percent"] = c(rew_stays, nor_stays)
          
          ## Build the regression models (when I put all four in at once, the model doesn't work)
          # all_mod     = glm(lagged_stay_first_stage ~ nor_unc + rew_com + nor_com + rew_unc, data = subj_dat, family = binomial())
          stay_mod    = glm(lagged_stay_first_stage ~ 1,       data = subj_dat, family = binomial())
          rew_com_mod = glm(lagged_stay_first_stage ~ rew_com, data = subj_dat, family = binomial())
          nor_com_mod = glm(lagged_stay_first_stage ~ nor_com, data = subj_dat, family = binomial())
          rew_unc_mod = glm(lagged_stay_first_stage ~ rew_unc, data = subj_dat, family = binomial())
          nor_unc_mod = glm(lagged_stay_first_stage ~ nor_unc, data = subj_dat, family = binomial())
          ## Save the data into the data.frame
          class_lagged_effects[class_lagged_effects$SubjID == subj & class_lagged_effects$run == runi & class_lagged_effects$lag == lagi & class_lagged_effects$condition == "rew_com",]$log_odds = rew_com_mod$coefficients[[2]]
          class_lagged_effects[class_lagged_effects$SubjID == subj & class_lagged_effects$run == runi & class_lagged_effects$lag == lagi & class_lagged_effects$condition == "nor_com",]$log_odds = nor_com_mod$coefficients[[2]]
          class_lagged_effects[class_lagged_effects$SubjID == subj & class_lagged_effects$run == runi & class_lagged_effects$lag == lagi & class_lagged_effects$condition == "rew_unc",]$log_odds = rew_unc_mod$coefficients[[2]]
          class_lagged_effects[class_lagged_effects$SubjID == subj & class_lagged_effects$run == runi & class_lagged_effects$lag == lagi & class_lagged_effects$condition == "nor_unc",]$log_odds = nor_unc_mod$coefficients[[2]]
          ## Build the new models, adding rep_key to each of the 4 predictors
          rep_key_mod = glm(lagged_stay_first_stage ~ rep_key, data = subj_dat, family = binomial())
          rew_com_mod = glm(lagged_stay_first_stage ~ rep_key + rew_com, data = subj_dat, family = binomial())
          nor_com_mod = glm(lagged_stay_first_stage ~ rep_key + nor_com, data = subj_dat, family = binomial())
          rew_unc_mod = glm(lagged_stay_first_stage ~ rep_key + rew_unc, data = subj_dat, family = binomial())
          nor_unc_mod = glm(lagged_stay_first_stage ~ rep_key + nor_unc, data = subj_dat, family = binomial())
          new_lagged_effects[new_lagged_effects$SubjID == subj & new_lagged_effects$run == runi & new_lagged_effects$lag == lagi & new_lagged_effects$condition == "stay",]$log_odds = stay_mod$coefficients[[1]]
          new_lagged_effects[new_lagged_effects$SubjID == subj & new_lagged_effects$run == runi & new_lagged_effects$lag == lagi & new_lagged_effects$condition == "rep_key",]$log_odds = rep_key_mod$coefficients[[2]]
          new_lagged_effects[new_lagged_effects$SubjID == subj & new_lagged_effects$run == runi & new_lagged_effects$lag == lagi & new_lagged_effects$condition == "rew_com",]$log_odds = rew_com_mod$coefficients[[3]]
          new_lagged_effects[new_lagged_effects$SubjID == subj & new_lagged_effects$run == runi & new_lagged_effects$lag == lagi & new_lagged_effects$condition == "nor_com",]$log_odds = nor_com_mod$coefficients[[3]]
          new_lagged_effects[new_lagged_effects$SubjID == subj & new_lagged_effects$run == runi & new_lagged_effects$lag == lagi & new_lagged_effects$condition == "rew_unc",]$log_odds = rew_unc_mod$coefficients[[3]]
          new_lagged_effects[new_lagged_effects$SubjID == subj & new_lagged_effects$run == runi & new_lagged_effects$lag == lagi & new_lagged_effects$condition == "nor_unc",]$log_odds = nor_unc_mod$coefficients[[3]]
        }
      }
    }
  }
  list(class_lagged_effects, new_lagged_effects, lagged_switch_stay, lagged_switch_stay_stage2)
}

create_smooth_lagged_effects = function(dat, name, number_of_iterations = 1) {
  
  ## Throw out outliers and average over subjects
  if (name == "class_lagged_effects") {
    smooth_lagged_effects = ddply(subset(dat, abs(log_odds) < quantile(abs(log_odds), 0.95, na.rm = T)),
                                  .(SubjID, run, lag, condition, training), summarize,
                                  log_odds = mean(log_odds, na.rm = T),
                                  sd_log_odds = sd(log_odds, na.rm = T))
  } else if (name == "lagged_switch_stay") {
    smooth_lagged_effects = ddply(dat, .(SubjID, run, lag, condition, training), summarize,
                                  log_odds = mean(stay_percent, na.rm = T),
                                  sd_log_odds = sd(stay_percent, na.rm = T))
  }
  
  ## Smooth twice by averaging 3 neighboring values
  smooth_lagged_effects$smooth_log_odds = NA
  for (conditioni in unique(smooth_lagged_effects$condition)) {
    for (trainingi in unique(smooth_lagged_effects$training)) {
      for (runi in unique(smooth_lagged_effects$run)) {
        smooth_log_odds = rollapply(subset(smooth_lagged_effects, condition == conditioni & training == trainingi & run == runi)$log_odds,
                                    width = 3, mean, na.rm = T, fill = NA, partial = T, align = "center")
        smooth_lagged_effects$smooth_log_odds[smooth_lagged_effects$condition == conditioni & smooth_lagged_effects$training == trainingi & smooth_lagged_effects$run == runi] = smooth_log_odds
      }
    }
  }
  if (number_of_iterations > 1) {
    for (it in 2:number_of_iterations) {
      for (conditioni in unique(smooth_lagged_effects$condition)) {
        for (trainingi in unique(smooth_lagged_effects$training)) {
          for (runi in unique(smooth_lagged_effects$run)) {
            smooth_log_odds = rollapply(subset(smooth_lagged_effects, condition == conditioni & training == trainingi & run == runi)$smooth_log_odds,
                                        width = 3, mean, na.rm = T, fill = NA, partial = T, align = "center")
            smooth_lagged_effects$smooth_log_odds[smooth_lagged_effects$condition == conditioni & smooth_lagged_effects$training == trainingi & smooth_lagged_effects$run == runi] = smooth_log_odds
          }
        }
      }
    }
  }
  smooth_lagged_effects
}

create_logist_regr_data = function(dat = ts, number.discarded.trials = 20) {
  
  ## Prepare empty logist_regr_data
  logist_regr_data_with_keyrep  = expand.grid(effect = c("KeyRep", "cor", "sta", "rew", "tra", "int"), run = unique(ts$run), SubjID = unique(ts$SubjID), odds = NA, AIC = NA)
  logist_regr_data_with_correct = expand.grid(effect =           c("cor", "sta", "rew", "tra", "int"), run = unique(ts$run), SubjID = unique(ts$SubjID), odds = NA, AIC = NA)
  logist_regr_data              = expand.grid(effect =                  c("sta", "rew", "tra", "int"), run = unique(ts$run), SubjID = unique(ts$SubjID), odds = NA, AIC = NA, Chi_diff_cor = NA, Chi_diff_rep = NA, Chi_p_cor = NA, Chi_p_rep = NA)
  
  ## Modify values in ts for Daw's logistic regression (he uses values of 0.5 and -0.5 instead of 1 and -1 and codes the interaction explicitly)
  dat$stay = 1
  dat$transi_prev_trial = as.numeric(as.character(factor(dat$transi_prev_trial, levels = c("Uncommon transition", "Common transition"), labels = c(-0.5, 0.5))))
  dat$reward_prev_trial = as.numeric(as.character(factor(dat$reward_prev_trial, levels = c("Reward", "No reward"), labels = c(0.5, -0.5))))
  dat$rep_key[dat$repeat_first_key == F] =  0.5
  dat$rep_key[dat$repeat_first_key == T] = -0.5
  dat$rep_key_prev_trial = c(NA, dat$rep_key[1:(nrow(dat)-1)])
  dat$trans_rew_interac = -0.5
  dat$trans_rew_interac[dat$transi_prev_trial == dat$reward_prev_trial] = 0.5
  
  ## Add reward probabilities for each 2nd-stage fractal in each trial
  # Load reward probability data
  if (data_source == 2015) {
    
    reward_probs1 = as.data.frame(t(read.csv('C:/Users/maria/MEGAsync/TrainingPlanningProject/TwoStepTask/stimuli/reward_probabilities1.csv',
                             header = F, row.names = c("x1", "x2", "x3", "x4", "f1", "f2", "f3", "f4"), col.names = paste("t", as.character(1:201), sep = ""))))
    reward_probs1 = subset(reward_probs1, select = c("f1", "f2", "f3", "f4"))
    reward_probs1$trial = 1:201
    reward_probs2 = as.data.frame(t(read.csv('C:/Users/maria/MEGAsync/TrainingPlanningProject/TwoStepTask/stimuli/reward_probabilities2.csv',
                             header = F, row.names = c("x1", "x2", "x3", "x4", "f1", "f2", "f3", "f4"), col.names = paste("t", as.character(1:201), sep = ""))))
    reward_probs2 = subset(reward_probs2, select = c("f1", "f2", "f3", "f4"))
    reward_probs2$trial = 1:201
    # Find out when subjects played the 2-step task with reward probabilities 1 and reward probabilities 2
    reward_versions = read.csv('C:/Users/maria/MEGAsync/TrainingPlanningProject/TwoStepTask/model/reward_versions.csv',
                               header = F, col.names = c("SubjID", "session", "reward_version"))
    reward_versions$session = factor(reward_versions$session, levels = c(1, 2), labels = c("Session 1", "Session 2"))
  
    dat = merge(dat, reward_versions, by = c("SubjID", "session"), all.x = T, sort = F)
    
  } else if (data_source == 2016 | data_source == "2016from_scratch") {
    ## Read in reward probabilities
    reward_probs1 = as.data.frame(t(read.csv('C:/Users/maria/MEGAsync/TrainingPlanningProject/TwoStepTask/stimuli/tryout_list1.csv',
                                             header = F, row.names = c("f1", "f2", "f3", "f4"), col.names = paste("t", as.character(1:201), sep = ""))))
    reward_probs2 = as.data.frame(t(read.csv('C:/Users/maria/MEGAsync/TrainingPlanningProject/TwoStepTask/stimuli/tryout_list2.csv',
                                             header = F, row.names = c("f1", "f2", "f3", "f4"), col.names = paste("t", as.character(1:201), sep = ""))))
    reward_probs3 = as.data.frame(t(read.csv('C:/Users/maria/MEGAsync/TrainingPlanningProject/TwoStepTask/stimuli/tryout_list3.csv',
                                             header = F, row.names = c("f1", "f2", "f3", "f4"), col.names = paste("t", as.character(1:201), sep = ""))))
    reward_probs4 = as.data.frame(t(read.csv('C:/Users/maria/MEGAsync/TrainingPlanningProject/TwoStepTask/stimuli/tryout_list4.csv',
                                             header = F, row.names = c("f1", "f2", "f3", "f4"), col.names = paste("t", as.character(1:201), sep = ""))))
  reward_probs1$trial = reward_probs2$trial = reward_probs3$trial = reward_probs4$trial = 1:201
  ## Add reward versions to subject data
  dat$reward_version[dat$run %in% c("A", "Run 1")] = 1
  dat$reward_version[dat$run %in% c("B", "Run 2")] = 2
  dat$reward_version[dat$run %in% c("C", "Run 3")] = 3
  dat$reward_version[dat$run %in% c("D", "Run 4")] = 4
  # Fix the error for subj 106 (got versions A and B again in the second session)
  dat$reward_version[dat$SubjID == 106 & dat$run == "Run 3"] = 1
  dat$reward_version[dat$SubjID == 106 & dat$run == "Run 4"] = 2
  }
  reward1_subj_dat = subset(dat, reward_version == 1)
  reward2_subj_dat = subset(dat, reward_version == 2)
  reward3_subj_dat = subset(dat, reward_version == 3)
  reward4_subj_dat = subset(dat, reward_version == 4)
  # Add reward probabilities to the right subjects, put all data back together, and bring in the right order
  reward1_subj_dat = merge(reward1_subj_dat, reward_probs1, by = c("trial"), all.x = T, sort = F)
  reward2_subj_dat = merge(reward2_subj_dat, reward_probs2, by = c("trial"), all.x = T, sort = F)
  dat = as.data.frame(rbind(reward1_subj_dat, reward2_subj_dat))
  if (!empty(reward4_subj_dat)) {
    reward3_subj_dat = merge(reward3_subj_dat, reward_probs1, by = c("trial"), all.x = T, sort = F)
    reward4_subj_dat = merge(reward4_subj_dat, reward_probs2, by = c("trial"), all.x = T, sort = F)
    dat = as.data.frame(rbind(reward1_subj_dat, reward2_subj_dat, reward3_subj_dat, reward4_subj_dat))
  }
  dat = dat[with(dat, order(SubjID, session, run, trial)),]
  # Add columns of interest
  dat$pair1_max_prob = apply(dat[,c("f1", "f2")], 1, max)                              # reward prob of the better fractal of pair 1
  dat$pair2_max_prob = apply(dat[,c("f3", "f4")], 1, max)                              # reward prob of the better fractal of pair 2
  dat$chosen_max_prob= NA                                                              # reward prob of the better fractal of chosen pair
  dat$chosen_max_prob[dat$choice2 %in% c(3, 4)] = dat$pair1_max_prob[dat$choice2 %in% c(3, 4)]
  dat$chosen_max_prob[dat$choice2 %in% c(5, 6)] = dat$pair2_max_prob[dat$choice2 %in% c(5, 6)]
  dat$unchos_max_prob= NA                                                              # reward prob of the better fractal of unchosen pair
  dat$unchos_max_prob[dat$choice2 %in% c(3, 4)] = dat$pair2_max_prob[dat$choice2 %in% c(3, 4)]
  dat$unchos_max_prob[dat$choice2 %in% c(5, 6)] = dat$pair1_max_prob[dat$choice2 %in% c(5, 6)]
  dat$correct_diff   = with(dat, chosen_max_prob - unchos_max_prob)                    # reward prob difference between chosen and unchosen pair
  dat$correct_diff_prev_trial = c(NA, dat$correct_diff[1:(nrow(dat)-1)])
  dat$correct_bin    = (dat$correct_diff / abs(dat$correct_diff)) * 0.5                # chosen pair has higher reward prob (0.5) or unchosen has higher (-0.5)
  dat$correct_bin_prev_trial = c(NA, dat$correct_bin[1:(nrow(dat)-1)])
  
  # Remove the first 20 trials from each run
  dat = subset(dat, trial > number.discarded.trials)
  
  # Calculate the logistic regressions
  for (subj in unique(dat$SubjID)) {
    for (runi in unique(dat$run)) {
      
      subj_sess_dat = subset(dat, SubjID == subj & run == runi & !is.na(correct_diff_prev_trial) & !is.na(rep_key_prev_trial))  ## ADJUST FOR 2013 DATA!!! LOOP OVER SESSION INSTEAD OF RUN!
      if (!empty(subj_sess_dat)) {
        ## Build the models (1. main effect of transition; 2. main effect of reward; 3. interaction btw both; 4. main effect of correct)
        mod_stay               = glm(stay_first_stage ~ stay, data = subj_sess_dat, family = binomial())
        mod_transition         = update(mod_stay, .~. + transi_prev_trial)
        mod_reward             = update(mod_transition, .~. + reward_prev_trial)
        mod_rew_trans          = update(mod_reward, .~. + trans_rew_interac)
        mod_rew_trans_corr     = update(mod_rew_trans, .~. + correct_diff_prev_trial)
        mod_rew_trans_rep      = update(mod_rew_trans, .~. + rep_key_prev_trial)
        mod_rew_trans_corr_rep = update(mod_rew_trans_corr, .~. + rep_key_prev_trial)
        
        Chi_diff_cor = mod_rew_trans$deviance - mod_rew_trans_corr$deviance
        Chi_df_cor = mod_rew_trans$df.residual - mod_rew_trans_corr$df.residual
        Chi_p_cor = 1 - pchisq(Chi_diff_cor, Chi_df_cor)
        Chi_diff_rep = mod_rew_trans$deviance - mod_rew_trans_rep$deviance
        Chi_df_rep = mod_rew_trans$df.residual - mod_rew_trans_rep$df.residual
        Chi_p_rep = 1 - pchisq(Chi_diff_rep, Chi_df_rep)
        
        odds_ratio_rew_trans          = mod_rew_trans$coefficients
        odds_ratio_rew_trans_corr     = mod_rew_trans_corr$coefficients
        odds_ratio_rew_trans_corr_rep = mod_rew_trans_corr_rep$coefficients
        AIC_rew_trans                 = mod_rew_trans$aic
        AIC_rew_trans_corr            = mod_rew_trans_corr$aic
        AIC_rew_trans_corr_rep        = mod_rew_trans_corr_rep$aic
        
        ## Add effect sizes into the prepared data frame
        logist_regr_data[logist_regr_data$SubjID == subj & logist_regr_data$run == runi, "AIC"] = AIC_rew_trans
        logist_regr_data[logist_regr_data$SubjID == subj & logist_regr_data$run == runi, "Chi_diff_cor"] = Chi_diff_cor
        logist_regr_data[logist_regr_data$SubjID == subj & logist_regr_data$run == runi, "Chi_diff_rep"] = Chi_diff_rep
        logist_regr_data[logist_regr_data$SubjID == subj & logist_regr_data$run == runi, "Chi_p_cor"] = Chi_p_cor
        logist_regr_data[logist_regr_data$SubjID == subj & logist_regr_data$run == runi, "Chi_p_rep"] = Chi_p_rep
        logist_regr_data[logist_regr_data$SubjID == subj & logist_regr_data$run == runi & logist_regr_data$effect == "sta", "odds"] = c(odds_ratio_rew_trans[[1]])
        logist_regr_data[logist_regr_data$SubjID == subj & logist_regr_data$run == runi & logist_regr_data$effect == "tra", "odds"] = c(odds_ratio_rew_trans[[3]])
        logist_regr_data[logist_regr_data$SubjID == subj & logist_regr_data$run == runi & logist_regr_data$effect == "rew", "odds"] = c(odds_ratio_rew_trans[[4]])
        logist_regr_data[logist_regr_data$SubjID == subj & logist_regr_data$run == runi & logist_regr_data$effect == "int", "odds"] = c(odds_ratio_rew_trans[[5]])
        
        logist_regr_data_with_correct[logist_regr_data_with_correct$SubjID == subj & logist_regr_data_with_correct$run == runi,]$AIC = AIC_rew_trans_corr
        logist_regr_data_with_correct[logist_regr_data_with_correct$SubjID == subj & logist_regr_data_with_correct$run == runi & logist_regr_data_with_correct$effect == "sta",]$odds = odds_ratio_rew_trans_corr[[1]]
        logist_regr_data_with_correct[logist_regr_data_with_correct$SubjID == subj & logist_regr_data_with_correct$run == runi & logist_regr_data_with_correct$effect == "tra",]$odds = odds_ratio_rew_trans_corr[[3]]
        logist_regr_data_with_correct[logist_regr_data_with_correct$SubjID == subj & logist_regr_data_with_correct$run == runi & logist_regr_data_with_correct$effect == "rew",]$odds = odds_ratio_rew_trans_corr[[4]]
        logist_regr_data_with_correct[logist_regr_data_with_correct$SubjID == subj & logist_regr_data_with_correct$run == runi & logist_regr_data_with_correct$effect == "int",]$odds = odds_ratio_rew_trans_corr[[5]]
        logist_regr_data_with_correct[logist_regr_data_with_correct$SubjID == subj & logist_regr_data_with_correct$run == runi & logist_regr_data_with_correct$effect == "cor",]$odds = odds_ratio_rew_trans_corr[[6]]
        
        logist_regr_data_with_keyrep[logist_regr_data_with_keyrep$SubjID == subj & logist_regr_data_with_keyrep$run == runi,]$AIC = AIC_rew_trans_corr_rep
        logist_regr_data_with_keyrep[logist_regr_data_with_keyrep$SubjID == subj & logist_regr_data_with_keyrep$run == runi & logist_regr_data_with_keyrep$effect == "sta",]$odds = odds_ratio_rew_trans_corr_rep[[1]]
        logist_regr_data_with_keyrep[logist_regr_data_with_keyrep$SubjID == subj & logist_regr_data_with_keyrep$run == runi & logist_regr_data_with_keyrep$effect == "tra",]$odds = odds_ratio_rew_trans_corr_rep[[3]]
        logist_regr_data_with_keyrep[logist_regr_data_with_keyrep$SubjID == subj & logist_regr_data_with_keyrep$run == runi & logist_regr_data_with_keyrep$effect == "rew",]$odds = odds_ratio_rew_trans_corr_rep[[4]]
        logist_regr_data_with_keyrep[logist_regr_data_with_keyrep$SubjID == subj & logist_regr_data_with_keyrep$run == runi & logist_regr_data_with_keyrep$effect == "int",]$odds = odds_ratio_rew_trans_corr_rep[[5]]
        logist_regr_data_with_keyrep[logist_regr_data_with_keyrep$SubjID == subj & logist_regr_data_with_keyrep$run == runi & logist_regr_data_with_keyrep$effect == "cor",]$odds = odds_ratio_rew_trans_corr_rep[[6]]
        logist_regr_data_with_keyrep[logist_regr_data_with_keyrep$SubjID == subj & logist_regr_data_with_keyrep$run == runi & logist_regr_data_with_keyrep$effect == "KeyRep",]$odds = odds_ratio_rew_trans_corr_rep[[7]]
      }
    }
  }
  
  list(logist_regr_data, logist_regr_data_with_correct, logist_regr_data_with_keyrep)
}

read_in_2step_parameters = function(data) {
  
  dat = read.table(paste("TwoStepTask/Results/all/", data, sep = ""),
                   header = F, col.names = c("alpha1", "alpha2", "beta1", "beta2", "lambda", "p", "w", "SubjID", "session", "run"),
                   colClasses = c("numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "factor", "factor", "factor"),
                   sep = ",", na.strings = "NA")
  
  dat$run     = factor(dat$run, levels = unique(dat$run), labels = paste("Run", unique(dat$run)))
  dat$session = factor(dat$session, levels = unique(dat$session), labels = paste("Session", unique(dat$session)))
  
  dat[dat$SubjID %in% seq(10,100)[seq(10,100) != 33],]   # exclude Subject 33 (missing data in session 2)
  
}

read_in_2step_parameters2 = function(data) {
  
  dat = read.table(paste("TwoStepTask/Results/all/", data, sep = ""),
                   header = T, col.names = c("alpha1", "alpha2", "beta1", "beta2", "lambda", "p", "k", "w", "BIC", "SubjID", "session", "run"),
                   colClasses = c("numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "factor", "factor", "factor"),
                   sep = ",", na.strings = "NA")
  
  dat$run     = factor(dat$run, levels = unique(dat$run), labels = paste("Run", unique(dat$run)))
  dat$session = factor(dat$session, levels = unique(dat$session), labels = paste("Session", unique(dat$session)))
  
  dat[dat$SubjID %in% seq(10,100)[seq(10,100) != 33],]   # exclude Subject 33 (missing data in session 2)
  
}

read_in_2step_parameters3 = function(data) {
  
  dat = read.table(paste("TwoStepTask/Results/all/", data, sep = ""),
                   col.names = c("alpha1", "alpha2", "beta1", "beta2", "lambda", "p", "k", "w", "BIC", "SubjID", "session", "run", "function value"),
                   colClasses = c("numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "factor", "factor", "factor", "numeric"),
                   sep = ",", na.strings = "NA")
  
  dat$run     = factor(dat$run, levels = unique(dat$run), labels = paste("Run", unique(dat$run)))
  dat$session = factor(dat$session, levels = unique(dat$session), labels = paste("Session", unique(dat$session)))
  
  dat[dat$SubjID %in% seq(10,100)[seq(10,100) != 33],]   # exclude Subject 33 (missing data in session 2)
  
}


### BICs ###

read_in_BICs = function(data) {
  
  dat = read.csv(paste("TwoStepTask/Results/all/", data, sep = ""),
                 header = F, col.names = c("BIC", "SubjID", "session", "run"),
                 colClasses = c("numeric", "factor", "factor", "factor"),
                 sep = ",", na.strings = "NA")
  
  dat$run     = factor(dat$run, levels = unique(dat$run), labels = paste("Run", unique(dat$run)))
  dat$session = factor(dat$session, levels = unique(dat$session), labels = paste("Session", unique(dat$session)))
  
  dat[dat$SubjID %in% seq(10,100)[seq(10,100) != 33],]   # exclude Subject 33 (missing data in session 2)
  
}


################################
### Summarize and merge data ###
################################

add_group_columns = function(data) {
  
  if (data_source == 2015) {
    
    data$group4 = NA
    data$group2 = NA
    
    data$group2[data$SubjID %in% seq(1, 101, 4) & data$session == "Session 1"] = "m_based"
    data$group2[data$SubjID %in% seq(2, 102, 4) & data$session == "Session 2"] = "m_based"
    data$group2[data$SubjID %in% seq(3, 103, 4) & data$session == "Session 2"] = "m_based"
    data$group2[data$SubjID %in% seq(4, 104, 4) & data$session == "Session 1"] = "m_based"
    
    data$group4[data$SubjID %in% seq(1, 101, 4) & data$session == "Session 1"] = "m_based1"
    data$group4[data$SubjID %in% seq(2, 102, 4) & data$session == "Session 2"] = "m_based2"
    data$group4[data$SubjID %in% seq(3, 103, 4) & data$session == "Session 2"] = "m_based2"
    data$group4[data$SubjID %in% seq(4, 104, 4) & data$session == "Session 1"] = "m_based1"
    
    data$group2[data$SubjID %in% seq(1, 101, 4) & data$session == "Session 2"] = "m_free"
    data$group2[data$SubjID %in% seq(2, 102, 4) & data$session == "Session 1"] = "m_free"
    data$group2[data$SubjID %in% seq(3, 103, 4) & data$session == "Session 1"] = "m_free"
    data$group2[data$SubjID %in% seq(4, 104, 4) & data$session == "Session 2"] = "m_free"
    
    data$group4[data$SubjID %in% seq(1, 101, 4) & data$session == "Session 2"] = "m_free2"
    data$group4[data$SubjID %in% seq(2, 102, 4) & data$session == "Session 1"] = "m_free1"
    data$group4[data$SubjID %in% seq(3, 103, 4) & data$session == "Session 1"] = "m_free1"
    data$group4[data$SubjID %in% seq(4, 104, 4) & data$session == "Session 2"] = "m_free2"
    
    data$training[data$group4 == "m_based1" | data$group4 == "m_free2"] = "m_based_first"
    data$training[data$group4 == "m_free1"  | data$group4 == "m_based2"]= "m_free_first"
    
    data$group4 = factor(data$group4)
    data$group2 = factor(data$group2, levels = c("m_free", "m_based"), labels = c("Model-free training", "Model-based training"))
  data$group4 = data$group2 = NULL
    
  } else if (data_source == 2016 | data_source == "2016from_scratch") {
    
    data$training = NA
    data$training[data$SubjID %in% seq(101, 301, 5)] = "mbmb"
    data$training[data$SubjID %in% seq(102, 302, 5)] = "mbmf"
    data$training[data$SubjID %in% seq(103, 303, 5)] = "mfmf"
    data$training[data$SubjID %in% seq(104, 304, 5)] = "mfmb"
    data$training[data$SubjID %in% seq(105, 305, 5)] = "co"
    
    data$training_s1[data$training == "co"] = "co"
    data$training_s1[data$training %in% c("mbmb", "mbmf")] = "mb"
    data$training_s1[data$training %in% c("mfmf", "mfmb")] = "mf"
    
  }
  
  data$training = factor(data$training)
  data$training_s1 = factor(data$training_s1)
  data
  
}

add_performance_columns_ToL = function() {
  
  ## Add column MinMoves: minimum number of moves necessary to solve each tower problem
  ToL$MinMoves = NA
  
  ToL$MinMoves[ToL$StartTower == "ST112010" & ToL$GoalTower == "GT000201"] = 3
  ToL$MinMoves[ToL$StartTower == "ST012000" & ToL$GoalTower == "GT100011"] = 3
  
  ToL$MinMoves[ToL$StartTower == "ST000110" & ToL$GoalTower == "GT111000"] = 4
  ToL$MinMoves[ToL$StartTower == "ST200001" & ToL$GoalTower == "GT102000"] = 4
  
  ToL$MinMoves[ToL$StartTower == "ST101100" & ToL$GoalTower == "GT110010"] = 5
  ToL$MinMoves[ToL$StartTower == "ST001020" & ToL$GoalTower == "GT102000"] = 5
  
  ToL$MinMoves[ToL$StartTower == "ST100100" & ToL$GoalTower == "GT110010"] = 6
  ToL$MinMoves[ToL$StartTower == "ST002001" & ToL$GoalTower == "GT020100"] = 6
  
  ToL$MinMoves[ToL$StartTower == "ST112010" & ToL$GoalTower == "GT100100"] = 7
  ToL$MinMoves[ToL$StartTower == "ST000102" & ToL$GoalTower == "GT100011"] = 7
  
  ToL$MinMoves[ToL$StartTower == "ST112010" & ToL$GoalTower == "GT020100"] = 8
  ToL$MinMoves[ToL$StartTower == "ST000102" & ToL$GoalTower == "GT102011"] = 8
  
  ## Add columns Made_minus_EstimMoves, Estim_minus_MinMoves, and Made_minus_MinMoves
  ToL$Made_minus_EstimMoves = ToL$MadeMoves - ToL$EstimMoves
  ToL$Estim_minus_MinMoves = ToL$EstimMoves - ToL$MinMoves
  ToL$Made_minus_MinMoves = ToL$MadeMoves - ToL$MinMoves
  
  ToL

}

add_start_end_columns = function(data, group2i) {
  
  data$part = "middle"
  data$part[data$trial <= 30] = "start"
  data$part[data$trial >= 80] = "end"
  part_perf = ddply(data, .(SubjID, session, run, group2, training, part), summarize, mean_ACC = mean(ACC, na.rm = T), mean_RT = mean(RT, na.rm = T))
  
  data$start = "middle"
  data$end = "middle"
  for (runi in c("Run 1", "Run 2")) {
    ACCs = mean(subset(part_perf, group2 == group2i & run == runi)$mean_ACC, na.rm = T)
    # ACCs = mean(subset(part_perf, part == "start" & group2 == group2i & run == runi)$mean_ACC, na.rm = T)
    start_low_subj      = subset(part_perf, part == "start" & group2 == group2i & run == runi & mean_ACC <= ACCs)$SubjID
    start_high_subj     = subset(part_perf, part == "start" & group2 == group2i & run == runi & mean_ACC >= ACCs)$SubjID
    data$start[data$group2 == group2i & data$run == runi & data$SubjID %in% start_low_subj] = "low"
    data$start[data$group2 == group2i & data$run == runi & data$SubjID %in% start_high_subj] = "high"
    
    # ACCs = mean(subset(part_perf, part == "end" & group2 == group2i & run == runi)$mean_ACC, na.rm = T)
    end_low_subj      = subset(part_perf, part == "end" & group2 == group2i & run == runi & mean_ACC <= ACCs)$SubjID
    end_high_subj     = subset(part_perf, part == "end" & group2 == group2i & run == runi & mean_ACC >= ACCs)$SubjID
    data$end[data$group2 == group2i & data$run == runi & data$SubjID %in% end_low_subj] = "low"
    data$end[data$group2 == group2i & data$run == runi & data$SubjID %in% end_high_subj] = "high"
  }
  
  data$part   = factor(data$part)
  data$start  = factor(data$start)
  data$end    = factor(data$end)
  
  data
}

exclude_trials = function(exp_dat) {
  
  # No trial is excluded at the beginning:
  exp_dat$exclude = FALSE
  
  # Now, I will go through all subjects and runs and find the trials that need to be excluded (RT outside 3 sd)
  for (subj in unique(exp_dat$SubjID)) {
    for (runi in unique(exp_dat$run)) {
      subj_dat = subset(exp_dat, SubjID == subj & run == runi)
      RT_mean = mean(subj_dat$RT, na.rm = T)
      RT_sd = sd(subj_dat$RT, na.rm = T)
      RT_upper = RT_mean + 3 * RT_sd
      RT_lower = RT_mean - 3 * RT_sd
      
      # The trials to be excluded will first be marked in the subject data...
      subj_excl = rep(FALSE, nrow(subj_dat))
      subj_excl[subj_dat$RT < RT_lower | subj_dat$RT > RT_upper] = TRUE
      
      # ... and than be transferred to the original data set
      exp_dat$exclude[exp_dat$SubjID == subj & exp_dat$run == runi] = subj_excl
    }
  }
  
  # Delete all excluded trials from the data frame (and final clean-up: delete the exclude column itself)
  subset(exp_dat, exclude == FALSE, select = colnames(exp_dat) != "exclude")
  
#   exp_dat$exclude = FALSE
#   means_and_sds = ddply(exp_dat, .(SubjID, session, run), summarize, RT_mean = mean(RT, na.rm = T), RT_sd = sd(RT, na.rm = T))
#   
#   for (row in 1:nrow(exp_dat)) {
#     
#     SubjID = exp_dat[row, "SubjID"]
#     run = exp_dat[row, "run"]
#     
#     subj_means_and_sds = subset(means_and_sds, SubjID == SubjID & run == run)
#     RT_mean = subj_means_and_sds$RT_mean
#     RT_sd   = subj_means_and_sds$RT_sd
#     
#     RT_upper_bound = with(subj_means_and_sds, RT_mean + 2 * RT_sd)
#     RT_lower_bound = with(subj_means_and_sds, RT_mean - 2 * RT_sd)
#     
#     exp_dat$exclude[exp_dat$SubjID == SubjID & exp_dat$run == run & (exp_dat$RT < RT_lower_bound | exp_dat$RT > RT_upper_bound)] = TRUE    
#   }
#   
#   subset(exp_dat, select = colnames(exp_dat) != "exclude")
}

create_summary_data_frame = function() {
  
  Lab_short = ddply(.data = Lab, .variables = .(SubjID, session, run, group2, training), .fun = summarize, Lab_ACC = mean(ACC, na.rm = T))
  ToL_short = ddply(.data = ToL, .variables = .(SubjID, session, run, group2, training), .fun = summarize, ToL_MadeEstim = mean(abs(Made_minus_EstimMoves), na.rm = T), ToL_MadeMin = mean(abs(Made_minus_MinMoves), na.rm = T))
  
  Ass_short = ddply(.data = Ass, .variables = .(SubjID, session, run, group2, training), .fun = summarize, Ass_ACC = mean(ACC, na.rm = T), Ass_RT = mean(RT, na.rm = T))
  GN_short  = ddply(.data = GN,  .variables = .(SubjID, session, run, group2, training), .fun = summarize, GN_ACC  = mean(ACC, na.rm = T), GN_RT =  mean(RT, na.rm = T))
  
  M_based_perf = merge(Lab_short, ToL_short, all = T)
  M_free_perf = merge(Ass_short, GN_short, all = T)
  Perf_all = merge(M_based_perf, M_free_perf, by = c("SubjID", "run", "training"), all = T)
  
  Perf_all[,c("SubjID", "run", "training", "Lab_ACC", "ToL_MadeEstim", "ToL_MadeMin", "Ass_ACC", "Ass_RT", "GN_ACC", "GN_RT")]
}

create_diff_dat = function() {
  
  m_based_first_diff_r1 = - subset(stay_dat, run == "Run 1" & training == "m_based_first" & session == "Session 1", "stay_prob_unrew") +
                          subset(stay_dat, run == "Run 1" & training == "m_based_first" & session == "Session 2", "stay_prob_unrew")
  SubjID =                subset(stay_dat, run == "Run 1" & training == "m_based_first" & session == "Session 2", "SubjID")
  diff_dat_part1 = cbind(SubjID, "Run 1", "m_based_first", m_based_first_diff_r1)
  
  m_based_first_diff_r2 = - subset(stay_dat, run == "Run 2" & training == "m_based_first" & session == "Session 1", "stay_prob_unrew") +
                          subset(stay_dat, run == "Run 2" & training == "m_based_first" & session == "Session 2", "stay_prob_unrew")
  SubjID =                subset(stay_dat, run == "Run 2" & training == "m_based_first" & session == "Session 2", "SubjID")
  diff_dat_part2 = cbind(SubjID, "Run 2", "m_based_first", m_based_first_diff_r2)
  
  m_free_first_diff_r1 =  subset(stay_dat, run == "Run 1" & training == "m_free_first" & session == "Session 1", "stay_prob_unrew") -
                          subset(stay_dat, run == "Run 1" & training == "m_free_first" & session == "Session 2", "stay_prob_unrew")
  SubjID =                subset(stay_dat, run == "Run 1" & training == "m_free_first" & session == "Session 2", "SubjID")
  diff_dat_part3 = cbind(SubjID, "Run 1", "m_free_first", m_free_first_diff_r1)
  
  m_free_first_diff_r2 =  subset(stay_dat, run == "Run 2" & training == "m_free_first" & session == "Session 1", "stay_prob_unrew") -
                          subset(stay_dat, run == "Run 2" & training == "m_free_first" & session == "Session 2", "stay_prob_unrew")
  SubjID =                subset(stay_dat, run == "Run 2" & training == "m_free_first" & session == "Session 2", "SubjID")
  diff_dat_part4 = cbind(SubjID, "Run 2", "m_free_first", m_free_first_diff_r2)
  
  colnames(diff_dat_part1) = colnames(diff_dat_part2) = colnames(diff_dat_part3) = colnames(diff_dat_part4) = c("SubjID", "run", "training", "m_free_minus_m_based")
  
  rbind(diff_dat_part1, diff_dat_part2, diff_dat_part3, diff_dat_part4)
}

create_stay_dat2 = function(data = ts, trials = 0:5000) {
  
  data = subset(data, trial %in% trials & !is.na(reward_prev_trial))
  stay_dat = ddply(data, .(SubjID, session, run, transi_prev_trial, reward_prev_trial, group2, training), summarize,
                   stays = sum(stay_first_stage, na.rm = T),
                   trials = length(stay_first_stage),
                   stay_prob = mean(stay_first_stage, na.rm = T))
  
  stay_dat
}

create_corrected_data = function(data, run, b) {
  
  data = subset(data, run == run)
  data$stay_prob[data$group2 == "Model-based training"] =
  data$stay_prob[data$group2 == "Model-based training"] - b
  
  # colnames(data)[colnames(data) == "stay_prob"] = "corrected_stay_prob"
  
  data
}

create_corrected_data_extended = function(data, training_v, run_v) {
  
  stay_dat = subset(data, training == training_v & run == run_v)
  
  mf_mean = mean(with(stay_dat, stay_prob[group2 == "Model-free training"]))
  mb_mean = mean(with(stay_dat, stay_prob[group2 == "Model-based training"]))
  stay_dat$stay_prob[stay_dat$group2 == "Model-free training"] = stay_dat$stay_prob[stay_dat$group2 == "Model-free training"] - mf_mean
  stay_dat$stay_prob[stay_dat$group2 == "Model-based training"] = stay_dat$stay_prob[stay_dat$group2 == "Model-based training"] - mb_mean
  
  stay_dat
}

create_cor_diff_data = function(data, variable = "cor_dat", colname = "stay_prob", run_diff = FALSE) {
  
  # bring columns in the right order
  data = data[,c(colnames(data)[colnames(data) != colname], colname)]
  
  # separate model-free and model-based data
  mf_cor_dat = subset(data, group2 == "Model-free training")
  colnames(mf_cor_dat) = c(colnames(mf_cor_dat)[colnames(mf_cor_dat) != colname], paste("mf_", colname, sep = ""))
  mb_cor_dat = subset(data, group2 == "Model-based training")
  colnames(mb_cor_dat) = c(colnames(mb_cor_dat)[colnames(mb_cor_dat) != colname], paste("mb_", colname, sep = ""))
  
  if (run_diff == TRUE) {
    mf_cor_dat = subset(data, run == "Run 2")
    colnames(mf_cor_dat) = c(colnames(mf_cor_dat)[colnames(mf_cor_dat) != colname], paste("mf_", colname, sep = ""))
    mb_cor_dat = subset(data, run == "Run 1")
    colnames(mb_cor_dat) = c(colnames(mb_cor_dat)[colnames(mb_cor_dat) != colname], paste("mb_", colname, sep = ""))
  }
  
  # indiciate on which variables to merge the data frames
  if (variable == "cor_dat") {
    bys = c("SubjID", "run", "uncommon_trans", "reward", "training")
    if ("Lab_median" %in% colnames(mb_cor_dat)) {
      bys = c("SubjID", "run", "uncommon_trans", "reward", "training", "Lab_ACC", "ToL_MadeEstim", "ToL_MadeMin", "Ass_ACC", "Ass_RT", "GN_ACC", "GN_RT", "Lab_median", "GN_median", "Ass_median", "ToL_MadeEstim_median", "ToL_MadeMin_median")
      #, "Lab_Ass_ACC_start", "Lab_Ass_ACC_end", "Lab_Ass_learning_f", "Lab_Ass_fatigue_f", "Lab_Ass_learning_absolute_f"
    }
  } else if (run_diff == TRUE) {
    bys = c("SubjID", "session", "training", "parameter")
  } else if (variable == "ts_params_molten") {
    bys = c("SubjID", "run", "training", "parameter")
  }

  # merge the data frames together
  merge_dat = merge(mf_cor_dat, mb_cor_dat, by = bys, suffixes = c("_mf", "_mb"))
  cor_diff_data = merge_dat
  # cor_diff_data = subset(merge_dat, select = c(bys, paste("mf_", colname, sep = ""), paste("mb_", colname, sep = "")))
  
  if (variable == "cor_dat") {
    cor_diff_data$diff_stay_prob = with(cor_diff_data, mb_stay_prob - mf_stay_prob)
  } else if (variable == "ts_params_molten") {
    cor_diff_data$diff_estimate = with(cor_diff_data, mb_estimate - mf_estimate)  # for variable == "run_diff": Run2-Run1
  }
  
  cor_diff_data
}

find_perseverance_trials = function(data = ts, num_keys = 10) {

  # Initialize values
  data$subj_run_persev = FALSE
  key_persev_dat = expand.grid(run = unique(data$run), session = unique(data$session), SubjID = unique(data$SubjID))
  
  # For each subject, for each session and each run, indicate if the same key has been pressed at least 'num_keys' times in a row
  for (subj in unique(data$SubjID)) {
    for (sessi in unique(data$session)) {
      for (runi in unique(data$run)) {
        subj_run_dat = subset(data, SubjID == subj & run == runi & session == sessi)
        if (!empty(subj_run_dat)) {
          subj_run_persev = rep(FALSE, nrow(subj_run_dat))
          
          for (trial in 1:(nrow(subj_run_dat) - num_keys)) {
            stay_keys = sum(subj_run_dat$repeat_first_key[trial:(trial+num_keys)], na.rm = T)
            
            if (stay_keys == num_keys) {
              subj_run_persev[trial:(trial+num_keys)] = TRUE
            }
          }
          
          key_persev_dat$persev[with(key_persev_dat, SubjID == subj & run == runi & session == sessi)] = sum(subj_run_persev)
          key_persev_dat$nrow[with(key_persev_dat, SubjID == subj & run == runi & session == sessi)] = nrow(subj_run_dat)
          data$subj_run_persev[with(data, SubjID == subj & run == runi & session == sessi)] = subj_run_persev 
        }
      }
    }
  }
  
  # Calculate what percentage of button presses belongs to this kind of key perseverance (same key more than 'num_keys' times in a row)
  key_persev_dat = subset(key_persev_dat, !is.na(persev))
  key_persev_dat$percent = with(key_persev_dat, persev / nrow)
  
  list(data, key_persev_dat)
}

create_lines_data = function(run, facet_var = "training") {
  
  # get the means of each bar using 'by()' and get the names of the facets
  if (facet_var == "training") {
    if        (run == "Run 1") {
      y = as.vector(by(cor_diff_data_r1$diff_stay_prob, list(cor_diff_data_r1$uncommon_trans, cor_diff_data_r1$reward, cor_diff_data_r1$training), mean))
    } else if (run == "Run 2") {
      y = as.vector(by(cor_diff_data_r2$diff_stay_prob, list(cor_diff_data_r2$uncommon_trans, cor_diff_data_r2$reward, cor_diff_data_r2$training), mean))
    }
    facets = c(rep("m_based_first", 4), rep("m_free_first", 4))
    
  } else if (facet_var == "Lab_median") {
    if        (run == "Run 1") {
      y = as.vector(by(cor_diff_data_r1$diff_stay_prob, list(cor_diff_data_r1$uncommon_trans, cor_diff_data_r1$reward, cor_diff_data_r1$Lab_median), mean))
    } else if (run == "Run 2") {
      y = as.vector(by(cor_diff_data_r2$diff_stay_prob, list(cor_diff_data_r2$uncommon_trans, cor_diff_data_r2$reward, cor_diff_data_r2$Lab_median), mean))
    }
    facets = c(rep("above", 4), rep("below", 4))
  } else if (facet_var == "Ass_median") {
    if        (run == "Run 1") {
      y = as.vector(by(cor_diff_data_r1$diff_stay_prob, list(cor_diff_data_r1$uncommon_trans, cor_diff_data_r1$reward, cor_diff_data_r1$Ass_median), mean))
    } else if (run == "Run 2") {
      y = as.vector(by(cor_diff_data_r2$diff_stay_prob, list(cor_diff_data_r2$uncommon_trans, cor_diff_data_r2$reward, cor_diff_data_r2$Ass_median), mean))
    }
    facets = c(rep("above", 4), rep("below", 4))
  }

  # create a data.frame with the 'by()' means and the rest to use in the plot
  dat = data.frame(x = c(0.77, 1.23, 1.77, 2.23, 0.77, 1.23, 1.77, 2.23),
             y = y,
             reward = c("Reward", "Reward", "No reward", "No reward", "Reward", "Reward", "No reward", "No reward"),
             group = c(1, 1, 2, 2, 3, 3, 4, 4),
             facet_var = facets)
  
  # rename colnames according to original data frame in the original plot so that facetting works
  colnames(dat)[colnames(dat) == "facet_var"] = facet_var
  
  dat
}

make_complete_anova_diff_plot = function(plot, dat) {
  
  plot +
    geom_path(inherit.aes = F, aes(x, y, group = group), data = dat) +
    geom_point(inherit.aes = F, aes(x, y, group = group), data = dat)
}

add_median_columns = function(data) {
  
  data$Lab_median[data$Lab_ACC >= median(data$Lab_ACC, na.rm = T)] = "above"
  data$Lab_median[data$Lab_ACC < median(data$Lab_ACC, na.rm = T)] = "below"
  data$Lab_median = as.factor(data$Lab_median)
  
  data$GN_median[data$GN_ACC >= median(data$GN_ACC, na.rm = T)] = "above"
  data$GN_median[data$GN_ACC < median(data$GN_ACC, na.rm = T)] = "below"
  data$GN_median = as.factor(data$GN_median)
  
  data$Ass_median[data$Ass_ACC >= median(data$Ass_ACC, na.rm = T)] = "above"
  data$Ass_median[data$Ass_ACC < median(data$Ass_ACC, na.rm = T)] = "below"
  data$Ass_median = as.factor(data$Ass_median)
  
  data$ToL_MadeEstim_median[data$ToL_MadeEstim >= median(data$ToL_MadeEstim, na.rm = T)] = "above"
  data$ToL_MadeEstim_median[data$ToL_MadeEstim < median(data$ToL_MadeEstim, na.rm = T)] = "below"
  data$ToL_MadeEstim_median = as.factor(data$ToL_MadeEstim_median)
  
  data$ToL_MadeMin_median[data$ToL_MadeMin >= median(data$ToL_MadeMin, na.rm = T)] = "above"
  data$ToL_MadeMin_median[data$ToL_MadeMin < median(data$ToL_MadeMin, na.rm = T)] = "below"
  data$ToL_MadeMin_median = as.factor(data$ToL_MadeMin_median)
  
  data
}

add_learning_columns = function(data, name) {
  data$start_end[data$trial < 50] = "start"
  data$start_end[data$run == "Run 1" & data$trial > 50] = "end"
  data$start_end[data$run == "Run 2" & data$trial > 50] = "end"
  sum_dat = ddply(data, .(SubjID, run, session, group2, training, start_end), summarize, part_ACC = mean(ACC, na.rm = T))
  start_dat = subset(sum_dat, start_end == "start")
  end_dat   = subset(sum_dat, start_end == "end")
  
  merge_dat = merge(start_dat, end_dat, by = c("SubjID", "run", "session", "group2", "training"), suffixes = c("_start", "_end"))
  diff_dat  = subset(merge_dat, select = colnames(merge_dat)[!colnames(merge_dat) %in% c("start_end_start", "start_end_end")])
  diff_dat$learning = with(diff_dat, part_ACC_end - part_ACC_start)
  diff_dat$learning_f[diff_dat$learning >= median(diff_dat$learning)] = "Increase"
  diff_dat$learning_f[diff_dat$learning < median(diff_dat$learning)] = "Decrease"
  diff_dat$learning_f = factor(diff_dat$learning_f, levels = c("Increase", "Decrease"))
  
  colnames(diff_dat) = c("SubjID", "run", "session", "group2", "training", paste(name, "_ACC_start", sep = ""), paste(name, "_ACC_end", sep = ""), paste(name, "_learning", sep = ""), paste(name, "_learning_f", sep = ""))
  
#   colnames(diff_dat)[colnames(diff_dat) == "learning"] = paste(name, "_learning", sep = "")
#   colnames(diff_dat)[colnames(diff_dat) == "learning_f"] = paste(name, "_learning_f", sep = "")
  
  diff_dat
}

create_learning_data = function() {
  learning_dat = merge(Lab_learning, Ass_learning, by = c("SubjID", "run", "session", "group2", "training"), all = T)
  learning_dat$Lab_Ass_ACC_start[!is.na(learning_dat$Lab_ACC_start)] = learning_dat$Lab_ACC_start[!is.na(learning_dat$Lab_ACC_start)]
  learning_dat$Lab_Ass_ACC_start[!is.na(learning_dat$Ass_ACC_start)] = learning_dat$Ass_ACC_start[!is.na(learning_dat$Ass_ACC_start)]
  learning_dat$Lab_Ass_ACC_end[!is.na(learning_dat$Lab_ACC_end)] = learning_dat$Lab_ACC_end[!is.na(learning_dat$Lab_ACC_end)]
  learning_dat$Lab_Ass_ACC_end[!is.na(learning_dat$Ass_ACC_end)] = learning_dat$Ass_ACC_end[!is.na(learning_dat$Ass_ACC_end)]
  learning_dat$Lab_Ass_learning[!is.na(learning_dat$Lab_learning)] = learning_dat$Lab_learning[!is.na(learning_dat$Lab_learning)]
  learning_dat$Lab_Ass_learning[!is.na(learning_dat$Ass_learning)] = learning_dat$Ass_learning[!is.na(learning_dat$Ass_learning)]
  learning_dat$Lab_Ass_learning_f[!is.na(learning_dat$Lab_learning_f)] = as.character(learning_dat$Lab_learning_f[!is.na(learning_dat$Lab_learning_f)])
  learning_dat$Lab_Ass_learning_f[!is.na(learning_dat$Ass_learning_f)] = as.character(learning_dat$Ass_learning_f[!is.na(learning_dat$Ass_learning_f)])
  learning_dat$Lab_Ass_learning_f = factor(learning_dat$Lab_Ass_learning_f, levels = c("Increase", "Decrease"))
  
  subset(learning_dat, select = c("SubjID", "run", "session", "group2", "training", "Lab_Ass_ACC_start", "Lab_Ass_ACC_end", "Lab_Ass_learning", "Lab_Ass_learning_f"))
}

create_fatigue_data = function() {
  learning_r1 = subset(learning_dat, run == "Run 1", select = c("SubjID", "session", "training", "Lab_Ass_ACC_start", "Lab_Ass_ACC_end"))
  learning_r2 = subset(learning_dat, run == "Run 2", select = c("SubjID", "session", "training", "Lab_Ass_ACC_start", "Lab_Ass_ACC_end"))
  
  merge_dat = merge(learning_r1, learning_r2, by = c("SubjID", "session", "training"), suffixes = c("_r1", "_r2"))
  merge_dat$Lab_Ass_fatigue = with(merge_dat, Lab_Ass_ACC_start_r1 - Lab_Ass_ACC_end_r2)
  merge_dat$Lab_Ass_fatigue_f[merge_dat$Lab_Ass_fatigue >= median(merge_dat$Lab_Ass_fatigue)] = "fatigue"
  merge_dat$Lab_Ass_fatigue_f[merge_dat$Lab_Ass_fatigue < median(merge_dat$Lab_Ass_fatigue)]  = "improve"
  merge_dat$Lab_Ass_fatigue_f = factor(merge_dat$Lab_Ass_fatigue_f)

  subset(merge_dat, select = c("SubjID", "session", "training", "Lab_Ass_fatigue", "Lab_Ass_fatigue_f"))
}

create_fatigue_data_old = function() {
  all_perf_r1 = subset(all_perf, run == "Run 1")
  all_perf_r2 = subset(all_perf, run == "Run 2")
  
  merge_dat = merge(all_perf_r1, all_perf_r2, by = c("SubjID", "training"), suffixes = c("_r1", "_r2"))
  merge_dat$Lab_fatigue = with(merge_dat, Lab_ACC_r2 - Lab_ACC_r1)
  merge_dat$Ass_fatigue = with(merge_dat, Ass_ACC_r2 - Ass_ACC_r1)
  merge_dat$Lab_fatigue_f[merge_dat$Lab_fatigue >= median(merge_dat$Lab_fatigue)] = "improve"
  merge_dat$Lab_fatigue_f[merge_dat$Lab_fatigue < median(merge_dat$Lab_fatigue)]  = "fatigue"
  merge_dat$Lab_fatigue_f = factor(merge_dat$Lab_fatigue_f)
  merge_dat$Ass_fatigue_f[merge_dat$Ass_fatigue >= median(merge_dat$Lab_fatigue)] = "improve"
  merge_dat$Ass_fatigue_f[merge_dat$Ass_fatigue < median(merge_dat$Lab_fatigue)]  = "fatigue"
  merge_dat$Ass_fatigue_f = factor(merge_dat$Ass_fatigue_f)
  subset(merge_dat, select = c("SubjID", "training", "Lab_fatigue", "Lab_fatigue_f", "Ass_fatigue", "Ass_fatigue_f"))
}



#################
### Plot data ###
#################

### Lab & Ass & GoNogo total ###

plot_labassgn_perf_total = function(data, variable, task_name) {
  
  if (task_name == "GoNogo") {
    perf_data = data
  } else {
    perf_data = data[data$testtrial == 1,]
  }
  
  sum_dat = ddply(perf_data, .(session, run, group2), summarize, mean_ACC = mean(ACC, na.rm = T), mean_RT = mean(RT, na.rm = T))
  
  if (variable == "ACC") {
    plot = ggplot(perf_data, aes(SubjID, ACC*100, fill = session)) +
      geom_hline(aes(yintercept = 100*mean_ACC, color = session), sum_dat) +
      coord_cartesian(ylim = c(0, 104))
  } else if (variable == "RT" & task_name == "GoNogo") {
    plot = ggplot(perf_data, aes(SubjID, RT/1000, fill = session)) +
      geom_hline(aes(yintercept = mean_RT/1000, color = session), sum_dat) +
      coord_cartesian(ylim = c(0, 1.5))
  } else if (variable == "RT") {
    plot = ggplot(perf_data, aes(SubjID, RT/1000, fill = session)) +
      geom_hline(aes(yintercept = mean_RT/1000, color = session), sum_dat) +
      coord_cartesian(ylim = c(0, 10))
  }
  
  plot = plot + stat_summary(fun.y = "mean", geom = "bar", na.rm = T) +
    labs(x = "Subject", y = variable, fill = "", title = paste(task_name, "overall", variable)) +
    theme(legend.position = "none") +
    facet_wrap(~run)
  
    if (variable == "ACC" & task_name != "GoNogo") {
      plot = plot + geom_hline(yintercept = 25) +
        geom_text(x = 7, y = 27, label = "chance")
    }
  
  plot
  
}

### ts ANOVA ###

plot_ts_anova = function(data, run, variable = "stay_prob") {
  
  if (variable == "stay_prob") {
    plot = ggplot(data[data$run %in% run,], aes(reward, stay_prob, fill = uncommon_trans)) +
      facet_wrap( ~ group2) +
      coord_cartesian(ylim = c(.5, 1))
    ylab = "Stay probability"
  } else if (variable == "diff_stay_prob") {
    plot = ggplot(data[data$run %in% run,], aes(reward, diff_stay_prob, fill = uncommon_trans)) +
      coord_cartesian(ylim = c(-.095, .14)) #+ facet_grid(~ training)
    ylab = "Delta stay"
  }
    
  plot = plot +
    stat_summary(fun.y = "mean", geom = "bar", position = "dodge") +
    labs(x = "", y = ylab, fill = "", title = run) #+
    # theme(legend.position = "none")
  
  if (variable == "stay_prob") {
    plot = plot + stat_summary(fun.data = "mean_cl_normal", mult = 1, geom = "pointrange", position = "position_dodge"(width = 0.9), width = 0.2)
  }
  
  plot
}

### ts total ###

plot_ts_perf_total = function(variable) {
  
  perf_data = ts
  perf_data$reward = as.character(perf_data$reward)
  perf_data$reward[perf_data$reward == "No reward"] = 0
  perf_data$reward[perf_data$reward == "Reward"] = 1
  perf_data$reward = as.numeric(perf_data$reward)
  
  sum_dat = ddply(perf_data, .(session, run, group2), summarize, mean_reward = mean(reward, na.rm = T), mean_RT = mean(RT1, na.rm = T) + mean(RT2, na.rm = T))
  
  if (variable == "reward") {
      plot = ggplot(perf_data, aes(SubjID, reward*100, fill = session)) +
        geom_hline(aes(yintercept = 100*mean_reward, color = session), sum_dat) +
        coord_cartesian(ylim = c(0, 104))
      y_lab = "Number of coins collected"
    
  } else if (variable == "RT") {
    plot = ggplot(perf_data, aes(SubjID, (RT1 + RT2)/1000, fill = session)) +
      geom_hline(aes(yintercept = mean_RT/1000, color = session), sum_dat) +
      coord_cartesian(ylim = c(0, 5))
    y_lab = "Reaction time of 1st and 2nd choice combined"
  }
  
  plot = plot + stat_summary(fun.y = "mean", geom = "bar", na.rm = T) +
    labs(x = "Subject", y = y_lab, fill = "", title = paste("2-step Task overall", variable)) +
    theme(legend.position = "none") +
    facet_wrap(group2 ~ run)
  
  plot
  
}

### ts stay probability (for each subject) ###

plot_ts_stay_prob = function(variable) {
  
  sum_dat = ddply(stay_dat, .(session, run, group2, training), summarize,
                  stays_total = mean(stays_total, na.rm = T),
                  stay_prob_rew = mean(stay_prob_rew, na.rm = T),
                  stay_prob_unrew = mean(stay_prob_unrew, na.rm = T))
  
  if        (variable == "stays_total") {
    plot = ggplot(stay_dat, aes(SubjID, stays_total, fill = training)) +
      geom_hline(aes(yintercept = stays_total, color = training), data = sum_dat)
    ylab = "Total number of stays after rare transistions"
    
  } else if (variable == "stay_prob_rew") {
    plot = ggplot(stay_dat, aes(SubjID, stay_prob_rew, fill = training)) +
      geom_hline(aes(yintercept = stay_prob_rew, color = training), data = sum_dat)
    ylab = "Probability of staying after rare transition (reward)"
    
  } else if (variable == "stay_prob_unrew") {
    plot = ggplot(stay_dat, aes(SubjID, stay_prob_unrew, fill = training)) +
      geom_hline(aes(yintercept = stay_prob_unrew, color = training), data = sum_dat)
    ylab = "Probability of staying after rare transition (NO reward)"
    
  }
  
  plot = plot +
    geom_bar(stat = "identity") +
#     theme(legend.position = "none") +
    labs(x = "", y = ylab, fill = "Training") +
    facet_wrap(session ~ run)  
  
  plot
}

### ts stay probability (mean) ###

plot_ts_stay_prob_total = function(variable, run) {
  
  if        (variable == "stay_prob_rew") {
    plot = ggplot(stay_dat[stay_dat$run == run,], aes(session, stay_prob_rew, fill = training))
    ylab = "Probability of staying after rare transition (reward)"
  } else if (variable == "stay_prob_unrew") {
    plot = ggplot(stay_dat[stay_dat$run == run,], aes(session, stay_prob_unrew, fill = training))
    ylab = "Probability of staying after rare transition (NO reward)"
  }
  
  plot = plot +
    geom_boxplot() +
#     stat_summary(fun.y = "mean", geom = "bar", position = "dodge") +
#     stat_summary(fun.dat = "mean_cl_normal", geom = "pointrange", position = "position_dodge"(width = 0.9), width = 0.2) +
    labs(x = "", y = ylab, fill = "Training", title = run) +
    coord_cartesian(ylim = c(0, 1)) +
    theme(legend.position = "none") +
    facet_wrap(~ training)
  
  plot
}

### Lab & Ass & GoNogo over time ###

plot_labassgn_perf_over_time = function(data, variable, task_name, section_size = 20) {
  
  ## Define "perf_data"
  if (task_name == "GoNogo") {
    perf_data = GN
  } else {
    perf_data = data[data$testtrial == 1,]
  }
  
  ## Add column "section" to perf_data
  perf_data$section = NA
  
  for (trial in seq(100, 10, -section_size)) {
    perf_data$section[perf_data$trial <= trial] = trial
  }

  ## Start plotting: Define aesthetics, depending on task and outcome variable
  if        (variable == "ACC") {
    plot = ggplot(perf_data, aes(section, ACC*100, color = session, group = SubjID)) +
      coord_cartesian(ylim = c(0, 104))
  } else if (variable == "RT" & task_name == "GoNogo") {
    plot = ggplot(perf_data, aes(section, RT/1000, color = session, group = SubjID)) +
      coord_cartesian(ylim = c(0, 1.5))
  } else if (variable == "RT") {
    plot = ggplot(perf_data, aes(section, RT/1000, color = session, group = SubjID)) +
      coord_cartesian(ylim = c(0, 10))
  }
  
  ## Finish the plot: Add labs and facet_wrap
  plot = plot + stat_summary(fun.y = "mean", geom = "line", position = "jitter", na.rm = T) +
    labs(x = "Trials", y = variable, color = "", title = paste(task_name, variable, "over time")) +
#     theme(legend.position = "none") +
    facet_wrap(~run)
  
  ## Return the plot AND the new perf_data data frame
  return(list(plot, perf_data))

}


### ToL total ###

plot_ToL_perf = function(data, variable, title, ylab) {
  
  if (variable == "Made_minus_EstimMoves") {
    plot = ggplot(data, aes(SubjID, Made_minus_EstimMoves, color = session))
  }
  else if (variable == "Made_minus_MinMoves") {
    plot = ggplot(data, aes(SubjID, Made_minus_MinMoves, color = session))
  }
  
  plot + geom_boxplot() +
    labs(x = "Subject ID", y = ylab, color = "", title = title) +
    scale_y_continuous(breaks = 0:15) +
    theme(legend.position = "none") +
    facet_wrap(~run)

}

### ToL difference scores ###

plot_ToL_diffscores = function() {
  
  ToL_MadeMin_dat   = cast(M_based, SubjID ~ run, value = "ToL_MadeMin")
  ToL_MadeEstim_dat = cast(M_based, SubjID ~ run, value = "ToL_MadeEstim")
  
  ToL_dat = merge(ToL_MadeMin_dat, ToL_MadeEstim_dat, by = "SubjID")
  ToL_dat$session = M_based$session[M_based$run == "Run 1"]
  colnames(ToL_dat) = c("SubjID", "MadeMin1", "MadeMin2", "MadeEstim1", "MadeEstim2", "session")
  
  MadeMin_name = "Change in (made - optimal number of moves)"
  MadeEstim_name = "Change in (estimated - made number of moves)"
  
  ToL_dat[,MadeMin_name]   = with(ToL_dat, abs(MadeMin2) - abs(MadeMin1))
  ToL_dat[,MadeEstim_name] = with(ToL_dat, abs(MadeEstim2) - abs(MadeEstim1))
  
  molten_ToL = melt(ToL_dat, id.vars = c("SubjID", "session"), measure.vars = c(MadeMin_name, MadeEstim_name))
  
  ggplot(molten_ToL, aes(SubjID, value, color = session)) +
    geom_point(stat = "identity") +
    geom_hline(yintercept = 0) +
    labs(x = "Subject ID", y = "Changes from 1st to 2nd run (2nd - 1st)", color = "") +
    theme(legend.position = "none") +
    facet_grid(~ variable)
  
}


############################
### Inference Statistics ###
############################

### Repeated-measures ANOVA / multilevel linear regression ###

calc_LME = function(variable, run) {

  if        (variable == "stay_prob_rew") {
    baseline_model = lme(stay_prob_rew ~ 1, random = ~1|SubjID/session, data = stay_dat[stay_dat$run == run,], method = "ML")
  } else if (variable == "stay_prob_unrew") {
    baseline_model = lme(stay_prob_unrew ~ 1, random = ~1|SubjID/session, data = stay_dat[stay_dat$run == run,], method = "ML")
  }
  
  group_model = update(baseline_model, .~. + group2)
  session_model = update(group_model, .~. + session)
  whole_model_gr = update(baseline_model, .~ group2*session)
  group_models = list(baseline_model, group_model, session_model, whole_model_gr)
  
  training_model = update(baseline_model, .~. + training)
  session_model = update(training_model, .~. + session)
  whole_model_tr = update(baseline_model, .~ training*session)
  training_models = list(baseline_model, training_model, session_model, whole_model_tr)
  
  list(group_models, training_models)
}
