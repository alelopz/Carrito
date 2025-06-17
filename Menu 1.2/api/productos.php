<?php
header('Content-Type: application/json');
require_once '../config/database.php';

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if (isset($_GET['id'])) {
        // Obtener un producto específico
        $stmt = $pdo->prepare("SELECT id_producto, nombre, descripcion, precio, stock, img, categoria FROM productos WHERE id_producto = ?");
        $stmt->execute([$_GET['id']]);
        $producto = $stmt->fetch();
        
        if ($producto) {
            echo json_encode($producto);
        } else {
            http_response_code(404);
            echo json_encode(['error' => 'Producto no encontrado']);
        }
    } else if (isset($_GET['categoria'])) {
        // Obtener productos por categoría
        $stmt = $pdo->prepare("SELECT id_producto, nombre, descripcion, precio, stock, img, categoria FROM productos WHERE categoria = ?");
        $stmt->execute([$_GET['categoria']]);
        $productos = $stmt->fetchAll();
        echo json_encode($productos);
    } else {
        // Obtener todos los productos
        $stmt = $pdo->query("SELECT id_producto, nombre, descripcion, precio, stock, img, categoria FROM productos");
        $productos = $stmt->fetchAll();
        echo json_encode($productos);
    }
} else {
    http_response_code(405);
    echo json_encode(['error' => 'Método no permitido']);
}
?> 