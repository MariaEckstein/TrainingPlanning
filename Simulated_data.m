classdef Simulated_data < Dataset
    %UNTITLED6 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Data
        sim_par
    end
    
    methods
        
        function obj = Simulated_data(n_datasets, n_trials, sim_model, common)
            
            % Which parameters are free in the simulation (-1) and which are fixed (value)?
            model_parameters = define_model_parameters();
            obj.sim_par = model_parameters(model_ID(sim_model),:);
            obj.Data = simulate_task(n_datasets, n_trials, obj.sim_par, common);
        end
        
        function [Agent, agentID, runID] = get_data(self, i_dataset)
            n_params = 8;
            data_columns;   % Find out which columns contain what
            agent_rows = self.Data(:, AgentID_c) == i_dataset;
            Agent = self.Data(agent_rows, :);
            agentID = i_dataset;
            runID = nan;
        end
        
    end
    
end

