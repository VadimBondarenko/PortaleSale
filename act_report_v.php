<?php

$params=array(
    ':tn' => $tn,
    ':dpt_id' => $_SESSION["dpt_id"],
    ':month' => $_REQUEST['month'],
    ':act' => "'".$_REQUEST['act']."'",
);


$smarty->assign('act_name', $db->getOne('select act_name from bud_act_fund WHERE act = \''.$_REQUEST['act'].'\' AND ROWNUM = 1'));


$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);

if (isset($_REQUEST["save"]))
{
    if (isset($_REQUEST["data"]))
    {
        foreach($_REQUEST["data"] as $k=>$v)
        {
            $keys = array('tn'=>$k,'m'=>$_REQUEST['month'],'act'=>$_REQUEST['act']);
            Table_Update ('act_ok', $keys, $v);
        }
    }
    if (isset($_REQUEST["fund"]))
    {
        $keys = array('act'=>$_REQUEST['act'],"TO_NUMBER (TO_CHAR (act_month, 'mm'))"=>$_REQUEST['month']);
	isset($_REQUEST["m"])?$_REQUEST["m"]=OraDate2MDBDate($_REQUEST["m"]):null;
        $vals = array(
		'fund_id'=>$_REQUEST["fund"],
		'dtz'=>$_REQUEST["m"]
	);
        Table_Update ('bud_act_fund', $keys, $vals);
    }
}

$sql=rtrim(file_get_contents("sql/".$_REQUEST['act']."_report_v.sql"));
$sql=stritr($sql,$params);
$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign("list", $d);

$sql=rtrim(file_get_contents('sql/bud_funds.sql'));
$p = array(":dpt_id" => $_SESSION["dpt_id"]);
$sql=stritr($sql,$p);
$bud_funds = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bud_funds', $bud_funds);

$sql=rtrim(file_get_contents('sql/bud_act_fund_get.sql'));
$p = array(":act" => "'".$_REQUEST['act']."'",":m"=>$_REQUEST['month']);
$sql=stritr($sql,$p);
$act = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('act', $act);

$smarty->assign('m_cur', get_month_name($_REQUEST['month']));

$smarty->display('act_report_v.html');

?>