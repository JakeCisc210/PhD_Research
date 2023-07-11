function wout = make_otto_cycle(T1,gamma,mH,mC,TH,TC,opt)
% Wout in units of 3/2 N kB T

    arguments 
        T1 = 100; % in Kelvin
        gamma = 2; % specific heat of reservoir / ( 3/2 N kB )
        mH = 3; % in kilograms
        mC = 7; % in kilograms
        TH = 215; % in Kelvin
        TC = 75; % in Kelvin
        opt.V1 = 1;
        opt.numPoints = 400;
        opt.plotOn = 1;
    end
    
    opt.numPoints = 4*fix(opt.numPoints/4);
    valuesV = zeros(1,opt.numPoints); valuesP = zeros(1,opt.numPoints);
    
    % Part 1:
    T2 = (T1+gamma*mH*TH)/(1+gamma*mH);
    for ii = 1:fix(opt.numPoints/4)
        pointT = T1 + (ii-1)/fix(opt.numPoints/4)*(T2-T1);
        valuesV(ii) = opt.V1;
        valuesP(ii) = pointT/valuesV(ii); % P in terms of N kB T / meters^3)
    end
    
    % Part 2:
    V2 = power( (1+gamma*mH)*gamma*mC*TC/(gamma*mC*T1+gamma*gamma*mC*mH*T1-gamma*mH*(TH-T1)), 3/2)*V1;
    for ii = 1:fix(opt.numPoints/4)
        valuesV(ii+fix(opt.numPoints/4)) = V1 + (ii-1)/fix(opt.numPoints/4)*(V2-V1);
        valuesP(ii+fix(opt.numPoints/4)) = valuesP(ii)*power(valuesV(ii+fix(opt.numPoints/4))/opt.V1,5/3); % P in terms of N kB T / meters^3)
    end    
end    
    
    
    
    
    