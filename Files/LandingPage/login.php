<?php
    if($_SERVER["REMOTE_USER"]) { # found $_SERVER["REMOTE_USER"];
        header('Location: /redcap/index.php');
        exit;
    } else { #"Not logged in";
        header('Location: /.auth/login/aad?post_login_redirect_url=/redcap/index.php');
        exit;
    }
?>