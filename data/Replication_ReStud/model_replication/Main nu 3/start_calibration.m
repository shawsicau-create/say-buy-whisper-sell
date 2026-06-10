clear; 
clc;

format short g

p.beta       = 0.985570;
p.alpha      = 0.689383;
p.R          = 0.011302;
p.phi        = 0.928049;                           % productivity non-market
p.F0m        = 0.090571;                              % fixed cost of refinancing
p.B          = 10.106351;                               % bequest motive
p.r1         = 0.349740; 
p.r2         = 9.488797; 
p.rh         = (1 + 0.015893)^(1/4) - 1;           % upper bound on liquid rate

x            = [p.beta;  p.alpha;   p.R;     p.phi;   p.F0m;    p.B;    p.r1;    p.r2;  (1 + p.rh)^4 - 1];
 
lb           = [0.985;    0.67;    0.0111;    0.88;    0.07;     9.7;   0.30;      8;        0.013 ];  
ub           = [0.986;    0.71;    0.0115;    0.96;    0.11;    10.6;   0.40;     11;        0.019 ];

ftarget      = @(x) objective(x);

% ftarget(x)
% return

switch 'patternsearch'

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

