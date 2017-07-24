<?
if (isset($_REQUEST["get_promoter"])){
    $params=array(':id' => $_REQUEST["id_t"], ':tp' => $_REQUEST["id_tp"],':promoter'=>$_REQUEST["promoter"]);
    //$sql = "SELECT t.* FROM tasting_promoter t WHERE t.t_id = :id AND t.tp = :tp";
    $sql = "SELECT fio from user_list where tn = :promoter";
    $sql = stritr($sql,$params);
    //echo $sql;
    //$r = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $r = $db->getOne($sql);
    $smarty->assign('x', $r);
} else if (isset($_REQUEST["list_promoter"])){
    $sql = "select promoter from tasting_promoter where t_id=".$_REQUEST["id_t"]." and tp=".$_REQUEST["id_tp"];
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
} else if (isset($_REQUEST["select_tasting"])){
    $sql = "SELECT t.*, TO_CHAR (t.dt, 'dd.mm.yyyy') dt FROM tasting t";
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
} else if (isset($_REQUEST["select_nets"])){
    $sql = "SELECT DISTINCT n.id_net, n.net_name
    FROM tasting_tp t, ms_nets n, cpp c
    WHERE t.t_id = '".$_REQUEST["id_t"]."' AND t.tp = c.kodtp AND c.id_net = n.id_net
    ORDER BY n.net_name";
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
} else if (isset($_REQUEST["select_tp"])){
    $sql = "  SELECT DISTINCT c.*
    FROM tasting_tp t, ms_nets n, cpp c
    WHERE     t.t_id = '".$_REQUEST["id_t"]."'
         AND t.tp = c.kodtp
         AND c.id_net = n.id_net
         AND n.id_net = '".$_REQUEST["id_net"]."'
    ORDER BY n.net_name";
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
} else if (isset($_REQUEST["select_promoter"])){
    $sql = "SELECT tn,
         fio,
         pos_id,
         pos_name,
         is_mkk,
         is_mkk_new,
         is_tm
    FROM user_list
   WHERE  (  is_tm = 1
         OR pos_id IN (69)
         OR     (    1 IN (is_mkk, is_mkk_new)
                 AND tn IN (SELECT slave
                              FROM full
                             WHERE master =
                                      (SELECT n.tn_tmkk
                                         FROM ms_nets n, cpp c
                                        WHERE     c.id_net = n.id_net
                                              AND c.kodtp = '".$_REQUEST["id_tp"]."')))
            AND datauvol IS NULL)
            AND '".$_REQUEST["id_tp"]."' <> 0
ORDER BY fio";
    //echo $sql;
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
} else if (isset($_REQUEST["save_promoter"])){
    $_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
    if (!isset($_REQUEST["tasting_promoter"])){
        Table_Update('tasting_promoter', array("t_id"=>$_REQUEST["tasting"],"tp"=>$_REQUEST["tp"]),null);
    } else {
        $r = $db->getCol("select promoter from tasting_promoter where t_id=".$_REQUEST["tasting"]." and tp=".$_REQUEST["tp"], null, null, null, 0);
        $delete = array_diff(array_values($r),array_keys($_REQUEST["tasting_promoter"]));
        foreach ($delete as $k=>$v){
            //echo $k."===".$v;
            $keys = array("t_id"=>$_REQUEST["tasting"],"tp"=>$_REQUEST["tp"],"promoter"=>$v);
            Table_Update('tasting_promoter', $keys, null);
        }
        foreach ($_REQUEST["tasting_promoter"] as $k=>$v){
            //echo $k."===".$v;
            $keys = array("t_id"=>$_REQUEST["tasting"],"tp"=>$_REQUEST["tp"],"promoter"=>$v);
            Table_Update('tasting_promoter', $keys, $keys);
        }
    }
    /*Table_Update('tasting_promoter', array(
        "t_id"=>$_REQUEST["tasting"],
        "tp"=>$_REQUEST["tp"]
        ),array("new_promoter"=>$_REQUEST["new_promoter"]));*/
    //print_r($_REQUEST);
    //print_r($_FILES);
}
//ses_req();
$smarty->display('tasting_promoter.html');