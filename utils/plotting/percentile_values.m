function percentile_values(inverse_gamma)
    arguments
        inverse_gamma = @(d) double_stunted_gaussian_inverse_gamma(d,-.05,1)
    end
    figure('Name','Percentile Bar','Position',[200 75 1200 670]);
    myAxes = gca;
    myAxes.XAxis.Visible = 'off'; myAxes.YAxis.Visible = 'off';
    
    for ii = 0:100
        xBox = [0 .05 .05 0];
        yBox = [ii ii ii+1 ii+1];
        patch(myAxes,xBox,yBox,[0 0 0])
        if ~mod(ii,10); text(.07,ii+1/2,sprintf('%.2g',inverse_gamma(ii/100)),'FontSize',24,'FontWeight','bold'); end
    end
    text(.25,50,'Value','Rotation',-90,'VerticalAlignment','bottom','FontSize',24,'FontWeight','bold')
    xlim([0 2])
end