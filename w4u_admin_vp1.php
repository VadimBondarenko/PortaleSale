<?php

audit("������ w4u_admin_vp1","w4u");

//ses_req();

InitRequestVar("ml1",'');

$sql = rtrim(file_get_contents('sql/w4u_admin_vp1_ml1.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('ml1', $res);



if (isset($_REQUEST["copy"]))
{
	$p=array();
	$p[':ml1'] = "'".$_REQUEST["ml1"]."'";
	$sql = rtrim(file_get_contents('sql/w4u_admin_vp1_copy.sql'));
	$sql=stritr($sql,$p);
	$res = $db->query($sql);

//echo $sql;
}

if (isset($_REQUEST["save"]))
{
	$keys=array(
		'm'=>OraDate2MDBDate($_REQUEST['ml1'])
	);
	Table_Update('w4u_vp1',$keys,null);
	$keys=array(
		'm'=>OraDate2MDBDate($_REQUEST['ml1']),
		/*'bm'=>OraDate2MDBDate($_REQUEST['ml2'])*/
		'bm'=>OraDate2MDBDate($_REQUEST['ml1'])
	);
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		$keys['h_groupname']=$k;
		//print_r($_REQUEST['data'][$k]);
		Table_Update('w4u_vp1',$keys,$_REQUEST['data'][$k]);
	}
	$p=array();
	//$p[':ml1'] = "'".$_REQUEST["ml1"]."'";
	//$p[':ml2'] = "'".$_REQUEST["ml2"]."'";
	//$p[':ml2'] = "'".$_REQUEST["ml1"]."'";
	//$sql = rtrim(file_get_contents('sql/w4u_admin_vp1_transit_copy.sql'));
	//$sql=stritr($sql,$p);
	//$res = $db->query($sql);
	$db->query('BEGIN w4u_list1_update; END;');
}

if (isset($_REQUEST["transit"]))
{
	$p=array();
	$p[':ml1'] = "'".$_REQUEST["ml1"]."'";
	//$p[':ml2'] = "'".$_REQUEST["ml1"]."'";
	$sql = rtrim(file_get_contents('sql/w4u_admin_vp1_transit_copy.sql'));
	$sql=stritr($sql,$p);
	$res = $db->query($sql);
	$db->query('BEGIN w4u_list1_update; END;');
}

if (isset($_REQUEST["select"])||isset($_REQUEST["copy"])||isset($_REQUEST["save"])||isset($_REQUEST["transit"]))
{
	$sql = rtrim(file_get_contents('sql/w4u_admin_vp1_ml2.sql'));
	$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('ml2', $res);

	$p=array();
	$p[':ml1'] = "'".$_REQUEST["ml1"]."'";

	$sql = rtrim(file_get_contents('sql/w4u_admin_vp1_prod_list.sql'));
	$sql=stritr($sql,$p);
	$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('pl', $res);
	//print_r($res);
}

$smarty->display('w4u_admin_vp1.html');

?>