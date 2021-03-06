/* Formatted on 29/01/2015 12:13:44 (QP5 v5.227.12220.39724) */
SELECT SUM (selected)
  FROM (  SELECT a1708kr.tab_num,
                 st.fio fio_ts,
                 a1708kr.fio_eta,
                 a1708kr.tp_ur,
                 a1708kr.tp_addr,
                 a1708kr.tp_kod,
                 DECODE (a1708krtps.tp_kod, NULL, NULL, 1) selected,
                 NVL (a1708krtps.contact_lpr,
                      (SELECT TRIM (contact_tel || ' ' || contact_fio)
                         FROM routes
                        WHERE tp_kod = a1708kr.tp_kod AND ROWNUM = 1))
                    contact_lpr
            FROM a1708kr_tp_select a1708krtps, a1708kr, user_list st
           WHERE     a1708kr.tab_num = st.tab_num
                 AND (   st.tn IN (SELECT slave
                                     FROM full
                                    WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND a1708kr.tp_kod = a1708krtps.tp_kod(+)
                 AND st.dpt_id = :dpt_id and st.is_spd=1
        GROUP BY a1708kr.tab_num,
                 st.fio,
                 a1708kr.fio_eta,
                 a1708kr.tp_ur,
                 a1708kr.tp_addr,
                 a1708kr.tp_kod,
                 a1708krtps.contact_lpr,
                 DECODE (a1708krtps.tp_kod, NULL, NULL, 1)
        ORDER BY st.fio, a1708kr.fio_eta, a1708kr.tp_ur)