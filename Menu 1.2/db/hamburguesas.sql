-- Eliminar la base de datos si existe
DROP DATABASE IF EXISTS `hamburguesas`;

-- Crear la base de datos
CREATE DATABASE `hamburguesas` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- Usar la base de datos
USE `hamburguesas`;

-- Tabla de productos (sin dependencias)
CREATE TABLE `productos` (
  `id_producto` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(255) NOT NULL,
  `precio` decimal(8,2) NOT NULL,
  `stock` int(3) NOT NULL,
  `img` varchar(255) DEFAULT NULL,
  `categoria` varchar(30) NOT NULL,
  PRIMARY KEY (`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Tabla de usuarios (sin dependencias)
CREATE TABLE `usuario` (
  `id_usuario` int(3) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(30) NOT NULL,
  `clave` varchar(255) NOT NULL,
  `rol` enum('mesero','cajero','admin','') NOT NULL,
  `ultima_actividad` timestamp NULL DEFAULT current_timestamp(),
  `fecha_alta` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Tabla de mesa (sin dependencias)
CREATE TABLE `mesa` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `numero_mesa` int(3) NOT NULL,
  `estado` enum('libre','ocupada') NOT NULL,
  `capacidad` int(2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Tabla de metodo_pago (sin dependencias)
CREATE TABLE `metodo_pago` (
  `id_metodo_pago` int(2) NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(30) NOT NULL,
  `habilitado` tinyint(1) NOT NULL,
  PRIMARY KEY (`id_metodo_pago`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Tabla de carrito (depende de usuario)
CREATE TABLE `carrito` (
  `id_carrito` int(8) NOT NULL AUTO_INCREMENT,
  `cliente` int(11) NOT NULL,
  `id_usuario` int(3) NOT NULL,
  PRIMARY KEY (`id_carrito`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `carrito_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Tabla de detalle_carrito (depende de carrito y productos)
CREATE TABLE `detalle_carrito` (
  `id_detalle_carrito` int(11) NOT NULL AUTO_INCREMENT,
  `id_carrito` int(8) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `cantidad` int(4) NOT NULL,
  `precio_unitario` float NOT NULL,
  PRIMARY KEY (`id_detalle_carrito`),
  KEY `id_carrito` (`id_carrito`),
  KEY `id_producto` (`id_producto`),
  CONSTRAINT `detalle_carrito_ibfk_1` FOREIGN KEY (`id_carrito`) REFERENCES `carrito` (`id_carrito`),
  CONSTRAINT `detalle_carrito_ibfk_2` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Tabla de pedidos (depende de usuario y mesa)
CREATE TABLE `pedidos` (
  `id_pedidos` int(11) NOT NULL AUTO_INCREMENT,
  `id_usuario` int(3) DEFAULT NULL,
  `id_clientes` int(11) NOT NULL,
  `id_mesa` int(3) NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp(),
  `estado` enum('Entregado','En preparación','Listo para entregar','') NOT NULL,
  `total` decimal(8,2) NOT NULL,
  `comentarios` varchar(255) NOT NULL,
  PRIMARY KEY (`id_pedidos`),
  KEY `id_usuario` (`id_usuario`),
  KEY `id_mesa` (`id_mesa`),
  CONSTRAINT `pedidos_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`),
  CONSTRAINT `pedidos_ibfk_2` FOREIGN KEY (`id_mesa`) REFERENCES `mesa` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Tabla de detalle_pedidos (depende de pedidos y productos)
CREATE TABLE `detalle_pedidos` (
  `id_detalle_pedido` int(11) NOT NULL AUTO_INCREMENT,
  `id_pedidos` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `cantidad` int(4) NOT NULL,
  `precio_unitario` float NOT NULL,
  PRIMARY KEY (`id_detalle_pedido`),
  KEY `id_pedidos` (`id_pedidos`),
  KEY `id_producto` (`id_producto`),
  CONSTRAINT `detalle_pedidos_ibfk_1` FOREIGN KEY (`id_pedidos`) REFERENCES `pedidos` (`id_pedidos`),
  CONSTRAINT `detalle_pedidos_ibfk_2` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Tabla de pagos (depende de pedidos, usuario y metodo_pago)
CREATE TABLE `pagos` (
  `id_pago` int(11) NOT NULL AUTO_INCREMENT,
  `id_pedidos` int(11) NOT NULL,
  `id_usuarios` int(3) NOT NULL,
  `id_metodo_pago` int(2) NOT NULL,
  `Estado_pago` enum('Pagado','Cancelado','Pendiente','') NOT NULL,
  `hora` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `monto` decimal(8,2) NOT NULL,
  PRIMARY KEY (`id_pago`),
  KEY `id_pedidos` (`id_pedidos`),
  KEY `id_usuarios` (`id_usuarios`),
  KEY `id_metodo_pago` (`id_metodo_pago`),
  CONSTRAINT `pagos_ibfk_1` FOREIGN KEY (`id_pedidos`) REFERENCES `pedidos` (`id_pedidos`),
  CONSTRAINT `pagos_ibfk_2` FOREIGN KEY (`id_usuarios`) REFERENCES `usuario` (`id_usuario`),
  CONSTRAINT `pagos_ibfk_3` FOREIGN KEY (`id_metodo_pago`) REFERENCES `metodo_pago` (`id_metodo_pago`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Tabla de llamados_meseros (depende de usuario y mesa)
CREATE TABLE `llamados_meseros` (
  `id_llamados` int(11) NOT NULL AUTO_INCREMENT,
  `id_usuario` int(3) NOT NULL,
  `id_mesa` int(3) NOT NULL,
  `estado` tinyint(1) NOT NULL,
  `hora_llamada` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_llamados`),
  KEY `id_usuario` (`id_usuario`),
  KEY `id_mesa` (`id_mesa`),
  CONSTRAINT `llamados_meseros_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`),
  CONSTRAINT `llamados_meseros_ibfk_2` FOREIGN KEY (`id_mesa`) REFERENCES `mesa` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Tabla de adicion (depende de mesa)
CREATE TABLE `adicion` (
  `id_adicion` int(6) NOT NULL AUTO_INCREMENT,
  `id_mesa` int(3) NOT NULL,
  `monto` decimal(8,2) NOT NULL,
  `estado` enum('Abierta','Cerrada') NOT NULL,
  PRIMARY KEY (`id_adicion`),
  KEY `id_mesa` (`id_mesa`),
  CONSTRAINT `adicion_ibfk_1` FOREIGN KEY (`id_mesa`) REFERENCES `mesa` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Tabla de asignaciones_meseros (depende de usuario y mesa)
CREATE TABLE `asignaciones_meseros` (
  `id_asignacion` int(3) NOT NULL AUTO_INCREMENT,
  `id_mesa` int(3) NOT NULL,
  `id_usuario` int(3) NOT NULL,
  `hora_asignacion` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_asignacion`),
  KEY `id_mesa` (`id_mesa`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `asignaciones_meseros_ibfk_1` FOREIGN KEY (`id_mesa`) REFERENCES `mesa` (`id`),
  CONSTRAINT `asignaciones_meseros_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Insertar usuario por defecto
INSERT INTO `usuario` (`nombre`, `clave`, `rol`) VALUES
('Admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin');

-- Insertar mesero por defecto
INSERT INTO `usuario` (`nombre`, `clave`, `rol`) VALUES
('Mesero', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'mesero');

-- Insertar mesas
INSERT INTO `mesa` (`numero_mesa`, `estado`, `capacidad`) VALUES
(1, 'libre', 4),
(2, 'libre', 4),
(3, 'libre', 6),
(4, 'libre', 6),
(5, 'libre', 8);

-- Insertar métodos de pago
INSERT INTO `metodo_pago` (`descripcion`, `habilitado`) VALUES
('Efectivo', 1),
('Mercado Pago', 0),
('Tarjeta de credito', 1);

-- Insertar los productos
INSERT INTO `productos` (`nombre`, `descripcion`, `precio`, `stock`, `img`, `categoria`) VALUES
('Hamburguesa Clásica', 'Carne de res, lechuga, tomate, cebolla y queso', 12.99, 100, 'img/hamburguesa.jpg', 'Hamburguesas'),
('Hamburguesa Doble', 'Doble carne, doble queso, lechuga y tomate', 15.99, 100, 'img/hamburguesa2.jpg', 'Hamburguesas'),
('Pizza Margherita', 'Salsa de tomate, mozzarella y albahaca', 14.99, 100, 'img/pizza.jpg', 'Pizzas'),
('Pizza Pepperoni', 'Mozzarella, salsa de tomate y pepperoni', 16.99, 100, 'img/pizza2.jpg', 'Pizzas'),
('Coca-Cola 500ml', 'Bebida gaseosa fría', 2.50, 100, 'img/cocacola.jpg', 'Bebidas'),
('Agua Mineral', 'Agua sin gas 500ml', 1.80, 100, 'img/agua.jpg', 'Bebidas'),
('Menú del Día', 'Plato especial del chef, cambia cada día', 10.99, 100, 'img/menu_dia.jpg', 'Menú del día'),
('Ensalada César', 'Lechuga romana, pollo, crutones y aderezo césar', 8.99, 100, 'img/ensalada.jpg', 'Menú del día'),
('Tiramisú', 'Postre italiano con café y mascarpone', 6.99, 100, 'img/tiramisu.jpg', 'Postres'),
('Brownie', 'Brownie de chocolate con nueces', 5.50, 100, 'img/brownie.jpg', 'Postres'),
('Cheeseburger', 'Hamburguesa con queso cheddar', 13.99, 50, 'img/cheeseburger.jpg', 'Hamburguesas'),
('Fanta 500ml', 'Bebida gaseosa sabor naranja', 2.50, 80, 'img/fanta.jpg', 'Bebidas'),
('Pizza Cuatro Quesos', 'Mozzarella, gorgonzola, parmesano y ricotta', 17.99, 20, 'img/pizza4quesos.jpg', 'Pizzas'),
('Flan Casero', 'Flan de huevo con caramelo', 4.99, 30, 'img/flan.jpg', 'Postres'); 