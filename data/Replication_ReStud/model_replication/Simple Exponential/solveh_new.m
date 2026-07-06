function [v, pall, vall, Lall, thetaall] = solveh_new(s, Winterp, p)

 ns      = size(s, 1); 
    

 vall     = zeros(ns, 2); 
 Lall     = zeros(ns, 2);
 thetaall = zeros(ns, 2); 
    
    for branch =  1 : 1 : 2
        

        if branch == 1                                                                              % Refinance mortgage
           
         thetaall(:, branch) = p.thetam*ones(ns, 1);

            Lall(:, branch)  = s(:,1) - (1 + p.rmgrid(s(:,3))).*p.Pgrid(s(:,3)).*s(:, 2)*p.hbar + thetaall(:, branch).*p.Pgrid(p.nr)*p.hbar - p.F;
          
             vall(:, branch) = Winterp(Lall(:, branch), thetaall(:, branch), p.nr*ones(ns, 1)) - p.chi; 
        
            
        elseif branch == 2                                                                           % Stay inactive
            
             mbar            = p.rmgrid(s(:, 3))./(1 - (1 + p.rmgrid(s(:, 3))).^(-p.D))*p.thetam;

         thetaall(:, branch) = max((1 + p.rmgrid(s(:,3))).*s(:,2) - mbar, 0);
  
             Lall(:, branch) = s(:,1) - (1 + p.rmgrid(s(:,3))).*p.Pgrid(s(:,3)).*s(:, 2)*p.hbar + thetaall(:, branch).*p.Pgrid(s(:,3)).*p.hbar;
                       
             vall(:, branch) = Winterp(Lall(:, branch), thetaall(:, branch), s(:,3)); 

        end
        
        
    end
            
 
 pb         = (1 - exp(-p.nu*max(vall(:,1) - vall(:,2), 0))).*(vall(:,1) >= vall(:,2));     
    
 v          = vall(:,2).*(vall(:,1) < vall(:,2)) + (vall(:,1) - pb/p.nu).*(vall(:,1) >= vall(:,2)); 
   
 pall       = [pb, 1 - pb];
 
 

     
    
    