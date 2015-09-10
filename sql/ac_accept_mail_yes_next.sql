/* Formatted on 10.12.2013 15:52:08 (QP5 v5.227.12220.39724) */
SELECT fn_getname ( tn) fio,
       (SELECT e_mail
          FROM user_list
         WHERE tn = z.tn)
          email,
       tn
  FROM (                                           /*следующий согласователь*/
        SELECT tn
          FROM (  SELECT *
                    FROM ac_accept
                   WHERE     ac_id = (SELECT ac_id
                                        FROM ac_accept
                                       WHERE id = :accept_id)
                         AND accepted = 0
                ORDER BY accept_order)
         WHERE ROWNUM = 1) z