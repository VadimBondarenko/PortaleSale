/* Formatted on 19.06.2014 10:59:22 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT u.department_name
    FROM user_list u
   WHERE u.tn > 0 AND TRIM (u.department_name) IS NOT NULL and dpt_id=:dpt_id
ORDER BY u.department_name