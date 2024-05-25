USE films;

-- 1. Mostrar el títol de la pel·lícula i la quantitat d'actors que hi participen de totes les pel·lícules.
SELECT film.title, COUNT(actor.actor_id) AS 'quantitat d\'actors'
FROM film
INNER JOIN film_actor ON film_actor.film_id = film.film_id
INNER JOIN actor ON actor.actor_id = film_actor.actor_id
GROUP BY film.title;

-- 2. Mostrar el cognom i el nom del actor, i el nombre de pel·lícules que ha fet en 'French'.
SELECT actor.last_name, actor.first_name, COUNT(film.film_id) AS 'nombre de pel·lícules en French'
FROM actor
INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
INNER JOIN film ON film_actor.film_id = film.film_id
INNER JOIN language ON film.original_language_id = language.language_id
WHERE language.name = 'French'
GROUP BY actor.actor_id;

-- 3. Mostrar el cognom i el nom, i la quantitat de pel·lícules de tots els actors. Ordena pel nombre de films de més films a menys films.
SELECT actor.last_name, actor.first_name, COUNT(film.film_id) AS 'quantitat de pel·lícules'
FROM actor
INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
INNER JOIN film ON film_actor.film_id = film.film_id
GROUP BY actor.actor_id
ORDER BY COUNT(film.film_id) DESC;

-- 4. Mostrar el cognom, el nom i el màxim de dies que d'un lloguer, de tots els clients. Ordenar el resultat pel cognom i el nom del client. No tenir en compte els lloguers que encara no han estat retornats.
SELECT customer.last_name, customer.first_name, MAX(rental.return_date - rental.rental_date) AS 'màxim de dies que d\'un lloguer'
FROM customer
INNER JOIN rental ON customer.customer_id = rental.customer_id
WHERE rental.return_date IS NOT NULL
GROUP BY customer.customer_id
ORDER BY customer.last_name, customer.first_name;


-- 5. Mostra el nom del pais i la mitjana de pagaments, de tots els països. Ordenar el resultat pel nom del pais.
SELECT country.country, AVG(payment.payment_id) AS 'mitjana de pagaments'
FROM country
INNER JOIN city ON country.country_id = city.country_id
INNER JOIN address ON city.city_id = address.city_id
INNER JOIN customer ON address.address_id = customer.address_id
INNER JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY country.country_id
ORDER BY country.country;

-- 6. Mostrar per cada pel·lícula el seu identificador, el seu títol i el total recaudat pel seu lloguer. Ordenar pel total recaudat de més recaudació a menys.
SELECT film.film_id, film.title, SUM(payment.amount) AS 'total recaudat'
FROM film
INNER JOIN inventory ON film.film_id = inventory.film_id
INNER JOIN store ON inventory.store_id = store.store_id
INNER JOIN customer ON store.store_id = customer.store_id
INNER JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY film.film_id
ORDER BY SUM(payment.amount) DESC;

























