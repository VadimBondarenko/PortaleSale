<?



//print_r($_bud_ru_ff);
if (isset($_REQUEST["new"]))
{
	foreach ($_REQUEST["new"] as $k=>$v)
	{
			if ($v["name"]!='')
			{
				Table_Update("bud_ru_ff",$v,$v);
				/*echo  "insert ".$table;
				print_r($keys);
				print_r($values);
				echo "<br>";*/
			}
	}
}


if (isset($_REQUEST["update"]))
{
	foreach ($_REQUEST["update"] as $k=>$v)
	{
		$keys=array("id"=>$k);
		$values=$v;
		Table_Update("bud_ru_ff",$keys,$values);
		/*echo  "update ".$table;
		print_r($keys);
		print_r($values);
		echo "<br>";*/
	}
}

if (isset($_REQUEST["update_ff"]))
{
	foreach ($_REQUEST["update_ff"] as $k=>$v)
	{
		foreach ($v as $k1=>$v1)
		{
			$keys=array("st"=>$k,"ff"=>$k1);
			$v1==1?$values=$keys:$values=null;
			Table_Update("bud_ru_ff_st",$keys,$values);
			/*echo  "update ".$table;
			print_r($keys);
			print_r($values);
			echo "<br>";*/
		}
	}
}

if (isset($_REQUEST["delete"]))
{
	foreach ($_REQUEST["delete"] as $k=>$v)
	{
		$keys=array("id"=>$k);
		Table_Update("bud_ru_ff",$keys,null);
		/*echo  "delete ".$table."-".$k1."-".$v1;
		print_r($keys);
		echo "<br>";*/
	}
}


if (isset($_REQUEST["rebuild"]))
{
	
	foreach ($_REQUEST["rebuild"] as $k=>$v)
	{
		$sql=rtrim(file_get_contents('sql/bud_ru_ff_rebuild.sql'));
		$params=array(':ff_id' => $k);
		$sql=stritr($sql,$params);
		$db->query($sql);
	}
}


$sql=rtrim(file_get_contents('sql/bud_ru_ff.sql'));
$params=array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$bud_ru_ff = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
foreach($bud_ru_ff as $k=>$v){
	$sql=rtrim(file_get_contents('sql/bud_ru_ff_parent_fields.sql'));
	$params=array(':dpt_id' => $_SESSION["dpt_id"],':id' => $v["id"]);
	$sql=stritr($sql,$params);
	$parent_fields = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$bud_ru_ff[$k]["parent_fields"] = $parent_fields;
}
$smarty->assign('bud_ru_ff', $bud_ru_ff);
//print_r($bud_ru_ff);

$sql=rtrim(file_get_contents('sql/bud_ru_ff_st_ras.sql'));
$params=array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$bud_ru_ff_st_ras = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bud_ru_ff_st_ras', $bud_ru_ff_st_ras);

$sql=rtrim(file_get_contents('sql/bud_ru_ff_st.sql'));
$params=array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$bud_ru_ff_st = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bud_ru_ff_st', $bud_ru_ff_st);

$sql=rtrim(file_get_contents('sql/bud_ru_ff_subtypes.sql'));
$params=array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$bud_ru_ff_subtypes = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bud_ru_ff_subtypes', $bud_ru_ff_subtypes);


$sql=rtrim(file_get_contents('sql/bud_ru_ff_admin_id_var1.sql'));
$bud_ru_ff_admin_id_var1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bud_ru_ff_admin_id_var1', $bud_ru_ff_admin_id_var1);


$smarty->display('bud_ru_ff.html');



?>