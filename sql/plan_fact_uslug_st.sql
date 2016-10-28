/* Formatted on 23/06/2016 15:42:04 (QP5 v5.252.13127.32867) */
  SELECT sn.parent,
         (SELECT cost_item
            FROM statya
           WHERE id = sn.parent)
            cost_item_parent,
         sn.id,
         sn.cost_item,
         SUM (fin.cnt) fin_cnt,
         SUM (fin.total) fin_total,
         AVG (fin.bonus) fin_bonus,
         SUM (oper.cnt) o_cnt,
         SUM (oper.total) o_total,
         AVG (oper.bonus) o_bonus,
         SUM (fu.cnt) fu_cnt,
         SUM (fu.total) fu_total,
         AVG (fu.bonus) fu_bonus
    FROM (SELECT n1.net_name,
                 n1.id_net,
                 n1.tn_mkk,
                 n1.tn_rmkk,
                 n1.my MONTH,
                 CASE
                    WHEN :mgroups = 1 THEN plan
                    WHEN :mgroups = 3 THEN plan_ng
                    WHEN :mgroups = 2 THEN plan_coffee
                 END
                    PLAN,
                   CASE
                      WHEN :mgroups = 1 THEN fakt
                      WHEN :mgroups = 3 THEN fakt_ng
                      WHEN :mgroups = 2 THEN fakt_coffee
                   END
                 / 1000
                    fakt
            FROM (SELECT DISTINCT n.*, c.my, c.y
                    FROM nets n, calendar c
                   WHERE c.y = :y) n1,
                 networkplanfact npf
           WHERE     n1.y = npf.YEAR(+)
                 AND n1.my = npf.month(+)
                 AND n1.sw_kod = npf.id_net(+)) n,
         (SELECT y.id_net,
                 c.my month,
                   NVL (
                      CASE
                         WHEN :mgroups = 1 THEN sales
                         WHEN :mgroups = 3 THEN sales_ng
                         WHEN :mgroups = 2 THEN sales_coffee
                      END,
                      0)
                 * CASE
                      WHEN :mgroups = 1 THEN mk.koeff
                      WHEN :mgroups = 3 THEN mk.koeff_ng
                      WHEN :mgroups = 2 THEN mk.koeff_coffee
                   END
                 / 100
                    sales
            FROM (SELECT DISTINCT my
                    FROM calendar
                   WHERE y = :y) c,
                 month_koeff mk,
                 nets_plan_year y
           WHERE mk.MONTH(+) = c.my AND y.YEAR = :y AND y.plan_type = 1) y,
         (SELECT DISTINCT statya,
                          id_net,
                          payment_format,
                          pf.pay_format,
                          MONTH
            FROM nets_plan_month m, statya s, payment_format pf
           WHERE     plan_type IN (1, 3, 4)
                 AND DECODE ( :payment_type, 0, m.payment_type, :payment_type) =
                        m.payment_type
                 AND CASE
                        WHEN s.parent NOT IN (42, 96882041) THEN 1
                        WHEN s.parent = 96882041 THEN 2
                        WHEN s.parent = 42 THEN 3
                     END IN ( :mgroups)
                 AND DECODE ( :statya_list, 0, s.ID, :statya_list) = s.ID
                 AND m.statya = s.id
                 AND YEAR = :y
                 AND payment_format = pf.id) st,
         statya sn,
         (  SELECT statya,
                   id_net,
                   SUM (cnt) cnt,
                   SUM (total) total,
                   SUM (bonus) bonus,
                   MONTH,
                   payment_format
              FROM nets_plan_month m, statya s
             WHERE     plan_type = 1
                   AND DECODE ( :payment_type, 0, m.payment_type, :payment_type) =
                          m.payment_type
                   AND CASE
                          WHEN s.parent NOT IN (42, 96882041) THEN 1
                          WHEN s.parent = 96882041 THEN 2
                          WHEN s.parent = 42 THEN 3
                       END IN ( :mgroups)
                   AND DECODE ( :statya_list, 0, s.ID, :statya_list) = s.ID
                   AND m.statya = s.id
                   AND YEAR = :y
          GROUP BY statya,
                   id_net,
                   MONTH,
                   payment_format) fin,
         (  SELECT statya,
                   id_net,
                   SUM (cnt) cnt,
                   SUM (total) total,
                   SUM (bonus) bonus,
                   MONTH,
                   payment_format
              FROM nets_plan_month m, statya s
             WHERE     plan_type = 3
                   AND DECODE ( :payment_type, 0, m.payment_type, :payment_type) =
                          m.payment_type
                   AND CASE
                          WHEN s.parent NOT IN (42, 96882041) THEN 1
                          WHEN s.parent = 96882041 THEN 2
                          WHEN s.parent = 42 THEN 3
                       END IN ( :mgroups)
                   AND DECODE ( :statya_list, 0, s.ID, :statya_list) = s.ID
                   AND m.statya = s.id
                   AND YEAR = :y
          GROUP BY statya,
                   id_net,
                   MONTH,
                   payment_format) oper,
         (  SELECT statya,
                   id_net,
                   SUM (cnt) cnt,
                   SUM (total) total,
                   SUM (bonus) bonus,
                   MONTH,
                   payment_format
              FROM nets_plan_month m, statya s
             WHERE     plan_type = 4
                   AND DECODE ( :payment_type, 0, m.payment_type, :payment_type) =
                          m.payment_type
                   AND CASE
                          WHEN s.parent NOT IN (42, 96882041) THEN 1
                          WHEN s.parent = 96882041 THEN 2
                          WHEN s.parent = 42 THEN 3
                       END IN ( :mgroups)
                   AND DECODE ( :statya_list, 0, s.ID, :statya_list) = s.ID
                   AND m.statya = s.id
                   AND YEAR = :y
          GROUP BY statya,
                   id_net,
                   MONTH,
                   payment_format) fu
   WHERE     (       :alg = 1
                 AND ( :calendar_months = 0 OR :calendar_months = st.month)
              OR (    :alg = 2
                  AND (   :calendar_months = 0
                       OR (st.month BETWEEN 1 AND :calendar_months))))
         AND st.id_net = n.id_net(+)
         AND st.month = n.month(+)
         AND st.id_net = y.id_net(+)
         AND st.month = y.month(+)
         AND st.month = oper.month(+)
         AND st.month = fu.month(+)
         AND sn.ID = st.statya
         AND st.id_net = y.id_net
         AND st.statya = oper.statya(+)
         AND st.id_net = oper.id_net(+)
         AND st.payment_format = oper.payment_format(+)
         AND st.statya = fu.statya(+)
         AND st.id_net = fu.id_net(+)
         AND st.payment_format = fu.payment_format(+)
         AND st.month = fin.month(+)
         AND st.statya = fin.statya(+)
         AND st.id_net = fin.id_net(+)
         AND st.payment_format = fin.payment_format(+)
         AND :tn IN (DECODE (
                        (SELECT pos_id
                           FROM spdtree
                          WHERE svideninn = :tn),
                        24, n.tn_mkk,
                        34, n.tn_rmkk,
                        63, :tn,
                        65, :tn,
                        67, :tn,
                        (SELECT pos_id
                           FROM user_list
                          WHERE tn = :tn AND (is_super = 1 OR is_admin = 1)), :tn))
         AND DECODE ( :tn_rmkk, 0, n.tn_rmkk, :tn_rmkk) = n.tn_rmkk
         AND DECODE ( :tn_mkk, 0, n.tn_mkk, :tn_mkk) = n.tn_mkk
         AND DECODE ( :nets, 0, n.id_net, :nets) = n.id_net
         AND (   n.id_net IN (SELECT kk_flt_nets_detail.id_net
                                FROM kk_flt_nets, kk_flt_nets_detail
                               WHERE     kk_flt_nets.id = :flt_id
                                     AND kk_flt_nets.id =
                                            kk_flt_nets_detail.id_flt)
              OR :flt_id = 0)
GROUP BY sn.id, sn.parent, sn.cost_item
ORDER BY cost_item