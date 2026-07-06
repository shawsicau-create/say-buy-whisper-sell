
close all

% Inaction Region

figure(1)

[~, pall]           = solveh(sv, Winterp, p);

data = [sv, pall(:,1)]; 
data = data(data(:,1) <= 3, :); 
n1   = numel(unique(data(:,1)));
n2   = numel(unique(data(:,2)));

surf(reshape(data(:,1), n1, n2), reshape(data(:,2), n1, n2), reshape(data(:,3), n1, n2)); colorbar 

xlabel('$w$', 'Interpreter', 'Latex');
ylabel('$\theta$', 'Interpreter', 'Latex');
title('probability refinance', 'Interpreter', 'Latex');
xlim([0, 3])


state = gridmake(nodeunif(100, 0.5, 4.5), 0.50); 

[v, pall, vall, Lall, thetaall] = solveh(state, Winterp, p);

call         = zeros(size(pall)); 
aprimeall    = zeros(size(pall)); 

for i = 1 : 2

cmax         = bisect('savings', 1e-13, 1e5, Lall(:, i), p, amin);     % c that implies a' = amin
cmin         = bisect('savings', 1e-13, 1e5, Lall(:, i), p, amax);     % c that implies a' = amax

call(:,i)    = solve_golden('wfunc', cmin, cmax, [Lall(:,i), thetaall(:,i)], EV, p);

[~, aprimeall(:,i)]  = savings(call(:,i), [Lall(:,i), thetaall(:,i)], p);

end

%{
figure(2)

subplot(2, 3, 1)
plot(state(:,1), pall(:,1));
set(gca, 'ygrid', 'on')
xlabel('$w$', 'Interpreter', 'Latex');
title('probability refinance', 'Interpreter', 'Latex');

subplot(2, 3, 2)
plot(state(:,1), Lall);
set(gca, 'ygrid', 'on')
xlabel('$w$', 'Interpreter', 'Latex');
title('$l$', 'Interpreter', 'Latex');
legend('refinance', 'dont refinance')

subplot(2, 3, 3)
plot(state(:,1), thetaall);
set(gca, 'ygrid', 'on')
xlabel('$w$', 'Interpreter', 'Latex');
title('$\theta^{\prime}$', 'Interpreter', 'Latex');

subplot(2, 3, 4)
plot(state(:,1), call);
set(gca, 'ygrid', 'on')
xlabel('$w$', 'Interpreter', 'Latex');
title('$c$', 'Interpreter', 'Latex');

subplot(2, 3, 5)
plot(state(:,1), aprimeall);
set(gca, 'ygrid', 'on')
xlabel('$w$', 'Interpreter', 'Latex');
title('$a^{\prime}$', 'Interpreter', 'Latex');


subplot(2, 3, 6)
plot(state(:,1), [vall, v]);
set(gca, 'ygrid', 'on')
xlabel('$w$', 'Interpreter', 'Latex');
title('values', 'Interpreter', 'Latex');
legend('refinance', 'dont refinance', 'envelope')
%}

figure(1)

subplot(2, 2, 1)
plot(state(:,1), [vall(:,1) - vall(:,2)]);
set(gca, 'ygrid', 'on')
xlabel('cash on hand', 'Interpreter', 'Latex');
title('$V^{R} - V^{N}$', 'Interpreter', 'Latex');

subplot(2, 2, 2)
plot(state(:,1), [call]);
set(gca, 'ygrid', 'on')
xlabel('cash on hand', 'Interpreter', 'Latex');
title('$c$', 'Interpreter', 'Latex');
legend('refinance', 'do not refinance')

subplot(2, 2, 3)
plot(state(:,1), [aprimeall]);
set(gca, 'ygrid', 'on')
xlabel('cash on hand', 'Interpreter', 'Latex');
title('$a^{\prime}$', 'Interpreter', 'Latex');

subplot(2, 2, 4)
plot(state(:,1), pall(:,1));
set(gca, 'ygrid', 'on')
xlabel('cash on hand', 'Interpreter', 'Latex');
title('probability of refinancing', 'Interpreter', 'Latex');

%{
figure(3)

state = gridmake(nodeunif(100, lmin, 3), 0.5); 

cmax  = bisect('savings', 1e-13, 1e5, state(:,1), p, amin);     % c that implies a' = amin
cmin  = bisect('savings', 1e-13, 1e5, state(:,1), p, amax);     % c that implies a' = amax

c     = solve_golden('wfunc', cmin, cmax, state, EV, p);

[~, aprime]  = savings(c, state, p);


subplot(1, 2, 1)
plot(state(:,1), c);
set(gca, 'ygrid', 'on')
xlabel('$l$', 'Interpreter', 'Latex');
title('$c$', 'Interpreter', 'Latex');

subplot(1, 2, 2)
plot(state(:,1), aprime);
set(gca, 'ygrid', 'on')
xlabel('$w$', 'Interpreter', 'Latex');
title('$a^{\prime}$', 'Interpreter', 'Latex');
%}

figure(2)

gain       = nodeunif(1000, -5000, 20000); 

factor     = 36500; % scaling factor to convert units in the model into u'(c) times 12896 in the data

plot(gain, [(1 - exp(-3*max(gain/factor, 0))).*(gain >=0), ...
            (1 - exp(-10*max(gain/factor, 0))).*(gain >=0), ...
            (1 - exp(-10000*max(gain/factor, 0))).*(gain >=0)]) 

title('probability of refinancing', 'Interpreter', 'Latex');
xlabel('welfare gains from refinancing', 'Interpreter', 'Latex');
legend('$\nu = 1/3$', '$\nu = 1/10$', '$\nu = 0$');