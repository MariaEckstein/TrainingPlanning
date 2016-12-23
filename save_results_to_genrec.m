function genrec = save_results_to_genrec(agent, Agent, agentID, runID, fit_params, NLLBICAIC, sim_data, n_params)

genrec_columns;   % what info is located in which column?
genrec(agent, [agentID_c run_c]) = [agentID runID];
if ~strcmp(sim_data, 'real')
    genrec(agent, gen_aabblwpk_c) = Agent(1, par_c);
end
genrec(agent, rec_aabblwpk_c) = fit_params;   % Save fitted parameters (params) into the genrec rec paramater columns (aabblwpk)
genrec(agent, NLLBICAIC_c) = NLLBICAIC;   % Save NLL, BIC, and AIC (NLLBICAIC) into the genrec NLLBICAIC columns (NLLBICAIC_c)
