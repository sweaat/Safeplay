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

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $name = $_POST['name'];
    $email = $_POST['email'];
    $subject = $_POST['subject'];
    $message = $_POST['message'];

    $stmt = $pdo->prepare("INSERT INTO support_requests (name, email, subject, message) VALUES (:name, :email, :subject, :message)");
    $stmt->bindParam(':name', $name);
    $stmt->bindParam(':email', $email);
    $stmt->bindParam(':subject', $subject);
    $stmt->bindParam(':message', $message);
    $stmt->execute();

    $success = "Your support request has been submitted successfully!";
}
?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Support</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<?php include '../header.php'; ?>
<main class="container">
    <h1>Support</h1>
    <p>If you have any questions or need assistance, please fill out the form below and we will get back to you as soon as possible.</p>

    <?php if (isset($success)): ?>
        <p class="success"><?php echo $success; ?></p>
    <?php endif; ?>

    <div class="support-form-container">
        <form action="https://formsubmit.co/mathiasbailet4@gmail.com" method="POST">
            <label for="name">Name:</label>
            <input type="text" id="name" name="name" required>

            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required>

            <label for="subject">Subject:</label>
            <input type="text" id="subject" name="subject" required>

            <label for="message">Message:</label>
            <textarea id="message" name="message" rows="5" required></textarea>

            <button type="submit">Submit</button>
        </form>
    </div>
</main>
</body>
</html>
