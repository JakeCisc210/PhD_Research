function value = system_macro_utility(density,gamma,vLow,vHigh,T1,specificHeat)
% Takes density, gamma, vLow, vHigh
% Assume volume is adjustable

    arguments
        density = @(T) double_stunted_gaussian(T,250,50);
        gamma = @(T) double_stunted_gaussian_gamma(T,250,50);
        vLow = 200; % Maximum T for Cold Reservoir Collection in Kelvin
        vHigh = 300; % Minimum T for Heat Reservoir Collection in Kelvin
        T1 = 250;
        specificHeat = 2; % specific heat of reservoir / ( 3/2 N kB );      
    end

    if nargin < 6
        warning('\n%d/%d inputs provide for HeatEngine.system_macro_utility\n',nargin,6)
    end
    
    mC = gamma(vLow); % in kilograms   
    mH = gamma(1e6)-gamma(vHigh); % in kilograms, assume max temperature is 1e6
    
    averageIntegrand = @(T) T*density(T);
    TC = integral(averageIntegrand,0,vLow,'ArrayValued',true)/integral(density,0,vLow,'ArrayValued',true); % in Kelvin
    TH = integral(averageIntegrand,vHigh,1e6,'ArrayValued',true)/integral(density,vHigh,1e6,'ArrayValued',true); % in Kelvin  

    numerator = (specificHeat*mC+specificHeat*specificHeat*mC*mH)*(T1-TC)-specificHeat*mH*(TH-T1);
    denominator = (specificHeat*mC+specificHeat*specificHeat*mC*mH)*T1-specificHeat*mH*(TH-T1);
    value = 3/2*specificHeat*mH/(1+specificHeat*mH)*(TH-T1)*numerator/denominator;

end
