Heat_Engine.system_micro_utility(vLow,vHigh,T1,specificHeat,.05,.05)
Heat_Engine.system_micro_utility(vLow,vHigh,T1,specificHeat,.5,.5)

% Not proportional!!!!
% Do we recover proportional like behavior when we 'run down the
% reservoirs' (keep cycling until Heat Cycle is no longer 'profitable' in
% energy)???



%% Set Up Temperature Mass Density Function and Gamma
mass_temperature_density = @(T) double_stunted_gaussian(T,250,50); % Better word for mass temperature
% mass_temperature_density = @(T) .5*((T-200)<5) + .5*((T-300)<5);

% mass_temperature_density(270) %???

gamma = @(T) double_stunted_gaussian_gamma(T,250,50);
gamma(350)

T1 = 250;
specificHeat = 2; % specific heat of reservoir / ( 3/2 N kB );  

s_mac_u = @(vLow,vHigh) Heat_Engine.system_macro_utility(mass_temperature_density,gamma,vLow,vHigh,T1,specificHeat);
p_c = @(vLow,vHigh) Heat_Engine.prime_constraint(mass_temperature_density,gamma,vLow,vHigh);

% Macroscopic
[vL,vH,profitMax] = Numerical.solver(s_mac_u,p_c,[150,350],.03,'grainSize',5)
Heat_Engine.system_micro_utility(200,300,T1,specificHeat,.5,.5)

% Microscopic
numTrials = 100;
numParticipants = 1000;
functMax = mass_temperature_density(250);
mC = 1/1000;
mH = 1/1000;

workArray = zeros(1,numTrials);
negativeWorkPairings = zeros(1,numTrials);
for ii = 1:numTrials
    totalWork = 0;
    % Setting up the probabilities
    temperatureArray = ones(1,numParticipants);
    for jj = 1:numParticipants
        temperatureSet = 0;
        counter = 1;
        while temperatureSet == 0 && counter < 1000
            T = rand()*200+150;
            chance = rand();
            if chance < mass_temperature_density(T)/functMax
                temperatureArray(jj) = T;
                temperatureSet = 1;
            end
            counter = counter + 1;
        end
        if counter >= 1000; disp("Probalitity not set"); end
    end
    
    temperatureArray = sort(temperatureArray);
    
    % Outside In Matching
    for jj = 1:numParticipants/2
        vLow = temperatureArray(jj);
        vHigh = temperatureArray(numParticipants-jj+1);
        localWork = Heat_Engine.system_micro_utility(vLow,vHigh,T1,specificHeat,mC,mH);

        if localWork < 0
            negativeWorkPairings(ii) = negativeWorkPairings(ii) + 1;
            % fprintf('Negative Work with TCbuffer = %.4g, THbuffer = %.4g, T1 = %d\n',vLow,vHigh,T1)
        else
            totalWork = totalWork+localWork;
        end

    end
    
    workArray(ii) = totalWork/numParticipants;
end

workMean = mean(workArray);
workStDev = std(workArray)/sqrt(numTrials);

fprintf('Peer to Peer:\n')
fprintf('Confidence Interval [%g,%g]\n',workMean-1.96*workStDev,workMean+1.96*workStDev)
fprintf('Negative Work Pairings: %.3g/%g\n',mean(negativeWorkPairings),numParticipants/2)



