function genrec = save_results_to_genrec(genrec, i_dataset, dataset, agentID, runID, fit_params, NLLBICAIC, sim_data, n_params)

data_columns;
genrec_columns;   % what info is located in which column?
genrec(i_dataset, [agentID_c run_c]) = [agentID runID];
if ~strcmp(sim_data, 'real')
    genrec(i_dataset, gen_aabblwpk_c) = dataset(1, par_c);
end
genrec(i_dataset, rec_aabblwpk_c) = fit_params;   % Save fitted parameters (params) into the genrec rec paramater columns (aabblwpk)
genrec(i_dataset, NLLBICAIC_c) = NLLBICAIC;   % Save NLL, BIC, and AIC (NLLBICAIC) into the genrec NLLBICAIC columns (NLLBICAIC_c)
