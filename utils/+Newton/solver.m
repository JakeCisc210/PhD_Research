function [vL,vH] = solver(prime_constraint,derived_constraint,tolerance)
    
    % Find our initial pa and pb
    vL = .51;
    numTries = 0;
    while abs(derived_constraint(vL)) < .1 && numTries < 1000
        numTries = numTries + 1; vL = rand();
    end
    if numTries >= 999; error('System Utility Function Too Concentrated'); end
    vH = vL;
    
    % Iteration Time
    numIter = 0;
    
    h = power(10,-6); % TODO: Add option for h
    
    while abs(prime_constraint(vL,vH)) > tolerance && abs(derived_constraint(vL,vH))&& numIter < 1000
        f1 = @(var1,var2) prime_constraint(var1,var2);
        f2 = @(var1,var2) derived_constraint(var1,var2);
        [dvL, dvH] = Newton.step_2d(f1,f2,vL,vH,h);
        vL = vL + dvL;
        vH = vH + dvH;     
        numIter = numIter + 1;
    end
    
    if numIter >= 1000
        error('Maximum Iterations Reached');
    end
end