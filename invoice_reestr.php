<?

//ini_set('display_errors', 'On');
audit("������ invoice_reestr","invoice_reestr");
InitRequestVar("nets",0);
InitRequestVar("calendar_years",0);
InitRequestVar("tn_rmkk",0);
InitRequestVar("tn_mkk",0);
InitRequestVar("calendar_months",0);
InitRequestVar("format",0);
InitRequestVar("payer",0);
InitRequestVar("urlic",0);
InitRequestVar("num",'');
InitRequestVar("ok_fm","all");
InitRequestVar("ok_rmkk","all");
InitRequestVar("invoice_sended","all");
InitRequestVar("ok_acts_redisplayed","all");
if (isset($_REQUEST["add"]))
{
	$v=$_REQUEST["new"];
	if
	(
		($v["id_net"]!="")&&
		($v["num"]!="")&&
		($v["data"]!="")&&
		($v["payer"]!="")&&
		($v["summa"]!="")
	)
	{
		$v["data"]=OraDate2MDBDate($v["data"]);
		$v["act_dt"]=OraDate2MDBDate($v["act_dt"]);
		$v["promo"]=0;
		$id=get_new_id();
		$v["id"]=$id;
		Table_Update("invoice",$v,$v);
		if (isset($_FILES['new_files']))
		{
			foreach($_FILES['new_files']['name'] as $k=>$v)
			{
				if
				(
					is_uploaded_file($_FILES['new_files']['tmp_name'][$k])
				)
				{
					$a=pathinfo($_FILES['new_files']['name'][$k]);
					$fn=get_new_file_id().'_'.translit($_FILES['new_files']['name'][$k]);
					$vals=array(
						'invoice'=>$id,
						'fn'=>$fn
					);
					Table_Update('invoice_files', $vals,$vals);
					move_uploaded_file($_FILES['new_files']['tmp_name'][$k], 'files/'.$fn);
				}
			}
		}
		if (isset($_FILES['new_acts']))
		{
			foreach($_FILES['new_acts']['name'] as $k=>$v)
			{
				if
				(
					is_uploaded_file($_FILES['new_acts']['tmp_name'][$k])
				)
				{
					$a=pathinfo($_FILES['new_acts']['name'][$k]);
					$fn=get_new_file_id().'_'.translit($_FILES['new_acts']['name'][$k]);
					$vals=array(
						'invoice'=>$id,
						'fn'=>$fn
					);
					Table_Update('invoice_acts', $vals,$vals);
					move_uploaded_file($_FILES['new_acts']['tmp_name'][$k], 'files/'.$fn);
				}
			}
		}
	}
	else
	{
		echo "<p style=\"color:red\">�� ��� ���� ���������, ������ �� ���������!</p>";
	}
}
if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		$keys = array("id"=>$k);
		isset($v['act_dt'])?$v['act_dt']=OraDate2MDBDate($v['act_dt']):null;
		Table_Update ("invoice", $keys, $v);
	}
}
if (isset($_FILES['files']))
{
	foreach($_FILES['files']['name'] as $k=>$v)
	{
	foreach($v as $k1=>$v1)
	{
		if
		(
			is_uploaded_file($_FILES['files']['tmp_name'][$k][$k1])
		)
		{
			$a=pathinfo($_FILES['files']['name'][$k][$k1]);
			$fn=get_new_file_id().'_'.translit($_FILES['files']['name'][$k][$k1]);
			$vals=array(
				'invoice'=>$k,
				'fn'=>$fn
			);
			Table_Update('invoice_files', $vals,$vals);
			move_uploaded_file($_FILES['files']['tmp_name'][$k][$k1], 'files/'.$fn);
		}
	}
	}
}
if (isset($_FILES['acts']))
{
	foreach($_FILES['acts']['name'] as $k=>$v)
	{
	foreach($v as $k1=>$v1)
	{
		if
		(
			is_uploaded_file($_FILES['acts']['tmp_name'][$k][$k1])
		)
		{
			$a=pathinfo($_FILES['acts']['name'][$k][$k1]);
			$fn=get_new_file_id().'_'.translit($_FILES['acts']['name'][$k][$k1]);
			$vals=array(
				'invoice'=>$k,
				'fn'=>$fn
			);
			Table_Update('invoice_acts', $vals,$vals);
			move_uploaded_file($_FILES['acts']['tmp_name'][$k][$k1], 'files/'.$fn);
		}
	}
	}
}
if (isset($_REQUEST["del_files"]))
{
	foreach ($_REQUEST["del_files"] as $k=>$v)
	{
		Table_Update("invoice_files", array('id'=>$v),null);
	}
}
if (isset($_REQUEST["del_acts"]))
{
	foreach ($_REQUEST["del_acts"] as $k=>$v)
	{
		Table_Update("invoice_acts", array('id'=>$v),null);
	}
}
if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		Table_Update("invoice", array('id'=>$v),null);
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
function getTable($payer,$invoice_sended,$ok_fm,$ok_rmkk)
{
	global $db, $tn, $smarty;
	$sql=rtrim(file_get_contents('sql/invoice_reestr.sql'));
	$sql_detail=rtrim(file_get_contents('sql/invoice_reestr_detail.sql'));
	$sql_files=rtrim(file_get_contents('sql/invoice_files.sql'));
	$sql_acts=rtrim(file_get_contents('sql/invoice_acts.sql'));
	$params=array(
		':y'=>$_REQUEST["calendar_years"],
		':nets'=>$_REQUEST["nets"],
		':format'=>$_REQUEST["format"],
		':payer'=>$payer,
		':urlic'=>$_REQUEST["urlic"],
		':num'=>"'".str_replace("'","''",$_REQUEST["num"])."'",
		':ok_fm'=>"'".$ok_fm."'",
		':ok_rmkk'=>"'".$ok_rmkk."'",
		':ok_acts_redisplayed'=>"'".$_REQUEST["ok_acts_redisplayed"]."'",
		':invoice_sended'=>"'".$invoice_sended."'",
		':calendar_months'=>$_REQUEST["calendar_months"],
		':tn_rmkk'=>$_REQUEST["tn_rmkk"],
		':tn_mkk'=>$_REQUEST["tn_mkk"],
		':tn'=>$tn
	);
	$sql=stritr($sql,$params);
	//echo $sql;
	$invoices = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach ($invoices as $k=>$v)
	{
		//echo $v["id_net"]."-".$v["my"]."<br>";
		$params[":invoice"]=$v["id"];
		$invoices[$k]["detail"] = $db->getAll(stritr($sql_detail,$params), null, null, null, MDB2_FETCHMODE_ASSOC);
		$invoices[$k]["files"] = $db->getAll(stritr($sql_files,$params), null, null, null, MDB2_FETCHMODE_ASSOC);
		$invoices[$k]["acts"] = $db->getAll(stritr($sql_acts,$params), null, null, null, MDB2_FETCHMODE_ASSOC);
	}
	//print_r($invoices);
	//$smarty->assign('invoice', $invoices);
	//$smarty->assign('fin_report_total', $invoices_total);
	return $invoices;
}

if (($_REQUEST["calendar_years"]!=0)&&(isset($_REQUEST["generate"])))
{
	$invoices_all = getTable(
                $_REQUEST["payer"],
                $_REQUEST["invoice_sended"],
                $_REQUEST["ok_fm"],
                $_REQUEST["ok_rmkk"]);
	$smarty->assign('invoice', $invoices_all);
}
$sql=rtrim(file_get_contents('sql/distr_prot_di_kk.sql'));
$p = array(":dpt_id" => $_SESSION["dpt_id"],':tn'=>$tn);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('payer', $data);

$sql=rtrim(file_get_contents('sql/calendar_years.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('calendar_years', $data);

$sql=rtrim(file_get_contents('sql/calendar_months.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('calendar_months', $data);

$sql=rtrim(file_get_contents('sql/nets.sql'));
$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets', $data);

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
$list_urlic = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_urlic', $list_urlic);

isset($_REQUEST["print"]) ? $print = $_REQUEST["print"] : $print = null;
isset($_REQUEST["format"]) ? $format = $_REQUEST["format"] : $format = null;
if (isset($_REQUEST["send_invoices"]))
{
    $cnt=0;
    $_REQUEST["print"] = 1;
    $_REQUEST["format"] = 1;
    foreach ($invoices_all as $k => $v)
    {
        if ($v["invoice_sended"]==0)
        {
            $payers_list[$v["payer"]]["name"]=$v["payer_name"];
            $payers_list[$v["payer"]]["mail"]=$v["invoice_mail"];
            $payers_list[$v["payer"]]["rmkk"]=$v["rmkk"];
            $payers_list[$v["payer"]]["rmkk_mail"]=$v["rmkk_mail"];
            $payers_list[$v["payer"]]["rmkk_sign"]=$v["rmkk_sign"];
        }
    }
    foreach ($payers_list as $k => $v)
    {
        $invoices = getTable($k,'no','ok','ok');
        if (count($invoices)>0){
        $smarty->assign('invoice', $invoices);
        $table = $smarty->fetch('invoice_reestr_table.html');
        $fn = get_new_file_id().".xls";
        file_put_contents("files/invoices".$fn, $table);
        //$subj="������ ������ ��� ������, ������������"." PAYER(ONLY FOR TEST): ".$v["name"]." MAIL: ".$v["mail"];
        $subj="������ ������ ��� ������, ������������";
        $text=$v['rmkk'].'<br><img height=100px src="https://ps.avk.ua/files/'.$v['rmkk_sign'].'">';
        send_mail($v["mail"],$subj,$text,["files/invoices".$fn]);
        }
    }
    foreach ($invoices_all as $k => $v)
    {
        if ($v["invoice_sended"]==0&&($v["ok_fm"]==1)&&($v["ok_rmkk"]==1))
        {
            Table_Update ("invoice", array("id"=>$v["id"]), array("invoice_sended"=>1));
            $invoices_all[$k]["invoice_sended"] = 1;
        }
    }
}
$_REQUEST["print"] = $print;
$_REQUEST["format"] = $format;
isset($invoices_all) ? $smarty->assign('invoice', $invoices_all) : null;
$smarty->display('kk_start.html');
$smarty->display('invoice_reestr.html');
$smarty->display('kk_end.html');
?>