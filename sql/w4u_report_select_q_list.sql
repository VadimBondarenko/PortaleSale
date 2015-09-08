/* Formatted on 26.03.2013 14:44:55 (QP5 v5.163.1008.3004) */
  SELECT DISTINCT TO_CHAR (TRUNC (c.data, 'q'), 'dd.mm.yyyy') dt, c.q, c.y
    FROM calendar c
   WHERE c.data BETWEEN (SELECT MIN (m) FROM w4u_vp) AND (SELECT MAX (m) FROM w4u_vp)
ORDER BY c.y, c.q