function money_density_spread_callback(inputSlider,event)
    spread = inputSlider.Value;
    money_density = @(p) funct(p,center,spread);
    gamma = @(p) FUNCT(p,center,spread);
    
    % Onto the Plotting
    xValues = 0:.0001:1;
    yValues = money_density(xValues);
    plot(xValues,yValues,'LineWidth',2,'Color',[0 0 0])
      
    % Solving for the Money Line
    solvedMoneyLine = newton_iteration_money_line(money_density,gamma,1e-6); 
         
    % Adding the Green Area
    pb = solvedMoneyLine.pbNI;
    xGreens = cat(2,0:.001:pb,flip(0:.001:pb));
    yGreens = cat(2,money_density(0:.001:pb),zeros(1,length(0:.001:pb)));
    patch(xGreens,yGreens,[144,238,144]/255,'LineWidth',2)
   
    % Adding the Red Area
    pa = solvedMoneyLine.paNI;
    xReds = cat(2,pa:.001:1,flip(pa:.001:1));
    yReds = cat(2,money_density(pa:.001:1),zeros(1,length(pa:.001:1)));
    patch(xReds,yReds,[255,114,118]/255,'LineWidth',2)
    
end
