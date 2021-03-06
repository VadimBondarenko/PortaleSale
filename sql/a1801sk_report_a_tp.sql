/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1801sk.tab_num,
         st.fio fio_ts,
         a1801sk.fio_eta,
         a1801sk.tp_ur,
         a1801sk.tp_addr,
         a1801sk.tp_kod,
         a1801sktps.contact_lpr
    FROM a1801sk_tp_select a1801sktps, a1801sk, user_list st
   WHERE     a1801sk.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1801sk.tp_kod = a1801sktps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1801sk.h_fio_eta, :eta_list) =
                a1801sk.h_fio_eta
GROUP BY a1801sk.tab_num,
         st.fio,
         a1801sk.fio_eta,
         a1801sk.tp_ur,
         a1801sk.tp_addr,
         a1801sk.tp_kod,
         a1801sktps.contact_lpr
ORDER BY st.fio,
         a1801sk.fio_eta,
         a1801sk.tp_ur,
         a1801sk.tp_addr