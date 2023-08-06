function [idealParameters,profitMax] = creeping_barrage_solver(profitFunct,constraintFunct,range,tol)

% For Macroscopic Matching

    arguments
        profitFunct = @(pa,pb) (pa-pb)*(pb-5)
        constraintFunct = @(pa,pb) 15 - pa - pb;
        range = [5 10];
        tol = 1e-6;
    end
    
    grainSize = diff(range)/1000;
   
    valueMesh = range(1):grainSize:range(2);
    
    profitMax = 0;
    idealParameters = [0 0];
    
    for lowIndex = 1:length(valueMesh)
        for highIndex = lowIndex:length(valueMesh)
            lowValue = valueMesh(lowIndex);
            highValue = valueMesh(highIndex);
            
            if abs(constraintFunct(highValue,lowValue)) <= tol
                if profitFunct(highValue,lowValue) > profitMax
                    profitMax = profitFunct(highValue,lowValue);
                    idealParameters = [highValue lowValue];
                end
            end
        end
    end
    
end
                    
                