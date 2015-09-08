/* Formatted on 20.05.2013 15:11:50 (QP5 v5.163.1008.3004) */
SELECT SUM (selected) selected
  FROM (  SELECT v.tab_num,
                 st.fio fio_ts,
                 v.fio_eta,
                 v.tp_ur,
                 v.tp_addr,
                 v.tp_kod,
                 vtps.selected,
                 NVL (vtps.contact_lpr,
                      (SELECT TRIM (contact_tel || ' ' || contact_fio)
                         FROM routes
                        WHERE tp_kod = v.tp_kod AND ROWNUM = 1))
                    contact_lpr
            FROM a13_51m_tp_select vtps, a13_51m v, user_list st
           WHERE     v.tab_num = st.tab_num
                 AND (st.tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND v.tp_kod = vtps.tp_kod(+)
                 AND st.dpt_id = :dpt_id
        GROUP BY v.tab_num,
                 st.fio,
                 v.fio_eta,
                 v.tp_ur,
                 v.tp_addr,
                 v.tp_kod,
                 vtps.selected,
                 vtps.contact_lpr)