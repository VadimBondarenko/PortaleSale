/* Formatted on 13.02.2013 15:23:48 (QP5 v5.163.1008.3004) */
  SELECT tz.id, tz.addr, n.name
    FROM atd_tz tz, atd_nets n
   WHERE (tz.contr_avk = :id
          OR NVL ( (SELECT is_super
                      FROM atd_contr_avk
                     WHERE id = :id),
                  0) = 1)
         AND n.id = tz.nets
ORDER BY n.name, tz.addr