file_dir = 'C:\Users\maria\MEGAsync\TrainingPlanningProject\TwoStepTask\model\Results\hyb';
files = dir(file_dir);
fileIndex = find(~[files.isdir]);

for i = 1:length(fileIndex)
    file_name = files(fileIndex(i)).name;
    load(fullfile(file_dir, file_name));
    
    flat_par(i,:) = genrec(10:17);
end

save('flat_par.mat', 'flat_par')