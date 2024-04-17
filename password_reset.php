<?php
include "conn.php";
$username = $_POST['username'];
$birthday = $_POST['birthday'];
$password1 = $_POST['password1'];

        $aSQL = "SELECT * from t_user 
        where username='$username' AND birthday='$birthday'";
        $aQResult=mysqli_query($connect, $aSQL);
        while ($aRow = mysqli_fetch_array($aQResult))
          {
          $result[]=$aRow;
          $name1=$aRow['name'];
          }

        if($name1 != NULL) {
            $aSQL2 = "UPDATE t_user set password='$password1' 
            where username='$username' AND birthday='$birthday'";
            $aQResult2=mysqli_query($connect, $aSQL2);
            echo json_encode("success");
            $action1 = json_encode($aSQL2, JSON_PRETTY_PRINT);

        $result = mysqli_query($connect,
        "insert into t_user_log
        set username='$username',
        name1='$name1',
        ip_address= '$_SERVER[REMOTE_ADDR]', 
        action1=$action1,
		datetime1=now() "
        );              
            }

        else{
          echo json_encode("failed");
          }
?>
