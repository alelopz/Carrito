<?php
header('Content-Type: application/json');
require_once '../config/database.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Aquí podrías implementar la lógica para notificar al mesero
    // Por ejemplo, guardar la solicitud en la base de datos
    $stmt = $pdo->prepare("INSERT INTO solicitudes_mesero (fecha_hora, estado) VALUES (NOW(), 'pendiente')");
    
    try {
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