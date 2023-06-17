function [profitMean,profitStDev] = peer_to_peer_numerical_profit(funct,functMax,x,numParticipants,numTrials)
    arguments
        funct = @(p) exp(-power(p-.5)/2/power(.1,2)) / sqrt(2*pi) / .1;
        functMax = 1/  sqrt(2*pi) / .1;
        x = 2;
        numParticipants = 1000;
        numTrials = 30;
    end
    
    numParticipants = mod(numParticipants,4); % To allow both types of matching
    
    profitArray = zeros(1,numTrials);
    for ii = 1:numTrials   
        profit = 0;
        % Setting up the probabilities
        probabilityArray = ones(1,1000);
        for jj = 1:numParticipants
            probabilitySet = 0;
            counter = 1;
            while probabilitySet == 0 && counter < 1000
                p = rand();
                chance = rand();
                if chance < funct(p)/functMax;  probabilityArray(jj) = p; end
                counter = counter + 1;
            end
            if counter >= 1000; disp("Probalitity not set"); end         
        end

        probabilityArray = sort(probabilityArray);
    
        % Outside In Matching
        for jj = 1:numParticpants/4-1
            Pm = probabilityArray(jj);
            Pz = probabilityArray(numParticipants-jj);
            [~,~,~,~,Fee,~] = peer_to_peer(Pm,Pz,1,x);
            profit = profit+Fee;
        end
        
        % Split n' Pair Matching
        for jj = numParticpants/4:numParticpants/2
            Pm = probabilityArray(jj);
            Pz = probabilityArray(numParticpants/4+jj);
            [~,~,~,~,Fee,~] = peer_to_peer(Pm,Pz,1,x);
            profit = profit+Fee;
        end    
        profitArray(ii) = profit;
    end
    profitMean = mean(profitArray);
    profitStDev = std(profitArray);
end
        
        