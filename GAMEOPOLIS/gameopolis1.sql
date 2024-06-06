-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 06-06-2024 a las 06:00:53
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `gameopolis1`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cliente`
--

CREATE TABLE `cliente` (
  `cliente_id` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `contraseña` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cliente_direccion`
--

CREATE TABLE `cliente_direccion` (
  `cliente_id` int(11) NOT NULL,
  `direccion_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detallepedido`
--

CREATE TABLE `detallepedido` (
  `detalle_pedido_id` int(11) NOT NULL,
  `pedido_id` int(11) DEFAULT NULL,
  `videojuego_id` int(11) DEFAULT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `precio_unitario` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `direccion`
--

CREATE TABLE `direccion` (
  `direccion_id` int(11) NOT NULL,
  `direccion` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedido`
--

CREATE TABLE `pedido` (
  `pedido_id` int(11) NOT NULL,
  `cliente_id` int(11) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `estado` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `plataforma`
--

CREATE TABLE `plataforma` (
  `plataforma_id` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `imagen` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `plataforma`
--

INSERT INTO `plataforma` (`plataforma_id`, `nombre`, `imagen`) VALUES
(17, 'XBOX', 'static/imagen\\XBOX.png'),
(18, 'Activision', 'static/imagen\\Activision.png'),
(19, 'Nintendo', 'static/imagen\\Nintendo.png'),
(20, 'PlayStation', 'static/imagen\\PlayStation.png'),
(21, 'SEGA', 'static/imagen\\SEGA.png'),
(22, 'Nintendo SWITCH', 'static/imagen\\Nintendo_SWITCH.png');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `promocion`
--

CREATE TABLE `promocion` (
  `promocion_id` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `descuento` decimal(10,2) DEFAULT NULL,
  `videojuego_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `nombre_usuario` varchar(50) NOT NULL,
  `contrasena` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `nombre_usuario`, `contrasena`) VALUES
(28, 'usuario20', 'scrypt:32768:8:1$nnZKHLtvzoc0novu$120e7323ab2b090ce0110563014127439da36d377e7245e0d20f9f4189d5eb637f81ac8fe2d13c53ef026e336ad5684b8b0a7f72c96296efd0b39b1feb955097'),
(30, 'usuario1', 'scrypt:32768:8:1$po0W4GMKtA2UtKK2$521f6dd069fca031f0e0c99ad50274bdfcb4e6e4128391bb8caae3880d986ba83b55a739accb8cc17b57754a3dcb811056606100b9059a0c58a15d813c174b01'),
(31, 'tony', 'scrypt:32768:8:1$Bt4vylfAQ9TAe8vK$543b698954a01acd1ceca574bb4902184cb16e866f6f8be2b17a1b63849ea6221e2401a83b8653e98637cac41e55c9b278dbafc483a0e0fd72c0ea2457f0c30a'),
(32, 'diaz', 'scrypt:32768:8:1$FAoQUJnGmM4gc7ik$84107c2ca8fb46528bc8b7ec97b75e5157fdfaaedc1196c85f4fd997d41e47a44a62827df76e9519fe3c6d797b2c7a5302718b63a693eeaa12c220c2184b5da5'),
(33, 'hh', 'scrypt:32768:8:1$EjzV7W6sVBGlxIbm$6c29a10500c407898b538ef3b6e8404ce343f917942e2c134f5ea200c0ae50ea7ed57f54bce30c3302e07da895d5f9387ad9fd579f36b9c34cb20c8a533ab649'),
(34, 'hj', 'scrypt:32768:8:1$pmdCGOSv3sx0HbBI$5ad26b39755e7f91bb65292be18fa60596e81b9fb55a1e604a52c3c31619b58a21b68c7f17b1375736aef67494cf1db8ba2bfa83f1d0da9ba9969e77e89981f0'),
(35, '12', 'scrypt:32768:8:1$vKNB2LIwWeqRqyss$95df8967898a9ccab0940d409541df64f99c0f01d873bd9510f7f026364f5b8e0bb78472f5ea99c4be828bb20e0c3f42b770f36269e9fe54bf7aa5593f9f6177'),
(36, 'tony2', 'scrypt:32768:8:1$2nS5moKMF5CVSgMn$f6dd1bd275049b1d61727dcee074ce9ed2bd98adf15dc85e78a6063082aa600642984babcd528475eaac35bbf60e926b8ba2e6278f93aee07e8c6d74da3dfd64'),
(37, 'admin', 'scrypt:32768:8:1$0LmHkafUoxfH1Xs2$ba88db6900cc022d496c6a0f4b55c6279e340f867386d6166de2906994b14a2ca4b54eeb2891c4ac3f503de2b227ba182304c38306fe0fe6be2a931b786bc3f2');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `videojuego`
--

CREATE TABLE `videojuego` (
  `videojuego_id` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `precio` decimal(10,2) DEFAULT NULL,
  `plataforma_id` int(11) DEFAULT NULL,
  `stock` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `videojuegos`
--

CREATE TABLE `videojuegos` (
  `videojuego_id` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `precio` decimal(10,2) DEFAULT NULL,
  `plataforma_id` int(11) DEFAULT NULL,
  `stock` int(11) DEFAULT NULL,
  `imagen` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `videojuegos`
--

INSERT INTO `videojuegos` (`videojuego_id`, `nombre`, `precio`, `plataforma_id`, `stock`, `imagen`) VALUES
(43, 'NUEVO', 20.00, 17, 20, 'static/imagen/h_15.png');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`cliente_id`);

--
-- Indices de la tabla `cliente_direccion`
--
ALTER TABLE `cliente_direccion`
  ADD PRIMARY KEY (`cliente_id`,`direccion_id`),
  ADD KEY `direccion_id` (`direccion_id`);

--
-- Indices de la tabla `detallepedido`
--
ALTER TABLE `detallepedido`
  ADD PRIMARY KEY (`detalle_pedido_id`),
  ADD KEY `pedido_id` (`pedido_id`),
  ADD KEY `videojuego_id` (`videojuego_id`);

--
-- Indices de la tabla `direccion`
--
ALTER TABLE `direccion`
  ADD PRIMARY KEY (`direccion_id`);

--
-- Indices de la tabla `pedido`
--
ALTER TABLE `pedido`
  ADD PRIMARY KEY (`pedido_id`),
  ADD KEY `cliente_id` (`cliente_id`);

--
-- Indices de la tabla `plataforma`
--
ALTER TABLE `plataforma`
  ADD PRIMARY KEY (`plataforma_id`);

--
-- Indices de la tabla `promocion`
--
ALTER TABLE `promocion`
  ADD PRIMARY KEY (`promocion_id`),
  ADD KEY `videojuego_id` (`videojuego_id`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre_usuario` (`nombre_usuario`);

--
-- Indices de la tabla `videojuego`
--
ALTER TABLE `videojuego`
  ADD PRIMARY KEY (`videojuego_id`),
  ADD KEY `plataforma_id` (`plataforma_id`);

--
-- Indices de la tabla `videojuegos`
--
ALTER TABLE `videojuegos`
  ADD PRIMARY KEY (`videojuego_id`),
  ADD KEY `plataforma_id` (`plataforma_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `cliente`
--
ALTER TABLE `cliente`
  MODIFY `cliente_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detallepedido`
--
ALTER TABLE `detallepedido`
  MODIFY `detalle_pedido_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `direccion`
--
ALTER TABLE `direccion`
  MODIFY `direccion_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `pedido`
--
ALTER TABLE `pedido`
  MODIFY `pedido_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `plataforma`
--
ALTER TABLE `plataforma`
  MODIFY `plataforma_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT de la tabla `promocion`
--
ALTER TABLE `promocion`
  MODIFY `promocion_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT de la tabla `videojuego`
--
ALTER TABLE `videojuego`
  MODIFY `videojuego_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `videojuegos`
--
ALTER TABLE `videojuegos`
  MODIFY `videojuego_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `cliente_direccion`
--
ALTER TABLE `cliente_direccion`
  ADD CONSTRAINT `cliente_direccion_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `cliente` (`cliente_id`),
  ADD CONSTRAINT `cliente_direccion_ibfk_2` FOREIGN KEY (`direccion_id`) REFERENCES `direccion` (`direccion_id`);

--
-- Filtros para la tabla `detallepedido`
--
ALTER TABLE `detallepedido`
  ADD CONSTRAINT `detallepedido_ibfk_1` FOREIGN KEY (`pedido_id`) REFERENCES `pedido` (`pedido_id`),
  ADD CONSTRAINT `detallepedido_ibfk_2` FOREIGN KEY (`videojuego_id`) REFERENCES `videojuego` (`videojuego_id`);

--
-- Filtros para la tabla `pedido`
--
ALTER TABLE `pedido`
  ADD CONSTRAINT `pedido_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `cliente` (`cliente_id`);

--
-- Filtros para la tabla `promocion`
--
ALTER TABLE `promocion`
  ADD CONSTRAINT `promocion_ibfk_1` FOREIGN KEY (`videojuego_id`) REFERENCES `videojuego` (`videojuego_id`);

--
-- Filtros para la tabla `videojuego`
--
ALTER TABLE `videojuego`
  ADD CONSTRAINT `videojuego_ibfk_1` FOREIGN KEY (`plataforma_id`) REFERENCES `plataforma` (`plataforma_id`);

--
-- Filtros para la tabla `videojuegos`
--
ALTER TABLE `videojuegos`
  ADD CONSTRAINT `videojuegos_ibfk_1` FOREIGN KEY (`plataforma_id`) REFERENCES `plataforma` (`plataforma_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
