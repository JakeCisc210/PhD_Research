function plot_density_function(money_density,inverse_gamma,range,lowValue,highValue,isClassical)
  
    arguments
        money_density = @(p) double_stunted_gaussian(p,.5,.1); 
        inverse_gamma = @(d) double_stunted_gaussian_inverse_gamma(d,.5,.1)
        range = [0 1];
        lowValue = .4;
        highValue = .6;
        isClassical = 1; % Colors by Percentile Otherwise
    end
    
    myFigure = uifigure('Name','Moneyline for Adjusted Money Density','Position',[200 75 1200 670]);
    myAxes = uiaxes(myFigure,'Position',[50 100 1100 500]);
    myAxes.FontSize = 20; myAxes.FontWeight = 'bold'; myAxes.LineWidth = 2; 
    myAxes.XAxis.Label.String = 'Probability'; myAxes.YAxis.Label.String = 'Money Density';
    myAxes.XLim = range;
    myAxes.YLim = [0 1.1*max(money_density(range(1):.01:range(2)))];
    inc = diff(range)/1e4;
    
    % Onto the Plotting
    xValues = range(1):inc:range(2);
    yValues = money_density(xValues);
    plot(myAxes,xValues,yValues,'LineWidth',2,'Color',[0 0 0])
    
    pb = lowValue; pa = highValue;
    % Adding the Green Area
    xGreens = cat(2,range(1):10*inc:pb,flip(range(1):10*inc:pb)); disp(length(xGreens));
    yGreens = cat(2,money_density(range(1):10*inc:pb),zeros(1,length(range(1):10*inc:pb)));disp(length(yGreens));
    patch(myAxes,xGreens,yGreens,[144,238,144]/255,'LineWidth',2)
    
    % Adding the Red Area
    xReds = cat(2,pa:10*inc:range(2),flip(pa:10*inc:range(2)));
    yReds = cat(2,money_density(pa:10*inc:range(2)),zeros(1,length(pa:10*inc:range(2))));
    patch(myAxes,xReds,yReds,[255,114,118]/255,'LineWidth',2)
    
    % Adding the Gray Area
    xGrays = cat(2,pb:10*inc:pa,flip(pb:10*inc:pa));
    yGrays = cat(2,money_density(pb:10*inc:pa),zeros(1,length(pb:10*inc:pa)));
    patch(myAxes,xGrays,yGrays,[200 200 200]/255,'LineWidth',2)
              
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