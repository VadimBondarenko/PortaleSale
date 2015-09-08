/* Formatted on 25/12/2014 15:15:27 (QP5 v5.227.12220.39724) */
  SELECT n.net_name,
         z.*,
         pt.name,
         n.tn_mkk,
         n.tn_rmkk,
         umkk.fio mkk,
         urmkk.fio rmkk,
         c.mt || ' ' || c.y period
    FROM (SELECT (SELECT id_net
                    FROM nets
                   WHERE sw_kod = npf.id_net)
                    id_net,
                 YEAR,
                 MONTH,
                 3 plan_type,
                 plan sales
            FROM networkplanfact npf
          UNION
          SELECT (SELECT id_net
                    FROM nets
                   WHERE sw_kod = npf.id_net)
                    id_net,
                 YEAR,
                 MONTH,
                 6 plan_type,
                 fakt sales
            FROM networkplanfact npf
          UNION
          SELECT py.id_net,
                 py.year,
                 mk.month,
                 py.plan_type,
                 py.sales / 100 * mk.koeff sales
            FROM nets_plan_year py, month_koeff mk
           WHERE py.plan_type IN (1, 2)) z,
         nets_plan_type pt,
         nets n,
         user_list umkk,
         user_list urmkk,
         (SELECT DISTINCT y, my, mt
            FROM calendar
           WHERE TRUNC (data, 'mm') BETWEEN TRUNC (TO_DATE (:sd, 'dd.mm.yyyy'),
                                                   'mm')
                                        AND TRUNC (TO_DATE (:ed, 'dd.mm.yyyy'),
                                                   'mm')) c
   WHERE     z.plan_type = pt.id
         AND z.id_net = n.id_net
         AND umkk.tn = n.tn_mkk
         AND urmkk.tn = n.tn_rmkk
         AND c.y = z.year
         AND c.my = z.month
         AND DECODE (:net, 0, n.id_net, :net) = n.id_net
         AND DECODE (:tn_rmkk, 0, n.tn_rmkk, :tn_rmkk) = n.tn_rmkk
         AND DECODE (:tn_mkk, 0, n.tn_mkk, :tn_mkk) = n.tn_mkk
         AND (   n.tn_rmkk IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
              OR n.tn_mkk IN (SELECT slave
                                FROM full
                               WHERE master = :tn)
              OR (SELECT NVL (is_super, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
ORDER BY z.plan_type,
         pt.name,
         rmkk,
         mkk,
         n.net_name,
         z.id_net,
         z.year,
         z.month