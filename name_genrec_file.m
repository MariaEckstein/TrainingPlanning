function genrec_file_name = name_genrec_file(sim_data, fit_model)

today = date;
now = clock;
hour = num2str(now(4));
genrec_file_name = ['genrec_' sim_data '_agents_' fit_model '_sim_' today '_' hour '.mat'];