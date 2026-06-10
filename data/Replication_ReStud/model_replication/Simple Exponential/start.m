clear; 
clc;

set(groot, 'DefaultAxesLineWidth', 1.5);
set(groot, 'DefaultLineLineWidth', 4);
set(groot, 'DefaultAxesTickLabelInterpreter','latex'); 
set(groot, 'DefaultLegendInterpreter','latex');
set(groot, 'DefaultAxesFontSize',22);
  
intmeth      = 'spline';
printr       = 1; 

optset('bisect', 'tol', 1e-32);

% Calibrated Parameters

p.beta       = 0.992;                                       % discount factor
p.F          = 0.22;                                        % fixed cost of refinancing
p.phi        = 1;                                           % productivity non-market
p.nu         = 3;                                           % 1 / volatility of extreme value shocks

% Assigned Parameters

p.rm         = (1 + 0.025)^(1/4) - 1;                       % mortgage rate
p.rl         = (1 + 0.010)^(1/4) - 1;                       % liquid rate

p.D          = 120;                                         % maturity of mortgages

p.sigma      = 2;                                           % CRRA
p.gamma      = 1; 
p.thetam     = 0.85;                                        % maximum LTV

se           = (1 - 0.55)^(1/2)*0.4869;                     % Krueger Perri (2011) show 55% of the variance of trans compon is measurement error so subtract

p.mbar       = p.rm/(1 - (1 + p.rm)^(-p.D))*p.thetam;       % minimum payment required per 1 of initial debt
p.hbar       = 8;                                           % house size

% Quality of Approximation
 
p.na         = 250;                                         % number of nodes for liquid assets
p.nw         = 250;                                         % number of nodes for cash on hand
p.nl         = 250;                                         % number of nodes for liquidity
p.nt         = 75; 
p.ny         = 71;


% Discretize Income Process

%[y, wy]      = qnwnorm(p.ny, 0, se^2);

%y            = exp(y); 

[y, wy]      = qnwunif(p.ny, 0, 1); 

y            = norminv(y, 0, 1)*se; 

y            = exp(y);

% Discretize other state variables

amin         = 0; 
amax         = 50; 
p.agrid      = amin + (amax - amin)*nodeunif(p.na, 0, 1).^2;

wmin         = min(y); 
wmax         = (1 + p.rl)*amax + max(y); 
p.wgrid      = wmin + (wmax - wmin)*nodeunif(p.nw, 0, 1).^2;

lmin         = -0.5;
lmax         = wmax + p.hbar;
p.lgrid      = lmin + (lmax - lmin)*nodeunif(p.nl, 0, 1).^2;


p.tgrid      = nodeunif(p.nt, 0, p.thetam); 

% Construct grids: 

sv           = gridmake(p.wgrid, p.tgrid);                          % grid for V 
sw           = gridmake(p.lgrid, p.tgrid);                          % grid for W
svbar        = gridmake(p.agrid, p.tgrid);                          % grid for Vbar (expected continuation value)

% Bounds on consumption mid-period

cmax         = bisect('savings', 1e-13, 1e5, p.lgrid, p, amin);     % c that implies a' = amin
cmin         = bisect('savings', 1e-13, 1e5, p.lgrid, p, amax);     % c that implies a' = amax

cmax         = repmat(cmax, p.nt, 1); 
cmin         = repmat(cmin, p.nt, 1); 



% Initial guess for value function

Vbar         = zeros(p.na*p.nt, 1); 

for iter = 1 : 5

    Vbarold     = Vbar;
    
    EV          = griddedInterpolant({p.agrid, p.tgrid},  reshape(Vbar, p.na, p.nt), intmeth, 'linear');
 
    % solve consumption-savings choice
    
    c           = solve_golden('wfunc', cmin, cmax, sw, EV, p);
    
    [~, aprime] = savings(c, sw, p);

    W           = wfunc(c, sw, EV, p);

    Winterp     = griddedInterpolant({p.lgrid, p.tgrid},  reshape(W, p.nl, p.nt), intmeth, 'linear'); 


    % Solve discrete choice problem

    V          = solveh(sv, Winterp, p);
   
    % Interpolate V(w, theta)
    
    Vinterp    = griddedInterpolant({p.wgrid, p.tgrid},  reshape(V, p.nw, p.nt), intmeth, 'linear'); 

    
    % Compute expected value and update vbar
    
    Vbar        = zeros(p.na*p.nt, 1); 

    for i = 1 : p.ny
        
    Vbar        = Vbar + wy(i)*Vinterp((1 + p.rl)*svbar(:,1) + y(i), svbar(:,2)); 
    
    end
    
    
    fprintf('%4i %6.2e \n', [iter, norm(Vbar - Vbarold)/norm(Vbar)]);    

end



% Apply Howard Improvement to Go Faster



for iter = 1 : 5000

    Vbarold     = Vbar;
    
    EV          = griddedInterpolant({p.agrid, p.tgrid},  reshape(Vbar, p.na, p.nt), intmeth, 'linear');
 
    % solve consumption-savings choice
    
    if mod(iter, 50) == 0
    
    c           = solve_golden('wfunc', cmin, cmax, sw, EV, p);
    
    end
    
    [~, aprime] = savings(c, sw, p);

    W           = wfunc(c, sw, EV, p);

    Winterp     = griddedInterpolant({p.lgrid, p.tgrid},  reshape(W, p.nl, p.nt), intmeth, 'linear'); 


    % Solve discrete choice problem

    V           = solveh(sv, Winterp, p);
   
    % Interpolate V(w, theta)
    
    Vinterp     = griddedInterpolant({p.wgrid, p.tgrid},  reshape(V, p.nw, p.nt), intmeth, 'linear'); 

    
    % Compute expected value and update vbar
    
    Vbar        = zeros(p.na*p.nt, 1); 

    for i = 1 : p.ny
        
    Vbar        = Vbar + wy(i)*Vinterp((1 + p.rl)*svbar(:,1) + y(i), svbar(:,2)); 
    
    end
    
    if mod(iter, 50) == 0
        
    fprintf('%4i %6.2e \n', [iter/50, norm(Vbar - Vbarold)/norm(Vbar)]);    

    if norm(Vbar - Vbarold)/norm(Vbar) < 1e-7, break, end
    
    end
    
end


Cinterp     = griddedInterpolant({p.lgrid, p.tgrid},  reshape(c, p.nl, p.nt), intmeth, 'linear');

plot_decisions
return
simulate

start_new

Cinterp_new = griddedInterpolant({p.lgrid, p.tgrid, p.rgrid},  reshape(c, p.nl, p.nt, p.nr), intmeth, 'linear');

simulate_new