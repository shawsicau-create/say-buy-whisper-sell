function [v, pall, vall, Lall, thetaall] = solveh(s, Winterp, p)

 ns      = size(s, 1); 
    

 vall     = zeros(ns, 2); 
 Lall     = zeros(ns, 2);
 thetaall = zeros(ns, 2); 
    
    for branch =  1 : 1 : 2
        

        if branch == 1                                                                              % Refinance mortgage
           
         thetaall(:, branch) = p.thetam*ones(ns, 1);

             Lall(:, branch) = s(:,1) - (1 + p.rm)*s(:, 2)*p.hbar + thetaall(:, branch)*p.hbar - p.F;
          
             vall(:, branch) = Winterp(Lall(:, branch), thetaall(:, branch)); 
        
            
        elseif branch == 2                                                                           % Stay inactive
            
         thetaall(:, branch) = max((1 + p.rm)*s(:,2) - p.mbar, 0);
  
             Lall(:, branch) = s(:,1) - (1 + p.rm)*s(:, 2)*p.hbar + thetaall(:, branch)*p.hbar;
                       
             vall(:, branch) = Winterp(Lall(:, branch), thetaall(:, branch)); 

        end
        
        
    end
            
 
 pb         = (1 - exp(-p.nu*max(vall(:,1) - vall(:,2), 0))).*(vall(:,1) >= vall(:,2));     
    
 v          = vall(:,2).*(vall(:,1) < vall(:,2)) + (vall(:,1) - pb/p.nu).*(vall(:,1) >= vall(:,2)); 
   
 pall       = [pb, 1 - pb];
 
 

        
    
    
    