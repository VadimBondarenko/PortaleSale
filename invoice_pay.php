<?
isset($_REQUEST["debug"])?ses_req():null;

audit("������ invoice_pay","invoice_pay");

InitRequestVar("nets");
InitRequestVar("tn_rmkk");
InitRequestVar("tn_mkk");
InitRequestVar("sort");
InitRequestVar("show");
InitRequestVar("urlic");
InitRequestVar("sd",$_REQUEST["month_list"]);
InitRequestVar("ed",$_REQUEST["month_list"]);
InitRequestVar("act_prov_month"/*,$_REQUEST["month_list"]*/);
InitRequestVar("oplata_date"/*,$_REQUEST["month_list"]*/);

if (isset($_REQUEST["save"])&&isset($_REQUEST["ok1"]))
{
	foreach ($_REQUEST["ok1"] as $k=>$v)
	{
		$keys["id"]=$k;
		foreach ($v as $k1=>$v1)
		{
			if ($v1!="")
			{
				$vals=array($k1=>$v1);
				//print_r($keys);
				//print_r($vals);
				Table_Update ("invoice", $keys, $vals);
			}
		}
	}
}

if (isset($_REQUEST["save"])&&isset($_REQUEST["date"]))
{
	foreach ($_REQUEST["date"] as $k=>$v)
	{
		$keys["id"]=$k;
		foreach ($v as $k1=>$v1)
		{
			if ($v1!="")
			{
				$vals=array($k1=>OraDate2MDBDate($v1));
			}
			else
			{
				$vals=array($k1=>null);
			}
			Table_Update ("invoice", $keys, $vals);
		}
	}
}

if (isset($_REQUEST["save"])&&isset($_REQUEST["comm"]))
{
	foreach ($_REQUEST["comm"] as $k=>$v)
	{
		$keys["id"]=$k;
		foreach ($v as $k1=>$v1)
		{
			if ($v1!="")
			{
				$vals=array($k1=>$v1);
			}
			else
			{
				$vals=array($k1=>null);
			}
			Table_Update ("invoice", $keys, $vals);
		}
	}
}

if (isset($_REQUEST["sendmsg"]))
{
	foreach ($_REQUEST["sendmsg"] as $k=>$v)
	{
		if (isset($_REQUEST["comm"][$k]))
		{
			if ($_REQUEST["comm"][$k]["comm"]!="")
			{
				$num=$db->getOne("select num from invoice where id=".$k);
				$data=$db->getOne("select TO_CHAR (data, 'dd.mm.yyyy') from invoice where id=".$k);
				$mail_mkk=$db->getOne("select e_mail from user_list where tn=(select tn_mkk from nets where id_net=(select id_net from invoice where id=".$k."))");
				$mail_rmkk=$db->getOne("select e_mail from user_list where tn=(select tn_rmkk from nets where id_net=(select id_net from invoice where id=".$k."))");
				$net_name=$db->getOne("select net_name from nets where id_net=(select id_net from invoice where id=".$k.")");
				$subj="����������� � ����� $num �� $data �� ���� $net_name. $mail_mkk $mail_rmkk";
				$text=nl2br($_REQUEST["comm"][$k]["comm"]);
				send_mail($mail_mkk,$subj,$text,null);
				send_mail($mail_rmkk,$subj,$text,null);
			}
		}
	}
}





if (isset($_REQUEST["generate"]))
{
	$sql=rtrim(file_get_contents('sql/invoice_pay.sql'));
	$sql_total=rtrim(file_get_contents('sql/invoice_pay_total.sql'));
	$params=array(
		':sd'=>"'".$_REQUEST["sd"]."'",
		':ed'=>"'".$_REQUEST["ed"]."'",
		":oplata_date"=>"'".$_REQUEST["oplata_date"]."'",
		":act_prov_month"=>"'".$_REQUEST["act_prov_month"]."'",
		':nets'=>$_REQUEST["nets"],
		':urlic'=>$_REQUEST["urlic"],
		':sort'=>$_REQUEST["sort"],
		':show'=>"'".$_REQUEST["show"]."'",
		':tn_rmkk'=>$_REQUEST["tn_rmkk"],
		':tn_mkk'=>$_REQUEST["tn_mkk"],
		':tn'=>$tn
	);
	$sql=stritr($sql,$params);
	$sql_total=stritr($sql_total,$params);
	//echo $sql;
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$data_total = $db->getRow($sql_total, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('invoice', $data);
	$smarty->assign('invoice_total', $data_total);
}

$sql=rtrim(file_get_contents('sql/nets.sql'));
$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets', $data);

$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);

$sql=rtrim(file_get_contents('sql/list_rmkk.sql'));
$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$list_rmkk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_rmkk', $list_rmkk);

$sql=rtrim(file_get_contents('sql/list_mkk.sql'));
$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$list_mkk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_mkk', $list_mkk);

$sql=rtrim(file_get_contents('sql/urlic.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_urlic', $res);


$smarty->display('kk_start.html');
$smarty->display('invoice_pay.html');
$smarty->display('kk_end.html');

?>