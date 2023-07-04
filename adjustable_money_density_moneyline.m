function adjustable_money_density_moneyline(funct,FUNCT,centerRange,spreadRange)
    % Plots money density function with manipulatable center and spreads
    % Solves for the optimal moneyline and plots the regions enclosed
    % by both moneyline values
    
    % funct - money density
    % FUNCT - integral of money density
    % centerRange - maximum and minimum center values
    % spreadRange - maximum and minimum spread values
     
    arguments
        funct = @(p,center,spread) (abs(p-center)<= 2.*spread) .* exp(-power(p-center,2)./2./power(spread,2))./sqrt(2.*pi)./spread./erf(sqrt(2)); 
        FUNCT = @(p,center,spread) erf((p-center)./sqrt(2)./spread)./2./erf(sqrt(2)) + 1/2;
        centerRange = [.5 .6];
        spreadRange = [.2 .25];
    end
    
    myFigure = uifigure('Name','Moneyline for Adjusted Money Density','Position',[200 75 1200 670]);
    myAxes = uiaxes(myFigure,'Position',[50 100 1100 500]);
    myAxes.FontSize = 16; myAxes.FontWeight = 'bold'; myAxes.LineWidth = 2; 
    myAxes.XAxis.Label.String = 'Probability'; myAxes.YAxis.Label.String = 'Money Density';
       
    center = centerRange(1);
    spread = spreadRange(1);
    money_density = @(p) funct(p,center,spread);
    gamma = @(p) FUNCT(p,center,spread);
    
    % Checking that probability function obeys probability laws
    if ~isempty(find(money_density(0:.01:1)<0,1)); error('Negative Values for Money Density Function in [0, 1]'); end 
    if abs(integral(money_density,0,1)-1) > 1e-4; error('Money Density not normalized'); end
    
    % Checking that FUNCT = integral(funct,0,p)
    for ii = 1:10
        pTest = rand();
        integralDiff = abs(integral(money_density,0,pTest)-gamma(pTest));     
        if integralDiff > .1; error('FUNCT ~= integral(funct), error of %d',integralDiff); end
    end
        
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
    
    centerSlider = uicontrol(myFigure,'Style','slider',...
        'Position',[500 30 200 50],...
        'Min',centerRange(1),'Max',centerRange(2),'Value',centerRange(1),...
        'sliderStep',[1/100 1/100]);   
    centerSlider.Callback = money_density_center_callback;
        
    spreadSlider = uicontrol(myFigure,'Style','slider',...
        'Position',[500 30 200 50],...
        'Min',spreadRange(1),'Max',spreadRange(2),'Value',spreadRange(1),...
        'sliderStep',[1/100 1/100]);   
    spreadSlider.Callback = money_density_spread_callback;
end
    
    
    
    
