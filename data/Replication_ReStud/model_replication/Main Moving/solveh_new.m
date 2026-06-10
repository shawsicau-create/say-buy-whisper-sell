function [Lall, omegaall, thetaall, hall, v, pall, vall] = solveh_new(s, Whinterp, Wrinterp, p, pti, type, At, Y, znow, hnow, tnow, rnow)

    ns    = size(s, 1); 
    

    if strcmp(type, 'r') 
   
    Lall       = zeros(ns, 3); 
    omegaall   = zeros(ns, 3); 
    thetaall   = zeros(ns, 3);
    hall       = zeros(ns, 3); 
    vall       = zeros(ns, 3);

    
    for branch =  1 : 1 : 3
            
        if branch == 1                                                           % Remain Renter
            
            
            Lall(:, branch)     = At + Y;               
            
            omegaall(:, branch) = 0;
            thetaall(:, branch) = 0; 
            hall(:, branch)     = 0; 
        
            vall(:, branch)     = Wrinterp(Lall(:, branch), znow); 

            
        elseif branch == 2                                                       % Purchase New Home Without Mortgage
           
            
            vtemp = zeros(ns, p.nh) - 1e12; 

            Ltemp = zeros(ns, p.nh);
        
            Cash  = At + Y;
            
            for i = 1 : p.nh     
            
                Ltemp(:,i)      = Cash - p.Pgrid(p.nr)*p.hgrid(i);                            % liquidity after housing choice

                ind2            = (znow - 1)*p.no*p.nt*p.nh*p.nr + (p.nr - 1)*p.no*p.nt*p.nh + (i - 1)*p.no*p.nt + (1 - 1) *p.no + 1; 
                
                good            = Ltemp(:, i) >= p.lgrid(1);                    % avoid extrapolation
                
                if any(good)
                
                    vtemp(good, i)  = Whinterp(Ltemp(good, i), ind2(good));
                 
                end
                
            end
            
        
            [vall(:, branch), htemp] = max(vtemp, [], 2);        
        
            hind                     = sub2ind([ns, p.nh], (1 : 1 : ns)', htemp); 
        
            Lall(:, branch)          = Ltemp(hind);
        
            omegaall(:, branch)      = 0; 
            thetaall(:, branch)      = 0; 
            hall(:, branch)          = p.hgrid(htemp);
            
        
        elseif branch == 3       % Purchase New Home with Mortgage
        
            
            % create a grid of possible houses and initial LTVs
            
            ht    = gridmake((1 : 1 : p.nh)', (1 : 1 : p.nt)'); 
            
            vtemp = zeros(ns, p.nh*p.nt) - 1e12; 

            Ltemp = zeros(ns, p.nh*p.nt);
        
            Cash  = At + Y; 
            
            for i = 1 : p.nh*p.nt     
                
                ttilde          = (p.tgrid(ht(i, 2)) - p.F0m/(p.Pgrid(p.nr)*p.hgrid(ht(i, 1))))/(1 + p.F1m);

                Ltemp(:, i)     = Cash - (1 - ttilde).*p.Pgrid(p.nr).*p.hgrid(ht(i, 1));           % liquidity after housing choice

                ind2            = (znow - 1)*p.no*p.nt*p.nh*p.nr + (p.nr - 1)*p.no*p.nt*p.nh + (ht(i, 1) - 1)*p.no*p.nt + (ht(i, 2) - 1) *p.no + p.no; 
              
                good            = (ttilde <= min(p.thetam, pti*Y/p.mbargrid(p.nr)/(p.Pgrid(p.nr)*p.hgrid(ht(i, 1))))) & (Ltemp(:,i) > p.lgrid(1));
              
                if any(good)
                    
                    vtemp(good, i)  = Whinterp(Ltemp(good, i), ind2(good)); 

                end
                
            end
            
            
            [vall(:, branch), htemp]  = max(vtemp, [], 2);        
   
            hind                      = sub2ind([ns, p.nh*p.nt], (1 : 1 : ns)', htemp); 
        
            Lall(:, branch)           = Ltemp(hind);

            omegaall(:, branch)       = 1; 
            thetaall(:, branch)       = p.tgrid(ht(htemp, 2));
            hall(:, branch)           = p.hgrid(ht(htemp, 1));
            
            
       end
    end
    
    
     % Compute pall and v
    
    [vn, in]    = max(vall(:, 1 : 2), [], 2); 
    vb          = vall(:,3); 
        
    pb          = (1 - exp(-p.nu*max(vb - vn, 0))).*(vb >= vn);   % avoid NaN

    pall        = zeros(ns, 3); 
    
    pall(:, 1)  = (1 - p.rr)*(1 - pb).*(in == 1)    + p.rr;                                 % no choice but to remain renter with p.rr
    pall(:, 2)  = (1 - p.rr)*(1 - pb).*(in == 2);
    pall(:, 3)  = (1 - p.rr)*pb; 

    v           = (1 - p.rr)*(vn.*(vb < vn) + (vb - pb/p.nu).*(vb >= vn)) + p.rr*vall(:,1); 
    
    
else
    
    Lall       = zeros(ns, 5); 
    omegaall   = zeros(ns, 5); 
    thetaall   = zeros(ns, 5);
    hall       = zeros(ns, 5); 
    vall       = zeros(ns, 5);            
    
    for branch =  1 : 1 : 5
        
        if branch == 1                                                                                                    % Switch to Renting
          
            Lall(:, branch)  = At + Y + (1 - p.Fs)*p.Pgrid(p.nr)*s(:,4) - (1 + p.rmgrid(s(:,5))).*p.Pgrid(s(:,5)).*s(:,2).*s(:,3).*s(:,4);                   % liquidity after housing choice
            
            omegaall(:, branch) = 0;
            thetaall(:, branch) = 0; 
            hall(:, branch)     = 0; 
        
            vall(:, branch)     = Wrinterp(Lall(:, branch), znow); 
            
            
        elseif branch == 2                              % Purchase home without mortgage
            
            vtemp = zeros(ns, p.nh) - 1e12; 

            Ltemp = zeros(ns, p.nh);
        
            Cash  = At + Y + (1 - p.Fs)*p.Pgrid(p.nr)*s(:,4) - (1 + p.rmgrid(s(:,5))).*p.Pgrid(s(:,5)).*s(:,2).*s(:,3).*s(:,4);
        
            for i = 1 : p.nh     
            
                Ltemp(:,i) = Cash - p.Pgrid(p.nr)*p.hgrid(i);                                              % liquidity after housing choice
               
                ind2       = (znow - 1)*p.no*p.nt*p.nh*p.nr + (p.nr - 1)*p.no*p.nt*p.nh + (i - 1)*p.no*p.nt + (1 - 1) *p.no + 1; 
                
                good       = Ltemp(:, i) >= p.lgrid(1);                                       % avoid extrapolation

                if any(good)
                
                    vtemp(good, i)  = Whinterp(Ltemp(good, i), ind2(good));
                 
                end
            
            end
            
            
            [vall(:, branch), htemp] = max(vtemp, [], 2);        
        
            hind                     = sub2ind([ns, p.nh], (1 : 1 : ns)', htemp); 
        
            Lall(:, branch)          = Ltemp(hind);
        
            omegaall(:, branch)      = 0; 
            thetaall(:, branch)      = 0; 
            hall(:, branch)          = p.hgrid(htemp);
            
                        
        elseif branch == 3                                                                      % Purchase home with mortgage
          
            ht    = gridmake((1 : 1 : p.nh)', (1 : 1 : p.nt)'); 
            
            vtemp = zeros(ns, p.nh*p.nt) - 1e12; 

            Ltemp = zeros(ns, p.nh*p.nt);
        
            Cash  = At + Y  + (1 - p.Fs)*p.Pgrid(p.nr)*s(:,4)  - (1 + p.rmgrid(s(:,5))).*p.Pgrid(s(:,5)).*s(:,2).*s(:,3).*s(:,4);

            for i = 1 : p.nh*p.nt     
                
                ttilde          = (p.tgrid(ht(i, 2)) - p.F0m/(p.Pgrid(p.nr)*p.hgrid(ht(i, 1))))/(1 + p.F1m);

                Ltemp(:, i)     =  Cash - (1 - ttilde).*p.Pgrid(p.nr)*p.hgrid(ht(i, 1));           

                good            = (ttilde <= min(p.thetam, pti*Y/p.mbargrid(p.nr)/(p.Pgrid(p.nr)*p.hgrid(ht(i, 1))))) & Ltemp(:, i) >= p.lgrid(1);
                
                ind2            = (znow - 1)*p.no*p.nt*p.nh*p.nr + (p.nr - 1)*p.no*p.nt*p.nh + (ht(i, 1) - 1)*p.no*p.nt + (ht(i, 2) - 1) *p.no + p.no; 

                if any(good)
                    
                    vtemp(good, i)  = Whinterp(Ltemp(good, i), ind2(good)); 

                end
                
            end

            [vall(:, branch), htemp]  = max(vtemp, [], 2);        
   
            hind                      = sub2ind([ns, p.nh*p.nt], (1 : 1 : ns)', htemp); 
        
            Lall(:, branch)           = Ltemp(hind);

            omegaall(:, branch)       = 1; 
            thetaall(:, branch)       = p.tgrid(ht(htemp, 2));
            hall(:, branch)           = p.hgrid(ht(htemp, 1));
            
            
        elseif branch == 4                                                                              % Refinance mortgage
            
           
            vtemp           = zeros(ns, p.nt) - 1e12; 
            Ltemp           = zeros(ns, p.nt);

            Cash            = At + Y - (1 + p.rmgrid(s(:,5))).*p.Pgrid(s(:,5)).*s(:,2).*s(:,3).*s(:,4);
            
               for i = 1 : p.nt     
                
                  ttilde      = (p.tgrid(i) - p.F0m./(p.Pgrid(p.nr)*s(:,4)))/(1 + p.F1m);

                  Ltemp(:, i) = Cash + ttilde.*p.Pgrid(p.nr).*s(:, 4);  

                  good        = (ttilde <= min(p.thetam, pti*Y/p.mbargrid(p.nr)./(p.Pgrid(p.nr)*s(:,4)))) & Ltemp(:, i) >= p.lgrid(1);
                  
                  ind2        = (znow - 1)*p.no*p.nt*p.nh*p.nr + (p.nr - 1)*p.no*p.nt*p.nh + (hnow - 1)*p.no*p.nt + (i - 1)*p.no + p.no; 

                  if any(good)
                       
                     vtemp(good, i)   = Whinterp(Ltemp(good, i), ind2(good));
                     
                  end
                
               end
                   
            [vall(:, branch), htemp]  = max(vtemp, [], 2);        

            hind                      = sub2ind([ns, p.nt], (1 : 1 : ns)', htemp); 
  
            Lall(:, branch)           = Ltemp(hind);
   
            omegaall(:, branch)       = 1; 
            thetaall(:, branch)       = p.tgrid(htemp); 
            hall(:, branch)           = s(:, 4); 
        
                                                      
        elseif branch == 5                                                                              % Stay inactive
            
            vtemp           = zeros(ns, p.no + 1) - 1e12; 
            Ltemp           = zeros(ns, p.no + 1);

            % Pay more than required
            
            Cash  = At + Y - (1 + p.rmgrid(s(:,5))).*p.Pgrid(s(:,5)).*s(:,2).*s(:,3).*s(:,4);
            
            for i = 1 : p.no
            
            Ltemp(:, i)     = Cash + p.ogrid(i).*p.Pgrid(s(:,5)).*s(:,3).*s(:,4);
           
            good            = (p.ogrid(i) < max((1 + p.rmgrid(s(:,5))).*s(:,2) - p.mbargrid(s(:,5)), 0)) & (Ltemp(:, i) >= p.lgrid(1));

            ind2            = (znow - 1)*p.no*p.nt*p.nh*p.nr + (rnow - 1)*p.no*p.nt*p.nh + (hnow - 1)*p.no*p.nt + (tnow - 1)*p.no + i; 

              if any(good)
               
                vtemp(good, i)  = Whinterp(Ltemp(good, i), ind2(good));
                
              end
                
            end
            
                        
            % Pay minimum required
            
            otemp              = max((1 + p.rmgrid(s(:,5))).*s(:,2) - p.mbargrid(s(:,5)), 0);        

            Ltemp(:, p.no + 1) = At + Y  - (1 + p.rmgrid(s(:,5))).*s(:,2).*s(:,3).*s(:,4).*p.Pgrid(s(:,5)) + otemp.*s(:,3).*s(:,4).*p.Pgrid(s(:,5));

            good               = (Ltemp(:, p.no + 1) >= p.lgrid(1)); 
            
            
            if any(good)
            
            % Interpolate
            
            otempind           = lookup1(p.ogrid, otemp, 3);
            
            w                  = (p.ogrid(otempind + 1) - otemp)./(p.ogrid(otempind + 1) - p.ogrid(otempind));

            ind2               = (znow - 1)*p.no*p.nt*p.nh*p.nr + (rnow - 1)*p.no*p.nt*p.nh + (hnow - 1)*p.no*p.nt + (tnow - 1)*p.no + otempind; 
            
            
            vtemp(good, p.no + 1) = w(good).*Whinterp(Ltemp(good, p.no + 1), ind2(good)); 
            
            ind2               = (znow - 1)*p.no*p.nt*p.nh*p.nr + (rnow - 1)*p.no*p.nt*p.nh + (hnow - 1)*p.no*p.nt + (tnow - 1)*p.no + otempind + 1; 
            
            vtemp(good, p.no + 1) = vtemp(good, p.no + 1) + (1 - w(good)).*Whinterp(Ltemp(good, p.no + 1), ind2(good)); 

            
            end
            
            
                    
            [vall(:, branch), htemp]  = max(vtemp, [], 2);        

            hind                      = sub2ind([ns, p.no + 1], (1 : 1 : ns)', htemp); 
  
            Lall(:, branch)           = Ltemp(hind);
   
            omegaall(htemp <= p.no, branch)       = p.ogrid(htemp(htemp <= p.no)); 
            omegaall(htemp  > p.no, branch)       = otemp(htemp > p.no); 

            thetaall(:, branch)       = p.tgrid(tnow); 
            hall(:, branch)           = s(:,4);       
            

        end 
    end
    
   % Compute pall and v
    
    [vn, in]    = max(vall(:, [1, 2, 5]), [], 2); 
    [vb, ib]    = max(vall(:, [3, 4]),    [], 2);
    
    pb          = (1 - exp(-p.nu*max(vb - vn, 0))).*(vb >= vn); 
    
    pall        = zeros(ns, 5); 
    
    pall(:, 1)  = (1 - p.hr)*(1 - pb).*(in == 1) + p.hr;       % forced into renting with p.hr 
    pall(:, 2)  = (1 - p.hr)*(1 - pb).*(in == 2);
    pall(:, 5)  = (1 - p.hr)*(1 - pb).*(in == 3); 
    pall(:, 3)  = (1 - p.hr)*      pb.*(ib == 1); 
    pall(:, 4)  = (1 - p.hr)*      pb.*(ib == 2);
    
    v           = (1 - p.hr)*(vn.*(vb < vn) + (vb - pb/p.nu).*(vb >= vn)) + p.hr*vall(:, 1); 
    
end
    
    
    
    
    