close all

set(groot, 'DefaultAxesLineWidth', 1.5);
set(groot, 'DefaultLineLineWidth', 4);
set(groot, 'DefaultAxesTickLabelInterpreter','latex'); 
set(groot, 'DefaultLegendInterpreter','latex');
set(groot, 'DefaultAxesFontSize',24);


S              = 5; 

% Without intervention

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

Deltasim(:, :, 1)   = Deltasave(:, 1 : T); 

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
                              solveh(state, Whinterp, Wrinterp, p, p.thetay(age), 'r', state(:, 1), Ysim(rent, initage,  time), Zsim(rent, initage,  time));
 
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
                               solveh(state, Whinterp, Wrinterp, p, p.thetay(age), 'h', state(:, 1), Ysim(~rent, initage, time), Zsim(~rent, initage, time), hind, tind);
 
  Pcum               = [zeros(ntemp, 1), cumsum(Pallsim(~rent, :, initage, time), 2)];  

  Dsim(~rent, initage, time)        = ((Usim(~rent, initage, time) < Pcum(:, 2:end)).*(Usim(~rent, initage, time) >= Pcum(:,1:end-1)))*(1 : 1 : 5)';

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
Rt   = zeros(S, 1); 
MPRt = zeros(S, 1);       % Beraja-Hurst propensity to refinance: amount of newly refinanced mortgages / outstanding stock of all existing mortgages
Emt  = zeros(S, 1);       % median equity (1 - LTV) for borrowers



for time = 1 : S
    
   Ct(time)    = mean(vec(Csim(:, :, time))); 
   Yt(time)    = mean(vec(Ysim(:, :, time))); 
   Ht(time)    = mean(vec(Hsim(:, :, time))); 
   At(time)    = mean(vec(Asim(:, :, time)));
   Dt(time)    = mean(vec(Osim(:, :, time).*Thsim(:, :, time).*Hsim(:, :, time))); 
   Rt(time)    = mean(vec(Dsim(:, :, time) == 4 & Hsim(:, :, time) > 0 & Osim(:, :, time).*Thsim(:, :, time) > 0))/mean(vec(Hsim(:, :, time) > 0 & Osim(:, :, time).*Thsim(:, :, time) > 0));
        
end


% With intervention

start_new;

Acsim           = Asim;  
Ocsim           = Osim; 
Thcsim          = Thsim;
Hcsim           = Hsim; 

Ccsim           = Csim; 
Lcsim           = Lsim; 
Dcsim           = Dsim; 

Vcsim           = zeros(2*N, T, S); 

Pallcsim        = Pallsim; 
Vallcsim        = Vallsim;

Rcsim               = zeros(2*N, T, S + 1); 

Rcsim(:, :, 1 : 2)  = 1;

Ocsim(:, :, 2)      = Osim(:,:,2);



for time = 2 : S
    for initage = 1 : T
 
        age          = Agesim(1, initage, time); 
        
  Whinterp           = griddedInterpolant({p.lgrid, (1: 1: p.no*p.nt*p.nh*p.nr*p.nz)'},  reshape(wh(:, age), p.nl, p.no*p.nt*p.nh*p.nr*p.nz), intmeth, 'linear'); 
  Wrinterp           = griddedInterpolant({p.lgrid, (1: 1:                     p.nz)'},  reshape(wr(:, age), p.nl,                     p.nz), intmeth, 'linear');
  
 
  rent               = Hcsim(:, initage, time) == 0; 

  % Renters
  
  state              = (1 + interest(Acsim(rent, initage,  time), p)).*Acsim(rent, initage,  time);
  
  ntemp              = numel(find(rent)); 

  [Lall, Oall, Thall, Hall, Vcsim(rent, initage, time), Pallcsim(rent, 1 : 3, initage, time), Vallcsim(rent, 1 : 3, initage, time)] = ...
                              solveh_new(state, Whinterp, Wrinterp, p, p.thetay(age), 'r', state(:,1), Ysim(rent, initage,  time), Zsim(rent, initage,  time));
 
  Pcum               = [zeros(ntemp, 1), cumsum(Pallcsim(rent, 1 : 3, initage, time), 2)];  


  Dcsim(rent, initage, time)         = ((Usim(rent, initage, time) < Pcum(:, 2:end)).*(Usim(rent, initage, time) >= Pcum(:,1:end-1)))*(1 : 1 : 3)';

  ind                = sub2ind([ntemp, 3], (1 : 1 : ntemp)', Dcsim(rent, initage, time)); 

  Lcsim(rent, initage, time)         =  Lall(ind); 
  Ocsim(rent, initage, time + 1)     =  Oall(ind);
  Thcsim(rent, initage, time + 1)    = Thall(ind); 
  Hcsim(rent, initage, time + 1)     =  Hall(ind); 
           
  
  % Homeowners
                           
  Attemp             = (1 + interest(Acsim(~rent, initage,  time), p)).*Acsim(~rent, initage,  time) - Deltasim(~rent, initage, time).*Hcsim(~rent, initage,  time);
  
  state              = [Attemp, Ocsim(~rent, initage,  time), Thcsim(~rent, initage,  time), Hcsim(~rent, initage,  time), Rcsim(~rent, initage, time)];                     % others don't matter directly
  
  hind               = lookup1(p.hgrid,  state(:, 4), 1); 
  tind               = lookup1(p.tgrid,  state(:, 3), 1); 
  rind               = state(:, 5);                          % made this state variable an index (1, 2), or else doesn't respect monotonicity
  
  ntemp              = numel(find(~rent)); 

   
  [Lall, Oall, Thall, Hall, Vcsim(~rent, initage, time), Pallcsim(~rent, :, initage, time), Vallcsim(~rent, :, initage, time)] = ...
                                solveh_new(state, Whinterp, Wrinterp, p, p.thetay(age), 'h', state(:,1), Ysim(~rent, initage, time), Zsim(~rent, initage, time), hind, tind, rind);
 
  Pcum               = [zeros(ntemp, 1), cumsum(Pallcsim(~rent, :, initage, time), 2)];  

  unif               = rand(ntemp, 1); 

  Dcsim(~rent, initage, time)        = ((Usim(~rent, initage, time) < Pcum(:, 2:end)).*(Usim(~rent, initage, time) >= Pcum(:,1:end-1)))*(1 : 1 : 5)';

  ind                                = sub2ind([ntemp, 5], (1 : 1 : ntemp)', Dcsim(~rent, initage, time)); 

  Lcsim(~rent, initage, time)        =  Lall(ind); 
  Ocsim(~rent, initage, time + 1)    =  Oall(ind);
  Thcsim(~rent, initage, time + 1)   = Thall(ind); 
  Hcsim(~rent, initage, time + 1)    =  Hall(ind);
                      
                            
  inactive                    = Dcsim(:, initage, time) == 5; 
                          
  Rcsim(:, initage, time + 1) = Rcsim(:, initage, time).*inactive + p.nr.*(1 - inactive);            
        
  
 % Find consumption

  rent               = Hcsim(:, initage, time + 1) == 0; 

  Chint              = griddedInterpolant({p.lgrid, p.ogrid, p.tgrid, p.hgrid, (1 : 1 : p.nr)', p.zgrid},  reshape(ch(:, age), p.nl, p.no, p.nt, p.nh, p.nr, p.nz), intmeth, 'linear');
  Crint              = griddedInterpolant({p.lgrid,                                             p.zgrid},  reshape(cr(:, age), p.nl,                         p.nz), intmeth, 'linear');

  cmin               = bisect('savings', 1e-13, 1e5, Lcsim(rent, initage, time), p, 'r', amax);                  % c that implies a' = amin
  cmax               = bisect('savings', 1e-13, 1e5, Lcsim(rent, initage, time), p, 'r', amin);                  % c that implies a' = amin

  Ccsim(rent, initage, time)           = max(min(Crint(Lcsim(rent, initage, time),  p.zgrid(Zsim(rent, initage, time))), cmax), cmin);

  [~, Acsim(rent, initage, time + 1)]  = savings(Ccsim(rent, initage, time), Lcsim(rent, initage, time), p, 'r');                                   % none of the other state variables matter

  
  cmin               = bisect('savings', 1e-13, 1e5, Lcsim(~rent, initage, time), p, 'h', amax);                 % c that implies a' = amin
  cmax               = bisect('savings', 1e-13, 1e5, Lcsim(~rent, initage, time), p, 'h', amin);                 % c that implies a' = amin

 Ccsim(~rent, initage, time)           = max(min(Chint(Lcsim(~rent, initage, time), Ocsim(~rent,initage, time + 1), Thcsim(~rent,initage, time + 1), Hcsim(~rent,initage, time + 1), Rcsim(~rent,initage, time + 1), p.zgrid(Zsim(~rent, initage, time))), cmax), cmin);

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
Yct   = zeros(S, 1); 
Act   = zeros(S, 1); 
Hct   = zeros(S, 1); 
Dct   = zeros(S, 1); 
Rct   = zeros(S, 1); 

for time = 1 : S
    
    
   Cct(time)   = mean(vec(Ccsim(:, :, time))); 
   Hct(time)   = mean(vec(Hcsim(:, :, time))); 
   Act(time)   = mean(vec(Acsim(:, :, time)));
   Dct(time)   = mean(vec(Ocsim(:, :, time).*Thcsim(:, :, time).*p.Pgrid(Rcsim(:,:,time)).*Hcsim(:, :, time))); 
   Rct(time)   = mean(vec(Dcsim(:, :, time) == 4 & Hcsim(:, :, time) > 0 & Ocsim(:, :, time).*Thcsim(:, :, time) > 0))/mean(vec(Hcsim(:, :, time) > 0 & Ocsim(:, :, time).*Thcsim(:, :, time) > 0));
    
end




% Next, simulate Ganong-Noel Experiment


Agsim           = Asim;  
Ogsim           = Osim; 
Thgsim          = Thsim;
Hgsim           = Hsim; 

Cgsim           = Csim; 
Lgsim           = Lsim; 
Dgsim           = Dsim; 

Vgsim           = zeros(2*N, T, S); 

Pallgsim        = Pallsim; 
Vallgsim        = Vallsim;

Rgsim               = zeros(2*N, T, S + 1); 

Rgsim(:, :, 1 : 2)  = 1;

time                = 2; 

Thgsim(:, :, time)  = Thsim(:, :, time); 
Ogsim(:, :, time)   = min(Osim(:, :, time) + 0.056978./Thsim(:, :, time), 1).*(Hsim(:, :, time) > 0 & Osim(:, :, time) > 0 & Thsim(:, :, time) > 0);     % only for borrowers                    % make change a fixed fraction of value of their homes

% Select these if want to introduce liquidity injection after interest rate change

%Thgsim(:, :, time)  = Thsim(:, :, time).*(Thsim(:, :,time) > 0 & Hsim(:,:,time) > 0) + p.tgrid(end).*(Thsim(:, :,time) == 0 & Hsim(:,:,time) > 0);
%Ogsim(:, :, time)   = min(Osim(:, :, time) + 0.01/(1 + p.rm0)./Thgsim(:, :, time), 1).*(Hsim(:, :, time) > 0);                                           % make change a fixed fraction of value of their homes

Transfer            = (1 + p.rm0)*(Ogsim(:, :, time).*Thgsim(:, :, time) - Osim(:, :, time).*Thsim(:, :, time)).*Hsim(:, :, time); 

RHS                 = (1 + interest(Asim(:, :, time), p)).*Asim(:, :, time) + Transfer; 

data                = [RHS(:)./(1 + p.rh), RHS(:)./(1 + p.rl)]; 


Agsim(:, :, time)   = reshape(bisect('findtransfer', min(data, [], 2) - 0.1, max(data, [], 2) + 0.1, RHS(:), p), 2*N, T); 


%Ogsim(:, :, time)   = Osim(:, :, time);    % payment and principal reduction
%Thgsim(:, :, time)  = Thsim(:, :, time); 



for time = 2 : S
    for initage = 1 : T
 
        age          = Agesim(1, initage, time); 
        
  Whinterp           = griddedInterpolant({p.lgrid, (1: 1: p.no*p.nt*p.nh*p.nr*p.nz)'},  reshape(wh(:, age), p.nl, p.no*p.nt*p.nh*p.nr*p.nz), intmeth, 'linear'); 
  Wrinterp           = griddedInterpolant({p.lgrid, (1: 1:                     p.nz)'},  reshape(wr(:, age), p.nl,                     p.nz), intmeth, 'linear');
  
 
  rent               = Hgsim(:, initage, time) == 0; 

  % Renters
  
  state              = (1 + interest(Agsim(rent, initage,  time), p)).*Agsim(rent, initage,  time);
  
  ntemp              = numel(find(rent)); 

  [Lall, Oall, Thall, Hall, Vgsim(rent, initage, time), Pallgsim(rent, 1 : 3, initage, time), Vallgsim(rent, 1 : 3, initage, time)] = ...
                              solveh_new(state, Whinterp, Wrinterp, p, p.thetay(age), 'r', state(:,1), Ysim(rent, initage,  time), Zsim(rent, initage,  time));
 
  Pcum               = [zeros(ntemp, 1), cumsum(Pallgsim(rent, 1 : 3, initage, time), 2)];  


  Dgsim(rent, initage, time)         = ((Usim(rent, initage, time) < Pcum(:, 2:end)).*(Usim(rent, initage, time) >= Pcum(:,1:end-1)))*(1 : 1 : 3)';

  ind                = sub2ind([ntemp, 3], (1 : 1 : ntemp)', Dgsim(rent, initage, time)); 

  Lgsim(rent, initage, time)         =  Lall(ind); 
  Ogsim(rent, initage, time + 1)     =  Oall(ind);
  Thgsim(rent, initage, time + 1)    = Thall(ind); 
  Hgsim(rent, initage, time + 1)     =  Hall(ind); 
           
  
  % Homeowners
                           
  Attemp             = (1 + interest(Agsim(~rent, initage,  time), p)).*Agsim(~rent, initage,  time) - Deltasim(~rent, initage, time).*Hgsim(~rent, initage,  time);
  
  state              = [Attemp, Ogsim(~rent, initage,  time), Thgsim(~rent, initage,  time), Hgsim(~rent, initage,  time), Rgsim(~rent, initage, time)];                     % others don't matter directly
  
  hind               = lookup1(p.hgrid,  state(:, 4), 1); 
  tind               = lookup1(p.tgrid,  state(:, 3), 1); 
  rind               = state(:, 5);                          % made this state variable an index (1, 2), or else doesn't respect monotonicity
  
  ntemp              = numel(find(~rent)); 

   
  [Lall, Oall, Thall, Hall, Vgsim(~rent, initage, time), Pallgsim(~rent, :, initage, time), Vallgsim(~rent, :, initage, time)] = ...
                                solveh_new(state, Whinterp, Wrinterp, p, p.thetay(age), 'h', state(:,1), Ysim(~rent, initage, time), Zsim(~rent, initage, time), hind, tind, rind);
 
  Pcum               = [zeros(ntemp, 1), cumsum(Pallgsim(~rent, :, initage, time), 2)];  

  unif               = rand(ntemp, 1); 

  Dgsim(~rent, initage, time)        = ((Usim(~rent, initage, time) < Pcum(:, 2:end)).*(Usim(~rent, initage, time) >= Pcum(:,1:end-1)))*(1 : 1 : 5)';

  ind                                = sub2ind([ntemp, 5], (1 : 1 : ntemp)', Dgsim(~rent, initage, time)); 

  Lgsim(~rent, initage, time)        =  Lall(ind); 
  Ogsim(~rent, initage, time + 1)    =  Oall(ind);
  Thgsim(~rent, initage, time + 1)   = Thall(ind); 
  Hgsim(~rent, initage, time + 1)    =  Hall(ind);
                      
                            
  inactive                    = Dgsim(:, initage, time) == 5; 
                          
  Rgsim(:, initage, time + 1) = Rgsim(:, initage, time).*inactive + p.nr.*(1 - inactive);            
        
  
 % Find consumption

  rent               = Hgsim(:, initage, time + 1) == 0; 

  Chint              = griddedInterpolant({p.lgrid, p.ogrid, p.tgrid, p.hgrid, (1 : 1 : p.nr)', p.zgrid},  reshape(ch(:, age), p.nl, p.no, p.nt, p.nh, p.nr, p.nz), intmeth, 'linear');
  Crint              = griddedInterpolant({p.lgrid,                                             p.zgrid},  reshape(cr(:, age), p.nl,                         p.nz), intmeth, 'linear');

  cmin               = bisect('savings', 1e-13, 1e5, Lgsim(rent, initage, time), p, 'r', amax);                  % c that implies a' = amin
  cmax               = bisect('savings', 1e-13, 1e5, Lgsim(rent, initage, time), p, 'r', amin);                  % c that implies a' = amin

  Cgsim(rent, initage, time)           = max(min(Crint(Lgsim(rent, initage, time),  p.zgrid(Zsim(rent, initage, time))), cmax), cmin);

  [~, Agsim(rent, initage, time + 1)]  = savings(Cgsim(rent, initage, time), Lgsim(rent, initage, time), p, 'r');                                   % none of the other state variables matter

  
  cmin               = bisect('savings', 1e-13, 1e5, Lgsim(~rent, initage, time), p, 'h', amax);                 % c that implies a' = amin
  cmax               = bisect('savings', 1e-13, 1e5, Lgsim(~rent, initage, time), p, 'h', amin);                 % c that implies a' = amin

 Cgsim(~rent, initage, time)           = max(min(Chint(Lgsim(~rent, initage, time), Ogsim(~rent,initage, time + 1), Thgsim(~rent,initage, time + 1), Hgsim(~rent,initage, time + 1), Rgsim(~rent,initage, time + 1), p.zgrid(Zsim(~rent, initage, time))), cmax), cmin);

 [~, Agsim(~rent, initage, time + 1)]  = savings(Cgsim(~rent, initage, time), Lgsim(~rent, initage, time), p, 'h');                                   % none of the other state variables matter

  
    if age == T
      
      Agsim(:,  initage, time + 1)  = 0;
      Ogsim(:,  initage, time + 1)  = 0;
      Thgsim(:, initage, time + 1)  = 0;
      Hgsim(:,  initage, time + 1)  = 0;
      
    end
    
    end
end

           
Cgt   = zeros(S, 1); 
Ygt   = zeros(S, 1); 
Agt   = zeros(S, 1); 
Hgt   = zeros(S, 1); 
Dgt   = zeros(S, 1); 
Rgt   = zeros(S, 1); 


for time = 1 : S
    
   Cgt(time)   = mean(vec(Cgsim(:, :, time))); 
   Hgt(time)   = mean(vec(Hgsim(:, :, time))); 
   Agt(time)   = mean(vec(Agsim(:, :, time)));
   Dgt(time)   = mean(vec(Ogsim(:, :, time).*Thgsim(:, :, time).*p.Pgrid(Rgsim(:,:,time)).*Hgsim(:, :, time))); 
   Rgt(time)   = mean(vec(Dgsim(:, :, time) == 4 & Hgsim(:, :, time) > 0 & Ogsim(:, :, time).*Thgsim(:, :, time) > 0))/mean(vec(Hgsim(:, :, time) > 0 & Ogsim(:, :, time).*Thgsim(:, :, time) > 0));
   
end

Vnew       = reshape(Vgsim(:, :, 2), 2*N*T, 1); 
Vold       = reshape(Vcsim(:, :, 2), 2*N*T, 1); 
UCold      = reshape(Ccsim(:, :, 2).^(- p.sigma),  2*N*T, 1);
Tran       = reshape(Transfer,                     2*N*T, 1);

ind        = Tran > 0; 

gains      = max(min((Vnew(ind) - Vold(ind))./Transfer(ind)./UCold(ind), 1), 0);  % small fraction due to interpolation error 


PTI        = p.mbar0*Thsim(:, :, 2).*Hsim(:, :, 2)./Ysim(:,:,2).*(Osim(:, :, 2) > 0);

sel        = PTI > 0.15; 
sel        = sel(ind); 

if 1   % annual MPC
    
MPC        = (Cgsim(:, :, 2) - p.phi^(1 + 1/p.gamma)*Cgsim(:, :, 2).^(-p.sigma/p.gamma) - (Ccsim(:, :, 2) - p.phi^(1 + 1/p.gamma)*Ccsim(:, :, 2).^(-p.sigma/p.gamma))) + ...
             (Cgsim(:, :, 3) - p.phi^(1 + 1/p.gamma)*Cgsim(:, :, 3).^(-p.sigma/p.gamma) - (Ccsim(:, :, 3) - p.phi^(1 + 1/p.gamma)*Ccsim(:, :, 3).^(-p.sigma/p.gamma))) + ... 
             (Cgsim(:, :, 4) - p.phi^(1 + 1/p.gamma)*Cgsim(:, :, 4).^(-p.sigma/p.gamma) - (Ccsim(:, :, 4) - p.phi^(1 + 1/p.gamma)*Ccsim(:, :, 4).^(-p.sigma/p.gamma))) + ...
             (Cgsim(:, :, 5) - p.phi^(1 + 1/p.gamma)*Cgsim(:, :, 5).^(-p.sigma/p.gamma) - (Ccsim(:, :, 5) - p.phi^(1 + 1/p.gamma)*Ccsim(:, :, 5).^(-p.sigma/p.gamma)));

MPC        = reshape(MPC,                         2*N*T, 1);

MPC        = MPC(ind)./Tran(ind); 

else  % quarterly MPC
  
MPC        = (Cgsim(:, :, 2) - p.phi^(1 + 1/p.gamma)*Cgsim(:, :, 2).^(-p.sigma/p.gamma) - (Ccsim(:, :, 2) - p.phi^(1 + 1/p.gamma)*Ccsim(:, :, 2).^(-p.sigma/p.gamma)));

MPC        = reshape(MPC,                         2*N*T, 1);

MPC        = MPC(ind)./Tran(ind); 
    
    
end

fprintf('\n')

fprintf('Fraction who benefit                             = %9.2f %9.2f\n',  [mean(gains > 0),               sum(gains > 0 & sel)/sum(sel)]);
fprintf('\n')

fprintf('Willingness to pay, mean                         = %9.2f %9.2f\n',  [mean(gains(gains > 0)),        mean(gains(gains > 0 & sel))        ]);
fprintf('Willingness to pay, 10th pctile                  = %9.2f %9.2f\n',  [prctile(gains(gains > 0), 10), prctile(gains(gains > 0 & sel), 10) ]);
fprintf('Willingness to pay, 25th pctile                  = %9.2f %9.2f\n',  [prctile(gains(gains > 0), 25), prctile(gains(gains > 0 & sel), 25) ]);
fprintf('Willingness to pay, 50th pctile                  = %9.2f %9.2f\n',  [prctile(gains(gains > 0), 50), prctile(gains(gains > 0 & sel), 50) ]);
fprintf('Willingness to pay, 75th pctile                  = %9.2f %9.2f\n',  [prctile(gains(gains > 0), 75), prctile(gains(gains > 0 & sel), 75) ]);
fprintf('Willingness to pay, 90th pctile                  = %9.2f %9.2f\n',  [prctile(gains(gains > 0), 90), prctile(gains(gains > 0 & sel), 90) ]);
fprintf('\n')


fprintf('MPC, mean                                        = %9.2f %9.2f\n',  [mean(MPC(gains > 0)),          mean(MPC(gains > 0 & sel)),        ]);
fprintf('MPC, 10th pctile                                 = %9.2f %9.2f\n',  [prctile(MPC(gains > 0),   10), prctile(MPC(gains > 0 & sel),   10)]);
fprintf('MPC, 25th pctile                                 = %9.2f %9.2f\n',  [prctile(MPC(gains > 0),   25), prctile(MPC(gains > 0 & sel),   25)]);
fprintf('MPC, 50th pctile                                 = %9.2f %9.2f\n',  [prctile(MPC(gains > 0),   50), prctile(MPC(gains > 0 & sel),   50)]);
fprintf('MPC, 75th pctile                                 = %9.2f %9.2f\n',  [prctile(MPC(gains > 0),   75), prctile(MPC(gains > 0 & sel),   75)]);
fprintf('MPC, 90th pctile                                 = %9.2f %9.2f\n',  [prctile(MPC(gains > 0),   90), prctile(MPC(gains > 0 & sel),   90)]);
