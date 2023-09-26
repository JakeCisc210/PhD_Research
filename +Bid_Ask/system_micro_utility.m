function value = system_micro_utility(vLow,vHigh,x)
    value = x*(vHigh-vLow)/(2+x);
end