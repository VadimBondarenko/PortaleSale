/* Formatted on 17.09.2013 12:34:17 (QP5 v5.227.12220.39724) */
  SELECT u.pos_id, u.pos_name, COUNT (*) cnt
    FROM tr,
         tr_pt_order_head th,
         tr_pt_order_body tb,
         user_list u
   WHERE     tb.manual >= 0
         AND u.h_eta = tb.h_eta
         AND u.dpt_id = :dpt_id
         AND tb.head = th.id
         AND tr.id = th.tr
         AND th.dt_start BETWEEN TO_DATE (:sd, 'dd.mm.yyyy')
                             AND TO_DATE (:ed, 'dd.mm.yyyy')
         AND tr.id IN (:tr)
   and ((:tr_pt_rep_common_datauvol='all') or (:tr_pt_rep_common_datauvol='actual' and nvl(u.datauvol,trunc(sysdate))>=trunc(sysdate)))
GROUP BY u.pos_id, u.pos_name
ORDER BY u.pos_name