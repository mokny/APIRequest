<?php
session_start();

if ($_POST["METHOD"] == "TEST") {
    //... this is just example data ...
	$arr['DATA']['test'] = "LAST METHOD ".$_POST['METHOD']." T".time()." ".rand(100,999);
	$arr['DATA']['ip'] = $_SERVER['REMOTE_ADDR'];
	$arr['DATA']['time'] = time();
	$arr['DATA']['uid'] = $_POST['UID'];

	//Adding an Array
	$arr['DATA']['array'][] = "a";
	$arr['DATA']['array'][] = "b";
	

} else {
	//unknoen method
}

//Test respons

$arr['RESULT'] = 'SUCCESS';
$arr['TIMESTAMP'] = time();
$arr['RAWCONTENT'] = "T-".time();
$arr['SESSIONID'] = session_id();

echo json_encode($arr);
?>
