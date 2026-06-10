clear; 
clc;

format short g

p.beta       = 0.986281;
p.alpha      = 0.323485;
p.R          = 0.009455;
p.phi        = 1.031685;                          % productivity non-market
p.F0m        = 0.244113;                          % fixed cost of refinancing
p.B          = 9.151025;                          % bequest motive
p.r1         = 0.407447; 
p.r2         = 8.001386; 
p.rh         = (1 + 0.014735)^(1/4) - 1;             % upper bound on liquid rate

x            = [p.beta;  p.alpha;   p.R;     p.phi;   p.F0m;    p.B;    p.r1;    p.r2;  (1 + p.rh)^4 - 1];
 
lb           = [0.985;    0.28;    0.008;     0.90;    0.20;     8.0;   0.30;      6;        0.011 ];  
ub           = [0.987;    0.36;    0.011;     1.10;    0.30;    10.0;   0.50;     10;        0.018 ];

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

