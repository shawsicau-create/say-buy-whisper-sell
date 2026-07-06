clear; 
clc;

format short g

p.beta       = 0.977890;
p.alpha      = 0.976102;
p.R          = 0.012105;
p.F0m        = 0.076959;                             % fixed cost of refinancing
p.B          = 11.271651;                         % bequest motive
p.r1         = 0.370918; 
p.r2         = 11.366816; 
p.rh         = (1 + 0.021464)^(1/4) - 1;            % upper bound on liquid rate

x            = [p.beta;  p.alpha;   p.R;     p.F0m;    p.B;    p.r1;    p.r2;  (1 + p.rh)^4 - 1];
 
lb           = [0.977;    0.90;    0.0120;    0.06;    10.7;   0.30;      9;        0.020 ];  
ub           = [0.979;    1.05;    0.0123;    0.09;    11.7;   0.45;     14;        0.023 ];

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

