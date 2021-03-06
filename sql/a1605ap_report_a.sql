/* Formatted on 24/02/2016 15:25:34 (QP5 v5.252.13127.32867) */
  SELECT an.id,
         d.nakl,
         TO_CHAR (d.data, 'dd.mm.yyyy') data,
         d.fio_eta,
         d.tp_kod,
         d.tp_ur,
         d.nakl_summ,
         d.act_summ,
         /* TRUNC (d.act_summ / 1000) * 100 */
         d.act_summ * 14.43 max_bonus,
         d.tp_addr,
         NVL (an.if1, 0) selected_if1,
		 /*case when an.if1 = 2 then d.act_summ else 0 end sert_cnt,*/
         an.bonus_sum1,
		 an.fn,
         TO_CHAR (an.bonus_dt1, 'dd.mm.yyyy') bonus_dt1,
         (SELECT TO_CHAR (lu, 'dd.mm.yyyy hh24:mi:ss') lu
            FROM ACT_OK
           WHERE     tn = (SELECT parent
                             FROM parents
                            WHERE tn = st.tn)
                 AND m = :month
                 AND act = :act)
            ok_chief_date,
         (SELECT DECODE (lu, NULL, 0, 1)
            FROM ACT_OK
           WHERE     tn = (SELECT parent
                             FROM parents
                            WHERE tn = st.tn)
                 AND m = :month
                 AND act = :act)
            ok_chief,
         fn_getname ( (SELECT parent
                         FROM parents
                        WHERE tn = st.tn))
            parent_fio,
         (SELECT parent
            FROM parents
           WHERE tn = st.tn)
            parent_tn,
         st.fio ts_fio,
         st.tn ts_tn
    FROM a1605ap d,
         a1605ap_action_nakl an,
         user_list st,
         a1605ap_tp_select tp
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
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND d.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL
         AND d.tp_kod = tp.tp_kod
         AND DECODE ( :eta_list, '', d.h_fio_eta, :eta_list) = d.h_fio_eta
         AND NVL (an.if1, 0) > 0
         AND DECODE ( :ok_bonus, 0, 0, NVL (an.if1, 0)) = :ok_bonus
ORDER BY parent_fio,
         ts_fio,
         fio_eta,
         data,
         nakl