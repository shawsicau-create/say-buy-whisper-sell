function [Dist, Aprime, H, N] = savings(C, s, p, type, bnd)   

% gives A' for a given level of consumption

if strcmp(type, 'h') 

    H      = s(:, 4); 
    N      = (C.^(-p.sigma)./(C.^(1 - p.sigma) + p.alpha*H.^(1 - p.sigma))).^(1/p.gamma)*p.phi^(1/p.gamma); 

    Aprime = s(:,1) + p.phi*N - C; 
    
else
    
    H      = (p.R/p.alpha).^(-1/p.sigma).*C; 
    N      = (C.^(-p.sigma)./(C.^(1 - p.sigma) + p.alpha*H.^(1 - p.sigma))).^(1/p.gamma)*p.phi^(1/p.gamma); 
    
    Aprime = s(:,1) + p.phi*N - C - p.R*H; 
    
end

if nargin == 5
    
    Dist = Aprime - bnd; 

else
    
    Dist = [];

end