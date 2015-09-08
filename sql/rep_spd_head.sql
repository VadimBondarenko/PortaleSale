/* Formatted on 10.06.2015 16:27:25 (QP5 v5.227.12220.39724) */
  SELECT l.id,
         l.fio,
         l.tn,
         h.service,
         h.h_fio_eta,
         TO_CHAR (h.lu, 'dd.mm.yyyy hh24:mi:ss') last_gen,
         CASE
            WHEN (contract_end - TRUNC (SYSDATE)) BETWEEN 0 AND 30
            THEN
               'violet'
            WHEN TRUNC (SYSDATE) >= contract_end
            THEN
               'red'
         END
            contract_color
    FROM rep_spd_list l, rep_spd_head h
   WHERE     (   l.last_month IS NULL
              OR l.last_month >= TO_DATE (:month_list, 'dd.mm.yyyy'))
         AND h.dt(+) = TO_DATE (:month_list, 'dd.mm.yyyy')
         AND h.tn(+) = l.tn
ORDER BY l.fio