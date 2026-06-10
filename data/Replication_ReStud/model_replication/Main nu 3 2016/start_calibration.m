clear; 
clc;

format short g

p.beta       = 0.985610;
p.alpha      = 0.700147;
p.R          = 0.012144;
p.phi        = 1.348889;                          % productivity non-market
p.F0m        = 0.418936;                          % fixed cost of refinancing
p.B          = 9.743407;                          % bequest motive
p.r1         = 0.593826; 
p.r2         = 7.051620; 
p.rh         = (1 + 0.012442)^(1/4) - 1;          % upper bound on liquid rate

x            = [p.beta;  p.alpha;   p.R;     p.phi;   p.F0m;    p.B;    p.r1;    p.r2;  (1 + p.rh)^4 - 1];
 
lb           = [0.985;    0.60;    0.0120;    1.30;    0.35;     9.3;    0.5;      5;        0.010 ];  
ub           = [0.986;    0.80;    0.0123;    1.40;    0.50;    10.0;    0.7;      9;        0.015 ];

ftarget      = @(x) objective(x);

% ftarget(x)
% return

switch 'fminsearch'

    case 'fminsearch'
        
        disp('fminsearch')
        
        options             = optimset('fminsearch');
        options.Display     = 'iter';
        options.TolX        = 1e-4;
        options.MaxFunEvals = 250;

        x    = fminsearchbnd(ftarget, x, lb, ub, options);
   
    
    case 'ga'

        parpool

        disp('ga')
        gaoptions = gaoptimset('Display', 'off','UseParallel', 'always', 'InitialPopulation', x');
        x         = ga(@(x)ftarget(x), size(x, 1), [], [], [], [], lb, ub, [], gaoptions); 

   
    case 'particleswarm'
       
       disp('particleswarm')

       options = optimoptions('particleswarm', 'Display', 'off', 'MaxTime',  10000, 'UseParallel', true, 'InitialSwarm', x',  'SwarmSize', 200);

       x   = particleswarm(ftarget, numel(x), lb', ub', options);   %this function complains  if I give it a structure as input
        
       
    case 'patternsearch'
              disp('patternsearch')

       options = optimoptions('patternsearch','Display','off', 'UseParallel', true);

       parpool
       
       x  = patternsearch(ftarget, x, [], [], [], [], lb, ub, [], options);
       
end

x  = x(:);

