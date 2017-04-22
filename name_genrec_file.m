function genrec_file_name = name_genrec_file(sim_model, fit_model)

today = date;
now = clock;
hour = num2str(now(4));
minute = num2str(now(5));
time = [hour '.' minute];
genrec_file_name = ['genrec_' sim_model '_agents_' fit_model '_sim_' today '_' time '.mat'];