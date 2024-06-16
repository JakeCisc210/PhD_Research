function sample_values = distribution_sample(density,num_values,opt)

% Sample Values are Generated Using the PY525 Method

    arguments
        density = @(x) double_stunted_gaussian(x,1/2,1/20);
        num_values = 1e4;
        opt.value_range = [0 1];
        opt.include_histogram = 0;
    end
    
    
    value_mesh = opt.value_range(1):(diff(opt.value_range)/1000):opt.value_range(2);
    max_density = max(density(value_mesh));

    sample_values = nan(1,num_values);
    for index = 1:num_values
        counter = 0;
        while isnan(sample_values(index))
            sample_value = diff(opt.value_range)*rand()+value_mesh(1);
            pr_accept = density(sample_value)/max_density;
            if rand() <= pr_accept
                sample_values(index) = sample_value;
            end
            counter = counter + 1;
            assert(counter <= 100)
        end
    end
    
    if opt.include_histogram
        h = histogram(sample_values);
        hold on
        A = num_values*h.BinWidth/integral(density,value_mesh(1),value_mesh(end));
        plot(value_mesh,A*density(value_mesh),...
            'LineWidth',2)
        hold off
    end
end