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

// Traitement du formulaire d'inscription
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = $_POST['username'];
    $email = $_POST['email'];
    $password = password_hash($_POST['password'], PASSWORD_BCRYPT);

    // Vérification si l'utilisateur existe déjà
    $stmt = $pdo->prepare('SELECT * FROM Users WHERE Email = :email');
    $stmt->execute(['email' => $email]);
    if ($stmt->rowCount() > 0) {
        $error = "L'email est déjà utilisé.";
    } else {
        // Insertion du nouvel utilisateur avec rôle par défaut 'User'
        $stmt = $pdo->prepare('INSERT INTO Users (Username, Email, Password, Role) VALUES (:username, :email, :password, "User")');
        if ($stmt->execute(['username' => $username, 'email' => $email, 'password' => $password])) {
            $success = "Compte créé avec succès ! Nous allons maintenant vous redirigez vers la page de connection.";
            sleep(4);
            header('Location: ../login/login.php');
        } else {
            $error = "Erreur lors de la création du compte.";
        }
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
    <title>Signup Page</title>
    <link rel="stylesheet" href="signupstyle.css">
</head>
<body>
<div class="container">
    <div class="welcome-section">
        <h1>BIENVENUE <br> SUR NOTRE <br> PLATFORM</h1>
        <p>Veuillez remplir les informations <br> ci-dessous pour créer votre compte.<br>
            Si vous avez déjà un compte, <br> vous pouvez vous connecter <a href="login.php">ici</a>.</p>
    </div>
    <div class="singup-section">
        <form class="singup-form" method="POST" action="singnup.php">
            <h2>Créer un compte</h2>
            <p>Rejoignez-nous dès aujourd'hui!</p>
            <?php if (isset($error)): ?>
                <p style="color: red;"><?php echo $error; ?></p>
            <?php elseif (isset($success)): ?>
                <p style="color: green;"><?php echo $success; ?></p>
            <?php endif; ?>
            <label for="username">Nom d'utilisateur</label>
            <input type="text" id="username" name="username" required>

            <label for="email">Email</label>
            <input type="email" id="email" name="email" required>

            <label for="password">Mot de passe</label>
            <input type="password" id="password" name="password" required>

            <button type="submit">Créer un compte</button>
            <p>Vous avez déjà un compte? <a href="login.php">Connectez-vous</a></p>
            <div class="footer-links">
                <a href="#">Conditions générales</a>
                <a href="#">Support</a>
                <a href="#">Service client</a>
            </div>
        </form>
        <img src="../img/earth.png" class="signup-earth-image">
    </div>
</div>
</body>
</html>
