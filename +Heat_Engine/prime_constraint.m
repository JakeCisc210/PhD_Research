function value = prime_constraint(~,gamma,vLow,vHigh)
% Takes density, gamma, vLow, vHigh
% Assume equal amount of mass in each reservoir

    mC = gamma(vLow); % in kilograms   
    mH = gamma(1e6)-gamma(vHigh); % Assumes max T is 1e6
    value = mH - mC; 
    
end
