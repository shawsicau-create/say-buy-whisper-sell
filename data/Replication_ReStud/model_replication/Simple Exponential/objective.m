function err_mom = objective(x)

set(groot, 'DefaultAxesLineWidth', 1.5);
set(groot, 'DefaultLineLineWidth', 4);
set(groot, 'DefaultAxesTickLabelInterpreter','latex'); 
set(groot, 'DefaultLegendInterpreter','latex');
set(groot, 'DefaultAxesFontSize',22);
  
intmeth      = 'linear';
printr       = 0; 

optset('bisect', 'tol', 1e-32);

% Calibrated Parameters

p.beta       = x(1);                              % discount factor
p.alpha      = x(2);                              % weight on housing in preferences
p.R          = x(3); 
p.phi        = x(4);                              % productivity non-market
p.F0m        = x(5);                              % fixed cost of refinancing
p.B          = x(6);
p.rh         = (1 + x(7))^(1/4) - 1;              % interest rate
p.r1         = x(8); 
p.r2         = x(9);                              % parameters governing shape of rl curve

% Assigned Parameters

p.rl         = (1 - 0.028)^(1/4) - 1;             % lower bound on liquid rate

p.T          = 61*4;                              % last period of life
p.D          = 30*4;                              % maturity of mortgages

p.sigma      = 2;                                 % CRRA
p.gamma      = 1;                                 % Frisch elasticity of non-market production

p.rm         = (1 + 0.025)^(1/4) - 1;             % interest rate
 
p.Fs         = 0.06;                              % fixed cost of selling home
p.F1m        = 0.005;                             % proportional cost of refinancing

p.wbar       = 0.00001;                           % parameter governing luxuriousness of bequests 

p.thetam     = 0.85;                              % maximum LTV
p.thetay     = 0.214;                             % maximum PTI

rhoz         = 0.9908;           
sz           = 0.0761;
se           = (1 - 0.55)^(1/2)*0.4869;           % Krueger Perri (2011) show 55% of the variance of trans compon is measurement error so subtract


time         = (1 : 1 : p.T)'; 
p.lambdat    = exp(0.07982636 - 0.02322307 * (time/4 + 25) + 0.00105409 * (time/4 + 25).^2 - 0.00001028 * (time/4 + 25).^3);

p.thetay     = p.thetay*(1 - 0.3126./(1 + exp(18.629 - 0.3049*(time/4 + 25)))); 

p.mbar       = p.rm/(1 - (1 + p.rm)^(-p.D));      % minimum payment required per 1 of initial debt


% Quality of Approximation
 
p.na         = 50;                                % number of nodes for liquid assets
p.nl         = 75;                                % number of nodes for liquidity
p.no         = 9;                                 % number of nodes for omega (fraction of loan outstanding)
p.nt         = 3;                                 % number of possible initial LTV
p.nh         = 7;                                 % number of nodes for housing
p.nz         = 9;                                 % points for exogenous income z
p.ne         = 3;


% Discretize Income Process

[zgrid, Fzz] = rouwenhorst(rhoz, sz, p.nz);
p.zgrid      = exp(zgrid');
 
[Fz, d]      = eigs(Fzz', 1, 'largestabs');
Fz           = Fz/sum(Fz); 
Fz           = full(Fz);                                            % ergodic distribution of z

[egrid, we]  = qnwnorm(p.ne, 0, se^2);
p.egrid      = exp(egrid);


% Discretize other state variables

amin         = 0; 
amax         = 100; 
p.agrid      = amin + (amax - amin)*nodeunif(p.na, 0, 1).^2;

omin         = 0;
omax         = 1;
p.ogrid      = omin + (omax - omin)*nodeunif(p.no, 0, 1);

tmin         = 0.5; 
tmax         = p.thetam;                                                   
p.tgrid      = tmin + (tmax - tmin)*nodeunif(p.nt, 0, 1);

hmin         = 5;                                                           % minimum house size
hmax         = 40;                                                          % maximum house size
p.hgrid      = hmin + (hmax - hmin)*nodeunif(p.nh, 0, 1).^1.5;

ymax         = max(p.lambdat)*zgrid(end)*egrid(end); 

lmin         = -0.1;
lmax         = 125;
p.lgrid      = lmin + (lmax - lmin)*nodeunif(p.nl, 0, 1).^1.5;


% Construct grids: 

svbarh       = gridmake(p.agrid, p.ogrid, p.tgrid, p.hgrid, p.zgrid);         % grid for expected value of homeowners
svbarr       = gridmake(p.agrid,                            p.zgrid);         % grid for expected value of renters

svh          = gridmake(p.agrid, p.ogrid, p.tgrid, p.hgrid, p.zgrid, p.egrid);  % grid for value of homeowners prior to making h choice
svr          = gridmake(p.agrid,                            p.zgrid, p.egrid);  % grid for value of renters    prior to making h choice

swh          = gridmake(p.lgrid, p.ogrid, p.tgrid, p.hgrid, p.zgrid);           % grid for W functions
swr          = gridmake(p.lgrid,                            p.zgrid); 

ind2h        = kron((1:1:p.no*p.nt*p.nh*p.nz)', ones(p.nl, 1));               % index of all other state-variables to speed up evaluations (Bangladesh)
ind2r        = kron((1:1:               p.nz)', ones(p.nl, 1));                


vbarh        = zeros(p.na*p.no*p.nt*p.nh*p.nz, p.T + 1);                      % expected values of homeowners
vbarr        = zeros(p.na*p.nz,                p.T + 1);                      % expected values of renters

vh           = zeros(p.na*p.no*p.nt*p.nh*p.nz*p.ne, p.T);                       % value of homeowners prior to making h choice (envelope over 5 possible options)
vr           = zeros(p.na*p.nz*p.ne,                p.T);                       % value of renters    prior to making h choice (envelope over possible options)

wh           = zeros(p.nl*p.no*p.nt*p.nh*p.nz, p.T);                          % value of homeowners after making h choice
wr           = zeros(p.nl*p.nz,                p.T);                          % value of renters    after making h choice

ch           = zeros(p.nl*p.no*p.nt*p.nh*p.nz, p.T);                          % consumption homeowners after making h choice
cr           = zeros(p.nl*p.nz,                p.T);                          % consumption of renters    after making h choice

aprimeh      = zeros(p.nl*p.no*p.nt*p.nh*p.nz, p.T);                          % liquid savings of homeowners after making h choice
aprimer      = zeros(p.nl*p.nz,                p.T);                          % liquid savings of renters    after making h choice

cmaxh        = bisect('savings', 1e-13, 1e5, p.lgrid, p, 'h', amin);  % c that implies a' = amin
cmaxr        = bisect('savings', 1e-13, 1e5, p.lgrid, p, 'r', amin); 

cminh        = bisect('savings', 1e-13, 1e5, p.lgrid, p, 'h', amax);  % c that implies a' = amax
cminr        = bisect('savings', 1e-13, 1e5, p.lgrid, p, 'r', amax);  

cmaxh        = repmat(cmaxh, p.no*p.nt*p.nh*p.nz, 1);
cmaxr        = repmat(cmaxr, p.nz,                1); 

cminh        = repmat(cminh, p.no*p.nt*p.nh*p.nz, 1);
cminr        = repmat(cminr, p.nz,                1); 

lh           = zeros(p.na*p.no*p.nt*p.nh*p.nz*p.ne, p.T);                     % liquidity of homeowners after making h choice (envelope over 5 possible options)
lr           = zeros(p.na*p.nz*p.ne,                p.T);                      % liquidity of renters    after making h choice (envelope over possible options)

omegaprimeh  = zeros(p.na*p.no*p.nt*p.nh*p.nz*p.ne, p.T);                       
omegaprimer  = zeros(p.na*p.nz*p.ne,                p.T);                        

thetaprimeh  = zeros(p.na*p.no*p.nt*p.nh*p.nz*p.ne, p.T);                        
thetaprimer  = zeros(p.na*p.nz*p.ne,                p.T);                       

hprimeh      = zeros(p.na*p.no*p.nt*p.nh*p.nz*p.ne, p.T);                        
hprimer      = zeros(p.na*p.nz*p.ne,                p.T);                        

dh           = zeros(p.na*p.no*p.nt*p.nh*p.nz*p.ne, p.T);                        
dr           = zeros(p.na*p.nz*p.ne,                p.T);                      


% Terminal value of bequests

vbarh(:, p.T + 1) = p.B*(p.wbar + (1 + p.rl)*svbarh(:,1) + (1 - p.Fs - svbarh(:,2).*svbarh(:,3)*(1 + p.rl)).*svbarh(:,4)).^(1 - p.sigma)/(1 - p.sigma);
vbarr(:, p.T + 1) = p.B*(p.wbar + (1 + p.rl)*svbarr(:,1)).^(1 - p.sigma)/(1 - p.sigma);

for t = p.T : -1 : 1

   % tic

    EVh      = griddedInterpolant({p.agrid, (1: 1:p.no*p.nt*p.nh*p.nz)'},  reshape(vbarh(:, t + 1), p.na, p.no*p.nt*p.nh*p.nz), intmeth, 'linear');
    EVr      = griddedInterpolant({p.agrid, (1: 1:               p.nz)'},  reshape(vbarr(:, t + 1), p.na,                p.nz), intmeth, 'linear');
 
    % solve consumption-savings choice
    
    
    ch(:, t) = solve_golden('wfunc', cminh, cmaxh, swh, ind2h, EVh, p, 'h');
    cr(:, t) = solve_golden('wfunc', cminr, cmaxr, swr, ind2r, EVr, p, 'r');
    
    
    [~, aprimeh(:,t)] = savings(ch(:, t), swh, p, 'h');
    [~, aprimer(:,t)] = savings(cr(:, t), swr, p, 'r');

    wh(:, t) = wfunc(ch(:, t), swh, ind2h, EVh, p, 'h');
    wr(:, t) = wfunc(cr(:, t), swr, ind2r, EVr, p, 'r');

    Whinterp = griddedInterpolant({p.lgrid, (1: 1: p.no*p.nt*p.nh*p.nz)'},  reshape(wh(:, t), p.nl, p.no*p.nt*p.nh*p.nz), intmeth, 'linear'); 
    Wrinterp = griddedInterpolant({p.lgrid, (1: 1:                p.nz)'},  reshape(wr(:, t), p.nl,                p.nz), intmeth, 'linear');

    
    % Solve discrete choice problem of renters

    A        = svr(:,1); 
    Y        = p.lambdat(t)*svr(:,2).*svr(:,3);
    znow     = repmat(kron((1: 1 : p.nz)', ones(p.na, 1)), p.ne, 1);    % index of z in (a, z, e) space for renters
   

    [lr(:,t), omegaprimer(:,t), thetaprimer(:,t), hprimer(:,t), vr(:,t), dr(:,t)] = solveh(svr, Whinterp, Wrinterp, p, p.thetay(t), 'r', A, Y, znow);
   
    
    % Solve discrete choice problem of housing
    
    A        = svh(:,1); 
    Y        = p.lambdat(t)*svh(:,5).*svh(:,6);
    
    znow     = repmat(kron((1: 1 : p.nz)', ones(p.na*p.no*p.nt*p.nh, 1)), p.ne,      1);             % index of z in (a, omega, theta, h, z, e) space for owners
    hnow     = repmat(kron((1: 1 : p.nh)', ones(p.na*p.no*p.nt,      1)), p.nz*p.ne, 1);             % index of h in (a, omega, theta, h, z, e) space for owners
    tnow     = repmat(kron((1: 1 : p.nt)', ones(p.na*p.no,           1)), p.nh*p.nz*p.ne, 1);        % index of theta in (a, omega, theta, h, z, e) space for owners

    
    [lh(:,t), omegaprimeh(:,t), thetaprimeh(:,t), hprimeh(:,t), vh(:,t), dh(:,t)] = solveh(svh, Whinterp, Wrinterp, p, p.thetay(t), 'h', A, Y, znow, hnow, tnow);
    
    % Compute expected value and update vbar
    
    for i = 1 : p.ne
        
    vbarh(:,t)        = vbarh(:,t) + we(i)*kronm({p.na*p.no*p.nt*p.nh, Fzz}, vh((i-1)*p.na*p.no*p.nt*p.nh*p.nz + 1 : i*p.na*p.no*p.nt*p.nh*p.nz, t)); 
    vbarr(:,t)        = vbarr(:,t) + we(i)*kronm({p.na,                Fzz}, vr((i-1)*p.na*p.nz + 1                : i*p.na*p.nz, t)); 

    end
    
    %fprintf('%6i %6.3f\n',[t toc]);

end



simulate
