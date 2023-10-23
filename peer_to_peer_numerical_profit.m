function [profitMean,profitStDev] = peer_to_peer_numerical_profit(funct,functMax,x,numParticipants,numTrials,opt)
    arguments
        funct = @(p) exp(-power(p-.5,2)/2/power(.1,2))/sqrt(2*pi)/.1/erf(sqrt(2));
        functMax = 1/sqrt(2*pi)/.1/erf(sqrt(2));
        x = 2;
        numParticipants = 100000;
        numTrials = 1;
        opt.displayHistogram = 1;
        opt.displayConfidenceInterval = 1;
        opt.Center = .5;
        opt.maxSpread = .2; % Change to .5 after experiment
    end
    
    numParticipants = numParticipants-mod(numParticipants,4); % To allow both types of matching
    
    profitArray = zeros(1,numTrials);
    for ii = 1:numTrials  
        % fprintf('On Trial %d/%d\n',ii,numTrials)
        profit = 0;
        % Setting up the probabilities
        probabilityArray = ones(1,1000);
        for jj = 1:numParticipants
            probabilitySet = 0;
            counter = 1;
            while probabilitySet == 0 && counter < 1000
                p = rand();
                chance = rand();
                if abs(p-opt.Center) <= opt.maxSpread && chance < funct(p)/functMax 
                    probabilityArray(jj) = p;    
                    probabilitySet = 1;
                end
                counter = counter + 1;
            end
            if counter >= 1000; disp("Probalitity not set"); end         
        end

        probabilityArray = sort(probabilityArray);
    
        % Outside In Matching
        for jj = 1:numParticipants/4-1
            Pm = probabilityArray(jj);
            Pz = probabilityArray(numParticipants-jj+1);
            [~,~,~,~,Fee,~] = peer_to_peer(Pm,Pz,1,x);
            profit = profit+Fee;
        end
        
        % Split n' Pair Matching
        for jj = numParticipants/4:numParticipants/2
            Pm = probabilityArray(jj);
            Pz = probabilityArray(numParticipants/4+jj);
            [~,~,~,~,Fee,~] = peer_to_peer(Pm,Pz,1,x);
            profit = profit+Fee;
        end    
        
        if numTrials == 1 && opt.displayHistogram == 1
            figure
            title('Example Distribution')
            hold on
            functDomain = opt.Center-opt.maxSpread:.01:opt.Center+opt.maxSpread;
            histogram(probabilityArray,functDomain)
            plot(functDomain,numParticipants/100*funct(functDomain),'LineWidth',2)
            legend({'Numerical Distributon','Theoretical Distribution'})
            xlabel('Probability')
            ylabel('Quantity of People')
            myAxes = gca; myAxes.FontSize = 24; myAxes.FontWeight = 'bold';      
        end
            
        profitArray(ii) = profit/numParticipants;
    end
    
    profitMean = mean(profitArray);
    profitStDev = std(profitArray)/sqrt(numTrials);
    
    if opt.displayConfidenceInterval == 1
        fprintf('\nConfidence Interval [%g,%g]\n',profitMean-1.96*profitStDev,profitMean+1.96*profitStDev)
    end
end
        
        