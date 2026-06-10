
close all

t        = 185; 

EVh      = griddedInterpolant({p.agrid, (1: 1:p.no*p.nt*p.nh*p.nz)'},  reshape(vbarh(:, t + 1), p.na, p.no*p.nt*p.nh*p.nz), intmeth, 'linear');

Whinterp = griddedInterpolant({p.lgrid, (1: 1: p.no*p.nt*p.nh*p.nz)'}, reshape(wh(:, t), p.nl, p.no*p.nt*p.nh*p.nz), intmeth, 'linear'); 
Wrinterp = griddedInterpolant({p.lgrid, (1: 1:                p.nz)'}, reshape(wr(:, t), p.nl,                p.nz), intmeth, 'linear');


N        = 100; 
 
oind     = p.no;    onow = oind*ones(N, 1); 

tind     = 5;                           tnow = tind*ones(N, 1); 
hind     = 2;                           hnow = hind*ones(N, 1); 
zind     = 3;                           znow = zind*ones(N, 1); 

ind2     = sub2ind([p.no, p.nt, p.nh, p.nz], onow, tnow, hnow, znow);  

state    = gridmake(nodeunif(N, 0, 2), p.ogrid(oind), p.tgrid(tind), p.hgrid(hind), p.zgrid(zind)); 

cmin     = bisect('savings', 1e-13, 1e5, state(:,1), p, 'h', amax);  
cmax     = bisect('savings', 1e-13, 1e5, state(:,1), p, 'h', amin);  

C        = solve_golden('wfunc', cmin, cmax, state, ind2, EVh, p, 'h');

[~, Aprime] = savings(C, state, p, 'h');


figure(1)

subplot(1, 2, 1)
plot(state(:, 1), C);

title('consumption', 'Interpreter', 'Latex');
xlabel('$l$', 'Interpreter', 'Latex');
set(gca, 'ygrid', 'on')

subplot(1, 2, 2)
plot(state(:, 1), Aprime);

title('$a^{\prime}$', 'Interpreter', 'Latex');
xlabel('$l$', 'Interpreter', 'Latex');
set(gca, 'ygrid', 'on')




% Housing Choice

eind     = 2; 

state    = gridmake(nodeunif(N, amin, 5), p.ogrid(oind), p.tgrid(tind), p.hgrid(hind), p.zgrid(zind), p.egrid(eind));

Y        = p.lambdat(t)*p.zgrid(zind)*p.egrid(eind);
A        = state(:,1); 

[Lall, omegaall, thetaall, hall, v, pall, vall] = solveh(state, Whinterp, Wrinterp, p, p.thetay(t), 'h', A, Y, znow, hnow, tnow);



figure(2)

subplot(2, 3, 1)
plot(A, pall);
title('prob. each choice', 'Interpreter', 'Latex')
xlabel('$a$', 'Interpreter', 'Latex');
set(gca, 'ygrid', 'on')
h     = legend('1', '2', '3', '4', '5');

subplot(2, 3, 2)
plot(A, Lall);
title('liquidity','Interpreter', 'Latex')
xlabel('$a$', 'Interpreter', 'Latex');
set(gca, 'ygrid', 'on')
h     = legend('1', '2', '3', '4', '5');

subplot(2, 3, 3)
plot(A, omegaall);
title('$\omega^{\prime}$','Interpreter', 'Latex')
xlabel('$a$', 'Interpreter', 'Latex');
set(gca, 'ygrid', 'on')
h     = legend('1', '2', '3', '4', '5');

subplot(2, 3, 4)
plot(A, thetaall);
title('$\bar{\theta}^{\prime}$','Interpreter', 'Latex')
xlabel('$a$', 'Interpreter', 'Latex');
set(gca, 'ygrid', 'on')
h     = legend('1', '2', '3', '4', '5');


subplot(2, 3, 5)
plot(A, hall);
title('$h^{\prime}$','Interpreter', 'Latex')
xlabel('$a$', 'Interpreter', 'Latex');
set(gca, 'ygrid', 'on')
h     = legend('1', '2', '3', '4', '5');


subplot(2, 3, 6)
plot(A, vall);
title('value','Interpreter', 'Latex')
xlabel('$a$', 'Interpreter', 'Latex');
set(gca, 'ygrid', 'on')
h     = legend('1', '2', '3', '4', '5');

