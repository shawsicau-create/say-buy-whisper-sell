close all

set(groot, 'DefaultAxesLineWidth', 1.5);
set(groot, 'DefaultLineLineWidth', 4);
set(groot, 'DefaultAxesTickLabelInterpreter','latex'); 
set(groot, 'DefaultLegendInterpreter','latex');
set(groot, 'DefaultAxesFontSize',24);




Asim  =  Asave; 
Osim  =  Osave; 
Thsim =  Thsave; 
Hsim  =  Hsave; 

Csim  =  Csave; 
Lsim  =  Lsave; 
Dsim  =  Dsave; 
Ysim  =  Ysave; 
Zsim  =  Zsave; 
Esim  =  Esave; 
Vsim  =  Vsave; 
Usim  =  Usave; 
Yhsim = Yhsave; 
Ssim  =  Ssave; 

Deltasim  = Deltasave; 
Pallsim   = Pallsave; 
Vallsim   = Vallsave; 


% Next Study Liquidity Injection: raise everyone's omega by 1% and increase A by the corresponding amount
           
Hcsim          = Hsim;    

Scsim          = zeros(2*N, p.T);  % service flow from housing -- need to compute MUC since non-separable

Lcsim          = Lsim; 
Dcsim          = Dsim; 


Pallcsim       = Pallsim; 
Vallcsim       = Vallsim;


Thcsim         = Thsim.*(Thsim > 0 & Hsim > 0) + p.tgrid(end).*(Thsim == 0 & Hsim > 0);

Ocsim          = min(Osim + 0.01/(1 + p.rm)./Thcsim, 1).*(Hsim > 0); 


Transfer       = (1 + p.rm)*(Ocsim.*Thcsim - Osim.*Thsim).*Hsim; 

RHS            = (1 + interest(Asim, p)).*Asim + Transfer; 

data           = [RHS(:)./(1 + p.rh), RHS(:)./(1 + p.rl)]; 


Acsim          = reshape(bisect('findtransfer', min(data, [], 2) - 0.1, max(data, [], 2) + 0.1, RHS(:), p), 2*N, T + 1); 


for t = 2 : T
  
  Whinterp           = griddedInterpolant({p.lgrid, (1: 1: p.no*p.nt*p.nh*p.nz)'},  reshape(wh(:, t), p.nl, p.no*p.nt*p.nh*p.nz), intmeth, 'linear'); 
  Wrinterp           = griddedInterpolant({p.lgrid, (1: 1:                p.nz)'},  reshape(wr(:, t), p.nl,                p.nz), intmeth, 'linear');
  
  rent               = H(:, t) == 0; 

  % Renters
  
  state              = (1 + interest(Acsim(rent, t), p)).*Acsim(rent, t);                                                                % others don't matter directly
  
  ntemp              = numel(find(rent)); 
  
  [Lall, Oall, Thall, Hall, V(rent,t), Pall(rent, 1 : 3, t), Vall(rent, 1 : 3, t)] = solveh(state, Whinterp, Wrinterp, p, p.thetay(t), 'r', state(:,1), Y(rent, t), Z(rent, t));
 
  Pcum               = [zeros(ntemp, 1), cumsum(Pall(rent, 1 : 3, t), 2)];  

  D(rent, t)         = ((U(rent, t) < Pcum(:, 2:end)).*(U(rent, t) >= Pcum(:,1:end-1)))*(1 : 1 : 3)';

  ind                = sub2ind([ntemp, 3], (1 : 1 : ntemp)', D(rent, t)); 

  L(rent, t)         =  Lall(ind); 
  O(rent, t + 1)     =  Oall(ind);
  Th(rent, t + 1)    = Thall(ind); 
  H(rent, t + 1)     =  Hall(ind); 

  
  % Homeowners
  
  ntemp              = numel(find(~rent)); 

  state              = [(1 + interest(Acsim(~rent, t), p)).*Acsim(~rent, t) - Delta(~rent, t).*Hcsim(~rent, t), Ocsim(~rent, t), Thcsim(~rent, t), Hcsim(~rent, t)];                     % others don't matter directly
  
  hind               = lookup1(p.hgrid,  Hcsim(~rent, t), 1); 
  tind               = lookup1(p.tgrid, Thcsim(~rent, t), 1); 
  
  [Lall, Oall, Thall, Hall, V(~rent,t), Pall(~rent, :, t), Vall(~rent, :, t)] = solveh(state, Whinterp, Wrinterp, p, p.thetay(t), 'h', state(:,1), Y(~rent, t), Z(~rent, t), hind, tind);
 
  Pcum               = [zeros(ntemp, 1), cumsum(Pall(~rent, :, t), 2)];  

  D(~rent, t)        = ((U(~rent, t) < Pcum(:, 2:end)).*(U(~rent, t) >= Pcum(:,1:end-1)))*(1 : 1 : 5)';

  ind                = sub2ind([ntemp, 5], (1 : 1 : ntemp)', D(~rent, t)); 

  L(~rent, t)        =  Lall(ind); 
  O(~rent, t + 1)    =  Oall(ind);
  Th(~rent, t + 1)   = Thall(ind); 
  H(~rent, t + 1)    =  Hall(ind); 
  
   
  % Find consumption

  rent               = H(:, t + 1) == 0; 

  Chint              = griddedInterpolant({p.lgrid, p.ogrid, p.tgrid, p.hgrid, p.zgrid},  reshape(ch(:, t), p.nl, p.no, p.nt, p.nh, p.nz), intmeth, 'linear');
  Crint              = griddedInterpolant({p.lgrid,                            p.zgrid},  reshape(cr(:, t), p.nl,                   p.nz), intmeth, 'linear');

  stemp              = [L(rent, t),  p.zgrid(Z(rent, t))];

  cmin               = bisect('savings', 1e-13, 1e5, stemp, p, 'r', amax);                  % c that implies a' = amin
  cmax               = bisect('savings', 1e-13, 1e5, stemp, p, 'r', amin);                  % c that implies a' = amin

  C(rent, t)         = max(min(Crint(stemp), cmax), cmin);
  
  [~, A(rent, t+1), Rent(rent, t), Yh(rent, t)]  = savings(C(rent, t), stemp, p, 'r');                                   % none of the other state variables matter

  Scsim(rent, t)     = Rent(rent, t);

  
  stemp              = [L(~rent, t), O(~rent, t+1), Th(~rent, t+1), H(~rent, t+1), p.zgrid(Z(~rent, t))];

  cmin               = bisect('savings', 1e-13, 1e5, stemp, p, 'h', amax);                 % c that implies a' = amin
  cmax               = bisect('savings', 1e-13, 1e5, stemp, p, 'h', amin);                 % c that implies a' = amin

  C(~rent,t)         = max(min(Chint(stemp), cmax), cmin);

  [~, A(~rent, t+1), ~,  Yh(~rent, t)] = savings(C(~rent,t), stemp, p, 'h');

  Scsim(~rent, t)    =  H(~rent, t + 1); 
 
end

Ccsim         = C; 
Vcsim         = V; 
Yhcsim        = Yh; 


% Ask: how many homeowners (in period time = 2) benefit, so Vcsim(:, :, time) > Vsim(:, :, time) and what do 

% 1. Fraction of homeowners who benefit

% 2. Distribution of welfare gains

Vnew          = reshape(Vcsim(:, 2 : T),                                                                                            2*N*(T - 1), 1); 
Vold          = reshape(Vsim(:, 2 : T),                                                                                             2*N*(T - 1), 1); 
UCold         = reshape(Csim(:, 2 : T).^(- p.sigma)./(Csim(:, 2 : T).^(1 - p.sigma) + p.alpha*Ssim(:, 2 : T).^(1 - p.sigma)),      2*N*(T - 1), 1);
Transfer      = reshape(Transfer(:, 2 : T),                                                                                         2*N*(T - 1), 1);

ind           = Transfer > 0; 

gains         = max(min((Vnew(ind) - Vold(ind))./Transfer(ind)./UCold(ind), 1), 0);                                  % small fraction due to interpolation error 

fbenefit      = mean(gains > 0); 

MPC           = (Ccsim(:, 2 : T) - p.phi*Yhcsim(:, 2 : T) - (Csim(:, 2 : T) - p.phi*Yhsim(:, 2 : T))); 
MPC           = reshape(MPC,                         2*N*(T - 1), 1);

MPC           = MPC(ind)./Transfer(ind); 


% fprintf('\n')
% fprintf('Fraction who benefit                             = %9.2f             \n',  fbenefit);
% fprintf('\n')
% fprintf('Willingness to pay, mean                         = %9.2f \n',  mean(gains(gains > 0)));
% fprintf('Willingness to pay, 10th pctile                  = %9.2f \n',  prctile(gains(gains > 0), 10));
% fprintf('Willingness to pay, 25th pctile                  = %9.2f \n',  prctile(gains(gains > 0), 25));
% fprintf('Willingness to pay, 50th pctile                  = %9.2f \n',  prctile(gains(gains > 0), 50));
% fprintf('Willingness to pay, 75th pctile                  = %9.2f \n',  prctile(gains(gains > 0), 75));
% fprintf('Willingness to pay, 90th pctile                  = %9.2f \n',  prctile(gains(gains > 0), 90));
% fprintf('\n')
% fprintf('Fraction consumed, mean                          = %9.2f \n',  mean(MPC(gains > 0)));
% fprintf('Fraction consumed, 10th pctile                   = %9.2f \n',  prctile(MPC(gains > 0),   10));
% fprintf('Fraction consumed, 25th pctile                   = %9.2f \n',  prctile(MPC(gains > 0),   25));
% fprintf('Fraction consumed, 50th pctile                   = %9.2f \n',  prctile(MPC(gains > 0),   50));
% fprintf('Fraction consumed, 75th pctile                   = %9.2f \n',  prctile(MPC(gains > 0),   75));
% fprintf('Fraction consumed, 90th pctile                   = %9.2f \n',  prctile(MPC(gains > 0),   90));



fprintf('\n')
fprintf('Table 11, C. Severity of Liquidity Constraints \n')
fprintf('\n')
fprintf('fraction liquidity constrained                     = %9.2f\n',  mean(gains > 0));
fprintf('mean valuation of liquidity                        = %9.2f\n',  mean(gains(gains > 0)));
fprintf('mean fraction consumed                             = %9.2f\n',  mean(MPC(gains > 0)));

