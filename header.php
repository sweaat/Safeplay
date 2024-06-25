<?php
session_start();
// Check if the logout request is made
if (isset($_GET['action']) && $_GET['action'] === 'logout') {
    // Destroy the session and all session variables
    session_unset(); // Unset all session variables
    session_destroy(); // Destroy the session

    // Redirect to the homepage or login page after logout
    header("Location: http://localhost/projet/index.php");
    exit();
}

// Assuming you have session variables to check if the user is logged in and to get the username
$is_logged_in = isset($_SESSION['username']);
$is_admin = isset($_SESSION['Role']) && $_SESSION['Role'] === 'Admin';
$username = $is_logged_in ? $_SESSION['username'] : '';
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Votre Titre</title>
    <link rel="stylesheet" href="style.css"> <!-- Chemin ajusté si header.php est dans un sous-dossier -->
</head>
<body>
<<<<<<< HEAD
<header>
    <div class="container">
        <div class="logo">
            <a href="/Safeplay/index.php">safeplay</a>
        </div>
        <nav>
            <ul>
                <li><a href="/Safeplay/index.php">Accueil</a></li>
                <li><a href="/Safeplay/actu/actu.php">Decouvrir un jeux</a></li>
                <li><a href="#">Forums</a></li>
                <a href="/Safeplay/messagerie/messagerie.php">Messages</a>
                <li><a href="#">Support</a></li>
            </ul>
        </nav>
        <div class="auth-buttons">
            <a href="/Safeplay/login/login.php" class="btn signin">Sign in</a>
            <a href="/Safeplay/singup/singnup.php" class="btn signup">Sign Out</a>
        </div>
    </div>
</header>
=======
    <header>
        <div class="container">
            <div class="logo">
                <a href="#">safeplay</a>
            </div>
            <nav>
                <ul>
                    <li><a href="http://localhost/projet/index.php">Accueil</a></li>
                    <li><a href="http://localhost/projet/actu/actu.php">Decouvrir un jeux</a></li> <!-- Chemin ajusté -->
                    <li><a href="http://localhost/projet/forum/forum.php">Forums</a></li>
                    <li><a href="#">Messagerie</a></li>
                    <li><a href="#">Support</a></li>
                    <?php if ($is_admin): ?>
                    <li><a href="http://localhost/projet/admin/admin.php">Admin Dashboard</a></li>
                    <?php endif; ?>
                </ul>
            </nav>
            <div class="auth-buttons">
<<<<<<< HEAD
                <?php if ($is_logged_in): ?>
                    <a href="http://localhost/projet/profile/edit_profile.php" class="username"><?php echo 'bienvenue ',htmlspecialchars($username); ?></a>
                    <a href="?action=logout" class="btn logout">Logout</a>
                <?php else: ?>
                    <a href="http://localhost/projet/login/login.php" class="btn signin">Sign in</a>
                    <a href="http://localhost/projet/signup/signup.php" class="btn signup">Sign up</a>
                <?php endif; ?>
=======
                <a href="login/login.php" class="btn signin">Sign in</a>
                <a href="singup/singnup.php" class="btn signup">Sign up</a>
>>>>>>> 2dc24a33f7d8d4627b7b5dc6305b3dbf35093624
            </div>
        </div>
    </header>
    <!-- Rest of your HTML content -->
>>>>>>> 98c904fe8337d1ed8cc0af94a738dd98235fbaab
</body>
</html>
