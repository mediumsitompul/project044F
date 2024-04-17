<?php
        include "conn.php";
        $username = $_POST['username'];
        $password = $_POST['password'];
        $flagging = $_POST['flagging'];
        
        $datetime1= date("Y-m-d H:i:s");
        $aSQL = "SELECT * FROM t_user WHERE username='".$username."' and password='".$password."' and flagging='".$flagging."'";
        $result=array();
        
        $aQResult=mysqli_query($connect, $aSQL);
        while ($aRow = mysqli_fetch_array($aQResult))
        {
        $result[]=$aRow;
        $name1=$aRow['name'];
        }

        
    if($name1 == null)
    {
        echo json_encode('failed');
    }else if($name1 != null)
    {
        echo json_encode($result);
        //.................................
        $username_=$aRow["username"];
        $hasil=json_encode($result);
        $action1 = json_encode($aSQL, JSON_PRETTY_PRINT);

        $result = mysqli_query($connect,
        "insert into t_user_log
        set username='$username',
        name1='$name1',
        ip_address= '$_SERVER[REMOTE_ADDR]', 
        action1=$action1,
		datetime1=now() "
        );
        //..................................
    };
?>


