clear; 
clc;

format short g

p.beta       = 0.985605;
p.alpha      = 0.67;
p.R          = 0.0105;
p.phi        = 0.938686;                          % productivity non-market
p.F0m        = 0.102974;                          % fixed cost of refinancing
p.B          = 10.265214;                         % bequest motive
p.r1         = 0.358448; 
p.r2         = 10.327567; 
p.rh         = (1 + 0.015765)^(1/4) - 1;          % upper bound on liquid rate
p.A0         = 6.5; 

x            = [p.beta;  p.alpha;   p.R;     p.phi;   p.F0m;    p.B;    p.r1;    p.r2;  (1 + p.rh)^4 - 1;   p.A0];
 
lb           = [0.982;    0.60;    0.009;    0.85;    0.07;     9.5;    0.25;      8;        0.013;          4  ];  
ub           = [0.989;    0.75;    0.012;    1.00;    0.13;    11.0;    0.45;     13;        0.019;          9  ];

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

