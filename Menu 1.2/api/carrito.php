<?php
header('Content-Type: application/json');
require_once '../config/database.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    
    if (isset($data['action'])) {
        switch ($data['action']) {
            case 'crear':
                // Crear un nuevo carrito
                $id_carrito = uniqid('CART_');
                $stmt = $pdo->prepare("INSERT INTO carrito (id_carrito, cliente, id_usuario) VALUES (?, ?, ?)");
                $stmt->execute([$id_carrito, $data['cliente'], $data['id_usuario']]);
                echo json_encode(['success' => true, 'id_carrito' => $id_carrito]);
                break;

            case 'agregar':
                // Agregar producto al carrito
                $stmt = $pdo->prepare("INSERT INTO detalle_carrito (id_detalle_carrito, id_carrito, id_producto, cantidad, precio_unitario) 
                                     VALUES (?, ?, ?, ?, ?)");
                $id_detalle = uniqid('DET_');
                $stmt->execute([
                    $id_detalle,
                    $data['id_carrito'],
                    $data['id_producto'],
                    $data['cantidad'],
                    $data['precio_unitario']
                ]);
                echo json_encode(['success' => true]);
                break;

            case 'actualizar':
                // Actualizar cantidad de producto
                $stmt = $pdo->prepare("UPDATE detalle_carrito SET cantidad = ? WHERE id_detalle_carrito = ?");
                $stmt->execute([$data['cantidad'], $data['id_detalle_carrito']]);
                echo json_encode(['success' => true]);
                break;

            case 'eliminar':
                // Eliminar producto del carrito
                $stmt = $pdo->prepare("DELETE FROM detalle_carrito WHERE id_detalle_carrito = ?");
                $stmt->execute([$data['id_detalle_carrito']]);
                echo json_encode(['success' => true]);
                break;

            case 'vaciar':
                // Vaciar carrito
                $stmt = $pdo->prepare("DELETE FROM detalle_carrito WHERE id_carrito = ?");
                $stmt->execute([$data['id_carrito']]);
                echo json_encode(['success' => true]);
                break;

            default:
                http_response_code(400);
                echo json_encode(['error' => 'Acción no válida']);
        }
    } else {
        http_response_code(400);
        echo json_encode(['error' => 'Acción no especificada']);
    }
} else if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if (isset($_GET['id_carrito'])) {
        // Obtener detalles del carrito
        $stmt = $pdo->prepare("
            SELECT dc.*, p.nombre, p.img 
            FROM detalle_carrito dc 
            JOIN productos p ON dc.id_producto = p.id_producto 
            WHERE dc.id_carrito = ?
        ");
        $stmt->execute([$_GET['id_carrito']]);
        $items = $stmt->fetchAll();
        echo json_encode($items);
    } else {
        http_response_code(400);
        echo json_encode(['error' => 'ID de carrito no especificado']);
    }
} else {
    http_response_code(405);
    echo json_encode(['error' => 'Método no permitido']);
}
?> 