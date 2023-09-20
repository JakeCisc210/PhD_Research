function value = system_utility(~,gamma,pbeta,palpha)
% Takes density, gamma, vLow, vHigh

% Returns the value of the equation corresponding to the balance constraint
% of a classical money line
    value = (1-pbeta./palpha).*(gamma(1)-gamma(palpha));
end
