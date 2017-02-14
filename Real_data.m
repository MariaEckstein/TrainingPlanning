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
        data_year
    end
    
    methods
        
        function obj = Real_data(file_dir, data_year)
            obj.file_dir = file_dir;
            obj.files = dir(file_dir);
            obj.file_index = find(~[obj.files.isdir]);
            obj.number = length(obj.file_index);
            obj.sim_model = nan;
            obj.sim_data = 'load';
            obj.data_year = data_year;
        end
        
        function [Agent, agentID, runID] = get_data(self, i_dataset)
            real_data_columns;   % Find out which columns contain what
            file_name = self.files(self.file_index(i_dataset)).name;
            load([self.file_dir '/' file_name]);
            Agent = params.user.log;
            Agent(:, frac2_c) = Agent(:, frac2_c) - 2;   % stage-2 fractals are numbered 3-6 in the real data, but need to be 1-4 for my analysis
            complete_data_rows = ~isnan(Agent(:, key1_c)) & ~isnan(Agent(:, key2_c)) & Agent(:, frac2_c) > 0;
            Agent = Agent(complete_data_rows,:);
            if self.data_year == 2015
                agentID =  file_name(8:9);
                runID = 2 * str2num(file_name(10));   % reason for '2 *': participants only played 2-step twice, at the end of each session. that corresponds to runs 2 and 4 in the new data
            else
                agentID =  file_name(length(file_name)-9:length(file_name)-7);
                runID = file_name(length(file_name)-4);
            end
            agentID = str2double(agentID);
            switch runID
                case 'A'
                    runID = 1;
                case 'B'
                    runID = 2;
                case 'C'
                    runID = 3;
                case 'D'
                    runID = 4;
            end
        end
        
    end
    
end

