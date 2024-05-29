<?php
session_start();

// Configuration de la base de données
$host = 'localhost';
$db = 'projet'; // Remplacez par le nom de votre base de données
$user = 'root';    // Remplacez par votre nom d'utilisateur de la base de données
$password = '';// Remplacez par votre mot de passe de la base de données

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
    $password = $_POST['password'];
    $profile_picture = $_FILES['profile_picture'];

    // Hachage du mot de passe
    $hashedPassword = password_hash($password, PASSWORD_DEFAULT);

    // Vérifier et traiter l'image téléchargée
    $target_dir = "uploads/"; // Répertoire où les images seront sauvegardées
    $target_file = $target_dir . basename($profile_picture["name"]);
    $uploadOk = 1;
    $imageFileType = strtolower(pathinfo($target_file, PATHINFO_EXTENSION));

    // Vérifier la taille du fichier
    if ($profile_picture["size"] > 500000) { // Limite de taille de 500KB
        $error = "Désolé, votre fichier est trop volumineux.";
        $uploadOk = 0;
    }

    // Autoriser certains formats de fichiers
    if($imageFileType != "jpg" && $imageFileType != "png" && $imageFileType != "jpeg" && $imageFileType != "gif" ) {
        $error = "Désolé, seuls les fichiers JPG, JPEG, PNG et GIF sont autorisés.";
        $uploadOk = 0;
    }

    // Vérifier si $uploadOk est défini à 0 par une erreur
    if ($uploadOk == 0) {
        $error = "Désolé, votre fichier n'a pas été téléchargé.";
    // Si tout est correct, essayer de télécharger le fichier
    } else {
        if (move_uploaded_file($profile_picture["tmp_name"], $target_file)) {
            // Insertion de l'utilisateur dans la base de données
            try {
                $stmt = $pdo->prepare('INSERT INTO Users (Username, Email, Password, Role, Profile_Picture) VALUES (?, ?, ?, ?, ?)');
                $stmt->execute([$username, $email, $hashedPassword, 'User', $target_file]);

                // Redirection après inscription réussie
                header('Location: login.php'); // Redirige vers la page de connexion
                exit();
            } catch (PDOException $e) {
                $error = "Erreur lors de la création de l'utilisateur: " . $e->getMessage();
            }
        } else {
            $error = "Désolé, une erreur est survenue lors du téléchargement de votre fichier.";
        }
    }
}
?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up Page</title>
    <link rel="stylesheet" href="signupstyle.css">
</head>
<body>
    <div class="container">
        <div class="welcome-section">
            <h1>Créer votre compte</h1>
            <p>Veuillez entrer vos identifiants et choisir votre mot de passe<br></p>
        </div>
        <div class="signup-section">
            <form class="signup-form" method="POST" action="signup.php" enctype="multipart/form-data">
                <h2>Sign Up</h2>
                <p>Welcome</p>
                <?php if (isset($error)): ?>
                    <p style="color: red;"><?php echo $error; ?></p>
                <?php endif; ?>
                <label for="username">Username</label>
                <input type="text" id="username" name="username" required>
                
                <label for="email">Email</label>
                <input type="email" id="email" name="email" required>
                
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>

                <label for="profile_picture">Profile Picture</label>
                <input type="file" id="profile_picture" name="profile_picture" required>
                
                <button type="submit">Sign Up</button>
                <p>Already have an account? <a href="login.php">Login</a></p>
                <div class="footer-links">
                    <a href="#">Terms & Conditions</a>
                    <a href="#">Support</a>
                    <a href="#">Customer Care</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
