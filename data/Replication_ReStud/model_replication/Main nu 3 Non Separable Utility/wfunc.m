function v  = wfunc(c, s, ind2, EV, p, type)


[~, aprime, h, n] = savings(c, s, p, type);



v      = 1/(1 - p.sigma)*log(c.^(1 - p.sigma) + p.alpha*h.^(1 - p.sigma)) - ...
         n.^(1 + p.gamma)/(1 + p.gamma) + p.beta*EV(aprime, ind2);
              


