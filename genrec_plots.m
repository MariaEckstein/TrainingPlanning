function genrec_plots(Data, genrec)

% %% Put dataframes together
% genrec_all = [];
% for fileID = 1:4
%     load(['genrec_real_agents_hyb_sim' num2str(fileID) '.mat'])
%     genrec_all = [genrec_all; genrec];
% end
% genrec = genrec_all;
% save('genrec_real_agents_hyb_sim.mat', 'genrec')

%% Get Agent data and genrec columns names
genrec_columns;
data_columns;

%% Plot all true and fitted values against each other
% genrec=genrec(1:91,:)
n_bins = 25;   % determine how fine-graned the histogram will be
BIC = mean(genrec(:,NLLBICAIC_c(2)))
figure
for i = 1:8%length(gen_aabblwpk_c)
    subplot(3, 3, i)
    scatter(genrec(:, gen_aabblwpk_c(i)), genrec(:, rec_aabblwpk_c(i)))
    lsline
    xlim([0 1])
    ylim([0 1])
end
subplot(3, 3, 9)   % add BIC
histogram(genrec(:,NLLBICAIC_c(2)), n_bins)
title(['av.BIC=' num2str(round(BIC))])

%% Plot results of fitting models to humans
genrec = sortrows(genrec, [agentID_c run_c]);   % sort by agentID and runID
[n_agents, ~] = size(genrec);
BIC = mean(genrec(:,NLLBICAIC_c(2)))   % get average BIC per agent
n_bins = 25;   % determine how fine-graned the histogram will be
figure
for i = 1:8   % plot parameters
    subplot(3, 3, i)
    histogram(genrec(:, rec_aabblwpk_c(i)), n_bins)
    lsline
    xlim([0 1])
    ylim([0 n_agents])
end
subplot(3, 3, 9)   % add BIC
histogram(genrec(:,NLLBICAIC_c(2)), n_bins)
ylim([0 n_agents])
title(['av.BIC=' num2str(round(BIC))])

%% Look at difference between mb values, mf values, and combined values
clear Agent
agent = 5;
agent_rows = Data(:, AgentID_c) == agent;
Agent = Data(agent_rows, :);
figure
subplot(2, 3, 1)
plot(Agent(:, Q1_c))
title('Q1')
subplot(2, 3, 2)
plot(Agent(:, Qmf1_c))
title('Q1 (mf)')
subplot(2, 3, 3)
plot(Agent(:,Qmb1_c))
title('Q1 (mb)')
subplot(2, 3, 4)
plot(Agent(:,Q2_c))
title('Q2')
subplot(2, 3, 5)
plot(Agent(:,Qmf2_c))
title('Q2 (mf)')
subplot(2, 3, 6)
plot(Agent(:,Qmb2_c))
title('Q2 (mb)')

%% Compare Klaus' and my models
%%% Plot values over time
figure
subplot(3, 2, 1)
plot(1:length(V), V(:,1:2))
subplot(3, 2, 2)
plot(1:length(V), V(:,3:6))
subplot(3, 2, 3)
plot(1:length(M), M(:,1:2))
subplot(3, 2, 5)
plot(1:length(Q), Q(:,1:2))

%%% Plot action probabilities
figure
subplot(1, 2, 1)
plot(1:length(P), P(:,1:2))
subplot(1, 2, 2)
plot(1:length(P), P(:,3:6))

%%% Compare fitted parameters between models
% load('genrec_real_agents_a1b1_l0_nok_sim_21-Apr-2017_23.mat')
% load('genrec_real_agents_hyb_sim_22-Apr-2017_3.29.mat')
% load('genrec_real_agents_a1b1_l0_nok_sim_22-Apr-2017_3.42.mat')
% load('genrec_real_agents_hyb_sim_22-Apr-2017_5.7.mat')
% load('pars4.mat')
% load('genrec_real_agents_a1b1_l0_nok_sim_20-Apr-2017_0.mat')
% load('pars2.mat')

load('genrec_real_agents_hyb_sim_22-Apr-2017_4.5.mat')
load('genrec_real_agents_a1b1_l0_nok_sim_22-Apr-2017_5.49.mat')
load('genrec_real_agents_hyb_sim_22-Apr-2017_6.29.mat')
load('pars_bugfix.mat')
genrec1 = genrec(genrec(:, 1) ~= 0, :);   % remove empty rows
pars1 = pars(pars(:, 3) ~= 0, :);   % remove empty rows
try pars1 = pars1(1:size(genrec1, 1), :);   % make genrec_dat1 the same length as genrec_dat2
catch genrec1 = genrec1(1:size(pars1, 1), :);   % make genrec_dat2 the same length as genrec_dat1
end
try pars1 = pars1(1:size(genrec1, 1), :);   % make pars1 the same length as pars2
catch genrec1 = genrec1(1:size(pars1, 1), :);   % make pars2 the same length as pars1
end

genrec_cols = [rec_aabblwpk_c(2) rec_aabblwpk_c(4)...  % alpha, beta, p, w
    rec_aabblwpk_c(7) rec_aabblwpk_c(6)];

figure
for pl = 1:4
    subplot(2, 2, pl)
    scatter(pars1(:,pl), genrec1(:, genrec_cols(pl)))  % alpha, beta, p, w
    lsline
end

%%% Compare fitted parameters within models
% load('genrec_real_agents_a1b1_l0_nok_sim_20-Apr-2017_9.mat')
% load('genrec_real_agents_a1b1_l0_nok_sim_22-Apr-2017_3.36.mat')
% load('genrec_real_agents_hyb_sim_22-Apr-2017_4.11.mat')

load('genrec_real_agents_hyb_sim_22-Apr-2017_5.7.mat')
load('genrec_real_agents_a1b1_l0_nok_sim_22-Apr-2017_6.10.mat')
load('genrec_real_agents_hyb_sim_22-Apr-2017_6.35.mat')
load('pars3.mat')
genrec2 = genrec(genrec(:, 1) ~= 0, :);   % remove empty rows
try genrec1 = genrec1(1:size(genrec2, 1), :);   % make genrec_dat1 the same length as genrec_dat2
catch genrec2 = genrec_dat2(1:size(genrec1, 1), :);   % make genrec_dat2 the same length as genrec_dat1
end
pars2 = pars(pars(:, 3) ~= 0, :);   % remove empty rows
try pars1 = pars1(1:size(pars2, 1), :);   % make pars1 the same length as pars2
catch pars2 = pars2(1:size(pars1, 1), :);   % make pars2 the same length as pars1
end

figure
for pl = 1:4
    subplot(2, 4, pl)
    scatter(pars1(:,pl), pars2(:,pl))
    lsline    
    subplot(2, 4, pl + 4)
    scatter(genrec1(:,genrec_cols(pl)), genrec2(:,genrec_cols(pl)))
    lsline
end