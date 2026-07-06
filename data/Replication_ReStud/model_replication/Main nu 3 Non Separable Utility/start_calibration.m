clear; 
clc;

format short g

p.beta       = 0.990474;
p.alpha      = 0.607782;
p.R          = 0.010091;
p.phi        = 0.870162;                          % productivity non-market
p.F0m        = 0.064924;                          % fixed cost of refinancing
p.B          = 10.621047;                         % bequest motive
p.r1         = 0.380307; 
p.r2         = 12.374309; 
p.rh         = (1 + 0.017698)^(1/4) - 1;          % upper bound on liquid rate

x            = [p.beta;  p.alpha;   p.R;     p.phi;   p.F0m;    p.B;    p.r1;    p.r2;  (1 + p.rh)^4 - 1];
 
lb           = [0.987;    0.56;    0.009;    0.80;    0.04;     9.5;    0.30;      10;        0.015     ];  
ub           = [0.993;    0.66;    0.011;    0.95;    0.09;    11.5;    0.45;      14;        0.020     ];

ftarget      = @(x) objective(x);

%ftarget(x)
%return

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

