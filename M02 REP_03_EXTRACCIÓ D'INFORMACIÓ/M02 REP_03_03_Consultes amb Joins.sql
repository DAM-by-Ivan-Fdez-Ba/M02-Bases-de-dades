USE films;

-- 1. Mostrar el títol i la descripció de totes les pel·lícules que siguin 'horror' i la seva descripció contingui la paraula 'crocodile'.
SELECT film.title, film.description
FROM film
INNER JOIN film_category ON film.film_id = film_category.film_id
INNER JOIN category ON category.category_id = film_category.category_id
WHERE category.name = 'horror' AND film.description LIKE '%crocodile%';

-- 2. Mostrar tota la informació de totes les adreces que pertanyen a 'ARGENTINA'.
SELECT DISTINCT *
FROM address
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN country ON city.country_id = country.country_id
WHERE country.country = 'ARGENTINA';

-- 3. Mostra el nom del pais, el nom, i el cognom dels clients, dels clients que siguin de 'Spain' o 'France', ordenats per nom del pais, cognom i nom del client ascendentment.
SELECT country.country, customer.first_name, customer.last_name
FROM country
INNER JOIN city ON city.country_id = country.country_id
INNER JOIN address ON address.city_id = city.city_id
INNER JOIN customer ON customer.address_id = address.address_id
WHERE country.country IN ('Spain','France')
ORDER BY country.country ASC, customer.last_name ASC, customer.first_name ASC;

-- 4. Mostra el nom, cognom, nom de la ciutat i nom del pais de tots els nostres empleats.
SELECT staff.first_name, staff.last_name, city.city, country.country
FROM country
INNER JOIN city ON city.country_id = country.country_id
INNER JOIN address ON address.city_id = city.city_id
INNER JOIN staff ON staff.address_id = address.address_id

-- 5. Mostra el títol i la descripció de les pel·lícules que han estat rodades en 'Italian','French'o 'German' i estiguin disponibles en el mateix idioma en el que van ser rodades. Ordenar pel títol de la pel·lícula descendenment.
SELECT film.title, film.description, language.name
FROM film
INNER JOIN language ON film.original_language_id = language.language_id
WHERE language.name IN ('Italian','French','German') AND film.original_language_id = film.language_id
ORDER BY film.title DESC;

-- 6. Mostra el títol, la descripció i l'edat apropiada de les películes, on la seva categoria sigui animació o nens i  que l'edat apropiada estigui entre els 1 i els 16 anys. Ordenar pel rating i pel títol. (El rating de les pel·lícules a EEUU és el següent: G --> 1-9, PG --> 10-12, PG-13 --> 13-16, R --> 17, NC-17 --> 18-)
SELECT film.title, film.description, film.rating 
FROM film
INNER JOIN film_category ON film_category.film_id = film.film_id
INNER JOIN category ON category.category_id = film_category.category_id
WHERE category.name IN ('ANIMATION','CHILDREN') AND film.rating IN ('G','PG','PG-13')
ORDER BY film.rating ASC, film.title ASC;

-- 7. Mostra el nom de l'actor, el títol i la descripció de la pel·lícula, de totes les pel·lícules rodades en Francés i que han estat intepretades per les actrius amb nom 'Penelope' o 'Cameron'. Ordenar el resultat pel títol de la pel·lícula.
SELECT actor.first_name, film.title, film.description
FROM film
INNER JOIN language ON film.original_language_id = language.language_id
INNER JOIN film_actor ON film_actor.film_id = film.film_id
INNER JOIN actor ON actor.actor_id = film_actor.actor_id
WHERE actor.first_name IN ('Penelope','Cameron') AND language.name = 'French'
ORDER BY film.title;

-- 8. Hacer una consulta que muestre el nombre y el apellido de todos los clientes que hayan hecho un pago en el mes de agosto entre los días 10 y 20, y que este pago sea mayor que 1.
SELECT DISTINCT customer.first_name, customer.last_name
FROM customer
INNER JOIN payment ON customer.customer_id = payment.customer_id
WHERE MONTH (payment.payment_date) = 8 AND (DAY(payment.payment_date) BETWEEN 10 AND 20) AND payment.amount > 1;

-- 9. Mostra el títol de la pel·lícula, de totes les películes on les característiques especials continguin 'trailers' i aquestes pel·lícules estiguin disponibles a la tenda on el cap d'aquesta tenda és un empleat amb el cognom 'STEPHENS'.
SELECT DISTINCT film.title
FROM film
INNER JOIN inventory ON film.film_id = inventory.film_id
INNER JOIN store ON inventory.store_id = store.store_id
INNER JOIN staff ON store.manager_staff_id = staff.staff_id
WHERE film.special_features LIKE '%trailers%' AND staff.last_name = 'STEPHENS';

-- 10. Mostrar el títol i la longitud de pel·lícula, i nom de la categoria, de totes les pel·lícules que tinguin una longitud superior a la longitud en la variable @length (p.ex: 150), i la seva categoria sigui el contingut de la variable @category_name1 o @category_name2 (p.ex: 'Horror' o 'Sci-Fi').
SET @length = 150;
SET @category_name1 = 'Horror';
SET @category_name2 = 'Sci-Fi';
SELECT film.title, film.length, category.name
FROM film
INNER JOIN film_category ON film.film_id = film_category.film_id
INNER JOIN category ON category.category_id = film_category.category_id
WHERE film.length > @length AND category.name IN (@category_name1, @category_name2);

-- 11. Mostrar el nom i el cognom de tots el clients que han llogat una pel·lícula entre la data de la varaible @date_start (p.ex: 12/07/2005) i la data de la variable @date_end (p.ex: 31/07/2005) i un dels actors de la pel·lícula té de cognom la variable @last_name (p.ex: 'CRUISE').
SET @date_start = '2005-07-12';
SET @date_end = '2005-07-31';
SET @last_name = 'CRUISE';
SELECT customer.first_name, customer.last_name
FROM customer
INNER JOIN rental ON customer.customer_id = rental.customer_id
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film ON inventory.film_id = film.film_id
INNER JOIN film_actor ON film.film_id = film_actor.film_id
INNER JOIN actor ON film_actor.actor_id = actor.actor_id
WHERE (DATE(rental.rental_date) BETWEEN @date_start AND @date_end) AND actor.last_name = @last_name;
















