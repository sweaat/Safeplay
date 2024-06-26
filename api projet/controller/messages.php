<?php


switch ($method) {
    case 'GET':
        if ($id) {
            $stmt = $pdo->prepare("SELECT * FROM Messages WHERE Message_ID = ?");
            $stmt->execute([$id]);
            $message = $stmt->fetch();
            if ($message) {
                respond($message);
            } else {
                respond(['error' => 'Message not found'], 404);
            }
        } else {
            $stmt = $pdo->query("SELECT * FROM Messages");
            $messages = $stmt->fetchAll();
            respond($messages);
        }
        break;

    case 'POST':
        $input = json_decode(file_get_contents('php://input'), true);
        if ($input) {
            $stmt = $pdo->prepare("INSERT INTO Messages (Sender_ID, Receiver_ID, Content) VALUES (?, ?, ?)");
            $stmt->execute([$input['Sender_ID'], $input['Receiver_ID'], $input['Content']]);
            respond(['message' => 'Message created', 'id' => $pdo->lastInsertId()], 201);
        } else {
            respond(['error' => 'Invalid input'], 400);
        }
        break;

    case 'PUT':
        if ($id) {
            $input = json_decode(file_get_contents('php://input'), true);
            if ($input) {
                $stmt = $pdo->prepare("UPDATE Messages SET Sender_ID = ?, Receiver_ID = ?, Content = ? WHERE Message_ID = ?");
                $stmt->execute([$input['Sender_ID'], $input['Receiver_ID'], $input['Content'], $id]);
                respond(['message' => 'Message updated']);
            } else {
                respond(['error' => 'Invalid input'], 400);
            }
        } else {
            respond(['error' => 'ID not provided'], 400);
        }
        break;

    case 'DELETE':
        if ($id) {
            $stmt = $pdo->prepare("DELETE FROM Messages WHERE Message_ID = ?");
            $stmt->execute([$id]);
            respond(['message' => 'Message deleted']);
        } else {
            respond(['error' => 'ID not provided'], 400);
        }
        break;

    default:
        respond(['error' => 'Method not allowed'], 405);
        break;
}
?>
