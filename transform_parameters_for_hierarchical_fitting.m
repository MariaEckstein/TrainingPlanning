
%% Get means and sd's for parameters of all of Klaus' models
genrec_columns;
load('all_genrec.mat')
all_genrec(all_genrec == 0) = 0.0000001;
all_genrec(all_genrec == 1) = 0.9999999;
for n_par = [4 6 7]
    K1_pars = all_genrec(...
        all_genrec(:,2) == 103 & ...  % Klaus' model (103 is definitely Klaus model here because beta goes up to 100 and p up to 5; it differs for the new results though, there 112 is my model)
        all_genrec(:,3) > 0.5 & ...    % Flat version
        all_genrec(:,4) == n_par, ... % 4, 6, or 7-parameter model
        rec_aabblwpk_c);            % only the parameter columns
%     K1_pars = K1_pars(1:5,:);   % for debugging
    switch n_par
        case 4
            par = K1_pars(:,[2 4 7 6]);   % a, b, p, w
            par_n = -log(1./par - 1);   % a, w
            par_n(:,2) = log(par(:,2));   % b: inverse function to convert pars into -inf..inf space
            par_n(:,3) = log(par(:,3)+5);   % p: inverse function to convert pars into -inf..inf space
            par_n4 = par_n;
        case 6
            par = K1_pars(:,[1:4 7 6]);   % a1, a2, b1, b2, p, w
            par_n = -log(1./par - 1);
            par_n(:,[3 4]) = log(par(:,[3 4]));
            par_n(:,5) = log(par(:,5)+5);
            par_n6 = par_n;
        case 7
            par = K1_pars(:,[1:5 7 6]);   % a1, a2, b1, b2, l, p, w
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

% par_n4(par_n4 > quantile(par_n4, 0.9) | par_n4 < quantile(par_n4, 0.1)) = nan;
% par_n6(par_n6 > quantile(par_n6, 0.9) | par_n6 < quantile(par_n6, 0.1)) = nan;
% par_n7(par_n7 > quantile(par_n7, 0.9) | par_n7 < quantile(par_n7, 0.1)) = nan;

for i_par = 1:4
    mean_4pars(i_par) = nanmedian(par_n4(:,i_par));
end
for i_par = 1:6
    mean_6pars(i_par) = nanmedian(par_n6(:,i_par));
end
for i_par = 1:7
    mean_7pars(i_par) = nanmedian(par_n7(:,i_par));
end

figure
subplot(2, 2, 1)
plot(par_n4, '.')
legend('alpha', 'beta', 'p', 'w')
subplot(2, 2, 2)
plot(par_n6, '.')
legend('a1', 'a2', 'b1', 'b2', 'p', 'w')
subplot(2, 2, 3)
plot(par_n7, '.')
legend('a1', 'a2', 'b1', 'b2', 'l', 'p', 'w')
