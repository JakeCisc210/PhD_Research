function otto_cycle(T1,specificHeat,mH,mC,TH,TC,opt)
% Wout in units of N kB

    arguments 
        T1 = 250; % in Kelvin
        specificHeat = 2; % specific heat of reservoir / ( 3/2 N kB )
        mH = 3; % in kilograms
        mC = 7; % in kilograms
        TH = 300; % in Kelvin
        TC = 200; % in Kelvin
        opt.V1 = 1;
        opt.numPoints = 400;
        opt.plotOn = 1;
    end
    
    V1 = opt.V1;
    opt.numPoints = 4*fix(opt.numPoints/4);
    valuesV = zeros(1,opt.numPoints); valuesP = zeros(1,opt.numPoints); 
    phaseNumbers = zeros(1,opt.numPoints); 
    
    % Phase 1 -> 2:
    T2 = (T1+specificHeat*mH*TH)/(1+specificHeat*mH);
    for ii = 1:fix(opt.numPoints/4)
        pointT = T1 + (ii-1)/fix(opt.numPoints/4)*(T2-T1);
        valuesV(ii) = V1;
        valuesP(ii) = pointT/valuesV(ii); % P in terms of N kB T / meters^3)
        phaseNumbers(ii) = 1;
    end
    
    % Phase 2 -> 3:
    V2 = power( (1+specificHeat*mH)*specificHeat*mC*TC/(specificHeat*mC*T1+specificHeat*specificHeat*mC*mH*T1-specificHeat*mH*(TH-T1)), -3/2)*V1;
    P2 = valuesP(opt.numPoints/4);
    for ii = 1:fix(opt.numPoints/4)
        valuesV(ii+fix(opt.numPoints/4)) = V1 + (ii-1)/fix(opt.numPoints/4)*(V2-V1);
        valuesP(ii+fix(opt.numPoints/4)) = P2*power(V1/valuesV(ii+fix(opt.numPoints/4)),5/3); % P in terms of N kB T / meters^3)
        phaseNumbers(ii+fix(opt.numPoints/4)) = 2;
    end    
       
    % Phase 3 -> 4:
    T3 = power(V1/V2,2/3)*T2;
    T4 = (T3+specificHeat*mC*TC)/(1+specificHeat*mC);
    for ii = 1:fix(opt.numPoints/4)
        pointT = T3 + (ii-1)/fix(opt.numPoints/4)*(T4-T3);
        valuesV(ii+2*fix(opt.numPoints/4)) = V2;
        valuesP(ii+2*fix(opt.numPoints/4)) = pointT/valuesV(ii+2*fix(opt.numPoints/4)); % P in terms of N kB T / meters^3)
        phaseNumbers(ii+2*fix(opt.numPoints/4)) = 3;
    end
    
    % Phase 4 -> 1
    P4 = valuesP(3*opt.numPoints/4);
    for ii = 1:fix(opt.numPoints/4)
        valuesV(ii+3*fix(opt.numPoints/4)) = V2 + (ii-1)/fix(opt.numPoints/4)*(V1-V2);
        valuesP(ii+3*fix(opt.numPoints/4)) = P4*power(V2/valuesV(ii+3*fix(opt.numPoints/4)),5/3); % P in terms of N kB T / meters^3)
        phaseNumbers(ii+3*fix(opt.numPoints/4)) = 4;
    end     
    
    figure('Name','Otto Cycle','Position',[200 75 1200 670]); hold on
    myAxes = gca;
    myAxes.FontSize = 20; myAxes.FontWeight = 'bold'; myAxes.LineWidth = 2; 
    xlabel('Volume (m^3)'); ylabel('Pressure (N kB T / m^3)');
    xlim([0,V2+1]); ylim([-15,max(valuesP)+15]);

    phaseColors = {[1 0 0],[1 165/255 0],[0 0 1],[1 1 0]};
    for ii = 1:4
        plot(myAxes,valuesV(phaseNumbers==ii),valuesP(phaseNumbers==ii),'Color',phaseColors{ii},'LineWidth',2)
    end

    % plot(myAxes,valuesV,valuesP,'LineWidth',2,'Color',[1 0 0])
    title('Otto Cycle')
    
    numerator = (specificHeat*mC+specificHeat*specificHeat*mC*mH)*(T1-TC)-specificHeat*mH*(TH-T1);
    denominator = (specificHeat*mC+specificHeat*specificHeat*mC*mH)*T1-specificHeat*mH*(TH-T1);
    woutTheoretical = 3/2*specificHeat*mH/(1+specificHeat*mH)*(TH-T1)*numerator/denominator;
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
    
    
    
    
    