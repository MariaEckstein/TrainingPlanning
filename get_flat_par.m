file_dir = 'C:\Users\maria\MEGAsync\TrainingPlanningProject\TwoStepTask\model\Results\hyb';
files = dir(file_dir);
fileIndex = find(~[files.isdir]);

for i = 1:length(fileIndex)
    file_name = files(fileIndex(i)).name;
    load(fullfile(file_dir, file_name));
    
    flat_par(i,:) = genrec(10:17);
end

save('flat_par.mat', 'flat_par')

epsilon = 1e-10;
flat_par(flat_par < epsilon) = epsilon;
flat_par(flat_par > 1 - epsilon) = 1 - epsilon;
flat_par_n = -log(1./flat_par - 1); 
    
M = mean(flat_par);
S = cov(flat_par);
figure
plot(flat_par(:,6), '.')
mline = refline(0, M(6));
mline.Color = 'r';
uline = refline(0, M(6) + sqrt(S(6,6)));
lline = refline(0, M(6) - sqrt(S(6,6)));

M = mean(flat_par_n);
S = cov(flat_par_n);
figure
plot(flat_par_n(:,6), '.')
mline = refline(0, M(6));
mline.Color = 'r';
uline = refline(0, M(6) + sqrt(S(6,6)));
lline = refline(0, M(6) - sqrt(S(6,6)));
