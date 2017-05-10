function [lik, X] = lik_rl1(trial, par, parMS)
% function [lik, prob] = lik2step(trial, par)
% Parameter fitting for 2step task
% kwunder@fil.ion.ucl.ac.uk

%% Columns in the log file
% 
% 1. trial number
% 2. first stage keypress
% 3. second stage keypress
% 4. first stage stimulus chosen
% 5. second stage stimulus chosen
% 6. second stage pair shown
% 7. rt first stage
% 8. rt second stage
% 9. ITI going into this trial
% 10. reward received
% 11. 1st phase, stimulus left
% 12. 1st phase, stimulus right
% 13. 2nd phase, stimulus left
% 14. 2nd phase, stimulus right
% 15. common (0) or uncommon (1) transition

% par = [.1 .1 1 1 1 0 .5];  % model with lambda == 1
% par = [.1 .1 1 1 0 0 .5];   % model with lambda == 0

% load(file_path)
% trial = params.user.log;

missed = zeros(length(trial),1);
reward = trial(:,10);
ch1 = trial(:,4); choice1 = zeros(length(ch1),2); for i=1:length(ch1), try, choice1(i,ch1(i)) = 1; catch, missed(i) = 1; end; end
ch2 = trial(:,5); choice2 = zeros(length(ch2),6); for i=1:length(ch2), try, choice2(i,ch2(i)) = 1; catch, missed(i) = 2; end; end

valid = find(missed == 0);

% choice2 = [1 0 0 0]; choice1 = [1 0];
reward = reward(valid);
choice1 = choice1(valid,:); ch1 = ch1(valid);
choice2 = choice2(valid,:); ch2 = ch2(valid);
choice = [choice1 choice2(:,3:6)];

%% parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if length(par) == 7
    alpha1 = par(1);  % RL 1
    alpha2 = par(2);  % RL 2
    beta1  = par(3);  % temp 1
    beta2  = par(4);  % temp 2
    lambda = par(5);  % Elegibility trace discount
    p = par(6);       % perseveration
    w = par(7);       % weight model/free
elseif length(par) == 6
    alpha1 = par(1);  % RL 1
    alpha2 = par(2);  % RL 2
    beta1  = par(3);  % temp 1
    beta2  = par(4);  % temp 2
    lambda = 0;  % Elegibility trace discount
    p = par(5);       % perseveration
    w = par(6);       % weight model/free
elseif length(par) == 4
    alpha1 =  par(1); alpha2 = par(1); %1./(1+exp(-par(1)));  % RL 1
    beta1  = par(2); beta2  = par(2); %exp(par(2));  % temp 1
    p = par(3); %exp(par(3));       % perseveration
    w = par(4); %1./(1+exp(-par(4)));       % weight model/free
    lambda = 0;
end    
%% model-free model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rescorlawagner of 2nd stage
clear V;
V(1,1:6) = 0.5;
for i=1:length(reward)
    delta2(i,1) = reward(i) - sum(V(i,1:6).*choice2(i,:));
    V(i+1,1:6) = V(i,1:6) + alpha2 * repmat(delta2(i),1,6).*choice2(i,:);
end

% rescorlawagner of 1st stage
v2 = sum(V(1:length(reward),:).*choice2,2);
for i=1:length(reward)
    delta1(i,1) = v2(i) - sum(V(i,1:2).*choice1(i,:));
    V(i+1,1:2) = V(i,1:2) + alpha1 * repmat(delta1(i),1,2).*choice1(i,:) + alpha1*lambda * repmat(delta2(i),1,2).*choice1(i,:);
end
V(end,:) = [];


%% model-based model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear M
M(:,3) = max(V(:,3:4),[],2);
M(:,4) = max(V(:,5:6),[],2);
M(:,1) = 0.7*M(:,3) + 0.3*M(:,4);
M(:,2) = 0.3*M(:,3) + 0.7*M(:,4);


%% repetition perseveration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dchoice = [0 0; diff(choice1)];
rep = (dchoice==0).* (choice1==1);
rep(:,3) = sum(rep,2);

C = [0 0; choice1(1:end-1,:)];
%% action probability
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Q = M(:,1:2); %w*M(:,1:2) + (1-w)*V(:,1:2);
Q = w*M(:,1:2) + (1-w)*V(:,1:2);
Q(:,3:6) = V(:,3:6);

clear P
P(:,1) = 1./ ( 1 + exp(- (beta1*( Q(:,1)-Q(:,2)) + p*(C(:,1)-C(:,2)) ))  );
P(:,2) = 1./ ( 1 + exp(- (beta1*( Q(:,2)-Q(:,1)) + p*(C(:,2)-C(:,1)) ))  );
% P(:,2) = exp(beta1*(Q(:,2))) ./ ( exp(beta1*(Q(:,1))) + exp(beta1*(Q(:,2))) );
% P(:,1) = exp(beta1*(Q(:,1))) ./ ( exp(beta1*(Q(:,1))) + exp(beta1*(Q(:,2))) );
% P(:,2) = exp(beta1*(Q(:,2))) ./ ( exp(beta1*(Q(:,1))) + exp(beta1*(Q(:,2))) );

P(:,3) = exp(beta2*(Q(:,3))) ./ ( exp(beta2*(Q(:,3))) + exp(beta2*(Q(:,4))) );
P(:,4) = exp(beta2*(Q(:,4))) ./ ( exp(beta2*(Q(:,3))) + exp(beta2*(Q(:,4))) );
P(:,5) = exp(beta2*(Q(:,5))) ./ ( exp(beta2*(Q(:,5))) + exp(beta2*(Q(:,6))) );
P(:,6) = exp(beta2*(Q(:,6))) ./ ( exp(beta2*(Q(:,5))) + exp(beta2*(Q(:,6))) );


%% Likelihoods
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

prob = P .* choice; prob(prob==0)=nan;
loglik = nansum(-log(prob),2);
lik = sum(loglik);
LL_k = [nansum(log(prob(:,1:2)), 2) nansum(log(prob(:,3:6)), 2)];  % just for plotting

X.V= V; X.Q=Q; X.M=M; X.P = P; 
X.L = prob;
X.BIC = -2*sum(nansum(log(prob),2)) + length(par)*(log(2*length(trial))-log(2*pi)); 
X.AIC = -2*sum(nansum(log(prob),2)) + 2*length(par);
X.NLL = lik;

% calculate group data if nargin > 2
par(par == 0) = 0.0000001;
par_n = -log(1./par - 1);
if length(par) == 4
    par_n(2) = log(par(2)); % b: inverse function to convert pars into -inf..inf space
    par_n(3) = log(par(3)+5); % p: inverse function to convert pars into -inf..inf space
elseif length(par) == 6
    par_n([3 4]) = log(par([3 4]));  % b1 b2
    par_n(5) = log(par(5)+5);  % p
elseif length(par) == 7
    par_n([3 4]) = log(par([3 4])); % b1 b2
    par_n(6) = log(par(6)+5); % p
else
    error('numpar wrong');
end
X.par_n = par_n;    
X.par = par;

if nargin > 2    
    % calculate penalty 
    for k=1:length(par)
        pdf_penalty(k) = normpdf(par_n(k), parMS(1,k), parMS(2,k));
    end
    X.pdf_penalty = pdf_penalty;
    lik = lik - length(trial) * sum(log(pdf_penalty));
end