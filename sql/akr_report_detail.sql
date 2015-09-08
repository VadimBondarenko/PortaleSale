/* Formatted on 11.02.2013 14:54:41 (QP5 v5.163.1008.3004) */
  SELECT p.id, p.name, nvl(z.val,0) val
    FROM akr_ocenka_params p, akr_tz_report_params z
   WHERE p.id = z.prm_id(+) AND z.rep_id(+) = :id
ORDER BY p.name