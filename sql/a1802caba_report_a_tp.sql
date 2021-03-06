/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1802caba.tab_num,
         st.fio fio_ts,
         a1802caba.fio_eta,
         a1802caba.tp_ur,
         a1802caba.tp_addr,
         a1802caba.tp_kod,
         a1802cabatps.contact_lpr
    FROM a1802caba_tp_select a1802cabatps, a1802caba, user_list st
   WHERE     a1802caba.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1802caba.tp_kod = a1802cabatps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1802caba.h_fio_eta, :eta_list) =
                a1802caba.h_fio_eta
GROUP BY a1802caba.tab_num,
         st.fio,
         a1802caba.fio_eta,
         a1802caba.tp_ur,
         a1802caba.tp_addr,
         a1802caba.tp_kod,
         a1802cabatps.contact_lpr
ORDER BY st.fio,
         a1802caba.fio_eta,
         a1802caba.tp_ur,
         a1802caba.tp_addr