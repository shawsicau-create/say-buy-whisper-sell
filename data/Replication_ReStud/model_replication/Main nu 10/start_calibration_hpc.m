clear; 
clc;

format short g

p.beta       = 0.985465;
p.alpha      = 0.710294;
p.R          = 0.0113;
p.phi        = 0.882502;                          % productivity non-market
p.F0m        = 0.187551;                          % fixed cost of refinancing
p.B          = 10.25;                             % bequest motive
p.r1         = 0.211624; 
p.r2         = 4.3; 
p.rh         = (1 + 0.0164)^(1/4) - 1;            % upper bound on liquid rate


x            = [p.beta;  p.alpha;   p.R;     p.phi;   p.F0m;     p.B;    p.r1;    p.r2;  (1 + p.rh)^4 - 1];
 
lb           = [0.984;    0.67;    0.0103;    0.83;    0.14;     9.7;    0.10;      2;        0.012 ];  
ub           = [0.987;    0.75;    0.0123;    0.93;    0.24;    10.7;    0.35;     10;        0.021 ];

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

x  = x(:)
objective(x)

save x x;

