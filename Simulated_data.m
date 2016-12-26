classdef Simulated_data < Dataset
    %UNTITLED6 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        number
        Data
        sim_model
        sim_par
    end
    
    methods
        
        function obj = Simulated_data(sim_model, n_datasets, n_trials, common)
            obj.sim_model = sim_model;
            if nargin == 1
                load(['data_' sim_model '_agents.mat'])
                obj.number = length(unique(Data(1:end-1,1)));
                obj.Data = Data;
            else
                obj.number = n_datasets;
                model_parameters = define_model_parameters();
                obj.sim_par = model_parameters(model_ID(sim_model),:);
                obj.Data = simulate_task(obj.number, n_trials, obj.sim_par, common);
                Data = obj.Data;
                save(['data_' sim_model '_agents.mat'], 'Data')                
            end
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

