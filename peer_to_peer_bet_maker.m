function peer2peerBetArray = peer_to_peer_bet_maker(playerBetArray,x)
    % playerBetArray = length n cell array of playerBet structs
    
    % playerBet is a struct with the following fields:
        % probability - in range [0 1], up to four decimal places
        % maxBid
        % playerName 
        % betID - unique ID number for bet in system
        
        
    numPlayers = length(playerBetArray);
    probArray = zeros(1,numPlayers);
    for ii = 1:numPlayers
        playerBet = playerBetArray{ii};
        probArray(ii) = playerBet.probability;
    end
    
    [~,sortedIndeces] = sort(probArray);
    
    peer2peerBetArray = cell(1,fix(numPlayers/2));
    for ii = 1:fix(numPlayers/2)
        index1 = sortedIndeces(ii);
        index2 = sortedIndeces(numPlayers+1-ii);
        playerBet1 = playerBetArray{index1};
        playerBet2 = playerBetArray{index2};
        peer2peerBet.player1Name = playerBet1.playerName;
        peer2peerBet.player2Name = playerBet2.playerName;
        peer2peerBet.player1Prob = playerBet1.probability;
        peer2peerBet.player2Prob =  playerBet2.probability;
        [WinsWith1,MasonPays,ZackPays,~,Fee,~] = peer_to_peer(playerBet1.probability,playerBet2.probability,MaxBid,x);        
        peer2peerBet.player1Pays = MasonPays;
        peer2peerBet.player2Name = ZackPays;
        if strcmpi(WinsWith1,'Mason')
            peer2peerBet.winsWithFocal = 1;
        elseif strcmpi(WinsWith1,'Zack')
            peer2peerBet.winsWithFocal = 2;
        else 
            error('No match with WinsWith1 outcome')
        end
        peer2peerBet.fee = Fee;
        peer2peerBetArray{ii} = peer2peerBet;
    end
    
end