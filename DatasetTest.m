classdef DatasetTest < matlab.unittest.TestCase
    
    % load test suite with "import matlab.unittest.TestSuite"
    % run tests with "result = run(TestSuite.fromClass(?DatasetTest))"
    
    properties
    end
    
    methods (Test)
        function testSimulatedData(testCase)
            n_params = 8;
            n_datasets = 5;
            n_trials = 10;
            sim_model = 'mb';
            common = 0.7;
            
            % Simulate data
            dataset = Simulated_data(sim_model, n_datasets, n_trials, common);
            [Agent, agentID, runID] = dataset.get_data(1);

            testCase.verifyEqual(agentID, 1);
            testCase.verifyEqual(runID, nan);
            all_zeros = all(Agent(1,:) == 0);
            testCase.verifyFalse(all_zeros);

            % Load data
            sim_model = 'mb';
            load(['data_' sim_model '_agents.mat'])
            
            dataset = Simulated_data(sim_model);
            [Agent, agentID, runID] = dataset.get_data(1);

            testCase.verifyEqual(agentID, 1);
            testCase.verifyEqual(runID, nan);
            all_zeros = all(Agent(1,:) == 0);
            testCase.verifyFalse(all_zeros);
        end
                
        function testRealData(testCase)
            file_dir = 'C:\Users\maria\MEGAsync\TrainingPlanningProject\TwoStepTask\Results\rawdata2016';   % Where is the original data stored?
            dataset = Real_data(file_dir);
            n_datasets = dataset.number;
            
            % Load human data
            [Agent, agentID, runID] = dataset.get_data(1);
            [Agent, agentID, runID] = dataset.get_data(2);

            testCase.verifyTrue(agentID > 100);
            testCase.verifyTrue(any(runID == 1:4));
            all_zeros = all(Agent(1,:) == 0);
            testCase.verifyFalse(all_zeros);
            all_zeros = all(Agent(1,:) == 0);
            testCase.verifyFalse(all_zeros);
            testCase.verifyEqual(n_datasets, 266);
        end
        
        function testGenrec(testCase)
            common = 0.7;
            sim_data = 'load';
            sim_model = 'mb';
            fit_model = 'mb';
            n_datasets = 5;
            n_trials = 5;
            n_params = 8;
            i_dataset = 1;
            dataset = Simulated_data(sim_model, n_datasets, n_trials, common);
            [Agent, agentID, runID] = dataset.get_data(i_dataset);
            fit_params = -1 * ones(1, n_params);
            NLLBICAIC = 100 * ones(1, 3);
            
            % Create genrec object
            genrec = Genrec(sim_model, fit_model, n_datasets, n_params);
            testCase.verifyEqual(genrec.file_name(1:6), 'genrec');
            genrec_size = [n_datasets,  (2 * n_params + 7)];
            testCase.verifyEqual(size(genrec.Data), genrec_size);
            
            % Save results to genrec
            genrec.add_results(i_dataset, Agent, agentID, runID, fit_params, NLLBICAIC, sim_data);
            genrec.add_results(i_dataset + 1, Agent, agentID, runID, fit_params, NLLBICAIC, sim_data);
            testCase.verifyFalse(all(genrec.Data(i_dataset, :) == 0))
            testCase.verifyFalse(all(genrec.Data(i_dataset + 1, :) == 0))
            
            % Save genrec to disk
            genrec.save_data
            load(genrec.file_name)
            testCase.verifyEqual(size(genrec_dat), genrec_size);
            testCase.verifyFalse(all(genrec_dat(i_dataset, :) == 0))
        end
        
        function testParameterFitting(testCase)
            fit_model = 'mf';
            sim_data = 'load';
            n_params = 8;
            n_fmincon_iterations = 3;
            solver_algo = 'fmincon';
            common = 0.7;
            for sim_mod = {'mb', 'mf', 'hyb'}
                sim_model = strjoin(sim_mod);
                load(['data_' sim_model '_agents.mat'])
                dataset = Simulated_data(sim_model);
                [Agent, ~, ~] = dataset.get_data(1);

                % Create parameterFitting object
                parameterFitting = ParameterFitting(fit_model, n_fmincon_iterations, solver_algo);
                testCase.verifyTrue(strcmp(parameterFitting.fit_model, fit_model))
                testCase.verifyFalse(all(parameterFitting.fit_par == ones(1, 8)))

                % Minimize neg. log. lik.
                [fit_params, ~] = parameterFitting.minimize_NLL(Agent, sim_data, common);
                minimized_parameters = fit_params(parameterFitting.fit_par == -1);
                testCase.verifyTrue(all(fit_params >= zeros(1, n_params) & fit_params <= ones(1, n_params)))
%                 testCase.verifyTrue(all(minimized_parameters > 0));

                % Calculate BIC & AIC
                NLLBICAIC = parameterFitting.compute_NLL(Agent, fit_params, sim_data, common);
                testCase.verifyTrue(all(NLLBICAIC > zeros(1, 3)));
            end
        end
        
    end
    
end

