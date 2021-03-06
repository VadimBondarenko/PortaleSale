/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1810cf.tab_num,
         st.fio fio_ts,
         a1810cf.fio_eta,
         a1810cf.tp_ur,
         a1810cf.tp_addr,
         a1810cf.tp_kod,
         a1810cftps.contact_lpr
    FROM a1810cf_tp_select a1810cftps, a1810cf, user_list st
   WHERE     a1810cf.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1810cf.tp_kod = a1810cftps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1810cf.h_fio_eta, :eta_list) =
                a1810cf.h_fio_eta
GROUP BY a1810cf.tab_num,
         st.fio,
         a1810cf.fio_eta,
         a1810cf.tp_ur,
         a1810cf.tp_addr,
         a1810cf.tp_kod,
         a1810cftps.contact_lpr
ORDER BY st.fio,
         a1810cf.fio_eta,
         a1810cf.tp_ur,
         a1810cf.tp_addr