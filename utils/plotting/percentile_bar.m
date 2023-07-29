function percentile_bar()
    figure('Name','Percentile Bar','Position',[200 75 1200 670]);
    myAxes = gca;
    myAxes.FontSize = 20; myAxes.FontWeight = 'bold'; myAxes.LineWidth = 2; 
    myAxes.XAxis.Visible = 'off'; myAxes.YAxisLocation = 'right'; ylabel('Percentile','Rotation',-90,'VerticalAlignment','bottom')
    
    for ii = 0:99
        xBox = [0 1 1 0];
        yBox = [ii ii ii+1 ii+1];
        percentileColor = interp1([100; 67; 33; 0],[1 0 0; 1 165/255 0; 1 1 0; 0 1 0],ii);
        patch(myAxes,xBox,yBox,percentileColor,'EdgeColor',percentileColor)
    end
    
end