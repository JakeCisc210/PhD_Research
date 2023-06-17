function value = classical_moneyline_equation2(money_density,gamma,palpha,pbeta)
% Returns the value of the equation corresponding to the second equation
% for the optimized classical money line as derived by Lagrange Multipliers
        term1 = gamma(pbeta,center,spread)*(1-gamma(palpha));
        term2 = palpha*(1-palpha)*money_density(palpha)*gamma(pbeta);
        term3 = pbeta*(1-pbeta)*money_density(pbeta)*(1-gamma(palpha));
        term4 = (palpha-pbeta)*(1-pbeta)*palpha*money_density(palpha)*money_density(pbeta);
        value = term1 + term2 + term3 - term4;
end