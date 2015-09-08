/* Formatted on 10.09.2012 14:14:49 (QP5 v5.163.1008.3004) */
  SELECT d.tab_num,
         st.fio fio_ts,
         d.fio_eta,
         d.tp_ur,
         d.tp_addr,
         d.tp_kod,
         d.nakl,
         TO_CHAR (d.data, 'dd.mm.yyyy') data,
         d.summa,
         d.summnds_pg,
         d.action_qt_ya_oct,
         CASE
            WHEN d.action_qt_ya_oct >= 4 THEN 1
            ELSE 0
         END
            action_nakl,
         CASE
            WHEN d.action_qt_ya_oct >= 4 THEN TRUNC (d.action_qt_ya_oct / 4)
            ELSE 0
         END
            max_ya,
         DECODE (an.nakl, NULL, 0, 1) selected,
         an.ok_traid,
         an.ok_ts,
         an.ok_chief,
         an.bonus,
         an.text,
         an.ya fakt_ya
    FROM a4p1 d, a4p1_10_action_nakl an, user_list st, a7p1_10_action_nakl an7
   WHERE     d.tab_num = st.tab_num
         AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
         AND st.tn = :tn
         AND st.dpt_id = :dpt_id
/*         AND DECODE (:tp, 0, 0, sign(to_date('15.09.2012','dd/mm/yyyy')-d.data)) = DECODE (:tp, 0, 0,1)*/
         AND DECODE (:tp, 0, 0, SIGN (d.data - TO_DATE ('08.10.2012', 'dd/mm/yyyy'))+ SIGN (TO_DATE ('01.11.2012', 'dd/mm/yyyy')-d.data)) = DECODE (:tp, 0, 0,2) /* ��������� � 09.10 �� 30.10 */
         AND DECODE (:tp, 0, d.tp_kod, :tp) = d.tp_kod
         AND DECODE (:tp, 0, d.nakl, 0) = DECODE (:tp, 0, an.nakl, 0)
         AND d.tp_kod = an.tp_kod(+)
         AND d.nakl = an.nakl(+)
         AND d.tp_kod = an7.tp_kod(+)
         AND d.nakl = an7.nakl(+)
         AND an7.nakl is null
         --AND TRUNC (d.data, 'mm') = '01.09.2012'
         AND DECODE (:eta_list, '', d.fio_eta, :eta_list) = d.fio_eta
ORDER BY st.fio,
         d.fio_eta,
         d.tp_ur,
         d.tp_addr,
         d.data,
         d.nakl