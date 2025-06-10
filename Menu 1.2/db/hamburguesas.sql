-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 17-05-2025 a las 13:26:34
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `hamburguesas`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `adicion`
--

CREATE TABLE `adicion` (
  `id_adicion` varchar(30) NOT NULL,
  `id_mesa` varchar(30) NOT NULL,
  `monto` decimal(10,0) NOT NULL,
  `estado` enum('Abierta','Cerrada','','') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `carrito`
--

CREATE TABLE `carrito` (
  `id_carrito` varchar(30) NOT NULL,
  `cliente` varchar(30) NOT NULL,
  `id_usuario` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_carrito`
--

CREATE TABLE `detalle_carrito` (
  `id_detalle_carrito` varchar(30) NOT NULL,
  `id_carrito` varchar(30) NOT NULL,
  `id_producto` varchar(30) NOT NULL,
  `cantidad` int(4) NOT NULL,
  `precio_unitario` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_pedidos`
--

CREATE TABLE `detalle_pedidos` (
  `id_detalle_pedido` varchar(30) NOT NULL,
  `id_pedidos` varchar(30) NOT NULL,
  `id_producto` varchar(30) NOT NULL,
  `cantidad` int(4) NOT NULL,
  `precio_unitario` float NOT NULL,
  `propina` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `llamados_meseros`
--

CREATE TABLE `llamados_meseros` (
  `id_llamados` varchar(30) NOT NULL,
  `id_usuario` varchar(30) NOT NULL,
  `id_mesa` int(2) NOT NULL,
  `estado` enum('activo','contestado','','') NOT NULL,
  `hora` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mesa`
--

CREATE TABLE `mesa` (
  `id_mesa` int(11) NOT NULL,
  `estado` enum('libre','ocupada','en preparacion','no habilitada') NOT NULL,
  `capacidad` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `metodo_pago`
--

CREATE TABLE `metodo_pago` (
  `id_metodo_pago` varchar(30) NOT NULL,
  `descripcion` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pagos`
--

CREATE TABLE `pagos` (
  `id_pago` varchar(30) NOT NULL,
  `id_pedidos` varchar(30) NOT NULL,
  `id_usuarios` varchar(30) NOT NULL,
  `metodo_pago` enum('Efectivo','Mercado pago','Debito','Transferencia','Targeta de Credito') NOT NULL,
  `Estado_pago` varchar(30) NOT NULL,
  `estado` date NOT NULL,
  `Numero_transaccion` varchar(255) NOT NULL,
  `hora` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `monto` decimal(10,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedidos`
--

CREATE TABLE `pedidos` (
  `id_pedidos` varchar(50) NOT NULL,
  `id_ususario` varchar(30) DEFAULT NULL,
  `id_clientes` varchar(30) NOT NULL,
  `id_mesa` int(2) NOT NULL,
  `fecha` timestamp(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  `estado` varchar(255) NOT NULL,
  `total` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id_producto` varchar(30) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(255) NOT NULL,
  `precio` float NOT NULL,
  `stock` int(11) NOT NULL,
  `img` varchar(255) NOT NULL,
  `categoria` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `id_usuario` int(30) NOT NULL,
  `nombre` varchar(30) NOT NULL,
  `clave` varchar(255) NOT NULL,
  `rol` enum('mesero','cajero','admin','') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`id_usuario`, `nombre`, `clave`, `rol`) VALUES
(1, 'coni123', '123', 'cajero'),
(2, 'ale123', '123', 'mesero'),
(3, 'nico123', '123', 'admin');

-- Productos migrados desde database.sql
INSERT INTO `productos` (`id_producto`, `nombre`, `descripcion`, `precio`, `stock`, `img`, `categoria`) VALUES
('1', 'Hamburguesa Clásica', 'Carne de res, lechuga, tomate, cebolla y queso', 12.99, 100, 'img/hamburguesa.jpg', 'Hamburguesas'),
('2', 'Hamburguesa Doble', 'Doble carne, doble queso, lechuga y tomate', 15.99, 100, 'img/hamburguesa2.jpg', 'Hamburguesas'),
('3', 'Pizza Margherita', 'Salsa de tomate, mozzarella y albahaca', 14.99, 100, 'img/pizza.jpg', 'Pizzas'),
('4', 'Pizza Pepperoni', 'Mozzarella, salsa de tomate y pepperoni', 16.99, 100, 'img/pizza2.jpg', 'Pizzas'),
('5', 'Coca-Cola 500ml', 'Bebida gaseosa fría', 2.50, 100, 'img/cocacola.jpg', 'Bebidas'),
('6', 'Agua Mineral', 'Agua sin gas 500ml', 1.80, 100, 'img/agua.jpg', 'Bebidas'),
('7', 'Menú del Día', 'Plato especial del chef, cambia cada día', 10.99, 100, 'img/menu_dia.jpg', 'Menú del día'),
('8', 'Ensalada César', 'Lechuga romana, pollo, crutones y aderezo césar', 8.99, 100, 'img/ensalada.jpg', 'Menú del día'),
('9', 'Tiramisú', 'Postre italiano con café y mascarpone', 6.99, 100, 'img/tiramisu.jpg', 'Postres'),
('10', 'Brownie', 'Brownie de chocolate con nueces', 5.50, 100, 'img/brownie.jpg', 'Postres'),
('11', 'Cheeseburger', 'Hamburguesa con queso cheddar', 13.99, 50, 'img/cheeseburger.jpg', 'Hamburguesas'),
('12', 'Fanta 500ml', 'Bebida gaseosa sabor naranja', 2.50, 80, 'img/fanta.jpg', 'Bebidas'),
('13', 'Pizza Cuatro Quesos', 'Mozzarella, gorgonzola, parmesano y ricotta', 17.99, 20, 'img/pizza4quesos.jpg', 'Pizzas'),
('14', 'Flan Casero', 'Flan de huevo con caramelo', 4.99, 30, 'img/flan.jpg', 'Postres');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `carrito`
--
ALTER TABLE `carrito`
  ADD PRIMARY KEY (`id_carrito`);

--
-- Indices de la tabla `detalle_carrito`
--
ALTER TABLE `detalle_carrito`
  ADD PRIMARY KEY (`id_detalle_carrito`);

--
-- Indices de la tabla `detalle_pedidos`
--
ALTER TABLE `detalle_pedidos`
  ADD PRIMARY KEY (`id_detalle_pedido`);

--
-- Indices de la tabla `mesa`
--
ALTER TABLE `mesa`
  ADD PRIMARY KEY (`id_mesa`);

--
-- Indices de la tabla `pagos`
--
ALTER TABLE `pagos`
  ADD PRIMARY KEY (`id_pago`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id_producto`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id_usuario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `mesa`
--
ALTER TABLE `mesa`
  MODIFY `id_mesa` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id_usuario` int(30) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
