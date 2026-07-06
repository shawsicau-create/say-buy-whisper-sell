close all

set(groot, 'DefaultAxesLineWidth', 1.5);
set(groot, 'DefaultLineLineWidth', 4);
set(groot, 'DefaultAxesTickLabelInterpreter','latex'); 
set(groot, 'DefaultLegendInterpreter','latex');
set(groot, 'DefaultAxesFontSize',24);


N     = 25000;
T     = p.T; 

A     = zeros(2*N, T + 1);     % Liquid Assets 
O     = zeros(2*N, T + 1);     % fraction of loan outstanding
Th    = zeros(2*N, T + 1);     % initial mortgage size
H     = zeros(2*N, T + 1);     % house size

C     = zeros(2*N, T);         % consumption
L     = zeros(2*N, T);         % liquidity after making housing choice
D     = zeros(2*N, T);         % discrete choice: 1 ... 5
Y     = zeros(2*N, T);         % income
V     = zeros(2*N, T);         % value function

Pall  = zeros(2*N, 5, T); 
Vall  = zeros(2*N, 5, T); 

Mind  = zeros(2*N, T + 1);     % number of your mortgage (1, 2, 3, ...)
Hind  = zeros(2*N, T + 1);     % number of your house (1, 2, 3)
Curt  = zeros(2*N, T);         % indicator for whether curtail mortgage

% First simulate history of shocks to income

rng(100); 

Z              = zeros(2*N, T);
E              = zeros(2*N, T);

index          = nodeunif(N, 1e-14, 1 - 1e-14); 

unif           = index(randperm(N));  unif = [unif; 1 - unif];    % mirror sampling

Fzcum          = [0; cumsum(Fz)];            % cumulative ergodic for initial conditions
[~, bin]       = histc(unif, Fzcum);         % bin is the index of initial draw of z

Z(:,1)         = bin;

unif           = index(randperm(N));  unif = [unif; 1 - unif];    % mirror sampling

Fecum          = [0; cumsum(we)];            % cumulative ergodic for transitory shock
[~, bin]       = histc(unif, Fecum);         % bin is the index of e transitory shock

E(:,1)         = bin;
        
Y(:,1)         = p.lambdat(1)*p.zgrid(Z(:,1)).*p.egrid(E(:,1));


for t = 2 : T

  unif      = index(randperm(N));  unif = [unif; 1 - unif];    % mirror sampling
  
  Fzcum     = [zeros(2*N, 1), cumsum(Fzz(Z(:,t-1), :), 2)];
 
  Z(:,t)    = ((unif < Fzcum(:, 2:end)).*(unif >= Fzcum(:,1:end-1)))*(1 : 1 : p.nz)';
  
  
  unif      = index(randperm(N));  unif = [unif; 1 - unif];
  
  [~, bin]  = histc(unif, Fecum);                             % bin is the index of e transitory shock

  E(:,t)    = bin;
  
  Y(:,t)    = p.lambdat(t)*p.zgrid(Z(:,t)).*p.egrid(E(:,t));

end

U           = rand(2*N, T);               % random variable that determines choice probability (adjustment cost)

Delta       = rand(2*N, T);               % random variable that determines maintenance shock 

Delta       = p.delta(1)*(Delta <= p.pidelta(1)) + p.delta(2)*(Delta > p.pidelta(1)); 


% period 1 all are renters with 0 wealth

t                  = 1; 

Whinterp           = griddedInterpolant({p.lgrid, (1: 1: p.no*p.nt*p.nh*p.nz)'},  reshape(wh(:, t), p.nl, p.no*p.nt*p.nh*p.nz), intmeth, 'linear'); 
Wrinterp           = griddedInterpolant({p.lgrid, (1: 1:                p.nz)'},  reshape(wr(:, t), p.nl,                p.nz), intmeth, 'linear');
 

state              = (1 + interest(A(:, t), p)).*A(:,t);                                                                  % others irrelevant here

[Lall, Oall, Thall, Hall, V(:,t), Pall(:, 1: 3, t), Vall(:, 1 : 3, t)] = solveh(state, Whinterp, Wrinterp, p, p.thetay(t), 'r', state(:,1), Y(:, t), Z(:, t));

Pcum               = [zeros(2*N, 1), cumsum(Pall(:, 1: 3, t), 2)];  

unif               = rand(2*N, 1); 

D(:, t)            = ((unif < Pcum(:, 2:end)).*(unif >= Pcum(:,1:end-1)))*(1 : 1 : 3)';

ind                = sub2ind([2*N, 3], (1 : 1 : 2*N)', D(:,t)); 

L(:, t)            =  Lall(ind); 
O(:, t + 1)        =  Oall(ind);
Th(:, t + 1)       = Thall(ind); 
H(:, t + 1)        =  Hall(ind); 


% Find consumption

rent               = H(:, t + 1) == 0; 

Chint              = griddedInterpolant({p.lgrid, p.ogrid, p.tgrid, p.hgrid, p.zgrid},  reshape(ch(:, t), p.nl, p.no, p.nt, p.nh, p.nz), intmeth, 'linear');
Crint              = griddedInterpolant({p.lgrid,                            p.zgrid},  reshape(cr(:, t), p.nl,                   p.nz), intmeth, 'linear');

cmin               = bisect('savings', 1e-13, 1e5, L(rent, t), p, 'r', amax);                  % c that implies a' = amin
cmax               = bisect('savings', 1e-13, 1e5, L(rent, t), p, 'r', amin);                  % c that implies a' = amin

C(rent, t)         = max(min(Crint(L(rent, t),  p.zgrid(Z(rent, t))), cmax), cmin);

[~, A(rent, t+1)]  = savings(C(rent,t), L(rent, t), p, 'r');                                   % none of the other state variables matter

cmin               = bisect('savings', 1e-13, 1e5, L(~rent, t), p, 'h', amax);                 % c that implies a' = amin
cmax               = bisect('savings', 1e-13, 1e5, L(~rent, t), p, 'h', amin);                 % c that implies a' = amin

C(~rent,t)         = max(min(Chint(L(~rent, t), O(~rent, t+1), Th(~rent, t+1), H(~rent, t+1), p.zgrid(Z(~rent, t))), cmax), cmin);

[~, A(~rent, t+1)] = savings(C(~rent,t), L(~rent,t), p, 'h');


Hind(:, t + 1)     = D(:, t) > 1; 
Mind(:, t + 1)     = D(:, t) == 3; 

for t = 2 : T
  
  Whinterp           = griddedInterpolant({p.lgrid, (1: 1: p.no*p.nt*p.nh*p.nz)'},  reshape(wh(:, t), p.nl, p.no*p.nt*p.nh*p.nz), intmeth, 'linear'); 
  Wrinterp           = griddedInterpolant({p.lgrid, (1: 1:                p.nz)'},  reshape(wr(:, t), p.nl,                p.nz), intmeth, 'linear');
  
  rent               = H(:, t) == 0; 

  % Renters
  
  state              = (1 + interest(A(rent, t), p)).*A(rent, t);                                                                % others don't matter directly
  
  ntemp              = numel(find(rent)); 
  
  [Lall, Oall, Thall, Hall, V(rent,t), Pall(rent, 1 : 3, t), Vall(rent, 1 : 3, t)] = solveh(state, Whinterp, Wrinterp, p, p.thetay(t), 'r', state(:,1), Y(rent, t), Z(rent, t));
 
  Pcum               = [zeros(ntemp, 1), cumsum(Pall(rent, 1 : 3, t), 2)];  

  D(rent, t)         = ((U(rent, t) < Pcum(:, 2:end)).*(U(rent, t) >= Pcum(:,1:end-1)))*(1 : 1 : 3)';

  ind                = sub2ind([ntemp, 3], (1 : 1 : ntemp)', D(rent, t)); 

  L(rent, t)         =  Lall(ind); 
  O(rent, t + 1)     =  Oall(ind);
  Th(rent, t + 1)    = Thall(ind); 
  H(rent, t + 1)     =  Hall(ind); 

  Hind(rent, t + 1)  = Hind(rent, t) + (D(rent, t) > 1); 
  Mind(rent, t + 1)  = Mind(rent, t) + (D(rent, t) == 3);
  
  % Homeowners
  
  ntemp              = numel(find(~rent)); 

  state              = [(1 + interest(A(~rent, t), p)).*A(~rent, t) - Delta(~rent, t).*H(~rent, t), O(~rent, t), Th(~rent, t), H(~rent, t)];                     % others don't matter directly
  
  hind               = lookup1(p.hgrid,  H(~rent, t), 1); 
  tind               = lookup1(p.tgrid, Th(~rent, t), 1); 
  
  [Lall, Oall, Thall, Hall, V(~rent,t), Pall(~rent, :, t), Vall(~rent, :, t)] = solveh(state, Whinterp, Wrinterp, p, p.thetay(t), 'h', state(:,1), Y(~rent, t), Z(~rent, t), hind, tind);
 
  Pcum               = [zeros(ntemp, 1), cumsum(Pall(~rent, :, t), 2)];  

  D(~rent, t)        = ((U(~rent, t) < Pcum(:, 2:end)).*(U(~rent, t) >= Pcum(:,1:end-1)))*(1 : 1 : 5)';

  ind                = sub2ind([ntemp, 5], (1 : 1 : ntemp)', D(~rent, t)); 

  L(~rent, t)        =  Lall(ind); 
  O(~rent, t + 1)    =  Oall(ind);
  Th(~rent, t + 1)   = Thall(ind); 
  H(~rent, t + 1)    =  Hall(ind); 
  
  Hind(~rent, t + 1) = Hind(~rent, t) + (D(~rent, t) == 2 | D(~rent, t) == 3); 
  Mind(~rent, t + 1) = Mind(~rent, t) + (D(~rent, t) == 3 | D(~rent, t) == 4);
  
  Curt(~rent, t + 1) = (Curt(~rent, t) == 1 | (O(~rent, t+1) <= (1 + p.rm)*O(~rent, t) - p.mbar - 1e-5)) & (D(~rent, t) == 5) &  (O(~rent, t+1) > 0);  
  
  
 % Find consumption

  rent               = H(:, t + 1) == 0; 

  Chint              = griddedInterpolant({p.lgrid, p.ogrid, p.tgrid, p.hgrid, p.zgrid},  reshape(ch(:, t), p.nl, p.no, p.nt, p.nh, p.nz), intmeth, 'linear');
  Crint              = griddedInterpolant({p.lgrid,                            p.zgrid},  reshape(cr(:, t), p.nl,                   p.nz), intmeth, 'linear');

  cmin               = bisect('savings', 1e-13, 1e5, L(rent, t), p, 'r', amax);                  % c that implies a' = amin
  cmax               = bisect('savings', 1e-13, 1e5, L(rent, t), p, 'r', amin);                  % c that implies a' = amin

  C(rent, t)         = max(min(Crint(L(rent, t),  p.zgrid(Z(rent, t))), cmax), cmin);

  [~, A(rent, t+1)]  = savings(C(rent,t), L(rent, t), p, 'r');                                   % none of the other state variables matter

  cmin               = bisect('savings', 1e-13, 1e5, L(~rent, t), p, 'h', amax);                 % c that implies a' = amin
  cmax               = bisect('savings', 1e-13, 1e5, L(~rent, t), p, 'h', amin);                 % c that implies a' = amin

  C(~rent,t)         = max(min(Chint(L(~rent, t), O(~rent, t+1), Th(~rent, t+1), H(~rent, t+1), p.zgrid(Z(~rent, t))), cmax), cmin);

  [~, A(~rent, t+1)] = savings(C(~rent,t), L(~rent,t), p, 'h');

 
end

Asave        = A; 
Osave        = O; 
Thsave       = Th; 
Hsave        = H; 
Csave        = C; 
Lsave        = L;
Dsave        = D; 
Ysave        = Y; 
Zsave        = Z; 
Esave        = E; 
Vsave        = V; 
Pallsave     = Pall; 
Vallsave     = Vall; 
Usave        = U; 
Deltasave    = Delta; 


%{

figure(2)

id = 1; 

subplot(2,2,1), plot([C(id, 1 : p.T)', Y(id, 1 : p.T)']); 
title('Consumption and Income', 'Interpreter','Latex');
h = legend('consumption', 'income');
set(gca, 'ygrid', 'on')
set(h,'Interpreter','latex'); 


subplot(2,2,2), plot([A(id, 1 : p.T + 1)', H(id, 1 : p.T + 1)'.*(1 - O(id, 1 : p.T + 1)'.*Th(id, 1 : p.T + 1)')]); 
title('Wealth', 'Interpreter','Latex');
set(gca, 'ygrid', 'on')
h = legend('liquid', 'illiquid');
set(h,'Interpreter','latex'); 

subplot(2,2,3), plot([H(id, 2 : p.T + 1)', (p.R/p.alpha)^(-1/p.sigma)*C(id, :)'])
title('Housing', 'Interpreter','Latex');
xlabel('age', 'Interpreter','Latex');
set(gca, 'ygrid', 'on')

subplot(2,2,4), plot(O(id, 1 : p.T + 1)'.*Th(id, 1 : p.T + 1)')
title('LTV', 'Interpreter','Latex');
xlabel('age', 'Interpreter','Latex');
set(gca, 'ygrid', 'on')



figure(3)

subplot(2,2,1), plot([mean(C(:, 1 : p.T))', mean(Y(:, 1 : p.T))']); 
title('Consumption and Income', 'Interpreter','Latex');
xlabel('age', 'Interpreter','Latex');
legend('consumption', 'income')
set(gca, 'ygrid', 'on')

subplot(2,2,2), plot([mean(A)', mean(H.*(1 - Th.*O))']); 
title('Wealth', 'Interpreter','Latex');
set(gca, 'ygrid', 'on')
h = legend('liquid', 'illiquid');
set(h,'Interpreter','latex'); 

subplot(2,2,3), plot([mean(H)']); 
title('Housing Stock', 'Interpreter','Latex');
set(gca, 'ygrid', 'on')

subplot(2,2,4), plot([mean(Th.*H.*O)'./mean(H)']); 
title('LTV', 'Interpreter','Latex');
set(gca, 'ygrid', 'on')

%}

W         = A + H.*(1 - Th.*O); 
Debt      = H.*Th.*O; 
Yh        = p.phi^(1 + 1/p.gamma)*C.^(-p.sigma/p.gamma);        % home production
Rent      = p.R*(p.R/p.alpha)^(-1/p.sigma)*C.*(H(:, 2:end) == 0); 

Debttilde        = zeros(2*N, T + 1); 
Debttilde(H > 0) = (Debt(H > 0) - p.F0m)./(1 + p.F1m);
 

%{

% Check aggregate resource constraint
% transaction costs: 

Ftrans   = (H(:, 1 : end - 1) == 0).*(D == 3).*(p.F0m + p.F1m*Debttilde(:, 2:end)) + ...             % mortgage origination cost for renters
           (H(:, 1 : end - 1) >  0).*(D <= 3).*(p.Fs*H(:, 1 : end - 1))       + ...                  % house selling costs for homeowners
           (H(:, 1 : end - 1) >  0).*(D == 3 | D == 4).*(p.F0m + p.F1m*Debttilde(:, 2:end));         % mortgage origination cost for homeowners

t       = 1:T; 

rl      = interest(A(:, t), p); 

err_agg = norm(vec(C(:,t) + H(:, t+1) + A(:, t+1) + (1 + p.rm)*Debt(:, t) + Rent(:,t) - Yh(:,t) - Y(:,t) - (1 + rl).*A(:, t) - H(:, t).*(1 - Delta(:,t)) - Debt(:, t+1) + Ftrans(:,t)));

fprintf('Err in Agg Resource Constr                     = %9.2e \n',  err_agg);
%}

fsell    = mean(vec(D <= 3 & H(:, 1 : end-1) > 0))/ mean(vec(H(:, 1 : end-1) > 0))*4; 
fmortg   = mean(vec(Th(:,1:end-1).*O(:,1:end-1) > 0 & H(:, 1 : end-1) > 0)) / mean(vec(H(:, 1 : end-1) > 0));

agewealthratio  = mean(vec(W(:, 41*4 + 1 : end))) / mean(vec(W(:, 2 : 41*4))); 

reqpayment      = p.mbar*Th(:, 1:end - 1).*H(:, 1:end - 1).*(O(:, 1:end - 1) > 0).*(D == 5); 
actpayment      = ((1 + p.rm)*Debt(:, 1 : end - 1) - Debt(:, 2 : end)).*(D == 5); 

fcurtail        = sum(vec(D == 5) & vec(O(:, 1:end-1) > 0) & vec(Curt(:, 1:end - 1) > 0))/sum(vec(D == 5) & vec(O(:, 1:end-1) > 0)); 

PTI             = reqpayment(reqpayment > 0)./Y(reqpayment > 0); 

HY              = H(:, 2:end)./Y/4;

Age   = zeros(2*N, T);         % mortgage age

for t = 2 : T

  Age(:,t)  = (Age(:,t-1) + 1/4).*(Age(:,t-1) > 0 & D(:,t) == 5) + 1/4.*(D(:,t) == 3 | D(:,t) == 4);    

end

Age = Age - 1/4; 

Age = floor(Age); 

LTV = O.*Th; 


% Let's compute refinance statistics the way Denis did in PSID data (imagine we track people every 2 years)


dates                 = 5 : 8 : p.T;       % interview dates: Jan 1 1999, Jan 1 2001, Jan 1 2003 ...

Ya                    = zeros(2*N, numel(dates) - 1);        % annual income: 1998, 2000, 2002
Ra                    = zeros(2*N, numel(dates) - 1);        % refinance between 1998-2000, 2000-2002 ...
Na                    = zeros(2*N, numel(dates) - 1);        % eligible to be counted as refinancer
Aa                    = zeros(2*N, numel(dates) - 1);        % liquid assets at the time of the interview
Ha                    = zeros(2*N, numel(dates) - 1);        % house value at interview
LTVa                  = zeros(2*N, numel(dates) - 1);        % LTV at interview
dLTVa                 = zeros(2*N, numel(dates) - 1);        % change in LTV 

for i = 1 : numel(dates) - 1

Ya(:, i)              = sum(Y(:, dates(i) - 4 : 1 : dates(i) - 1), 2); 

Ra(:, i)              = LTV(:, dates(i + 1)) > 1.05*LTV(:, dates(i)) & Hind(:, dates(i+1)) == Hind(:, dates(i)) & LTV(:, dates(i)) > 0 & H(:, dates(i)) > 0;
Na(:, i)              = Hind(:, dates(i+1)) == Hind(:, dates(i)) & LTV(:, dates(i)) > 0 & H(:, dates(i)) > 0; 

Aa(:, i)              = A(:, dates(i)); 
Ha(:, i)              = H(:, dates(i)); 
LTVa(:, i)            = LTV(:, dates(i)); 
dLTVa(:, i)           = LTV(:, dates(i + 1)) - LTV(:, dates(i));


end

AYa                   = Aa./Ya; 
AWa                   = Aa./(Aa + (1 - LTVa).*Ha); 
AWa(isnan(AWa))       = 0; 


fextract              = sum(Ra(:) > 0 & Na(:) > 0)/sum(Na(:) > 0);
medextract            = median(dLTVa(Ra(:) > 0 & Na(:) > 0)./LTVa(Ra(:) > 0 & Na(:) > 0));
meanextract           = mean(dLTVa(Ra(:) > 0 & Na(:) > 0)./LTVa(Ra(:) > 0 & Na(:) > 0));
meddLTV               = median(dLTVa(Ra(:) > 0 & Na(:) > 0));
meandLTV              = mean(dLTVa(Ra(:) > 0 & Na(:) > 0));

AWrefimean            = mean(AWa(Ra == 1 & Na == 1));
AWinacmean            = mean(AWa(Ra == 0 & Na == 1));
AYrefimean            = mean(AYa(Ra == 1 & Na == 1));
AYinacmean            = mean(AYa(Ra == 0 & Na == 1));


AWrefimed             = median(AWa(Ra == 1 & Na == 1));
AWinacmed             = median(AWa(Ra == 0 & Na == 1));
AYrefimed             = median(AYa(Ra == 1 & Na == 1));
AYinacmed             = median(AYa(Ra == 0 & Na == 1));




LTV                   = LTV(:, 2:end); % not sure why, check


moment_model          = zeros(57, 1); 

moment_model(1)       = mean(vec(H(:, 2 : end) > 0));
moment_model(2)       = mean(vec(W(:, 2 : end)))       /mean(vec(Y))/4;
moment_model(3)       = mean(vec(H(:, 2 : end)))       /mean(vec(Y))/4;
moment_model(4)       = mean(vec(Debt(:, 2 : end)))    /mean(vec(Y))/4; 
moment_model(5)       = mean(vec(A(:, 2 : end)))       /mean(vec(Y))/4;
moment_model(6)       = median(vec(A(:, 2 : end)))     /mean(vec(Y))/4;

moment_model(7)       = mean(A(H >  0))                /mean(vec(Y))/4;
moment_model(8)       = median(A(H >  0))              /mean(vec(Y))/4;

moment_model(9)       = mean(vec(A(:,2:end) <= 0)); 
moment_model(10)      = mean(vec(A(:,2:end) <= 4/26*Y));        % HTM with liquid assets < 2 weeks
moment_model(11)      = sum(vec(A(:,2:end) <= 0) & vec(H(:, 2:end) > 0))/sum(vec(H(:, 2:end) > 0)); 
moment_model(12)      = sum(vec(A(:,2:end) <= 4/26*Y) & vec(H(:, 2:end) > 0))/sum(vec(H(:, 2:end) > 0));

moment_model(13)      = fextract;
moment_model(14)      = mean(vec(Yh))/mean(vec(C));
moment_model(15)      = agewealthratio;

moment_model(16)      = fcurtail;
moment_model(17)      = fsell;
moment_model(18)      = fmortg; 
moment_model(19)      = medextract; 
moment_model(20)      = meddLTV; 


moment_model(21 : 25) = prctile(vec(A(:, 2 : end)), [10; 25; 50; 75; 90])/mean(vec(Y))/4;
moment_model(26 : 30) = prctile(A(H == 0), [10; 25; 50; 75; 90])/mean(vec(Y))/4;
moment_model(31 : 35) = prctile(A(H >  0), [10; 25; 50; 75; 90])/mean(vec(Y))/4;



moment_model(36 : 40) = prctile(Th(H >  0 & Debt > 0).*O(H > 0 & Debt > 0), [10; 25; 50; 75; 90]);
moment_model(41 : 45) = prctile((1 - Th(H >  0).*O(H > 0)).*H(H > 0)./W(H > 0), [10; 25; 50; 75; 90]);
moment_model(46 : 50) = prctile(vec(W(:,2:end)), [10; 25; 50; 75; 90])/mean(vec(Y))/4;
moment_model(51 : 55) = prctile(PTI, [10; 25; 50; 75; 90]);
moment_model(56 : 60) = prctile(HY(HY > 0), [10; 25; 50; 75; 90]);
moment_model(61 : 65) = prctile(Age(Age >=0 & LTV > 0), [10; 25; 50; 75; 90]);

moment_model(66)      = AWrefimean;
moment_model(67)      = AWinacmean;
moment_model(68)      = AYrefimean;
moment_model(69)      = AYinacmean;
moment_model(70)      = AWrefimed;
moment_model(71)      = AWinacmed;
moment_model(72)      = AYrefimed;
moment_model(73)      = AYinacmed;


moment_data = [0.64; 1.45; 1.82; 0.83; 0.46;  0.07; 0.53; 0.15; 0.26; 0.41; 0.20; 0.32; 0.15; 0.23; 2.00; 0.22; 0.08; 0.71; 0.21; 0.11;
              -0.04;    0; 0.07; 0.48; 1.50; -0.05;    0; 0.01; 0.15; 1;   -0.04; 0.01; 0.15; 0.68; 1.69;   
               0.18; 0.39; 0.62; 0.77; 0.88;  0.36; 0.64; 0.87; 0.99; 1.04; 0; 0.04; 0.73; 2.34; 3.94;
               0.05; 0.08; 0.11; 0.17; 0.24;  1.02; 1.62; 2.48; 3.78; 6.43; 0; 1; 3; 6; 10; 
               0.09; 0.21; 0.34; 1.39; 0.04;  0.16; 0.03; 0.18];

           

    
 
clc
    
fprintf('\n')
fprintf('Left Column: Model, Right Column: Data\n')
fprintf('\n')
fprintf('Table 11, A. Moments Used in Calibration \n')

fprintf('\n')
fprintf('I. Aggregate Moments\n')

fprintf('\n')
fprintf('fraction homeowners                                = %9.2f %9.2f\n',  [moment_model(1),    moment_data(1)]);
fprintf('wealth to income                                   = %9.2f %9.2f\n',  [moment_model(2),    moment_data(2)]);
fprintf('housing to income                                  = %9.2f %9.2f\n',  [moment_model(3),    moment_data(3)]);
fprintf('mortgage debt to income                            = %9.2f %9.2f\n',  [moment_model(4),    moment_data(4)]);
fprintf('mean liquid assets to income                       = %9.2f %9.2f\n',  [moment_model(5),    moment_data(5)]);
fprintf('fraction borrowers who extract                     = %9.2f %9.2f\n',  [round(moment_model(13)/2*100)/100,   round(moment_data(13)/2*100)/100]);

fprintf('\n')
fprintf('\n')
fprintf('II. Distribution of Liquid Assets\n')

fprintf('\n')
fprintf('\n')
fprintf('10th pctile                                        = %9.2f %9.2f\n',  [moment_model(21),   moment_data(21)]);
fprintf('25th pctile                                        = %9.2f %9.2f\n',  [moment_model(22),   moment_data(22)]);
fprintf('50th pctile                                        = %9.2f %9.2f\n',  [moment_model(23),   moment_data(23)]);
fprintf('75th pctile                                        = %9.2f %9.2f\n',  [moment_model(24),   moment_data(24)]);
fprintf('90th pctile                                        = %9.2f %9.2f\n',  [moment_model(25),   moment_data(25)]);
fprintf('\n')
  

% if printr
 
%     
% fprintf('\n')
% fprintf('Homeownership Rate                                 = %9.2f %9.2f\n',  [moment_model(1),    moment_data(1)]);
% fprintf('Aggregate Wealth to Income                         = %9.2f %9.2f\n',  [moment_model(2),    moment_data(2)]);
% fprintf('Aggregate Housing to Income                        = %9.2f %9.2f\n',  [moment_model(3),    moment_data(3)]);
% fprintf('Aggregate Debt to Income                           = %9.2f %9.2f\n',  [moment_model(4),    moment_data(4)]);
% 
% fprintf('\n')
% fprintf('Aggregate Liquid assets to Income                  = %9.2f %9.2f\n',  [moment_model(5),    moment_data(5)]);
% fprintf('Median    Liquid assets to Income                  = %9.2f %9.2f\n',  [moment_model(6),    moment_data(6)]);
% fprintf('Mean      Liquid assets to Income Owners           = %9.2f %9.2f\n',  [moment_model(7),    moment_data(7)]);
% fprintf('Median    Liquid assets to Income Owners           = %9.2f %9.2f\n',  [moment_model(8),    moment_data(8)]);
% 
% fprintf('\n')
% fprintf('Fraction HTM (A <= 0)                              = %9.2f %9.2f\n',  [moment_model(9),    moment_data(9)]);
% fprintf('Fraction HTM (A <= 1/26 income)                    = %9.2f %9.2f\n',  [moment_model(10),   moment_data(10)]);
% fprintf('Fraction HTM (A <= 0)             Owners           = %9.2f %9.2f\n',  [moment_model(11),   moment_data(11)]);
% fprintf('Fraction HTM (A <= 1/26 income)   Owners           = %9.2f %9.2f\n',  [moment_model(12),   moment_data(12)]);
% 
% fprintf('\n')
% 
% fprintf('Fraction of Borrowers who extract last 2 years     = %9.2f %9.2f\n',  [moment_model(13),   moment_data(13)]);
% fprintf('Non-Market Production to Consumption               = %9.2f %9.2f\n',  [moment_model(14),   moment_data(14)]);
% fprintf('Mean wealth retirees / workers                     = %9.2f %9.2f\n',  [moment_model(15),   moment_data(15)]);
% fprintf('\n')
% fprintf('\n')
% 
% fprintf('\n')
% fprintf('Fraction of Borrowers Ahead on Payments            = %9.2f %9.2f\n',  [moment_model(16),   moment_data(16)]);
% fprintf('Fraction of Homeowners who sell                    = %9.2f %9.2f\n',  [moment_model(17),   moment_data(17)]);
% fprintf('Fraction of Homeowners with mortgage               = %9.2f %9.2f\n',  [moment_model(18),   moment_data(18)]);
% fprintf('Median increase in balance extract                 = %9.2f %9.2f\n',  [moment_model(19),   moment_data(19)]);
% fprintf('Median increase in LTV extract                     = %9.2f %9.2f\n',  [moment_model(20),   moment_data(20)]);
% 
% fprintf('\n')
% 
% fprintf('10 pctile liquid assets to income                  = %9.2f %9.2f\n',  [moment_model(21),   moment_data(21)]);
% fprintf('25 pctile liquid assets to income                  = %9.2f %9.2f\n',  [moment_model(22),   moment_data(22)]);
% fprintf('50 pctile liquid assets to income                  = %9.2f %9.2f\n',  [moment_model(23),   moment_data(23)]);
% fprintf('75 pctile liquid assets to income                  = %9.2f %9.2f\n',  [moment_model(24),   moment_data(24)]);
% fprintf('90 pctile liquid assets to income                  = %9.2f %9.2f\n',  [moment_model(25),   moment_data(25)]);
% fprintf('\n')
% fprintf('10 pctile liquid assets renters                    = %9.2f %9.2f\n',  [moment_model(26),   moment_data(26)]);
% fprintf('25 pctile liquid assets renters                    = %9.2f %9.2f\n',  [moment_model(27),   moment_data(27)]);
% fprintf('50 pctile liquid assets renters                    = %9.2f %9.2f\n',  [moment_model(28),   moment_data(28)]);
% fprintf('75 pctile liquid assets renters                    = %9.2f %9.2f\n',  [moment_model(29),   moment_data(29)]);
% fprintf('90 pctile liquid assets renters                    = %9.2f %9.2f\n',  [moment_model(30),   moment_data(30)]);
% fprintf('\n')
% fprintf('10 pctile liquid assets owners                     = %9.2f %9.2f\n',  [moment_model(31),   moment_data(31)]);
% fprintf('25 pctile liquid assets owners                     = %9.2f %9.2f\n',  [moment_model(32),   moment_data(32)]);
% fprintf('50 pctile liquid assets owners                     = %9.2f %9.2f\n',  [moment_model(33),   moment_data(33)]);
% fprintf('75 pctile liquid assets owners                     = %9.2f %9.2f\n',  [moment_model(34),   moment_data(34)]);
% fprintf('90 pctile liquid assets owners                     = %9.2f %9.2f\n',  [moment_model(35),   moment_data(35)]);
% 
% 
% fprintf('\n')
% 
% fprintf('10 pctile LTV, borrowers                           = %9.2f %9.2f\n',  [moment_model(36),   moment_data(36)]);
% fprintf('25 pctile LTV, borrowers                           = %9.2f %9.2f\n',  [moment_model(37),   moment_data(37)]);
% fprintf('50 pctile LTV, borrowers                           = %9.2f %9.2f\n',  [moment_model(38),   moment_data(38)]);
% fprintf('75 pctile LTV, borrowers                           = %9.2f %9.2f\n',  [moment_model(39),   moment_data(39)]);
% fprintf('90 pctile LTV, borrowers                           = %9.2f %9.2f\n',  [moment_model(40),   moment_data(40)]);
% fprintf('\n')
% fprintf('10 Share Housing Wealth in Owner Wealth            = %9.2f %9.2f\n',  [moment_model(41),   moment_data(41)]);
% fprintf('25 Share Housing Wealth in Owner Wealth            = %9.2f %9.2f\n',  [moment_model(42),   moment_data(42)]);
% fprintf('50 Share Housing Wealth in Owner Wealth            = %9.2f %9.2f\n',  [moment_model(43),   moment_data(43)]);
% fprintf('75 Share Housing Wealth in Owner Wealth            = %9.2f %9.2f\n',  [moment_model(44),   moment_data(44)]);
% fprintf('90 Share Housing Wealth in Owner Wealth            = %9.2f %9.2f\n',  [moment_model(45),   moment_data(45)]);
% fprintf('\n')
% fprintf('10 pctile Wealth                                   = %9.2f %9.2f\n',  [moment_model(46),   moment_data(46)]);
% fprintf('25 pctile Wealth                                   = %9.2f %9.2f\n',  [moment_model(47),   moment_data(47)]);
% fprintf('50 pctile Wealth                                   = %9.2f %9.2f\n',  [moment_model(48),   moment_data(48)]);
% fprintf('75 pctile Wealth                                   = %9.2f %9.2f\n',  [moment_model(49),   moment_data(49)]);
% fprintf('90 pctile Wealth                                   = %9.2f %9.2f\n',  [moment_model(50),   moment_data(50)]);
% fprintf('\n')
% fprintf('10 pctile PTI                                      = %9.2f %9.2f\n',  [moment_model(51),   moment_data(51)]);
% fprintf('25 pctile PTI                                      = %9.2f %9.2f\n',  [moment_model(52),   moment_data(52)]);
% fprintf('50 pctile PTI                                      = %9.2f %9.2f\n',  [moment_model(53),   moment_data(53)]);
% fprintf('75 pctile PTI                                      = %9.2f %9.2f\n',  [moment_model(54),   moment_data(54)]);
% fprintf('90 pctile PTI                                      = %9.2f %9.2f\n',  [moment_model(55),   moment_data(55)]);
% fprintf('\n')
% fprintf('10 pctile housing to income                        = %9.2f %9.2f\n',  [moment_model(56),   moment_data(56)]);
% fprintf('25 pctile housing to income                        = %9.2f %9.2f\n',  [moment_model(57),   moment_data(57)]);
% fprintf('50 pctile housing to income                        = %9.2f %9.2f\n',  [moment_model(58),   moment_data(58)]);
% fprintf('75 pctile housing to income                        = %9.2f %9.2f\n',  [moment_model(59),   moment_data(59)]);
% fprintf('90 pctile housing to income                        = %9.2f %9.2f\n',  [moment_model(60),   moment_data(60)]);
% fprintf('\n')
% fprintf('10 pctile mortgage age                             = %9.0f %9.0f\n',  [moment_model(61),   moment_data(61)]);
% fprintf('25 pctile mortgage age                             = %9.0f %9.0f\n',  [moment_model(62),   moment_data(62)]);
% fprintf('50 pctile mortgage age                             = %9.0f %9.0f\n',  [moment_model(63),   moment_data(63)]);
% fprintf('75 pctile mortgage age                             = %9.0f %9.0f\n',  [moment_model(64),   moment_data(64)]);
% fprintf('90 pctile mortgage age                             = %9.0f %9.0f\n',  [moment_model(65),   moment_data(65)]);
% fprintf('\n')
% fprintf('  Mean Liquid Assets to Wealth: Refi               = %9.2f %9.2f\n',  [moment_model(66),   moment_data(66)]);
% fprintf('  Mean Liquid Assets to Wealth: Dont               = %9.2f %9.2f\n',  [moment_model(67),   moment_data(67)]);
% %fprintf('  Mean Liquid Assets to Income: Refi               = %9.2f %9.2f\n',  [moment_model(68),   moment_data(68)]);
% %fprintf('  Mean Liquid Assets to Income: Dont               = %9.2f %9.2f\n',  [moment_model(69),   moment_data(69)]);
% fprintf('Median Liquid Assets to Wealth: Refi               = %9.2f %9.2f\n',  [moment_model(70),   moment_data(70)]);
% fprintf('Median Liquid Assets to Wealth: Dont               = %9.2f %9.2f\n',  [moment_model(71),   moment_data(71)]);
% %fprintf('Median Liquid Assets to Income: Refi               = %9.2f %9.2f\n',  [moment_model(72),   moment_data(72)]);
% %fprintf('Median Liquid Assets to Income: Dont               = %9.2f %9.2f\n',  [moment_model(73),   moment_data(73)]);
% 
% % Calculate life time value
%     
% Hs = H(:, 2 : p.T + 1).*(H(:, 2 : p.T + 1) > 0) + (p.R/p.alpha)^(-1/p.sigma)*C.*(H(:, 2 : p.T + 1) == 0);
% 
% U  = C.^(1 - p.sigma)/(1 - p.sigma) + p.alpha*Hs.^(1 - p.sigma)/(1 - p.sigma) -  p.phi^(1 + 1/p.gamma)/(1 + p.gamma)*C.^(-p.sigma*(1 + 1/p.gamma));  
% 
% rl = 1./(1 + exp(-p.r1*(A(:,p.T+1) - p.r2)))*(p.rh - p.rl) + p.rl;
% 
% V  = sum(p.beta.^(0 : 1 : p.T - 1).*U, 2) + p.beta^p.T*p.B*(p.wbar + (1 + p.rl)*A(:,p.T+1) + (1 - p.Fs - (1 + p.rm)*O(:,p.T+1).*Th(:,p.T+1)).*H(:,p.T+1)).^(1 - p.sigma)/(1 - p.sigma); 
%     
% V  = ((1 - p.sigma)*(1 - p.beta)/(1 - p.beta^p.T)*mean(V))^(1/(1 - p.sigma)); 
% 
% fprintf('\n') 
% fprintf('Life Time Value, CEV                               = %9.4f \n',     V);
% 
% end
% 
% weights          = zeros(numel(moment_data), 1); 
% 
% weights(1)       = 10; 
% weights(2 : 8)   = 1; 
% weights(5 : 6)   = 10;    % mean/median liquid assets
% weights(10)      = 1;
% weights(12)      = 1; 
% weights(13)      = 20; 
% weights(14:15)   = 1; 
% weights(17)      = 1; 
% weights(30)      = 1; 
% weights(35)      = 1; 
% 
% 
% weights        = weights/sum(weights);
% 
% err_mom        = (moment_model - moment_data)./(1 + moment_data);
% err_mom        = (weights'*err_mom.^2).^(1/2);
% 
% if exist('x', 'var')
% 
%     fprintf('%5.6f  %5.6f  %5.6f  %5.6f %5.6f %5.6f  %5.6f  %5.6f  %5.6f %5.6f %5.6f %5.6f  \n',  [x(:)', err_mom]);
% 
% else
%     
% fprintf('\n');     
% fprintf('value of objective                                 = %5.6f \n',  err_mom);
% fprintf('\n');    
% 
% end



