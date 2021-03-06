/* Formatted on 05.12.2017 23:05:23 (QP5 v5.252.13127.32867) */
  SELECT zp.fil fil_id,
         z.act,
         z.act_name,
         TO_CHAR (z.act_month, 'dd.mm.yyyy') act_month,
         TO_NUMBER (TO_CHAR (z.act_month, 'mm')) month,
         SUM (s.tp) tp,
         SUM (s.sales) sales,
         SUM (s.bonus) bonus,
         SUM (  s.bonus
              * (  1
                 -   NVL ( (SELECT discount
                              FROM bud_fil_discount_body
                             WHERE dt = z.act_month AND distr = zp.fil),
                          0)
                   / 100)
              * (SELECT bonus_log_koef
                   FROM bud_fil
                  WHERE id = zp.fil))
            compens_distr,
         z.act_month period,
         (SELECT mt || ' ' || y
            FROM calendar
           WHERE data = z.act_month)
            period_text
    FROM bud_act_fund z,
         act_svod s,
         user_list u,
         (SELECT dt, fil, h_eta
            FROM bud_svod_zp
           WHERE     dt BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                            AND TO_DATE ( :ed, 'dd.mm.yyyy')
                 AND dpt_id = :dpt_id
                 AND fil IS NOT NULL) zp
   WHERE     u.tab_num = s.ts_tab_num
         AND u.dpt_id = :dpt_id
         AND u.is_spd = 1
         AND s.dpt_id = :dpt_id
         AND s.db_tn = DECODE ( :db, 0, s.db_tn, :db)
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
         AND zp.h_eta = s.h_fio_eta
         AND DECODE ( :fil, 0, zp.fil, :fil) = zp.fil
         AND z.fund_id = DECODE ( :funds, 0, z.fund_id, :funds)
         AND (   zp.fil IN (SELECT fil_id
                              FROM clusters_fils
                             WHERE :clusters = CLUSTER_ID)
              OR :clusters = 0)
         AND z.act = s.act
         AND TO_NUMBER (TO_CHAR (z.act_month, 'mm')) = s.m
         AND z.act_month BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                             AND TO_DATE ( :ed, 'dd.mm.yyyy')
         AND z.act_month = zp.dt
         AND DECODE ( :st, 0, 0, 1) = 0
GROUP BY zp.fil,
         z.act,
         z.act_name,
         z.act_month
UNION
  SELECT s.fil_kod fil_id,
         z.act,
         z.act_name,
         TO_CHAR (z.act_month, 'dd.mm.yyyy') act_month,
         TO_NUMBER (TO_CHAR (z.act_month, 'mm')) month,
         COUNT (*) tp,
         SUM (s.sales) sales,
         SUM (s.bonus) bonus,
         SUM (  s.bonus
              * (  1
                 -   NVL ( (SELECT discount
                              FROM bud_fil_discount_body
                             WHERE dt = z.act_month AND distr = s.fil_kod),
                          0)
                   / 100)
              * (SELECT bonus_log_koef
                   FROM bud_fil
                  WHERE id = s.fil_kod))
            compens_distr,
         z.act_month period,
         (SELECT mt || ' ' || y
            FROM calendar
           WHERE data = z.act_month)
            period_text
    FROM bud_act_fund z, act_svodn s, user_list u
   WHERE     u.tab_num = s.ts_tab_num
         AND u.dpt_id = :dpt_id
         AND u.is_spd = 1
         AND s.db_tn = DECODE ( :db, 0, s.db_tn, :db)
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
         AND DECODE ( :fil, 0, s.fil_kod, :fil) = s.fil_kod
         AND z.fund_id = DECODE ( :funds, 0, z.fund_id, :funds)
         AND (   s.fil_kod IN (SELECT fil_id
                                 FROM clusters_fils
                                WHERE :clusters = CLUSTER_ID)
              OR :clusters = 0)
         AND z.act = s.act
         AND TO_NUMBER (TO_CHAR (z.act_month, 'mm')) = s.m
         AND z.act_month BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                             AND TO_DATE ( :ed, 'dd.mm.yyyy')
         AND DECODE ( :st, 0, 0, 1) = 0
GROUP BY s.fil_kod,
         z.act,
         z.act_name,
         z.act_month
ORDER BY act_month, act_name