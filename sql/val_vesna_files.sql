/* Formatted on 11.01.2013 13:49:34 (QP5 v5.163.1008.3004) */
  SELECT TO_CHAR (d.lu, 'dd.mm.yyyy hh24:mi:ss') lu_text,
         d.*,
         fn_getname ( d.tn) fio_ts,
         NVL (bonus, 0) summa
    FROM val_vesna_files d, spdtree st
   WHERE     d.tn = st.svideninn
         AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_without_ts, 0, :tn, :exp_list_without_ts))
         AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_only_ts, 0, :tn, :exp_list_only_ts))
         AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
         AND st.dpt_id = :dpt_id
         AND DECODE (:ok_traid,  1, 0,  2, 1) = DECODE (:ok_traid,  1, 0,  2, d.ok_traid)
         and d.m=:month
ORDER BY fio_ts, d.fn