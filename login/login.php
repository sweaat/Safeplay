<?php
session_start();

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

// Traitement du formulaire de connexion
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = $_POST['username'];
    $password = $_POST['password'];

    // Recherche de l'utilisateur dans la base de données
    $stmt = $pdo->prepare('SELECT * FROM Users WHERE Username = :username');
    $stmt->execute(['username' => $username]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    // Vérification du mot de passe
    if ($user && password_verify($password, $user['Password'])) {
        $_SESSION['user_id'] = $user['User_ID'];
        $_SESSION['username'] = $user['Username'];

        // Redirection après connexion réussie
        header('Location: ../index.php'); // Remplacez par la page de destination après connexion
        exit();
    } else {
        $error = "Nom d'utilisateur ou mot de passe incorrect.";
    }
}
?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Oswald:wght@200..700&display=swap" rel="stylesheet">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Page</title>
    <link rel="stylesheet" href="loginstyles.css">
</head>
<body>
<div class="container">
    <div class="welcome-section">
        <h1>BIENVENUE <br> SUR NOTRE <br> PLATFORM</h1>
        <p>Veuillez entrer vos identifiants <br> pour accéder à votre compte.<br>
            Si vous n'avez pas encore de compte, <br> vous pouvez vous inscrire ici.</p>
    </div>
    <div class="login-section">
        <form class="login-form" method="POST" action="login.php">
            <h2>Login</h2>
            <p>Glad you're back!</p>
            <?php if (isset($error)): ?>
                <p style="color: red;"><?php echo $error; ?></p>
            <?php endif; ?>
            <label for="username">Username</label>
            <input type="text" id="username" name="username" required>

            <label for="password">Password</label>
            <input type="password" id="password" name="password" required>

            <div class="remember-me">
                <input type="checkbox" id="remember-me" name="remember-me">
                <label for="remember-me">Remember me</label>
            </div>

            <button type="submit">Login</button>
            <a href="#">Forgot password?</a>
            <p>Don't have an account? <a href="../signup/signup.php">Signup</a></p>
            <div class="footer-links">
                <a href="#">Terms & Conditions</a>
                <a href="#">Support</a>
                <a href="#">Customer Care</a>
            </div>
        </form>
        <img src="../img/skull.png" class="skull-image">
    </div>
</div>
</body>
</html>
