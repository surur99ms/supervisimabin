<?php
// Start session if not started
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

$db_host = 'localhost';
$db_name = 'supervisi_mabin';
$db_user = 'root';
$db_pass = '';

try {
    $pdo = new PDO("mysql:host=$db_host;dbname=$db_name;charset=utf8mb4", $db_user, $db_pass);
    // Set the PDO error mode to exception
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
} catch(PDOException $e) {
    $err = $e->getMessage();
    if (strpos($_SERVER['REQUEST_URI'] ?? '', 'api.php') !== false || isset($_GET['action'])) {
        header('Content-Type: application/json');
        echo json_encode(['success' => false, 'message' => 'Koneksi Database Gagal: Database belum dibuat atau salah konfigurasi.']);
        exit;
    }
    die("Connection failed: " . $err . "<br><br><b>PENTING:</b> Pastikan Anda sudah membuat database bernama '$db_name' di phpMyAdmin.");
}
?>
