/* Formatted on 20.06.2014 12:45:51 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT u.department_name
    FROM user_list u, bud_fil f, bud_tn_fil tf
   WHERE     f.id = tf.bud_id
         AND tf.tn = u.tn
         AND f.dpt_id = :dpt_id
         AND u.tn > 0
         AND TRIM (u.department_name) IS NOT NULL
         AND (   u.tn IN (SELECT slave
                            FROM full
                           WHERE master IN
                                     (SELECT parent
                                         FROM assist
                                        WHERE child = :tn AND dpt_id = :dpt_id
                                       UNION
                                       SELECT :tn FROM DUAL))
              OR (SELECT NVL (is_admin, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_super, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
ORDER BY u.department_name