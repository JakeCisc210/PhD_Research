function value = derived_constraint(density,gamma,pbid,pask)
% Takes density, gamma, vLow, vHigh

% Returns the value of the equation corresponding to the second equation
% for the optimized bid ask spread as derived by Lagrange Multipliers
        value = (pask-pbid).*density(pask).*density(pbid)-(density(pask)+density(pbid)).*gamma(pbid);
end