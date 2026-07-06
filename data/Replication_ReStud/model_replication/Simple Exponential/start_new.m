
p.rm0        = p.rm;
p.rm1        = (1 + 0.015)^(1/4) - 1;

p.P0         = 1;
p.P1         = 1; 

p.mbar0      = p.rm0/(1 - (1 + p.rm0)^(-p.D));            % minimum payment required per 1 of initial debt
p.mbar1      = p.rm1/(1 - (1 + p.rm1)^(-p.D));            % minimum payment required per 1 of initial debt

p.rm         = [];
p.mbar       = [];

p.rmgrid     = [p.rm0; p.rm1]; 
p.Pgrid      = [p.P0;  p.P1];

p.rgrid      = [1; 2];                                   % index for whether mortgage is old o rnew

p.nr         = 2;                                        % number of possible mortgage contracts

fprintf('\n');
fprintf('PV of savings from rate refi (discounted at old rm)    = %9.2f\n',  (p.mbar0 - p.mbar1)*(1 - (1 + p.rm0)^(-p.D))/p.rm0*p.thetam*p.hbar);
fprintf('\n');

% Construct grids: 

sv           = gridmake(sv,    [1; 2]); 
sw           = gridmake(sw,    [1; 2]); 
svbar        = gridmake(svbar, [1; 2]); 

cmax         = bisect('savings', 1e-13, 1e5, p.lgrid, p, amin);     % c that implies a' = amin
cmin         = bisect('savings', 1e-13, 1e5, p.lgrid, p, amax);     % c that implies a' = amax

cmax         = repmat(cmax, p.nt*p.nr, 1); 
cmin         = repmat(cmin, p.nt*p.nr, 1); 

Vbar         = repmat(Vbar, p.nr, 1); 


for iter = 1 : 5

    Vbarold     = Vbar;
    
    EV          = griddedInterpolant({p.agrid, p.tgrid, p.rgrid},  reshape(Vbar, p.na, p.nt, p.nr), intmeth, 'linear');
 
    % solve consumption-savings choice
    
    c           = solve_golden('wfunc_new', cmin, cmax, sw, EV, p);
    
    [~, aprime] = savings(c, sw, p);

    W           = wfunc_new(c, sw, EV, p);

    Winterp     = griddedInterpolant({p.lgrid, p.tgrid, p.rgrid},  reshape(W, p.nl, p.nt, p.nr), intmeth, 'linear'); 


    % Solve discrete choice problem

    V          = solveh_new(sv, Winterp, p);
   
    % Interpolate V(w, theta)
    
    Vinterp    = griddedInterpolant({p.wgrid, p.tgrid, p.rgrid},  reshape(V, p.nw, p.nt, p.nr), intmeth, 'linear'); 

    
    % Compute expected value and update vbar
    
    Vbar        = zeros(p.na*p.nt*p.nr, 1); 

    for i = 1 : p.ny
        
    Vbar        = Vbar + wy(i)*Vinterp((1 + p.rl)*svbar(:,1) + y(i), svbar(:,2), svbar(:,3)); 
    
    end
    
    
    fprintf('%4i %6.2e \n', [iter, norm(Vbar - Vbarold)/norm(Vbar)]);    

end


for iter = 1 : 5000

    Vbarold     = Vbar;
    
    EV          = griddedInterpolant({p.agrid, p.tgrid, p.rgrid},  reshape(Vbar, p.na, p.nt, p.nr), intmeth, 'linear');
 
    % solve consumption-savings choice
    
    if mod(iter, 50) == 0
    
    c           = solve_golden('wfunc_new', cmin, cmax, sw, EV, p);
    
    end
    
    [~, aprime] = savings(c, sw, p);

    W           = wfunc_new(c, sw, EV, p);

    Winterp     = griddedInterpolant({p.lgrid, p.tgrid, p.rgrid},  reshape(W, p.nl, p.nt, p.nr), intmeth, 'linear'); 


    % Solve discrete choice problem

    V           = solveh_new(sv, Winterp, p);
   
    % Interpolate V(w, theta)
    
    Vinterp     = griddedInterpolant({p.wgrid, p.tgrid, p.rgrid},  reshape(V, p.nw, p.nt, p.nr), intmeth, 'linear'); 

    
    % Compute expected value and update vbar
    
    Vbar        = zeros(p.na*p.nt*p.nr, 1); 

    for i = 1 : p.ny
        
    Vbar        = Vbar + wy(i)*Vinterp((1 + p.rl)*svbar(:,1) + y(i), svbar(:,2), svbar(:,3)); 
    
    end
    
    if mod(iter, 50) == 0
        
    fprintf('%4i %6.2e \n', [iter/50, norm(Vbar - Vbarold)/norm(Vbar)]);    

    if norm(Vbar - Vbarold)/norm(Vbar) < 1e-7, break, end
    
    end
    
end
