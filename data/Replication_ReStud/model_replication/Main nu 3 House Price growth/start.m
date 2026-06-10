clear; 
clc;

set(groot, 'DefaultAxesLineWidth', 1.5);
set(groot, 'DefaultLineLineWidth', 4);
set(groot, 'DefaultAxesTickLabelInterpreter','latex'); 
set(groot, 'DefaultLegendInterpreter','latex');
set(groot, 'DefaultAxesFontSize',22);
  
intmeth      = 'linear';
printr       = 1; 

optset('bisect', 'tol', 1e-32);

% Calibrated Parameters

p.beta       = 0.986435;
p.alpha      = 0.289591;
p.R          = 0.009389;
p.phi        = 1.099649;                          % productivity non-market
p.F0m        = 0.209125;                          % fixed cost of refinancing
p.B          = 9.835208;                          % bequest motive
p.r1         = 0.457784; 
p.r2         = 8.735971; 
p.rh         = (1 + 0.015533)^(1/4) - 1;          % upper bound on liquid rate

p.g          = 0.012/4;                           % 1.2% from Denis email, version b)

%0.017466

% Assigned Parameters

p.nu         = 3;                                 % parameter in exponential distribution

p.pidelta    = [0.975;   0.025];                  % probability of expenditure shocks
p.delta      = [0;      0.0625];                  % expenditure shock, fraction of home (quarterly so divide by 4)

p.rl         = (1 - 0.028)^(1/4) - 1;             % lower bound on liquid rate

p.T          = 61*4;                              % last period of life
p.D          = 30*4;                              % maturity of mortgages

p.sigma      = 2;                                 % CRRA
p.gamma      = 1;                                 % Frisch elasticity of non-market production

p.rm         = (1 + 0.025)^(1/4) - 1;             % mortgage interest rate

p.Fs         = 0.06;                              % fixed cost of selling home
p.F1m        = 0.005;                             % proportional cost of refinancing

p.wbar       = 1;                                 % parameter governing luxuriousness of bequests 

p.thetam     = 0.85;                              % maximum LTV
p.thetay     = 0.214;                             % maximum PTI

rhoz         = 0.9908;           
sz           = 0.0761;
se           = (1 - 0.55)^(1/2)*0.4869;           % Krueger Perri (2011) show 55% of the variance of trans compon is measurement error so subtract

time         = (1 : 1 : p.T)'; 
p.lambdat    = exp(0.07982636 - 0.02322307 * (time/4 + 25) + 0.00105409 * (time/4 + 25).^2 - 0.00001028 * (time/4 + 25).^3);

p.thetay     = p.thetay*(1 - 0.3126./(1 + exp(18.629 - 0.3049*(time/4 + 25)))); 

p.mbar       = p.rm/(1 - (1 + p.rm)^(-p.D));      % minimum payment required per 1 of initial debt

p.Pt         = [(1 + p.g).^(time - 1); (1 + p.g)^p.T];   % add one more to compute value of bequests
p.Rt         = p.R*p.Pt; 

% Quality of Approximation
 
p.na         = 75;                                % number of nodes for liquid assets
p.nat        = 75;                                % number of nodes for atilde = (1 + rl)*a - delta*h
p.nl         = 75;                                % number of nodes for liquidity
p.no         = 11;                                % number of nodes for omega (fraction of loan outstanding)
p.nt         = 9;                                 % number of possible initial LTV
p.nh         = 7;                                 % number of nodes for housing
p.nz         = 9;                                 % points for exogenous income z
p.ne         = 3;


% Discretize Income Process

[zgrid, Fzz] = rouwenhorst(rhoz, sz, p.nz);
zgrid        = exp(zgrid');
p.zgrid      = zgrid;
 
[Fz, d]      = eigs(Fzz', 1, 'largestabs');
Fz           = Fz/sum(Fz); 
Fz           = full(Fz);                                                          % ergodic distribution of z

[egrid, we]  = qnwnorm(p.ne, 0, se^2);
egrid        = exp(egrid);
p.egrid      = egrid;


% Discretize other state variables

amin         = -0.4; 
amax         = 100; 
p.agrid      = amin + (amax - amin)*nodeunif(p.na, 0, 1).^2;

omin         = 0;
omax         = 1;
p.ogrid      = omin + (omax - omin)*nodeunif(p.no, 0, 1);

tmin         = 0; 
tmax         = p.thetam;                                                         % allow to cover fixed cost                                            
p.tgrid      = tmin + (tmax - tmin)*nodeunif(p.nt, 0, 1);
 

hmin         = 5;                                                                % minimum house size
hmax         = 40;                                                               % maximum house size
p.hgrid      = hmin + (hmax - hmin)*nodeunif(p.nh, 0, 1).^1.5;

ymin         = min(p.lambdat)*zgrid(1)*egrid(1); 
ymax         = max(p.lambdat)*zgrid(end)*egrid(end); 

lmin         = -1;                                                               % keep it reasonably negative so they know that's a bad state to find yourself in 
lmax         = 125;
p.lgrid      = lmin + (lmax - lmin)*nodeunif(p.nl, 0, 1).^1.5;

atmin        = -p.delta(2)*hmax + (1 + p.rl)*amin;
atmax        =                    (1 + p.rh)*amax;
p.atgrid     = atmin + (atmax - atmin)*nodeunif(p.nat, 0, 1).^1.5;



% Construct grids: 

svbarh       = gridmake(p.agrid,  p.ogrid, p.tgrid, p.hgrid, p.zgrid);           % grid for expected value of homeowners
svbarr       = gridmake(p.agrid,                             p.zgrid);           % grid for expected value of renters

svh          = gridmake(p.atgrid, p.ogrid, p.tgrid, p.hgrid, p.zgrid, p.egrid);  % grid for value of homeowners prior to making h choice
svr          = gridmake(p.atgrid,                            p.zgrid, p.egrid);  % grid for value of renters    prior to making h choice

swh          = gridmake(p.lgrid, p.ogrid, p.tgrid, p.hgrid, p.zgrid);            % grid for W functions
swr          = gridmake(p.lgrid,                            p.zgrid); 

svht         = gridmake(p.agrid, p.ogrid, p.tgrid, p.hgrid, p.zgrid, p.egrid);   % grid for computing intermediate value function (creier prajit)
svrt         = gridmake(p.agrid,                            p.zgrid, p.egrid);

ind2h        = kron((1:1:p.no*p.nt*p.nh*p.nz)', ones(p.nl, 1));                  % index of all other state-variables to speed up evaluations (Bangladesh)
ind2r        = kron((1:1:               p.nz)', ones(p.nl, 1));                

ind3h        = kron((1:1:p.no*p.nt*p.nh*p.nz*p.ne)', ones(p.na, 1));             % index of all other state-variables to speed up evaluations (Bangladesh)
ind3r        = kron((1:1:               p.nz*p.ne)', ones(p.na, 1));                


vbarh        = zeros(p.na*p.no*p.nt*p.nh*p.nz, p.T + 1);                         % expected values of homeowners
vbarr        = zeros(p.na*p.nz,                p.T + 1);                         % expected values of renters

vh           = zeros(p.nat*p.no*p.nt*p.nh*p.nz*p.ne, p.T);                       % value of homeowners prior to making h choice (envelope over 5 possible options)
vr           = zeros(p.nat*p.nz*p.ne,                p.T);                       % value of renters    prior to making h choice (envelope over possible options)

wh           = zeros(p.nl*p.no*p.nt*p.nh*p.nz, p.T);                             % value of homeowners after making h choice
wr           = zeros(p.nl*p.nz,                p.T);                             % value of renters    after making h choice

ch           = zeros(p.nl*p.no*p.nt*p.nh*p.nz, p.T);                             % consumption homeowners after making h choice
cr           = zeros(p.nl*p.nz,                p.T);                             % consumption of renters    after making h choice



% Terminal value of bequests

rlh               = interest(svbarh(:,1), p); 
rlr               = interest(svbarr(:,1), p); 

vbarh(:, p.T + 1) = p.pidelta(1)*p.B*(p.wbar + (1 + rlh).*svbarh(:,1) + (1 - p.Fs - svbarh(:,2).*svbarh(:,3)*(1 + p.rm) - p.delta(1)).*p.Pt(p.T+1).*svbarh(:,4)).^(1 - p.sigma)/(1 - p.sigma) + ...
                    p.pidelta(2)*p.B*(p.wbar + (1 + rlh).*svbarh(:,1) + (1 - p.Fs - svbarh(:,2).*svbarh(:,3)*(1 + p.rm) - p.delta(2)).*p.Pt(p.T+1).*svbarh(:,4)).^(1 - p.sigma)/(1 - p.sigma);
                
vbarr(:, p.T + 1) = p.B*(p.wbar + (1 + rlr).*svbarr(:,1)).^(1 - p.sigma)/(1 - p.sigma);


for t = p.T : -1 : 1

    EVh      = griddedInterpolant({p.agrid, (1: 1:p.no*p.nt*p.nh*p.nz)'},  reshape(vbarh(:, t + 1), p.na, p.no*p.nt*p.nh*p.nz), intmeth, 'linear');
    EVr      = griddedInterpolant({p.agrid, (1: 1:               p.nz)'},  reshape(vbarr(:, t + 1), p.na,                p.nz), intmeth, 'linear');
 
    % solve consumption-savings choice
    
    % first, find bounds on c
    
    cmaxh        = bisect('savings', 1e-13, 1e5, p.lgrid, p, p.Rt(t), 'h', amin);             % c that implies a' = amin
    cmaxr        = bisect('savings', 1e-13, 1e5, p.lgrid, p, p.Rt(t), 'r', amin); 

    cminh        = bisect('savings', 1e-13, 1e5, p.lgrid, p, p.Rt(t), 'h', amax);             % c that implies a' = amax
    cminr        = bisect('savings', 1e-13, 1e5, p.lgrid, p, p.Rt(t), 'r', amax);  

    cmaxh        = repmat(cmaxh, p.no*p.nt*p.nh*p.nz, 1);
    cmaxr        = repmat(cmaxr, p.nz,                1); 

    cminh        = repmat(cminh, p.no*p.nt*p.nh*p.nz, 1);
    cminr        = repmat(cminr, p.nz,                1); 

    ch(:, t)     = solve_golden('wfunc', cminh, cmaxh, swh, ind2h, EVh, p, p.Rt(t), 'h');
    cr(:, t)     = solve_golden('wfunc', cminr, cmaxr, swr, ind2r, EVr, p, p.Rt(t), 'r');
   
    wh(:, t)     = wfunc(ch(:, t), swh, ind2h, EVh, p, p.Rt(t), 'h');
    wr(:, t)     = wfunc(cr(:, t), swr, ind2r, EVr, p, p.Rt(t), 'r');

    Whinterp     = griddedInterpolant({p.lgrid, (1: 1: p.no*p.nt*p.nh*p.nz)'},  reshape(wh(:, t), p.nl, p.no*p.nt*p.nh*p.nz), intmeth, 'linear'); 
    Wrinterp     = griddedInterpolant({p.lgrid, (1: 1:                p.nz)'},  reshape(wr(:, t), p.nl,                p.nz), intmeth, 'linear');

    
    % Solve discrete choice problem of renters

    At       = svr(:,1); 
    Y        = p.lambdat(t)*svr(:,2).*svr(:,3);
    znow     = repmat(kron((1: 1 : p.nz)', ones(p.nat, 1)), p.ne, 1);    % index of z in (a, z, e) space for renters
   
    [~, ~, ~, ~, vr(:,t)] = solveh(svr, Whinterp, Wrinterp, p, p.thetay(t), 'r', At, Y, p.Pt(t), p.Rt(t), znow);
   
    
    % Solve discrete choice problem of housing
    
    At       = svh(:,1); 
    Y        = p.lambdat(t)*svh(:,5).*svh(:,6);
    
    znow     = repmat(kron((1: 1 : p.nz)', ones(p.nat*p.no*p.nt*p.nh, 1)), p.ne,      1);             % index of z in (a, omega, theta, h, z, e) space for owners
    hnow     = repmat(kron((1: 1 : p.nh)', ones(p.nat*p.no*p.nt,      1)), p.nz*p.ne, 1);             % index of h in (a, omega, theta, h, z, e) space for owners
    tnow     = repmat(kron((1: 1 : p.nt)', ones(p.nat*p.no,           1)), p.nh*p.nz*p.ne, 1);        % index of theta in (a, omega, theta, h, z, e) space for owners

    
    [~, ~, ~, ~, vh(:,t)] = solveh(svh, Whinterp, Wrinterp, p, p.thetay(t), 'h', At, Y, p.Pt(t), p.Rt(t), znow, hnow, tnow);
    
    % We need to interpolate to calculate the expected value before the delta shocks are realized, but after the z,e shocks are realized 
    
    Vhinterp      = griddedInterpolant({p.atgrid, (1: 1:p.no*p.nt*p.nh*p.nz*p.ne)'},  reshape(vh(:, t), p.nat, p.no*p.nt*p.nh*p.nz*p.ne), intmeth, 'linear');
    Vrinterp      = griddedInterpolant({p.atgrid, (1: 1:               p.nz*p.ne)'},  reshape(vr(:, t), p.nat,                p.nz*p.ne), intmeth, 'linear');
    
    
    % Compute expected value and update vbar

    % 1. Step 1: integrate delta shocks by interpolating value of home and rent (which are functions of atilde)
    
    vhtemp        = p.pidelta(1)*Vhinterp((1 + interest(svht(:,1), p)).*svht(:,1) - p.delta(1)*svht(:, 4), ind3h) + p.pidelta(2)*Vhinterp((1 + interest(svht(:,1), p)).*svht(:,1) - p.delta(2)*svht(:, 4), ind3h);
    
    vrtemp        = Vrinterp((1 + interest(svrt(:,1), p)).*svrt(:,1), ind3r);

    % 2. Step 2: integrate income shocks
    
    for i = 1 : p.ne
        
    vbarh(:,t)    = vbarh(:,t) + we(i)*kronm({p.na*p.no*p.nt*p.nh, Fzz}, vhtemp((i - 1)*p.na*p.no*p.nt*p.nh*p.nz + 1 : i*p.na*p.no*p.nt*p.nh*p.nz)); 
    vbarr(:,t)    = vbarr(:,t) + we(i)*kronm({p.na,                Fzz}, vrtemp((i - 1)*p.na*p.nz + 1                : i*p.na*p.nz)); 

    end
    
end


simulate

simulate_liquidity