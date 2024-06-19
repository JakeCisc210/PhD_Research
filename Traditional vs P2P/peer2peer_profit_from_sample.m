function [profit,matching_technique] = peer2peer_profit_from_sample(sample_values,x)

    arguments
        sample_values = double_stunted_gaussian_inverse_gamma(rand(1,1e3),1/2,1/20);
        x = 2;
    end
    
    num_samples = length(sample_values);
    sample_values = sort(sample_values);
    
    profit_outside_in = 0;
    for index = 1:(num_samples/2)
        % Outside In Matching
        p1 = sample_values(index);
        p2 = sample_values(num_samples+1-index);
        peer_bet = peer_to_peer(p1,p2,1,x);
        profit_outside_in = profit_outside_in + peer_bet.profit;
    end
    
    profit_split_n_pair = 0;
    for index = 1:(num_samples/2)
        % Split n' Pair Matching
        p1 = sample_values(index);
        p2 = sample_values(index+num_samples/2);
        peer_bet = peer_to_peer(p1,p2,1,x);
        profit_split_n_pair = profit_split_n_pair + peer_bet.profit;
    end

    if profit_outside_in >= profit_split_n_pair
        profit = profit_outside_in;
        matching_technique = 'Outside In';
    else
        profit = profit_split_n_pair;
        matching_technique = 'Split n'' Pair';
    end

end