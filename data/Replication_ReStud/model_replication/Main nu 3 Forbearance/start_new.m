
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

cmaxh        = bisect('savings', 1e-13, 1e5, p.lgrid, p, 'h', amin);             % c that implies a' = amin
cmaxr        = bisect('savings', 1e-13, 1e5, p.lgrid, p, 'r', amin); 

cminh        = bisect('savings', 1e-13, 1e5, p.lgrid, p, 'h', amax);             % c that implies a' = amax
cminr        = bisect('savings', 1e-13, 1e5, p.lgrid, p, 'r', amax);  

cmaxh        = repmat(cmaxh, p.no*p.nt*p.nh*p.nz, 1);
cmaxr        = repmat(cmaxr, p.nz,                1); 

cminh        = repmat(cminh, p.no*p.nt*p.nh*p.nz, 1);
cminr        = repmat(cminr, p.nz,                1); 


% Terminal value of bequests

rlh               = interest(svbarh(:,1), p); 
rlr               = interest(svbarr(:,1), p); 

vbarh(:, p.T + 1) = p.pidelta(1)*p.B*(p.wbar + (1 + rlh).*svbarh(:,1) + (1 - p.Fs - svbarh(:,2).*svbarh(:,3)*(1 + p.rm) - p.delta(1)).*svbarh(:,4)).^(1 - p.sigma)/(1 - p.sigma) + ...
                    p.pidelta(2)*p.B*(p.wbar + (1 + rlh).*svbarh(:,1) + (1 - p.Fs - svbarh(:,2).*svbarh(:,3)*(1 + p.rm) - p.delta(2)).*svbarh(:,4)).^(1 - p.sigma)/(1 - p.sigma);
                
vbarr(:, p.T + 1) = p.B*(p.wbar + (1 + rlr).*svbarr(:,1)).^(1 - p.sigma)/(1 - p.sigma);


for t = p.T : -1 : 1

    EVh      = griddedInterpolant({p.agrid, (1: 1:p.no*p.nt*p.nh*p.nz)'},  reshape(vbarh(:, t + 1), p.na, p.no*p.nt*p.nh*p.nz), intmeth, 'linear');
    EVr      = griddedInterpolant({p.agrid, (1: 1:               p.nz)'},  reshape(vbarr(:, t + 1), p.na,                p.nz), intmeth, 'linear');
 
    % solve consumption-savings choice
    
    ch(:, t)          = solve_golden('wfunc', cminh, cmaxh, swh, ind2h, EVh, p, 'h');
    cr(:, t)          = solve_golden('wfunc', cminr, cmaxr, swr, ind2r, EVr, p, 'r');
   
    wh(:, t)          = wfunc(ch(:, t), swh, ind2h, EVh, p, 'h');
    wr(:, t)          = wfunc(cr(:, t), swr, ind2r, EVr, p, 'r');

    Whinterp          = griddedInterpolant({p.lgrid, (1: 1: p.no*p.nt*p.nh*p.nz)'},  reshape(wh(:, t), p.nl, p.no*p.nt*p.nh*p.nz), intmeth, 'linear'); 
    Wrinterp          = griddedInterpolant({p.lgrid, (1: 1:                p.nz)'},  reshape(wr(:, t), p.nl,                p.nz), intmeth, 'linear');

    
    % Solve discrete choice problem of renters

    At       = svr(:,1); 
    Y        = p.lambdat(t)*svr(:,2).*svr(:,3);
    znow     = repmat(kron((1: 1 : p.nz)', ones(p.nat, 1)), p.ne, 1);    % index of z in (a, z, e) space for renters
   
    [~, ~, ~, ~, vr(:,t)] = solveh_new(svr, Whinterp, Wrinterp, p, p.thetay(t), 'r', At, Y, znow);
   
    
    % Solve discrete choice problem of housing
    
    At       = svh(:,1); 
    Y        = p.lambdat(t)*svh(:,5).*svh(:,6);
    
    znow     = repmat(kron((1: 1 : p.nz)', ones(p.nat*p.no*p.nt*p.nh, 1)), p.ne,      1);             % index of z in (a, omega, theta, h, z, e) space for owners
    hnow     = repmat(kron((1: 1 : p.nh)', ones(p.nat*p.no*p.nt,      1)), p.nz*p.ne, 1);             % index of h in (a, omega, theta, h, z, e) space for owners
    tnow     = repmat(kron((1: 1 : p.nt)', ones(p.nat*p.no,           1)), p.nh*p.nz*p.ne, 1);        % index of theta in (a, omega, theta, h, z, e) space for owners

    
    [~, ~, ~, ~, vh(:,t)] = solveh_new(svh, Whinterp, Wrinterp, p, p.thetay(t), 'h', At, Y, znow, hnow, tnow);
    
    % We need to interpolate to calculate the expected value before the delta shocks are realized, but after the z,e shocks are realized 
    
    Vhinterp      = griddedInterpolant({p.atgrid, (1: 1:p.no*p.nt*p.nh*p.nz*p.ne)'},  reshape(vh(:, t), p.nat, p.no*p.nt*p.nh*p.nz*p.ne), intmeth, 'linear');
    Vrinterp      = griddedInterpolant({p.atgrid, (1: 1:               p.nz*p.ne)'},  reshape(vr(:, t), p.nat,                p.nz*p.ne), intmeth, 'linear');
    
    
    % Compute expected value and update vbar

    % 1. Step 1: integrate delta shocks by interpolate value of home and rent (which are functions of atilde)
    
    vhtemp        = p.pidelta(1)*Vhinterp((1 + interest(svht(:,1), p)).*svht(:,1) - p.delta(1)*svht(:, 4), ind3h) + p.pidelta(2)*Vhinterp((1 + interest(svht(:,1), p)).*svht(:,1) - p.delta(2)*svht(:, 4), ind3h);
    
    vrtemp        = Vrinterp((1 + interest(svrt(:,1), p)).*svrt(:,1), ind3r);

    % 2. Step 2: integrate income shocks
    
    for i = 1 : p.ne
        
    vbarh(:,t)    = vbarh(:,t) + we(i)*kronm({p.na*p.no*p.nt*p.nh, Fzz}, vhtemp((i - 1)*p.na*p.no*p.nt*p.nh*p.nz + 1 : i*p.na*p.no*p.nt*p.nh*p.nz)); 
    vbarr(:,t)    = vbarr(:,t) + we(i)*kronm({p.na,                Fzz}, vrtemp((i - 1)*p.na*p.nz + 1                : i*p.na*p.nz)); 

    end
    
end


