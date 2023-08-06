function value = prime_constraint(~,gamma,pbid,pask)
% Takes density, gamma, vLow, vHigh

% Assumes max price <= trillion dollars (seems fair)

    value = gamma(10e12)-gamma(pask)-gamma(pbid);
end
