/* Formatted on 29/01/2015 12:13:36 (QP5 v5.227.12220.39724) */
  SELECT a1503mg.tab_num,
         st.fio fio_ts,
         a1503mg.fio_eta,
         a1503mg.tp_ur,
         a1503mg.tp_addr,
         a1503mg.tp_kod,
         DECODE (a1503mgtps.tp_kod, NULL, NULL, 1) selected,
         NVL (a1503mgtps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a1503mg.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a1503mg_tp_select a1503mgtps, a1503mg, user_list st
   WHERE     a1503mg.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1503mg.tp_kod = a1503mgtps.tp_kod(+)
         AND st.dpt_id = :dpt_id and st.is_spd=1
GROUP BY a1503mg.tab_num,
         st.fio,
         a1503mg.fio_eta,
         a1503mg.tp_ur,
         a1503mg.tp_addr,
         a1503mg.tp_kod,
         a1503mgtps.contact_lpr,
         DECODE (a1503mgtps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a1503mg.fio_eta, a1503mg.tp_ur