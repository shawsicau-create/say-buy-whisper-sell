function v  = wfunc_new(c, s, EV, p)


[~, aprime] = savings(c, s, p);

v           = c.^(1 - p.sigma)/(1 - p.sigma) - ...
              p.phi^(1 + 1/p.gamma)/(1 + p.gamma)*c.^(-p.sigma*(1 + 1/p.gamma)) + p.beta*EV(aprime, s(:,2), s(:,3));
              



