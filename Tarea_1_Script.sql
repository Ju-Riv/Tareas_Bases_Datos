-- TAREA

-- Inserción de datos en Tabla Cliente
select * from cliente c

insert into cliente 
(nombres, apellidos, correo)
values 
('Wanda','Maximoff','wanda.maximoff@avengers.org'),
('Pietro','Maximoff','pietro@mail.sokovia.ru'), 
('Erik','Lensherr','fuck_you_charles@brotherhood.of.evil.mutants.space'),
('Charles','Xavier','i.am.secretely.filled.with.hubris@xavier-school-4-gifted-youngste.'),
('Anthony Edward','Stark','i.am.secretely.filled.with.hubris@xavier-school-4-gifted-youngste.'),
('Steve', 'Rogers',	'americas_ass@anti_avengers'),
('The Vision', null, 'vis@westview.sword.gov'),
('Clint', 'Barton',	'bul@lse.ye'),
('Natasja', 'Romanov', 'blackwidow@kgb.ru'),
('Thor', null, 'god_of_thunder-^_^@royalty.asgard.gov'),
('Logan', null, 'wolverine@cyclops_is_a_jerk.com'),
('Ororo', 'Monroe', 'ororo@weather.co'),
('Scott', 'Summers', 'o@x'),
('Nathan', 'Summers', 'cable@xfact.or'),
('Groot', null, 'iamgroot@asgardiansofthegalaxyledbythorquillsux'),
('Nebula', null, 'idonthaveelektras@complex.thanos'),
('Gamora', null, 'thefiercestwomaninthegalaxy@thanos.'),
('Rocket', null, 'shhhhhhhh@darknet.ru');

-- Construir un query que regrese emails inválidos

-- Si consideramos suficiente garantizar que nuestro string tenga una estructura de la forma: 
-- nombre_usuario@organización.tipo
-- El siguiente query regresará una lista con correos inválidos
select id_cliente, concat(nombres, ' ', apellidos) as "cliente", correo as "Correos Inválidos" from cliente 
where correo not like '_%@__%.__%';

-- Por el contrario, si consideramos que es necesario hacer una lista de todas las terminaciones válidas,
-- el query que sigue funcionará. 
-- Sin embargo, en este caso funciona bien porque tenemos pocas terminaciones posibles. 
-- Pero si quisiéramos replicar este query con muchas más terminaciones no creo que sea muy eficiente
select id_cliente, concat(nombres, ' ', apellidos) as "cliente", correo as "Correos Inválidos" from cliente 
where (correo not like '_%@__%.com' and correo not like '_%@__%.ru' and correo not like '_%@__%.gov' 
	  and correo not like '_%@__%.co' and correo not like '_%@__%.or' and correo not like '_%@__%.org');

-- Análogamente estas son las opciones para regresar una lista con correos inválidos
select id_cliente, concat(nombres, ' ', apellidos) as "cliente", correo as "Correos Inválidos" from cliente 
where correo like '_%@__%.__%';

select id_cliente, concat(nombres, ' ', apellidos) as "cliente", correo as "Correos Inválidos" from cliente 
where (correo like '_%@__%.com' or correo like '_%@__%.ru' or correo like '_%@__%.gov' 
	  or correo like '_%@__%.co' or correo like '_%@__%.or' or correo like '_%@__%.org');
	 
	 
