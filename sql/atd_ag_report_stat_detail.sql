/* Formatted on 15.02.2013 9:58:42 (QP5 v5.163.1008.3004) */
  SELECT TO_CHAR (r.dt, 'dd.mm.yyyy') dt,
         r.rep_tm,
         r.text,
         r.id,
         tz.id tz_id,
         r.count_byu,
         r.stock_start,
         r.stock_finish,
         r.stock_shelf
    FROM atd_tz tz,
         atd_city c,
         atd_diviz d,
         atd_nets n,
         atd_contr_avk cavk,
         atd_contr_ag cag,
         user_list u,
         atd_tz_ag_report r
   WHERE     tz.city = c.id(+)
         AND tz.nets = n.id(+)
         AND tz.diviz = d.id(+)
         AND tz.contr_avk = cavk.id(+)
         AND tz.contr_ag = cag.id(+)
         AND tz.cont_avk = u.tn(+)
         AND tz.id = r.tz_id
         AND r.tz_id = :tz_id
         AND r.dt BETWEEN TO_DATE (:sdt, 'dd.mm.yyyy') AND TO_DATE (:edt, 'dd.mm.yyyy')
ORDER BY r.dt, r.rep_tm