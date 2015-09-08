/* Formatted on 24.07.2014 15:09:19 (QP5 v5.227.12220.39724) */
  SELECT ID,
         FAM,
         IM,
         OTCH,
         ADDRESS,
         DOLGN,
         TO_CHAR (BIRTHDAY, 'dd.mm.yyyy') BIRTHDAY,
         EMAIL,
         TO_CHAR (FDATA, 'dd.mm.yyyy') fdata,
         TO_CHAR (DATAPER, 'dd.mm.yyyy') DATAPER,
         TO_CHAR (DATAUVOL, 'dd.mm.yyyy') DATAUVOL,
         TO_CHAR (DATASTART, 'dd.mm.yyyy') DATASTART,
         PHONE,
         DOGOVORNUM,
         TO_CHAR (DOGOVORDATA, 'dd.mm.yyyy') DOGOVORDATA,
         DOGOVOROPL,
         DOGOVORUSLUGI,
         SVIDREGNUM,
         TO_CHAR (SVIDREGDATA, 'dd.mm.yyyy') SVIDREGDATA,
         SVIDREGVID,
         SVIDENNUM,
         TO_CHAR (SVIDENDATA, 'dd.mm.yyyy') SVIDENDATA,
         SVIDENINN,
         SVIDENPLACE,
         BANKNAME,
         REKVBANK,
         REKVMFO,
         REKVOKPO,
         REKVRS,
         REKVPLAT,
         OPLATAKAT,
         OPLATASTAVKA,
         OPLATABONUS,
         l.LIMITKOM,
         l.LIMITTRANS,
         l.LIMITPIT,
         l.LIMITPRED,
         l.LIMITKANC,
         l.LIMITMOB,
         l.LIMIT_CAR_VOL,
         LIMITPER,
         AVANS,
         amort,
         CAR_BRAND,
         CAR_RASHOD,
         TAB_NUM,
         POS_ID,
         s.DPT_ID,
         d.dpt_name,
         d.cnt_name,
         d.cnt_kod,
         d.sort,
         s.rekvdpt,
         s.rekvschet,
         s.department_name,
         s.region_name,
         s.skype,
         s.res,
         s.res_pos_id,
         TO_CHAR (res_dt, 'dd.mm.yyyy') res_dt
    FROM PERSIK.SPDTREE s, departments d, limits_current l
   WHERE s.dpt_id = D.DPT_ID AND id = :id AND s.svideninn = l.tn(+)
ORDER BY d.sort,
         fam,
         im,
         otch