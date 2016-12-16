function genrec_plots(Data, genrec)

%% Get Agent data and genrec columns names
genrec_columns;
data_columns;
today = date;
now = clock;
hour = num2str(now(4));
minute = num2str(now(5));
time = [hour '.' minute];
label = 'free_agents_free_sim';
    
%% Plot all true and fitted alphas and betas against each other
BIC = mean(genrec(:,20));
figure
for i = 1:length(gen_aabblwpk_c)
    subplot(3, 3, i)
    scatter(genrec(:, gen_aabblwpk_c(i)), genrec(:, rec_aabblwpk_c(i)))
    lsline
end
saveas(gcf, ['Plots/TrueFittedAll', today, '4.png'])

%% Look at difference between mb values, mf values, and combined values
clear Agent
agent = 1;
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
saveas(gcf, ['Plots/Qs' today '_' time '_' label '.png'])

end