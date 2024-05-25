create database rep01_Series;

use rep01_Series;

create table actors (
	idActor int primary key auto_increment,
    nom varchar(100) not null,
    alzada int,
    pes int,
    dataNaixement date
);

create table generes (
	idGenere int primary key auto_increment,
    nom varchar(20) not null
);

create table paisos (
	idPais int primary key auto_increment,
    nom varchar(50) not null
);

create table plataformes (
	idPlataforma int primary key auto_increment,
    nom varchar(50) not null
);

create table ciutats (
	idCiutat int primary key auto_increment,
    nom varchar(50) not null,
    idPais int references paisos(idPais)
);

create table series (
	idSerie int primary key auto_increment,
    titol varchar(50) not null,
    descripcio varchar(1000) not null,
    anyEstrena int not null,
    nombreTemporades int not null,
    idPlataforma int references plataformes(idPlataforma)
);

create table enquadrar (
	idSerie int,
    idGenere int,
    constraint pk_enquadrar primary key (idSerie, idGenere),
    constraint fk_enquadrar_series foreign key(idSerie) references series(idSerie),
	constraint fk_enquadrar_generes foreign key(idGenere) references generes(idGenere)
);

create table interpretar (
	idActor int,
    idGenere int,
    constraint pk_interpretar primary key (idActor, idGenere),
    constraint fk_interpretar_actors foreign key(idActor) references actors(idActor),
	constraint fk_interpretar_generes foreign key(idGenere) references generes(idGenere),
    grauHabilitat int not null
);

create table intervenir (
	idSerie int,
    idActor int,
    constraint pk_intervenir primary key (idSerie, idActor),
    constraint fk_intervenir_series foreign key(idSerie) references series(idSerie),
    constraint fk_intervenir_actors foreign key(idActor) references actors(idActor),
    paper varchar(20) not null
);

create table rodar (
	idSerie int,
    idCiutat int,
    constraint pk_rodar primary key (idSerie, idCiutat),
    constraint fk_rodar_series foreign key(idSerie) references series(idSerie),
    constraint fk_rodar_ciutats foreign key(idCiutat) references ciutats(idCiutat)
);





