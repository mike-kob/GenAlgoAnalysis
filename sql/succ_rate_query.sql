-- Select success rate along with speed of convergence for every Pm that we have
-- in RunSet table. Compare it to finally found Pmax.

-- succ_rate_hamming.csv, succ_rate_real.csv, succ_rate_gray.csv
WITH accuracy_ts_stats AS (
    SELECT test_suite_id, SUM(CASE WHEN solution_found THEN 1 ELSE 0 END) AS success_rate
    FROM run
    GROUP BY test_suite_id
),
     accuracy_rs_stats AS (
         SELECT run_set_id, SUM(CASE WHEN solution_found THEN 1 ELSE 0 END) AS success_rate
         FROM run
         GROUP BY run_set_id
     )
SELECT frs.f_alias
     , sel_type
     , "L"
     , "N"
     , frs.pmax                                          AS pm
     , to_char(frs.pmax / ts.init_pmax * 100, 'FM999.0') AS pct_of_pmax
     , rs_stats.success_rate                             AS pm_success_rate
     , frs.min_iter_num                                  AS pm_min_iter
     , frs.avg_iter_num                                  AS pm_avg_iter
     , frs.max_iter_num                                  AS pm_max_iter
     , frs.std_iter_num                                  AS pm_std_iter
     , ts.init_pmax                                      AS Pmax
     , ts_stats.success_rate                             AS pmax_success_rate
     , ts.min_iter_num                                   AS pmax_min_iter
     , ts.avg_iter_num                                   AS pmax_avg_iter
     , ts.max_iter_num                                   AS pmax_max_iter
     , ts.std_iter_num                                   AS pmax_std_iter
FROM full_run_set frs
         INNER JOIN testsuite ts ON frs.expsuite_id = COALESCE(ts.exp_suite_after_id, ts.exp_suite_before_id)
         INNER JOIN accuracy_ts_stats ts_stats ON ts.id = ts_stats.test_suite_id
         INNER JOIN accuracy_rs_stats rs_stats ON frs.id = rs_stats.run_set_id
WHERE ts.is_approved
  AND ts.factor = 1
  AND frs.succ_num = 10
  AND ts.init_pmax > frs.pmax
  AND series_code = 'dec_gray'  -- 'nov_main_1', 'nov_main_2'
ORDER BY 1,2,3,4;