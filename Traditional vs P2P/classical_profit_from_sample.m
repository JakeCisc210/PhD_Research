function [profit,palpha_final,pbeta_final] = classical_profit_from_sample(sample_values,sample_bet_amounts,tolerance,opt)

    arguments
        sample_values = double_stunted_gaussian_inverse_gamma(rand(1,1e3),1/2,1/20);
        sample_bet_amounts = ones(1,length(sample_values));
        tolerance = 1; % in basis points of sum of all bet amounts
        opt.include_waitbar = 1;
    end
    
    num_samples = length(sample_values);
    [sample_values,sample_indeces] = sort(sample_values);
    sample_bet_amounts = sample_bet_amounts(sample_indeces);
    
    profit = 0;
    palpha_final = nan;
    pbeta_final = nan;
    
    if opt.include_waitbar
        f = waitbar(0,'Starting Process','Name','Solving For Traditional Sportsbook');
    end
    for palpha_index = 1:num_samples

        if opt.include_waitbar
            progress_value = (palpha_index^2+palpha_index)/(num_samples^2+num_samples);
            waitbar(progress_value,f,sprintf('%.1f Percent Complete',100*progress_value));
        end

        for pbeta_index = 1:(palpha_index-1)
            palpha = sample_values(palpha_index);
            pbeta = sample_values(pbeta_index);
            alpha = 100*palpha/(1-palpha);
            beta = 100*pbeta/(1-pbeta);
    
            money_on_favorite = sum(sample_bet_amounts(palpha_index:num_samples));
            money_on_underdog = sum(sample_bet_amounts(1:pbeta_index));

            profit_favorite_win = money_on_underdog - 100/alpha*money_on_favorite;
            profit_underdog_win = money_on_favorite - beta/100*money_on_underdog;
            if abs(profit_favorite_win-profit_underdog_win) <= tolerance*sum(sample_bet_amounts)/10000
                if max(profit_favorite_win,profit_underdog_win) > profit
                    profit = max(profit_favorite_win,profit_underdog_win);
                    palpha_final = palpha;
                    pbeta_final = pbeta;
                end
            end
    
        end
    end
    if opt.include_waitbar
        close(f)
    end
end