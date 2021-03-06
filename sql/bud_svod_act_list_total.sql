/* Formatted on 05.12.2017 22:40:38 (QP5 v5.252.13127.32867) */
SELECT SUM (s.sales) sales,
       SUM (s.bonus) bonus,
       DECODE (SUM (s.sales), 0, 0, SUM (s.bonus) / SUM (s.sales) * 100) zat,
       SUM (s.tp) tp
  FROM act_svod s,
       user_list u,
       (SELECT fil, h_eta
          FROM bud_svod_zp
         WHERE     dt = TO_DATE ( :dt, 'dd.mm.yyyy')
               AND dpt_id = :dpt_id
               AND fil IS NOT NULL) zp
 WHERE     s.act = :act
       AND s.m = :m
       AND s.ts_tab_num = u.tab_num
       AND u.dpt_id = :dpt_id
       AND u.is_spd = 1
       AND s.dpt_id = :dpt_id
       AND (   :exp_list_without_ts = 0
            OR u.tn IN (SELECT slave
                          FROM full
                         WHERE master = :exp_list_without_ts))
       AND (   :exp_list_only_ts = 0
            OR u.tn IN (SELECT slave
                          FROM full
                         WHERE master = :exp_list_only_ts))
       AND (   u.tn IN (SELECT slave
                          FROM full
                         WHERE master = :tn)
            OR (SELECT NVL (is_traid, 0)
                  FROM user_list
                 WHERE tn = :tn) = 1
            OR (SELECT NVL (is_traid_kk, 0)
                  FROM user_list
                 WHERE tn = :tn) = 1)
       AND ( :eta_list IS NULL OR :eta_list = s.h_fio_eta)
       AND s.db_tn = DECODE ( :db, 0, s.db_tn, :db)
       AND zp.h_eta = s.h_fio_eta
       AND DECODE ( :fil, 0, zp.fil, :fil) = zp.fil
       AND (   zp.fil IN (SELECT fil_id
                            FROM clusters_fils
                           WHERE :clusters = CLUSTER_ID)
            OR :clusters = 0)
UNION
SELECT SUM (s.sales) sales,
       SUM (s.bonus) bonus,
       DECODE (SUM (s.sales), 0, 0, SUM (s.bonus) / SUM (s.sales) * 100) zat,
       COUNT (*) c
  FROM act_svodn s, user_list u
 WHERE     s.act = :act
       AND s.m = :m
       AND s.ts_tab_num = u.tab_num
       AND u.dpt_id = :dpt_id
       AND u.is_spd = 1
       AND (   :exp_list_without_ts = 0
            OR u.tn IN (SELECT slave
                          FROM full
                         WHERE master = :exp_list_without_ts))
       AND (   :exp_list_only_ts = 0
            OR u.tn IN (SELECT slave
                          FROM full
                         WHERE master = :exp_list_only_ts))
       AND (   u.tn IN (SELECT slave
                          FROM full
                         WHERE master = :tn)
            OR (SELECT NVL (is_traid, 0)
                  FROM user_list
                 WHERE tn = :tn) = 1
            OR (SELECT NVL (is_traid_kk, 0)
                  FROM user_list
                 WHERE tn = :tn) = 1)
       AND s.db_tn = DECODE ( :db, 0, s.db_tn, :db)
       AND DECODE ( :fil, 0, s.fil_kod, :fil) = s.fil_kod
       AND (   s.fil_kod IN (SELECT fil_id
                               FROM clusters_fils
                              WHERE :clusters = CLUSTER_ID)
            OR :clusters = 0)