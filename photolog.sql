-- phpMyAdmin SQL Dump
-- version 4.1.14
-- http://www.phpmyadmin.net
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 07-10-2015 a las 09:49:02
-- Versión del servidor: 5.6.17
-- Versión de PHP: 5.5.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de datos: `photolog`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `borrarAmistad`(
IN ide int, IN ideA int
)
BEGIN
SET SQL_SAFE_UPDATES = 0;
delete FROM amistad where usuario_id = ide and ID_AMIGO = ideA;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `borrarComentario`(in id int)
BEGIN
	SET SQL_SAFE_UPDATES = 0;
	DELETE FROM COMENTARIO where ID_COMENTARIO = id;
    UPDATE fotos
    SET fotos.CANTIDAD_COMENTARIOS = fotos.CANTIDAD_COMENTARIOS -1 WHERE fotos.ID_FOTO = ID_FOTO;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `borrarFoto`(in id int)
BEGIN
	SET SQL_SAFE_UPDATES = 0;
	DELETE FROM COMENTARIO where ID_FOTO = id;
	DELETE FROM FOTO where ID_FOTO = id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `borrarUsuario`(IN `ide` INT)
BEGIN
declare i int;
declare limite int;
declare idf int;
set idf = 0;
set i = 0;
SET SQL_SAFE_UPDATES = 0;
set limite = (select count(id_foto) from foto where usuario_id = ide);


	while (i < limite+1) do
		select id_foto into idf from foto where usuario_id = ide limit 1;
		call borrarFoto(idf);
		set i = i + 1;

    END WHILE;
    DELETE FROM amistad where usuario_id = ide;
    DELETE FROM amistad where id_amigo = ide;
    DELETE FROM comentario where usuario_id = ide;
    DELETE FROM usuario where usuario_id = ide;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertarAmistad`(in id_u int,in id_a int)
BEGIN
	INSERT INTO AMISTAD(usuario_id, ID_AMIGO, FECHA_AMISTAD) VALUES(id_u,id_a,now());
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertarComentario`(in id_f int, in coment varchar(200), in ptje int,in id_u int)
BEGIN
if (select CANTIDAD_COMENTARIOS from FOTO where id_foto = id_f) <20 then
INSERT INTO COMENTARIO (ID_FOTO, COMENTARIO, PUNTAJE_ASIGNADO, usuario_id) values (id_f, coment,ptje,id_u);
update foto
set CANTIDAD_COMENTARIOS = CANTIDAD_COMENTARIOS +1 where foto.ID_FOTO=id_f;
end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertarFoto`(in id_u int, in title varchar(50), in photo longblob, in descr varchar(200))
BEGIN

	INSERT INTO FOTO (usuario_id, TITULO, FOTO, DESCRIPCION, SUMA_PUNTAJE, PUNTAJE_TOTAL) values (id_u, title, photo, descr,0,0);
    UPDATE USUARIO
    set FECHA_UL_ACTUALIZACION = now() where usuario_id = id_u;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertarUsuario`(IN nick varchar(50), IN contraseña varchar(50),
IN nombre varchar(50), IN apellido varchar(50),IN mail varchar(50), IN admin bool)
begin
	INSERT INTO usuario(NICK, CONTRASENA, NOMBRE , APELLIDO, CORREO, ES_ADMIN) VALUES(nick, AES_ENCRYPT('text', contraseña), nombre, apellido, mail, admin);
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateComentario`(in id int, in coment varchar(200),in ptje int)
BEGIN

    IF coment IS NOT NULL then

    UPDATE COMENTARIO

    SET COMENTARIO = coment where ID_COMENTARIO = id;
    END IF;

    IF ptje IS NOT NULL then

    UPDATE COMENTARIO

    set PUNTAJE_ASIGNADO = ptje where ID_COMENTARIO = id;

    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateFoto`(in id int, in title varchar(20), in descr varchar(200))
BEGIN


    IF title IS NOT NULL then

    UPDATE FOTO

    set TITULO = title where ID_FOTO = id;

    END IF;

    IF descr IS NOT NULL then

    UPDATE FOTO

    set DESCRIPCION = descr where ID_FOTO = id;

    END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateUsuario`(IN ide int,IN nicke varchar(50), IN contraseña varchar(50),
IN nombre varchar(50), IN apellido varchar(50),IN mail varchar(50), IN admin bool)
BEGIN
IF nicke IS NOT NULL then
update usuario
Set NICK = nicke where usuario_id = ide;
end if;
IF contraseña IS NOT NULL then
update usuario
Set CONTRASENA = contraseña where usuario_id = ide;
end if;
IF nombre IS NOT NULL then
update usuario
Set NOMBRE = nombre where usuario_id = ide;
end if;
IF apellido IS NOT NULL then
update usuario
Set APELLIDO = apellido where usuario_id = ide;
end if;
IF mail IS NOT NULL then
update usuario
Set CORREO = mail where usuario_id = ide;
end if;
IF admin IS NOT NULL then
update usuario
Set ES_ADMIN = admin where usuario_id = ide;
end if;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `amigos`
--

CREATE TABLE IF NOT EXISTS `amigos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario_id` int(11) DEFAULT NULL,
  `id_amigo` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_amigos_on_usuario_id` (`usuario_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `amigos`
--

INSERT INTO `amigos` (`id`, `usuario_id`, `id_amigo`, `created_at`, `updated_at`) VALUES
(1, 25, 6, '2015-10-07 07:00:37', '2015-10-07 07:00:37'),
(2, 25, 28, '2015-10-07 07:01:05', '2015-10-07 07:01:05');

--
-- Disparadores `amigos`
--
DROP TRIGGER IF EXISTS `finAmistad`;
DELIMITER //
CREATE TRIGGER `finAmistad` BEFORE DELETE ON `amigos`
 FOR EACH ROW insert into auditoria(ACCION,usuario_id,OLD,TS)
values('AMISTAD BORRADA',old.usuario_id,CONCAT_WS( ', ', old.id, old.usuario_id, old.id_amigo, old.created_at ),now())
//
DELIMITER ;
DROP TRIGGER IF EXISTS `nuevaAmistad`;
DELIMITER //
CREATE TRIGGER `nuevaAmistad` AFTER INSERT ON `amigos`
 FOR EACH ROW insert into auditoria(ACCION,usuario_id,NEW,TS)
		values('NUEVA AMISTAD',new.usuario_id,CONCAT_WS( ', ', new.id, new.usuario_id, new.id_amigo, new.created_at ),now())
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auditoria`
--

CREATE TABLE IF NOT EXISTS `auditoria` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario_id` int(11) DEFAULT NULL,
  `accion` varchar(255) DEFAULT NULL,
  `old` varchar(255) DEFAULT NULL,
  `new` varchar(255) DEFAULT NULL,
  `ts` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `auditoria`
--

INSERT INTO `auditoria` (`id`, `usuario_id`, `accion`, `old`, `new`, `ts`, `created_at`, `updated_at`) VALUES
(1, 21, 'SUBE_FOTO', NULL, '30, 21, subiendo foto, pa ver q ondi, 2015-10-06 22:38:50', '2015-10-07 00:38:50', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(2, 6, 'EDITA FOTO', '21, 6, probando foto, probando, 2015-10-06 03:56:56', '21, 6, probando foto, probando, 2015-10-06 03:56:56', '2015-10-07 00:39:03', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(3, 21, 'AGREGA_COMENTARIO', NULL, '18, 21, wwasassa, 1, 2015-10-06 22:39:03, 21', '2015-10-07 00:39:03', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(4, 21, 'SUBE_FOTO', NULL, '31, 21, otra foto, pa ver q sucede, 2015-10-06 22:41:55', '2015-10-07 00:41:55', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(5, 21, 'SUBE_FOTO', NULL, '32, 21, cdcdcdcdcddc, cdcdcdcdcdcdcd, 2015-10-06 22:55:00', '2015-10-07 00:55:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(6, 22, 'NUEVO USUARIO', NULL, '22, 1234@1234.com, 2015-10-06 22:57:37, 0, 2015-10-06 22:57:37', '2015-10-07 00:57:37', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(7, 22, 'EDITA USUARIO', '22, 1234@1234.com, 2015-10-06 22:57:37, 0, 2015-10-06 22:57:37', '22, 1234@1234.com, 2015-10-06 22:57:38, 0, 2015-10-06 22:57:38', '2015-10-07 00:57:38', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(8, 22, 'EDITA USUARIO', '22, 1234@1234.com, 2015-10-06 22:57:38, 0, 2015-10-06 22:57:38', '22, Nick, 12345678, nombre, apellido, 1234@1234.com, 2015-10-06 22:58:07, 2, 2015-10-06 22:58:07', '2015-10-07 00:58:07', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(9, 9, 'EDITA USUARIO', '9, admin, 12345678, admin, admin, admin@gmail.com, 2015-10-06 00:30:42, 0, 2015-10-06 00:30:42', '9, admin, 12345678, admin, admin, admin@gmail.com, 2015-10-06 23:05:27, 0, 2015-10-06 23:05:27', '2015-10-07 01:05:27', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(10, 6, 'EDITA USUARIO', '6, smedinas, , sergio, medina, medina159@gmail.com, 2015-10-05 23:47:46, 1, 2015-10-05 23:47:46', '6, smedinas, , sergio, medina, medina159@gmail.com, 2015-10-06 23:35:15, 1, 2015-10-06 23:35:15', '2015-10-07 01:35:15', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(11, 6, 'SUBE_FOTO', NULL, '33, 6, eeedada, eedadadda, 2015-10-06 23:35:27', '2015-10-07 01:35:27', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(12, 6, 'SUBE_FOTO', NULL, '34, 6, tgtgttg we erg, fef ef ef sef e , 2015-10-06 23:35:41', '2015-10-07 01:35:41', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(13, 6, 'SUBE_FOTO', NULL, '35, 6, tgtgttg we erg, fef ef ef sef e , 2015-10-06 23:35:43', '2015-10-07 01:35:43', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(14, 11, 'EDITA USUARIO', '11, mi nick, 12345678, random, apellido, 123@123.com, 2015-10-06 16:39:57, 2, 2015-10-06 16:39:57', '11, mi nick, 12345678, random, apellido, 123@123.com, 2015-10-06 23:36:02, 2, 2015-10-06 23:36:02', '2015-10-07 01:36:02', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(15, 23, 'NUEVO USUARIO', NULL, '23, hola1@hola.cl, 2015-10-07 00:36:31, 0, 2015-10-07 00:36:31', '2015-10-07 02:36:31', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(16, 23, 'EDITA USUARIO', '23, hola1@hola.cl, 2015-10-07 00:36:31, 0, 2015-10-07 00:36:31', '23, hola1@hola.cl, 2015-10-07 00:36:31, 0, 2015-10-07 00:36:31', '2015-10-07 02:36:31', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(17, 23, 'EDITA USUARIO', '23, hola1@hola.cl, 2015-10-07 00:36:31, 0, 2015-10-07 00:36:31', '23, hola, holahola, hola, hola, hola1@hola.cl, 2015-10-07 00:48:46, 0, 2015-10-07 00:48:46', '2015-10-07 02:48:46', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(18, 23, 'EDITA USUARIO', '23, hola, holahola, hola, hola, hola1@hola.cl, 2015-10-07 00:48:46, 0, 2015-10-07 00:48:46', '23, hola, holahola, hola, hola, hola1@hola.cl, 2015-10-07 00:48:46, 0, 2015-10-07 00:48:46', '2015-10-07 02:49:40', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(19, 23, 'SUBE_FOTO', NULL, '36, 23, subiendo foto al usuario hola, esta es la foto del usuario hola, 2015-10-07 00:49:42', '2015-10-07 02:49:42', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(20, 11, 'EDITA USUARIO', '11, mi nick, 12345678, random, apellido, 123@123.com, 2015-10-06 23:36:02, 2, 2015-10-06 23:36:02', '11, mi nick, 12345678, random, apellido, 123@123.com, 2015-10-07 00:59:48, 2, 2015-10-07 00:59:48', '2015-10-07 02:59:48', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(21, 23, 'EDITA USUARIO', '23, hola, holahola, hola, hola, hola1@hola.cl, 2015-10-07 00:48:46, 0, 2015-10-07 00:48:46', '23, hola, holahola, hola, hola, hola1@hola.cl, 2015-10-07 01:08:30, 0, 2015-10-07 01:08:30', '2015-10-07 03:08:30', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(22, 23, 'EDITA FOTO', '36, 23, subiendo foto al usuario hola, esta es la foto del usuario hola, 2015-10-07 00:49:42', '36, 23, subiendo foto al usuario hola, nueva descripcion, 2015-10-07 01:13:57', '2015-10-07 03:13:57', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(23, 24, 'NUEVO USUARIO', NULL, '24, 1chao@chao.cl, 2015-10-07 01:15:29, 0, 2015-10-07 01:15:29', '2015-10-07 03:15:29', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(24, 24, 'EDITA USUARIO', '24, 1chao@chao.cl, 2015-10-07 01:15:29, 0, 2015-10-07 01:15:29', '24, 1chao@chao.cl, 2015-10-07 01:15:29, 0, 2015-10-07 01:15:29', '2015-10-07 03:15:29', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(25, 24, 'EDITA USUARIO', '24, 1chao@chao.cl, 2015-10-07 01:15:29, 0, 2015-10-07 01:15:29', '24, chao, chaochao, chao, chao, 1chao@chao.cl, 2015-10-07 01:16:07, 0, 2015-10-07 01:16:07', '2015-10-07 03:16:07', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(26, 24, 'EDITA USUARIO', '24, chao, chaochao, chao, chao, 1chao@chao.cl, 2015-10-07 01:16:07, 0, 2015-10-07 01:16:07', '24, chao, chaochao, chao, chao, 1chao@chao.cl, 2015-10-07 01:16:07, 0, 2015-10-07 01:16:07', '2015-10-07 03:16:55', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(27, 24, 'SUBE_FOTO', NULL, '37, 24, chaochaochao, chaochaochaochao, 2015-10-07 01:16:56', '2015-10-07 03:16:56', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(28, 23, 'EDITA FOTO', '36, 23, subiendo foto al usuario hola, nueva descripcion, 2015-10-07 01:13:57', '36, 23, subiendo foto al usuario hola, nueva descripcion, 2015-10-07 01:13:57', '2015-10-07 03:17:48', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(29, 24, 'AGREGA_COMENTARIO', NULL, '19, 36, buena foto, 2, 2015-10-07 01:17:48, 24', '2015-10-07 03:17:48', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(30, 24, 'EDITA USUARIO', '24, chao, chaochao, chao, chao, 1chao@chao.cl, 2015-10-07 01:16:07, 0, 2015-10-07 01:16:07', '24, chao, , chao, chao, 1chao@chao.cl, 2015-10-07 01:18:12, 1, 2015-10-07 01:18:12', '2015-10-07 03:18:12', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(31, 11, 'EDITA USUARIO', '11, mi nick, 12345678, random, apellido, 123@123.com, 2015-10-07 00:59:48, 2, 2015-10-07 00:59:48', '11, mi nick, 12345678, random, apellido, 123@123.com, 2015-10-07 01:18:26, 2, 2015-10-07 01:18:26', '2015-10-07 03:18:26', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(39, 24, 'BORRO FOTO', '37, 24, chaochaochao, chaochaochaochao, 2015-10-07 01:16:56', NULL, '2015-10-07 04:04:20', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(40, 6, 'BORRO FOTO', '34, 6, tgtgttg we erg, fef ef ef sef e , 2015-10-06 23:35:41', NULL, '2015-10-07 04:04:36', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(41, 11, 'EDITA USUARIO', '11, mi nick, 12345678, random, apellido, 123@123.com, 2015-10-07 01:18:26, 2, 2015-10-07 01:18:26', '11, mi nick, 12345678, random, apellido, 123@123.com, 2015-10-07 03:22:05, 2, 2015-10-07 03:22:05', '2015-10-07 05:22:05', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(42, 25, 'NUEVO USUARIO', NULL, '25, mumf@ord.cl, 2015-10-07 03:23:46, 0, 2015-10-07 03:23:46', '2015-10-07 05:23:46', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(43, 25, 'EDITA USUARIO', '25, mumf@ord.cl, 2015-10-07 03:23:46, 0, 2015-10-07 03:23:46', '25, mumf@ord.cl, 2015-10-07 03:23:46, 0, 2015-10-07 03:23:46', '2015-10-07 05:23:46', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(44, 25, 'EDITA USUARIO', '25, mumf@ord.cl, 2015-10-07 03:23:46, 0, 2015-10-07 03:23:46', '25, negro, , negro, negro, mumf@ord.cl, 2015-10-07 03:34:59, 0, 2015-10-07 03:34:59', '2015-10-07 05:34:59', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(45, 25, 'EDITA USUARIO', '25, negro, , negro, negro, mumf@ord.cl, 2015-10-07 03:34:59, 0, 2015-10-07 03:34:59', '25, negro, , negro, negro, mumf@ord.cl, 2015-10-07 03:34:59, 0, 2015-10-07 03:34:59', '2015-10-07 05:35:25', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(46, 25, 'SUBE_FOTO', NULL, '38, 25, foto mia, eweweqeqwewqeqwe, 2015-10-07 03:35:28', '2015-10-07 05:35:28', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(47, 25, 'BORRO FOTO', '38, 25, foto mia, eweweqeqwewqeqwe, 2015-10-07 03:35:28', NULL, '2015-10-07 05:35:38', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(48, 25, 'EDITA USUARIO', '25, negro, , negro, negro, mumf@ord.cl, 2015-10-07 03:34:59, 0, 2015-10-07 03:34:59', '25, negro, , negro, negro, mumf@ord.cl, 2015-10-07 03:40:50, 0, 2015-10-07 03:40:50', '2015-10-07 05:40:50', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(49, 6, 'EDITA FOTO', '22, 6, nueva foto, una nueva foto, 2015-10-05 23:45:32', '22, 6, nueva foto, una nueva foto, 2015-10-05 23:45:32', '2015-10-07 05:41:13', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(50, 25, 'AGREGA_COMENTARIO', NULL, '20, 22, eee2e2, 0, 2015-10-07 03:41:13, 25', '2015-10-07 05:41:13', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(51, 11, 'EDITA USUARIO', '11, mi nick, 12345678, random, apellido, 123@123.com, 2015-10-07 03:22:05, 2, 2015-10-07 03:22:05', '11, mi nick, 12345678, random, apellido, 123@123.com, 2015-10-07 04:01:01, 2, 2015-10-07 04:01:01', '2015-10-07 06:01:01', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(52, 25, 'EDITA USUARIO', '25, negro, , negro, negro, mumf@ord.cl, 2015-10-07 03:40:50, 0, 2015-10-07 03:40:50', '25, negro, , negro, negro, mumf@ord.cl, 2015-10-07 05:02:29, 0, 2015-10-07 05:02:29', '2015-10-07 07:02:29', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(53, 6, 'EDITA USUARIO', '6, smedinas, , sergio, medina, medina159@gmail.com, 2015-10-06 23:35:15, 1, 2015-10-06 23:35:15', '6, smedinas, , sergio, medina, medina159@gmail.com, 2015-10-07 05:04:41, 1, 2015-10-07 05:04:41', '2015-10-07 07:04:41', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(54, 26, 'NUEVO USUARIO', NULL, '26, nuevo@nuevo.cl, 2015-10-07 05:05:20, 0, 2015-10-07 05:05:20', '2015-10-07 07:05:20', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(55, 26, 'EDITA USUARIO', '26, nuevo@nuevo.cl, 2015-10-07 05:05:20, 0, 2015-10-07 05:05:20', '26, nuevo@nuevo.cl, 2015-10-07 05:05:20, 0, 2015-10-07 05:05:20', '2015-10-07 07:05:20', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(56, 26, 'EDITA USUARIO', '26, nuevo@nuevo.cl, 2015-10-07 05:05:20, 0, 2015-10-07 05:05:20', '26, nuevo, nuevonuevo, nuevo, nuevo, nuevo@nuevo.cl, 2015-10-07 05:06:13, 0, 2015-10-07 05:06:13', '2015-10-07 07:06:13', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(57, 26, 'EDITA USUARIO', '26, nuevo, nuevonuevo, nuevo, nuevo, nuevo@nuevo.cl, 2015-10-07 05:06:13, 0, 2015-10-07 05:06:13', '26, nuevo, nuevonuevo, nuevo, nuevo, nuevo@nuevo.cl, 2015-10-07 05:06:13, 0, 2015-10-07 05:06:13', '2015-10-07 07:07:24', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(58, 26, 'SUBE_FOTO', NULL, '39, 26, nueva foto de usuario nuevo, ya está amaneciendo, 2015-10-07 05:07:29', '2015-10-07 07:07:29', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(59, 27, 'NUEVO USUARIO', NULL, '27, holahola@hola.com, 2015-10-07 05:08:38, 0, 2015-10-07 05:08:38', '2015-10-07 07:08:38', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(60, 27, 'EDITA USUARIO', '27, holahola@hola.com, 2015-10-07 05:08:38, 0, 2015-10-07 05:08:38', '27, holahola@hola.com, 2015-10-07 05:08:38, 0, 2015-10-07 05:08:38', '2015-10-07 07:08:38', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(61, 27, 'EDITA USUARIO', '27, holahola@hola.com, 2015-10-07 05:08:38, 0, 2015-10-07 05:08:38', '27, hola, holahola, hola, hola, holahola@hola.com, 2015-10-07 05:08:53, 0, 2015-10-07 05:08:53', '2015-10-07 07:08:53', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(62, 27, 'EDITA USUARIO', '27, hola, holahola, hola, hola, holahola@hola.com, 2015-10-07 05:08:53, 0, 2015-10-07 05:08:53', '27, hola, holahola, hola, hola, holahola@hola.com, 2015-10-07 05:08:53, 0, 2015-10-07 05:08:53', '2015-10-07 07:09:21', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(63, 27, 'SUBE_FOTO', NULL, '40, 27, foto de juego, foto nueva , 2015-10-07 05:09:22', '2015-10-07 07:09:22', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(64, 11, 'EDITA USUARIO', '11, mi nick, 12345678, random, apellido, 123@123.com, 2015-10-07 04:01:01, 2, 2015-10-07 04:01:01', '11, mi nick, 12345678, random, apellido, 123@123.com, 2015-10-07 05:09:56, 2, 2015-10-07 05:09:56', '2015-10-07 07:09:56', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(65, 27, 'EDITA USUARIO', '27, hola, holahola, hola, hola, holahola@hola.com, 2015-10-07 05:08:53, 0, 2015-10-07 05:08:53', '27, hola, holahola, hola, hola, holahola@hola.com, 2015-10-07 05:11:19, 0, 2015-10-07 05:11:19', '2015-10-07 07:11:19', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(66, 27, 'EDITA USUARIO', '27, hola, holahola, hola, hola, holahola@hola.com, 2015-10-07 05:11:19, 0, 2015-10-07 05:11:19', '27, hola, holahola, hola, hola, holahola@hola.com, 2015-10-07 05:11:19, 0, 2015-10-07 05:11:19', '2015-10-07 07:11:19', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(67, 27, 'EDITA FOTO', '40, 27, foto de juego, foto nueva , 2015-10-07 05:09:22', '40, 27, foto de juego, descripcion modificiada, 2015-10-07 05:14:05', '2015-10-07 07:14:05', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(68, 27, 'EDITA USUARIO', '27, hola, holahola, hola, hola, holahola@hola.com, 2015-10-07 05:11:19, 0, 2015-10-07 05:11:19', '27, hola, holahola, hola, hola, holahola@hola.com, 2015-10-07 05:14:22, 0, 2015-10-07 05:14:22', '2015-10-07 07:14:22', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(69, 28, 'NUEVO USUARIO', NULL, '28, chaochao@chao.com, 2015-10-07 05:14:32, 0, 2015-10-07 05:14:32', '2015-10-07 07:14:32', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(70, 28, 'EDITA USUARIO', '28, chaochao@chao.com, 2015-10-07 05:14:32, 0, 2015-10-07 05:14:32', '28, chaochao@chao.com, 2015-10-07 05:14:32, 0, 2015-10-07 05:14:32', '2015-10-07 07:14:32', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(71, 28, 'EDITA USUARIO', '28, chaochao@chao.com, 2015-10-07 05:14:32, 0, 2015-10-07 05:14:32', '28, chao, chaochao, chao, chao, chaochao@chao.com, 2015-10-07 05:14:41, 0, 2015-10-07 05:14:41', '2015-10-07 07:14:41', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(72, 28, 'EDITA USUARIO', '28, chao, chaochao, chao, chao, chaochao@chao.com, 2015-10-07 05:14:41, 0, 2015-10-07 05:14:41', '28, chao, chaochao, chao, chao, chaochao@chao.com, 2015-10-07 05:14:41, 0, 2015-10-07 05:14:41', '2015-10-07 07:15:04', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(73, 28, 'SUBE_FOTO', NULL, '41, 28, foto nueva de chao, chao tiene foto nueva, 2015-10-07 05:15:05', '2015-10-07 07:15:05', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(74, 27, 'EDITA FOTO', '40, 27, foto de juego, descripcion modificiada, 2015-10-07 05:14:05', '40, 27, foto de juego, descripcion modificiada, 2015-10-07 05:14:05', '2015-10-07 07:15:26', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(75, 28, 'AGREGA_COMENTARIO', NULL, '21, 40, estoy comentando, 3, 2015-10-07 05:15:26, 28', '2015-10-07 07:15:26', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(76, 28, 'NUEVO_GOLD', NULL, '1, 28, 2015-10-07 05:15:37', '2015-10-07 07:15:37', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(77, 28, 'EDITA USUARIO', '28, chao, chaochao, chao, chao, chaochao@chao.com, 2015-10-07 05:14:41, 0, 2015-10-07 05:14:41', '28, chao, chaochao, chao, chao, chaochao@chao.com, 2015-10-07 05:15:37, 1, 2015-10-07 05:15:37', '2015-10-07 07:15:37', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(78, 11, 'EDITA USUARIO', '11, mi nick, 12345678, random, apellido, 123@123.com, 2015-10-07 05:09:56, 2, 2015-10-07 05:09:56', '11, mi nick, 12345678, random, apellido, 123@123.com, 2015-10-07 05:16:22, 2, 2015-10-07 05:16:22', '2015-10-07 07:16:22', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(79, 11, 'EDITA USUARIO', '11, mi nick, 12345678, random, apellido, 123@123.com, 2015-10-07 05:16:22, 2, 2015-10-07 05:16:22', '11, mi nick, 12345678, random, apellido, 123@123.com, 2015-10-07 05:16:22, 2, 2015-10-07 05:16:22', '2015-10-07 07:16:22', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(81, 21, 'BORRO FOTO', '32, 21, cdcdcdcdcddc, cdcdcdcdcdcdcd, 2015-10-06 22:55:00', NULL, '2015-10-07 07:19:55', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(83, 11, 'EDITA USUARIO', '11, mi nick, 12345678, random, apellido, 123@123.com, 2015-10-07 05:16:22, 2, 2015-10-07 05:16:22', '11, mi nick, 12345678, random, apellido, 123@123.com, 2015-10-07 05:25:07, 2, 2015-10-07 05:25:07', '2015-10-07 07:25:07', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(84, 28, 'EDITA USUARIO', '28, chao, chaochao, chao, chao, chaochao@chao.com, 2015-10-07 05:15:37, 1, 2015-10-07 05:15:37', '28, chao, chaochao, chao, chao, chaochao@chao.com, 2015-10-07 05:25:18, 1, 2015-10-07 05:25:18', '2015-10-07 07:25:18', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(85, 28, 'SUBE_FOTO', NULL, '42, 28, ewwewe, wewweewewewewe, 2015-10-07 05:25:27', '2015-10-07 07:25:27', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(86, 25, 'EDITA USUARIO', '25, negro, , negro, negro, mumf@ord.cl, 2015-10-07 05:02:29, 0, 2015-10-07 05:02:29', '25, negro, , negro, negro, mumf@ord.cl, 2015-10-07 05:26:19, 0, 2015-10-07 05:26:19', '2015-10-07 07:26:19', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(87, 11, 'EDITA USUARIO', '11, mi nick, 12345678, random, apellido, 123@123.com, 2015-10-07 05:25:07, 2, 2015-10-07 05:25:07', '11, mi nick, 12345678, random, apellido, 123@123.com, 2015-10-07 05:26:34, 2, 2015-10-07 05:26:34', '2015-10-07 07:26:34', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(90, 21, 'BORRO FOTO', '30, 21, subiendo foto, pa ver q ondi, 2015-10-06 22:38:50', NULL, '2015-10-07 07:36:14', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(91, 27, 'EDITA USUARIO', '27, hola, holahola, hola, hola, holahola@hola.com, 2015-10-07 05:14:22, 0, 2015-10-07 05:14:22', '27, hola, holahola, hola, hola, holahola@hola.com, 2015-10-07 05:37:17, 0, 2015-10-07 05:37:17', '2015-10-07 07:37:17', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(92, 11, 'EDITA USUARIO', '11, mi nick, 12345678, random, apellido, 123@123.com, 2015-10-07 05:26:34, 2, 2015-10-07 05:26:34', '11, mi nick, 12345678, random, apellido, 123@123.com, 2015-10-07 05:37:52, 2, 2015-10-07 05:37:52', '2015-10-07 07:37:52', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(93, 27, 'EDITA USUARIO', '27, hola, holahola, hola, hola, holahola@hola.com, 2015-10-07 05:37:17, 0, 2015-10-07 05:37:17', '27, hola, , hola, hola, holahola@hola.com, 2015-10-07 05:38:02, 2, 2015-10-07 05:38:02', '2015-10-07 07:38:02', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(94, 27, 'EDITA USUARIO', '27, hola, , hola, hola, holahola@hola.com, 2015-10-07 05:38:02, 2, 2015-10-07 05:38:02', '27, banana, , hola, hola, holahola@hola.com, 2015-10-07 05:38:30, 2, 2015-10-07 05:38:30', '2015-10-07 07:38:30', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(95, 27, 'EDITA USUARIO', '27, banana, , hola, hola, holahola@hola.com, 2015-10-07 05:38:30, 2, 2015-10-07 05:38:30', '27, banana, , hola, hola, holahola@hola.com, 2015-10-07 05:38:57, 2, 2015-10-07 05:38:57', '2015-10-07 07:38:57', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(96, 25, 'EDITA USUARIO', '25, negro, , negro, negro, mumf@ord.cl, 2015-10-07 05:26:19, 0, 2015-10-07 05:26:19', '25, negro, , negro, negro, mumf@ord.cl, 2015-10-07 05:40:50, 0, 2015-10-07 05:40:50', '2015-10-07 07:40:50', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(97, 25, 'EDITA USUARIO', '25, negro, , negro, negro, mumf@ord.cl, 2015-10-07 05:40:50, 0, 2015-10-07 05:40:50', '25, negro, , negro, negro, mumf@ord.cl, 2015-10-07 05:41:51, 0, 2015-10-07 05:41:51', '2015-10-07 07:41:51', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(98, 25, 'NUEVO_GOLD', NULL, '2, 25, 2015-10-07 05:41:54', '2015-10-07 07:41:54', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(99, 25, 'EDITA USUARIO', '25, negro, , negro, negro, mumf@ord.cl, 2015-10-07 05:41:51, 0, 2015-10-07 05:41:51', '25, negro, , negro, negro, mumf@ord.cl, 2015-10-07 05:41:54, 1, 2015-10-07 05:41:54', '2015-10-07 07:41:54', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(100, 25, 'SUBE_FOTO', NULL, '43, 25, asdfdfasfadsf, sdfasfdasfsdf, 2015-10-07 05:42:04', '2015-10-07 07:42:04', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(101, 27, 'EDITA FOTO', '40, 27, foto de juego, descripcion modificiada, 2015-10-07 05:14:05', '40, 27, foto de juego, descripcion modificiada, 2015-10-07 05:14:05', '2015-10-07 07:55:22', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(102, NULL, 'AGREGA_COMENTARIO', NULL, '22, 40, hohola, 2015-10-07 05:55:22', '2015-10-07 07:55:22', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(103, 11, 'EDITA USUARIO', '11, mi nick, 12345678, random, apellido, 123@123.com, 2015-10-07 05:37:52, 2, 2015-10-07 05:37:52', '11, mi nick, 12345678, random, apellido, 123@123.com, 2015-10-07 05:55:32, 2, 2015-10-07 05:55:32', '2015-10-07 07:55:32', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(107, 17, 'USUARIO ELIMINADO', '17, aadd@aadd.com, 2015-10-06 18:37:57, 0, 2015-10-06 18:37:57', NULL, '2015-10-07 08:58:06', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(108, 18, 'USUARIO ELIMINADO', '18, quieroseradmin@asd.cl, 2015-10-06 19:48:16, 0, 2015-10-06 19:48:16', NULL, '2015-10-07 08:58:09', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(109, 19, 'USUARIO ELIMINADO', '19, sss@sss.cl, 2015-10-06 20:01:23, 0, 2015-10-06 20:01:23', NULL, '2015-10-07 08:58:11', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(110, 20, 'USUARIO ELIMINADO', '20, , , , , 123@123.cl, 2015-10-06 20:05:09, 2, 2015-10-06 20:05:09', NULL, '2015-10-07 08:58:16', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(111, 25, 'EDITA USUARIO', '25, negro, , negro, negro, mumf@ord.cl, 2015-10-07 05:41:54, 1, 2015-10-07 05:41:54', '25, negro, , negro, negro, mumf@ord.cl, 2015-10-07 06:59:14, 1, 2015-10-07 06:59:14', '2015-10-07 08:59:14', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(112, 25, 'NUEVA AMISTAD', NULL, '1, 25, 6, 2015-10-07 07:00:37', '2015-10-07 09:00:37', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(113, 25, 'NUEVA AMISTAD', NULL, '2, 25, 28, 2015-10-07 07:01:05', '2015-10-07 09:01:05', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(114, 11, 'EDITA USUARIO', '11, mi nick, 12345678, random, apellido, 123@123.com, 2015-10-07 05:55:32, 2, 2015-10-07 05:55:32', '11, mi nick, 12345678, random, apellido, 123@123.com, 2015-10-07 07:01:13, 2, 2015-10-07 07:01:13', '2015-10-07 09:01:13', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(115, 28, 'EDITA USUARIO', '28, chao, chaochao, chao, chao, chaochao@chao.com, 2015-10-07 05:25:18, 1, 2015-10-07 05:25:18', '28, Coke, , Jorge, Salas, jorges@gmail.com, 2015-10-07 07:01:48, 0, 2015-10-07 07:01:48', '2015-10-07 09:01:48', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(116, 9, 'USUARIO ELIMINADO', '9, admin, 12345678, admin, admin, admin@gmail.com, 2015-10-06 23:05:27, 0, 2015-10-06 23:05:27', NULL, '2015-10-07 09:02:02', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(117, 11, 'EDITA USUARIO', '11, mi nick, 12345678, random, apellido, 123@123.com, 2015-10-07 07:01:13, 2, 2015-10-07 07:01:13', '11, AdminPhotolog, 12345678, Administrador, Photolog, admin@photolog.com, 2015-10-07 07:03:23, 2, 2015-10-07 07:03:23', '2015-10-07 09:03:23', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(118, 21, 'EDITA USUARIO', '21, email, emailemail, email, email, email@email.cemail, 2015-10-06 20:06:41, 0, 2015-10-06 20:06:41', '21, charlie993, , Carlos, Jara, cjara@yahoo.es, 2015-10-07 07:04:11, 0, 2015-10-07 07:04:11', '2015-10-07 09:04:11', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(119, 21, 'EDITA USUARIO', '21, charlie993, , Carlos, Jara, cjara@yahoo.es, 2015-10-07 07:04:11, 0, 2015-10-07 07:04:11', '21, charlie993, carlitos993, Carlos, Jara, cjara@yahoo.es, 2015-10-07 07:04:11, 0, 2015-10-07 07:04:11', '2015-10-07 09:05:05', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(120, 6, 'EDITA USUARIO', '6, smedinas, , sergio, medina, medina159@gmail.com, 2015-10-07 05:04:41, 1, 2015-10-07 05:04:41', '6, smedinas, smedina159, sergio, medina, medina159@gmail.com, 2015-10-07 05:04:41, 1, 2015-10-07 05:04:41', '2015-10-07 09:05:16', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(121, 22, 'USUARIO ELIMINADO', '22, Nick, 12345678, nombre, apellido, 1234@1234.com, 2015-10-06 22:58:07, 2, 2015-10-06 22:58:07', NULL, '2015-10-07 09:05:41', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(124, 24, 'EDITA USUARIO', '24, chao, , chao, chao, 1chao@chao.cl, 2015-10-07 01:18:12, 1, 2015-10-07 01:18:12', '24, matisk8, matisk84ever, Matias, Illanes, sk8@hotmail.com, 2015-10-07 07:07:39, 1, 2015-10-07 07:07:39', '2015-10-07 09:07:39', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(125, 25, 'EDITA USUARIO', '25, negro, , negro, negro, mumf@ord.cl, 2015-10-07 06:59:14, 1, 2015-10-07 06:59:14', '25, holasoyivan, mumfordandsons, Ivan, Hidalgo, mumf@gmail.cl, 2015-10-07 07:08:34, 0, 2015-10-07 07:08:34', '2015-10-07 09:08:34', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(127, 26, 'BORRO FOTO', '39, 26, nueva foto de usuario nuevo, ya está amaneciendo, 2015-10-07 05:07:29', NULL, '2015-10-07 09:08:53', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(128, 26, 'USUARIO ELIMINADO', '26, nuevo, nuevonuevo, nuevo, nuevo, nuevo@nuevo.cl, 2015-10-07 05:06:13, 0, 2015-10-07 05:06:13', NULL, '2015-10-07 09:08:53', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(129, 27, 'EDITA USUARIO', '27, banana, , hola, hola, holahola@hola.com, 2015-10-07 05:38:57, 2, 2015-10-07 05:38:57', '27, bartSimpson, bartsimpson, Pablo, Echeverría, pablobart@yahoo.com, 2015-10-07 07:09:57, 0, 2015-10-07 07:09:57', '2015-10-07 09:09:57', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(131, 23, 'EDITA USUARIO', '23, hola, holahola, hola, hola, hola1@hola.cl, 2015-10-07 01:08:30, 0, 2015-10-07 01:08:30', '23, LauritaX3, lx3aravena, Laura, Aravena, lx3@outlook.com, 2015-10-07 07:10:46, 1, 2015-10-07 07:10:46', '2015-10-07 09:10:46', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(132, 6, 'EDITA FOTO', '33, 6, eeedada, eedadadda, 2015-10-06 23:35:27', '33, 6, eeedada, eedadadda, 2015-10-06 23:35:27', '2015-10-07 09:40:23', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(133, 11, 'AGREGA_COMENTARIO', NULL, '23, 33, mememe, 3, 2015-10-07 07:40:23, 11', '2015-10-07 09:40:23', '0000-00-00 00:00:00', '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `comentarios`
--

CREATE TABLE IF NOT EXISTS `comentarios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `comentario` varchar(255) DEFAULT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `puntaje` int(11) DEFAULT NULL,
  `foto_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_comentarios_on_usuario_id` (`usuario_id`),
  KEY `index_comentarios_on_foto_id` (`foto_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `comentarios`
--

INSERT INTO `comentarios` (`id`, `comentario`, `usuario_id`, `puntaje`, `foto_id`, `created_at`, `updated_at`) VALUES
(13, 'Comentando esta caga de foto', 6, 3, NULL, '2015-10-06 02:37:01', '2015-10-06 02:37:01'),
(14, 'Comentando esta caga de foto', 6, 3, NULL, '2015-10-06 02:37:19', '2015-10-06 02:37:19'),
(15, 'asdasddasdasdsa', 6, 3, NULL, '2015-10-06 02:37:30', '2015-10-06 02:37:30'),
(18, 'wwasassa', 21, 1, 21, '2015-10-06 22:39:03', '2015-10-06 22:39:03'),
(19, 'buena foto', 24, 2, 36, '2015-10-07 01:17:48', '2015-10-07 01:17:48'),
(20, 'eee2e2', 25, 0, 22, '2015-10-07 03:41:13', '2015-10-07 03:41:13'),
(21, 'estoy comentando', 28, 3, 40, '2015-10-07 05:15:26', '2015-10-07 05:15:26'),
(22, 'hohola', NULL, NULL, 40, '2015-10-07 05:55:22', '2015-10-07 05:55:22'),
(23, 'mememe', 11, 3, 33, '2015-10-07 07:40:23', '2015-10-07 07:40:23');

--
-- Disparadores `comentarios`
--
DROP TRIGGER IF EXISTS `agregarComentario`;
DELIMITER //
CREATE TRIGGER `agregarComentario` AFTER INSERT ON `comentarios`
 FOR EACH ROW INSERT INTO auditoria(ACCION,usuario_id,NEW,TS)
    VALUES('AGREGA_COMENTARIO',new.usuario_id,CONCAT_WS( ', ', new.id, new.foto_id, new.comentario, new.puntaje, new.created_at, new.usuario_id ),now())
//
DELIMITER ;
DROP TRIGGER IF EXISTS `agregarPuntajeALaFoto`;
DELIMITER //
CREATE TRIGGER `agregarPuntajeALaFoto` BEFORE INSERT ON `comentarios`
 FOR EACH ROW update fotos
    set fotos.puntaje=fotos.puntaje+new.puntaje WHERE fotos.id = new.foto_id
//
DELIMITER ;
DROP TRIGGER IF EXISTS `borrarComentario`;
DELIMITER //
CREATE TRIGGER `borrarComentario` BEFORE DELETE ON `comentarios`
 FOR EACH ROW INSERT INTO auditoria(ACCION,usuario_id,OLD,TS)
    VALUES('BORRA COMENTARIO',old.usuario_id,CONCAT_WS( ', ', old.id, old.foto_id, old.comentario, old.puntaje, old.created_at, old.usuario_id ),now())
//
DELIMITER ;
DROP TRIGGER IF EXISTS `borrarPuntajeFoto`;
DELIMITER //
CREATE TRIGGER `borrarPuntajeFoto` AFTER DELETE ON `comentarios`
 FOR EACH ROW update fotos
    set fotos.puntaje=fotos.puntaje-old.puntaje WHERE fotos.foto_id = old.foto_id
//
DELIMITER ;
DROP TRIGGER IF EXISTS `editaComentario`;
DELIMITER //
CREATE TRIGGER `editaComentario` AFTER UPDATE ON `comentarios`
 FOR EACH ROW INSERT INTO auditoria(ACCION,usuario_id,OLD,NEW,TS)
    VALUES('EDITA COMENTARIO',old.usuario_id,CONCAT_WS( ', ', old.id, old.foto_id, old.comentario, old.puntaje, old.updated_at, old.usuario_id ),CONCAT_WS( ', ', new.id, new.foto_id, new.comentario, new.puntaje, new.updated_at, new.usuario_id ),now())
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `fotos`
--

CREATE TABLE IF NOT EXISTS `fotos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `titulo` varchar(255) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `puntaje` int(11) DEFAULT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `imagen_file_name` varchar(255) DEFAULT NULL,
  `imagen_content_type` varchar(255) DEFAULT NULL,
  `imagen_file_size` int(11) DEFAULT NULL,
  `imagen_updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `fotos`
--

INSERT INTO `fotos` (`id`, `titulo`, `descripcion`, `puntaje`, `usuario_id`, `created_at`, `updated_at`, `imagen_file_name`, `imagen_content_type`, `imagen_file_size`, `imagen_updated_at`) VALUES
(21, 'probando foto', 'probando', NULL, 6, '2015-10-06 03:56:56', '2015-10-06 03:56:56', 'Captura_de_pantalla_de_2015-10-05_18_16_51.png', 'image/png', 165075, '2015-10-06 03:56:56'),
(22, 'nueva foto', 'una nueva foto', NULL, 6, '2015-10-05 23:45:32', '2015-10-05 23:45:32', 'botonranking.png', 'image/png', 4192, '2015-10-05 23:45:27'),
(31, 'otra foto', 'pa ver q sucede', NULL, 21, '2015-10-06 22:41:55', '2015-10-06 22:41:55', 'cmd.png', 'image/png', 10970, '2015-10-06 22:41:54'),
(33, 'eeedada', 'eedadadda', NULL, 6, '2015-10-06 23:35:27', '2015-10-06 23:35:27', 'baquedano.jpg', 'image/jpeg', 30243, '2015-10-06 23:35:24'),
(35, 'tgtgttg we erg', 'fef ef ef sef e ', NULL, 6, '2015-10-06 23:35:43', '2015-10-06 23:35:43', 'tobalaba.jpg', 'image/jpeg', 140847, '2015-10-06 23:35:41'),
(36, 'subiendo foto al usuario hola', 'nueva descripcion', NULL, 23, '2015-10-07 00:49:42', '2015-10-07 01:13:57', 'nombre.png', 'image/png', 11134, '2015-10-07 00:49:40'),
(40, 'foto de juego', 'descripcion modificiada', NULL, 27, '2015-10-07 05:09:22', '2015-10-07 05:14:05', 'jugar.png', 'image/png', 166102, '2015-10-07 05:09:21'),
(41, 'foto nueva de chao', 'chao tiene foto nueva', NULL, 28, '2015-10-07 05:15:05', '2015-10-07 05:15:05', 'cmd.png', 'image/png', 10970, '2015-10-07 05:15:04'),
(42, 'ewwewe', 'wewweewewewewe', NULL, 28, '2015-10-07 05:25:27', '2015-10-07 05:25:27', 'baquedano.jpg', 'image/jpeg', 30243, '2015-10-07 05:25:26'),
(43, 'asdfdfasfadsf', 'sdfasfdasfsdf', NULL, 25, '2015-10-07 05:42:04', '2015-10-07 05:42:04', 'botonranking.png', 'image/png', 4192, '2015-10-07 05:42:03');

--
-- Disparadores `fotos`
--
DROP TRIGGER IF EXISTS `borrarFoto`;
DELIMITER //
CREATE TRIGGER `borrarFoto` AFTER DELETE ON `fotos`
 FOR EACH ROW insert into auditoria(ACCION,usuario_id,OLD,TS)
    values('BORRO FOTO',old.usuario_id,CONCAT_WS( ', ', old.id, old.usuario_id, old.titulo, old.descripcion, old.puntaje, old.created_at),now())
//
DELIMITER ;
DROP TRIGGER IF EXISTS `editarFOTO`;
DELIMITER //
CREATE TRIGGER `editarFOTO` AFTER UPDATE ON `fotos`
 FOR EACH ROW INSERT INTO auditoria(ACCION,usuario_id,OLD,NEW,TS)
    VALUES('EDITA FOTO',old.usuario_id,CONCAT_WS( ', ', old.id, old.usuario_id, old.titulo, old.descripcion, old.puntaje, old.updated_at),CONCAT_WS( ', ', new.id, new.usuario_id, new.titulo, new.descripcion, new.puntaje, new.updated_at),now())
//
DELIMITER ;
DROP TRIGGER IF EXISTS `sube Foto`;
DELIMITER //
CREATE TRIGGER `sube Foto` AFTER INSERT ON `fotos`
 FOR EACH ROW insert into auditoria(ACCION,usuario_id,NEW,TS)
    VALUES('SUBE_FOTO',new.usuario_id,CONCAT_WS( ', ', new.id, new.usuario_id, new.titulo, new.descripcion, new.puntaje, new.created_at),now())
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `golds`
--

CREATE TABLE IF NOT EXISTS `golds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario_id` int(11) DEFAULT NULL,
  `es_gold` int(11) DEFAULT NULL,
  `vencimiento` date DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_golds_on_usuario_id` (`usuario_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `golds`
--

INSERT INTO `golds` (`id`, `usuario_id`, `es_gold`, `vencimiento`, `created_at`, `updated_at`) VALUES
(1, 28, NULL, NULL, '2015-10-07 05:15:37', '2015-10-07 05:15:37'),
(2, 25, NULL, NULL, '2015-10-07 05:41:54', '2015-10-07 05:41:54');

--
-- Disparadores `golds`
--
DROP TRIGGER IF EXISTS `goldVencido`;
DELIMITER //
CREATE TRIGGER `goldVencido` BEFORE DELETE ON `golds`
 FOR EACH ROW insert into auditoria(ACCION,usuario_id,OLD,TS)
		VALUES('GOLD_TERMINADO',old.usuario_id,CONCAT_WS( ', ', old.id, old.usuario_id, old.es_gold, old.vencimiento,old.created_at),now())
//
DELIMITER ;
DROP TRIGGER IF EXISTS `nuevoGold`;
DELIMITER //
CREATE TRIGGER `nuevoGold` AFTER INSERT ON `golds`
 FOR EACH ROW insert into auditoria(ACCION,usuario_id,NEW,TS)
		VALUES('NUEVO_GOLD',new.usuario_id,CONCAT_WS( ', ', new.id, new.usuario_id, new.es_gold, new.vencimiento,new.created_at),now())
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `schema_migrations`
--

CREATE TABLE IF NOT EXISTS `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `schema_migrations`
--

INSERT INTO `schema_migrations` (`version`) VALUES
('20151005230352'),
('20151005230407'),
('20151005230640'),
('20151005230710'),
('20151005230952'),
('20151005231015'),
('20151006000436'),
('20151006004615'),
('20151006020010'),
('20151006020307'),
('20151006202344');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE IF NOT EXISTS `usuarios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tipo_usuario` int(11) DEFAULT '0',
  `nick` varchar(255) DEFAULT NULL,
  `nombre` varchar(255) DEFAULT NULL,
  `apellido` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `contrasena` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `encrypted_password` varchar(255) NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) NOT NULL DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) DEFAULT NULL,
  `last_sign_in_ip` varchar(255) DEFAULT NULL,
  `f_restantes` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_usuarios_on_reset_password_token` (`reset_password_token`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `tipo_usuario`, `nick`, `nombre`, `apellido`, `email`, `contrasena`, `created_at`, `updated_at`, `encrypted_password`, `reset_password_token`, `reset_password_sent_at`, `remember_created_at`, `sign_in_count`, `current_sign_in_at`, `last_sign_in_at`, `current_sign_in_ip`, `last_sign_in_ip`, `f_restantes`) VALUES
(6, 1, 'smedinas', 'sergio', 'medina', 'medina159@gmail.com', 'smedina159', '2015-10-06 01:10:42', '2015-10-07 05:04:41', '$2a$10$QRXKnlFfzQIkIYocBOxon.D5NSrp9Rx/4JbcobZL7W7CFnMS0TyVe', NULL, NULL, NULL, 13, '2015-10-07 05:04:41', '2015-10-06 23:35:15', '::1', '::1', 0),
(11, 2, 'AdminPhotolog', 'Administrador', 'Photolog', 'admin@photolog.com', '12345678', '2015-10-06 03:59:11', '2015-10-07 07:03:23', '$2a$10$NzlGwgtx.tPCzsLEF7DGWuyeo8q5ntSScSUXWp5AwQshHUAYmvDiy', NULL, NULL, NULL, 14, '2015-10-07 07:01:13', '2015-10-07 05:55:32', '::1', '::1', 0),
(21, 0, 'charlie993', 'Carlos', 'Jara', 'cjara@yahoo.es', 'carlitos993', '2015-10-06 20:06:22', '2015-10-07 07:04:11', '$2a$10$KNSF3P.NiDHB4xN5ggMRNO7c/HAop/l5xq8/Ub5KWk/Z2mWLoj9Ze', NULL, NULL, NULL, 1, '2015-10-06 20:06:22', '2015-10-06 20:06:22', '::1', '::1', 0),
(23, 1, 'LauritaX3', 'Laura', 'Aravena', 'lx3@outlook.com', 'lx3aravena', '2015-10-07 00:36:31', '2015-10-07 07:10:46', '$2a$10$x7yG06Dzbhr4DIPEAojEoeT9mAS3GPK7RIo3maGcDKQHpgoUg/QPm', NULL, NULL, NULL, 2, '2015-10-07 01:08:30', '2015-10-07 00:36:31', '::1', '::1', 0),
(24, 1, 'matisk8', 'Matias', 'Illanes', 'sk8@hotmail.com', 'matisk84ever', '2015-10-07 01:15:29', '2015-10-07 07:07:39', '$2a$10$zTdTYApnN7r6CitZlN9FtOuoa/.blsu9AQoVKnnCGP7WrsqAybIee', NULL, NULL, NULL, 1, '2015-10-07 01:15:29', '2015-10-07 01:15:29', '::1', '::1', 0),
(25, 0, 'holasoyivan', 'Ivan', 'Hidalgo', 'mumf@gmail.cl', 'mumfordandsons', '2015-10-07 03:23:46', '2015-10-07 07:08:34', '$2a$10$GrHC06C3GQg5NUYhWLo/1u4mHp1qA3wbxYP56DuQZ.RzCHhqKRYh.', NULL, NULL, NULL, 7, '2015-10-07 06:59:14', '2015-10-07 05:41:51', '::1', '::1', 0),
(27, 0, 'bartSimpson', 'Pablo', 'Echeverría', 'pablobart@yahoo.com', 'bartsimpson', '2015-10-07 05:08:38', '2015-10-07 07:09:57', '$2a$10$QZiAWMwBXfrDR/nM9HidCe3ojV5UaIZENmRIRrAJtu9K5.1/7ANEa', NULL, NULL, NULL, 4, '2015-10-07 05:38:57', '2015-10-07 05:37:17', '::1', '::1', 0),
(28, 0, 'Coke', 'Jorge', 'Salas', 'jorges@gmail.com', '', '2015-10-07 05:14:32', '2015-10-07 07:01:48', '$2a$10$ujUgnNCKMgT94B95itsp.e92s/om6XYf9fYH2ffiZad6lZUnn2V7.', NULL, NULL, NULL, 2, '2015-10-07 05:25:18', '2015-10-07 05:14:32', '::1', '::1', 0);

--
-- Disparadores `usuarios`
--
DROP TRIGGER IF EXISTS `editaUsuario`;
DELIMITER //
CREATE TRIGGER `editaUsuario` AFTER UPDATE ON `usuarios`
 FOR EACH ROW INSERT INTO auditoria(ACCION,usuario_id,OLD,NEW,TS)
    VALUES('EDITA USUARIO',old.id,CONCAT_WS( ', ', old.id, old.nick, old.contrasena, old.nombre, old.apellido, old.email, old.updated_at, old.tipo_usuario, old.updated_at ),CONCAT_WS( ', ', new.id, new.nick, new.contrasena, new.nombre, new.apellido, new.email, new.updated_at,  new.tipo_usuario, new.updated_at ),now())
//
DELIMITER ;
DROP TRIGGER IF EXISTS `nuevoUsuario`;
DELIMITER //
CREATE TRIGGER `nuevoUsuario` AFTER INSERT ON `usuarios`
 FOR EACH ROW insert into auditoria(ACCION,usuario_id,NEW,TS)
    VALUEs('NUEVO USUARIO',new.id,CONCAT_WS( ', ', new.id, new.nick, new.contrasena, new.nombre, new.apellido, new.email, new.created_at, new.tipo_usuario, new.created_at ),now())
//
DELIMITER ;
DROP TRIGGER IF EXISTS `usuarioEliminado`;
DELIMITER //
CREATE TRIGGER `usuarioEliminado` BEFORE DELETE ON `usuarios`
 FOR EACH ROW insert into auditoria(ACCION,usuario_id,OLD,TS)
    VALUEs('USUARIO ELIMINADO',old.id,CONCAT_WS( ', ', old.id, old.NICK, old.contrasena, old.nombre, old.apellido, old.email, old.updated_at, old.tipo_usuario, old.updated_at ),now())
//
DELIMITER ;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `amigos`
--
ALTER TABLE `amigos`
  ADD CONSTRAINT `fk_rails_5f50b2abb9` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `comentarios`
--
ALTER TABLE `comentarios`
  ADD CONSTRAINT `fk_rails_0ceedb79ec` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `fk_rails_c3323fe6a6` FOREIGN KEY (`foto_id`) REFERENCES `fotos` (`id`);

--
-- Filtros para la tabla `golds`
--
ALTER TABLE `golds`
  ADD CONSTRAINT `fk_rails_f2e9d68c96` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
