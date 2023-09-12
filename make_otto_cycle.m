function make_otto_cycle(T1,gamma,mH,mC,TH,TC,opt)
% Wout in units of N kB

    arguments 
        T1 = 100; % in Kelvin
        gamma = 2; % specific heat of reservoir / ( 3/2 N kB )
        mH = 3; % in kilograms
        mC = 7; % in kilograms
        TH = 1000; % in Kelvin
        TC = 75; % in Kelvin
        opt.V1 = 1;
        opt.numPoints = 400;
        opt.plotOn = 1;
    end
    
    V1 = opt.V1;
    opt.numPoints = 4*fix(opt.numPoints/4);
    valuesV = zeros(1,opt.numPoints); valuesP = zeros(1,opt.numPoints);  
    
    % Phase 1 -> 2:
    T2 = (T1+gamma*mH*TH)/(1+gamma*mH);
    for ii = 1:fix(opt.numPoints/4)
        pointT = T1 + (ii-1)/fix(opt.numPoints/4)*(T2-T1);
        valuesV(ii) = V1;
        valuesP(ii) = pointT/valuesV(ii); % P in terms of N kB T / meters^3)
    end
    
    % Phase 2 -> 3:
    V2 = power( (1+gamma*mH)*gamma*mC*TC/(gamma*mC*T1+gamma*gamma*mC*mH*T1-gamma*mH*(TH-T1)), -3/2)*V1;
    P2 = valuesP(opt.numPoints/4);
    for ii = 1:fix(opt.numPoints/4)
        valuesV(ii+fix(opt.numPoints/4)) = V1 + (ii-1)/fix(opt.numPoints/4)*(V2-V1);
        valuesP(ii+fix(opt.numPoints/4)) = P2*power(V1/valuesV(ii+fix(opt.numPoints/4)),5/3); % P in terms of N kB T / meters^3)
    end    
       
    % Phase 3 -> 4:
    T3 = power(V1/V2,2/3)*T2;
    T4 = (T3+gamma*mC*TC)/(1+gamma*mC);
    for ii = 1:fix(opt.numPoints/4)
        pointT = T3 + (ii-1)/fix(opt.numPoints/4)*(T4-T3);
        valuesV(ii+2*fix(opt.numPoints/4)) = V2;
        valuesP(ii+2*fix(opt.numPoints/4)) = pointT/valuesV(ii+2*fix(opt.numPoints/4)); % P in terms of N kB T / meters^3)
    end
    
    % Phase 4 -> 1
    P4 = valuesP(3*opt.numPoints/4);
    for ii = 1:fix(opt.numPoints/4)
        valuesV(ii+3*fix(opt.numPoints/4)) = V2 + (ii-1)/fix(opt.numPoints/4)*(V1-V2);
        valuesP(ii+3*fix(opt.numPoints/4)) = P4*power(V2/valuesV(ii+3*fix(opt.numPoints/4)),5/3); % P in terms of N kB T / meters^3)
    end     
    
    myFigure = uifigure('Name','Otto Cycyle','Position',[200 75 1200 670]);
    myAxes = uiaxes(myFigure,'Position',[50 100 1100 500]);
    myAxes.FontSize = 20; myAxes.FontWeight = 'bold'; myAxes.LineWidth = 2; 
    myAxes.XAxis.Label.String = 'Volume (m^3)'; myAxes.YAxis.Label.String = 'Pressure (N kB T / m^3)';
    myAxes.XLim = [0,V2+1]; myAxes.YLim = [-15,max(valuesP)+15];
    plot(myAxes,valuesV,valuesP,'LineWidth',2,'Color',[1 0 0])
    title('Otto Cycle')
    
    numerator = (gamma*mC+gamma*gamma*mC*mH)*(T1-TC)-gamma*mH*(TH-T1);
    denominator = (gamma*mC+gamma*gamma*mC*mH)*T1-gamma*mH*(TH-T1);
    woutTheoretical = 3/2*gamma*mH/(1+gamma*mH)*(TH-T1)*numerator/denominator;
    fprintf('Theoretical Wout = %g\n',woutTheoretical)
    
    woutNumericalUp = 0;
    woutNumericalDown = 0;
    h = 1/fix(opt.numPoints/4)*(V2-V1);
    for ii = 1:fix(opt.numPoints/4)
        woutNumericalUp = woutNumericalUp + h*(valuesP(ii+fix(opt.numPoints/4))-valuesP(ii+3*fix(opt.numPoints/4)));
        woutNumericalDown = woutNumericalDown + h*(valuesP(ii-1+fix(opt.numPoints/4))-valuesP(ii-1+3*fix(opt.numPoints/4)));
    end
    fprintf('Numerical Wout in [%g, %g]\n',woutNumericalUp,woutNumericalDown)
end    
    
    
    
    
    