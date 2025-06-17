<?php
header('Content-Type: application/json');
require_once '../config/database.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        // Registrar el llamado del mesero
        $stmt = $pdo->prepare("INSERT INTO llamados_meseros (id_usuario, id_mesa, estado) VALUES (2, 1, 1)");
        $stmt->execute();
        echo json_encode(['success' => true, 'message' => 'Mesero notificado']);
    } catch(PDOException $e) {
        http_response_code(500);
        echo json_encode(['error' => 'Error al notificar al mesero']);
    }
} else {
    http_response_code(405);
    echo json_encode(['error' => 'Método no permitido']);
}
?> 