function genrec_plots(Data, genrec)

%% Put dataframes together
genrec_all = [];
for fileID = 1:4
    load(['genrec_real_agents_hyb_sim' num2str(fileID) '.mat'])
    genrec_all = [genrec_all; genrec];
end
genrec = genrec_all;
save('genrec_real_agents_hyb_sim.mat', 'genrec')

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
