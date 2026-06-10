clear;
clc;

set(groot, 'DefaultAxesLineWidth', 1.5);
set(groot, 'DefaultLineLineWidth', 4);
set(groot, 'DefaultAxesTickLabelInterpreter','latex'); 
set(groot, 'DefaultLegendInterpreter','latex');
set(groot, 'DefaultAxesFontSize',22);


sigma = 10; 

x     = nodeunif(100, 0, 1);

V1    = x; 
V2    = 0.5*x + 0.5; 


chi1  = 0; 
chi2  = 0.3; 
EV    = 1/sigma*log(exp(sigma*(V1 - chi1)) + exp(sigma*(V2 - chi2)));


plot(x, [V1, V2])


figure(1)
set(gcf,'DefaultLineLineWidth', 4);

subplot(1,2,1)
plot(x, [V1 - chi1, V2 - chi2, EV])
set(get(gcf,'CurrentAxes'),'FontSize',22,'LineWidth',2);
set(gca,'ygrid', 'on')
title('Values','Interpreter','Latex','FontSize', 22);
h = legend('max', 'gumbell');
set(h,'Interpreter','latex');
        
subplot(1,2,2)
plot(x, [V1 - chi1 > V2 - chi2, exp(sigma*(V1 - chi1))./(exp(sigma*(V1 - chi1)) + exp(sigma*(V2 - chi2)))]);
set(get(gcf,'CurrentAxes'),'FontSize',22,'LineWidth',2);
set(gca,'ygrid', 'on')
title('Choice Probability','Interpreter','Latex','FontSize', 22);
h = legend('max', 'gumbell');
set(h,'Interpreter','latex');

return

u1     = rand(50000, 1);
u2     = rand(50000, 1);

gamma  = double(eulergamma); 
mu     = -gamma/sigma; 

e1     = chi1 + mu - 1/sigma*log(-log(u1));
e2     = chi2 + mu - 1/sigma*log(-log(u2));

figure(2)
histogram(e1, 100)


P1     = mean(V1 - e1' >= V2 - e2', 2);


figure(3)
plot(x, P1, x, exp(sigma*(V1 - chi1))./(exp(sigma*(V1 - chi1)) + exp(sigma*(V2 - chi2))))