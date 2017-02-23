

files = dir;
file_index = find(~[files.isdir]);
for i = file_index
    file_name = files(i).name;
    if strcmp(file_name(8:11), 'real')
        load(file_name)
        keep_rows = find(genrec(:,1)~=0);
        genrec_s = genrec(keep_rows, :);
        save(file_name(1:end-21), 'genrec_s')
    end
end