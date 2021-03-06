/* Formatted on 1/11/2016 12:41:09  (QP5 v5.252.13127.32867) */
INSERT INTO nets_plan_month (id_net,
                             YEAR,
                             MONTH,
                             statya,
                             descript,
                             payment_type,
                             payment_format,
                             bonus,
                             price,
                             cnt,
                             plan_type,
                             mkk_ter,
                             payer)
   SELECT n1.id_net,
          n1.YEAR,
          n1.MONTH,
          n1.statya,
          n1.descript,
          n1.payment_type,
          n1.payment_format,
          n1.bonus,
          n1.price,
          n1.cnt,
          2,
          n1.mkk_ter,
          n1.payer
     FROM nets_plan_month n1
          LEFT JOIN (SELECT *
                       FROM nets_plan_month
                      WHERE plan_type = 2) n2
             ON     n1.id_net = n2.id_net
                AND n1.YEAR = n2.YEAR
                AND n1.MONTH = n2.MONTH
                AND n1.statya = n2.statya
                AND NVL (n1.descript, ' ') = NVL (n2.descript, ' ')
                AND NVL (n1.payment_type, 0) = NVL (n2.payment_type, 0)
                AND NVL (n1.payment_format, 0) = NVL (n2.payment_format, 0)
                AND NVL (n1.bonus, 0) = NVL (n2.bonus, 0)
                AND NVL (n1.price, 0) = NVL (n2.price, 0)
                AND NVL (n1.cnt, 0) = NVL (n2.cnt, 0)
                AND NVL (n1.mkk_ter, 0) = NVL (n2.mkk_ter, 0)
                AND NVL (n1.payer, 0) = NVL (n2.payer, 0)
    WHERE     n1.plan_type = 1
          AND n1.id_net = :id_net
          AND n1.YEAR = :YEAR
          AND n2.plan_type IS NULL