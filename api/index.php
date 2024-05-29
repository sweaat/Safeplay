<?php
// index.php

require 'config.php';
require 'UserController.php';
require 'GameController.php';

$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$uri = explode('/', $uri);

// Ex: /api/users/1
if ($uri[1] !== 'api') {
    header("HTTP/1.1 404 Not Found");
    exit();
}

$entity = $uri[2];
$id = isset($uri[3]) ? (int)$uri[3] : null;

switch ($entity) {
    case 'users':
        $controller = new UserController($pdo);
        break;
    // Ajoutez ici d'autres entités comme 'games', 'posts', etc.
    default:
        header("HTTP/1.1 404 Not Found");
        exit();
}

$requestMethod = $_SERVER["REQUEST_METHOD"];
$controller->processRequest($requestMethod, $id);
?>
