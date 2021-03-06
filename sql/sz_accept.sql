/* Formatted on 12.01.2018 12:48:03 (QP5 v5.252.13127.32867) */
  SELECT sz.id,
         TO_CHAR (sz.created, 'dd.mm.yyyy hh24:mi:ss') created,
         sz.head,
         sz.body,
         sz.tn creator_tn,
         fn_getname (sz.tn) creator,
         fn_getname (sz.recipient) recipient,
         get_sz_current_status (sz.id) current_status,
         get_sz_current_acceptor_tn (sz.id) current_acceptor_tn,
         DECODE (get_sz_current_acceptor_tn (sz.id), :tn, 1, 0)
            allow_status_change,
         fn_getname (
            (SELECT tn
               FROM sz_accept
              WHERE     sz_id = sz.id
                    AND accept_order = (SELECT MIN (accept_order)
                                          FROM sz_accept
                                         WHERE sz_id = sz.id AND accepted = 0)))
            current_acceptor_name,
         sz_accept.tn acceptor_tn,
         fn_getname (sz_accept.tn) acceptor_name,
         sz_executors.tn executor_tn,
         fn_getname (sz_executors.tn) executor_name,
         sz_accept.accepted,
         sz_accept.failure,
         sz_accept.accept_order,
         szat.name accepted_name,
         DECODE (sz_accept.accepted,
                 0, NULL,
                 TO_CHAR (sz_accept.lu, 'dd.mm.yyyy hh24:mi:ss'))
            accepted_date,
         DECODE ( (SELECT COUNT (*)
                     FROM sz_accept
                    WHERE sz_id = sz.id AND accepted = 2),
                 0, 0,
                 1)
            deleted,
         f.fn,
         (SELECT id
            FROM sz_accept
           WHERE     sz_id = sz.id
                 AND accept_order = (SELECT MIN (accept_order)
                                       FROM sz_accept
                                      WHERE sz_id = sz.id AND accepted = 0))
            current_accept_id,
         (SELECT accept_order
            FROM sz_accept
           WHERE     sz_id = sz.id
                 AND accept_order = (SELECT MIN (accept_order)
                                       FROM sz_accept
                                      WHERE sz_id = sz.id AND accepted = 0))
            current_accept_order,
         sz_executors.execute_order,
         (SELECT id
            FROM sz_accept
           WHERE sz_id = sz.id AND tn = :tn)
            my_sz_accept,
         (SELECT accept_order
            FROM sz_accept
           WHERE sz_id = sz.id AND tn = :tn)
            my_accept_order,
         sc.name cat_name,
         fn_getname (a.tn) chater,
         a.text,
         a.lu chat_time_d,
         TO_CHAR (a.lu, 'dd.mm.yyyy hh24:mi:ss') chat_time,
         a.id chat_id,
         a.priority,
         /*(SELECT DECODE (COUNT (tn), 0, 0, 1) c
            FROM sz_accept
           WHERE     sz_id = sz.id
                 AND accept_order >=
                        ( (SELECT accept_order
                             FROM sz_accept
                            WHERE     sz_id = sz.id
                                  AND tn =
                                         (SELECT tn
                                            FROM sz_accept
                                           WHERE     sz_id = sz.id
                                                 AND accept_order =
                                                        (SELECT MIN (
                                                                   accept_order)
                                                           FROM sz_accept
                                                          WHERE     sz_id =
                                                                       sz.id
                                                                AND accepted =
                                                                       0))))
                 AND tn = :tn)
            allow_text,*/
         u.pos_name creator_pos_name,
         sz_executors.pos_name executor_pos_name,
         sz_executors.department_name executor_department_name,
         u1.pos_name acceptor_pos_name,
         u2.pos_name recipient_pos_name,
         u.department_name creator_department_name,
         u1.department_name acceptor_department_name,
         u2.department_name recipient_department_name,
         u.region_name
    FROM sz,
         sz_accept,
         (SELECT sze.*, szu.pos_name, szu.department_name
            FROM sz_executors sze, user_list szu
           WHERE sze.tn = szu.tn) sz_executors,
         accept_types szat,
         sz_files f,
         sz_cat sc,
         user_list u,
         user_list u1,
         user_list u2,
         sz_chat a
   WHERE     sz.tn = u.tn
         AND sz_accept.tn = u1.tn
         AND sz.recipient = u2.tn
         AND sz.id = sz_accept.sz_id(+)
         AND sz.id = sz_executors.sz_id(+)
         AND sz_accept.accepted = szat.id(+)
         AND a.sz_id(+) = sz.id
         AND sz.cat = sc.id(+)
         AND sz.id = f.sz_id(+)
         AND (   (SELECT tn
                    FROM sz_accept
                   WHERE     sz_id = sz.id
                         AND accept_order =
                                (SELECT MIN (accept_order)
                                   FROM sz_accept
                                  WHERE sz_id = sz.id AND accepted = 0)) = :tn
              OR sz.tn = :tn
              OR ( (SELECT accept_order
                      FROM sz_accept
                     WHERE     sz_id = sz.id
                           AND accept_order =
                                  (SELECT MIN (accept_order)
                                     FROM sz_accept
                                    WHERE sz_id = sz.id AND accepted = 0)) >=
                     (SELECT accept_order
                        FROM sz_accept
                       WHERE sz_id = sz.id AND tn = :tn)))
         AND DECODE ( (SELECT COUNT (*)
                         FROM sz_accept
                        WHERE sz_id = sz.id AND accepted = 2),
                     0, 0,
                     1) = 0
         AND get_sz_current_status (sz.id) <> 1
         AND DECODE ( :sz_cat, 0, 0, :sz_cat) = DECODE ( :sz_cat, 0, 0, sz.cat)
         AND DECODE ( :wait4myaccept, 0, :tn, 0) =
                DECODE ( :wait4myaccept,
                        0, get_sz_current_acceptor_tn (sz.id),
                        0)
ORDER BY id,
         accept_order,
         execute_order,
         chat_time_d