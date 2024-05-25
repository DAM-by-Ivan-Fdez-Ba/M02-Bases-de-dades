drop database HOTELS;
create database HOTELS;

use HOTELS;

create table ACTIVITATS (
idActivitat INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
nom varchar (50)
);

create table AGENCIES (
idAgencia INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
nom varchar (50)
);

create table CADENES_HOTELS (
cif INT PRIMARY KEY NOT NULL  AUTO_INCREMENT,
nom varchar (50),
adreca_Fiscal varchar (100)
);

create table CIUTATS (
idCiutat INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
nom varchar (50)
);

create table EMPLEATS (
idEmpleat INT PRIMARY KEY NOT NULL  AUTO_INCREMENT,
DNI char (9) UNIQUE,
nom varchar (50)
);

create table DELEGACIONS (
idDelegacio INT,
idAgencia INT,
idCiutat INT,
adreca varchar (100),
CONSTRAINT pk_delegacions PRIMARY KEY (idDelegacio, idAgencia),
CONSTRAINT fk_delegacions_ciuats FOREIGN KEY (idCiutat) REFERENCES CIUTATS(idCiutat),
CONSTRAINT fk_delegacions_agencia FOREIGN KEY (idAgencia) REFERENCES AGENCIES(idAgencia)
);

create table HOTELS (
    nom varchar(50),
    categoria TINYINT,
    adreca varchar(50),
    telefon INT,
    tipus_hotel ENUM('platja', 'muntanya'),
    cif INT,
    idCiutat INT,
    CONSTRAINT pk_hotels PRIMARY KEY (nom, idCiutat),
    CONSTRAINT fk_hotels_ciutats FOREIGN KEY (idCiutat) REFERENCES CIUTATS(idCiutat),
    FOREIGN KEY (cif) REFERENCES CADENES_HOTELS(cif)
);

create table MONTANYA (
idCiutat INT,
nom varchar (50),
piscina boolean,
CONSTRAINT pk_muntanya PRIMARY KEY (idCiutat, nom),
CONSTRAINT fk_muntanya_ciutats FOREIGN KEY (idCiutat) REFERENCES CIUTATS(idCiutat),
CONSTRAINT fk_muntanya_hotels FOREIGN KEY (nom, idCiutat) REFERENCES HOTELS(nom, idCiutat)
);

create table PLATJA (
idCiutat INT,
nom varchar (50) ,
platjaPrivada boolean,
lloguerEmbarcacions boolean,
CONSTRAINT pk_platja PRIMARY KEY (idCiutat, nom),
CONSTRAINT fk_platja_ciutats FOREIGN KEY (idCiutat) REFERENCES CIUTATS(idCiutat),
CONSTRAINT fk_platja_hotels FOREIGN KEY (nom, idCiutat) REFERENCES HOTELS(nom, idCiutat)
);

create table ASSIGNAR (
num INT,
nom varchar (50),
mes date,
idAgencia INT,
CONSTRAINT pk_assignar PRIMARY KEY (nom, mes, idAgencia),
CONSTRAINT fk_assignar_nom FOREIGN KEY (nom) REFERENCES HOTELS(nom),
CONSTRAINT fk_assignar_idAgencia FOREIGN KEY (idAgencia) REFERENCES AGENCIES(idAgencia)
);

create table CONTRACTA (
dataAlta DATE,
dataBaixa DATE,
cif INT,
idEmpleat INT,
CONSTRAINT pk_contracta PRIMARY KEY (idEmpleat, dataAlta),
CONSTRAINT fk_contracta_empleats FOREIGN KEY (idEmpleat) REFERENCES EMPLEATS(idEmpleat),
FOREIGN KEY (cif) REFERENCES CADENES_HOTELS(cif)
);

create table EQUIVALENTS (
nom varchar (50),
idCiutat INT,
nomEquivalents varchar (50),
idCiutatEquivalents INT,
CONSTRAINT pk_equivalents PRIMARY KEY (nom, idCiutat, nomEquivalents, idCiutatEquivalents),
CONSTRAINT fk_equivalents FOREIGN KEY (nom, idCiutat) REFERENCES HOTELS(nom, idCiutat),
CONSTRAINT fk_contracta_equivalents FOREIGN KEY (nomEquivalents, idCiutatEquivalents) REFERENCES HOTELS(nom, idCiutat)
);

create table REALITZEN (
nivellQuialitat varchar (50),
idCiutat INT,
idActivitat INT,
nom varchar (50),
CONSTRAINT pk_realitzan PRIMARY KEY (nom, idCiutat, idActivitat),
CONSTRAINT fk_realitzen_hotels FOREIGN KEY (nom, idCiutat) REFERENCES HOTELS(nom, idCiutat),
CONSTRAINT fk_realitzen_idActivitat FOREIGN KEY (idActivitat) REFERENCES ACTIVITATS(idActivitat)
);

create table TRABAJA (
dataAlta DATE,
idEmpleat INT,
idCiutat INT,
nom varchar (50),
CONSTRAINT pk_trabaja PRIMARY KEY (dataAlta, idEmpleat),
CONSTRAINT fk_trabaja_empleats FOREIGN KEY (idEmpleat) REFERENCES EMPLEATS(idEmpleat),
CONSTRAINT fk_trabaja_hotels FOREIGN KEY (nom, idCiutat) REFERENCES HOTELS(nom, idCiutat)
);