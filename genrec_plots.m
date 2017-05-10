function genrec_plots(Data, genrec)

%% Get Agent data and genrec columns names
genrec_columns;
data_columns;

%% Plot all true and fitted values against each other
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

%%% Plot log likelihoods of each trial
figure
subplot(2, 1, 1)
plot(1:size(LL_k,1), LL_k)   % klaus
subplot(2, 1, 2)
plot(1:size(LL,1), LL)   % maria

%%% Compare fitted parameters between models
load('all_pars.mat')
v1_pars = all_pars(all_pars(:,3) == 1,:);
v2_pars = all_pars(all_pars(:,3) == 2,:);

% Compare Klaus' and Maria's 4-parameter models
n4_K = v1_pars(v1_pars(:,4) == 7 & v1_pars(:,2) == 103,:);
n4_M = v1_pars(v1_pars(:,4) == 7 & v1_pars(:,2) == 112,:);
n4_M = n4_M(1:425,:);
figure
for pl = 1:8
    subplot(3, 3, pl)
    scatter(n4_K(:, rec_aabblwpk_c(pl)), n4_M(:, rec_aabblwpk_c(pl)))  % alpha, beta, p, w
    lsline
end

% Compare Klaus' and Maria's 6-parameter models
figure
for pl = 1:6
    subplot(2, 3, pl)
    scatter(pars6(:,pl), genrec6(:, genrec_cols6(pl)))  % alpha, beta, p, w
    lsline
end

% Compare Klaus' and Maria's 7-parameter models
figure
for pl = 1:7
    subplot(2, 4, pl)
    scatter(pars7(:,pl), genrec7(:, genrec_cols7(pl)))  % alpha, beta, p, w
    lsline
end

% Compare Klaus' 4- and 6-parameter models
figure
subplot(2, 2, 1)
scatter(pars4(:,1), pars6(:,1))
subplot(2, 2, 2)
scatter(pars4(:,2), pars6(:,3))
subplot(2, 2, 3)
scatter(pars4(:,3), pars6(:,5))
subplot(2, 2, 4)
scatter(pars4(:,4), pars6(:,6))

figure
for i = 1:4
    subplot(2, 2, i)
    scatter(genrec4(:,genrec_cols4(i)), genrec6(:,genrec_cols4(i)))
end

% 6-params vs 7-params
figure
for i = 1:4
    subplot(2, 3, i)
    scatter(pars7(:,i), pars6(:,i))
end
subplot(2, 3, 5)
scatter(pars7(:,6), pars6(:,5))
subplot(2, 3, 6)
scatter(pars7(:,7), pars6(:,6))

figure
for i = 1:6
    subplot(2, 3, i)
    scatter(genrec7(:,genrec_cols6(i)), genrec6(:,genrec_cols6(i)))
end

%%% Compare fitted parameters within models
% 4-parameter models
load('genrec_real_agents_a1b1_l0_nok_sim_24-Apr-2017_1.48.mat')
load('pars_46.mat')
load('all_pars_42.mat')
% 6-parameter models
load('genrec_real_agents_nok_l0_sim_24-Apr-2017_1.45.mat')
load('pars_66.mat')
load('all_pars_62.mat')
% 7-parameter models
load('genrec_real_agents_nok_sim_24-Apr-2017_1.47.mat')
load('pars_76.mat')

genrec2 = genrec(genrec(:, 1) ~= 0, :);   % remove empty rows
try genrec4 = genrec4(1:size(genrec2, 1), :);   % make genrec_dat1 the same length as genrec_dat2
catch genrec2 = genrec2(1:size(genrec1, 1), :);   % make genrec_dat2 the same length as genrec_dat1
end
pars2 = pars(pars(:, 3) ~= 0, :);   % remove empty rows
try pars4 = pars4(1:size(pars2, 1), :);   % make pars1 the same length as pars2
catch pars2 = pars2(1:size(pars1, 1), :);   % make pars2 the same length as pars1
end

figure
for pl = 1:size(pars4, 2)
    subplot(2, 4, pl)
    scatter(all_pars_41(:,genrec_cols4(pl)), all_pars_42(:,genrec_cols4(pl)))
    lsline
    subplot(2, size(pars4, 2), pl + size(pars4, 2))
    scatter(genrec4(:,genrec_cols4(pl)), genrec2(:,genrec_cols4(pl)))
    lsline
end

% Running Klaus' model on cluster leads to same results 
figure
for pl = 1:4
    subplot(2, 2, pl)
    scatter(all_pars_41(:,genrec_cols4(pl)), pars(:,pl))
    lsline
end
