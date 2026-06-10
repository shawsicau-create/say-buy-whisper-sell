function [Dist, Aprime] = savings(C, s, p, Rt, type, bnd)   

% gives A' for a given level of consumption

if strcmp(type, 'h') 
   
    Aprime = s(:,1) + p.phi^(1 + 1/p.gamma).*C.^(-p.sigma/p.gamma) - C; 
    
else
    
    Aprime = s(:,1) + p.phi^(1 + 1/p.gamma).*C.^(-p.sigma/p.gamma) - (1 + p.alpha^(1/p.sigma)*Rt^(1 - 1/p.sigma)).*C; 
    
end

if nargin == 6
    
    Dist = Aprime - bnd; 

else
    
    Dist = [];

end