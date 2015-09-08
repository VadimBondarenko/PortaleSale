/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1504cy.tab_num,
         st.fio fio_ts,
         a1504cy.fio_eta,
         a1504cy.tp_ur,
         a1504cy.tp_addr,
         a1504cy.tp_kod,
         a1504cytps.contact_lpr
    FROM a1504cy_tp_select a1504cytps, a1504cy, user_list st
   WHERE     a1504cy.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1504cy.tp_kod = a1504cytps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a1504cy.h_fio_eta, :eta_list) =
                a1504cy.h_fio_eta
GROUP BY a1504cy.tab_num,
         st.fio,
         a1504cy.fio_eta,
         a1504cy.tp_ur,
         a1504cy.tp_addr,
         a1504cy.tp_kod,
         a1504cytps.contact_lpr
ORDER BY st.fio,
         a1504cy.fio_eta,
         a1504cy.tp_ur,
         a1504cy.tp_addr