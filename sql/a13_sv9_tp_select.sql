/* Formatted on 17.09.2013 16:28:36 (QP5 v5.227.12220.39724) */
  SELECT a13_sv9.tab_num,
         st.fio fio_ts,
         a13_sv9.fio_eta,
         a13_sv9.tp_ur,
         a13_sv9.tp_addr,
         a13_sv9.tp_kod,
         a13_sv9tps.selected,
         NVL (a13_sv9tps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a13_sv9.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a13_sv9_tp_select a13_sv9tps, a13_sv9, user_list st
   WHERE     a13_sv9.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a13_sv9.tp_kod = a13_sv9tps.tp_kod(+)
         AND st.dpt_id = :dpt_id
/*AND a13_sv9.data BETWEEN TO_DATE ('01.01.2013', 'dd.mm.yyyy') AND TO_DATE ('12.05.2013', 'dd.mm.yyyy')*/
GROUP BY a13_sv9.tab_num,
         st.fio,
         a13_sv9.fio_eta,
         a13_sv9.tp_ur,
         a13_sv9.tp_addr,
         a13_sv9.tp_kod,
         a13_sv9tps.selected,
         a13_sv9tps.contact_lpr
ORDER BY st.fio, a13_sv9.fio_eta, a13_sv9.tp_ur