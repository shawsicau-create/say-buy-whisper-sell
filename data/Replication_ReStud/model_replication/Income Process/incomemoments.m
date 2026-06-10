function obj   = incomemoments(x, N, T, lambdat, kz, ke)

rhoz           = x(1); 
sz             = x(2);
se             = x(3);

rng(0); 

[zgrid, Fzz]   = rouwenhorst(rhoz, sz, kz);

 
[Fz, ~]        = eigs(Fzz',1);
Fz             = Fz/sum(Fz); 
Fz             = max(Fz, 0); 

  
[egrid, Fe]    = qnwnorm(ke, 0, se^2);

Fee            = repmat(Fe', ke, 1); 

index          = nodeunif(N, 1e-14, 1 - 1e-14); 

Z              = zeros(2*N, T);
E              = zeros(2*N, T);

rng(0)


unif      = index(randperm(N));  unif = [unif; 1 - unif];    % mirror sampling

Fzcum     = [0; cumsum(Fz)];            % cumulative ergodic for initial conditions
[~, bin]  = histc(unif, Fzcum);         % bin is the index of initial draw of z

Z(:,1)    = bin;


unif      = index(randperm(N));  unif = [unif; 1 - unif];    % mirror sampling

Fecum     = [0; cumsum(Fe)];            % cumulative ergodic for transitory shock
[~, bin]  = histc(unif, Fecum);         % bin is the index of e transitory shock

E(:,1)    = bin;


for t = 2 : T

  unif      = index(randperm(N));  unif = [unif; 1 - unif];    % mirror sampling
  
  Fzcum     = [zeros(2*N, 1), cumsum(Fzz(Z(:,t-1), :), 2)];
 
  Z(:,t)    = ((unif < Fzcum(:, 2:end)).*(unif >= Fzcum(:,1:end-1)))*(1 : 1 : kz)';
  
  
  unif      = index(randperm(N));  unif = [unif; 1 - unif];
  
  Fecum     = [zeros(2*N, 1), cumsum(Fee(E(:,t-1), :), 2)];
 
  E(:,t)    = ((unif < Fecum(:, 2:end)).*(unif >= Fecum(:,1:end-1)))*(1 : 1 : ke)';
  

end

Y           = exp(lambdat' + zgrid(Z) + egrid(E));


% Create annual income measures and calculate moments

Y              = (Y(:, 1 : 4 : T) + Y(:, 2 : 4 : T) + Y(:, 3 : 4 : T) + Y(:, 4 : 4 : T));   % sum quarterly income

varyall        = var(log(Y(:)));    

Czz2           = cov(log([vec(Y(:, 3 : end)), vec(Y(:, 1 : end - 2))]));       Czz2 = Czz2(1, 2); 

stddy          = std(log(vec(Y(:, 3 : end))) - log(vec(Y(:, 1 : end - 2))));

Czz4           = cov(log([vec(Y(:, 5 : end)), vec(Y(:, 1 : end - 4))]));       Czz4 = Czz4(1, 2); 


fprintf('\n');
fprintf('Moments: Model, Data\n');
fprintf('\n');

fprintf('variance log income, all                    = %9.3f %9.3f \n',  [varyall,           0.443]);
fprintf('autocov log income (t, t-2), all            = %9.3f %9.3f \n',  [Czz2,              0.332]);
fprintf('autocov log income (t, t-4), all            = %9.3f %9.3f \n',  [Czz4,              0.314]);
fprintf('std dev log income growth (t, t-2), all     = %9.3f %9.3f \n',  [stddy,             0.408]);


mmode          = [varyall;  Czz2;   Czz4;   stddy];
mdata          = [0.443;   0.332;   0.314;  0.408];

obj            = (mmode - mdata)./(1 + abs(mdata));

weight         = ones(4, 1); 
weight         = weight/sum(weight);

obj            = sqrt(weight'*(obj.^2));

fprintf('\n');
fprintf('Root mean squared deviations  %9.4f  \n',  obj);
fprintf('\n');

format short g
disp([x(:)', obj])
format short
