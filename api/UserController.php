<?php
// UserController.php

class UserController {
    private $pdo;

    public function __construct($pdo) {
        $this->pdo = $pdo;
    }

    public function processRequest($requestMethod, $id) {
        switch ($requestMethod) {
            case 'GET':
                if ($id) {
                    $this->getUser($id);
                } else {
                    $this->getAllUsers();
                }
                break;
            case 'POST':
                $this->createUser();
                break;
            case 'PUT':
                $this->updateUser($id);
                break;
            case 'DELETE':
                $this->deleteUser($id);
                break;
            default:
                header("HTTP/1.1 405 Method Not Allowed");
                break;
        }
    }

    private function getAllUsers() {
        $stmt = $this->pdo->query("SELECT * FROM Users");
        $users = $stmt->fetchAll();
        echo json_encode($users);
    }

    private function getUser($id) {
        $stmt = $this->pdo->prepare("SELECT * FROM Users WHERE User_ID = ?");
        $stmt->execute([$id]);
        $user = $stmt->fetch();
        if ($user) {
            echo json_encode($user);
        } else {
            header("HTTP/1.1 404 Not Found");
        }
    }

    private function createUser() {
        $input = (array) json_decode(file_get_contents('php://input'), TRUE);
        $sql = "INSERT INTO Users (Username, Email, Password, Role, Profile_Picture) VALUES (:Username, :Email, :Password, :Role, :Profile_Picture)";
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute([
            'Username' => $input['Username'],
            'Email' => $input['Email'],
            'Password' => password_hash($input['Password'], PASSWORD_DEFAULT),
            'Role' => $input['Role'],
            'Profile_Picture' => $input['Profile_Picture']
        ]);
        header("HTTP/1.1 201 Created");
        echo json_encode(['message' => 'User created']);
    }

    private function updateUser($id) {
        $input = (array) json_decode(file_get_contents('php://input'), TRUE);
        $sql = "UPDATE Users SET Username = :Username, Email = :Email, Password = :Password, Role = :Role, Profile_Picture = :Profile_Picture WHERE User_ID = :User_ID";
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute([
            'User_ID' => $id,
            'Username' => $input['Username'],
            'Email' => $input['Email'],
            'Password' => password_hash($input['Password'], PASSWORD_DEFAULT),
            'Role' => $input['Role'],
            'Profile_Picture' => $input['Profile_Picture']
        ]);
        echo json_encode(['message' => 'User updated']);
    }

    private function deleteUser($id) {
        $stmt = $this->pdo->prepare("DELETE FROM Users WHERE User_ID = ?");
        $stmt->execute([$id]);
        echo json_encode(['message' => 'User deleted']);
    }
}
?>
