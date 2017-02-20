classdef Genrec < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        file_name
        Data
    end
    
    methods
        
        function obj = Genrec(sim_model, fit_model, n_datasets, n_params)
            obj.file_name = name_genrec_file(sim_model, fit_model);
            obj.Data = zeros(n_datasets, 2 * n_params + 7);
        end
        
        function add_results(self, i_dataset, Agent, agentID, runID, fit_params, NLLBICAIC, sim_data)
            data_columns;
            genrec_columns;   % what info is located in which column?
            self.Data(i_dataset, [agentID_c run_c]) = [agentID runID];
            if ~strcmp(sim_data, 'real')
                self.Data(i_dataset, gen_aabblwpk_c) = Agent(1, par_c);
            end
            self.Data(i_dataset, rec_aabblwpk_c) = fit_params;   % Save fitted parameters (params) into the genrec rec paramater columns (aabblwpk)
            self.Data(i_dataset, NLLBICAIC_c) = NLLBICAIC;   % Save NLL, BIC, and AIC (NLLBICAIC) into the genrec NLLBICAIC columns (NLLBICAIC_c)
        end
        
        function save_data(self)
            genrec_dat = self.Data;
            save(self.file_name, 'genrec_dat')
        end
        
        function genrec_dat = read_data(self)
            genrec_dat = self.Data;
        end            
        
    end
    
end

