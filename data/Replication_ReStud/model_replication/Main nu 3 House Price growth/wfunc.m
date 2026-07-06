function v  = wfunc(c, s, ind2, EV, p, Rt, type)


[~, aprime] = savings(c, s, p, Rt, type);


if strcmp(type, 'h') 

v           = c.^(1 - p.sigma)/(1 - p.sigma) + p.alpha*s(:,4).^(1 - p.sigma)/(1 - p.sigma) - ...
              p.phi^(1 + 1/p.gamma)/(1 + p.gamma)*c.^(-p.sigma*(1 + 1/p.gamma)) + p.beta*EV(aprime, ind2);
              
else
    
v           = (1 + p.alpha^(1/p.sigma)*Rt^(1 - 1/p.sigma))*c.^(1 - p.sigma)/(1 - p.sigma) - ...
              p.phi^(1 + 1/p.gamma)/(1 + p.gamma)*c.^(-p.sigma*(1 + 1/p.gamma)) + p.beta*EV(aprime, ind2);
    
end


