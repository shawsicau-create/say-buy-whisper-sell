clear;
clc;
close all;

N           =  50000;                       % number of agents to simulate
T           =  61*4;                        % number quarters to live, from 25 to 85

kz          =  7;                           % nodes for z
ke          =  3; 


rhoz        =  0.9908;           
sz          =  0.0761;
se          =  0.4869;


time        = (1 : 1 : T)'; 

lambdat     =  0.07982636 - 0.02322307 * (time/4 + 25) + 0.00105409 * (time/4 + 25).^2 - 0.00001028 * (time/4 + 25).^3;
    
x           =  [rhoz;     sz;      se ];

lb          =  [0.975;    0.03;    0.3];
ub          =  [0.997;    0.15;    0.8];


ftarget     = @(x) incomemoments(x, N, T, lambdat, kz, ke);

ftarget(x)

%{
switch 'simplex' 

    case 'ga'

        gaoptions = gaoptimset('Display', 'off','UseParallel', 'always', 'InitialPopulation', x');
        x         = ga(@(x)ftarget(x), size(x, 1), [], [], [], [], lb, ub, [], gaoptions); 

    case 'simplex'
            
        x         = neldmead_bounds(@(x)ftarget(x), x, lb, ub);

  
    case 'particleswarm'
       

       options = optimoptions('particleswarm', 'Display', 'off', 'MaxTime',  100, 'UseParallel', true, 'InitialSwarm', x',  'SwarmSize', 200);

       x   = particleswarm(ftarget, numel(x), lb', ub', options);   %this function complains  if I give it a structure as input
        
       
    case 'patternsearch'

       options = optimoptions('patternsearch','Display','off', 'UseParallel', true);

       x  = patternsearch(ftarget, x, [], [], [], [], lb, ub, [], options);
   
end



se = (1 - 0.55)^(1/2)*se;   % Krueger Perri (2011) show 55% of the variance of trans compon is measurement error so subtract


%}