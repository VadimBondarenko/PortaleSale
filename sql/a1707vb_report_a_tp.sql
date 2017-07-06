/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1707vb.tab_num,
         st.fio fio_ts,
         a1707vb.fio_eta,
         a1707vb.tp_ur,
         a1707vb.tp_addr,
         a1707vb.tp_kod,
         a1707vbtps.contact_lpr
    FROM a1707vb_tp_select a1707vbtps, a1707vb, user_list st
   WHERE     a1707vb.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1707vb.tp_kod = a1707vbtps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1707vb.h_fio_eta, :eta_list) =
                a1707vb.h_fio_eta
GROUP BY a1707vb.tab_num,
         st.fio,
         a1707vb.fio_eta,
         a1707vb.tp_ur,
         a1707vb.tp_addr,
         a1707vb.tp_kod,
         a1707vbtps.contact_lpr
ORDER BY st.fio,
         a1707vb.fio_eta,
         a1707vb.tp_ur,
         a1707vb.tp_addr