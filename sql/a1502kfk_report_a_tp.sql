/* Formatted on 28/01/2015 17:59:28 (QP5 v5.227.12220.39724) */
  SELECT t1.tab_num,
         st.fio fio_ts,
         t1.fio_eta,
         t1.tp_ur,
         t1.tp_addr,
         t1.tp_kod,
         tp.contact_lpr
    FROM a1502kfk_tp_select tp, a1502kfk t1, user_list st
   WHERE     t1.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND t1.tp_kod = tp.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', t1.h_fio_eta, :eta_list) = t1.h_fio_eta
GROUP BY t1.tab_num,
         st.fio,
         t1.fio_eta,
         t1.tp_ur,
         t1.tp_addr,
         t1.tp_kod,
         tp.contact_lpr
ORDER BY st.fio,
         t1.fio_eta,
         t1.tp_ur,
         t1.tp_addr