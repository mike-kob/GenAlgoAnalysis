-- Definition of success rate (solution_found column in Run table)
-- For real function except rastrigins:
UPDATE run
SET solution_found=(SELECT BOOL_AND(ABS(ROUND(a.a::numeric, 2)) <= 0.01) FROM unnest(best_ind_ar) AS a)
WHERE run_set_id IN (
    SELECT id
    FROM full_run_set
    WHERE succ_num=10
      AND series_code='dec_gray'
      AND f_alias='spherical'
);

-- For rastrigins real function we also consider +1,-1 as solution:
UPDATE run
SET solution_found=(SELECT BOOL_AND(
                            ABS(ROUND(a.a::numeric, 2)) <= 0.01 OR ABS(ABS(ROUND(a.a::numeric, 2)) - 1) <= 0.01
                        ) FROM unnest(best_ind_ar) AS a)
WHERE run_set_id IN (
    SELECT id
    FROM full_run_set
    WHERE succ_num=10
      AND series_code='nov_main_1'
      AND f_alias='shifted_rastrigins'
);

-- For hamming functions
UPDATE run
SET solution_found=(hamm_d_to_extremum<=0)
WHERE run_set_id IN (
    SELECT id
    FROM full_run_set
    WHERE succ_num=10
      AND series_code='nov_main_2'
);
