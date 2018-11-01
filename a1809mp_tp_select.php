﻿<?php

if (isset($_REQUEST["save"])) {
    if (isset($_REQUEST["data"])) {
        foreach ($_REQUEST["data"] as $key => $val) {
            $keys = array('tp_kod' => $key);
            Table_Update("a1809mp_select", $keys, $val);
        }
    }
    if (isset($_REQUEST["del"])) {
        foreach ($_REQUEST["del"] as $key => $val) {
            Table_Update("a1809mp_select", array('tp_kod' => $key), null);
        }
    }
}
$params = array(':dpt_id' => $_SESSION["dpt_id"], ':tn' => $tn);
$sql = rtrim(file_get_contents('sql/a1809mp_tp_select.sql'));
$sql = stritr($sql, $params);
$tp = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tp', $tp);
$sql = rtrim(file_get_contents('sql/a1809mp_tp_select_total.sql'));
$sql = stritr($sql, $params);
$tp = $db->getOne($sql);
$smarty->assign('tp_total', $tp);
$smarty->display('a1809mp_tp_select.html');
?>