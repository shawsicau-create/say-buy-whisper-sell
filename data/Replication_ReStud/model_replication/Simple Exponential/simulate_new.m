A     = [Asave,   zeros(2*N, T)];           % Liquid Assets 
Th    = [Thsave,  zeros(2*N, T)];           % initial mortgage size

C     = [Csave,   zeros(2*N, T)];           % consumption
L     = [Lsave,   zeros(2*N, T)];           % liquidity after making housing choice
R     = [Rsave,   zeros(2*N, T)];           % refinance choice
X     = [Xsave,   zeros(2*N, T)];           % amount extracted
Age   = [Agesave, zeros(2*N, T)];           % age of loan


% First simulate history of shocks to income


Y     = randn(N, T)*se; 
Y     = [Ysave, exp([Y; -Y])]; 

S     = ones(2*N, size(Asave, 2) + T);  % interest state


for t = size(Asave, 2) : size(Asave, 2) + T - 1

unif         = rand(2*N, 1); 
    
state        = [(1 + p.rl)*A(:,t) + Y(:,t), Th(:,t), S(:,t)];    

[~, pall, ~, Lall, thetall] = solveh_new(state, Winterp, p);

R(:,t)       = unif <= pall(:,1); 

L(:,t)       = Lall(:,1).*R(:,t) + Lall(:,2).*(1 - R(:,t));        % when many options: generate a single unif and ask which interval belongs to

Th(:, t+1)   = thetall(:,1).*R(:,t) + thetall(:,2).*(1 - R(:,t)); 

cmax         = bisect('savings', 1e-13, 1e5, L(:,t), p, amin);     % c that implies a' = amin
cmin         = bisect('savings', 1e-13, 1e5, L(:,t), p, amax);     % c that implies a' = amax

C(:,t)          = max(min(Cinterp_new(L(:,t), Th(:,t+1), S(:,t+1)), cmax), cmin); 

[~, A(:, t+1)]  = savings(C(:,t), L(:,t), p);
    
Age(:, t+1)     = (Age(:,t) + 1).*(1 - R(:,t)) + R(:,t); 

X(:,t)       = (Th(:,t+1) - Th(:,t))./Th(:,t).*R(:,t); 

S(:,t + 1)   = S(:,t).*(1 - R(:,t)) + p.nr*R(:,t); 

end

 

 
figure(4)

id = 1; 

subplot(1, 3, 1), plot(mean(C)'); 
title('Consumption', 'Interpreter','Latex');
set(gca, 'ygrid', 'on')
set(h,'Interpreter','latex'); 


subplot(1, 3, 2), plot(mean(R)'); 
title('Fraction Refinance', 'Interpreter','Latex');
set(gca, 'ygrid', 'on')
set(h,'Interpreter','latex'); 


subplot(1, 3, 3), plot(mean(Th)'); 
title('LTV', 'Interpreter','Latex');
set(gca, 'ygrid', 'on')
set(h,'Interpreter','latex'); 

