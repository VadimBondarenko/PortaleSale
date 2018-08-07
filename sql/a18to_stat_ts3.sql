/* Formatted on 04/04/2016 08:59:10 (QP5 v5.252.13127.32867) */
  SELECT key, SUM (bonus4tp) bonus4tp, 
         count(distinct cto) cto
    FROM (SELECT DISTINCT
                 tn key,
                 tp_kod_key,
                        name_to cto,
                 type_standart_price * DECODE (zst_lu, NULL, 0, 1) * DECODE (reject_traid_in_month, 1, null, 1) bonus4tp
            FROM (SELECT z.*,
                 CASE
                    WHEN :by_who = 'eta' THEN type_standart_price_eta
                    WHEN :by_who = 'ts' THEN type_standart_price_ts
                 END
                    type_standart_price
            FROM a18to_mv z
           WHERE     visitdate BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                   AND TO_DATE ( :ed, 'dd.mm.yyyy')
                 AND (   :exp_list_without_ts = 0
                      OR tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_without_ts))
                 AND (   :exp_list_only_ts = 0
                      OR tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_only_ts))
                 AND (   tn IN (SELECT slave
                                  FROM full
                                 WHERE master IN (SELECT parent
                                                    FROM assist
                                                   WHERE     child = :tn
                                                         AND dpt_id = :dpt_id
                                                  UNION
                                                  SELECT DECODE ( :tn,
                                                                 -1, master,
                                                                 :tn)
                                                    FROM DUAL))
                      OR (SELECT NVL (is_admin, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1
                      OR (SELECT NVL (is_traid_kk, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1
                      OR (SELECT NVL (is_kpr, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND dpt_id = :dpt_id
                 AND (:eta_list is null OR :eta_list = h_fio_eta)
                 AND DECODE ( :ok_ts, 1, ok_ts, :ok_ts) = ok_ts
                 AND DECODE ( :ok_auditor, 1, ok_auditor, :ok_auditor) = ok_auditor
                 AND DECODE ( :st_ts, 1, st_ts, :st_ts) = st_ts
                 AND DECODE ( :st_auditor, 1, st_auditor, :st_auditor) = st_auditor
                 AND DECODE ( :ok_st_tm, 1, ok_st_tm, :ok_st_tm) = ok_st_tm
                       AND (   :type_standart = 1
                            OR ( :type_standart = 2 AND type_standart = 'A')
                            OR ( :type_standart = 3 AND type_standart = 'B')))
         /*WHERE DECODE (zst_lu, NULL, 0, 1) > 0*/)
GROUP BY key