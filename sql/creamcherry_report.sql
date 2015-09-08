/* Formatted on 25.02.2013 10:07:29 (QP5 v5.163.1008.3004) */
  SELECT an.id,
         d.nakl,
         TO_CHAR (d.data, 'dd.mm.yyyy') data,
         d.fio_eta,
         d.qtyskufk,
         d.summnds_fk,
         d.tp_kod,
         d.tp_ur,
         d.summa,
d.cream_cherry_qty,
d.sumnds_cream_cher,
         d.tp_addr,
         nvl(an.if1, 0) selected_if1,
         nvl(an.if2, 0) selected_if2,
         an.bonus_sum,
         TO_CHAR (an.bonus_dt, 'dd.mm.yyyy') bonus_dt,
         TO_CHAR (an.ok_chief_date, 'dd.mm.yyyy hh24:mi:ss') ok_chief_date,
         an.ok_chief,
         an.ok_traid,
         fn_getname (
                      (SELECT parent
                         FROM parents
                        WHERE tn = st.tn))
            parent_fio,
         (SELECT parent
            FROM parents
           WHERE tn = st.tn)
            parent_tn,
         st.fio ts_fio,
         st.tn ts_tn
    FROM creamcherry d,
         creamcherry_action_nakl an,
         user_list st,
         creamcherry_tp_select tp
   WHERE     d.tab_num = st.tab_num
         AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_without_ts, 0, :tn, :exp_list_without_ts))
         AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_only_ts, 0, :tn, :exp_list_only_ts))
         AND (st.tn IN (SELECT slave
                          FROM full
                         WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND st.dpt_id = :dpt_id
         AND d.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL
         AND d.tp_kod = tp.tp_kod
         AND DECODE (:eta_list, '', d.h_fio_eta, :eta_list) = d.h_fio_eta
         AND DECODE (:ok_chief,  1, 0,  2, 1,  3, 0) = DECODE (:ok_chief,  1, 0,  2, an.ok_chief,  3, NVL (an.ok_chief, 0))
         AND DECODE (:act_month, 0, 0, :act_month) = DECODE (:act_month, 0, 0, TO_NUMBER (TO_CHAR (d.data, 'mm')))
         AND decode(nvl(an.if1,0)+nvl(an.if2,0),0,0,1) = 1
ORDER BY parent_fio,
         ts_fio,
         fio_eta,
         data,
         nakl