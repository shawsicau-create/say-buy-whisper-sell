clear; 
clc;

format short g

p.beta       = 0.987843;
p.alpha      = 0.475078;
p.R          = 0.010475;
p.phi        = 1.299950;                          % productivity non-market
p.F0m        = 0.080056;                          % fixed cost of refinancing
p.B          = 12.840452;                         % bequest motive
p.rl         = (1 + 0.007174)^(1/4) - 1;

x            = [p.beta;  p.alpha;   p.R;     p.phi;   p.F0m;    p.B;   (1 + p.rl)^4 - 1];
 
lb           = [0.986;    0.43;    0.0102;    1.20;    0.06;    12.0;       0.004 ];  
ub           = [0.989;    0.53;    0.0107;    1.40;    0.10;    14.0;       0.010 ];

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

