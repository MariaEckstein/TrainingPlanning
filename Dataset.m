classdef (Abstract) Dataset
    %UNTITLED7 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Abstract)
        number
    end
    
    methods (Abstract)
        get_data(self, i_dataset)
    end
    
end

