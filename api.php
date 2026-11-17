<?php
// 1. Mulai Output Buffering untuk menahan segala output nyasar (spasi, error, atau kode SVG)
ob_start();

require_once 'config.php';

// 2. Set Header secara ketat
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

// Handle OPTIONS preflight request for CORS
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit;
}

// Read action
$action = $_GET['action'] ?? '';
$method = $_SERVER['REQUEST_METHOD'];

// Get POST JSON body if content type is application/json
$postData = [];
if ($method === 'POST') {
    $contentType = isset($_SERVER["CONTENT_TYPE"]) ? trim($_SERVER["CONTENT_TYPE"]) : '';
    if (strpos($contentType, 'application/json') !== false) {
        $content = trim(file_get_contents("php://input"));
        $postData = json_decode($content, true) ?? [];
    } else {
        $postData = $_POST;
    }
    
    // In case action is sent via POST body
    if (empty($action) && isset($postData['action'])) {
        $action = $postData['action'];
    }
}

$response = ['success' => false, 'message' => 'Invalid action'];

try {
    // Pastikan koneksi database PDO dari config.php berhasil
    if (!isset($pdo)) {
        throw new Exception("Koneksi database (PDO) tidak ditemukan atau gagal dimuat dari config.php.");
    }

    switch ($action) {
        case 'login':
            if ($method === 'POST') {
                $username = $postData['username'] ?? '';
                $password = $postData['password'] ?? '';

                // Check admin
                $stmt = $pdo->prepare("SELECT * FROM admin_users WHERE username = :username");
                $stmt->execute(['username' => $username]);
                $admin = $stmt->fetch();

                if ($admin && password_verify($password, $admin['password'])) {
                    $response = ['success' => true, 'role' => 'admin', 'name' => 'Admin Pusat'];
                    break;
                }

                // Check supervisor
                $stmt = $pdo->prepare("SELECT * FROM supervisors WHERE username = :username");
                $stmt->execute(['username' => $username]);
                $supervisor = $stmt->fetch();

                if ($supervisor && password_verify($password, $supervisor['password'])) {
                    $response = [
                        'success' => true, 
                        'role' => 'supervisor', 
                        'name' => $supervisor['nama_supervisor'], 
                        'id' => $supervisor['id'], 
                        'foto' => $supervisor['foto_profil'] ?? ''
                    ];
                    break;
                }

                $response = ['success' => false, 'message' => 'Username atau password salah'];
            }
            break;

        case 'get_madrasah':
            if ($method === 'GET') {
                $stmt = $pdo->query("SELECT id, nama_madrasah, wilayah FROM madrasah");
                $data = $stmt->fetchAll();
                foreach($data as &$row) {
                    $row['Nama_Madrasah'] = $row['nama_madrasah'];
                    $row['Wilayah'] = $row['wilayah'];
                }
                $response = $data;
            }
            break;

        case 'import_madrasah':
            if ($method === 'POST') {
                $dataToImport = $postData['dataToImport'] ?? [];
                
                $pdo->exec("TRUNCATE TABLE madrasah");
                
                $stmt = $pdo->prepare("INSERT INTO madrasah (nama_madrasah, wilayah) VALUES (:nama, :wilayah)");
                $count = 0;
                foreach ($dataToImport as $row) {
                    $nama = $row['Nama_Madrasah'] ?? $row['nama_madrasah'] ?? '';
                    $wilayah = $row['Wilayah'] ?? $row['wilayah'] ?? '';
                    if (!empty($nama)) {
                        $stmt->execute(['nama' => $nama, 'wilayah' => $wilayah]);
                        $count++;
                    }
                }
                $response = ['success' => true, 'count' => $count];
            }
            break;

        case 'import_supervisor':
            if ($method === 'POST') {
                $dataToImport = $postData['dataToImport'] ?? [];
                
                $pdo->exec("TRUNCATE TABLE supervisors");
                
                $stmt = $pdo->prepare("INSERT INTO supervisors (username, password, nama_supervisor, wilayah_tugas) VALUES (:username, :password, :nama, :wilayah)");
                $count = 0;
                foreach ($dataToImport as $row) {
                    $username = $row['Username'] ?? $row['username'] ?? '';
                    $password = $row['Password'] ?? $row['password'] ?? '';
                    $nama = $row['Nama_Supervisor'] ?? $row['nama_supervisor'] ?? '';
                    $wilayah = $row['Wilayah_Tugas'] ?? $row['wilayah_tugas'] ?? '';
                    
                    if (!empty($username) && !empty($password)) {
                        $hash = password_hash($password, PASSWORD_BCRYPT);
                        $stmt->execute(['username' => $username, 'password' => $hash, 'nama' => $nama, 'wilayah' => $wilayah]);
                        $count++;
                    }
                }
                $response = ['success' => true, 'count' => $count];
            }
            break;

        case 'add_supervisor':
            if ($method === 'POST') {
                $username = $postData['username'] ?? '';
                $password = $postData['password'] ?? '';
                $nama = $postData['nama_supervisor'] ?? '';
                $wilayah = $postData['wilayah_tugas'] ?? '';

                $stmt = $pdo->prepare("SELECT id FROM supervisors WHERE username = :username");
                $stmt->execute(['username' => $username]);
                if ($stmt->rowCount() > 0) {
                    $response = ['success' => false, 'message' => 'Username sudah digunakan'];
                } else {
                    $hash = password_hash($password, PASSWORD_BCRYPT);
                    $stmt = $pdo->prepare("INSERT INTO supervisors (username, password, nama_supervisor, wilayah_tugas) VALUES (:username, :password, :nama, :wilayah)");
                    $stmt->execute(['username' => $username, 'password' => $hash, 'nama' => $nama, 'wilayah' => $wilayah]);
                    $response = ['success' => true];
                }
            }
            break;

        case 'get_supervisors':
            if ($method === 'GET') {
                $stmt = $pdo->query("SELECT id, username, nama_supervisor, wilayah_tugas, created_at FROM supervisors");
                $response = $stmt->fetchAll();
            }
            break;

        case 'delete_supervisor':
            if ($method === 'POST') {
                $id = $postData['id'] ?? 0;
                $stmt = $pdo->prepare("DELETE FROM supervisors WHERE id = :id");
                $stmt->execute(['id' => $id]);
                $response = ['success' => true];
            }
            break;

        case 'submit_supervisi':
            if ($method === 'POST') {
                $madrasah = $postData['madrasah'] ?? '';
                $supervisor_nama = $postData['supervisor_nama'] ?? '';
                $supervisor_id = $postData['supervisor_id'] ?? 0;
                $periode = $postData['periode'] ?? '1447-1448 H';
                
                $nilai_raw = $postData['nilai'] ?? '';
                $nilai = is_array($nilai_raw) ? json_encode($nilai_raw) : $nilai_raw;
                
                $catatan_raw = $postData['catatan'] ?? '';
                $catatan = is_array($catatan_raw) ? json_encode($catatan_raw) : $catatan_raw;

                // Selalu Insert sebagai riwayat/log baru, tidak ada data yang ditimpa (di-update)
                $stmtInsert = $pdo->prepare("INSERT INTO rekap_supervisi (madrasah_nama, supervisor_id, supervisor_nama, periode, nilai, catatan) VALUES (:madrasah, :supervisor_id, :supervisor_nama, :periode, :nilai, :catatan)");
                
                $stmtInsert->execute([
                    'madrasah' => $madrasah,
                    'supervisor_id' => $supervisor_id,
                    'supervisor_nama' => $supervisor_nama,
                    'periode' => $periode,
                    'nilai' => $nilai,
                    'catatan' => $catatan
                ]);
                $response = ['success' => true];
            }
            break;

        case 'get_rekap':
        case 'get_supervisi':
            if ($method === 'GET') {
                $stmt = $pdo->query("SELECT id, madrasah_nama as madrasah, supervisor_id, supervisor_nama, periode, nilai, catatan, waktu FROM rekap_supervisi ORDER BY waktu DESC");
                $data = $stmt->fetchAll(PDO::FETCH_ASSOC);
                $response = ['success' => true, 'data' => $data];
            }
            break;

        case 'delete_data':
            if ($method === 'POST') {
                $jenis = $postData['jenis'] ?? '';
                if ($jenis === 'hasil') {
                    $pdo->exec("TRUNCATE TABLE rekap_supervisi");
                    $response = ['success' => true];
                } elseif ($jenis === 'madrasah') {
                    $pdo->exec("TRUNCATE TABLE madrasah");
                    $response = ['success' => true];
                } elseif ($jenis === 'supervisor') {
                    $pdo->exec("TRUNCATE TABLE supervisors");
                    $response = ['success' => true];
                }
            }
            break;

        case 'upload_foto':
            if ($method === 'POST') {
                $supervisor_id = $_POST['supervisor_id'] ?? 0;
                if (isset($_FILES['foto']) && $_FILES['foto']['error'] === UPLOAD_ERR_OK && $supervisor_id > 0) {
                    $uploadDir = 'uploads/foto/';
                    if (!is_dir($uploadDir)) {
                        mkdir($uploadDir, 0755, true);
                    }
                    
                    $fileInfo = pathinfo($_FILES['foto']['name']);
                    $ext = strtolower($fileInfo['extension']);
                    $allowed = ['jpg', 'jpeg', 'png', 'gif'];
                    
                    if (in_array($ext, $allowed)) {
                        $newFilename = 'sup_' . $supervisor_id . '_' . time() . '.' . $ext;
                        $uploadFile = $uploadDir . $newFilename;
                        
                        if (move_uploaded_file($_FILES['foto']['tmp_name'], $uploadFile)) {
                            $stmt = $pdo->prepare("UPDATE supervisors SET foto_profil = :path WHERE id = :id");
                            $stmt->execute(['path' => $uploadFile, 'id' => $supervisor_id]);
                            $response = ['success' => true, 'path' => $uploadFile];
                        } else {
                            $response = ['success' => false, 'message' => 'Failed to move uploaded file'];
                        }
                    } else {
                        $response = ['success' => false, 'message' => 'Invalid file extension'];
                    }
                } else {
                    $response = ['success' => false, 'message' => 'No file uploaded or error occurred'];
                }
            }
            break;

        case 'ubah_password':
            if ($method === 'POST') {
                $supervisor_id = $postData['supervisor_id'] ?? 0;
                $old_password = $postData['old_password'] ?? '';
                $new_password = $postData['new_password'] ?? '';

                $stmt = $pdo->prepare("SELECT password FROM supervisors WHERE id = :id");
                $stmt->execute(['id' => $supervisor_id]);
                $supervisor = $stmt->fetch();

                if ($supervisor && password_verify($old_password, $supervisor['password'])) {
                    $hash = password_hash($new_password, PASSWORD_BCRYPT);
                    $updateStmt = $pdo->prepare("UPDATE supervisors SET password = :hash WHERE id = :id");
                    $updateStmt->execute(['hash' => $hash, 'id' => $supervisor_id]);
                    $response = ['success' => true];
                } else {
                    $response = ['success' => false, 'message' => 'Password lama salah'];
                }
            }
            break;

        case 'register_webauthn':
            if ($method === 'POST') {
                $supervisor_id = $postData['supervisor_id'] ?? 0;
                $credential_id = $postData['credential_id'] ?? '';
                $public_key = $postData['public_key'] ?? '';

                if ($supervisor_id && $credential_id && $public_key) {
                    $stmt = $pdo->prepare("UPDATE supervisors SET webauthn_credential_id = :cid, webauthn_public_key = :pk WHERE id = :id");
                    $stmt->execute(['cid' => $credential_id, 'pk' => $public_key, 'id' => $supervisor_id]);
                    $response = ['success' => true];
                } else {
                    $response = ['success' => false, 'message' => 'Missing data'];
                }
            }
            break;

        case 'get_webauthn_users':
            if ($method === 'GET') {
                $stmt = $pdo->query("SELECT id, username, nama_supervisor, webauthn_credential_id as credential_id FROM supervisors WHERE webauthn_credential_id IS NOT NULL");
                $response = $stmt->fetchAll();
            }
            break;

        default:
            $response = ['success' => false, 'message' => 'Unknown action: ' . htmlspecialchars($action)];
            break;
    }
} catch (Exception $e) {
    $response = ['success' => false, 'message' => 'Error: ' . $e->getMessage()];
}

// 3. Ubah array PHP menjadi format JSON murni
$jsonOutput = json_encode($response);

// 4. BUBARKAN (Hapus) semua output liar yang nyangkut sebelumnya agar tidak merusak JSON
ob_end_clean(); 

// 5. Cetak murni JSON saja
echo $jsonOutput;
exit;
?>