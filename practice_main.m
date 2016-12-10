genrec = simulate_task(10);

%% Plot estimated and real parameters
figure
subplot(1,2,1)
scatter(genrec(:,1),genrec(:,2))
lsline

subplot(1,2,2)
scatter(genrec(:,1),genrec(:,3))
lsline

