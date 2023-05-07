classdef ClassicalMoneyLine
   
    properties
        alphaMC
        betaMC
        paMC
        pbMC
        profitMC
        
        alphaNI
        betaNI
        paNI
        pbNI
        profitNI 
    end

    methods
        function obj = ClassicalMoneyLine()
            obj.alphaMC = -1;
            obj.betaMC = -1;
            obj.paMC = -1;
            obj.pbMC = -1;
            obj.profitMC = -1;
            
            obj.alphaNI = -1;
            obj.betaNI = -1;
            obj.paNI = -1;
            obj.pbNI = -1;
            obj.profitNI = -1;
        end
    end
    
end