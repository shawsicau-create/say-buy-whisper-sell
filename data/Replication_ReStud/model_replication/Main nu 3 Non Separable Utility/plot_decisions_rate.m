
close all

% understand value of each option

t        = 75; 

tind     = 3; 
hind     = 5; 
rind     = 1; 
zind     = 5;
eind     = 2; 

omega    = 0.0; 

state    = gridmake(nodeunif(100, 0, 3), omega, p.tgrid(tind), p.hgrid(hind), rind, p.zgrid(zind), p.egrid(eind)); 

Whinterp = griddedInterpolant({p.lgrid, (1: 1: p.no*p.nt*p.nh*p.nr*p.nz)'},  reshape(wh(:, t), p.nl, p.no*p.nt*p.nh*p.nr*p.nz), intmeth, 'linear'); 
Wrinterp = griddedInterpolant({p.lgrid, (1: 1:                     p.nz)'},  reshape(wr(:, t), p.nl,                     p.nz), intmeth, 'linear');
 

ai       = state(:,1); 
yi       = p.lambdat(t)*state(:,6).*state(:,7);

[li, oi, thi, hi, vi, di, valli] = solveh_rm(state, Whinterp, Wrinterp, p, p.thetay(t), 'h', ai, yi, zind*ones(100, 1), hind*ones(100, 1), tind*ones(100, 1), rind*ones(100, 1));

state2   = gridmake(ai + 0.0001, omega, p.tgrid(tind), p.hgrid(hind), rind, p.zgrid(zind), p.egrid(eind)); 
ai2      = state2(:,1); 

[~, ~, ~, ~, vi2] = solveh_rm(state2, Whinterp, Wrinterp, p, p.thetay(t), 'h', ai2, yi, zind*ones(100, 1), hind*ones(100, 1), tind*ones(100, 1), rind*ones(100, 1));

vprime   = (vi2 - vi)./(ai2 - ai); 




figure(3)

subplot(1, 2, 1)
plot(ai, di);

title('discrete choice', 'Interpreter', 'Latex');
xlabel('$a$', 'Interpreter', 'Latex');
set(gca, 'ygrid', 'on')


subplot(1, 2, 2)
plot(ai, (valli(:, 1:4) - valli(:, 5))./vprime);

title('values', 'Interpreter', 'Latex');
xlabel('$a$', 'Interpreter', 'Latex');
set(gca, 'ygrid', 'on')
