clear; 
clc;

format short g

p.beta       = 0.982469;
p.alpha      = 0.948085;
p.R          = 0.015102;
p.phi        = 0.921713;                          % productivity non-market
p.F0m        = 0.083441;                          % fixed cost of refinancing
p.B          = 10.223019;                         % bequest motive
p.r1         = 0.335880; 
p.r2         = 10.568925; 
p.rh         = (1 + 0.029692)^(1/4) - 1;          % upper bound on liquid rate


x            = [p.beta;  p.alpha;   p.R;     p.phi;   p.F0m;    p.B;    p.r1;    p.r2;  (1 + p.rh)^4 - 1];
 
lb           = [0.980;    0.88;    0.012;    0.82;    0.07;     9.5;    0.25;      9;        0.026 ];  
ub           = [0.985;    1.00;    0.018;    1.02;    0.10;    11.0;    0.45;     12;        0.034 ];

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

