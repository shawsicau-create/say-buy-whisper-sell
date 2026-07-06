clear; 
clc;

format short g

p.beta       = 0.985458;
p.alpha      = 0.690395;
p.R          = 0.011370;
p.phi        = 0.881891;                          % productivity non-market
p.F0m        = 0.282543;                          % fixed cost of refinancing
p.B          = 10.640120;                         % bequest motive
p.r1         = 0.274224; 
p.r2         = 8.868972; 
p.rh         = (1 + 0.018447)^(1/4) - 1;          % upper bound on liquid rate

x            = [p.beta;  p.alpha;   p.R;     p.phi;   p.F0m;    p.B;    p.r1;    p.r2;  (1 + p.rh)^4 - 1];
 
lb           = [0.985;    0.66;    0.0112;    0.85;    0.24;    10.2;    0.22;      8;        0.017 ];  
ub           = [0.986;    0.72;    0.0116;    0.91;    0.30;    10.7;    0.32;     10;        0.020 ];

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

       x  = patternsearch(ftarget, x, [], [], [], [], lb, ub, [], options);
       
end

x  = x(:);

