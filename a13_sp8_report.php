<?php

//audit("����� � ������ �����");

//ses_req();

InitRequestVar("exp_list_without_ts",0);
InitRequestVar("exp_list_only_ts",0);
InitRequestVar("eta_list",$_SESSION["h_eta"]);
InitRequestVar("ok_traid",1);
InitRequestVar("ok_chief",1);

$params=array(':dpt_id' => $_SESSION["dpt_id"],
	':tn'=>$tn,
	':eta_list' => "'".$_REQUEST["eta_list"]."'",
	':ok_traid' => $_REQUEST["ok_traid"],
	':ok_chief' => $_REQUEST["ok_chief"],
	':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
	':exp_list_only_ts' => $_REQUEST["exp_list_only_ts"]
);

$sql = rtrim(file_get_contents('sql/exp_list_from_parent_only_ts.sql'));
$sql=stritr($sql,$params);
$exp_list_only_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_only_ts', $exp_list_only_ts);

$sql = rtrim(file_get_contents('sql/exp_list_from_parent_without_ts.sql'));
$sql=stritr($sql,$params);
$exp_list_without_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_without_ts', $exp_list_without_ts);

$sql = rtrim(file_get_contents('sql/a13_sp8_report_eta_list.sql'));
$sql=stritr($sql,$params);
$eta_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('eta_list', $eta_list);

if (isset($_REQUEST["generate"]))
{
if (isset($_REQUEST["save"]))
{
	if (isset($_REQUEST["data"]))
	{
		$table_name = 'a13_sp8_action_nakl';
		foreach($_REQUEST["data"] as $k=>$v)
		{
			isset($v['bonus_dt'])?$v['bonus_dt']=OraDate2MDBDate($v['bonus_dt']):null;
			$keys = array('h_tp_kod_data_nakl'=>$k);
			Table_Update ($table_name, $keys, $v);
		}
	}
	if (isset($_REQUEST["data_files"]))
	{
		$table_name = 'a13_sp8_files';
		foreach($_REQUEST["data_files"] as $k=>$v)
		{
			$keys = array('id'=>$k);
			Table_Update ($table_name, $keys, $v);
		}
	}
}

$sql=rtrim(file_get_contents("sql/a13_sp8_report.sql"));
$sql=stritr($sql,$params);
//echo $sql;
$list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign("list", $list);

$sql=rtrim(file_get_contents("sql/a13_sp8_report_itogi.sql"));
$sql=stritr($sql,$params);
$list = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign("itogi", $list);

$d1=array();

$sql=rtrim(file_get_contents('sql/a13_sp8_files.sql'));
$sql=stritr($sql,$params);
$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

if (isset($d))
{
foreach ($d as $k=>$v)
{
$d1[$v["tn"]]["data"][$v["id"]]=$v;
}
}

$sql=rtrim(file_get_contents('sql/a13_sp8_files_total.sql'));
$sql=stritr($sql,$params);
$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);


//echo $sql;

if (isset($d))
{
foreach ($d as $k=>$v)
{
$d1[$v["tn"]]["data_total"]=$v;
}
}

if (isset($d1))
{
$smarty->assign('file_list', $d1);
}

$sql=rtrim(file_get_contents('sql/a13_sp8_files_total_total.sql'));
$sql=stritr($sql,$params);
$d = $db->getOne($sql);
$smarty->assign('file_list_total', $d);



}

$smarty->display('a13_sp8_report.html');

?>