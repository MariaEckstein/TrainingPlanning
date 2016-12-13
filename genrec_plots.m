function genrec_plots(Data, genrec)

%% Get Agent data
clear Agent
agent = 1;
agent_rows = Data.AgentID == agent;
Agent.frac1 = Data.frac1(agent_rows);
Agent.frac2 = Data.frac2(agent_rows);
Agent.Q1 = Data.Q1(agent_rows, :);
Agent.Q2 = Data.Q2(agent_rows, :);
Agent.Qmb1 = Data.Qmb1(agent_rows, :);
Agent.Qmb2 = Data.Qmb2(agent_rows, :);
Agent.Qmf1 = Data.Qmf1(agent_rows, :);
Agent.Qmf2 = Data.Qmf2(agent_rows, :);
Agent.reward = Data.reward(agent_rows);
true_par = Data.par(agent_rows, :);
Agent.par = true_par(1, :);


%% Look at difference between mb values, mf values, and combined values
figure
subplot(2, 3, 1)
plot(Agent.Q1)
title('Q1')
subplot(2, 3, 2)
plot(Agent.Qmf1)
title('Q1 (mf)')
subplot(2, 3, 3)
plot(Agent.Qmb1)
title('Q1 (mb)')
subplot(2, 3, 4)
plot(Agent.Q2)
title('Q2')
subplot(2, 3, 5)
plot(Agent.Qmf2)
title('Q2 (mf)')
subplot(2, 3, 6)
plot(Agent.Qmb2)
title('Q2 (mb)')
saveas(gcf, ['MBMFQ', today, '2.png'])


%% Plot all true and fitted alphas and betas against each other
figure
subplot(3, 2, 1)
scatter(genrec.a1(1:length(genrec.fa1)), genrec.fa1)
lsline
title('Alpha 1')
subplot(3, 2, 2)
scatter(genrec.a2(1:length(genrec.fa2)), genrec.fa2)
lsline
title('Alpha 2')
subplot(3, 2, 3)
scatter(genrec.b1(1:length(genrec.fb1)), genrec.fb1)
lsline
title('Beta 1')
subplot(3, 2, 4)
scatter(genrec.b2(1:length(genrec.fb2)), genrec.fb2)
lsline
title('Beta 2')
subplot(3, 2, 5)
scatter(genrec.l(1:length(genrec.fl)), genrec.fl)
lsline
title('Lambda')
subplot(3, 2, 6)
scatter(genrec.w(1:length(genrec.fw)), genrec.fw)
lsline
title('W')
saveas(gcf, ['TrueFittedAll', today, '2.png'])

end