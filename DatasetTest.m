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
            dataset = Simulated_data(sim_model, n_trials, common);
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
        
        function testsimulate_task(testCase)
            common = 0.7;
            n_agents = 10;
            n_trials = 200;
            data_columns
            
            % Simulate agents whose decision only depend on key repetition
            % and choice repetition, NOT on action values
            par = [0.5 0.5 0 0 0 0.5 1 1];   % k_par and p_par are 1; beta = 0; -> only key repetition and choice repetition have an influence, not values!
            Data = simulate_task(n_agents, n_trials, par, common);
            Data = Data(1:end-1,:);
            
            fractals1_12 = Data(:,frac1_p(1)) == 1;
            fractals1_21 = Data(:,frac1_p(1)) == 2;
            key1_left = Data(:,key1_c) == 1;
            prev_key1_left = [0; key1_left(1:end-1)];
            prev_key1_right = 1 - prev_key1_left;
            frac1_1 = Data(:,frac1_c) == 1;
            prev_frac1_1 = [0; frac1_1(1:end-1)];
            prev_frac1_2 = 1 - prev_frac1_1;
            
            % Look at trials, in which agents should choose left
            choose_left = (fractals1_12 & prev_key1_left & prev_frac1_1) | ...
                          (fractals1_21 & prev_key1_left & prev_frac1_2);
            
            testCase.verifyTrue(round(mean(Data(choose_left(2:end), key1_c))) == 1);

            % Agents should choose right
            choose_right = (fractals1_12 & prev_key1_right & prev_frac1_2) | ...
                           (fractals1_21 & prev_key1_right & prev_frac1_1);
            
            testCase.verifyTrue(round(mean(Data(choose_right(2:end),key1_c))) == 2);

            choose_frac1 = (fractals1_12 & prev_key1_left & prev_frac1_1) | ...
                           (fractals1_21 & prev_key1_right & prev_frac1_1);

            testCase.verifyTrue(round(mean(Data(choose_frac1(2:end),frac1_c))) == 1);

            choose_frac2 = (fractals1_12 & prev_key1_right & prev_frac1_2) | ...
                           (fractals1_21 & prev_key1_left & prev_frac1_2);

            testCase.verifyTrue(round(mean(Data(choose_frac2(2:end), frac1_c))) == 2);

            % Key repetition and choice repetition balance each other
            undetermined = (fractals1_12 & prev_key1_right & prev_frac1_1) | ...
                           (fractals1_21 & prev_key1_right & prev_frac1_2) | ...
                           (fractals1_12 & prev_key1_left & prev_frac1_2) | ...
                           (fractals1_21 & prev_key1_left & prev_frac1_1);
            
            testCase.verifyTrue(mean(Data(undetermined(2:end),key1_c)) > 1.3);
            testCase.verifyTrue(mean(Data(undetermined(2:end),frac1_c)) > 1.3);
            
            % Compute BIC & AIC for these perfect agents
            n_fit = n_trials;
            output = 'all';
            data_type = 'sim';
            NLLBICAICData = computeNLL(Data, par, n_fit, output, common, data_type);
            BICData = NLLBICAICData(2);
            
            %%% To test computeNLL, I could run computeNLL on the agents
            %%% just created and on agents with random behavior (just a
            %%% data frame with random 1's and 2's) and check if the BIC
            %%% and AIC are smaller for the created than randomized agents
            
            randData = zeros(n_agents * n_trials, 40);
            randData(:, frac1_c) = randsample([1 2], n_agents * n_trials, true);
            randData(:, frac1_p(1)) = randsample([1 2], n_agents * n_trials, true);
            randData(:, frac1_p(2)) = -(randData(:, frac1_p(1)) - 3);
            randData(:, key1_c) = randsample([1 2], n_agents * n_trials, true);
            randData(:, key2_c) = randsample([1 2], n_agents * n_trials, true);
            randData(:, frac2_c) = randsample(1:4, n_agents * n_trials, true);
            randData(:, frac2_p(1)) = randsample(1:4, n_agents * n_trials, true);
            fill = randData(:, frac2_p(1)) - 1;
            fill(fill == 2) = 4;
            fill(fill == 0) = 2;
            randData(:, frac2_p(2)) = fill;
            
            n_fit = n_trials;
            output = 'all';
            data_type = 'sim';
            NLLBICAICRand = computeNLL(randData, par, n_fit, output, common, data_type);
            BICRand = NLLBICAICRand(2);
            
            testCase.verifyTrue(BICData < BICRand);
            
            
            % Simulate agents whose decision only depend on mf VALUES
            par = [0.5 0.5 1 1 0 0 0.5 0.5];   % beta = 1; k_par and p_par = 0 -> only values influence choice!
            mfData = simulate_task(n_agents, n_trials, par, common);
            mfData = mfData(1:end-1,:);
            
            frac1_1_high = mfData(:,Qmf1_c(1)) > (mfData(:,Qmf1_c(2)) + 0.3);
            frac1_2_high = mfData(:,Qmf1_c(2)) > (mfData(:,Qmf1_c(1)) + 0.3);
            frac1_12_similar = ~(frac1_1_high | frac1_2_high);
            
            % Look at trials, in which agents should choose left
            testCase.verifyTrue(round(mean(mfData(frac1_1_high, frac1_c))) == 1);   % frac1 is selected most of the time, frac2 barely
            
            % Look at trials, in which agents should choose right
            testCase.verifyTrue(round(mean(mfData(frac1_2_high, frac1_c))) == 2);   % frac2 is selected most of the time, frac1 barely
            
            % Look at trials, in which agents should be uncertain
            fracs_chosen = mean(mfData(frac1_12_similar, frac1_c));
            testCase.verifyTrue(fracs_chosen > 1.4 & fracs_chosen < 1.6);   % frac2 and frac1 are selected equally often
            
        end
                
        function testRealData2015(testCase)
            data_year = 2015;
            [~, ~, file_dir] = determine_location_specifics('home', 12, data_year);
            dataset = Real_data(file_dir, data_year);
            [Agent, agentID, runID] = dataset.get_data(1);
            [Agent, agentID, runID] = dataset.get_data(dataset.number);

            testCase.verifyTrue(any(runID == 2:4));
            testCase.verifyTrue(any(agentID > 0));
            all_zeros = all(Agent(1,:) == 0);
            testCase.verifyFalse(all_zeros);
        end
        
        function testRealData2016(testCase)
            data_year = 2016;
            [~, ~, file_dir] = determine_location_specifics('home', 12, data_year);
            dataset = Real_data(file_dir, data_year);
            [Agent, agentID, runID] = dataset.get_data(1);
            [Agent, agentID, runID] = dataset.get_data(dataset.number);

            testCase.verifyTrue(any(runID == 1:4));
            testCase.verifyTrue(any(agentID > 100));
            all_zeros = all(Agent(1,:) == 0);
            testCase.verifyFalse(all_zeros);
        end
        
        function testGenrec(testCase)
            common = 0.7;
            sim_data = 'load';
            sim_model = 'mb';
            fit_model = 'mb';
            n_fit = 5;
            n_datasets = 5;
            n_trials = 5;
            n_params = 8;
            i_dataset = 1;
            dataset = Simulated_data(sim_model, n_trials, common);
            [Agent, agentID, runID] = dataset.get_data(i_dataset);
            fit_params = -1 * ones(1, n_params);
            NLLBICAIC = 100 * ones(1, 3);
            
            % Create genrec object
            genrec = Genrec(sim_model, fit_model, n_datasets, n_params);
            testCase.verifyEqual(genrec.file_name(1:6), 'genrec');
            genrec_size = [n_datasets,  (2 * n_params + 7)];
            testCase.verifyEqual(size(genrec.Data), genrec_size);
            
            % Save results to genrec
            genrec.add_results(i_dataset, Agent, agentID, runID, fit_params, NLLBICAIC, sim_data, n_fit);
            genrec.add_results(i_dataset + 1, Agent, agentID, runID, fit_params, NLLBICAIC, sim_data, n_fit);
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
                testCase.verifyTrue(all(fit_params >= zeros(1, n_params) & fit_params <= ones(1, n_params)))

                % Calculate BIC & AIC
                NLLBICAIC = parameterFitting.compute_NLL(Agent, fit_params, sim_data, common);
                testCase.verifyTrue(all(NLLBICAIC > zeros(1, 3)));
            end
        end
        
    end
    
end

