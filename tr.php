<?


//ses_req();


audit("������ tr","bud");

if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("tr", array("id"=>$k),$v);
	}
}



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		$db->extended->autoExecute("tr", null, MDB2_AUTOQUERY_DELETE, "id=".$k);
	}
}

if (isset($_REQUEST["new"]))
{
	$affectedRows = $db->extended->autoExecute("tr",
		array
		(
			"name"=>$_REQUEST["new_name"],
			"for_eta"=>$_REQUEST["new_for_eta"],
			"kod"=>$_REQUEST["new_kod"],
			"max_stud"=>$_REQUEST["new_max_stud"],
			"days"=>$_REQUEST["new_days"],
			"test_len"=>$_REQUEST["new_test_len"],
			"text" => $_REQUEST["new_text"]
		), MDB2_AUTOQUERY_INSERT);
}

$sql=rtrim(file_get_contents('sql/tr_all.sql'));
$p = array(":dpt_id" => $_SESSION["dpt_id"]);
$sql=stritr($sql,$p);
$tr = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tr', $tr);
$smarty->display('tr.html');

?>