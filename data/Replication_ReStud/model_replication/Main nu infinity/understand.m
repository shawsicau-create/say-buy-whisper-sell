clc
%{
ind     = 558;
initage = 150; 

dVc     = (squeeze(Vallcsim(ind, 4, initage, 1 : S) - Vallcsim(ind, 5, initage, 1 : S)))./squeeze(Ccsim(ind, initage, 1 : S).^(-p.sigma));
dV      = squeeze( Vallsim(ind, 4, initage, 1 : S) -  Vallsim(ind, 5, initage, 1 : S))./squeeze(Csim(ind, initage, 1 : S).^(-p.sigma));

Pc      = squeeze(Pallcsim(ind, 4, initage, 1 : S));
P       = squeeze( Pallsim(ind, 4, initage, 1 : S));

Ac      = squeeze(Acsim(ind,  initage, 1 : S)); 
A       = squeeze( Asim(ind,  initage, 1 : S)); 

LTVc    = squeeze(Thcsim(ind,  initage, 1 : S).*Ocsim(ind,  initage, 1 : S));
LTV     = squeeze( Thsim(ind,  initage, 1 : S).* Osim(ind,  initage, 1 : S));

Y       = squeeze(  Ysim(ind,  initage, 1 : S));

Hc      = squeeze( Hcsim(ind,  initage, 1 : S));
H       = squeeze(  Hsim(ind,  initage, 1 : S));

Cc      = squeeze( Ccsim(ind,  initage, 1 : S));
C       = squeeze(  Csim(ind,  initage, 1 : S));



Sav     = p.thetam.*H(2).*(p.mbar0 - p.mbar1);

fprintf('\n')
fprintf('\n')
fprintf('Savings if refinance in period 2: quarterly, PV at old rm = %9.3f   %9.3f \n',  [Sav, Sav*(1 - (1 + p.rm0)^(-p.D))/p.rm0]);

fprintf('\n')
fprintf('\n')
fprintf('%s      %s   \n', ['      Date', '    Gains from Refi',    '       Prob Refi',    '           Liq Asst',  '              LTV',  '           House Size',  '       Income',  '       Consumption'])
fprintf('\n')
fprintf('\n')
fprintf('\t%d      %5.2f   %5.2f      %5.2f   %5.2f      %5.2f   %5.2f      %5.2f   %5.2f      %5.2f   %5.2f     %5.2f      %5.2f   %5.2f \n', [(1 : 1 : S)', dVc, dV, Pc, P, Ac, A, LTVc, LTV, Hc, H, Y, Cc, C, ]')
fprintf('\n')
fprintf('\n')

%}

% People who absent utility cost would benefit from refinance

time   = 2;

% Absent Rate Drop

borr   = Hsim(:, :, time) > 0 & Osim(:, :, time) > 0;

good   = Hsim(:, :, time) > 0 & Osim(:, :, time) > 0 & squeeze((Vallsim(:, 4, :, time) > max(Vallsim(:, [1, 2, 3, 5], :, time), [], 2)) );

Vother = squeeze(max(Vallsim(:, [1, 2, 3, 5], :, time), [], 2));
Vrefi  = squeeze(Vallsim(:, 4, :, time));
Vgap   = (Vrefi - Vother)./Csim(:, :, time).^(-p.sigma);
Prefi  = squeeze(Pallsim(:, 4, :, time));
Refi   = squeeze(Dsim(:,  :, time) == 4);



% After Rate Drop

borrc   = Hcsim(:, :, time) > 0 & Ocsim(:, :, time) > 0;

goodc   = Hcsim(:, :, time) > 0 & Ocsim(:, :, time) > 0 & squeeze((Vallcsim(:, 4, :, time) > max(Vallcsim(:, [1, 2, 3, 5], :, time), [], 2)) );

Votherc = squeeze(max(Vallcsim(:, [1, 2, 3, 5], :, time), [], 2));
Vrefic  = squeeze(Vallcsim(:, 4, :, time));
Vgapc   = (Vrefic - Votherc)./Ccsim(:, :, time).^(-p.sigma);
Prefic  = squeeze(Pallcsim(:, 4, :, time));
Refic   = squeeze(Dcsim(:,  :, time) == 4);


fprintf('\n')
fprintf('\n')
fprintf('Table 5 \n')

fprintf('\n')
fprintf('A. Refinancing in Steady State \n')
fprintf('\n')
fprintf('monetary cost of refinancing, 2016 USD                       = %9.0f \n',    p.F0m*12896);
fprintf('fraction who would refinance absent utility cost             = %9.2f \n',    sum(good(:))/sum(borr(:)));
fprintf('average welfare gains from refinancing, 2016 USD             = %9.0f \n',    mean(Vgap(good))*12896         );
fprintf('fraction who refinance                                       = %9.2f \n',    mean(Refi(borr))         );


fprintf('\n')
fprintf('B. Refinancing After Decline in Mortgage Rate \n')
fprintf('\n')
fprintf('decline in pre-tax mortgage rate                             = %9.2f \n',    dR/(1  - 0.2391)*100);
fprintf('\n')

fprintf('fraction who would refinance absent utility cost             = %9.2f \n',    sum(goodc(:))/sum(borrc(:)));
fprintf('average welfare gains from refinancing, 2016 USD             = %9.0f \n',    mean(Vgapc(goodc))*12896);
%fprintf('Proportion of those that benefit who refinance               = %9.2f \n',    mean(Refic(goodc)));



% Naive measure of benefit from refinancing: 
% Is PV of savings (discounted at old rate) above the cost of borrowing

PVgains = Osim(:,:, time).*Thsim(:, :, time).*Hsim(:, :, time).*((p.mbar0 - p.mbar1)*(1 - (1 + p.rm0)^(-p.D))/p.rm0  - p.F1m) - p.F0m;

goodc    = PVgains > 0; 
fprintf('\n')

fprintf('fraction with positive savings from refinancing              = %9.2f\n',    sum(goodc(:))/sum(borrc(:)));
fprintf('average savings from refinancing, 2016 USD                   = %9.0f\n',    mean(PVgains(goodc))*12896);
fprintf('\n')

fprintf('fraction who refinance                                       = %9.2f\n',    mean(Refic(borrc)));
