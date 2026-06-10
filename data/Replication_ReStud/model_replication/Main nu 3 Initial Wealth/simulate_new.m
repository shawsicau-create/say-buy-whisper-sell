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
    
   MPRt(time)  = sum(vec((Dsim(:,:, time) == 4).*Osim(:, :, time + 1).*Thsim(:, :, time + 1).*Hsim(:, :, time + 1)))/...
                 sum(vec(                        Osim(:, :, time    ).*Thsim(:, :, time    ).*Hsim(:, :, time    ))); 
   
   LTV         = vec(Osim(:, :, time).*Thsim(:, :, time)); 
   
   Emt(time)   = 1 - median(LTV(LTV > 0));           
            
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
MPRct = zeros(S, 1);       % Beraja-Hurst propensity to refinance: amount of newly refinanced mortgages / outstanding stock of all existing mortgages
Emct  = zeros(S, 1);       % median equity (1 - LTV) for borrowers


for time = 1 : S
    
    
   Cct(time)   = mean(vec(Ccsim(:, :, time))); 
   Hct(time)   = mean(vec(Hcsim(:, :, time))); 
   Act(time)   = mean(vec(Acsim(:, :, time)));
   Dct(time)   = mean(vec(Ocsim(:, :, time).*Thcsim(:, :, time).*p.Pgrid(Rcsim(:,:,time)).*Hcsim(:, :, time))); 
   Rct(time)   = mean(vec(Dcsim(:, :, time) == 4 & Hcsim(:, :, time) > 0 & Ocsim(:, :, time).*Thcsim(:, :, time) > 0))/mean(vec(Hcsim(:, :, time) > 0 & Ocsim(:, :, time).*Thcsim(:, :, time) > 0));
    
   MPRct(time) = sum(vec((Dcsim(:,:, time) == 4).*Ocsim(:, :, time + 1).*Thcsim(:, :, time + 1).*p.Pgrid(Rcsim(:, :, time + 1)).*Hcsim(:, :, time + 1)))/...
                 sum(vec(                         Ocsim(:, :, time    ).*Thcsim(:, :, time    ).*p.Pgrid(Rcsim(:, :, time    )).*Hcsim(:, :, time    ))); 
   
  if time == 1
      
   LTV         = vec(Ocsim(:, :, time).*Thcsim(:, :, time)); 
   
  else
   
   LTV         = vec(Ocsim(:, :, time).*Thcsim(:, :, time).*p.Pgrid(Rcsim(:,:,time)))/p.Pgrid(p.nr); 
   
  end
   
   Emct(time)   = 1 - median(LTV(LTV > 0));           
            
end



% Characteristics of those who refinance: with and without the shock

Wsim     = Asim + Hsim.*(1 - Osim.*Thsim);

time    = 2; 

Wtemp    = Wsim(:, :, time);                      % only state variables
Atemp    = Asim(:, :, time); 
LTV      = Osim(:, :, time).*Thsim(:, :, time); 
Htemp    = Hsim(:, :, time); 
LY       = Atemp./Ysim(:, :, time); 
Sh       = 1 - Atemp./Wtemp; 
Agetemp  = Agesim(:, :, time)/4 + 25; 
Ytemp    = Ysim(:, :, time); 

refin    = Dsim(:, :, time) == 4 & Hsim(:, :, time) > 0; 
owner    = Hsim(:, :, time) > 0; 

fprintf('\n');
fprintf('Characteristics of Refinancers Absent Shock\n');
fprintf('\n');
fprintf('All, Refinance, Dont Refinance\n');

fprintf('\n');

fprintf('\n');
fprintf('Mean Liquid Assets           = %9.2f %9.2f %9.2f \n',  [mean(Atemp(owner)),    mean(Atemp(owner & refin)),    mean(Atemp(owner & ~refin))]);
fprintf('Mean Income                  = %9.2f %9.2f %9.2f \n',  [mean(Ytemp(owner)),    mean(Ytemp(owner & refin)),    mean(Ytemp(owner & ~refin))]);
fprintf('Mean Liquid Asset to Income  = %9.2f %9.2f %9.2f \n',  [mean(LY(owner)),       mean(LY(owner & refin)),       mean(LY(owner & ~refin))]);
fprintf('Mean Share Housing Wealth    = %9.2f %9.2f %9.2f \n',  [mean(Sh(owner)),       mean(Sh(owner & refin)),       mean(Sh(owner & ~refin))]);
fprintf('Mean Wealth                  = %9.2f %9.2f %9.2f \n',  [mean(Wtemp(owner)),    mean(Wtemp(owner & refin)),    mean(Wtemp(owner & ~refin))]);
fprintf('Mean LTV                     = %9.2f %9.2f %9.2f \n',  [mean(LTV(owner)),      mean(LTV(owner & refin)),      mean(LTV(owner & ~refin))]);
fprintf('Mean House                   = %9.2f %9.2f %9.2f \n',  [mean(Htemp(owner)),    mean(Htemp(owner & refin)),    mean(Htemp(owner & ~refin))]);
fprintf('Mean Age                     = %9.2f %9.2f %9.2f \n',  [mean(Agetemp(owner)),  mean(Agetemp(owner & refin)),  mean(Agetemp(owner & ~refin))]);

fprintf('\n');
fprintf('\n');


Wcsim               = zeros(size(Acsim)); 

Wcsim(:,:, 1)       = Acsim(:, :, 1)         + p.Pgrid(1)*Hcsim(:, :, 1).*(1 - Ocsim(:, :, 1).*Thcsim(:, :, 1));

Wcsim(:, :, 2: end) = Acsim(:, :, 2 : end)   + p.Pgrid(p.nr)*Hcsim(:,:,2:end) - p.Pgrid(Rcsim(:,:,2:end)).*Ocsim(:, :, 2:end).*Thcsim(:, :, 2:end);

time                = 2; 

Wtemp               = Wcsim(:, :, time);                      % only state variables
Atemp               = Acsim(:, :, time); 
LTV                 = Ocsim(:, :, time).*Thcsim(:, :, time); 
Htemp               = Hcsim(:, :, time); 
LY                  = Atemp./Ysim(:, :, time); 
Sh                  = 1 - Atemp./Wtemp; 
Agetemp             = Agesim(:, :, time)/4 + 25; 
Ytemp               = Ysim(:, :, time); 

refin               = Dcsim(:, :, time) == 4 & Hcsim(:, :, time) > 0; 
owner               = Hcsim(:, :, time) > 0; 

fprintf('\n');
fprintf('Characteristics of Refinancers With Shock\n');
fprintf('\n');
fprintf('All, Refinance, Dont Refinance\n');

fprintf('\n');

fprintf('\n');
fprintf('Mean Liquid Assets           = %9.2f %9.2f %9.2f \n',  [mean(Atemp(owner)),    mean(Atemp(owner & refin)),    mean(Atemp(owner & ~refin))]);
fprintf('Mean Income                  = %9.2f %9.2f %9.2f \n',  [mean(Ytemp(owner)),    mean(Ytemp(owner & refin)),    mean(Ytemp(owner & ~refin))]);
fprintf('Mean Liquid Asset to Income  = %9.2f %9.2f %9.2f \n',  [mean(LY(owner)),       mean(LY(owner & refin)),       mean(LY(owner & ~refin))]);
fprintf('Mean Share Housing Wealth    = %9.2f %9.2f %9.2f \n',  [mean(Sh(owner)),       mean(Sh(owner & refin)),       mean(Sh(owner & ~refin))]);
fprintf('Mean Wealth                  = %9.2f %9.2f %9.2f \n',  [mean(Wtemp(owner)),    mean(Wtemp(owner & refin)),    mean(Wtemp(owner & ~refin))]);
fprintf('Mean LTV                     = %9.2f %9.2f %9.2f \n',  [mean(LTV(owner)),      mean(LTV(owner & refin)),      mean(LTV(owner & ~refin))]);
fprintf('Mean House                   = %9.2f %9.2f %9.2f \n',  [mean(Htemp(owner)),    mean(Htemp(owner & refin)),    mean(Htemp(owner & ~refin))]);
fprintf('Mean Age                     = %9.2f %9.2f %9.2f \n',  [mean(Agetemp(owner)),  mean(Agetemp(owner & refin)),  mean(Agetemp(owner & ~refin))]);

fprintf('\n');
fprintf('\n');


% MPC out of transfer in Ganong-Noel Experiment


time     = 2; 
    
Transfer = (p.mbargrid(p.nr) - p.mbargrid(Rcsim(:, :, time))).*Thcsim(:, :, time).*p.Pgrid(Rcsim(:,:,time)).*Hcsim(:,:,time).*(Dcsim(:, :, time) == 5).*(Osim(:,:,time) > 0); 

dC       = (Ccsim(:, :, time) - p.phi^(1 + 1/p.gamma)*Ccsim(:, :, time).^(-p.sigma/p.gamma) - (Csim(:, :, time)  - p.phi^(1 + 1/p.gamma)*Csim(:, :, time).^(-p.sigma/p.gamma))); 
dA       = Acsim(:, :, time + 1) - Asim(:, :, time + 1); 

htm      = Acsim(:, :, time + 1) <= 1/6.5*Ysim(:,:,time); 

gains    = Vcsim(:, :, time) - Vsim(:, :, time); 

good     = Transfer > 0 & Dcsim(:, :, time) == 5  & Dsim(:, :, time) == 5;


MPC      = dC(good)./Transfer(good); 
gains    = gains(good); 
htm      = htm(good); 

fbenefit      = mean(gains > 0); 
fprintf('\n')

fprintf('Fraction who benefit                             = %9.2f             \n',  fbenefit);

fprintf('\n')
fprintf('MPC, mean                                        = %9.2f %9.2f %9.2f \n',  [mean(MPC(gains > 0)),          mean(MPC(gains > 0 & htm)),          mean(MPC(gains > 0 & ~htm))         ]);
fprintf('MPC, 10th pctile                                 = %9.2f %9.2f %9.2f \n',  [prctile(MPC(gains > 0),   10), prctile(MPC(gains > 0 & htm),   10), prctile(MPC(gains > 0 & ~htm),   10)]);
fprintf('MPC, 25th pctile                                 = %9.2f %9.2f %9.2f \n',  [prctile(MPC(gains > 0),   25), prctile(MPC(gains > 0 & htm),   25), prctile(MPC(gains > 0 & ~htm),   25)]);
fprintf('MPC, 50th pctile                                 = %9.2f %9.2f %9.2f \n',  [prctile(MPC(gains > 0),   50), prctile(MPC(gains > 0 & htm),   50), prctile(MPC(gains > 0 & ~htm),   50)]);
fprintf('MPC, 75th pctile                                 = %9.2f %9.2f %9.2f \n',  [prctile(MPC(gains > 0),   75), prctile(MPC(gains > 0 & htm),   75), prctile(MPC(gains > 0 & ~htm),   75)]);
fprintf('MPC, 90th pctile                                 = %9.2f %9.2f %9.2f \n',  [prctile(MPC(gains > 0),   90), prctile(MPC(gains > 0 & htm),   90), prctile(MPC(gains > 0 & ~htm),   90)]);

