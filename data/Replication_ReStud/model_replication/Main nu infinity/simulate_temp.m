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

U           = rand(2*N, T); 
U           = -log(U)/p.nu;    % generate actual cost  


% period 1 all are renters with 0 wealth

t                  = 1; 


Whinterp           = griddedInterpolant({p.lgrid, (1: 1: p.no*p.nt*p.nh*p.nz)'},  reshape(wh(:, t), p.nl, p.no*p.nt*p.nh*p.nz), intmeth, 'linear'); 
Wrinterp           = griddedInterpolant({p.lgrid, (1: 1:                p.nz)'},  reshape(wr(:, t), p.nl,                p.nz), intmeth, 'linear');
 

state              = A(:, t);                                                                  % others irrelevant here

[Lall, Oall, Thall, Hall, V(:,t), Pall(:, 1: 3, t), Vall(:, 1 : 3, t)] = solveh(state, Whinterp, Wrinterp, p, p.thetay(t), 'r', A(:, t), Y(:, t), Z(:, t));

Pcum               = [zeros(2*N, 1), cumsum(Pall(:, 1: 3, t), 2)];  

unif               = rand(2*N, 1); 

[~, D(:, t)]       = max([Vall(:, 1 : 2, t), Vall(:, 3, t) - U(:, t)], [], 2);  

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


for t = 2 : T
  
  Whinterp           = griddedInterpolant({p.lgrid, (1: 1: p.no*p.nt*p.nh*p.nz)'},  reshape(wh(:, t), p.nl, p.no*p.nt*p.nh*p.nz), intmeth, 'linear'); 
  Wrinterp           = griddedInterpolant({p.lgrid, (1: 1:                p.nz)'},  reshape(wr(:, t), p.nl,                p.nz), intmeth, 'linear');
  
  rent               = H(:, t) == 0; 

  % Renters
  
  state              = A(rent, t);                                                                % others don't matter directly
  
  ntemp              = numel(find(rent)); 
  
  [Lall, Oall, Thall, Hall, V(rent,t), Pall(rent, 1 : 3, t), Vall(rent, 1 : 3, t)] = solveh(state, Whinterp, Wrinterp, p, p.thetay(t), 'r', A(rent, t), Y(rent, t), Z(rent, t));

  [~, D(rent, t)]       = max([Vall(rent, 1 : 2, t), Vall(rent, 3, t) - U(rent, t)], [], 2);  

  ind                = sub2ind([ntemp, 3], (1 : 1 : ntemp)', D(rent, t)); 

  L(rent, t)         =  Lall(ind); 
  O(rent, t + 1)     =  Oall(ind);
  Th(rent, t + 1)    = Thall(ind); 
  H(rent, t + 1)     =  Hall(ind); 

  
  % Homeowners
  
  ntemp              = numel(find(~rent)); 

  state              = [A(~rent, t), O(~rent, t), Th(~rent, t), H(~rent, t)];                     % others don't matter directly
  
  hind               = lookup1(p.hgrid,  H(~rent, t), 1); 
  tind               = lookup1(p.tgrid, Th(~rent, t), 1); 
  
  [Lall, Oall, Thall, Hall, V(~rent,t), Pall(~rent, :, t), Vall(~rent, :, t)] = solveh(state, Whinterp, Wrinterp, p, p.thetay(t), 'h', A(~rent, t), Y(~rent, t), Z(~rent, t), hind, tind);
 
  Pcum               = [zeros(ntemp, 1), cumsum(Pall(~rent, :, t), 2)];  

  [~, D(~rent, t)]   = max([Vall(~rent, 1 : 2, t), Vall(~rent, 3 : 4, t) - U(~rent, t), Vall(~rent, 5, t)], [], 2);  

  ind                = sub2ind([ntemp, 5], (1 : 1 : ntemp)', D(~rent, t)); 

  L(~rent, t)        =  Lall(ind); 
  O(~rent, t + 1)    =  Oall(ind);
  Th(~rent, t + 1)   = Thall(ind); 
  H(~rent, t + 1)    =  Hall(ind); 
  
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
% 
% Fextractage = zeros(p.T, 1); 
% 
% for t = 2 : p.T
%     
%     Fextractage(t) = mean(D(:,t) == 4 & H(:,t-1) > 0 & Debt(:, /mean(vec(H(:, 1 : end-1) > 0  & Debt(:, 1 : end - 1) > 0 ))*4; 
% 
%     
% end

% Check aggregate resource constraint
% transaction costs: 

Ftrans   = (H(:, 1 : end - 1) == 0).*(D == 3).*(p.F0m + p.F1m*Debttilde(:, 2:end)) + ...             % mortgage origination cost for renters
           (H(:, 1 : end - 1) >  0).*(D <= 3).*(p.Fs*H(:, 1 : end - 1))       + ...                  % house selling costs for homeowners
           (H(:, 1 : end - 1) >  0).*(D == 3 | D == 4).*(p.F0m + p.F1m*Debttilde(:, 2:end));         % mortgage origination cost for homeowners

%{
t       = 1 : T; 

rl = 1./(1 + exp(-p.r1*(A(:, t) - p.r2)))*(p.rh - p.rl) + p.rl;

err_agg = norm(vec(C(:,t) + H(:, t+1) + A(:, t+1) + (1 + p.rm)*Debt(:, t) + Rent(:,t) - Yh(:,t) - Y(:,t) - (1 + rl).*A(:, t) - H(:, t) - Debt(:, t+1) + Ftrans(:,t)))

fprintf('Err in Agg Resource Constr                     = %9.2e \n',  err_agg);
%}

fsell    = mean(vec(D <= 3 & H(:, 1 : end-1) > 0))/ mean(vec(H(:, 1 : end-1) > 0))*4; 
fmortg   = mean(vec(Th(:,1:end-1).*O(:,1:end-1) > 0 & H(:, 1 : end-1) > 0)) / mean(vec(H(:, 1 : end-1) > 0));

agewealthratio  = mean(vec(W(:, 41*4 + 1 : end))) / mean(vec(W(:, 2 : 41*4))); 

reqpayment      = p.mbar*Th(:, 1:end - 1).*H(:, 1:end - 1).*(O(:, 1:end - 1) > 0).*(D == 5); 
actpayment      = ((1 + p.rm)*Debt(:, 1 : end - 1) - Debt(:, 2 : end)).*(D == 5); 

fcurtail        = sum(actpayment(:) > 1e-4 + reqpayment(:) & reqpayment(:) > 0 & D(:) == 5)/sum(reqpayment(:) > 0 & D(:) == 5); 

PTI             = reqpayment(reqpayment > 0)./Y(reqpayment > 0); 

HY              = H(:, 2:end)./Y/4;

Age   = zeros(2*N, T);         % mortgage age

for t = 2 : T

  Age(:,t)  = (Age(:,t-1) + 1/4).*(Age(:,t-1) > 0 & D(:,t) == 5) + 1/4.*(D(:,t) == 3 | D(:,t) == 4);    

end

Age = Age - 1/4; 

Age = floor(Age); 

LTV = O(:, 2 : end).*Th(:, 2 : end); 

% Let's computa Bhutta-Keys stats by annualizing first data. 
% Suppose we see them in the last quarter of the year

Debta                 = O(:, 4 : 4: end).*Th(:, 4: 4 : end).*H(:, 4 : 4 : end);  
Xtract                = (Debta(:, 2:end) - Debta(:, 1 : end-1))./Debta(:, 1 : end-1);
Debta(:, end)         = [];
Ha                    = H(:, 4 : 4 :end); 
notmove               = Ha(:, 2 : end) == Ha(:, 1 : end-1); 
Ha(:, end)            = [];
Aa                    = A(:, 4 : 4 : end); 
Aa(:, end)            = [];

fextract              = sum(Xtract(:)>=0.05 & Debta(:) > 0 & notmove(:))/sum(Debta(:) > 0 & notmove(:)); 
medextract            = median(Xtract(Xtract >= 0.05 & Debta > 0 & notmove)); 
fextracttwice         = sum(vec(Xtract(:,2:end) >=0.05 & Xtract(:,1:end-1) >=0.05 & Debta(:, 2: end) >0 & notmove(:, 2:end)  & Debta(:, 1:end-1) >0 & notmove(:, 1:end-1)))/...
                        sum(vec(Xtract(:,1:end-1) >=0.05 & Debta(:, 2: end) >0 & notmove(:, 2:end) & Debta(:, 1:end-1) >0 & notmove(:, 1:end-1))); 


moment_model          = zeros(57, 1); 

moment_model(1)       = mean(vec(H(:, 2 : end) > 0));
moment_model(2)       = mean(vec(W(:, 2 : end)))       /mean(vec(Y))/4;
moment_model(3)       = mean(vec(H(:, 2 : end)))       /mean(vec(Y))/4;
moment_model(4)       = mean(vec(Debt(:, 2 : end)))    /mean(vec(Y))/4; 
moment_model(5)       = mean(vec(A(:, 2 : end)))       /mean(vec(Y))/4;

moment_model(6)       = fextract;
moment_model(7)       = mean(vec(Yh))/mean(vec(C));
moment_model(8)       = agewealthratio;


moment_model(9  : 13) = prctile(vec(A(:, 2 : end)), [10; 25; 50; 75; 90])/mean(vec(Y))/4;
moment_model(14 : 18) = prctile(A(H == 0), [10; 25; 50; 75; 90])/mean(vec(Y))/4;
moment_model(19 : 23) = prctile(A(H >  0), [10; 25; 50; 75; 90])/mean(vec(Y))/4;

moment_model(24)      = fsell;
moment_model(25)      = fmortg; 

moment_model(26 : 30) = prctile(Th(H >  0 & Debt > 0).*O(H > 0 & Debt > 0), [10; 25; 50; 75; 90]);
moment_model(31 : 35) = prctile((1 - Th(H >  0).*O(H > 0)).*H(H > 0)./W(H > 0), [10; 25; 50; 75; 90]);
moment_model(36 : 40) = prctile(vec(W(:,2:end)), [10; 25; 50; 75; 90])/mean(vec(Y))/4;
moment_model(41 : 45) = prctile(PTI, [10; 25; 50; 75; 90]);
moment_model(46 : 50) = prctile(HY(HY > 0), [10; 25; 50; 75; 90]);
moment_model(51 : 55) = prctile(Age(Age >=0 & LTV > 0), [10; 25; 50; 75; 90]);

moment_model(56)      = medextract;
moment_model(57)      = fextracttwice;


moment_data = [0.64; 1.45; 1.82; 0.83; 0.46; 0.08; 0.23; 2.00;  -0.04; 0; 0.07; 0.48; 1.50; 
              -0.05;    0; 0.01; 0.15; 1; -0.04; 0.01; 0.15; 0.68; 1.69; 0.044; 0.71;  
               0.18; 0.39; 0.62; 0.77; 0.88; 0.36; 0.64; 0.87; 0.99; 1.04; 0; 0.04; 0.73; 2.34; 3.94;
               0.05; 0.08; 0.11; 0.17; 0.24; 1.02; 1.62; 2.48; 3.78; 6.43; 0; 1; 3; 6; 10; 0.23; 0.08];

           
if printr

fprintf('\n')
fprintf('Homeownership Rate                                 = %9.2f %9.2f\n',  [moment_model(1),    moment_data(1)]);
fprintf('Aggregate Wealth to Income                         = %9.2f %9.2f\n',  [moment_model(2),    moment_data(2)]);
fprintf('Aggregate Housing to Income                        = %9.2f %9.2f\n',  [moment_model(3),    moment_data(3)]);
fprintf('Aggregate Debt to Income                           = %9.2f %9.2f\n',  [moment_model(4),    moment_data(4)]);
fprintf('Aggregate Liquid assets to Income                  = %9.2f %9.2f\n',  [moment_model(5),    moment_data(5)]);
fprintf('Fraction of Homeowners with Mortgage who extract   = %9.2f %9.2f\n',  [moment_model(6),    moment_data(6)]);
fprintf('Non-Market Production to Consumption               = %9.2f %9.2f\n',  [moment_model(7),    moment_data(7)]);
fprintf('Mean wealth retirees / workers                     = %9.2f %9.2f\n',  [moment_model(8),    moment_data(8)]);

fprintf('\n')
fprintf('10 pctile liquid assets to income                  = %9.2f %9.2f\n',  [moment_model(9),    moment_data(9)]);
fprintf('25 pctile liquid assets to income                  = %9.2f %9.2f\n',  [moment_model(10),   moment_data(10)]);
fprintf('50 pctile liquid assets to income                  = %9.2f %9.2f\n',  [moment_model(11),   moment_data(11)]);
fprintf('75 pctile liquid assets to income                  = %9.2f %9.2f\n',  [moment_model(12),   moment_data(12)]);
fprintf('90 pctile liquid assets to income                  = %9.2f %9.2f\n',  [moment_model(13),   moment_data(13)]);
fprintf('\n')
fprintf('\n')


fprintf('10 pctile liquid assets renters                    = %9.2f %9.2f\n',  [moment_model(14),   moment_data(14)]);
fprintf('25 pctile liquid assets renters                    = %9.2f %9.2f\n',  [moment_model(15),   moment_data(15)]);
fprintf('50 pctile liquid assets renters                    = %9.2f %9.2f\n',  [moment_model(16),   moment_data(16)]);
fprintf('75 pctile liquid assets renters                    = %9.2f %9.2f\n',  [moment_model(17),   moment_data(17)]);
fprintf('90 pctile liquid assets renters                    = %9.2f %9.2f\n',  [moment_model(18),   moment_data(18)]);
fprintf('\n')
fprintf('10 pctile liquid assets owners                     = %9.2f %9.2f\n',  [moment_model(19),   moment_data(19)]);
fprintf('25 pctile liquid assets owners                     = %9.2f %9.2f\n',  [moment_model(20),   moment_data(20)]);
fprintf('50 pctile liquid assets owners                     = %9.2f %9.2f\n',  [moment_model(21),   moment_data(21)]);
fprintf('75 pctile liquid assets owners                     = %9.2f %9.2f\n',  [moment_model(22),   moment_data(22)]);
fprintf('90 pctile liquid assets owners                     = %9.2f %9.2f\n',  [moment_model(23),   moment_data(23)]);

fprintf('\n')
fprintf('Fraction of Homeowners who curtail                 = %9.3f \n',       fcurtail);
fprintf('Fraction of Homeowners who sell                    = %9.3f %9.3f\n',  [moment_model(24),   moment_data(24)]);
fprintf('Fraction of Homeowners with mortgage               = %9.2f %9.2f\n',  [moment_model(25),   moment_data(25)]);
fprintf('Median increase in balance extract                 = %9.2f %9.2f\n',  [moment_model(56),   moment_data(56)]);
fprintf('Fraction that extract twice in a row               = %9.2f %9.2f\n',  [moment_model(57),   moment_data(57)]);

fprintf('\n')

fprintf('10 pctile LTV, borrowers                           = %9.2f %9.2f\n',  [moment_model(26),   moment_data(26)]);
fprintf('25 pctile LTV, borrowers                           = %9.2f %9.2f\n',  [moment_model(27),   moment_data(27)]);
fprintf('50 pctile LTV, borrowers                           = %9.2f %9.2f\n',  [moment_model(28),   moment_data(28)]);
fprintf('75 pctile LTV, borrowers                           = %9.2f %9.2f\n',  [moment_model(29),   moment_data(29)]);
fprintf('90 pctile LTV, borrowers                           = %9.2f %9.2f\n',  [moment_model(30),   moment_data(30)]);
fprintf('\n')
fprintf('10 Share Housing Wealth in Owner Wealth            = %9.2f %9.2f\n',  [moment_model(31),   moment_data(31)]);
fprintf('25 Share Housing Wealth in Owner Wealth            = %9.2f %9.2f\n',  [moment_model(32),   moment_data(32)]);
fprintf('50 Share Housing Wealth in Owner Wealth            = %9.2f %9.2f\n',  [moment_model(33),   moment_data(33)]);
fprintf('75 Share Housing Wealth in Owner Wealth            = %9.2f %9.2f\n',  [moment_model(34),   moment_data(34)]);
fprintf('90 Share Housing Wealth in Owner Wealth            = %9.2f %9.2f\n',  [moment_model(35),   moment_data(35)]);
fprintf('\n')
fprintf('10 pctile Wealth                                   = %9.2f %9.2f\n',  [moment_model(36),   moment_data(36)]);
fprintf('25 pctile Wealth                                   = %9.2f %9.2f\n',  [moment_model(37),   moment_data(37)]);
fprintf('50 pctile Wealth                                   = %9.2f %9.2f\n',  [moment_model(38),   moment_data(38)]);
fprintf('75 pctile Wealth                                   = %9.2f %9.2f\n',  [moment_model(39),   moment_data(39)]);
fprintf('90 pctile Wealth                                   = %9.2f %9.2f\n',  [moment_model(40),   moment_data(40)]);
fprintf('\n')
fprintf('10 pctile PTI                                      = %9.2f %9.2f\n',  [moment_model(41),   moment_data(41)]);
fprintf('25 pctile PTI                                      = %9.2f %9.2f\n',  [moment_model(42),   moment_data(42)]);
fprintf('50 pctile PTI                                      = %9.2f %9.2f\n',  [moment_model(43),   moment_data(43)]);
fprintf('75 pctile PTI                                      = %9.2f %9.2f\n',  [moment_model(44),   moment_data(44)]);
fprintf('90 pctile PTI                                      = %9.2f %9.2f\n',  [moment_model(45),   moment_data(45)]);
fprintf('\n')
fprintf('10 pctile housing to income                        = %9.2f %9.2f\n',  [moment_model(46),   moment_data(46)]);
fprintf('25 pctile housing to income                        = %9.2f %9.2f\n',  [moment_model(47),   moment_data(47)]);
fprintf('50 pctile housing to income                        = %9.2f %9.2f\n',  [moment_model(48),   moment_data(48)]);
fprintf('75 pctile housing to income                        = %9.2f %9.2f\n',  [moment_model(49),   moment_data(49)]);
fprintf('90 pctile housing to income                        = %9.2f %9.2f\n',  [moment_model(50),   moment_data(50)]);
fprintf('\n')
fprintf('10 pctile mortgage age                             = %9.2f %9.2f\n',  [moment_model(51),   moment_data(51)]);
fprintf('25 pctile mortgage age                             = %9.2f %9.2f\n',  [moment_model(52),   moment_data(52)]);
fprintf('50 pctile mortgage age                             = %9.2f %9.2f\n',  [moment_model(53),   moment_data(53)]);
fprintf('75 pctile mortgage age                             = %9.2f %9.2f\n',  [moment_model(54),   moment_data(54)]);
fprintf('90 pctile mortgage age                             = %9.2f %9.2f\n',  [moment_model(55),   moment_data(55)]);

% Calculate life time value
    
Hs = H(:, 2 : p.T + 1).*(H(:, 2 : p.T + 1) > 0) + (p.R/p.alpha)^(-1/p.sigma)*C.*(H(:, 2 : p.T + 1) == 0);

U  = C.^(1 - p.sigma)/(1 - p.sigma) + p.alpha*Hs.^(1 - p.sigma)/(1 - p.sigma) -  p.phi^(1 + 1/p.gamma)/(1 + p.gamma)*C.^(-p.sigma*(1 + 1/p.gamma));  

rl = 1./(1 + exp(-p.r1*(A(:,p.T+1) - p.r2)))*(p.rh - p.rl) + p.rl;

V  = sum(p.beta.^(0 : 1 : p.T - 1).*U, 2) + p.beta^p.T*p.B*(p.wbar + (1 + p.rl)*A(:,p.T+1) + (1 - p.Fs - (1 + p.rm)*O(:,p.T+1).*Th(:,p.T+1)).*H(:,p.T+1)).^(1 - p.sigma)/(1 - p.sigma); 
    
V  = ((1 - p.sigma)*(1 - p.beta)/(1 - p.beta^p.T)*mean(V))^(1/(1 - p.sigma)); 

fprintf('\n') 
fprintf('Life Time Value, CEV                               = %9.4f \n',     V);

end

weights        = ones(13, 1); 

weights        = weights/sum(weights);

err_mom        = (moment_model(1:13) - moment_data(1:13))./(1 + moment_data(1:13));
err_mom        = (weights'*err_mom.^2).^(1/2);

if exist('x', 'var')

    fprintf('%5.6f  %5.6f  %5.6f  %5.6f  %5.6f  %5.6f  %5.6f %5.6f %5.6f %5.6f  \n',  [x(:)', err_mom]);

else
    
fprintf('\n');     
fprintf('value of objective                                 = %5.6f \n',  err_mom);
fprintf('\n');    

end


% Characteristics of those who refinance


W       = A + H.*(1 - O.*Th);

Wtemp   = W(:, 1 : end - 1);    % only state variables
Atemp   = A(:, 1 : end - 1); 
LTV     = O(:, 1 : end - 1).*Th(:, 1 : end - 1); 
Htemp   = H(:, 1 : end - 1); 
LY      = Atemp./Y; 
Sh      = 1 - Atemp./Wtemp; 
Age     = repmat((1 : 1 : T)/4 + 25, 2*N, 1); 

refin   =  D == 4   & Htemp > 0; 
owner   = (D == 4 | D == 5) & Htemp > 0; 

time  = 1; 


fprintf('\n');
fprintf('Characteristics of Refinancers in Initial Steady State\n');
fprintf('\n');
fprintf('All, Refinance, Dont Refinance\n');

fprintf('\n');

fprintf('\n');
fprintf('Mean Liquid Assets             = %9.2f %9.2f %9.2f \n',  [mean(Atemp(owner)),    mean(Atemp(owner & refin)),    mean(Atemp(owner & ~refin))]);
fprintf('Mean Income                    = %9.2f %9.2f %9.2f \n',  [mean(Y(owner)),        mean(Y(owner & refin)),        mean(Y(owner & ~refin))]);
fprintf('Mean Liquid Asset to Income    = %9.2f %9.2f %9.2f \n',  [mean(LY(owner)),       mean(LY(owner & refin)),       mean(LY(owner & ~refin))]);
fprintf('Mean Share Housing Wealth      = %9.2f %9.2f %9.2f \n',  [mean(Sh(owner)),       mean(Sh(owner & refin)),       mean(Sh(owner & ~refin))]);
fprintf('Mean Wealth                    = %9.2f %9.2f %9.2f \n',  [mean(Wtemp(owner)),    mean(Wtemp(owner & refin)),    mean(Wtemp(owner & ~refin))]);
fprintf('Mean LTV                       = %9.2f %9.2f %9.2f \n',  [mean(LTV(owner)),      mean(LTV(owner & refin)),      mean(LTV(owner & ~refin))]);
fprintf('Mean House                     = %9.2f %9.2f %9.2f \n',  [mean(Htemp(owner)),    mean(Htemp(owner & refin)),    mean(Htemp(owner & ~refin))]);
fprintf('Mean Age                       = %9.2f %9.2f %9.2f \n',  [mean(Age(owner)),      mean(Age(owner & refin)),      mean(Age(owner & ~refin))]);

fprintf('\n');
fprintf('\n');

fprintf('\n');
fprintf('Median Liquid Assets           = %9.2f %9.2f %9.2f \n',  [median(Atemp(owner)),    median(Atemp(owner & refin)),    median(Atemp(owner & ~refin))]);
fprintf('Median Income                  = %9.2f %9.2f %9.2f \n',  [median(Y(owner)),        median(Y(owner & refin)),        median(Y(owner & ~refin))]);
fprintf('Median Liquid Asset to Income  = %9.2f %9.2f %9.2f \n',  [median(LY(owner)),       median(LY(owner & refin)),       median(LY(owner & ~refin))]);
fprintf('Median Share Housing Wealth    = %9.2f %9.2f %9.2f \n',  [median(Sh(owner)),       median(Sh(owner & refin)),       median(Sh(owner & ~refin))]);
fprintf('Median Wealth                  = %9.2f %9.2f %9.2f \n',  [median(Wtemp(owner)),    median(Wtemp(owner & refin)),    median(Wtemp(owner & ~refin))]);
fprintf('Median LTV                     = %9.2f %9.2f %9.2f \n',  [median(LTV(owner)),      median(LTV(owner & refin)),      median(LTV(owner & ~refin))]);
fprintf('Median House                   = %9.2f %9.2f %9.2f \n',  [median(Htemp(owner)),    median(Htemp(owner & refin)),    median(Htemp(owner & ~refin))]);
fprintf('Median Age                     = %9.2f %9.2f %9.2f \n',  [median(Age(owner)),      median(Age(owner & refin)),      median(Age(owner & ~refin))]);

fprintf('\n');
fprintf('\n');


