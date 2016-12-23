classdef Simulated_data < Dataset
    %UNTITLED6 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Data
    end
    
    methods
        
        function obj = Simulated_data(Data)
            obj.Data = Data;
        end
        
        function [Agent, agentID, runID] = get_data(self, i_dataset)
            data_columns;   % Find out which columns contain what
            agent_rows = self.Data(:, AgentID_c) == i_dataset;
            Agent = self.Data(agent_rows, :);
            agentID = i_dataset;
            runID = nan;
        end
        
    end
    
end

