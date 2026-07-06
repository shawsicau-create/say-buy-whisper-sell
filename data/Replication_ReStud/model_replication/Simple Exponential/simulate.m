close all

set(groot, 'DefaultAxesLineWidth', 1.5);
set(groot, 'DefaultLineLineWidth', 4);
set(groot, 'DefaultAxesTickLabelInterpreter','latex'); 
set(groot, 'DefaultLegendInterpreter','latex');
set(groot, 'DefaultAxesFontSize',24);


N     = 2500;
T     = 450; 

A     = zeros(2*N, T + 1);        % Liquid Assets 
Th    = zeros(2*N, T + 1);        % initial mortgage size
  
C     = zeros(2*N, T);            % consumption
L     = zeros(2*N, T);            % liquidity after making housing choice
R     = zeros(2*N, T);            % decision to refinance
X     = zeros(2*N, T);            % amount extracted

Age   = zeros(2*N, T);            % age of loan


% First simulate history of shocks to income

rng(100); 

Y            = randn(N, T)*se; 
Y            = exp([Y; -Y]); 

Th(:, 1)     = p.thetam; 
A(:, 1)      = 0; 
Age(:,1)     = 1; 


for t = 1 : T

unif         = rand(2*N, 1); 
    
state        = [(1 + p.rl)*A(:,t) + Y(:,t), Th(:,t)];    

[~, pall, ~, Lall, thetall] = solveh(state, Winterp, p);

R(:,t)       = unif <= pall(:,1); 

L(:,t)       = Lall(:,1).*R(:,t) + Lall(:,2).*(1 - R(:,t));        % when many options: generate a single unif and ask which interval belongs to

Th(:, t+1)   = thetall(:,1).*R(:,t) + thetall(:,2).*(1 - R(:,t)); 

cmax         = bisect('savings', 1e-13, 1e5, L(:,t), p, amin);     % c that implies a' = amin
cmin         = bisect('savings', 1e-13, 1e5, L(:,t), p, amax);     % c that implies a' = amax

C(:,t)          = max(min(Cinterp(L(:,t), Th(:,t+1)), cmax), cmin); 

[~, A(:, t+1)]  = savings(C(:,t), L(:,t), p);
    
Age(:, t+1)     = (Age(:,t) + 1).*(1 - R(:,t)) + R(:,t); 

X(:,t)       = (Th(:,t+1) - Th(:,t))./Th(:,t).*R(:,t); 

end

 

  A(:, 1 : 150)   = [];
 Th(:, 1 : 150)   = [];
  C(:, 1 : 150)   = [];
  R(:, 1 : 150)   = [];
  L(:, 1 : 150)   = [];
  Y(:, 1 : 150)   = [];
  X(:, 1 : 150)   = [];
Age(:, 1 : 150)   = []; 
  
Asave        = A; 
Thsave       = Th; 
Csave        = C; 
Lsave        = L;
Rsave        = R; 
Ysave        = Y; 
Xsave        = X; 
Agesave      = Age; 


 A(:,  end)  = [];
 Th(:, end)  = [];
Age(:, end)  = []; 
 
Age          = floor(Age/4);

D            = Th.*p.hbar; 
W            = A + p.hbar - D; 

Yh           = p.phi^(1/p.gamma)*C.^(-p.sigma/p.gamma); 



figure(2)

id = 1; 

subplot(1, 3, 1), plot([C(id, :)', Y(id, :)']); 
title('Consumption and Income', 'Interpreter','Latex');
h = legend('consumption', 'income');
set(gca, 'ygrid', 'on')
set(h,'Interpreter','latex'); 


subplot(1, 3, 2), plot([A(id, :)', p.hbar.*(1 - Th(id, :)')]); 
title('Wealth', 'Interpreter','Latex');
set(gca, 'ygrid', 'on')
h = legend('liquid', 'illiquid');
set(h,'Interpreter','latex'); 


subplot(1, 3, 3), plot(Th(id, :)'); 
title('Debt', 'Interpreter','Latex');
set(gca, 'ygrid', 'on')
set(h,'Interpreter','latex'); 


fextract              = mean(vec(X >= 0.05))*4; 
medianextract         = median(X(X >= 0.05)); 

HY                    = p.hbar./Y/4;
PTI                   = p.mbar*p.hbar./Y; 



moment_model          = zeros(60, 1); 

moment_model(1)       = mean(W(:)) /mean(vec(Y))/4;
moment_model(2)       = p.hbar     /mean(vec(Y))/4;
moment_model(3)       = mean(D(:)) /mean(vec(Y))/4; 
moment_model(4)       = mean(A(:)) /mean(vec(Y))/4;

moment_model(5)       = fextract;
moment_model(6)       = mean(vec(Yh))/mean(vec(C));


moment_model(7  : 11) = prctile( A(:),  [10; 25; 50; 75; 90])/mean(vec(Y))/4;
moment_model(12 : 16) = prctile(Th(:),  [10; 25; 50; 75; 90]);
moment_model(17 : 21) = prctile((1 - Th(:)).*p.hbar./W(:), [10; 25; 50; 75; 90]);
moment_model(22 : 26) = prctile( W(:),  [10; 25; 50; 75; 90])/mean(vec(Y))/4;
moment_model(27 : 31) = prctile(PTI(:), [10; 25; 50; 75; 90]);
moment_model(32 : 36) = prctile(HY(:),  [10; 25; 50; 75; 90]);
moment_model(37 : 41) = prctile(Age(:), [10; 25; 50; 75; 90]);
moment_model(42)      = medianextract;


moment_data = [1.45; 1.82; 0.83; 0.46; 0.08; 0.23; -0.04; 0.01; 0.15; 0.68; 1.69;  
               0.18; 0.39; 0.62; 0.77; 0.88; 0.36; 0.64; 0.87; 0.99; 1.04; 0; 0.04; 0.73; 2.34; 3.94;
               0.05; 0.08; 0.11; 0.17; 0.24; 1.02; 1.62; 2.48; 3.78; 6.43; 0; 1; 3; 6; 10; 0.23];

           

fprintf('\n')
fprintf('Aggregate Wealth to Income                         = %9.2f %9.2f\n',  [moment_model(1),    moment_data(1)]);
fprintf('Aggregate Housing to Income                        = %9.2f %9.2f\n',  [moment_model(2),    moment_data(2)]);
fprintf('Aggregate Debt to Income                           = %9.2f %9.2f\n',  [moment_model(3),    moment_data(3)]);
fprintf('Aggregate Liquid assets to Income                  = %9.2f %9.2f\n',  [moment_model(4),    moment_data(4)]);
fprintf('Non-Market Production to Consumption               = %9.2f %9.2f\n',  [moment_model(6),    moment_data(6)]);
fprintf('\n')
fprintf('Fraction Borrowers who extract                     = %9.2f %9.2f\n',  [moment_model(5),    moment_data(5)]);
fprintf('Median Change in the Balance                       = %9.2f %9.2f\n',  [moment_model(42),   moment_data(42)]);
fprintf('\n')

fprintf('10 pctile liquid assets owners                     = %9.2f %9.2f\n',  [moment_model(7),    moment_data(7)]);
fprintf('25 pctile liquid assets owners                     = %9.2f %9.2f\n',  [moment_model(8),    moment_data(8)]);
fprintf('50 pctile liquid assets owners                     = %9.2f %9.2f\n',  [moment_model(9),    moment_data(9)]);
fprintf('75 pctile liquid assets owners                     = %9.2f %9.2f\n',  [moment_model(10),   moment_data(10)]);
fprintf('90 pctile liquid assets owners                     = %9.2f %9.2f\n',  [moment_model(11),   moment_data(11)]);

fprintf('\n')


fprintf('10 pctile LTV, borrowers                           = %9.2f %9.2f\n',  [moment_model(12),   moment_data(12)]);
fprintf('25 pctile LTV, borrowers                           = %9.2f %9.2f\n',  [moment_model(13),   moment_data(13)]);
fprintf('50 pctile LTV, borrowers                           = %9.2f %9.2f\n',  [moment_model(14),   moment_data(14)]);
fprintf('75 pctile LTV, borrowers                           = %9.2f %9.2f\n',  [moment_model(15),   moment_data(15)]);
fprintf('90 pctile LTV, borrowers                           = %9.2f %9.2f\n',  [moment_model(16),   moment_data(16)]);
fprintf('\n')
fprintf('10 Share Housing Wealth in Owner Wealth            = %9.2f %9.2f\n',  [moment_model(17),   moment_data(17)]);
fprintf('25 Share Housing Wealth in Owner Wealth            = %9.2f %9.2f\n',  [moment_model(18),   moment_data(18)]);
fprintf('50 Share Housing Wealth in Owner Wealth            = %9.2f %9.2f\n',  [moment_model(19),   moment_data(19)]);
fprintf('75 Share Housing Wealth in Owner Wealth            = %9.2f %9.2f\n',  [moment_model(20),   moment_data(20)]);
fprintf('90 Share Housing Wealth in Owner Wealth            = %9.2f %9.2f\n',  [moment_model(21),   moment_data(21)]);
fprintf('\n')
fprintf('10 pctile Wealth                                   = %9.2f %9.2f\n',  [moment_model(22),   moment_data(22)]);
fprintf('25 pctile Wealth                                   = %9.2f %9.2f\n',  [moment_model(23),   moment_data(23)]);
fprintf('50 pctile Wealth                                   = %9.2f %9.2f\n',  [moment_model(24),   moment_data(24)]);
fprintf('75 pctile Wealth                                   = %9.2f %9.2f\n',  [moment_model(25),   moment_data(25)]);
fprintf('90 pctile Wealth                                   = %9.2f %9.2f\n',  [moment_model(26),   moment_data(26)]);
fprintf('\n')
fprintf('10 pctile PTI                                      = %9.2f %9.2f\n',  [moment_model(27),   moment_data(27)]);
fprintf('25 pctile PTI                                      = %9.2f %9.2f\n',  [moment_model(28),   moment_data(28)]);
fprintf('50 pctile PTI                                      = %9.2f %9.2f\n',  [moment_model(29),   moment_data(29)]);
fprintf('75 pctile PTI                                      = %9.2f %9.2f\n',  [moment_model(30),   moment_data(30)]);
fprintf('90 pctile PTI                                      = %9.2f %9.2f\n',  [moment_model(31),   moment_data(31)]);
fprintf('\n')
fprintf('10 pctile housing to income                        = %9.2f %9.2f\n',  [moment_model(32),   moment_data(32)]);
fprintf('25 pctile housing to income                        = %9.2f %9.2f\n',  [moment_model(33),   moment_data(33)]);
fprintf('50 pctile housing to income                        = %9.2f %9.2f\n',  [moment_model(34),   moment_data(34)]);
fprintf('75 pctile housing to income                        = %9.2f %9.2f\n',  [moment_model(35),   moment_data(35)]);
fprintf('90 pctile housing to income                        = %9.2f %9.2f\n',  [moment_model(36),   moment_data(36)]);
fprintf('\n')
fprintf('10 pctile mortgage age                             = %9.2f %9.2f\n',  [moment_model(37),   moment_data(37)]);
fprintf('25 pctile mortgage age                             = %9.2f %9.2f\n',  [moment_model(38),   moment_data(38)]);
fprintf('50 pctile mortgage age                             = %9.2f %9.2f\n',  [moment_model(39),   moment_data(39)]);
fprintf('75 pctile mortgage age                             = %9.2f %9.2f\n',  [moment_model(40),   moment_data(40)]);
fprintf('90 pctile mortgage age                             = %9.2f %9.2f\n',  [moment_model(41),   moment_data(41)]);

% Calculate life time value
    
T  = size(C, 2); 

U  = C.^(1 - p.sigma)/(1 - p.sigma) -  p.phi^(1 + 1/p.gamma)/(1 + p.gamma)*C.^(-p.sigma*(1 + 1/p.gamma));  

V  = sum(p.beta.^(0 : 1 : T -1).*U, 2); 
    
V  = ((1 - p.sigma)*(1 - p.beta)*mean(V))^(1/(1 - p.sigma)); 

fprintf('\n') 
fprintf('Life Time Value, CEV                               = %9.4f \n',     V);

% Compare characteristics of those who refinance and don't 

S   = (1 - Th(:)).*p.hbar./W(:); 
R   = R(:) == 1; 

fprintf('\n');
fprintf('Mean Liquid Assets           = %9.2f %9.2f %9.2f \n',  [mean(A(:)),        mean(A(R)),                    mean(A(~R))]);
fprintf('Mean Income                  = %9.2f %9.2f %9.2f \n',  [mean(Y(:)),        mean(Y(R)),                    mean(Y(~R))]);
fprintf('Mean Liquid Asset to Income  = %9.2f %9.2f %9.2f \n',  [mean(A(:)./Y(:)),  mean(A(R)./Y(R)),              mean(A(~R)./Y(~R))]);
fprintf('Mean Share Housing Wealth    = %9.2f %9.2f %9.2f \n',  [mean(S(:)),        mean(S(R)),                    mean(S(~R))]);
fprintf('Mean Wealth                  = %9.2f %9.2f %9.2f \n',  [mean(W(:)),        mean(W(R)),                    mean(W(~R))]);
fprintf('Mean LTV                     = %9.2f %9.2f %9.2f \n',  [mean(Th(:)),       mean(Th(R)),                   mean(Th(~R))]);
fprintf('Mean Age                     = %9.2f %9.2f %9.2f \n',  [mean(Age(:)),      mean(Age(R)),                  mean(Age(~R))]);

fprintf('\n');
fprintf('\n');
