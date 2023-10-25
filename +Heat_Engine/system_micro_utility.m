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

    % Since we only have two masses...
    TC = vLow;
    TH = vHigh;
    
    numerator1 = (specificHeat*mC+specificHeat*specificHeat*mC*mH)*(T1-TC)-specificHeat*mH*(TH-T1)
    denominator1 = (specificHeat*mC+specificHeat*specificHeat*mC*mH)*T1-specificHeat*mH*(TH-T1)

    % These may be the correct values:
    numerator2 = mH*(TH-T1)-mC*(1+specificHeat*mH)*(T1+TC) % Big Difference: Is it T1-TC or T1+TC???
    denominator2 = mH*(TH-T1)-mC*(1+specificHeat*mH)*T1

numerator1/denominator1
numerator2/denominator2

    value = specificHeat*mH/(1+specificHeat*mH)*(TH-T1)*numerator/denominator;
    
end