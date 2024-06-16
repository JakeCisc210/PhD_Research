function moneyline_struct = moneyline_solver(density,gamma,tolerance)

arguments
    density = @(p) double_stunted_gaussian(p,1/2,1/10);
    gamma = @(p) double_stunted_gaussian_gamma(p,1/2,1/10);
    tolerance = 5; % In terms of Basis Points
end

    test_mesh = 0:.0001:1;
    test_values = density(test_mesh);
    range_min = test_mesh(find(test_values>0,1,'first'));
    range_max = test_mesh(find(test_values>0,1,'last'));
    
    s_u = @(pbeta,palpha) Gambling.system_utility(density,gamma,pbeta,palpha);
    p_c = @(pbeta,palpha) Gambling.prime_constraint(density,gamma,pbeta,palpha);
    d_c = @(pbeta,palpha) Gambling.derived_constraint(density,gamma,pbeta,palpha);
    
    % Numerical Solution
    [moneyline_struct.pbeta_numerical,moneyline_struct.palpha_numerical,moneyline_struct.profit_numerical] = Numerical.solver(s_u,p_c,[range_min range_max],tolerance/10000);
    
    [moneyline_struct.pbeta_newton,moneyline_struct.palpha_newton] = Newton.solver(p_c,d_c,tolerance/10000,[range_min range_max]);
    
    moneyline_struct.profit_newton = Gambling.system_utility(density,gamma,moneyline_struct.pbeta_newton,moneyline_struct.palpha_newton);

    % P Alpha and P Beta are allowed to differ by 20 basis points in this
    % program
    moneyline_struct.matched_answers = abs(moneyline_struct.pbeta_numerical-moneyline_struct.pbeta_newton) <= 20/10000 && ...
        abs(moneyline_struct.palpha_numerical-moneyline_struct.palpha_newton) <= 20/10000 && ...
        abs(moneyline_struct.profit_numerical-moneyline_struct.profit_newton) <= tolerance/10000;


end