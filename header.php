<?php
session_start();
?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Votre Titre</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<header>
    <div class="container">
        <div class="logo">
            <a href="/Safeplay/index.php">safeplay</a>
        </div>
        <nav>
            <ul>
                <li><a href="/Safeplay/index.php">Accueil</a></li>
                <li><a href="/Safeplay/actu/actu.php">Decouvrir un jeux</a></li>
                <li><a href="/Safeplay/forum/forum.php">Forums</a></li>
                <li><a href="/Safeplay/messagerie/messagerie.php">Messages</a></li>
                <li><a href="#">Support</a></li>
            </ul>
        </nav>
        <div class="auth-buttons">
            <?php if (isset($_SESSION['user_id'])): ?>
                <span class="username"><?php echo htmlspecialchars($_SESSION['username']); ?></span>
                <a href="/Safeplay/logout.php" class="btn logout">Déconnexion</a>
            <?php else: ?>
                <a href="/Safeplay/login/login.php" class="btn signin">Sign in</a>
                <a href="/Safeplay/singup/singnup.php" class="btn signup">Sign Out</a>
            <?php endif; ?>
        </div>
    </div>
</header>
</body>
</html>
