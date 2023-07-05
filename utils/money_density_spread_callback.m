function money_density_spread_callback(inputSlider,~,otherSlider,funct,FUNCT,myAxes)
    cla(myAxes)
    center = otherSlider.Value;
    spread = inputSlider.Value;
    money_density = @(p) funct(p,center,spread);
    gamma = @(p) FUNCT(p,center,spread);
    
   % Onto the Plotting
    xValues = 0:.0001:1;
    yValues = money_density(xValues);
    plot(myAxes,xValues,yValues,'LineWidth',2,'Color',[0 0 0])
    uilabel(myAxes,'Text',sprintf('Center: %.4g',center),'Position',[800 450 300 50],'FontSize',16,'FontWeight','bold');
    uilabel(myAxes,'Text',sprintf('Spread: %.4g',spread),'Position',[1000 450 300 50],'FontSize',16,'FontWeight','bold');
    
    % Solving for the Money Line
    newtonMoneyLine = newton_iteration_money_line(money_density,gamma,1e-6); 
    
    if newtonMoneyLine.paNI ~= -1
        pa = newtonMoneyLine.paNI; pb = newtonMoneyLine.pbNI; profit = newtonMoneyLine.profitNI;
    else
        warning('Newton Iteration Failed ... Solving with Monte Carlo')
        montecarloMoneyLine = monte_carlo_money_line(gamma,.25,1e-5);
        pa = montecarloMoneyLine.paMC; pb = montecarloMoneyLine.pbMC; profit = montecarloMoneyLine.profitMC;
    end     
    
    if newtonMoneyLine.paNI ~= -1 || montecarloMoneyLine.paMC ~= -1
        
        % Adding the Green Area
        xGreens = cat(2,0:.001:pb,flip(0:.001:pb));
        yGreens = cat(2,money_density(0:.001:pb),zeros(1,length(0:.001:pb)));
        patch(myAxes,xGreens,yGreens,[144,238,144]/255,'LineWidth',2)
              
        % Adding the Red Area     
        xReds = cat(2,pa:.001:1,flip(pa:.001:1));
        yReds = cat(2,money_density(pa:.001:1),zeros(1,length(pa:.001:1)));
        patch(myAxes,xReds,yReds,[255,114,118]/255,'LineWidth',2)
    
        uilabel(myAxes,'Text',sprintf('P_Alpha: %.4g',pa),'Position',[800 450 300 50],'FontSize',16,'FontWeight','bold');
        uilabel(myAxes,'Text',sprintf('P_Beta: %.4g',pb),'Position',[1000 450 300 50],'FontSize',16,'FontWeight','bold');
        uilabel(myAxes,'Text',sprintf('Profit: %.4g',profit),'Position',[900 400 300 50],'FontSize',16,'FontWeight','bold');
        
    else      
        % Adding the Red Area     
        xReds = cat(2,0:.001:1,flip(0:.001:1));
        yReds = cat(2,money_density(0:.001:1),zeros(1,length(0:.001:1)));
        patch(myAxes,xReds,yReds,[1 0 0],'LineWidth',2)
        
        uilabel(myAxes,'Text','No Profitable Solution','Position',[900 450 300 50],'FontSize',16,'FontWeight','bold');
    end
end
