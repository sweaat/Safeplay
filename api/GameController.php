<?php
// GameController.php

class GameController {
    private $pdo;

    public function __construct($pdo) {
        $this->pdo = $pdo;
    }

    public function processRequest($requestMethod, $id) {
        switch ($requestMethod) {
            case 'GET':
                if ($id) {
                    $this->getGame($id);
                } else {
                    $this->getAllGames();
                }
                break;
            case 'POST':
                $this->createGame();
                break;
            case 'PUT':
                $this->updateGame($id);
                break;
            case 'DELETE':
                $this->deleteGame($id);
                break;
            default:
                header("HTTP/1.1 405 Method Not Allowed");
                break;
        }
    }

    private function getAllGames() {
        $stmt = $this->pdo->query("SELECT * FROM Games");
        $games = $stmt->fetchAll();
        echo json_encode($games);
    }

    private function getGame($id) {
        $stmt = $this->pdo->prepare("SELECT * FROM Games WHERE Game_ID = ?");
        $stmt->execute([$id]);
        $game = $stmt->fetch();
        if ($game) {
            echo json_encode($game);
        } else {
            header("HTTP/1.1 404 Not Found");
        }
    }

    private function createGame() {
        $input = (array) json_decode(file_get_contents('php://input'), TRUE);
        $sql = "INSERT INTO Games (Title, Genre, Release_Date, Developer) VALUES (:Title, :Genre, :Release_Date, :Developer)";
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute([
            'Title' => $input['Title'],
            'Genre' => $input['Genre'],
            'Release_Date' => $input['Release_Date'],
            'Developer' => $input['Developer']
        ]);
        header("HTTP/1.1 201 Created");
        echo json_encode(['message' => 'Game created']);
    }

    private function updateGame($id) {
        $input = (array) json_decode(file_get_contents('php://input'), TRUE);
        $sql = "UPDATE Games SET Title = :Title, Genre = :Genre, Release_Date = :Release_Date, Developer = :Developer WHERE Game_ID = :Game_ID";
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute([
            'Game_ID' => $id,
            'Title' => $input['Title'],
            'Genre' => $input['Genre'],
            'Release_Date' => $input['Release_Date'],
            'Developer' => $input['Developer']
        ]);
        echo json_encode(['message' => 'Game updated']);
    }

    private function deleteGame($id) {
        $stmt = $this->pdo->prepare("DELETE FROM Games WHERE Game_ID = ?");
        $stmt->execute([$id]);
        echo json_encode(['message' => 'Game deleted']);
    }
}
?>
