USE films;

-- 1. Mostrar tota la informació de tots els films. 
SELECT *
FROM film;

-- 2. Mostrar el títol, la duració del lloguer i la longitud de les pel·lícules amb una duració de lloguer superior a 5 i una longitud de pel·lícula superior a 150.
SELECT film.title, film.rental_duration
FROM film
WHERE film.rental_duration > 5 AND film.length > 150;

-- 3. Mostrar el títol i la longitud de la pel·lícula, de les pel·lícules on la seva longitud estigui entre 150 i 170. Ordenar descendentment per la longtud de la pel·lícula.
SELECT film.title, film.length
FROM film
WHERE film.length > 150 AND film.length < 170
ORDER BY film.length DESC;

-- 4. Mostrar el cognom i el nom de tots els client on el seu cognom tingui com segona lletra una 'A' o una 'O', i el seu nom comenci per 'F'. Ordenar per cognom i nom.
SELECT customer.last_name, customer.first_name
FROM customer
WHERE (customer.last_name LIKE '_A%' OR customer.last_name LIKE '_O%') AND customer.first_name LIKE 'F%'
ORDER BY customer.last_name ASC, customer.first_name ASC;

-- 5. Mostrar la data de pagament, l'identificador del client i l'import del pagament, dels pagaments que estiguin entre 28/07/2005 i 30/07/2005.
SELECT payment.payment_date, payment.customer_id, payment.amount
FROM payment
WHERE payment.payment_date BETWEEN '2005-07-28' AND '2005-07-30';

-- 6.Mostrar la data de pagament, l'identificador del client, l'identificador del venedor i l'import del pagament, de tots els pagaments que siguin del clients amb els identificadors 20, 30, 40 o 50, que l'identificador del venedor sigui el 2 i el mes del pagament sigui Agost. Les dades han de sortir ordenades per data de pagament descendentment i per l'ientificador del client.
SELECT payment.payment_date, payment.customer_id, payment.staff_id, payment.amount
FROM payment
WHERE payment.customer_id = (20 OR 30 OR 40 OR 50) AND payment.staff_id = 2 AND MONTH (payment.payment_date) = 8
ORDER BY payment.payment_date DESC, payment.customer_id ASC;

-- 7. Mostrar el nom complert del client, es a dir, el seu cognom, una ', ' i el seu nom amb un àlies de 'complet_name', i el email, de tots els clients que no estiguin actius, que l'identificador de la tenda sigui 1, i el seu cognom ha de tenir'UN' o el seu nom 'ER'. Ordenar el resultat perl nom complert.
SELECT CONCAT (customer.last_name, ',', customer.first_name) AS complet_name, customer.email
FROM customer
WHERE customer.active = FALSE AND customer.store_id = 1 AND (customer.last_name LIKE '%UN%' OR customer.first_name LIKE '%ER%')
ORDER BY complet_name ASC;



