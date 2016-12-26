classdef Real_data < Dataset
    %UNTITLED8 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        number
        sim_model
        file_dir
        file_index
        files
        sim_data
    end
    
    methods
        
        function obj = Real_data(file_dir)
            obj.file_dir = file_dir;
            obj.files = dir(file_dir);
            obj.file_index = find(~[obj.files.isdir]);
            obj.number = length(obj.file_index);
            obj.sim_model = nan;
            obj.sim_data = 'load';
        end
        
        function [Agent, agentID, runID] = get_data(self, i_dataset)
            file_name = self.files(self.file_index(i_dataset)).name;
            [Agent, agentID, runID] = get_real_data(self.file_dir, file_name);
        end
        
    end
    
end

