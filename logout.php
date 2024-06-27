<?php
session_start();
session_unset();
session_destroy();
header('Location: /Safeplay/index.php');
exit;
