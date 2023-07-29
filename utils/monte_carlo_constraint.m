function value = monte_carlo_constraint(gamma,palpha,pbeta)
% Returns the value of the equation corresponding to the balance constraint
% of a classical money line

% Assumes Normalized Gamma
    value = palpha*gamma(pbeta)-(1-pbeta)*(gamma(1)-gamma(palpha));
end
