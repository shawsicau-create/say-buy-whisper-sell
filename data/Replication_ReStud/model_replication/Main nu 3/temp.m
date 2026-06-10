
% plot value of liquidity as a function of various characteristics

% 1. Loan to Value

LTV   = Thsim(:, :, 2).*Osim(:,:,2); 

ltv   = LTV(ind); 

good  = ltv == 0; 

bins  = [0; prctile(ltv(ltv > 0), (20:20:100)')]; 

xx    = zeros(numel(bins), 1); 
yy    = xx; 

xx(1) = median(ltv(good));
yy(1) = mean(max(0, gains(good)));


for i = 1 : numel(bins) - 1
   
    good    = ltv > bins(i) & ltv <= bins(i + 1);
    
    xx(i+1) = median(ltv(good));
    yy(i+1) = mean(max(0, gains(good)));
    
end

lasst = Asim(:, :, 2)./(Asim(:,:,2) + (1 - Thsim(:, :, 2).*Osim(:, :, 2)).*Hsim(:,:,2));      % liquid assets to wealth
logy  = log(Ysim(:, :, 2));                                                                   % log income

pti   = p.mbar*Thsim(:, :, 2).*Hsim(:, :, 2)./Ysim(:,:,2); 
lasst = lasst(ind); 
logy  = logy(ind);

% Can we run some regressions? 

yy          = min(1, max(0, gains)); 
xx          = [ltv, lasst, logy];

% randomly permute

shuff       = randperm(numel(yy)); 

yy          = yy(shuff); 
xx          = xx(shuff, :);

yy          = yy(1 : 250000); 
xx          = xx(1 : 250000, :);

nnet.type   = 0;                                   % output layer: 0 if f(x) in -inf, +inf, 1 if f(x) in 0, 1
nnet.lambda = 0.1;                                 % regularization parameter
nnet.lsize  = [size(xx, 2), 25, 1];                % inner matrix: number of neurons in each hidden layer                   
nnet.afunc  = {'tanhh'};                           % activation functions in each inner layer

tic
theta       = fitreg([], xx, yy, nnet, 'knitro');
toc
yyhat       = predict(theta, xx, nnet);

Rsq         = 1 - mean((yy - yyhat).^2)/mean((yy - mean(yy)).^2);


% Compare to Matlab

net           = fitnet([25], 'trainlm');

net.trainParam.epochs      = 200;

net.layers{1}.transferFcn  = 'tansig';                             % for alternative functions

net.divideParam.trainRatio = 0.70;
net.divideParam.valRatio   = 0.15;
net.divideParam.testRatio  = 0.15;

net.inputs{1}.processFcns  = {};                    % don't normalize
net.outputs{2}.processFcns = {};                    % don't normalize

%net           = configure(net, xx', yy');
%net           = setwb(net, theta);

tic
net           = train(net, xx', yy', 'useParallel','yes','showResources','yes');
toc

yyhat2        = net(xx')';
        
theta2        = getwb(net);

Rsq2          = 1 - mean((yy - yyhat2).^2)/mean((yy - mean(yy)).^2);

fprintf('\n %6.4f %6.4f \n', [Rsq Rsq2]);

% plot

xnode  = gridmake(nodeunif(100, 0, p.thetam), median(xx(:,2)), median(xx(:,3))); 
ynode  = predict(theta, xnode, nnet);
ynode2 = net(xnode')';

figure(5)
subplot(2,2,1)

plot(xnode(:,1), [ynode, ynode2]); 

[xxmed, yymed] = binned_plot(xx(:,1), yy, 10);

hold on
scatter(xxmed, yymed, 150, 'filled')

subplot(2,2,2)

xnode  = gridmake(median(xx(:,1)), nodeunif(100, prctile(xx(:,2), 1), prctile(xx(:,2), 99)), median(xx(:,3))); 
ynode  = predict(theta, xnode, nnet);
ynode2 = net(xnode')';

plot(xnode(:,2), [ynode, ynode2]); 

[xxmed, yymed] = binned_plot(xx(:,2), yy, 10);

hold on
scatter(xxmed, yymed, 150, 'filled')


subplot(2,2,3)

xnode  = gridmake(median(xx(:,1)), median(xx(:,2)),  nodeunif(100, prctile(xx(:,3), 1), prctile(xx(:,3), 99))); 
ynode  = predict(theta, xnode, nnet);
ynode2 = net(xnode')';

plot(xnode(:,3), [ynode, ynode2]); 

[xxmed, yymed] = binned_plot(xx(:,3), yy, 10);

hold on
scatter(xxmed, yymed, 150, 'filled')