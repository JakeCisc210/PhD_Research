function static_money_density_moneyline(money_density,gamma,inverse_gamma,isClassical)
    % Plots money density function with manipulatable center and spreads
    % Solves for the optimal moneyline and plots the regions enclosed
    % by both moneyline values
    
    % funct - money density
    % FUNCT - integral of money density
    % centerRange - maximum and minimum center values
    % spreadRange - maximum and minimum spread values
     
    arguments
        money_density = @(p) double_stunted_gaussian(p,.5,.1); 
        gamma = @(p) double_stunted_gaussian_gamma(p,.5,.1);
        inverse_gamma = @(d) double_stunted_gaussian_inverse_gamma(d,.5,.1)
        isClassical = 1; % Colors by Percentile Otherwise
    end
    
    myFigure = uifigure('Name','Moneyline for Adjusted Money Density','Position',[200 75 1200 670]);
    myAxes = uiaxes(myFigure,'Position',[50 100 1100 500]);
    myAxes.FontSize = 20; myAxes.FontWeight = 'bold'; myAxes.LineWidth = 2; 
    myAxes.XAxis.Label.String = 'Probability'; myAxes.YAxis.Label.String = 'Money Density';
    myAxes.XLim = [0 1]; myAxes.YLim = [0 1.1*max(money_density(0:.01:1))];
       
    % Checking that probability function obeys probability laws
    if ~isempty(find(money_density(0:.01:1)<0,1)); error('Negative Values for Money Density Function in [0, 1]'); end 
    if abs(integral(money_density,0,1)-1) > 1e-4; error('Money Density not normalized'); end
    
    % Checking that FUNCT = integral(funct,0,p)
    for ii = 1:10
        pTest = rand();
        integralDiff = abs(integral(money_density,0,pTest)-gamma(pTest));     
        if integralDiff > .05; error('FUNCT ~= integral(funct), error of %d',integralDiff); end
    end
    
    % Onto the Plotting
    xValues = 0:.0001:1;
    yValues = money_density(xValues);
    plot(myAxes,xValues,yValues,'LineWidth',2,'Color',[0 0 0])
      
    if isClassical
        % Solving for the Money Line
        newtonMoneyLine = newton_iteration_money_line(money_density,gamma,1e-6);
        
        if newtonMoneyLine.palphaNI ~= -1
            pa = newtonMoneyLine.palphaNI; pb = newtonMoneyLine.pbetaNI; profit = newtonMoneyLine.profitNI;
        else
            montecarloMoneyLine = monte_carlo_money_line(gamma,1,10);
            pa = montecarloMoneyLine.palphaMC; pb = montecarloMoneyLine.pbetaMC; profit = montecarloMoneyLine.profitMC;
        end
        
        if newtonMoneyLine.palphaNI ~= -1 || montecarloMoneyLine.palphaMC ~= -1
            
            % Adding the Green Area
            xGreens = cat(2,0:.001:pb,flip(0:.001:pb));
            yGreens = cat(2,money_density(0:.001:pb),zeros(1,length(0:.001:pb)));
            patch(myAxes,xGreens,yGreens,[144,238,144]/255,'LineWidth',2)
            
            % Adding the Red Area
            xReds = cat(2,pa:.001:1,flip(pa:.001:1));
            yReds = cat(2,money_density(pa:.001:1),zeros(1,length(pa:.001:1)));
            patch(myAxes,xReds,yReds,[255,114,118]/255,'LineWidth',2)
            
            % Adding the Gray Area
            xGrays = cat(2,pb:.001:pa,flip(pb:.001:pa));
            yGrays = cat(2,money_density(pb:.001:pa),zeros(1,length(pb:.001:pa)));
            patch(myAxes,xGrays,yGrays,[200 200 200]/255,'LineWidth',2)
            
            palphaLabel = uilabel(myFigure,'Text',sprintf('P_Alpha: %.4g',pa),'Position',[800 450 300 50],'FontSize',16,'FontWeight','bold');
            pbetaLabel = uilabel(myFigure,'Text',sprintf('P_Beta: %.4g',pb),'Position',[1000 450 300 50],'FontSize',16,'FontWeight','bold');
            profitLabel = uilabel(myFigure,'Text',sprintf('Profit: %.4g',profit),'Position',[900 400 300 50],'FontSize',16,'FontWeight','bold');
            
        else
            
            % Adding the Dead Red Area
            xReds = cat(2,0:.001:1,flip(0:.001:1));
            yReds = cat(2,money_density(0:.001:1),zeros(1,length(0:.001:1)));
            patch(myAxes,xReds,yReds,[1 0 0],'LineWidth',2)
            
            palphaLabel = uilabel(myFigure,'Text','P_Alpha: N/A','Position',[800 450 300 50],'FontSize',16,'FontWeight','bold');
            pbetaLabel = uilabel(myFigure,'Text','P_Beta: N/A','Position',[1000 450 300 50],'FontSize',16,'FontWeight','bold');
            profitLabel = uilabel(myFigure,'Text','Profit: N/A','Position',[900 400 300 50],'FontSize',16,'FontWeight','bold');
            
        end
    end
    
    if ~isClassical
        for ii = 0:99
            xMin = inverse_gamma(ii/100);
            xMax = inverse_gamma((ii+1)/100);
            xBox = cat(2,xMin:.001:xMax,flip(xMin:.001:xMax));
            yBox = cat(2,money_density(xMin:.001:xMax),zeros(1,length(xMin:.001:xMax)));
            percentileColor = interp1([100; 67; 33; 0],[1 0 0; 1 165/255 0; 1 1 0; 0 1 0],ii);
            patch(myAxes,xBox,yBox,percentileColor,'EdgeColor',percentileColor)
        end
    end
    
end