<?
$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
if (isset($_REQUEST["copy"]))
{
$id=$db->getOne("SELECT ProbTestCopy (".$_REQUEST['parent'].") FROM DUAL");
$_REQUEST['name']=$db->getOne("select name from prob_test where id=".$id);
$_REQUEST['test_len']=$db->getOne("select test_len from prob_test where id=".$id);
$_REQUEST['comm']=$db->getOne("select comm from prob_test where id=".$id);
}
else
{
$id=get_new_id();
$keys = array('id'=>$id,'name'=>$_REQUEST['name'],'test_len'=>$_REQUEST['test_len'],'parent'=>$_REQUEST['parent'],'comm'=>$_REQUEST['comm']);
Table_Update('prob_test', $keys,$keys);
}
$smarty->assign('id',$id);
$smarty->assign('name',$_REQUEST['name']);
$smarty->assign('test_len',$_REQUEST['test_len']);
$smarty->assign('comm',$_REQUEST['comm']);
$smarty->display('prob_test_new.html');
?>