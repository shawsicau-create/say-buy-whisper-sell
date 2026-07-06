clear; 
clc;

format short g

p.beta       = 0.985844;
p.alpha      = 0.793136;
p.R          = 0.013439;
p.phi        = 1.010159;                          % productivity non-market
p.F0m        = 0.012354;                          % fixed cost of refinancing
p.B          = 10.300415;                          % bequest motive
p.r1         = 0.641467; 
p.r2         = 7.300151; 
p.rh         = (1 + 0.014341)^(1/4) - 1;          % upper bound on liquid rate
p.rr         = 0.899175; 
p.hr         = 0.011304; 

x           = [p.beta;  p.alpha;   p.R;     p.phi;   p.F0m;    p.B;    p.r1;    p.r2;  (1 + p.rh)^4 - 1;    p.rr;    p.hr];
 
lb          = [0.984;    0.74;    0.0131;    0.96;    0.01;    10.0;    0.55;      6;        0.011;         0.85;   0.009];  
ub          = [0.987;    0.84;    0.0137;    1.06;    0.02;    10.7;    0.75;      9;        0.017;         0.95;   0.013];

ftarget     = @(x) objective(x);

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

