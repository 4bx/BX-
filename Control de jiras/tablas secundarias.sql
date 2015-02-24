drop table usuarios;
drop table empresas;


create table empresas (c_empresa smallint not null, 
                       empresa varchar(45) not null,
                       primary key (c_empresa));

insert into empresas values (1,'Bx+');
insert into empresas values (2,'TAS');

create table usuarios (nombre varchar(45) not null,
                       c_empresa smallint not null,
                       primary key (c_empresa,nombre));


insert into usuarios values('Agustin Gutierrez',1);
insert into usuarios values('Alejandra Ivonne González Venancio',1);
insert into usuarios values('Ana hernandez',1);
insert into usuarios values('Ana Mayte Topete',1);
insert into usuarios values('Antonio Laija Olmedo',1);
insert into usuarios values('Arturo Saldivar',2);
insert into usuarios values('Carmen Méndez',2);
insert into usuarios values('Cesar Guzmán',1);
insert into usuarios values('Christian González Flores',1);
insert into usuarios values('Christian Ramirez',1);
insert into usuarios values('Edgar Rangel',1);
insert into usuarios values('Edgar Richter',2);
insert into usuarios values('Erick Vázquez',1);
insert into usuarios values('Ever Hernandez',2);
insert into usuarios values('Francisco Morales López',1);
insert into usuarios values('Gabriela Cedillo',2);
insert into usuarios values('Gaby Ledesma',1);
insert into usuarios values('Gerardo Gomez',2);
insert into usuarios values('Gerardo Tenopala',2);
insert into usuarios values('German Gomez',2);
insert into usuarios values('Giordy Palacios',1);
insert into usuarios values('Irma Aguilar',1);
insert into usuarios values('Isela Martínez',1);
insert into usuarios values('Ivan Torres',2);
insert into usuarios values('Jacqueline Barradas',2);
insert into usuarios values('Jesús Villaseñor',1);
insert into usuarios values('Jocelyn Vazquez',1);
insert into usuarios values('Jose Daniel Garces Quiroz',1);
insert into usuarios values('Juan Carlos Fernández',1);
insert into usuarios values('Juan Vargas',1);
insert into usuarios values('Leonado Hernández',1);
insert into usuarios values('Margarita Arellano',1);
insert into usuarios values('Maricarmen Mendez Álvarez',1);
insert into usuarios values('Martin Cruz',1);
insert into usuarios values('Mary Carmen Bonilla Limón',1);
insert into usuarios values('Rafael Cedillo',1);
insert into usuarios values('Roberto de la Rosa',1);
insert into usuarios values('Salvador García',2);
insert into usuarios values('Sergio Rangel',2);
insert into usuarios values('Tere Díaz',1);
insert into usuarios values('Ximena Roldan',1);
