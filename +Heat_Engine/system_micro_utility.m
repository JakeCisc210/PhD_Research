function value = system_micro_utility(vLow,vHigh,T1,specificHeat,mC,mH)

    % Assume volume is adjustable
    % Wout in terms of 3/2 N kB

    arguments 
        vLow = 200; % TC in Kelvin
        vHigh = 300; % TH in Kelvin
        T1 = 250; % in Kelvin
        specificHeat = 2;
        mC = 7; % in kilograms
        mH = 3;        
    end

    if nargin < 6
        warning('\n%d/%d inputs provide for HeatEngine.system_micro_utility\n',nargin,6)
    end
    
    numerator = (specificHeat*mC+specificHeat*specificHeat*mC*mH)*(T1-vLow)-specificHeat*mH*(vHigh-T1);
    denominator = (specificHeat*mC+specificHeat*specificHeat*mC*mH)*T1-specificHeat*mH*(vHigh-T1);
    value = 3/2*specificHeat*mH/(1+specificHeat*mH)*(vHigh-T1)*numerator/denominator;
    
end