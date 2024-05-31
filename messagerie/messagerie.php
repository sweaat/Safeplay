<?php
session_start();

// Vérifiez si l'utilisateur est connecté
if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit;
}

// Configuration de la base de données
$host = 'localhost';
$db = 'projet';
$user = 'root';
$password = '';

// Connexion à la base de données
try {
    $pdo = new PDO("mysql:host=$host;dbname=$db", $user, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Impossible de se connecter à la base de données: " . $e->getMessage());
}

$userId = $_SESSION['user_id'];

// Envoi d'un message
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['content'])) {
    $receiverId = $_POST['receiver_id'];
    $content = $_POST['content'];

    $stmt = $pdo->prepare('INSERT INTO messages (Sender_ID, Receiver_ID, Content) VALUES (:senderId, :receiverId, :content)');
    $stmt->execute(['senderId' => $userId, 'receiverId' => $receiverId, 'content' => $content]);

    header("Location: ?user=$receiverId");
    exit;
}

// Fetch user conversations
$stmt = $pdo->prepare('SELECT DISTINCT u.User_ID, u.Username FROM users u JOIN messages m ON u.User_ID = m.Sender_ID OR u.User_ID = m.Receiver_ID WHERE (m.Sender_ID = :userId OR m.Receiver_ID = :userId) AND u.User_ID != :userId');
$stmt->execute(['userId' => $userId]);
$conversations = $stmt->fetchAll();

// Fetch all users for starting a new conversation
$stmt = $pdo->prepare('SELECT User_ID, Username FROM users WHERE User_ID != :userId');
$stmt->execute(['userId' => $userId]);
$users = $stmt->fetchAll();

$receiverId = $_GET['user'] ?? null;
$messages = [];

if ($receiverId) {
    // Fetch messages
    $stmt = $pdo->prepare('SELECT * FROM messages WHERE (Sender_ID = :userId AND Receiver_ID = :receiverId) OR (Sender_ID = :receiverId AND Receiver_ID = :userId) ORDER BY Send_Date ASC');
    $stmt->execute(['userId' => $userId, 'receiverId' => $receiverId]);
    $messages = $stmt->fetchAll();
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Messages</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<header>
    <div class="logo">SafePlay</div>
    <nav>
        <a href="#">Accueil</a>
        <a href="#">Actualités</a>
        <a href="#">Forums</a>
        <a href="#">Messages</a>
        <a href="#">Support</a>
        <a href="/singup/singnup.php">Sign Out</a>
    </nav>
</header>
<main>
    <div class="messaging-container">
        <section class="conversations">
            <h1>Conversations</h1>
            <ul>
                <?php foreach ($conversations as $conversation): ?>
                    <li><a href="?user=<?= $conversation['User_ID'] ?>"><?= htmlspecialchars($conversation['Username']) ?></a></li>
                <?php endforeach; ?>
            </ul>
        </section>

        <section class="chat">
            <div class="chat-header">
                <h1>Start New Conversation</h1>
                <form action="" method="post">
                    <select name="receiver_id" required>
                        <option value="" disabled selected>Select a user</option>
                        <?php foreach ($users as $user): ?>
                            <option value="<?= $user['User_ID'] ?>"><?= htmlspecialchars($user['Username']) ?></option>
                        <?php endforeach; ?>
                    </select>
                    <textarea name="content" placeholder="Type your message here..." required></textarea>
                    <button type="submit">Send</button>
                </form>
            </div>

            <?php if ($receiverId): ?>
                <div class="chat-messages">
                    <h1>Messages</h1>
                    <ul>
                        <?php foreach ($messages as $message): ?>
                            <li class="<?= $message['Sender_ID'] == $userId ? 'sent' : 'received' ?>">
                                <span class="content"><?= htmlspecialchars($message['Content']) ?></span>
                                <span class="timestamp"><?= htmlspecialchars($message['Send_Date']) ?></span>
                            </li>
                        <?php endforeach; ?>
                    </ul>
                    <form action="" method="post" class="message-form">
                        <input type="hidden" name="receiver_id" value="<?= $receiverId ?>">
                        <label>
                            <textarea name="content" placeholder="Type your message here..." required></textarea>
                        </label>
                        <button type="submit">Send</button>
                    </form>
                </div>
            <?php endif; ?>
        </section>
    </div>
</main>
</body>
</html>
