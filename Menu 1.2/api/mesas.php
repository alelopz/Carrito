<?php
header('Content-Type: application/json');
require_once '../config/database.php';

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // Obtener todas las mesas
    $stmt = $pdo->query("SELECT * FROM mesa ORDER BY numero_mesa");
    $mesas = $stmt->fetchAll();
    echo json_encode($mesas);
} else if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    
    if (isset($data['action'])) {
        switch ($data['action']) {
            case 'actualizar_estado':
                $stmt = $pdo->prepare("UPDATE mesa SET estado = ? WHERE id = ?");
                $stmt->execute([$data['estado'], $data['id_mesa']]);
                echo json_encode(['success' => true]);
                break;

            case 'crear':
                $stmt = $pdo->prepare("INSERT INTO mesa (numero_mesa, estado, capacidad) VALUES (?, 'libre', ?)");
                $stmt->execute([$data['numero_mesa'], $data['capacidad']]);
                echo json_encode(['success' => true, 'id' => $pdo->lastInsertId()]);
                break;

            default:
                http_response_code(400);
                echo json_encode(['error' => 'Acción no válida']);
        }
    } else {
        http_response_code(400);
        echo json_encode(['error' => 'Acción no especificada']);
    }
} else {
    http_response_code(405);
    echo json_encode(['error' => 'Método no permitido']);
}
?> 