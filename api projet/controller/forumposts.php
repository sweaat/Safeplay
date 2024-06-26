<?php


switch ($method) {
    case 'GET':
        if ($id) {
            $stmt = $pdo->prepare("SELECT * FROM ForumPosts WHERE ForumPost_ID = ?");
            $stmt->execute([$id]);
            $forumpost = $stmt->fetch();
            if ($forumpost) {
                respond($forumpost);
            } else {
                respond(['error' => 'Forum post not found'], 404);
            }
        } else {
            $stmt = $pdo->query("SELECT * FROM ForumPosts");
            $forumposts = $stmt->fetchAll();
            respond($forumposts);
        }
        break;

    case 'POST':
        $input = json_decode(file_get_contents('php://input'), true);
        if ($input) {
            $stmt = $pdo->prepare("INSERT INTO ForumPosts (Forum_ID, Post_ID) VALUES (?, ?)");
            $stmt->execute([$input['Forum_ID'], $input['Post_ID']]);
            respond(['message' => 'Forum post created', 'id' => $pdo->lastInsertId()], 201);
        } else {
            respond(['error' => 'Invalid input'], 400);
        }
        break;

    case 'PUT':
        if ($id) {
            $input = json_decode(file_get_contents('php://input'), true);
            if ($input) {
                $stmt = $pdo->prepare("UPDATE ForumPosts SET Forum_ID = ?, Post_ID = ? WHERE ForumPost_ID = ?");
                $stmt->execute([$input['Forum_ID'], $input['Post_ID'], $id]);
                respond(['message' => 'Forum post updated']);
            } else {
                respond(['error' => 'Invalid input'], 400);
            }
        } else {
            respond(['error' => 'ID not provided'], 400);
        }
        break;

    case 'DELETE':
        if ($id) {
            $stmt = $pdo->prepare("DELETE FROM ForumPosts WHERE ForumPost_ID = ?");
            $stmt->execute([$id]);
            respond(['message' => 'Forum post deleted']);
        } else {
            respond(['error' => 'ID not provided'], 400);
        }
        break;

    default:
        respond(['error' => 'Method not allowed'], 405);
        break;
}
?>
