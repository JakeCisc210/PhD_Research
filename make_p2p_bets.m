function BetMatrix = make_p2p_bets(InputMatrix,MaxBid,Percent)
% Percent -  Fee as percentage of ExpectedProfit (in decimal form)
% BetMatrix ->
%  -First row is Player 1 name
%  -Second row is Player 1 payment
%  -Third row is Player 2 name
%  -Fourth row is Player 2 payment
%  -Fifth row is PLayers' Winnings Pot
% InputMatrix - Matrix whose first row is probabilities, and whose second row is the corresponding names
% MaxBid - Maximum value for MasonPays or ZackPays

    InputMatrix = transpose(InputMatrix);
    InputMatrix = sortrows(InputMatrix);
    InputMatrix = transpose(InputMatrix);

    prob_array = InputMatrix(1,:);
    name_array = InputMatrix(2,:);
    
    if mod(length(prob_array),2) ~= 0
        mid_index = (length(prob_array)-1)/2;
        fprintf(name_array(mid_index) + " can't participate in the bet.");
        prob_array(mid_index) = [];
        name_array(mid_index) = [];
    end
    
    BetMatrix = ["Aa";1;"Bb";2;3];
    for n = 1:length(prob_array)/2
        p1 = str2double(prob_array(n));
        p2 = str2double(prob_array(length(prob_array)+1-n));
        BetMatrix(1,n) = name_array(n);
        BetMatrix(3,n) = name_array(length(prob_array)+1-n);
        [~,MasonPays,ZackPays,Winnings,~,~] = WinWin(p1,p2,MaxBid,Percent);
        BetMatrix(2,n) = MasonPays;
        BetMatrix(4,n) = ZackPays;
        BetMatrix(5,n) = Winnings;
    end    
end

% Added Comment for Git Check