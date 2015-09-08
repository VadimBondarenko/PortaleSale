/* Formatted on 06.02.2013 11:16:11 (QP5 v5.163.1008.3004) */
SELECT COUNT (DISTINCT an.H_TP_KOD_DATA_NAKL) cnt_nakl,
       COUNT (DISTINCT tp.tp_kod) cnt_tp,
       SUM (d.summa) summa,
       SUM (d.summnds_pg) summnds_pg,
       SUM (d.qtysku) qtysku,
       SUM (an.bonus_d_qty) bonus_d_qty,
       SUM (an.bonus_t_qty) bonus_t_qty,
       SUM (an.ok_ts) ok_ts,
       SUM (an.ok_chief) ok_chief,
       SUM (an.bonus_d_fact) bonus_d_fact,
       SUM (an.bonus_t_fact) bonus_t_fact,
       AVG ( (SELECT SUM (bonus) bonus
                FROM choco_files f, user_list st
               WHERE     f.ok_traid = 1
                     AND f.tn = st.tn
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
                     AND st.dpt_id = :dpt_id))
          files_bonus,
       DECODE (NVL (SUM (d.summa), 0), 0, 0, (SUM (an.bonus_d_fact) + SUM (an.bonus_t_fact)) / SUM (d.summa)) * 100 zat
  FROM choco_box d,
       choco_action_nakl an,
       user_list st,
       choco_tp_select tp
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
       AND DECODE (:ok_traid,  1, 0,  2, 1) = DECODE (:ok_traid,  1, 0,  2, an.ok_traid)
       AND DECODE (:ok_ts,  1, 0,  2, 1,  3, 0) = DECODE (:ok_ts,  1, 0,  2, an.ok_ts,  3, NVL (an.ok_ts, 0))
       AND DECODE (:ok_chief,  1, 0,  2, 1,  3, 0) = DECODE (:ok_chief,  1, 0,  2, an.ok_chief,  3, NVL (an.ok_chief, 0))
       AND DECODE (:act_month, 0, 0, :act_month) = DECODE (:act_month, 0, 0, TO_NUMBER (TO_CHAR (d.data, 'mm')))