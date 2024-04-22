function value = system_micro_utility(vLow,vHigh,x)
    denominator = max(vLow+vHigh,2-vLow-vHigh) + x*max(vHigh,1-vLow);
    value = x*(vHigh-vLow)/denominator;
end