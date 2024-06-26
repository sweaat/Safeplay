<?php


switch ($method) {
    case 'GET':
        if ($id) {
            $stmt = $pdo->prepare("SELECT * FROM Games WHERE Game_ID = ?");
            $stmt->execute([$id]);
            $game = $stmt->fetch();
            if ($game) {
                respond($game);
            } else {
                respond(['error' => 'Game not found'], 404);
            }
        } else {
            $stmt = $pdo->query("SELECT * FROM Games");
            $games = $stmt->fetchAll();
            respond($games);
        }
        break;

    case 'POST':
        $input = json_decode(file_get_contents('php://input'), true);
        if ($input) {
            $stmt = $pdo->prepare("INSERT INTO Games (Title, Genre, Release_Date, Developer) VALUES (?, ?, ?, ?)");
            $stmt->execute([$input['Title'], $input['Genre'], $input['Release_Date'], $input['Developer']]);
            respond(['message' => 'Game created', 'id' => $pdo->lastInsertId()], 201);
        } else {
            respond(['error' => 'Invalid input'], 400);
        }
        break;

    case 'PUT':
        if ($id) {
            $input = json_decode(file_get_contents('php://input'), true);
            if ($input) {
                $stmt = $pdo->prepare("UPDATE Games SET Title = ?, Genre = ?, Release_Date = ?, Developer = ? WHERE Game_ID = ?");
                $stmt->execute([$input['Title'], $input['Genre'], $input['Release_Date'], $input['Developer'], $id]);
                respond(['message' => 'Game updated']);
            } else {
                respond(['error' => 'Invalid input'], 400);
            }
        } else {
            respond(['error' => 'ID not provided'], 400);
        }
        break;

    case 'DELETE':
        if ($id) {
            $stmt = $pdo->prepare("DELETE FROM Games WHERE Game_ID = ?");
            $stmt->execute([$id]);
            respond(['message' => 'Game deleted']);
        } else {
            respond(['error' => 'ID not provided'], 400);
        }
        break;

    default:
        respond(['error' => 'Method not allowed'], 405);
        break;
}
?>
