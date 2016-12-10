function simulate
beta = 8;
ntrials = 100;
p = [0.25 .75];


for repetition=1:100
repetition
alpha = .5*rand;
Q = [.5 .5];
for t = 1:ntrials
    pr =1/(1+exp(beta*(Q(1)-Q(2))));
    a = 1+(rand<pr);
    
    r = rand<p(a);
    Q(a) = Q(a)+alpha*(r-Q(a));
    sa(t)=a;
    sr(t)=r;
    sQ(t,:)=Q;
end
% 
% figure
% plot(sQ)
% hold on
% plot(sa-1,'*')
% plot(sr,'o')

params=fitRL(sa,sr);
params(2)=params(2)*100;

genrec(repetition,:)=[alpha,params];
end

figure
subplot(1,2,1)
scatter(genrec(:,1),genrec(:,2))
lsline

subplot(1,2,2)
scatter(genrec(:,1),genrec(:,3))
lsline

end


function params = fitRL(sa,sr)
global D;D=[sa;sr];
% options = optimset('display','off');
pmin =[0 0];
pmax = [1 1];

% for iter = 1:20
par0 = pmin + rand(1,length(pmin)).*(pmax-pmin);
% [X,FVAL,EXITFLAG,OUTPUT] =fmincon(@computellh,par0,[],[],[],[],pmin,pmax,[],options);
% results(iter,:)=[X FVAL];

options = optimoptions(@fmincon,'Algorithm','sqp');
problem = createOptimProblem('fmincon','objective',...
 @computellh,'x0',par0,'lb',pmin,'ub',pmax,'options',options);
ms = MultiStart;
[x,f] = run(ms,problem,20)
% end

% [~,i]=min(results(:,end));
params = x;
end


function llh=computellh(par)
Q = [.5 .5];
alpha = par(1);
beta = 100*par(2);
epsilon = .00001;

global D;
sa =D(1,:);
sr=D(2,:);
ntrials =length(sa);
llh = 0;
for t = 1:ntrials
    
    a = sa(t);
%     pr = exp(beta*Q(a))/(exp(beta*(Q(1)))+exp(beta*(Q(2))));
    pr = 1/(exp(beta*(Q(1)-Q(a)))+exp(beta*(Q(2)-Q(a))));
    pr = (1-epsilon)*pr + epsilon/2;
    
    r = sr(t);
    Q(a) = Q(a)+alpha*(r-Q(a));
    
    llh =llh+ log(pr);
end
llh = -llh;

end
