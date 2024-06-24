function black_scholes_params = estimate_black_scholes_parameters(stock_data,precision_level,spot_price)


    arguments
        stock_data = struct();
        precision_level = 1e-4;
        spot_price = 'Open';
    end

    if strcmpi(spot_price,'Open')
        stock_prices = [stock_data.Open];
    elseif strcmpi(spot_price,'Low')
        stock_prices = [stock_data.Low];
    elseif strcmpi(spot_price,'High')
        stock_prices = [stock_data.High];
    elseif strcmpi(spot_price,'Close')
        stock_prices = [stock_data.Close];
    elseif strcmpi(spot_price,'AdjClose')
        stock_prices = [stock_data.AdjClose];
    else
        error('Wrong Spot Pice Option Selected')
    end

    dS_over_S = diff(stock_prices)./stock_prices(1:(end-1));

    dS_over_S_mean = mean(dS_over_S);
    dS_over_S_stdev = std(dS_over_S);

    n = length(stock_prices);
    p_value = .95; % For 95% Confidence Interval
    z_value = norminv((1+p_value)/2);
    
    dS_over_S_mean_interval = [dS_over_S_mean-z_value*dS_over_S_stdev/sqrt(n), dS_over_S_mean+z_value*dS_over_S_stdev/sqrt(n)];
    dS_over_S_stdev_interval = [sqrt((n-1)/chi2inv((1+p_value)/2,n-1)) sqrt((n-1)/chi2inv((1-p_value)/2,n-1))].*dS_over_S_stdev;

    dS_over_S_mean_interval = round(dS_over_S_mean_interval,-log10(precision_level));
    dS_over_S_stdev_interval = round(dS_over_S_stdev_interval,-log10(precision_level));
    
    dS_over_S_mean_range = dS_over_S_mean_interval(1):precision_level:dS_over_S_mean_interval(2);
    dS_over_S_stdev_range = dS_over_S_stdev_interval(1):precision_level:dS_over_S_stdev_interval(2);
    
    lowest_chi_square_value = inf;
    best_mean = nan;
    best_stdev = nan;
    
    for ii = 1:length(dS_over_S_mean_range)
        for jj = 1:length(dS_over_S_stdev_range)
            test_mean = dS_over_S_mean_range(ii);
            test_stdev = dS_over_S_stdev_range(jj);
            z_score_set = (dS_over_S-test_mean)/test_stdev;
            chi_square_value = compare_with_standard_normal(z_score_set);
            if chi_square_value < lowest_chi_square_value
                best_mean = test_mean;
                best_stdev = test_stdev;
                lowest_chi_square_value = chi_square_value;
            end
        end
    end
    
    dt = 1/n;

    black_scholes_params.best_mu = best_mean/dt;
    black_scholes_params.best_sigma = best_stdev/sqrt(dt);

    black_scholes_params.mu_interval = dS_over_S_mean_interval/dt;
    black_scholes_params.sigma_interval = dS_over_S_stdev_interval/sqrt(dt);
end