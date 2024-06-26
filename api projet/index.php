<?php

require 'config.php';

header("Content-Type: application/json");

$method = $_SERVER['REQUEST_METHOD'];
$request = explode('/', trim($_SERVER['PATH_INFO'], '/'));
$resource = array_shift($request);
$id = array_shift($request);

// Fonction pour envoyer une réponse JSON
function respond($data, $status = 200) {
    http_response_code($status);
    echo json_encode($data);
    exit();
}

switch ($resource) {
    case 'users':
        require 'controllers/users.php';
        break;
    case 'games':
        require 'controllers/games.php';
        break;
    // Ajoutez des cas pour d'autres ressources...
    default:
        respond(['error' => 'Resource not found'], 404);
        break;
}
?>
