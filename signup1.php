<?php
include "conn.php";
$username = $_POST['username'];
$password = $_POST['password'];
$name = $_POST['name'];
$birthday = $_POST['birthday'];
$email = $_POST['email'];
$flagging = $_POST['flagging'];
$c_profile = 'p-01';
$l_profile = 'ordinary user';



$username_='';

    if($username != '') {
        $aSQL = "SELECT * from t_user where username=$username";
        $aQResult=mysqli_query($connect, $aSQL);
        while ($aRow = mysqli_fetch_array($aQResult))
        {
        $username_=$aRow["username"];
        echo json_encode('username_exist');
        }
    if($username_ == NULL) {

        $aSQL2 = "insert into t_user set username='$username', password='$password', name='$name', birthday='$birthday', 
        email='$email', flagging='$flagging', c_profile='$c_profile', l_profile='$l_profile', datetime1=now()";
        $aQResult2=mysqli_query($connect, $aSQL2);
        echo json_encode('success');
        
        $action1 = json_encode($aSQL2, JSON_PRETTY_PRINT);
        $result = mysqli_query($connect, "insert into t_user_log set username='$username', name1='$name1', 
        ip_address= '$_SERVER[REMOTE_ADDR]', action1=$action1, datetime1=now()");              
        }
        $username_=NULL;
    }
    else{
        echo json_encode('failed');
        }
        $username_=NULL;
?>
