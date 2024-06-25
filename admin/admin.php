<?php


include '../header.php';

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

// Suppression de l'utilisateur
if (isset($_POST['delete_user'])) {
    $user_id = $_POST['user_id'];
    $stmt = $pdo->prepare('DELETE FROM Users WHERE User_ID = :user_id');
    $stmt->execute(['user_id' => $user_id]);
}

// Changement de rôle de l'utilisateur
if (isset($_POST['change_role'])) {
    $user_id = $_POST['user_id'];
    $new_role = $_POST['new_role'];
    $stmt = $pdo->prepare('UPDATE Users SET Role = :new_role WHERE User_ID = :user_id');
    $stmt->execute(['new_role' => $new_role, 'user_id' => $user_id]);
}

// Récupération des utilisateurs
$stmt = $pdo->query('SELECT * FROM Users');
$users = $stmt->fetchAll(PDO::FETCH_ASSOC);
?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="styleadmin.css">
</head>
<body>
    <div class="container">
        <h1>Admin Dashboard</h1>
        <table>
            <thead>
                <tr>
                    <th>User_ID</th>
                    <th>Username</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($users as $user): ?>
                <tr>
                    <td><?php echo htmlspecialchars($user['User_ID']); ?></td>
                    <td><?php echo htmlspecialchars($user['Username']); ?></td>
                    <td><?php echo htmlspecialchars($user['Email']); ?></td>
                    <td><?php echo htmlspecialchars($user['Role']); ?></td>
                    <td>
                        <form method="POST" action="admin.php" style="display:inline-block;">
                            <input type="hidden" name="user_id" value="<?php echo $user['User_ID']; ?>">
                            <button type="submit" name="delete_user" onclick="return confirm('Are you sure you want to delete this user?');">Delete</button>
                        </form>
                        <form method="POST" action="admin.php" style="display:inline-block;">
                            <input type="hidden" name="user_id" value="<?php echo $user['User_ID']; ?>">
                            <select name="new_role">
                                <option value="User" <?php if ($user['Role'] == 'User') echo 'selected'; ?>>User</option>
                                <option value="Admin" <?php if ($user['Role'] == 'Admin') echo 'selected'; ?>>Admin</option>
                            </select>
                            <button type="submit" name="change_role">Change Role</button>
                        </form>
                    </td>
                </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>
</body>
</html>
