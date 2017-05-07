
genrec_columns;
file_dir = 'Results';   % Where is the original data stored? 
files = dir(file_dir);
fileIndex = find(~[files.isdir]);
n_files = length(fileIndex);

all_pars = zeros(n_files, 22);

for file = 1:n_files
    file_name = files(fileIndex(file)).name;
    version = str2double(file_name(end-4));
    model = file_name(13:end-5);
    n_par = str2double(file_name(11));
    load(fullfile(file_dir, file_name));
    agentID = str2double(file_name(4:6));
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
    
    if strcmp(model, 'genrec')
        all_pars(file, :) = genrec;
        
    elseif strcmp(model, 'pars')        
        a1 = 0; b1 = 0; l = 0; k = 0;
        switch size(pars, 2)
            case 4
                a2 = pars(1);
                b2 = pars(2);
                p = pars(3);
                w = pars(4);
            case 6
                a1 = pars(1);
                a2 = pars(2);
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
        all_pars(file, rec_aabblwpk_c) = [a1 a2 b1 b2 l w p k];
    end
    all_pars(file, 2:4) = [model(1) version n_par];    
    all_pars(file, [agentID_c run_c]) = [agentID runID];
end

save('all_pars.mat', 'all_pars')