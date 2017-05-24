
%% Get means and sd's for parameters of all of Klaus' models
genrec_columns;
load('all_genrec.mat')
epsilon = 0.0000001;
all_genrec(all_genrec < epsilon) = epsilon;
all_genrec(all_genrec > 1 - epsilon) = 1 - epsilon;
for n_par = [4 6 7]
    K1_pars = all_genrec(...
        all_genrec(:,2) == 103 & ...  % Klaus' model (103 is definitely Klaus model here because beta goes up to 100 and p up to 5; it differs for the new results though, there 112 is my model)
        all_genrec(:,3) > 0.5 & ...    % Flat (< 0.5) or hierarchical (> 0.5) version?
        all_genrec(:,4) == n_par, ... % 4, 6, or 7-parameter model
        rec_aabblwpk_c);            % only the parameter columns
%     K1_pars = K1_pars(1:5,:);   % for debugging
    switch n_par
        case 4
            par = K1_pars(:,[2 4 7 6]);   % a, b, p, w
            par_n4_raw = par;
            par_n = -log(1./par - 1);   % a, w
            par_n(:,2) = log(par(:,2));   % b: inverse function to convert pars into -inf..inf space
            par_n(:,3) = log(par(:,3)+5);   % p: inverse function to convert pars into -inf..inf space
            par_n4 = par_n;
        case 6
            par = K1_pars(:,[1:4 7 6]);   % a1, a2, b1, b2, p, w
            par_n6_raw = par;
            par_n = -log(1./par - 1);
            par_n(:,[3 4]) = log(par(:,[3 4]));
            par_n(:,5) = log(par(:,5)+5);
            par_n6 = par_n;
        case 7
            par = K1_pars(:,[1:5 7 6]);   % a1, a2, b1, b2, l, p, w
            par_n7_raw = par;
            par_n = -log(1./par - 1);
            par_n(:,[3 4]) = log(par(:,[3 4]));
            par_n(:,6) = log(par(:,6)+5);
            par_n7 = par_n;
    end
end

for i_par = 1:4
    sd_4pars(i_par) = nanstd(par_n4(:,i_par));
end
for i_par = 1:6
    sd_6pars(i_par) = nanstd(par_n6(:,i_par));
end
for i_par = 1:7
    sd_7pars(i_par) = nanstd(par_n7(:,i_par));
end

for i_par = 1:4
    mean_4pars(i_par) = nanmean(par_n4(:,i_par));
end
for i_par = 1:6
    mean_6pars(i_par) = nanmean(par_n6(:,i_par));
end
for i_par = 1:7
    mean_7pars(i_par) = nanmean(par_n7(:,i_par));
end

M = mean_4pars
S = cov(par_n4)

mvnpdf(M,M,S)

figure
subplot(2, 3, 1)
plot(par_n4, '.')
legend('alpha', 'beta', 'p', 'w')
subplot(2, 3, 2)
plot(par_n6, '.')
legend('a1', 'a2', 'b1', 'b2', 'p', 'w')
subplot(2, 3, 3)
plot(par_n7, '.')
legend('a1', 'a2', 'b1', 'b2', 'l', 'p', 'w')

subplot(2, 3, 4)
plot(par_n4_raw, '.')
legend('alpha', 'beta', 'p', 'w')
subplot(2, 3, 5)
plot(par_n6_raw, '.')
legend('a1', 'a2', 'b1', 'b2', 'p', 'w')
subplot(2, 3, 6)
plot(par_n7_raw, '.')
legend('a1', 'a2', 'b1', 'b2', 'l', 'p', 'w')

figure
for par = 1:size(par_n4, 2)
    subplot(3, 7, par)
    histogram(par_n4(:,par))
end

for par = 1:size(par_n6, 2)
    subplot(3, 7, par + 7)
    histogram(par_n6(:,par))
end

for par = 1:size(par_n7, 2)
    subplot(3, 7, par + 14)
    histogram(par_n7(:,par))
end
