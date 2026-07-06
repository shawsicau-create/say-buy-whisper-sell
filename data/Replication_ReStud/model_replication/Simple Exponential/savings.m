function [Dist, Aprime] = savings(C, s, p, bnd)   


Aprime = s(:,1) + p.phi^(1 + 1/p.gamma).*C.^(-p.sigma/p.gamma) - C;    % gives A' for a given level of consumption

    
if nargin == 4
    
    Dist = Aprime - bnd; 

else
    
    Dist = [];

end