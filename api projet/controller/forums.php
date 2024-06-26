<?php

switch ($method) {
    case 'GET':
        if ($id) {
            $stmt = $pdo->prepare("SELECT * FROM Forums WHERE Forum_ID = ?");
            $stmt->execute([$id]);
            $forum = $stmt->fetch();
            if ($forum) {
                respond($forum);
            } else {
                respond(['error' => 'Forum not found'], 404);
            }
        } else {
            $stmt = $pdo->query("SELECT * FROM Forums");
            $forums = $stmt->fetchAll();
            respond($forums);
        }
        break;

    case 'POST':
        $input = json_decode(file_get_contents('php://input'), true);
        if ($input) {
            $stmt = $pdo->prepare("INSERT INTO Forums (Title, Description) VALUES (?, ?)");
            $stmt->execute([$input['Title'], $input['Description']]);
            respond(['message' => 'Forum created', 'id' => $pdo->lastInsertId()], 201);
        } else {
            respond(['error' => 'Invalid input'], 400);
        }
        break;

    case 'PUT':
        if ($id) {
            $input = json_decode(file_get_contents('php://input'), true);
            if ($input) {
                $stmt = $pdo->prepare("UPDATE Forums SET Title = ?, Description = ? WHERE Forum_ID = ?");
                $stmt->execute([$input['Title'], $input['Description'], $id]);
                respond(['message' => 'Forum updated']);
            } else {
                respond(['error' => 'Invalid input'], 400);
            }
        } else {
            respond(['error' => 'ID not provided'], 400);
        }
        break;

    case 'DELETE':
        if ($id) {
            $stmt = $pdo->prepare("DELETE FROM Forums WHERE Forum_ID = ?");
            $stmt->execute([$id]);
            respond(['message' => 'Forum deleted']);
        } else {
            respond(['error' => 'ID not provided'], 400);
        }
        break;

    default:
        respond(['error' => 'Method not allowed'], 405);
        break;
}
?>
