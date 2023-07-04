function value = classical_moneyline_equation1(gamma,palpha,pbeta)
% Returns the value of the equation corresponding to the balance constraint
% of a classical money line
    value = palpha.*gamma(pbeta) - (1-pbeta).*(1-gamma(palpha));
end
