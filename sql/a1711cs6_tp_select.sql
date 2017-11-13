/* Formatted on 19.08.2017 11:43:39 (QP5 v5.252.13127.32867) */
  SELECT a1711cs6.tab_num,
         st.fio fio_ts,
         a1711cs6.fio_eta,
         a1711cs6.tp_ur,
         a1711cs6.tp_addr,
         a1711cs6.tp_kod,
         DECODE (a1711cs6tps.tp_kod, NULL, NULL, 1) selected,
         NVL (a1711cs6tps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a1711cs6.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a1711cs6_select a1711cs6tps, a1711cs6, user_list st
   WHERE     a1711cs6.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1711cs6.tp_kod = a1711cs6tps.tp_kod(+)
         AND st.dpt_id = :dpt_id
         AND st.is_spd = 1
GROUP BY a1711cs6.tab_num,
         st.fio,
         a1711cs6.fio_eta,
         a1711cs6.tp_ur,
         a1711cs6.tp_addr,
         a1711cs6.tp_kod,
         a1711cs6tps.contact_lpr,
         DECODE (a1711cs6tps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a1711cs6.fio_eta, a1711cs6.tp_ur