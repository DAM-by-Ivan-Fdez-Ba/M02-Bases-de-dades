DROP DATABASE films;

CREATE DATABASE films;

USE films;

SET FOREIGN_KEY_CHECKS = 0;

create table COUNTRY (
	country_id INT PRIMARY KEY AUTO_INCREMENT, 
    country VARCHAR (50), 
    last_update DATE
);

create table CITY (
	city_id INT PRIMARY KEY AUTO_INCREMENT, 
    city VARCHAR (50), 
    country_id INT, 
    last_update DATE,
    FOREIGN KEY (country_id) REFERENCES COUNTRY(country_id)
);

create table ADDRESS (
	address_id INT PRIMARY KEY AUTO_INCREMENT, 
    address VARCHAR (100), 
    address2 VARCHAR (100), 
    district VARCHAR (5), 
    city_id INT, 
    postal_code VARCHAR (10), 
    phone INT, 
    last_update DATE,
    FOREIGN KEY (city_id) REFERENCES CITY(city_id)
);

create table ACTOR (
	actor_id INT PRIMARY KEY AUTO_INCREMENT, 
    first_name VARCHAR (50), 
    last_name VARCHAR (50), 
    last_update DATE
);

create table LANGUAGE (
	language_id INT PRIMARY KEY AUTO_INCREMENT, 
    name VARCHAR (50), 
    last_update DATE
);

create table CATEGORY (
	category_id INT PRIMARY KEY AUTO_INCREMENT, 
    name VARCHAR (50), 
    last_update DATE
);

create table FILM (
	film_id INT PRIMARY KEY AUTO_INCREMENT, 
    title VARCHAR (50), 
    description VARCHAR (100), 
    release_year YEAR, 
    language_id INT, 
    original_language_id INT, 
    rental_duration DOUBLE, 
    rental_rate TINYINT, 
    length DOUBLE, 
    replacement_cost DOUBLE, 
    rating VARCHAR (5), 
    special_features VARCHAR (50), 
    last_update DATE,
	FOREIGN KEY (language_id) REFERENCES LANGUAGE(language_id),
    FOREIGN KEY (original_language_id) REFERENCES LANGUAGE(language_id)
);

create table FILM_ACTOR (
	actor_id INT, 
    film_id INT, 
    last_update DATE,
    CONSTRAINT pk_film_actor PRIMARY KEY (actor_id, film_id),
	CONSTRAINT fk_film_actor_actor FOREIGN KEY (actor_id) REFERENCES ACTOR(actor_id),
	CONSTRAINT fk_film_actor_film FOREIGN KEY (film_id) REFERENCES FILM(film_id)
);

create table FILM_CATEGORY (
	film_id INT, 
    category_id INT, 
    last_update DATE,
    CONSTRAINT pk_film_category PRIMARY KEY (film_id, category_id),
	CONSTRAINT fk_film_category_film FOREIGN KEY (film_id) REFERENCES FILM(film_id),
	CONSTRAINT fk_film_category_category FOREIGN KEY (category_id) REFERENCES CATEGORY(category_id)
    
);

create table STORE (
	store_id INT PRIMARY KEY AUTO_INCREMENT, 
    manager_staff_id INT, 
    address_id INT, 
    last_update DATE,
    FOREIGN KEY (manager_staff_id) REFERENCES STAFF(staff_id),
    FOREIGN KEY (address_id) REFERENCES ADDRESS(address_id)
);

create table STAFF (
	staff_id INT PRIMARY KEY AUTO_INCREMENT, 
    first_name VARCHAR (50), 
    last_name VARCHAR (50), 
    address_id INT, 
    picture VARCHAR (50), 
    email VARCHAR (50), 
    store_id INT, 
    active BOOLEAN, 
    username VARCHAR (50), 
    password VARCHAR(50), 
    last_update DATE,
    FOREIGN KEY (address_id) REFERENCES ADDRESS(address_id),
    FOREIGN KEY (store_id) REFERENCES STORE(store_id)
);

create table INVENTORY (
	inventory_id INT PRIMARY KEY AUTO_INCREMENT, 
    film_id INT, 
    store_id INT, 
    last_update DATE,
	FOREIGN KEY (film_id) REFERENCES FILM(film_id),
    FOREIGN KEY (store_id) REFERENCES STORE(store_id)
);

create table CUSTOMER (
	customer_id INT PRIMARY KEY AUTO_INCREMENT, 
    store_id INT, 
    first_name VARCHAR (50), 
    last_name VARCHAR (50), 
    email VARCHAR (50), 
    address_id INT, 
    active BOOLEAN, 
    create_date DATE, 
    last_update DATE,
    FOREIGN KEY (store_id) REFERENCES STORE(store_id),
	FOREIGN KEY (address_id) REFERENCES ADDRESS(address_id)
);

create table RENTAL (
	rental_id INT PRIMARY KEY AUTO_INCREMENT, 
    rental_date DATE, 
    inventory_id INT, 
    customer_id INT, 
    return_date DATE, 
    staff_id INT, 
    last_update DATE,
    FOREIGN KEY (inventory_id) REFERENCES INVENTORY(inventory_id),
	FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id),
    FOREIGN KEY (staff_id) REFERENCES STAFF(staff_id)
);

create table PAYMENT (
	payment_id INT PRIMARY KEY AUTO_INCREMENT, 
    customer_id INT, 
    staff_id INT, 
    rental_id INT, 
    amount DOUBLE, 
    payment_date DATE, 
    last_update DATE,
	FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id),
    FOREIGN KEY (staff_id) REFERENCES STAFF(staff_id),
    FOREIGN KEY (rental_id) REFERENCES RENTAL(rental_id)
);

SET FOREIGN_KEY_CHECKS = 1;