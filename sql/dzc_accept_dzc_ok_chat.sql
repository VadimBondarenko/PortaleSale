/* Formatted on 15.07.2013 11:51:37 (QP5 v5.227.12220.39724) */
  SELECT TO_CHAR (c.lu, 'dd.mm.yyyy hh24:mi:ss') lu,
         u.fio,
         c.text,
         u.department_name,
         u.pos_name
    FROM dzc_chat c, user_list u
   WHERE c.dzc_id = :dzc_id AND c.tn = u.tn
ORDER BY lu