select z.*,to_char(birthday,'dd.mm.yyyy') birthday from bud_fil_contacts z where fil=:id order by id