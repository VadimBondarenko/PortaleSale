<?

audit("������ mz_spr_vis","mz");

if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("mz_spr_vis", array("id"=>$k),$v);
	}
}



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
                Table_Update("mz_spr_vis", array('id'=>$k),null);
	}
}

if (isset($_REQUEST["new"]))
{
	Table_Update("mz_spr_vis", array("name"=>$_REQUEST["new_name"]), array("name"=>$_REQUEST["new_name"]));
}

$sql=rtrim(file_get_contents('sql/mz_spr_vis.sql'));
$mz_spr_vis = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('mz_spr_vis', $mz_spr_vis);
$smarty->display('mz_spr_vis.html');

?>