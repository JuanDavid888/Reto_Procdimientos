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