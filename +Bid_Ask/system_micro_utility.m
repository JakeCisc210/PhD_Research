function utility = system_micro_utility(vLow,vHigh,x)
    utility = x*(vHigh-vLow)/(2+x);
end