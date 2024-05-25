USE films;

-- PRÈVIA TRIGGERS
CREATE TABLE LOG_STAFF (
    id INT PRIMARY KEY AUTO_INCREMENT,
    action ENUM ('update', 'deleted'),
    staff_id INT,
    date_time DATETIME,
    email_changed BOOLEAN
    -- FOREIGN KEY (staff_id) REFERENCES STAFF(staff_id)
    -- DA ERROR EN EL DE BORRAR.
);

ALTER TABLE CUSTOMER ADD warnings TINYINT;


-- TRIGGERS 1

-- 1. Quan afegim un nou membre a la taula staff, cal que encriptem la seva contrassenya fent servir la funció sha1()
-- i que afegim la data actual a la columna last_update.

DROP TRIGGER IF EXISTS staff_add;

DELIMITER //
CREATE TRIGGER staff_add
    BEFORE INSERT ON films.STAFF
    FOR EACH ROW
BEGIN
    SET NEW.password = SHA1(NEW.password);
    SET NEW.last_update = CURDATE();
END; //
DELIMITER ;

-- TEST
DELETE FROM STAFF WHERE STAFF.staff_id = 3;

INSERT INTO `staff` VALUES (3,'Paco','Fernandez',3,NULL,'paco.fernandez@sakilastaff.com',1,1,'Paco','123', NULL);

SELECT STAFF.password, STAFF.last_update
FROM STAFF
WHERE STAFF.staff_id = 3;


-- 2. Si us fixeu, el nom i el cognom dels autors està desat en majúscules. Per tant, volem que cada vegada que
-- s'afegeix o es modifica un registre de la taula actor, ens assegurem que aquests dos camps estan escrits completament
-- en majúscula. Tanmateix ens hem d'assegurar que s'eliminin possibles espais davant o darrera del nom i del cognom.

DROP TRIGGER IF EXISTS actor_add;
DROP TRIGGER IF EXISTS actor_update;

DELIMITER //
CREATE TRIGGER actor_add
    BEFORE INSERT ON films.ACTOR
    FOR EACH ROW
BEGIN
    SET NEW.first_name = UPPER(TRIM(NEW.first_name));
    SET NEW.last_name = UPPER(TRIM(NEW.last_name));
END; //
DELIMITER ;

DELIMITER //
CREATE TRIGGER actor_update
    BEFORE UPDATE ON films.ACTOR
    FOR EACH ROW
BEGIN
    SET NEW.first_name = UPPER(TRIM(NEW.first_name));
    SET NEW.last_name = UPPER(TRIM(NEW.last_name));
END; //
DELIMITER ;

-- TEST
DELETE FROM ACTOR WHERE ACTOR.actor_id = 201;

INSERT INTO ACTOR VALUES (201, ' francisco', 'ferNandez  ', CURDATE());

SELECT ACTOR.first_name, ACTOR.last_name
FROM ACTOR
WHERE ACTOR.actor_id = 201;

UPDATE ACTOR
    SET ACTOR.first_name = ' francis ', ACTOR.last_name = ' fDez '
    WHERE ACTOR.actor_id = 201;


-- 3. Quan es faci una actualització a la taula rental que modifiqui la data de retorn de la pel·lícula, cal verificar
-- que aquesta sigui posterior a la data de lloguer. En cas contrari, establir la data de retorn 3 dies després de la
-- data de lloguer.

DROP TRIGGER IF EXISTS rental_update;

DELIMITER //
CREATE TRIGGER rental_update
    BEFORE UPDATE ON films.RENTAL
    FOR EACH ROW
BEGIN
    IF NEW.return_date <> OLD.return_date THEN
        IF NEW.return_date < NEW.rental_date THEN
            SET NEW.return_date = NEW.rental_date + INTERVAL 3 DAY;
        END IF;
    END IF;
END; //
DELIMITER ;

-- TEST
DELETE FROM RENTAL WHERE RENTAL.rental_id = 17000;

INSERT INTO RENTAL VALUES (17000, '2005-05-12', 1, 1, NULL, 1, NOW());

UPDATE RENTAL SET return_date = '2005-05-17' WHERE RENTAL.rental_id = 17000;
UPDATE RENTAL SET return_date = '2005-05-10' WHERE RENTAL.rental_id = 17000;

SELECT RENTAL.return_date
FROM RENTAL
WHERE RENTAL.rental_id = 17000;


-- TRIGGERS 2

-- 1. Cada vegada que es realitzi una modificació a la taula staff, s'haurà d'actualitzar la columna last_update.

DROP TRIGGER IF EXISTS staff_update;

DELIMITER //
CREATE TRIGGER staff_update
    BEFORE UPDATE ON films.STAFF
    FOR EACH ROW
BEGIN
    SET NEW.last_update = CURDATE();
END; //
DELIMITER ;

-- TEST
UPDATE STAFF SET STAFF.first_name = 'Paco' WHERE STAFF.staff_id = 1;

SELECT STAFF.last_update
FROM STAFF
WHERE STAFF.staff_id = 1;

-- 2. Cada vegada que es realitzi un update o un delete sobre la taula staff s'haurà d'afegir un nou registre a la
-- taula log_staff indicant l’acció realitzada, sobre quin empleat s’ha realitzat (la seva id), en quin moment (data i
-- hora actuals) i si s'ha modificat l'e-mail.

DROP TRIGGER IF EXISTS staff_update2;
DROP TRIGGER IF EXISTS staff_delete;

DELIMITER //
CREATE TRIGGER staff_update2
    BEFORE UPDATE ON films.STAFF
    FOR EACH ROW
BEGIN
    DECLARE mail_changed BOOLEAN;
    SET mail_changed = IF(NEW.email = OLD.email, FALSE, TRUE);
    INSERT INTO LOG_STAFF (action, staff_id, date_time, email_changed) VALUES ('update', NEW.staff_id, NOW(), mail_changed);
END; //
DELIMITER ;

DELIMITER //
CREATE TRIGGER staff_delete
    BEFORE DELETE ON films.STAFF
    FOR EACH ROW
BEGIN
    INSERT INTO LOG_STAFF (action, staff_id, date_time, email_changed) VALUES ('deleted', OLD.staff_id, NOW(), FALSE);
END; //
DELIMITER ;

-- TEST
INSERT INTO STAFF VALUES (5, 'FRANCISCO', 'FERNANDEZ', 1, NULL, 'francisco@gmail.com', 1, 0, 'francisco', '123', CURDATE());

UPDATE STAFF SET STAFF.first_name = 'Paco' WHERE STAFF.staff_id = 5;
UPDATE STAFF SET STAFF.email = 'paco@gmail.com' WHERE STAFF.staff_id = 5;

DELETE FROM STAFF WHERE STAFF.staff_id = 5;

SELECT *
FROM LOG_STAFF;


-- 3. Quan es faci una actualització a la taula rental perquè es produeix el retorn d'una pel·lícula, verificar si ha
-- passat més d'una setmana. En cas afirmatiu cal afegir un avís a la columna "warnings" de la taula customer. Si
-- l'usuari arriba a 3 avisos, es procedirà a desactivar-lo.

DROP TRIGGER IF EXISTS rental_update2;

DELIMITER //
CREATE TRIGGER rental_update2
    BEFORE UPDATE ON films.RENTAL
    FOR EACH ROW
BEGIN
    DECLARE cus_id INT;
    SET cus_id = NEW.customer_id;
    IF (NEW.return_date - NEW.rental_date) > 7 THEN
        UPDATE CUSTOMER
        SET CUSTOMER.warnings = CUSTOMER.warnings + 1
        WHERE CUSTOMER.customer_id = cus_id;
        IF 3 <= (SELECT CUSTOMER.warnings
                 FROM CUSTOMER
                 WHERE CUSTOMER.customer_id = cus_id) THEN
            UPDATE CUSTOMER
                SET CUSTOMER.active = 0
                WHERE CUSTOMER.customer_id = cus_id;
        END IF;
    END IF;
END; //
DELIMITER ;

-- TEST
UPDATE CUSTOMER SET CUSTOMER.warnings = 0;
DELETE FROM RENTAL WHERE RENTAL.rental_id = 17000;
UPDATE CUSTOMER SET CUSTOMER.active = 1 WHERE CUSTOMER.customer_id = 1;

INSERT INTO RENTAL VALUES (17000, '2005-05-12', 1, 1, NULL, 1, NOW());
UPDATE RENTAL SET return_date = '2005-05-30' WHERE RENTAL.rental_id = 17000;

SELECT CUSTOMER.first_name, CUSTOMER.active, CUSTOMER.warnings
FROM CUSTOMER
WHERE CUSTOMER.customer_id = 1;


-- PROCEDURES

-- 1. Procediment que rep dues dates i ens mostra els ingressos totals entre les dues dates indicades.

DROP PROCEDURE IF EXISTS ingresos_entre;

DELIMITER //
CREATE PROCEDURE ingresos_entre(IN data_inici DATE, IN data_fi DATE, OUT ingresos DOUBLE)
BEGIN
    SET ingresos = (SELECT SUM(PAYMENT.amount)
                        FROM PAYMENT
                        WHERE PAYMENT.payment_date BETWEEN data_inici AND data_fi);
END; //
DELIMITER ;

-- TEST
CALL ingresos_entre('2005-05-12', '2006-05-12', @ingresos);
SELECT @ingresos;


-- 2. Procediment que rep el nom d'una categoria de pel·lícula per paràmetre i retorna en un altre paràmetre el càlcul
-- dels ingressos per aquella categoria.

DROP PROCEDURE IF EXISTS ingresos_categoria;

DELIMITER //
CREATE PROCEDURE ingresos_categoria(IN categoria VARCHAR(50), OUT ingresos DOUBLE)
BEGIN
    SET ingresos = (SELECT SUM(PAYMENT.amount)
                    FROM PAYMENT
                    INNER JOIN RENTAL ON PAYMENT.rental_id = RENTAL.rental_id
                    INNER JOIN INVENTORY ON RENTAL.inventory_id = INVENTORY.inventory_id
                    INNER JOIN FILM ON INVENTORY.film_id = FILM.film_id
                    INNER JOIN FILM_CATEGORY ON FILM.film_id = FILM_CATEGORY.film_id
                    INNER JOIN CATEGORY ON FILM_CATEGORY.category_id = CATEGORY.category_id
                    WHERE CATEGORY.name = categoria);
END; //
DELIMITER ;

-- TEST
CALL ingresos_categoria('action', @ingresos);
SELECT @ingresos;


-- 3. Procediment que comprova la disponibilitat d'una pel·lícula a una botiga concreta en funció de la seva id. Li
-- passarem tant la id de la botiga com la id de la pel·lícula. Si hi ha alguna còpia de la pel·lícula a l'inventari,
-- retorna un missatge indicant que està disponible per a llogar (o que no està disponible, en cas contrari).

DROP PROCEDURE IF EXISTS comprova_disponibilitat;

DELIMITER //
CREATE PROCEDURE comprova_disponibilitat(IN id_botiga INT, IN id_pelicula INT, OUT missatge VARCHAR(50))
BEGIN
        IF EXISTS(
            SELECT INVENTORY.film_id, INVENTORY.store_id
            FROM INVENTORY
            WHERE INVENTORY.film_id = id_pelicula AND INVENTORY.store_id = id_botiga
        ) THEN
            SET missatge = 'Està disponible per a llogar';
        ELSE
            SET missatge = 'No està disponible per a llogar';
        END IF;
END; //
DELIMITER ;

-- TEST
CALL comprova_disponibilitat(1,1, @missatge);
CALL comprova_disponibilitat(1,2, @missatge);
SELECT @missatge;


-- 4. Procediment per esborrar clients inactius. Si un client ha estat inactiu durant un determinat nº de dies, que
-- passarem per paràmetre, procedirem a esborrar-lo de la base de dades. Validarem, al mateix procedure, si s'ha
-- esborrat algun registre, de manera que mostrarem el missatge "S'han esborrat X clients" (on X és el nº de clients
-- eliminats) o "No s'ha esborrat cap client per inactivitat).

DROP PROCEDURE IF EXISTS esborrar_clients_inactius;

DELIMITER //
CREATE PROCEDURE esborrar_clients_inactius(IN dies INT, OUT missatge VARCHAR(50))
BEGIN
    DECLARE num_inactius INT;

    SET num_inactius = (SELECT COUNT(CUSTOMER.customer_id)
                        FROM CUSTOMER
                        WHERE CUSTOMER.active = FALSE
                        AND DATEDIFF(CURDATE(), CUSTOMER.last_update) >= dies);
    IF num_inactius = 0 THEN
        SET missatge = 'No s''ha esborrat cap client per inactivitat';
    ELSE
        DELETE FROM CUSTOMER
                WHERE CUSTOMER.active = FALSE
                AND DATEDIFF(CURDATE(), CUSTOMER.last_update) >= dies;
        SET missatge = CONCAT('S''han esborrat ', num_inactius, ' clients');
    END IF;
END; //
DELIMITER ;

-- TEST
CALL esborrar_clients_inactius(99999, @missatge);
SELECT @missatge;

SET foreign_key_checks = 0;
CALL esborrar_clients_inactius(9, @missatge);