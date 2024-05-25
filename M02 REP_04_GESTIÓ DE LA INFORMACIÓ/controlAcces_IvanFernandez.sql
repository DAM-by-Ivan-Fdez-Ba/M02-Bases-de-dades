USE films;

-- 1. Crea una vista per mostrar la informació més rellevant de les pel·lícules. Concretament volem el títol, la durada,
-- la classificació per edats, l'idioma original i l'idioma en què està doblada aquella còpia de la pel·lícula.

CREATE FUNCTION languageName(id INT) RETURNS VARCHAR(50) DETERMINISTIC
BEGIN
    DECLARE name VARCHAR(50);
    SELECT LANGUAGE.name INTO name
    FROM LANGUAGE
    WHERE LANGUAGE.language_id = id;
    RETURN name;
END;

CREATE VIEW informacioFilms AS
    SELECT FILM.title,
           FILM.length,
           FILM.rating,
           languageName(FILM.original_language_id) AS 'original_language',
           languageName(FILM.language_id) AS 'language'
    FROM FILM;

SELECT *
FROM informacioFilms;

-- 2. Crea una vista per consultar fàcilment la informació dels lloguers. Concretament volem incloure el títol de la
-- pel·lícula, nom i cognoms del client que l'ha llogat, data de lloguer i data de retorn, nom de la botiga on s'ha
-- llogat i ciutat. Cal incloure només els clients actius.

CREATE VIEW informacioRental AS
    SELECT FILM.title, CUSTOMER.first_name, CUSTOMER.last_name, RENTAL.rental_date, RENTAL.return_date, CUSTOMER.store_id, CITY.city
    FROM FILM
    INNER JOIN INVENTORY ON FILM.film_id = INVENTORY.film_id
    INNER JOIN RENTAL ON INVENTORY.inventory_id = RENTAL.inventory_id
    INNER JOIN STORE ON INVENTORY.store_id = STORE.store_id
    INNER JOIN CUSTOMER ON RENTAL.customer_id = CUSTOMER.customer_id
    INNER JOIN ADDRESS ON STORE.address_id = ADDRESS.address_id
    INNER JOIN CITY ON ADDRESS.city_id = CITY.city_id;

SELECT *
FROM informacioRental;

-- 3. Per tal de protegir més fàcilment les dades, crearem dues vistes amb la informació no sensible tant d'empleats
-- com de clients. Per als clients mostarem només nom, inicial del cognom, e-mail i si està actiu o no. Per als empleats
-- (staff) mostrarem la id, el nom d'usuari, e-mail, password i si estan actius o no.

CREATE FUNCTION customer_last_name_first_letter(id INT) RETURNS VARCHAR(1) DETERMINISTIC
BEGIN
    DECLARE last_name_first_letter VARCHAR(1);
    SELECT LEFT(CUSTOMER.last_name, 1) INTO last_name_first_letter
    FROM CUSTOMER
    WHERE CUSTOMER.customer_id = id;
    RETURN last_name_first_letter;
END;

CREATE VIEW informacioClients AS
    SELECT CUSTOMER.first_name, customer_last_name_first_letter(CUSTOMER.customer_id) AS last_name_first_letter, CUSTOMER.email, CUSTOMER.active
    FROM CUSTOMER;

SELECT *
FROM informacioClients;

CREATE VIEW informacioStaff AS
    SELECT STAFF.staff_id, STAFF.username, STAFF.email, STAFF.password, STAFF.active
    FROM STAFF;

SELECT *
FROM informacioStaff;


-- Control d'accés
USE films;

-- PUNT 1
CREATE ROLE 'administrador';

GRANT UPDATE (first_name, last_name, email, active)
ON films.CUSTOMER
TO 'administrador';

GRANT INSERT
ON films.CUSTOMER
TO 'administrador';

-- PUNT 2
GRANT UPDATE
ON films.STAFF
TO 'administrador';

-- PUNT 3
CREATE ROLE 'desenvolupador';

GRANT CREATE, SELECT, UPDATE, DELETE
ON films
TO 'desenvolupador';

GRANT CREATE ROUTINE, ALTER ROUTINE
ON films.*
TO 'desenvolupador';

-- PUNT 4
CREATE ROLE 'practiques';

GRANT SELECT
    ON films.*
    TO 'practiques';

GRANT UPDATE, DELETE
ON films.ACTOR
TO 'practiques';

GRANT UPDATE, DELETE
    ON films.FILM
    TO 'practiques';

GRANT UPDATE, DELETE
    ON films.FILM_ACTOR
    TO 'practiques';

GRANT UPDATE, DELETE
    ON films.INVENTORY
    TO 'practiques';

GRANT UPDATE, DELETE
    ON films.RENTAL
    TO 'practiques';

-- PUNT 5

GRANT SELECT
    ON films.*
    TO 'administrador';