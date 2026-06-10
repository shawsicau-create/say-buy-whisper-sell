function [Dist, Aprime] = savings(C, s, p, type, bnd)   

% gives A' for a given level of consumption

if strcmp(type, 'h') 
   
    Aprime = s(:,1) + p.phi^(1 + 1/p.gamma).*C.^(-p.sigma/p.gamma) - C; 
    
else
    
    Aprime = s(:,1) + p.phi^(1 + 1/p.gamma).*C.^(-p.sigma/p.gamma) - (1 + p.alpha^(1/p.sigma)*p.R^(1 - 1/p.sigma)).*C; 
    
end

if nargin == 5
    
    Dist = Aprime - bnd; 

else
    
    Dist = [];

end