/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1710ss2.tab_num,
         st.fio fio_ts,
         a1710ss2.fio_eta,
         a1710ss2.tp_ur,
         a1710ss2.tp_addr,
         a1710ss2.tp_kod,
         a1710ss2tps.contact_lpr
    FROM a1710ss2_tp_select a1710ss2tps, a1710ss2, user_list st
   WHERE     a1710ss2.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1710ss2.tp_kod = a1710ss2tps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1710ss2.h_fio_eta, :eta_list) =
                a1710ss2.h_fio_eta
GROUP BY a1710ss2.tab_num,
         st.fio,
         a1710ss2.fio_eta,
         a1710ss2.tp_ur,
         a1710ss2.tp_addr,
         a1710ss2.tp_kod,
         a1710ss2tps.contact_lpr
ORDER BY st.fio,
         a1710ss2.fio_eta,
         a1710ss2.tp_ur,
         a1710ss2.tp_addr