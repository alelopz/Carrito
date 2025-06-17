<?php
header('Content-Type: application/json');
require_once '../config/database.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    
    if (isset($data['action'])) {
        switch ($data['action']) {
            case 'crear':
                try {
                    $pdo->beginTransaction();
                    
                    // Crear el pedido
                    $stmt = $pdo->prepare("INSERT INTO pedidos (id_usuario, id_clientes, id_mesa, estado, total, comentarios) 
                                         VALUES (?, ?, ?, 'En preparación', ?, ?)");
                    $stmt->execute([
                        $data['id_usuario'],
                        $data['id_cliente'],
                        $data['id_mesa'],
                        $data['total'],
                        $data['comentarios'] ?? ''
                    ]);
                    $id_pedido = $pdo->lastInsertId();

                    // Crear los detalles del pedido
                    $stmt = $pdo->prepare("INSERT INTO detalle_pedidos (id_pedidos, id_producto, cantidad, precio_unitario) 
                                         VALUES (?, ?, ?, ?)");
                    
                    foreach ($data['items'] as $item) {
                        $stmt->execute([
                            $id_pedido,
                            $item['id_producto'],
                            $item['cantidad'],
                            $item['precio_unitario']
                        ]);
                    }

                    // Registrar el pago
                    $stmt = $pdo->prepare("INSERT INTO pagos (id_pedidos, id_usuarios, id_metodo_pago, Estado_pago, monto) 
                                         VALUES (?, ?, ?, 'Pagado', ?)");
                    $stmt->execute([
                        $id_pedido,
                        $data['id_usuario'],
                        $data['id_metodo_pago'],
                        $data['total']
                    ]);

                    $pdo->commit();
                    echo json_encode(['success' => true, 'id_pedido' => $id_pedido]);
                } catch (Exception $e) {
                    $pdo->rollBack();
                    http_response_code(500);
                    echo json_encode(['error' => 'Error al crear el pedido: ' . $e->getMessage()]);
                }
                break;

            case 'actualizar_estado':
                $stmt = $pdo->prepare("UPDATE pedidos SET estado = ? WHERE id_pedidos = ?");
                $stmt->execute([$data['estado'], $data['id_pedido']]);
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
    if (isset($_GET['id_pedido'])) {
        // Obtener detalles de un pedido específico
        $stmt = $pdo->prepare("
            SELECT p.*, dp.*, pr.nombre, pr.img, pr.descripcion 
            FROM pedidos p 
            JOIN detalle_pedidos dp ON p.id_pedidos = dp.id_pedidos 
            JOIN productos pr ON dp.id_producto = pr.id_producto 
            WHERE p.id_pedidos = ?
        ");
        $stmt->execute([$_GET['id_pedido']]);
        $pedido = $stmt->fetchAll();
        echo json_encode($pedido);
    } else {
        // Obtener todos los pedidos
        $stmt = $pdo->query("SELECT * FROM pedidos ORDER BY fecha DESC");
        $pedidos = $stmt->fetchAll();
        echo json_encode($pedidos);
    }
} else {
    http_response_code(405);
    echo json_encode(['error' => 'Método no permitido']);
}
?> 