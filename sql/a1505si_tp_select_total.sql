/* Formatted on 29/01/2015 12:13:44 (QP5 v5.227.12220.39724) */
SELECT SUM (selected)
  FROM (  SELECT a1505si.tab_num,
                 st.fio fio_ts,
                 a1505si.fio_eta,
                 a1505si.tp_ur,
                 a1505si.tp_addr,
                 a1505si.tp_kod,
                 DECODE (a1505sitps.tp_kod, NULL, NULL, 1) selected,
                 NVL (a1505sitps.contact_lpr,
                      (SELECT TRIM (contact_tel || ' ' || contact_fio)
                         FROM routes
                        WHERE tp_kod = a1505si.tp_kod AND ROWNUM = 1))
                    contact_lpr
            FROM a1505si_tp_select a1505sitps, a1505si, user_list st
           WHERE     a1505si.tab_num = st.tab_num
                 AND (   st.tn IN (SELECT slave
                                     FROM full
                                    WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND a1505si.tp_kod = a1505sitps.tp_kod(+)
                 AND st.dpt_id = :dpt_id
        GROUP BY a1505si.tab_num,
                 st.fio,
                 a1505si.fio_eta,
                 a1505si.tp_ur,
                 a1505si.tp_addr,
                 a1505si.tp_kod,
                 a1505sitps.contact_lpr,
                 DECODE (a1505sitps.tp_kod, NULL, NULL, 1)
        ORDER BY st.fio, a1505si.fio_eta, a1505si.tp_ur)