%% Set Up Money Density Function and Gamma
money_density = @(p) double_stunted_gaussian(p,.5,.2);
gamma = @(p) double_stunted_gaussian_gamma(p,.5,.2);

s_u = @(pbeta,palpha) Gambling.system_utility(money_density,gamma,pbeta,palpha);
p_c = @(pbeta,palpha) Gambling.prime_constraint(money_density,gamma,pbeta,palpha);
d_c = @(pbeta,palpha) Gambling.derived_constraint(money_density,gamma,pbeta,palpha);

[vL,vH,profitMax] = Numerical.solver(s_u,p_c,[.1 .9],1e-4)

[vL,vH] = Newton.solver(p_c,d_c,1e-4,[.1 .9])
