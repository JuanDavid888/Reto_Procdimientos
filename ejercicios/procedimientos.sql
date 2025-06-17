-- Active: 1749726759608@@127.0.0.1@3307@reto1
 
 -- 1
DELIMITER $$

DROP PROCEDURE IF EXISTS ps_nuevo_cliente $$

CREATE PROCEDURE ps_nuevo_cliente(
    IN c_nombre VARCHAR(100),
    IN c_apellido1 VARCHAR(100),
    IN c_apellido2 VARCHAR(100),
    IN c_ciudad VARCHAR(100),
    IN c_categoria INT
)
BEGIN
    DECLARE c_cliente_id INT;

    IF EXISTS (
        SELECT * FROM cliente
        WHERE nombre = c_nombre AND
        apellido1 = c_apellido1 AND
        apellido2 = c_apellido2) THEN
        SIGNAL SQLSTATE '40001'
            SET MESSAGE_TEXT = 'El cliente ya existe en la base de datos';
    END IF;

    INSERT INTO cliente(nombre, apellido1, apellido2, ciudad, categoria)
    VALUES(c_nombre, c_apellido1, c_apellido2, c_ciudad, c_categoria);
    SET c_cliente_id = LAST_INSERT_ID();

    SELECT * FROM cliente WHERE id = c_cliente_id;

END $$

DELIMITER ;

CALL ps_nuevo_cliente('Pedro', 'Jaimes', 'Gonzales', 'Bucaramanga', 100);

-- 2
DELIMITER $$

DROP PROCEDURE IF EXISTS ps_actualizar_comision $$

CREATE PROCEDURE ps_actualizar_comision(
    IN c_comercial_id INT,
    IN c_comision FLOAT
)
BEGIN

    IF c_comision <= 0 THEN
        SIGNAL SQLSTATE '40001'
            SET MESSAGE_TEXT = 'La comision debe ser mayor a 0';
    END IF;

    UPDATE comercial SET comision = c_comision
    WHERE id = c_comercial_id;

    SELECT * FROM comercial WHERE id = c_comercial_id;

END $$

DELIMITER ;

CALL ps_actualizar_comision(1, 1.20);

-- 3
DELIMITER $$

DROP PROCEDURE IF EXISTS ps_eliminar_pedidos $$

CREATE PROCEDURE ps_eliminar_pedidos(
    IN c_cliente_id INT
)
BEGIN

    IF NOT EXISTS (SELECT 1 FROM cliente WHERE id = c_cliente_id) THEN
        SIGNAL SQLSTATE '40002'
            SET MESSAGE_TEXT = 'El cliente seleccionado no existe';
    END IF;

    DELETE FROM pedido WHERE id_cliente = c_cliente_id;

END $$

DELIMITER ;

CALL ps_eliminar_pedidos(1);

-- 4
DELIMITER $$

DROP PROCEDURE IF EXISTS ps_nuevo_pedido $$

CREATE PROCEDURE ps_nuevo_pedido(
    IN p_total DOUBLE,
    IN p_cliente_id INT,
    IN p_comercial_id INT
)
BEGIN
    DECLARE p_pedido_id INT;

    IF p_total <= 0 THEN
        SIGNAL SQLSTATE '40001'
            SET MESSAGE_TEXT = 'El total debe ser mayor a 0';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM cliente WHERE id = p_cliente_id) THEN
        SIGNAL SQLSTATE '40002'
            SET MESSAGE_TEXT = 'El cliente seleccionado no existe';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM comercial WHERE id = p_comercial_id) THEN
        SIGNAL SQLSTATE '40002'
            SET MESSAGE_TEXT = 'El comercial seleccionado no existe';
    END IF;

    INSERT INTO pedido(total, fecha, id_cliente, id_comercial)
    VALUES(p_total, NOW(), p_cliente_id, p_comercial_id);
    SET p_pedido_id = LAST_INSERT_ID();

    SELECT * FROM pedido WHERE id = p_pedido_id;

END $$

DELIMITER ;

CALL ps_nuevo_pedido(70000, 11, 3);