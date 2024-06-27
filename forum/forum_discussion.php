<?php
session_start();
$dsn = 'mysql:host=localhost;dbname=projet';
$db_user = 'root';
$db_password = '';

try {
    $pdo = new PDO($dsn, $db_user, $db_password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die('Erreur de connexion : ' . $e->getMessage());
}

if (!isset($_SESSION['user_id'])) {
    header("Location: ../login/login.php"); // Rediriger vers la page de connexion
    exit;
}

$forum_id = $_GET['id'];
$query = "SELECT * FROM forums WHERE Forum_ID = :id";
$stmt = $pdo->prepare($query);
$stmt->bindParam(':id', $forum_id, PDO::PARAM_INT);
$stmt->execute();
$forum = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$forum) {
    die('Forum not found');
}

// Handle new post submission
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['add_post'])) {
    $content = $_POST['content'];
    $user_id = $_SESSION['user_id'];
    $stmt = $pdo->prepare("INSERT INTO posts (User_ID, Content, Post_Type) VALUES (:user_id, :content, 'Forum')");
    $stmt->bindParam(':user_id', $user_id);
    $stmt->bindParam(':content', $content);
    $stmt->execute();
    $post_id = $pdo->lastInsertId();

    // Link the post to the forum
    $stmt = $pdo->prepare("INSERT INTO forumposts (Forum_ID, Post_ID) VALUES (:forum_id, :post_id)");
    $stmt->bindParam(':forum_id', $forum_id);
    $stmt->bindParam(':post_id', $post_id);
    $stmt->execute();
}

// Handle reply submission
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['reply_post'])) {
    $content = $_POST['content'];
    $parent_id = $_POST['parent_id'];
    $user_id = $_SESSION['user_id'];
    $stmt = $pdo->prepare("INSERT INTO posts (User_ID, Content, Post_Type, Parent_ID) VALUES (:user_id, :content, 'Forum', :parent_id)");
    $stmt->bindParam(':user_id', $user_id);
    $stmt->bindParam(':content', $content);
    $stmt->bindParam(':parent_id', $parent_id);
    $stmt->execute();
}

// Fetch posts related to the forum
$query = "
    SELECT posts.*, users.Username 
    FROM posts 
    JOIN forumposts ON posts.Post_ID = forumposts.Post_ID 
    JOIN users ON posts.User_ID = users.User_ID 
    WHERE forumposts.Forum_ID = :id 
    AND posts.Parent_ID IS NULL
    ORDER BY posts.Post_Date DESC";
$stmt = $pdo->prepare($query);
$stmt->bindParam(':id', $forum_id, PDO::PARAM_INT);
$stmt->execute();
$posts = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Fetch replies
function fetchReplies($pdo, $post_id) {
    $stmt = $pdo->prepare("
        SELECT posts.*, users.Username 
        FROM posts 
        JOIN users ON posts.User_ID = users.User_ID 
        WHERE posts.Parent_ID = :post_id 
        ORDER BY posts.Post_Date ASC");
    $stmt->bindParam(':post_id', $post_id, PDO::PARAM_INT);
    $stmt->execute();
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}
?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo htmlspecialchars($forum['Title']); ?></title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<?php include '../header.php'; ?>
<main class="container">
    <h1><?php echo htmlspecialchars($forum['Title']); ?></h1>
    <p><?php echo htmlspecialchars($forum['Description']); ?></p>

    <div class="posts-container">
        <?php if (!empty($posts)): ?>
            <?php foreach ($posts as $post): ?>
                <div class="post-item">
                    <p><strong><?php echo htmlspecialchars($post['Username']); ?>:</strong> <?php echo htmlspecialchars($post['Content']); ?></p>
                    <p><small><?php echo $post['Post_Date']; ?></small></p>
                    <button class="reply-button" onclick="toggleReplyForm(<?php echo $post['Post_ID']; ?>)">Répondre</button>

                    <div class="reply-form-container" id="reply-form-<?php echo $post['Post_ID']; ?>" style="display: none;">
                        <form action="" method="post">
                            <input type="hidden" name="reply_post" value="1">
                            <input type="hidden" name="parent_id" value="<?php echo $post['Post_ID']; ?>">
                            <textarea name="content" required></textarea>
                            <button type="submit">Poster</button>
                        </form>
                    </div>

                    <?php $replies = fetchReplies($pdo, $post['Post_ID']); ?>
                    <?php if (!empty($replies)): ?>
                        <div class="reply-container">
                            <?php foreach ($replies as $reply): ?>
                                <div class="post-item">
                                    <p><strong><?php echo htmlspecialchars($reply['Username']); ?>:</strong> <?php echo htmlspecialchars($reply['Content']); ?></p>
                                    <p><small><?php echo $reply['Post_Date']; ?></small></p>
                                    <button class="reply-button" onclick="toggleReplyForm(<?php echo $reply['Post_ID']; ?>)">Répondre</button>

                                    <div class="reply-form-container" id="reply-form-<?php echo $reply['Post_ID']; ?>" style="display: none;">
                                        <form action="" method="post">
                                            <input type="hidden" name="reply_post" value="1">
                                            <input type="hidden" name="parent_id" value="<?php echo $reply['Post_ID']; ?>">
                                            <textarea name="content" required></textarea>
                                            <button type="submit">Poster</button>
                                        </form>
                                    </div>

                                    <?php $nestedReplies = fetchReplies($pdo, $reply['Post_ID']); ?>
                                    <?php if (!empty($nestedReplies)): ?>
                                        <div class="reply-container">
                                            <?php foreach ($nestedReplies as $nestedReply): ?>
                                                <div class="post-item">
                                                    <p><strong><?php echo htmlspecialchars($nestedReply['Username']); ?>:</strong> <?php echo htmlspecialchars($nestedReply['Content']); ?></p>
                                                    <p><small><?php echo $nestedReply['Post_Date']; ?></small></p>
                                                    <button class="reply-button" onclick="toggleReplyForm(<?php echo $nestedReply['Post_ID']; ?>)">Répondre</button>

                                                    <div class="reply-form-container" id="reply-form-<?php echo $nestedReply['Post_ID']; ?>" style="display: none;">
                                                        <form action="" method="post">
                                                            <input type="hidden" name="reply_post" value="1">
                                                            <input type="hidden" name="parent_id" value="<?php echo $nestedReply['Post_ID']; ?>">
                                                            <textarea name="content" required></textarea>
                                                            <button type="submit">Poster</button>
                                                        </form>
                                                    </div>
                                                </div>
                                            <?php endforeach; ?>
                                        </div>
                                    <?php endif; ?>
                                </div>
                            <?php endforeach; ?>
                        </div>
                    <?php endif; ?>
                </div>
            <?php endforeach; ?>
        <?php else: ?>
            <p>No posts found.</p>
        <?php endif; ?>
    </div>

    <div class="message-form-container new-post-form">
        <h2>Ajouter un nouveau message</h2>
        <form action="" method="post">
            <input type="hidden" name="add_post" value="1">
            <textarea name="content" required></textarea>
            <button type="submit">Poster</button>
        </form>
    </div>
</main>
<script>
    function toggleReplyForm(postId) {
        const form = document.getElementById('reply-form-' + postId);
        if (form.style.display === 'none') {
            form.style.display = 'block';
        } else {
            form.style.display = 'none';
        }
    }
</script>
</body>
</html>
