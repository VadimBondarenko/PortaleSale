select distinct wm,wm wm1 from calendar where trunc(data,'mm')=TO_DATE(:sd,'dd.mm.yyyy') order by wm