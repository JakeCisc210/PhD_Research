classdef ClassicalMoneyLine
   
    properties
        alphaMC
        betaMC
        palphaMC
        pbetaMC
        profitMC
        
        alphaNI
        betaNI
        palphaNI
        pbetaNI
        profitNI 
    end

    methods
        function obj = ClassicalMoneyLine()
            obj.alphaMC = -1;
            obj.betaMC = -1;
            obj.palphaMC = -1;
            obj.pbetaMC = -1;
            obj.profitMC = -1;
            
            obj.alphaNI = -1;
            obj.betaNI = -1;
            obj.palphaNI = -1;
            obj.pbetaNI = -1;
            obj.profitNI = -1;
        end
    end
    
end