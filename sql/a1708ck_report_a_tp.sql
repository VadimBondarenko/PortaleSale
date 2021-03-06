/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1708ck.tab_num,
         st.fio fio_ts,
         a1708ck.fio_eta,
         a1708ck.tp_ur,
         a1708ck.tp_addr,
         a1708ck.tp_kod,
         a1708cktps.contact_lpr
    FROM a1708ck_tp_select a1708cktps, a1708ck, user_list st
   WHERE     a1708ck.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1708ck.tp_kod = a1708cktps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1708ck.h_fio_eta, :eta_list) =
                a1708ck.h_fio_eta
GROUP BY a1708ck.tab_num,
         st.fio,
         a1708ck.fio_eta,
         a1708ck.tp_ur,
         a1708ck.tp_addr,
         a1708ck.tp_kod,
         a1708cktps.contact_lpr
ORDER BY st.fio,
         a1708ck.fio_eta,
         a1708ck.tp_ur,
         a1708ck.tp_addr