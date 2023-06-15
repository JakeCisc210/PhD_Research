function gaussian_graphic(lValue,hValue)
    arguments 
        lValue = -.67;
        hValue = .43;
    end
    
    figure
    hold on
    xValues = -3:.01:3;
    yValues = exp(-power(xValues,2)/2)/sqrt(2*pi);
    plot(xValues,yValues,'Color',[0 0 0],'LineWidth',2)
    xlabel('Value')
    ylabel('Quantity')
    ylim([0 .5])
    myAxes = gca;
    myAxes.LineWidth = 2;
    myAxes.FontSize = 10;
    myAxes.FontWeight = 'bold';
    
    % Adding the Green Area

    xGreens = cat(2,-3:.01:lValue,flip(-3:.01:lValue));
    yGreens = cat(2,exp(-power(-3:.01:lValue,2)/2)/sqrt(2*pi),zeros(1,length(-3:.01:lValue)));
    patch(xGreens,yGreens,[144,238,144]/255,'LineWidth',2)

    % Adding the Red Area

    xReds = cat(2,hValue:.01:3,flip(hValue:.01:3));
    yReds = cat(2,exp(-power(hValue:.01:3,2)/2)/sqrt(2*pi),zeros(1,length(hValue:.01:3)));
    patch(xReds,yReds,[255,114,118]/255,'LineWidth',2)
end