/* Formatted on 29/01/2015 12:13:44 (QP5 v5.227.12220.39724) */
SELECT SUM (selected)
  FROM (  SELECT a1810ctm.tab_num,
                 st.fio fio_ts,
                 a1810ctm.fio_eta,
                 a1810ctm.tp_ur,
                 a1810ctm.tp_addr,
                 a1810ctm.tp_kod,
                 DECODE (a1810ctmtps.tp_kod, NULL, NULL, 1) selected,
                 NVL (a1810ctmtps.contact_lpr,
                      (SELECT TRIM (contact_tel || ' ' || contact_fio)
                         FROM routes
                        WHERE tp_kod = a1810ctm.tp_kod AND ROWNUM = 1))
                    contact_lpr
            FROM A1810CTM_SELECT a1810ctmtps, a1810ctm, user_list st
           WHERE     a1810ctm.tab_num = st.tab_num
                 AND (   st.tn IN (SELECT slave
                                     FROM full
                                    WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND a1810ctm.tp_kod = a1810ctmtps.tp_kod(+)
                 AND st.dpt_id = :dpt_id and st.is_spd=1
        GROUP BY a1810ctm.tab_num,
                 st.fio,
                 a1810ctm.fio_eta,
                 a1810ctm.tp_ur,
                 a1810ctm.tp_addr,
                 a1810ctm.tp_kod,
                 a1810ctmtps.contact_lpr,
                 DECODE (a1810ctmtps.tp_kod, NULL, NULL, 1)
        ORDER BY st.fio, a1810ctm.fio_eta, a1810ctm.tp_ur)