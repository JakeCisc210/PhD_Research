function value = system_utility(~,gamma,pbeta,palpha)
% Takes density, gamma, vLow, vHigh

    value = (1-pbeta./palpha).*(gamma(1)-gamma(palpha));
end
