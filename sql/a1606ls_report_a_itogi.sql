/* Formatted on 30/05/2016 17:03:14 (QP5 v5.252.13127.32867) */
SELECT COUNT (DISTINCT an.H_TP_KOD_DATA_NAKL) cnt_nakl,
       COUNT (DISTINCT tp.tp_kod) cnt_tp,
       SUM (d.nakl_summ) nakl_summ,
       SUM (d.act_summ) act_summ,
       SUM (DECODE (an.bonus_dt1, NULL, NULL, 1)) if_cnt,
       SUM (an.bonus_sum1) if_sum
  FROM a1606ls d,
       a1606ls_action_nakl an,
       user_list st,
       a1606ls_tp_select tp
 WHERE     d.tab_num = st.tab_num
       AND (   :exp_list_without_ts = 0
            OR st.tn IN (SELECT slave
                           FROM full
                          WHERE master = :exp_list_without_ts))
       AND (   :exp_list_only_ts = 0
            OR st.tn IN (SELECT slave
                           FROM full
                          WHERE master = :exp_list_only_ts))
       AND (   st.tn IN (SELECT slave
                           FROM full
                          WHERE master = DECODE ( :tn, -1, master, :tn))
            OR (SELECT NVL (is_traid, 0)
                  FROM user_list
                 WHERE tn = :tn) = 1)
       AND st.dpt_id = :dpt_id
       AND d.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL
       AND d.tp_kod = tp.tp_kod
       AND DECODE ( :eta_list, '', d.h_fio_eta, :eta_list) = d.h_fio_eta
       AND NVL (an.if1, 0) > 0
       AND DECODE ( :ok_bonus, 0, 0, NVL (an.if1, 0)) = :ok_bonus