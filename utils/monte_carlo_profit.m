function value = monte_carlo_profit(gamma,palpha,pbeta)
% Returns the value of the equation corresponding to the balance constraint
% of a classical money line

% Assumes Normalized Gamma
    value = (1-pbeta/palpha)*(gamma(1)-gamma(palpha));
end
