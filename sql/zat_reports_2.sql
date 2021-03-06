/* Formatted on 09/04/2015 13:02:28 (QP5 v5.227.12220.39724) */
  SELECT cse.*,
         fn_getname (cse.tn) fio,
         TO_CHAR (cse.datauvol, 'dd.mm.yyyy') datauvol_txt,
         NVL (zc.total, 0) + NVL (zt.total, 0) + NVL (zm.total, 0) total,
         NVL (zc.PET_VOL, 0)+nvl(zm.gbo_warmup_vol,0) PET_VOL,
         NVL (zc.PET_SUM, 0)+nvl(zm.gbo_warmup_sum,0) PET_SUM,
         NVL (zc.OIL_SUM, 0) OIL_SUM,
         NVL (zc.WASH, 0) WASH,
         NVL (zc.SERVICE, 0) SERVICE,
         NVL (zc.PARKING, 0) PARKING,
         NVL (zt.DAILY_COST, 0) DAILY_COST,
         NVL (zt.FOOD, 0) FOOD,
         NVL (zt.HOTEL, 0) HOTEL,
         NVL (zt.TRANSPORT, 0) TRANSPORT,
         NVL (zm.amort, 0) amort,
         NVL (zm.PRESENT_COST, 0) PRESENT_COST,
         NVL (zm.STATIONERY, 0) STATIONERY,
         NVL (zm.MEDIA_ADVERT, 0) MEDIA_ADVERT,
         NVL (zm.MAIL, 0) MAIL,
         NVL (zm.CONFERENCE, 0) CONFERENCE,
         NVL (zm.TRAINING_FOOD, 0) TRAINING_FOOD,
         NVL (zm.ESV, 0) ESV,
         NVL (zm.SINGLE_TAX, 0) SINGLE_TAX,
         NVL (zm.account_payments, 0) account_payments,
         NVL (zm.mobile, 0) mobile,
         l.*,
         zm.valuta
    FROM (SELECT c1.dt,
                 c1.mt,
                 c1.y,
                 e1.full,
                 s1.*
            FROM user_list s1,
                 (SELECT DISTINCT full, slave tn
                    FROM full
                   WHERE dpt_id = :dpt_id AND master = :exp_tn) e1,
                 (SELECT DISTINCT TRUNC (data, 'mm') dt, mt, y
                    FROM calendar
                   WHERE TRUNC (data, 'mm') BETWEEN TO_DATE (:sd, 'dd.mm.yyyy')
                                                AND TO_DATE (:ed, 'dd.mm.yyyy')) c1
           WHERE     S1.TN = e1.tn
                 AND s1.dpt_id = :dpt_id
                 AND s1.is_spd = 1
                 AND (INSTR (:full, TO_CHAR (e1.full)) > 0 OR e1.full = -2)) cse,
         (  SELECT TRUNC (zc.data, 'mm') dt,
                   zc.tn,
                   SUM (
                        NVL (PET_SUM, 0)
                      + NVL (OIL_SUM, 0)
                      + NVL (WASH, 0)
                      + NVL (SERVICE, 0)
                      + NVL (PARKING, 0))
                      total,
                   SUM (PET_VOL) PET_VOL,
                   SUM (PET_SUM) PET_SUM,
                   SUM (OIL_SUM) OIL_SUM,
                   SUM (WASH) WASH,
                   SUM (SERVICE) SERVICE,
                   SUM (PARKING) PARKING
              FROM zat_daily_car zc
             WHERE TRUNC (zc.data, 'mm') BETWEEN TO_DATE (:sd, 'dd.mm.yyyy')
                                             AND TO_DATE (:ed, 'dd.mm.yyyy')
          GROUP BY TRUNC (zc.data, 'mm'), zc.tn) zc,
         (  SELECT TRUNC (zt.data, 'mm') dt,
                   zt.tn,
                   SUM (
                        +NVL (DAILY_COST, 0)
                      + NVL (FOOD, 0)
                      + NVL (HOTEL, 0)
                      + NVL (TRANSPORT, 0))
                      total,
                   SUM (DAILY_COST) DAILY_COST,
                   SUM (FOOD) FOOD,
                   SUM (HOTEL) HOTEL,
                   SUM (TRANSPORT) TRANSPORT
              FROM zat_daily_trip zt
             WHERE TRUNC (zt.data, 'mm') BETWEEN TO_DATE (:sd, 'dd.mm.yyyy')
                                             AND TO_DATE (:ed, 'dd.mm.yyyy')
          GROUP BY TRUNC (zt.data, 'mm'), zt.tn) zt,
         (SELECT TO_DATE ('01.' || m || '.' || y, 'dd.mm.yyyy') dt,
                 zm.*,
                   NVL (PRESENT_COST, 0)
                 + NVL (STATIONERY, 0)
                 + NVL (MEDIA_ADVERT, 0)
                 + NVL (MAIL, 0)
                 + NVL (CONFERENCE, 0)
                 + NVL (TRAINING_FOOD, 0)
                 + NVL (ESV, 0)
                 + NVL (SINGLE_TAX, 0)
                 + NVL (account_payments, 0)
                 + NVL (mobile, 0)
                 + NVL (AMORT, 0)
               + NVL (gbo_warmup_sum, 0)
                    total,
                 (SELECT name
                    FROM currencies
                   WHERE id = zm.cur_id)
                    valuta
            FROM zat_monthly zm
           WHERE TO_DATE ('01.' || m || '.' || y, 'dd.mm.yyyy') BETWEEN TO_DATE (
                                                                           :sd,
                                                                           'dd.mm.yyyy')
                                                                    AND TO_DATE (
                                                                           :ed,
                                                                           'dd.mm.yyyy')) zm,
         limits_current l
   WHERE     cse.tn = zc.tn(+)
         AND cse.tn = zt.tn(+)
         AND cse.tn = zm.tn(+)
         AND cse.dt = zm.dt(+)
         AND cse.dt = zt.dt(+)
         AND cse.dt = zc.dt(+)
         AND cse.tn IN (SELECT slave
                          FROM full
                         WHERE master = :tn)
         AND cse.tn = l.tn(+)
         AND (NVL (zm.cur_id, 0) IN (:cur))
ORDER BY cse.pos_name,
         cse.fio,
         cse.dt,
         cse.mt