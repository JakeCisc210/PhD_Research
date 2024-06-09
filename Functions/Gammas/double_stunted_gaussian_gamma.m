function value = double_stunted_gaussian_gamma(p,center,spread)
    % p either a single number or in the form of [a:b]
	value = erf((p-center)./sqrt(2)./spread)./2./erf(sqrt(2)) + 1/2;
end