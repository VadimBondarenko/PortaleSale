/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1709bs.tab_num,
         st.fio fio_ts,
         a1709bs.fio_eta,
         a1709bs.tp_ur,
         a1709bs.tp_addr,
         a1709bs.tp_kod,
         a1709bstps.contact_lpr
    FROM a1709bs_tp_select a1709bstps, a1709bs, user_list st
   WHERE     a1709bs.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1709bs.tp_kod = a1709bstps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1709bs.h_fio_eta, :eta_list) =
                a1709bs.h_fio_eta
GROUP BY a1709bs.tab_num,
         st.fio,
         a1709bs.fio_eta,
         a1709bs.tp_ur,
         a1709bs.tp_addr,
         a1709bs.tp_kod,
         a1709bstps.contact_lpr
ORDER BY st.fio,
         a1709bs.fio_eta,
         a1709bs.tp_ur,
         a1709bs.tp_addr