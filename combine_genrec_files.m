
file_dir = 'Results';   % Where is the original data stored? 
files = dir(file_dir);
fileIndex = find(~[files.isdir]);
n_files = length(fileIndex);

all_genrec = zeros(n_files, 22);

for file = 1:n_files
    file_name = files(fileIndex(file)).name;
    load(fullfile(file_dir, file_name));
    
    mode = file_name(12);
    if strcmp(mode, 'h')
        hier = 1;
    else
        hier = 0;
    end
        
    all_genrec(file,:) = genrec;
    all_genrec(file,3) = hier;
end

save('all_genrec.mat', 'all_genrec')