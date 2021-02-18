<?php

if ($_POST["METHOD"] == "ASD") {
    //...
}

//Test response

$arr['DATA']['test'] = $_POST['METHOD']."T".time();
$arr['DATA']['ip'] = $_SERVER['REMOTE_ADDR'];


$arr['RESULT'] = 'SUCCESS';
$arr['TIMESTAMP'] = time();
$arr['RAWCONTENT'] = "Bla" . time();


echo json_encode($arr);
?>
