<?
InitRequestVar("exp_list_without_ts",0);
InitRequestVar("exp_list_only_ts",0);
InitRequestVar("eta_list",$_SESSION["h_eta"]);
InitRequestVar("fil",0);
InitRequestVar("clusters",0);
InitRequestVar("dt",$_SESSION["month_list"]);
$params=array(
	':tn' => $tn,
	':dpt_id' => $_SESSION["dpt_id"],
	':dt' => "'".$_REQUEST["dt"]."'",
	':eta_list' => "'".$_REQUEST["eta_list"]."'",
	':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
	':exp_list_only_ts' => $_REQUEST["exp_list_only_ts"],
	':fil' => $_REQUEST["fil"],
	':clusters' => $_REQUEST["clusters"],
);
$sql = rtrim(file_get_contents('sql/bud_svod_all_zay_list.sql'));
$sql=stritr($sql,$params);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
foreach ($x as $k=>$v)
{
$params1=$params;
$params1[':fil']=$v['id'];
$sql = rtrim(file_get_contents('sql/bud_svod_all_zay_zay.sql'));
$sql=stritr($sql,$params1);
$x[$k]['zay'] = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$sql = rtrim(file_get_contents('sql/bud_svod_all_zay_zay_total.sql'));
$sql=stritr($sql,$params1);
$x[$k]['zay_total'] = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
}
$smarty->assign('list', $x);
$smarty->display('bud_svod_all_zay_list.html');
?>