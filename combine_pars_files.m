
genrec_columns;
file_dir = ['Results'];   % Where is the original data stored? 
files = dir(file_dir);
fileIndex = find(~[files.isdir]);
n_files = length(fileIndex);

all_pars_41 = zeros(n_files, 19);
all_pars_42 = zeros(n_files, 19);
all_pars_61 = zeros(n_files, 19);
all_pars_62 = zeros(n_files, 19);
all_pars_71 = zeros(n_files, 19);
all_pars_72 = zeros(n_files, 19);

i_41 = 1; i_42 = 1; i_61 = 1; i_62 = 1; i_71 = 1; i_72 = 1;

for file = 1:n_files
    file_name = files(fileIndex(file)).name;
    version = str2double(file_name(end-4));
    load(fullfile(file_dir, file_name));
    a1 = 0; b1 = 0; l = 0; k = 0;
    switch size(pars, 2)
        case 4
            a2 = pars(1);
            b2 = pars(2);
            p = pars(3);
            w = pars(4);
        case 6
            a1 = pars(1);
            a2 = pras(2);
            b1 = pars(3);
            b2 = pars(4);
            p = pars(5);
            w = pars(6);
        case 7
            a1 = pars(1);
            a2 = pars(2);
            b1 = pars(3);
            b2 = pars(4);
            l = pars(5);
            p = pars(6);
            w = pars(7);
    end
    agentID = str2num(file_name(4:6));
    runID = file_name(9);
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
    
    switch size(pars, 2)
        case 4
            if version == 1
                all_pars_41(i_41, [agentID_c run_c]) = [agentID runID];
                all_pars_41(i_41, rec_aabblwpk_c) = [a1 a2 b1 b2 l w p k];
                i_41 = i_41 + 1;
            elseif version == 2
                all_pars_42(i_42, [agentID_c run_c]) = [agentID runID];
                all_pars_42(i_42, rec_aabblwpk_c) = [a1 a2 b1 b2 l w p k];
                i_42 = i_42 + 1;
            end
        case 6
            if version == 1
                all_pars_61(i_61, [agentID_c run_c]) = [agentID runID];
                all_pars_61(i_61, rec_aabblwpk_c) = [a1 a2 b1 b2 l w p k];
                i_61 = i_61 + 1;
            elseif version == 2
                all_pars_62(i_62, [agentID_c run_c]) = [agentID runID];
                all_pars_62(i_62, rec_aabblwpk_c) = [a1 a2 b1 b2 l w p k];
                i_62 = i_62 + 1;
            end
        case 7
            if version == 1
                all_pars_71(i_71, [agentID_c run_c]) = [agentID runID];
                all_pars_71(i_71, rec_aabblwpk_c) = [a1 a2 b1 b2 l w p k];
                i_71 = i_71 + 1;
            elseif version == 2
                all_pars_72(i_72, [agentID_c run_c]) = [agentID runID];
                all_pars_72(i_72, rec_aabblwpk_c) = [a1 a2 b1 b2 l w p k];
                i_72 = i_72 + 1;
            end
    end
end

save('all_pars_41.mat', 'all_pars_41')
save('all_pars_42.mat', 'all_pars_42')
save('all_pars_61.mat', 'all_pars_61')
save('all_pars_62.mat', 'all_pars_62')
save('all_pars_71.mat', 'all_pars_71')
save('all_pars_72.mat', 'all_pars_72')