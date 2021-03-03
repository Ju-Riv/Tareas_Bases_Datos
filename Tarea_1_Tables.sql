-- TAREA

-- Creación de Tabla Cliente
create table cliente (
id_cliente numeric(4) constraint pk_cliente primary key,
nombres varchar(50) not null, 
apellidos varchar(50), 
correo varchar(50) not null,
); 
create sequence cliente_id_cliente_seq start 1 increment 1; 
alter table cliente alter column id_cliente set default nextval('cliente_id_cliente_seq');