
close all

% Inaction Region

figure(1)

[~, pall]           = solveh_new(sv, Winterp, p);

data = [sv(1 : p.na*p.nt, 1 : 2), pall(1 : p.na*p.nt, 1)]; 
data = data(data(:,1) <= 3, :); 

n1   = numel(unique(data(:,1)));
n2   = numel(unique(data(:,2)));

surf(reshape(data(:,1), n1, n2), reshape(data(:,2), n1, n2), reshape(data(:,3), n1, n2)); colorbar 

xlabel('$w$', 'Interpreter', 'Latex');
ylabel('$\theta$', 'Interpreter', 'Latex');
title('probability refinance', 'Interpreter', 'Latex');
xlim([0, 3])


state = gridmake(nodeunif(100, wmin, 3), 0.7, 2); 

[v, pall, vall, Lall, thetaall] = solveh_new(state, Winterp, p);

call         = zeros(size(pall)); 
aprimeall    = zeros(size(pall)); 
sall         = [state(:,3), 2*ones(size(state, 1), 1)]; 

for i = 1 : 2

cmax         = bisect('savings', 1e-13, 1e5, Lall(:, i), p, amin);     % c that implies a' = amin
cmin         = bisect('savings', 1e-13, 1e5, Lall(:, i), p, amax);     % c that implies a' = amax

call(:,i)    = solve_golden('wfunc_new', cmin, cmax, [Lall(:,i), thetaall(:,i), sall(:,i)], EV, p);

[~, aprimeall(:,i)]  = savings(call(:,i), Lall(:,i), p);

end

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


figure(3)

state = gridmake(nodeunif(100, lmin, 3), 0.5, 1); 

cmax  = bisect('savings', 1e-13, 1e5, state(:,1), p, amin);     % c that implies a' = amin
cmin  = bisect('savings', 1e-13, 1e5, state(:,1), p, amax);     % c that implies a' = amax

c     = solve_golden('wfunc_new', cmin, cmax, state, EV, p);

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

