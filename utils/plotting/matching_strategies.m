function matching_strategies(inverse_gamma)
    
    arguments
        inverse_gamma = @(d) double_stunted_gaussian_inverse_gamma(d,-.05,1)
    end
    
    figure('Name','Percentile Bar','Position',[200 75 1200 670]);
    myAxes = gca;
    myAxes.XAxis.Visible = 'off'; myAxes.YAxis.Visible = 'off';
    
    percentiles = zeros(1,10);
    for ii = 1:10
        percentiles(ii) = rand();
    end
    
    % 
    percentiles = sort(percentiles);
    for ii = 1:10
        xBox = [0 1 1 0];
        yBox = [ii ii ii+1 ii+1];
        percentileColor = interp1([100; 67; 33; 0],[1 0 0; 1 165/255 0; 1 1 0; 0 1 0],100*percentiles(ii));
        patch(myAxes,xBox,yBox,percentileColor,'EdgeColor',[0 0 0],'LineWidth',2)
        text(.5,ii+1/2,sprintf('%.2g',inverse_gamma(percentiles(ii))),'FontSize',24,'FontWeight','bold','HorizontalAlignment','center')
    end
  
    % Split and Pair
    figure('Name','Split and Pair','Position',[200 75 1200 670]);
    myAxes = gca;
    myAxes.XAxis.Visible = 'off'; myAxes.YAxis.Visible = 'off';
    
    percentiles = flip(percentiles);
    for ii = 1:5
        xBox1 = [0 1 1 0];
        xBox2 =  xBox1+2*ones(1,4);
        yBox = [ii ii ii+1 ii+1];
        percentileColor1 = interp1([100; 67; 33; 0],[1 0 0; 1 165/255 0; 1 1 0; 0 1 0],100*percentiles(6-ii));
        percentileColor2 = interp1([100; 67; 33; 0],[1 0 0; 1 165/255 0; 1 1 0; 0 1 0],100*percentiles(11-ii));
        patch(myAxes,xBox1,yBox,percentileColor1,'EdgeColor',[0 0 0],'LineWidth',2)
        patch(myAxes,xBox2,yBox,percentileColor2,'EdgeColor',[0 0 0],'LineWidth',2)
        text(0.5,ii+1/2,sprintf('%.2g',inverse_gamma(percentiles(6-ii))),'FontSize',24,'FontWeight','bold','HorizontalAlignment','center')
        text(2.5,ii+1/2,sprintf('%.2g',inverse_gamma(percentiles(11-ii))),'FontSize',24,'FontWeight','bold','HorizontalAlignment','center')
    end    
    
    % Outside In
    figure('Name','Outside In','Position',[200 75 1200 670]);
    myAxes = gca;
    myAxes.XAxis.Visible = 'off'; myAxes.YAxis.Visible = 'off';
    
    for ii = 1:5
        xBox1 = [0 1 1 0];
        xBox2 =  xBox1+2*ones(1,4);
        yBox = [ii ii ii+1 ii+1];
        percentileColor1 = interp1([100; 67; 33; 0],[1 0 0; 1 165/255 0; 1 1 0; 0 1 0],100*percentiles(6-ii));
        percentileColor2 = interp1([100; 67; 33; 0],[1 0 0; 1 165/255 0; 1 1 0; 0 1 0],100*percentiles(ii+5));
        patch(myAxes,xBox1,yBox,percentileColor1,'EdgeColor',[0 0 0],'LineWidth',2)
        patch(myAxes,xBox2,yBox,percentileColor2,'EdgeColor',[0 0 0],'LineWidth',2)
        text(0.5,ii+1/2,sprintf('%.2g',inverse_gamma(percentiles(6-ii))),'FontSize',24,'FontWeight','bold','HorizontalAlignment','center')
        text(2.5,ii+1/2,sprintf('%.2g',inverse_gamma(percentiles(ii+5))),'FontSize',24,'FontWeight','bold','HorizontalAlignment','center')
    end    
    
end