classdef Real_data < Dataset
    %UNTITLED8 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        file_dir
        file_index
        files
    end
    
    methods
        
        function obj = Real_data(file_dir, file_index, files)
            obj.file_dir = file_dir;
            obj.file_index = file_index;
            obj.files = files;
        end
        
        function [Agent, agentID, runID] = get_data(self, i_dataset)
            file_name = self.files(self.file_index(i_dataset)).name;
            [Agent, agentID, runID] = get_real_data(self.file_dir, file_name);
        end
        
    end
    
end

