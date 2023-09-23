function [vL,vH] = solver(prime_constraint,derived_constraint,tolerance,range)
    
% range is of the from [lowerBound upperBound]

    % Find our initial vL and vH
    vL = mean(range);
    vH = mean(range) + rand()*diff(range)/2;
    
    % Iteration Time
    numIter = 0;
    
    h = power(10,-6); % TODO: Add option for h
    
    while abs(prime_constraint(vL,vH)) > tolerance && abs(derived_constraint(vL,vH))> tolerance && numIter < 1000       
        [dvL, dvH,singularJacobian] = Newton.step_2d(prime_constraint,derived_constraint,vL,vH,h);
        
        if ~singularJacobian
            vL = vL + dvL;
            vH = vH + dvH;
        else
            vL = mean(range);
            vH = mean(range) + rand()*diff(range)/2;
        end
        
        numIter = numIter + 1;
    end

    if numIter >= 1000
        error('Maximum Iterations Reached');
    end
end