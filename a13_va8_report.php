<?php

//audit("����� � ������ �����");

InitRequestVar("exp_list_without_ts",0);
InitRequestVar("exp_list_only_ts",0);
InitRequestVar("eta_list",$_SESSION["h_eta"]);
InitRequestVar("ok_traid",1);
InitRequestVar("ok_ts",1);
InitRequestVar("ok_chief",1);
InitRequestVar("is_act",1);

$params=array(':dpt_id' => $_SESSION["dpt_id"],
	':tn'=>$tn,
	':ok_traid' => $_REQUEST["ok_traid"],
	':ok_ts' => $_REQUEST["ok_ts"],
	':ok_chief' => $_REQUEST["ok_chief"],
	':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
	':exp_list_only_ts' => $_REQUEST["exp_list_only_ts"],
	':is_act'=>$_REQUEST["is_act"],
	':eta_list' => "'".$_REQUEST["eta_list"]."'"
);


$sql = rtrim(file_get_contents('sql/exp_list_from_parent_only_ts.sql'));
$sql=stritr($sql,$params);
$exp_list_only_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_only_ts', $exp_list_only_ts);

$sql = rtrim(file_get_contents('sql/exp_list_from_parent_without_ts.sql'));
$sql=stritr($sql,$params);
$exp_list_without_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_without_ts', $exp_list_without_ts);

$sql = rtrim(file_get_contents('sql/a13_va8_report_eta_list.sql'));
$sql=stritr($sql,$params);
$eta_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('eta_list', $eta_list);



if (isset($_REQUEST['generate']))
{


if (isset($_REQUEST["save"]))
{
	$table_name = 'a13_va8_tp_select';
	if (isset($_REQUEST["ok2"]))
	{
		foreach($_REQUEST["ok2"] as $k=>$v)
		{
			foreach($v as $k1=>$v1)
			{
				if ($v1!="")
				{
					$keys = array('tp_kod'=>$k1);
					$vals = array($k=>$v1);
//echo $k." ".$k1." ".$k2." ".$v." ".$v1." ".$v2."<br>";
					Table_Update ($table_name, $keys, $vals);
				}
			}
		}
	}
	$table_name = 'a13_va8_tp_select';
	if (isset($_REQUEST["text2"]))
	{
		foreach($_REQUEST["text2"] as $k=>$v)
		{
			foreach($v as $k1=>$v1)
			{
				$keys = array('tp_kod'=>$k1);
				$vals = array($k=>$v1);
//echo $k." ".$k1." ".$k2." ".$v." ".$v1." ".$v2."<br>";
				Table_Update ($table_name, $keys, $vals);
			}
		}
	}
	$table_name = 'a13_va8_tp_select';
	if (isset($_REQUEST["fakt_bonus"]))
	{
		foreach ($_REQUEST["fakt_bonus"] as $key => $val)
		{
			if ($val!=null)
			{
				$keys = array('tp_kod'=>$key);
				$values = array('fakt_bonus'=>$val);
				Table_Update ($table_name, $keys, $values);
			}
		}
	}
	$table_name = 'a13_va8_tp_select';
	if (isset($_REQUEST["ok_ts_date"]))
	{
		foreach ($_REQUEST["ok_ts_date"] as $key => $val)
		{
			if ($val!=null)
			{
				$keys = array('tp_kod'=>$key);
				$values = array('ok_ts_date'=>OraDate2MDBDate($val));
				Table_Update ($table_name, $keys, $values);
			}
		}
	}
	$table_name = 'a13_va8_files';
	if (isset($_REQUEST["ok_files"]))
	{
		foreach($_REQUEST["ok_files"] as $k=>$v)
		{
			foreach($v as $k1=>$v1)
			{
				if ($v1!="")
				{
					$keys = array('id'=>$k1);
					$vals = array($k=>$v1);
//echo $k." ".$k1." ".$k2." ".$v." ".$v1." ".$v2."<br>";
					Table_Update ($table_name, $keys, $vals);
				}
			}
		}
	}
	if (isset($_REQUEST["text_files"]))
	{
		foreach($_REQUEST["text_files"] as $k=>$v)
		{
			foreach($v as $k1=>$v1)
			{
				$keys = array('id'=>$k1);
				$vals = array($k=>$v1);
//echo $k." ".$k1." ".$k2." ".$v." ".$v1." ".$v2."<br>";
				Table_Update ($table_name, $keys, $vals);
			}
		}
	}
}


//ses_req();



if (isset($_REQUEST["del_file"]))
{
foreach ($_REQUEST["del_file"] as $k=>$v)
{
$fn=$db->getOne("select fn from a13_va8_files where id=".$k);
unlink("a13_va8_files/".$tn."/".$fn);
$fn=$db->query("delete from a13_va8_files where id=".$k);
}
}


if (isset($_FILES["new_fn"]))
{
if ($_FILES["new_fn"]["name"]!="")
{
	//ses_req();
	$_REQUEST["new"]["tn"]=$tn;
	$d1="a13_va8_files/".$tn;
	if (!file_exists($d1)) {mkdir($d1,0777,true);}
	//$d1=$d1."/2";
	if (!file_exists($d1)) {mkdir($d1,0777,true);}
	if (is_uploaded_file($_FILES["new_fn"]['tmp_name'])){move_uploaded_file($_FILES["new_fn"]["tmp_name"], $d1."/".translit($_FILES["new_fn"]["name"]));}
	$_REQUEST["new"]["fn"]=translit($_FILES["new_fn"]["name"]);
	if ($_FILES["new_fn"]['error']==0){
		//$_REQUEST["new"]["bonus"]=str_replace(",",".",$_REQUEST["new"]["bonus"]);
		Table_Update("a13_va8_files",$_REQUEST["new"],$_REQUEST["new"]);
	}
}
}

$sql=rtrim(file_get_contents("sql/a13_va8_report.sql"));
$sql=stritr($sql,$params);
//echo $sql;
$list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//print_r($list);
$smarty->assign("list", $list);

$sql=rtrim(file_get_contents("sql/a13_va8_report_itogi.sql"));
$sql=stritr($sql,$params);
//echo $sql;
$list = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//print_r($list);
$smarty->assign("itogi", $list);

$d1=array();

$sql=rtrim(file_get_contents('sql/a13_va8_files.sql'));
$sql=stritr($sql,$params);
$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

if (isset($d))
{
foreach ($d as $k=>$v)
{
$d1[$v["tn"]]["data"][$v["id"]]=$v;
}
}

$sql=rtrim(file_get_contents('sql/a13_va8_files_total.sql'));
$sql=stritr($sql,$params);
$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

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

$sql=rtrim(file_get_contents('sql/a13_va8_files_total_total.sql'));
$sql=stritr($sql,$params);
$d = $db->getOne($sql);
//echo $sql;
$smarty->assign('file_list_total', $d);

}

$smarty->display('a13_va8_report.html');

//ses_req();


?>