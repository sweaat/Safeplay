<?php


switch ($method) {
    case 'GET':
        if ($id) {
            $stmt = $pdo->prepare("SELECT * FROM Users WHERE User_ID = ?");
            $stmt->execute([$id]);
            $user = $stmt->fetch();
            if ($user) {
                respond($user);
            } else {
                respond(['error' => 'User not found'], 404);
            }
        } else {
            $stmt = $pdo->query("SELECT * FROM Users");
            $users = $stmt->fetchAll();
            respond($users);
        }
        break;

    case 'POST':
        $input = json_decode(file_get_contents('php://input'), true);
        if ($input) {
            $stmt = $pdo->prepare("INSERT INTO Users (Username, Email, Password, Role) VALUES (?, ?, ?, ?)");
            $stmt->execute([$input['Username'], $input['Email'], $input['Password'], $input['Role']]);
            respond(['message' => 'User created', 'id' => $pdo->lastInsertId()], 201);
        } else {
            respond(['error' => 'Invalid input'], 400);
        }
        break;

    case 'PUT':
        if ($id) {
            $input = json_decode(file_get_contents('php://input'), true);
            if ($input) {
                $stmt = $pdo->prepare("UPDATE Users SET Username = ?, Email = ?, Password = ?, Role = ? WHERE User_ID = ?");
                $stmt->execute([$input['Username'], $input['Email'], $input['Password'], $input['Role'], $id]);
                respond(['message' => 'User updated']);
            } else {
                respond(['error' => 'Invalid input'], 400);
            }
        } else {
            respond(['error' => 'ID not provided'], 400);
        }
        break;

    case 'DELETE':
        if ($id) {
            $stmt = $pdo->prepare("DELETE FROM Users WHERE User_ID = ?");
            $stmt->execute([$id]);
            respond(['message' => 'User deleted']);
        } else {
            respond(['error' => 'ID not provided'], 400);
        }
        break;

    default:
        respond(['error' => 'Method not allowed'], 405);
        break;
}
?>
