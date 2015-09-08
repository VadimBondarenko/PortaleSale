/* Formatted on 15.07.2014 11:31:10 (QP5 v5.227.12220.39724) */
  SELECT z.*, DECODE (z.current_acceptor_tn, :tn, 1, 0) allow_status_change
    FROM (SELECT ac.id,
                 TO_CHAR (ac.created, 'dd.mm.yyyy hh24:mi:ss') created,
                 TO_CHAR (ac.dt, 'dd.mm.yyyy') dt,
                 ac.head,
                 ac.place,
                 ac.tn creator_tn,
                 u.fio creator,
                 u2.fio recipient,
                 u3.fio init,
                 NVL (
                    (SELECT accepted
                       FROM ac_accept
                      WHERE     ac_id = ac.id
                            AND accept_order =
                                   DECODE (
                                      NVL (
                                         (SELECT MAX (accept_order)
                                            FROM ac_accept
                                           WHERE     ac_id = ac.id
                                                 AND accepted = 464262),
                                         0),
                                      0, (SELECT MAX (accept_order)
                                            FROM ac_accept
                                           WHERE ac_id = ac.id),
                                      (SELECT MAX (accept_order)
                                         FROM ac_accept
                                        WHERE     ac_id = ac.id
                                              AND accepted = 464262))),
                    464260)
                    current_status,
                 (SELECT tn
                    FROM ac_accept
                   WHERE     ac_id = ac.id
                         AND accept_order =
                                (SELECT MIN (accept_order)
                                   FROM ac_accept
                                  WHERE ac_id = ac.id AND accepted = 464260))
                    current_acceptor_tn,
                 fn_getname (
                    (SELECT tn
                       FROM ac_accept
                      WHERE     ac_id = ac.id
                            AND accept_order =
                                   (SELECT MIN (accept_order)
                                      FROM ac_accept
                                     WHERE ac_id = ac.id AND accepted = 464260)))
                    current_acceptor_name,
                 ac_accept.tn acceptor_tn,
                 fn_getname ( ac_accept.tn) acceptor_name,
                 ac_accept.accepted,
                 ac_accept.failure,
                 ac_accept.accept_order,
                 acat.name accepted_name,
                 DECODE (ac_accept.accepted,
                         464260, NULL,
                         TO_CHAR (ac_accept.lu, 'dd.mm.yyyy hh24:mi:ss'))
                    accepted_date,
                 DECODE ( (SELECT COUNT (*)
                             FROM ac_accept
                            WHERE ac_id = ac.id AND accepted = 464262),
                         0, 0,
                         1)
                    deleted,
                 (SELECT id
                    FROM ac_accept
                   WHERE     ac_id = ac.id
                         AND accept_order =
                                (SELECT MIN (accept_order)
                                   FROM ac_accept
                                  WHERE ac_id = ac.id AND accepted = 464260))
                    current_accept_id,
                 (SELECT accept_order
                    FROM ac_accept
                   WHERE     ac_id = ac.id
                         AND accept_order =
                                (SELECT MIN (accept_order)
                                   FROM ac_accept
                                  WHERE ac_id = ac.id AND accepted = 464260))
                    current_accept_order,
                 (SELECT id
                    FROM ac_accept
                   WHERE ac_id = ac.id AND tn = :tn)
                    my_ac_accept,
                 (SELECT accept_order
                    FROM ac_accept
                   WHERE ac_id = ac.id AND tn = :tn)
                    my_accept_order,
                 fn_getname ( a.tn) chater,
                 a.text,
                 a.lu chat_time_d,
                 TO_CHAR (a.lu, 'dd.mm.yyyy hh24:mi:ss') chat_time,
                 a.id chat_id,
                 (SELECT DECODE (COUNT (tn), 0, 0, 1) c
                    FROM ac_accept
                   WHERE     ac_id = ac.id
                         AND accept_order >=
                                ( (SELECT accept_order
                                     FROM ac_accept
                                    WHERE     ac_id = ac.id
                                          AND tn =
                                                 (SELECT tn
                                                    FROM ac_accept
                                                   WHERE     ac_id = ac.id
                                                         AND accept_order =
                                                                (SELECT MIN (
                                                                           accept_order)
                                                                   FROM ac_accept
                                                                  WHERE     ac_id =
                                                                               ac.id
                                                                        AND accepted =
                                                                               464260))))
                         AND tn = :tn)
                    allow_text,
                 u.pos_name creator_pos_name,
                 u1.pos_name acceptor_pos_name,
                 u2.pos_name recipient_pos_name,
                 u3.pos_name init_pos_name,
                 u.department_name creator_department_name,
                 u1.department_name acceptor_department_name,
                 u2.department_name recipient_department_name,
                 u3.department_name init_department_name,
                 u.region_name,
                 uc.fio uc_fio,
                 umi.fio umi_fio,
                 me.fam || ' ' || me.im || ' ' || me.otch me_fio,
                 me.email,
                 me.resume,
                 ac.vac1,
                 ac.vac2,
                 ac.vac3,
                 p1.pos_name vac1_pos,
                 p2.pos_name vac2_pos,
                 p3.pos_name vac3_pos,
                 (SELECT name
                    FROM ac_test
                   WHERE id = mi.ac_test_logic)
                    mi_logic,
                 (SELECT name
                    FROM ac_test
                   WHERE id = me.ac_test_logic)
                    me_logic,
                 (SELECT name
                    FROM ac_test
                   WHERE id = mi.ac_test_math)
                    mi_math,
                 (SELECT name
                    FROM ac_test
                   WHERE id = me.ac_test_math)
                    me_math
            FROM ac,
                 ac_accept,
                 ac_accept_types acat,
                 user_list u,
                 user_list u1,
                 user_list u2,
                 user_list u3,
                 ac_chat a,
                 ac_comm c,
                 ac_memb_int mi,
                 ac_memb_ext me,
                 user_list uc,
                 user_list umi,
                 pos p1,
                 pos p2,
                 pos p3
           WHERE     ac.tn = u.tn
                 AND ac_accept.tn = u1.tn
                 AND ac.recipient = u2.tn
                 AND ac.init_tn = u3.tn
                 AND ac.id = c.ac_id(+)
                 AND ac.id = mi.ac_id(+)
                 AND ac.id = me.ac_id(+)
                 AND c.tn = uc.tn(+)
                 AND mi.tn = umi.tn(+)
                 AND ac.id = ac_accept.ac_id(+)
                 AND ac_accept.accepted = acat.id(+)
                 AND a.ac_id(+) = ac.id
                 AND (   (SELECT tn
                            FROM ac_accept
                           WHERE     ac_id = ac.id
                                 AND accept_order =
                                        (SELECT MIN (accept_order)
                                           FROM ac_accept
                                          WHERE     ac_id = ac.id
                                                AND accepted = 464260)) = :tn
                      OR ac.tn = :tn
                      OR ( (SELECT accept_order
                              FROM ac_accept
                             WHERE     ac_id = ac.id
                                   AND accept_order =
                                          (SELECT MIN (accept_order)
                                             FROM ac_accept
                                            WHERE     ac_id = ac.id
                                                  AND accepted = 464260)) >=
                             (SELECT accept_order
                                FROM ac_accept
                               WHERE ac_id = ac.id AND tn = :tn)))
                 AND DECODE ( (SELECT COUNT (*)
                                 FROM ac_accept
                                WHERE ac_id = ac.id AND accepted = 464262),
                             0, 0,
                             1) = 0
                 AND NVL (
                        (SELECT accepted
                           FROM ac_accept
                          WHERE     ac_id = ac.id
                                AND accept_order =
                                       DECODE (
                                          NVL (
                                             (SELECT MAX (accept_order)
                                                FROM ac_accept
                                               WHERE     ac_id = ac.id
                                                     AND accepted = 464262),
                                             0),
                                          0, (SELECT MAX (accept_order)
                                                FROM ac_accept
                                               WHERE ac_id = ac.id),
                                          (SELECT MAX (accept_order)
                                             FROM ac_accept
                                            WHERE     ac_id = ac.id
                                                  AND accepted = 464262))),
                        464260) <> 464261
                 AND ac.vac1_pos = p1.pos_id(+)
                 AND ac.vac2_pos = p2.pos_id(+)
                 AND ac.vac3_pos = p3.pos_id(+)) z
   WHERE DECODE (:wait4myaccept, 0, :tn, 0) =
            DECODE (:wait4myaccept, 0, z.current_acceptor_tn, 0)
ORDER BY z.id,
         z.accept_order,
         z.chat_time_d,
         z.uc_fio,
         z.umi_fio,
         z.me_fio