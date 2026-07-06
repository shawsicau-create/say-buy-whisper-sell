close all

set(groot, 'DefaultAxesLineWidth', 1.5);
set(groot, 'DefaultLineLineWidth', 4);
set(groot, 'DefaultAxesTickLabelInterpreter','latex'); 
set(groot, 'DefaultLegendInterpreter','latex');
set(groot, 'DefaultAxesFontSize',24);


S              = 3; 

Asim           = zeros(2*N, T, S + 1);  
Osim           = zeros(2*N, T, S + 1); 
Thsim          = zeros(2*N, T, S + 1);
Hsim           = zeros(2*N, T, S + 1); 

Csim           = zeros(2*N, T, S); 
Lsim           = zeros(2*N, T, S); 
Dsim           = zeros(2*N, T, S); 
Ysim           = zeros(2*N, T, S); 
Zsim           = zeros(2*N, T, S);
Esim           = zeros(2*N, T, S);
Vsim           = zeros(2*N, T, S);
Pallsim        = zeros(2*N, 5, T, S); 
Vallsim        = zeros(2*N, 5, T, S); 
Usim           = zeros(2*N, T, S); 
Deltasim       = zeros(2*N, T, S); 

Agesim         = zeros(2*N, T, S); 


Asim(:, :, 1)  =  Asave(:, 1 : T); 
Osim(:, :, 1)  =  Osave(:, 1 : T); 
Thsim(:, :, 1) = Thsave(:, 1 : T); 
Hsim(:, :, 1)  =  Hsave(:, 1 : T); 
Csim(:, :, 1)  =  Csave(:, 1 : T); 
Lsim(:, :, 1)  =  Lsave(:, 1 : T); 
Dsim(:, :, 1)  =  Dsave(:, 1 : T); 
Ysim(:, :, 1)  =  Ysave(:, 1 : T); 
Zsim(:, :, 1)  =  Zsave(:, 1 : T); 
Esim(:, :, 1)  =  Esave(:, 1 : T); 
Vsim(:, :, 1)  =  Vsave(:, 1 : T); 
Usim(:, :, 1)  =  Usave(:, 1 : T); 

Deltasim(:, :, 1) = Deltasave(:, 1 : T); 

Pallsim(:, :, :, 1) = Pallsave;
Vallsim(:, :, :, 1) = Vallsave;


Agesim(:,:,1)  =  repmat((1 : 1 : T), 2*N, 1); 

index          = nodeunif(N, 1e-14, 1 - 1e-14); 

% First simulate history of shocks to income

for time = 2 : S 

Agesim(:, :, time)  = rem(Agesim(:, : , time - 1), T) + 1; 


for initage = 1 : T  % go over all initial age bins
    
  unif      = index(randperm(N));  unif = [unif; 1 - unif];    % mirror sampling
  
  Fzcum     = [zeros(2*N, 1), cumsum(Fzz(Zsim(:, initage, time - 1), :), 2)];

  Zsim(:, initage, time)  = ((unif < Fzcum(:, 2:end)).*(unif >= Fzcum(:,1:end-1)))*(1 : 1 : p.nz)';
  
  
  unif      = index(randperm(N));  unif = [unif; 1 - unif];
  
  [~, bin]  = histc(unif, Fecum);                             % bin is the index of e transitory shock

  Esim(:, initage, time)    = bin;
  
  Ysim(:, initage, time)    = p.lambdat(Agesim(:, initage, time)).*p.zgrid(Zsim(:, initage, time)).*p.egrid(Esim(:, initage, time));

end

Usim(:, :, time)     = rand(2*N, T);

Deltasim(:, :, time) = rand(2*N, T);
Deltasim(:, :, time) = p.delta(1)*(Deltasim(:, :, time) <= p.pidelta(1)) + p.delta(2)*(Deltasim(:, :, time) > p.pidelta(1)); 

end


Asim(:,  1 : T - 1,  2)  = Asave(:, 2 : T);  
Asim(:,      T,      2)  = 0; 

Osim(:,  1 : T - 1,  2)  = Osave(:, 2 : T);  
Osim(:,      T,      2)  = 0; 

Thsim(:, 1 : T - 1,  2)  = Thsave(:, 2 : T);  
Thsim(:,     T,      2)  = 0; 

Hsim(:,  1 : T - 1,  2)  = Hsave(:, 2 : T);  
Hsim(:,      T,      2)  = 0; 


for time = 2 : S
    for initage = 1 : T
 
        age          = Agesim(1, initage, time); 
        
  Whinterp           = griddedInterpolant({p.lgrid, (1: 1: p.no*p.nt*p.nh*p.nz)'},  reshape(wh(:, age), p.nl, p.no*p.nt*p.nh*p.nz), intmeth, 'linear'); 
  Wrinterp           = griddedInterpolant({p.lgrid, (1: 1:                p.nz)'},  reshape(wr(:, age), p.nl,                p.nz), intmeth, 'linear');
  
  rent               = Hsim(:, initage, time) == 0; 

  % Renters
  
  state              = (1 + interest(Asim(rent, initage,  time), p)).*Asim(rent, initage,  time);
  
  ntemp              = numel(find(rent)); 
  
  [Lall, Oall, Thall, Hall, Vsim(rent, initage, time), Pallsim(rent, 1 : 3, initage, time), Vallsim(rent, 1 : 3, initage, time)] = ...
                              solveh(state, Whinterp, Wrinterp, p, p.thetay(age), 'r', state(:,1), Ysim(rent, initage,  time), Zsim(rent, initage,  time));
 
  Pcum               = [zeros(ntemp, 1), cumsum(Pallsim(rent, 1 : 3, initage, time), 2)];  


  Dsim(rent, initage, time)         = ((Usim(rent, initage, time) < Pcum(:, 2:end)).*(Usim(rent, initage, time) >= Pcum(:,1:end-1)))*(1 : 1 : 3)';

  ind                = sub2ind([ntemp, 3], (1 : 1 : ntemp)', Dsim(rent, initage, time)); 

  Lsim(rent, initage, time)         =  Lall(ind); 
  Osim(rent, initage, time + 1)     =  Oall(ind);
  Thsim(rent, initage, time + 1)    = Thall(ind); 
  Hsim(rent, initage, time + 1)     =  Hall(ind); 

 % Homeowners
 
  Attemp             = (1 + interest(Asim(~rent, initage,  time), p)).*Asim(~rent, initage,  time) - Deltasim(~rent, initage, time).*Hsim(~rent, initage,  time);
 
  state              = [Attemp, Osim(~rent, initage,  time), Thsim(~rent, initage,  time), Hsim(~rent, initage,  time)];                     % others don't matter directly
  
  hind               = lookup1(p.hgrid,  state(:, 4), 1); 
  tind               = lookup1(p.tgrid,  state(:, 3), 1); 
  
  ntemp              = numel(find(~rent)); 

  [Lall, Oall, Thall, Hall, Vsim(~rent, initage, time), Pallsim(~rent, :, initage, time), Vallsim(~rent, :, initage, time)] = ...
                               solveh(state, Whinterp, Wrinterp, p, p.thetay(age), 'h', state(:,1), Ysim(~rent, initage, time), Zsim(~rent, initage, time), hind, tind);
 
  Pcum               = [zeros(ntemp, 1), cumsum(Pallsim(~rent, :, initage, time), 2)];  

  Dsim(~rent, initage, time)     = ((Usim(~rent, initage, time) < Pcum(:, 2:end)).*(Usim(~rent, initage, time) >= Pcum(:,1:end-1)))*(1 : 1 : 5)';

  ind                = sub2ind([ntemp, 5], (1 : 1 : ntemp)', Dsim(~rent, initage, time)); 

  Lsim(~rent, initage, time)        =  Lall(ind); 
  Osim(~rent, initage, time + 1)    =  Oall(ind);
  Thsim(~rent, initage, time + 1)   = Thall(ind); 
  Hsim(~rent, initage, time + 1)    =  Hall(ind);
   
  
 % Find consumption

  rent               = Hsim(:, initage, time + 1) == 0; 

  Chint              = griddedInterpolant({p.lgrid, p.ogrid, p.tgrid, p.hgrid, p.zgrid},  reshape(ch(:, age), p.nl, p.no, p.nt, p.nh, p.nz), intmeth, 'linear');
  Crint              = griddedInterpolant({p.lgrid,                            p.zgrid},  reshape(cr(:, age), p.nl,                   p.nz), intmeth, 'linear');

  cmin               = bisect('savings', 1e-13, 1e5, Lsim(rent, initage, time), p, 'r', amax);                  % c that implies a' = amin
  cmax               = bisect('savings', 1e-13, 1e5, Lsim(rent, initage, time), p, 'r', amin);                  % c that implies a' = amin

  Csim(rent, initage, time)           = max(min(Crint(Lsim(rent, initage, time),  p.zgrid(Zsim(rent, initage, time))), cmax), cmin);

  [~, Asim(rent, initage, time + 1)]  = savings(Csim(rent, initage, time), Lsim(rent, initage, time), p, 'r');                                   % none of the other state variables matter

  
  cmin               = bisect('savings', 1e-13, 1e5, Lsim(~rent, initage, time), p, 'h', amax);                 % c that implies a' = amin
  cmax               = bisect('savings', 1e-13, 1e5, Lsim(~rent, initage, time), p, 'h', amin);                 % c that implies a' = amin

 Csim(~rent, initage, time)           = max(min(Chint(Lsim(~rent, initage, time), Osim(~rent,initage, time + 1), Thsim(~rent,initage, time + 1), Hsim(~rent,initage, time + 1), p.zgrid(Zsim(~rent, initage, time))), cmax), cmin);

 [~, Asim(~rent, initage, time + 1)]  = savings(Csim(~rent, initage, time), Lsim(~rent, initage, time), p, 'h');                                   % none of the other state variables matter

  
  
    if age == T
      
      Asim(:,  initage, time + 1)  = 0;
      Osim(:,  initage, time + 1)  = 0;
      Thsim(:, initage, time + 1)  = 0;
      Hsim(:,  initage, time + 1)  = 0;

    end
  
    end
end
    

         
Ct   = zeros(S, 1); 
Yt   = zeros(S, 1); 
At   = zeros(S, 1); 
Ht   = zeros(S, 1); 
Dt   = zeros(S, 1); 


% find out who is constrained in period 2


for time = 1 : S
    
   Ct(time)   = mean(vec(Csim(:, :, time))); 
   Yt(time)   = mean(vec(Ysim(:, :, time))); 
   Ht(time)   = mean(vec(Hsim(:, :, time))); 
   At(time)   = mean(vec(Asim(:, :, time)));
   Dt(time)   = mean(vec(Osim(:, :, time).*Thsim(:, :, time).*Hsim(:, :, time))); 
   
end


% Next Study Impact of 500$ cash transfer
           
Acsim             = Asim;  
Ocsim             = Osim; 
Thcsim            = Thsim;
Hcsim             = Hsim; 

Ccsim             = Csim; 
Lcsim             = Lsim; 
Dcsim             = Dsim; 

Vcsim             = Vsim;

Pallcsim          = Pallsim; 
Vallcsim          = Vallsim;

time                = 2; 


Transfer            = 0.0388; 

RHS                 = (1 + interest(Asim(:, :, time), p)).*Asim(:, :, time) + Transfer; 

data                = [RHS(:)./(1 + p.rh), RHS(:)./(1 + p.rl)]; 

Acsim(:, :, time)   = reshape(bisect('findtransfer', min(data, [], 2) - 0.1, max(data, [], 2) + 0.1, RHS(:), p), 2*N, T); 


%Ocsim(:, :, time)  = Osim(:, :, time); 
%Thcsim(:, :, time) = Thsim(:, :, time); 



for time = 2 : S
    for initage = 1 : T
 
        age          = Agesim(1, initage, time); 
        
  Whinterp           = griddedInterpolant({p.lgrid, (1: 1: p.no*p.nt*p.nh*p.nz)'},  reshape(wh(:, age), p.nl, p.no*p.nt*p.nh*p.nz), intmeth, 'linear'); 
  Wrinterp           = griddedInterpolant({p.lgrid, (1: 1:                p.nz)'},  reshape(wr(:, age), p.nl,                p.nz), intmeth, 'linear');
  
  % Renters
 
  rent               = Hcsim(:, initage, time) == 0; 

  state              = (1 + interest(Acsim(rent, initage,  time), p)).*Acsim(rent, initage,  time);

  ntemp              = numel(find(rent)); 
  
  [Lall, Oall, Thall, Hall, Vcsim(rent, initage, time), Pallcsim(rent, 1 : 3, initage, time), Vallcsim(rent, 1 : 3, initage, time)] = ...
                              solveh(state, Whinterp, Wrinterp, p, p.thetay(age), 'r', state(:,1), Ysim(rent, initage,  time), Zsim(rent, initage,  time));
 
  Pcum               = [zeros(ntemp, 1), cumsum(Pallcsim(rent, 1 : 3, initage, time), 2)];  


  Dcsim(rent, initage, time)         = ((Usim(rent, initage, time) < Pcum(:, 2:end)).*(Usim(rent, initage, time) >= Pcum(:,1:end-1)))*(1 : 1 : 3)';

  ind                = sub2ind([ntemp, 3], (1 : 1 : ntemp)', Dcsim(rent, initage, time)); 

  Lcsim(rent, initage, time)         =  Lall(ind); 
  Ocsim(rent, initage, time + 1)     =  Oall(ind);
  Thcsim(rent, initage, time + 1)    = Thall(ind); 
  Hcsim(rent, initage, time + 1)     =  Hall(ind); 

  % Homeowners                        

  Attemp             = (1 + interest(Acsim(~rent, initage,  time), p)).*Acsim(~rent, initage,  time) - Deltasim(~rent, initage, time).*Hcsim(~rent, initage,  time);

  state              = [Attemp, Ocsim(~rent, initage,  time), Thcsim(~rent, initage,  time), Hcsim(~rent, initage,  time)];                     % others don't matter directly
  
  hind               = lookup1(p.hgrid,  state(:, 4), 1); 
  tind               = lookup1(p.tgrid,  state(:, 3), 1); 
  
  ntemp              = numel(find(~rent)); 

  [Lall, Oall, Thall, Hall, Vcsim(~rent, initage, time), Pallcsim(~rent, :, initage, time), Vallcsim(~rent, :, initage, time)] = ...
                              solveh(state, Whinterp, Wrinterp, p, p.thetay(age), 'h', state(:,1), Ysim(~rent, initage, time), Zsim(~rent, initage, time), hind, tind);
 
  Pcum               = [zeros(ntemp, 1), cumsum(Pallcsim(~rent, :, initage, time), 2)];  

  unif               = rand(ntemp, 1); 

  Dcsim(~rent, initage, time)     = ((Usim(~rent, initage, time) < Pcum(:, 2:end)).*(Usim(~rent, initage, time) >= Pcum(:,1:end-1)))*(1 : 1 : 5)';

  ind                = sub2ind([ntemp, 5], (1 : 1 : ntemp)', Dcsim(~rent, initage, time)); 

  Lcsim(~rent, initage, time)        =  Lall(ind); 
  Ocsim(~rent, initage, time + 1)    =  Oall(ind);
  Thcsim(~rent, initage, time + 1)   = Thall(ind); 
  Hcsim(~rent, initage, time + 1)    =  Hall(ind);

  
  
 % Find consumption

  rent               = Hcsim(:, initage, time + 1) == 0; 

  Chint              = griddedInterpolant({p.lgrid, p.ogrid, p.tgrid, p.hgrid, p.zgrid},  reshape(ch(:, age), p.nl, p.no, p.nt, p.nh, p.nz), intmeth, 'linear');
  Crint              = griddedInterpolant({p.lgrid,                            p.zgrid},  reshape(cr(:, age), p.nl,                   p.nz), intmeth, 'linear');

  cmin               = bisect('savings', 1e-13, 1e5, Lcsim(rent, initage, time), p, 'r', amax);                  % c that implies a' = amin
  cmax               = bisect('savings', 1e-13, 1e5, Lcsim(rent, initage, time), p, 'r', amin);                  % c that implies a' = amin

  Ccsim(rent, initage, time)           = max(min(Crint(Lcsim(rent, initage, time),  p.zgrid(Zsim(rent, initage, time))), cmax), cmin);

  [~, Acsim(rent, initage, time + 1)]  = savings(Ccsim(rent, initage, time), Lcsim(rent, initage, time), p, 'r');                                   % none of the other state variables matter

  
  cmin               = bisect('savings', 1e-13, 1e5, Lcsim(~rent, initage, time), p, 'h', amax);                 % c that implies a' = amin
  cmax               = bisect('savings', 1e-13, 1e5, Lcsim(~rent, initage, time), p, 'h', amin);                 % c that implies a' = amin

 Ccsim(~rent, initage, time)           = max(min(Chint(Lcsim(~rent, initage, time), Ocsim(~rent,initage, time + 1), Thcsim(~rent,initage, time + 1), Hcsim(~rent,initage, time + 1), p.zgrid(Zsim(~rent, initage, time))), cmax), cmin);

 [~, Acsim(~rent, initage, time + 1)]  = savings(Ccsim(~rent, initage, time), Lcsim(~rent, initage, time), p, 'h');                                   % none of the other state variables matter

  
  
    if age == T
      
      Acsim(:,  initage, time + 1)  = 0;
      Ocsim(:,  initage, time + 1)  = 0;
      Thcsim(:, initage, time + 1)  = 0;
      Hcsim(:,  initage, time + 1)  = 0;

    end
    
    end
end
    

Cct   = zeros(S, 1); 
Act   = zeros(S, 1); 
Hct   = zeros(S, 1); 
Dct   = zeros(S, 1); 


for time = 1 : S
    
   Cct(time)   = mean(vec(Ccsim(:, :, time))); 
   Hct(time)   = mean(vec(Hcsim(:, :, time))); 
   Act(time)   = mean(vec(Acsim(:, :, time)));
   Dct(time)   = mean(vec(Ocsim(:, :, time).*Thcsim(:, :, time).*Hcsim(:, :, time))); 
   
end


MPCt           = (Cct - Ct)/mean(vec(Transfer)); 


% Ask: how many homeowners (in period time = 2) benefit, so Vcsim(:, :, time) > Vsim(:, :, time) and what do 

% 1. Fraction of homeowners who benefit

% 2. Distribution of welfare gains

Vnew          = reshape(Vcsim(:, :, 2),              2*N*T, 1); 
Vold          = reshape(Vsim(:, :, 2),               2*N*T, 1); 
UCold         = reshape(Csim(:, :, 2).^(- p.sigma),  2*N*T, 1);

PTI           = p.mbar*Thsim(:, :, 2).*Hsim(:, :, 2)./Ysim(:,:,2).*(Osim(:, :, 2) > 0);


gains         = max(min((Vnew(:) - Vold(:))./Transfer(:)./UCold(:), 1), 0);  % small fraction due to interpolation error 


MPC           = (Ccsim(:, :, 2) - p.phi^(1 + 1/p.gamma)*Ccsim(:, :, 2).^(-p.sigma/p.gamma) - (Csim(:, :, 2) - p.phi^(1 + 1/p.gamma)*Csim(:, :, 2).^(-p.sigma/p.gamma)))/Transfer; 

owners        = Hsim(:, :, 2) > 0; 

fprintf('MPC, mean                                        = %9.2f %9.2f %9.2f \n',  [mean(MPC(:)),          mean(MPC(owners)),          mean(MPC(~owners))         ]);
fprintf('MPC, 10th pctile                                 = %9.2f %9.2f %9.2f \n',  [prctile(MPC(:),   10), prctile(MPC(owners),   10), prctile(MPC(~owners),   10)]);
fprintf('MPC, 25th pctile                                 = %9.2f %9.2f %9.2f \n',  [prctile(MPC(:),   25), prctile(MPC(owners),   25), prctile(MPC(~owners),   25)]);
fprintf('MPC, 50th pctile                                 = %9.2f %9.2f %9.2f \n',  [prctile(MPC(:),   50), prctile(MPC(owners),   50), prctile(MPC(~owners),   50)]);
fprintf('MPC, 75th pctile                                 = %9.2f %9.2f %9.2f \n',  [prctile(MPC(:),   75), prctile(MPC(owners),   75), prctile(MPC(~owners),   75)]);
fprintf('MPC, 90th pctile                                 = %9.2f %9.2f %9.2f \n',  [prctile(MPC(:),   90), prctile(MPC(owners),   90), prctile(MPC(~owners),   90)]);



% plot MPC as a function of various characteristics for homeowners

% 1. Loan to Value

ltv      = Thsim(:, :, 2).*Osim(:,:,2); 
lasst    = Asim(:, :, 2)./(Asim(:,:,2) + (1 - Thsim(:, :, 2).*Osim(:, :, 2)).*Hsim(:,:,2));      % liquid assets to wealth
logy     = log(Ysim(:, :, 2));                                                                   % log income
pti      = p.mbar*Thsim(:, :, 2).*Hsim(:, :, 2)./Ysim(:,:,2).*(Osim(:, :, 2) > 0); 

ind      = Hsim(:, :, 2) > 0; 


ltv      = ltv(ind); 
lasst    = lasst(ind);
logy     = logy(ind); 
pti      = pti(ind); 
mpc      = MPC(ind);

prefi    = squeeze(Pallsim(:, 4, :, time)); 
prefi    = prefi(ind);

xx       = [ltv, pti, lasst, logy];
yy       = mpc; 

figure(5)
subplot(2, 2, 1)

[xxmed, yymed] = binned_plot(xx(:,1), yy, 11);

ff             = fit(xxmed, yymed, 'smoothingspline');
xnode          = nodeunif(11, 0, 0.85);  

scatter(xnode, ff(xnode), 150, [0.02, 0.26, 0.48], 'filled'); set(gca, 'ygrid', 'on'); 

hold on;

ffs            = griddedInterpolant(xnode,  ff(xnode), 'pchip');

xxnodes        = nodeunif(100, xnode(1), xnode(end)); 


plot(xxnodes, ffs(xxnodes), 'LineWidth', 4, 'Color', [0.02, 0.26, 0.48])

xlabel('loan-to-value ratio','Interpreter','latex');
ylabel('MPC','Interpreter','latex');
title('A. LTV','Interpreter','latex');
box on


subplot(2, 2, 2)

[xxmed, yymed] = binned_plot(xx(:,2), yy, 11);

ff             = fit(xxmed, yymed, 'smoothingspline');
xnode          = nodeunif(11, 0, 0.3);  

scatter(xnode, ff(xnode), 150, [0.02, 0.26, 0.48], 'filled'); set(gca, 'ygrid', 'on'); 
hold on

ffs            = griddedInterpolant(xnode,  ff(xnode), 'pchip');

xxnodes        = nodeunif(100, xnode(1), xnode(end)); 

plot(xxnodes, ffs(xxnodes), 'LineWidth', 4, 'Color', [0.02, 0.26, 0.48])

xlabel('payment to income ratio','Interpreter','latex');
title('B. PTI','Interpreter','latex');
box on



subplot(2, 2, 3)

[xxmed, yymed] = binned_plot(xx(:,3), yy, 11);

ff             = fit(xxmed, yymed, 'smoothingspline');
xnode          = nodeunif(11, xxmed(1), xxmed(end));  

scatter(xnode, ff(xnode), 150, [0.02, 0.26, 0.48], 'filled'); set(gca, 'ygrid', 'on'); 
hold on

ffs            = griddedInterpolant(xnode,  ff(xnode), 'pchip');

xxnodes        = nodeunif(100, xnode(1), xnode(end)); 

plot(xxnodes, ffs(xxnodes), 'LineWidth', 4, 'Color', [0.02, 0.26, 0.48])

xlabel('liquid assets to wealth','Interpreter','latex');
ylabel('MPC','Interpreter','latex');
title('C. Liquid Assets to Wealth','Interpreter','latex');
box on


subplot(2, 2, 4)

[xxmed, yymed] = binned_plot(xx(:,4), yy, 11);

ff             = fit(xxmed, yymed, 'smoothingspline');
xnode          = nodeunif(11, xxmed(1), xxmed(end));  

scatter(xnode, ff(xnode), 150, [0.02, 0.26, 0.48], 'filled'); set(gca, 'ygrid', 'on'); 
hold on

ffs            = griddedInterpolant(xnode,  ff(xnode), 'pchip');

xxnodes        = nodeunif(100, xnode(1), xnode(end)); 

plot(xxnodes, ffs(xxnodes), 'LineWidth', 4, 'Color', [0.02, 0.26, 0.48])

xlabel('log income','Interpreter','latex');
title('D. Income','Interpreter','latex');
box on
