classdef DatasetTest < matlab.unittest.TestCase
    %UNTITLED9 Summary of this class goes here
    %   execute with "result = run(TestSuite.fromClass(?DatasetTest))"
    
    properties
    end
    
    methods (Test)
        function testSimulatedData(testCase)
            n_params = 8;
            n_datasets = 5;
            n_trials = 10;
            sim_model = 'mb';
            common = 0.7;
            
            dataset = Simulated_data(n_datasets, n_trials, sim_model, common);
            
            [Agent, agentID, runID] = dataset.get_data(1);

            testCase.verifyEqual(agentID, 1);
            testCase.verifyEqual(runID, nan);
            all_zeros = all(Agent(1,:) == 0);
            testCase.verifyFalse(all_zeros);
        end
        
        function testRealData(testCase)
            file_dir = 'C:\Users\maria\MEGAsync\TrainingPlanningProject\TwoStepTask\Results\rawdata2016';   % Where is the original data stored?
            dataset = Real_data(file_dir);
            n_datasets = dataset.n_datasets;
            
            [Agent, agentID, runID] = dataset.get_data(1);

            testCase.verifyTrue(agentID > 100);
            testCase.verifyTrue(any(runID == 1:4));
            all_zeros = all(Agent(1,:) == 0);
            testCase.verifyFalse(all_zeros);
            testCase.verifyEqual(n_datasets, 266);
        end
    end
    
end

