/* Formatted on 28/05/2015 16:53:45 (QP5 v5.227.12220.39724) */
SELECT COUNT (DISTINCT d.H_TP_KOD_DATA_NAKL) cnt_nakl,
       COUNT (DISTINCT d.tp_kod) cnt_tp,
       SUM (d.nakl_summ) nakl_summ,
       SUM (DECODE (an.bonus_dt1, NULL, NULL, an.bonus_sum1)) bonus_sum,
       SUM (DECODE (an.bonus_dt1, NULL, NULL, 1)) bonus_dt_cnt,
       SUM (          (SELECT DECODE (lu, NULL, 0, 1)
            FROM ACT_OK
           WHERE     tn = (SELECT parent
                             FROM parents
                            WHERE tn = st.tn)
                 AND m = :month and act=:act)
)
          ok_chief,
         DECODE (NVL (SUM (d.nakl_summ), 0),
                 0, 0,
                 (SUM (an.bonus_sum1)) / SUM (d.nakl_summ))
       * 100
          zat
  FROM a15return d, a15return_action_nakl an, user_list st
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
                          WHERE master = DECODE (:tn, -1, master, :tn))
            OR (SELECT NVL (is_traid, 0)
                  FROM user_list
                 WHERE tn = :tn) = 1)
       AND st.dpt_id = :dpt_id and st.is_spd=1
       AND d.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL(+)
       AND DECODE (:eta_list, '', d.h_fio_eta, :eta_list) = d.h_fio_eta
       AND DECODE (:ok_bonus,  1, 0,  2, 1,  3, 0) =
              DECODE (:ok_bonus,
                      1, 0,
                      2, DECODE (an.bonus_dt1, NULL, 0, 1),
                      3, DECODE (an.bonus_dt1, NULL, 0, 1))
       AND TO_NUMBER (TO_CHAR (d.data, 'mm')) = :month