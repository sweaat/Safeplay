<?php
$dsn = 'mysql:host=localhost;dbname=projet';
$db_user = 'root';
$db_password = '';


try {
    $pdo = new PDO($dsn, $db_user, $db_password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die('Erreur de connexion : ' . $e->getMessage());
}
$is_admin = isset($_SESSION['Role']) && $_SESSION['Role'] === 'Admin';

// Handle form submission to add a new forum
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['add_forum'])) {
    $title = $_POST['title'];
    $description = $_POST['description'];

    // Insert the new category into the database
    $stmt = $pdo->prepare("INSERT INTO forums (Title, Description) VALUES (:title, :description)");
    $stmt->bindParam(':title', $title);
    $stmt->bindParam(':description', $description);
    $stmt->execute();
}

// Handle form submission to delete a forum
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['delete_forum'])) {
    $forum_id = $_POST['forum_id'];

    // Delete the category from the database
    $stmt = $pdo->prepare("DELETE FROM forums WHERE Forum_ID = :id");
    $stmt->bindParam(':id', $forum_id);
    $stmt->execute();
}

// Fetch forum categories from the database
$query = "SELECT * FROM forums";
$stmt = $pdo->query($query);
$categories = $stmt->fetchAll(PDO::FETCH_ASSOC);
?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forum Categories</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<main>
    <?php include '../header.php';?>
    <div class="form-container">
        <h2>Ajouter un nouveau forum</h2>
        <form action="" method="post">
            <input type="hidden" name="add_forum" value="1">
            <label for="title">Nom du forum:</label>
            <input type="text" id="title" name="title" required>
            <label for="description">Description du forum:</label>
            <textarea id="description" name="description" required></textarea>
            <button type="submit">Ajouter</button>
        </form>
    </div>
    <div class="categories-container">
        <?php if (!empty($categories)): ?>
            <?php foreach ($categories as $category): ?>
                <div class="category-item">
                    <h2><a href="forum_discussion.php?id=<?php echo $category['Forum_ID']; ?>"><?php echo htmlspecialchars($category['Title']); ?></a></h2>
                    <p><?php echo htmlspecialchars($category['Description']); ?></p>
                    <?php if ($is_admin): ?>
                        <form action="" method="post">
                            <input type="hidden" name="delete_forum" value="1">
                            <input type="hidden" name="forum_id" value="<?php echo $category['Forum_ID']; ?>">
                            <button type="submit" class="delete-button">Delete Forum</button>
                        </form>
                    <?php endif; ?>
                </div>
            <?php endforeach; ?>
        <?php else: ?>
            <p>No categories found.</p>
        <?php endif; ?>
    </div>
</main>
</body>
</html>