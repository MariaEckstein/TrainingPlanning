classdef ParameterFitting
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        fit_model
        fit_par
        pmin
        pmax
        par0
        n_fit
        n_params
        n_fmincon_iterations
        solver_algo
    end
    
    methods
        
        function obj = ParameterFitting(fit_model, n_fmincon_iterations, solver_algo)
            model_parameters = define_model_parameters();
            obj.fit_model = fit_model;
            obj.fit_par = model_parameters(model_ID(fit_model),:);
            [obj.pmin, obj.pmax, obj.par0, obj.n_fit, obj.n_params] = get_fmincon_stuff(obj.fit_par);
            obj.solver_algo = solver_algo;
            obj.n_fmincon_iterations = n_fmincon_iterations;
        end
        
        function [fit_params, function_value] = minimize_NLL(self, Agent, sim_data, common)
            object_fun = @(par)computeNLL(Agent, par, self.n_fit, 'NLL', common, sim_data);
            [fit_params, function_value] = find_params_that_minimize_NLL(object_fun, self.par0, self.pmin, self.pmax, self.n_fmincon_iterations, self.solver_algo);
        end
        
        function NLLBICAIC = compute_NLL(self, Agent, fit_params, sim_data, common)
            NLLBICAIC = computeNLL(Agent, fit_params, self.n_fit, 'all', common, sim_data);
        end
        
    end
    
end

