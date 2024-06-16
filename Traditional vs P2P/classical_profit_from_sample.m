function [profit,palpha_final,pbeta_final] = classical_profit_from_sample(sample_values,tolerance)

    arguments
        sample_values = double_stunted_gaussian_inverse_gamma(rand(1,1e3),1/2,1/20);
        tolerance = 1; % in basis points
    end
    
    num_samples = length(sample_values);
    sample_values = sort(sample_values);
    
    total_profit = 0;
    palpha_final = nan;
    pbeta_final = nan;
    
    % Would be interesting to plot max profitability as a function of asymmetry
    % tolerance
    
    f = waitbar(0,'Starting Process','Name','Solving For Traditional Sportsbook');
    for palpha_index = 1:num_samples
        progress_value = (palpha_index^2+palpha_index)/(num_samples^2+num_samples);
        waitbar(progress_value,f,sprintf('%.1f Percent Complete',100*progress_value));
        for pbeta_index = 1:(palpha_index-1)
            palpha = sample_values(palpha_index);
            pbeta = sample_values(pbeta_index);
            alpha = 100*palpha/(1-palpha);
            beta = 100*pbeta/(1-pbeta);
    
            profit_favorite_win = length(1:pbeta_index) - 100/alpha*length(palpha_index:num_samples);
            profit_underdog_win = length(palpha_index:num_samples) - beta/100*length(1:pbeta_index);
            if abs(profit_favorite_win-profit_underdog_win) <= tolerance*num_samples/10000
                if max(profit_favorite_win,profit_underdog_win) > total_profit
                    total_profit = max(profit_favorite_win,profit_underdog_win);
                    palpha_final = palpha;
                    pbeta_final = pbeta;
                end
            end
    
        end
    end
    close(f)
    profit = total_profit/num_samples;
end