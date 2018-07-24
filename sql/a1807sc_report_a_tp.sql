/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1807sc.tab_num,
         st.fio fio_ts,
         a1807sc.fio_eta,
         a1807sc.tp_ur,
         a1807sc.tp_addr,
         a1807sc.tp_kod,
         a1807sctps.contact_lpr
    FROM a1807sc_tp_select a1807sctps, a1807sc, user_list st
   WHERE     a1807sc.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1807sc.tp_kod = a1807sctps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1807sc.h_fio_eta, :eta_list) =
                a1807sc.h_fio_eta
GROUP BY a1807sc.tab_num,
         st.fio,
         a1807sc.fio_eta,
         a1807sc.tp_ur,
         a1807sc.tp_addr,
         a1807sc.tp_kod,
         a1807sctps.contact_lpr
ORDER BY st.fio,
         a1807sc.fio_eta,
         a1807sc.tp_ur,
         a1807sc.tp_addr