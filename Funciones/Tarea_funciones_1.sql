
-- TAREA 1

-- ¿Cuál es el promedio de tiempo entre cada pago por cliente de la BD Sakila?
select * from customer; 
select * from payment; 

-- Numerar los pagos de cada cliente en orden ascendiente por fecha
select c.customer_id, p.payment_date, row_number() over(order by c.customer_id, p.payment_date) as no_pago
from customer c inner join payment p on(c.customer_id = p.customer_id);

-- Crear una tabla con fechas consecutivas de renta para cada cliente en orden ascendiente
with pagos_clientes as (select c.customer_id, p.payment_date, row_number() over(order by c.customer_id, p.payment_date) as no_pago
						from customer c inner join payment p on(c.customer_id = p.customer_id)),
			
select pc.customer_id, pc.payment_date primer_pago, pc_ini.payment_date segundo_pago
from pagos_clientes pc left join pagos_clientes pc_ini 
on (pc_ini.customer_id = pc.customer_id) and (pc_ini.no_pago = pc.no_pago + 1)

-- Crear tabla con tiempo entre pagos de cada cliente
with pagos_clientes as (select c.customer_id, p.payment_date, row_number() over() as no_pago
			from customer c inner join payment p on(c.customer_id = p.customer_id)
			order by c.customer_id, p.payment_date asc),
			
	fechas_pago as (select pc.customer_id, pc.payment_date primer_pago, pc_ini.payment_date segundo_pago
					from pagos_clientes pc left join pagos_clientes pc_ini 
					on (pc_ini.customer_id = pc.customer_id) and (pc_ini.no_pago = pc.no_pago + 1))

select customer_id, (segundo_pago - primer_pago) diferencia_pagos
from fechas_pago
where (segundo_pago - primer_pago) is not null

-- Encontrar el promedio del tiempo de pago por cliente
with pagos_clientes as (select c.customer_id, p.payment_date, row_number() over(order by c.customer_id, p.payment_date) as no_pago
						from customer c inner join payment p on(c.customer_id = p.customer_id))
			
	fechas_pago as (select pc.customer_id, pc.payment_date primer_pago, pc_ini.payment_date segundo_pago
					from pagos_clientes pc left join pagos_clientes pc_ini 
					on (pc_ini.customer_id = pc.customer_id) and (pc_ini.no_pago = pc.no_pago + 1)),

	tiempos_pago as (select customer_id, (segundo_pago - primer_pago) diferencia_pagos
					 from fechas_pago
					 where (segundo_pago - primer_pago) is not null)
					
select customer_id, avg(diferencia_pagos) tiempo_prom_pagos
from tiempos_pago tp 
group by customer_id 
order by customer_id;

-- Extraer días y horas de promedio de tiempo
with pagos_clientes as (select c.customer_id, p.payment_date, row_number() over(order by c.customer_id, p.payment_date) as no_pago
						from customer c inner join payment p on(c.customer_id = p.customer_id)),
			
	fechas_pago as (select pc.customer_id, pc.payment_date primer_pago, pc_ini.payment_date segundo_pago
					from pagos_clientes pc left join pagos_clientes pc_ini 
					on (pc_ini.customer_id = pc.customer_id) and (pc_ini.no_pago = pc.no_pago + 1)),

	tiempos_pago as (select customer_id, (segundo_pago - primer_pago) diferencia_pagos
					 from fechas_pago
					 where (segundo_pago - primer_pago) is not null),
					
	prom_pagos as (select customer_id, avg(diferencia_pagos) tiempo_prom_pagos
				   from tiempos_pago tp 
				   group by customer_id 
				   order by customer_id)

select customer_id, extract('days' from tiempo_prom_pagos) dias, extract('hours' from tiempo_prom_pagos) horas
from prom_pagos;

-- QUERY FINAL
-- Redondear promedio de tiempo de pago a días --> human readable
with pagos_clientes as (select c.customer_id, p.payment_date, row_number() over(order by c.customer_id, p.payment_date) as no_pago
						from customer c inner join payment p on(c.customer_id = p.customer_id)),
			
	fechas_pago as (select pc.customer_id, pc.payment_date primer_pago, pc_ini.payment_date segundo_pago
					from pagos_clientes pc left join pagos_clientes pc_ini 
					on (pc_ini.customer_id = pc.customer_id) and (pc_ini.no_pago = pc.no_pago + 1)),

	tiempos_pago as (select customer_id, (segundo_pago - primer_pago) diferencia_pagos
					 from fechas_pago
					 where (segundo_pago - primer_pago) is not null),
					
	prom_pagos as (select customer_id, avg(diferencia_pagos) tiempo_prom_pagos
				   from tiempos_pago tp 
				   group by customer_id 
				   order by customer_id),
				   
	dias_horas as (select customer_id, extract('days' from tiempo_prom_pagos) dias, extract('hours' from tiempo_prom_pagos) horas
				   from prom_pagos)

select c.customer_id, concat(c.first_name, ' ', c.last_name) customer_name, 
	   case
	   		when dh.horas > 23 then dh.dias + 2
	   		when dh.horas <= 23 and dh.horas > 0 then dh.dias + 1
	   		when dh.horas = 0 then dh.dias 
	   		end prom_dias_pago
from customer c inner join dias_horas dh on (c.customer_id = dh.customer_id)
order by c.customer_id;
				   
-- ¿Sigue una distribución normal?	

-- Encontrar media y desviación estándar de los datos
with pagos_clientes as (select c.customer_id, p.payment_date, row_number() over(order by c.customer_id, p.payment_date) as no_pago
						from customer c inner join payment p on(c.customer_id = p.customer_id)),
			
	fechas_pago as (select pc.customer_id, pc.payment_date primer_pago, pc_ini.payment_date segundo_pago
					from pagos_clientes pc left join pagos_clientes pc_ini 
					on (pc_ini.customer_id = pc.customer_id) and (pc_ini.no_pago = pc.no_pago + 1)),

	tiempos_pago as (select customer_id, (segundo_pago - primer_pago) diferencia_pagos
					 from fechas_pago
					 where (segundo_pago - primer_pago) is not null),
					
	prom_pagos as (select customer_id, avg(diferencia_pagos) tiempo_prom_pagos
				   from tiempos_pago tp 
				   group by customer_id 
				   order by customer_id),
				   
	dias_horas as (select customer_id, extract('days' from tiempo_prom_pagos) dias, extract('hours' from tiempo_prom_pagos) horas
				   from prom_pagos),
				   
	prom_pagos_2 as (select c.customer_id, concat(c.first_name, ' ', c.last_name) customer_name, 
	   						case
	   						when dh.horas > 23 then dh.dias + 2
	   						when dh.horas <= 23 and dh.horas > 0 then dh.dias + 1
	   						when dh.horas = 0 then dh.dias 
	   						end prom_dias_pago
					 from customer c inner join dias_horas dh on (c.customer_id = dh.customer_id)
					 order by c.customer_id)

select avg(prom_dias_pago) as media, stddev(prom_dias_pago) as desv_estandar 
from prom_pagos_2;

-- Normalización de promedios 
with pagos_clientes as (select c.customer_id, p.payment_date, row_number() over(order by c.customer_id, p.payment_date) as no_pago
						from customer c inner join payment p on(c.customer_id = p.customer_id)),
			
	fechas_pago as (select pc.customer_id, pc.payment_date primer_pago, pc_ini.payment_date segundo_pago
					from pagos_clientes pc left join pagos_clientes pc_ini 
					on (pc_ini.customer_id = pc.customer_id) and (pc_ini.no_pago = pc.no_pago + 1)),

	tiempos_pago as (select customer_id, (segundo_pago - primer_pago) diferencia_pagos
					 from fechas_pago
					 where (segundo_pago - primer_pago) is not null),
					
	prom_pagos as (select customer_id, avg(diferencia_pagos) tiempo_prom_pagos
				   from tiempos_pago tp 
				   group by customer_id 
				   order by customer_id),
				   
	dias_horas as (select customer_id, extract('days' from tiempo_prom_pagos) dias, extract('hours' from tiempo_prom_pagos) horas
				   from prom_pagos),
				   
	prom_pagos_2 as (select c.customer_id, concat(c.first_name, ' ', c.last_name) customer_name, 
	   						case
	   						when dh.horas > 23 then dh.dias + 2
	   						when dh.horas <= 23 and dh.horas > 0 then dh.dias + 1
	   						when dh.horas = 0 then dh.dias 
	   						end prom_dias_pago
					 from customer c inner join dias_horas dh on (c.customer_id = dh.customer_id)
					 order by c.customer_id),
					 
	media_dve as (select avg(prom_dias_pago) as media, stddev(prom_dias_pago) as desv_estandar 
				  from prom_pagos_2)
	
select pp.customer_id, pp.customer_name, ((prom_dias_pago - md.media)/md.desv_estandar) prom_ajuste
from prom_pagos_2 pp , media_dve md
order by prom_ajuste;


-- Clasificación por intervalos de datos ajustados
with pagos_clientes as (select c.customer_id, p.payment_date, row_number() over(order by c.customer_id, p.payment_date) as no_pago
						from customer c inner join payment p on(c.customer_id = p.customer_id)),
			
	fechas_pago as (select pc.customer_id, pc.payment_date primer_pago, pc_ini.payment_date segundo_pago
					from pagos_clientes pc left join pagos_clientes pc_ini 
					on (pc_ini.customer_id = pc.customer_id) and (pc_ini.no_pago = pc.no_pago + 1)),

	tiempos_pago as (select customer_id, (segundo_pago - primer_pago) diferencia_pagos
					 from fechas_pago
					 where (segundo_pago - primer_pago) is not null),
					
	prom_pagos as (select customer_id, avg(diferencia_pagos) tiempo_prom_pagos
				   from tiempos_pago tp 
				   group by customer_id 
				   order by customer_id),
				   
	dias_horas as (select customer_id, extract('days' from tiempo_prom_pagos) dias, extract('hours' from tiempo_prom_pagos) horas
				   from prom_pagos),
				   
	prom_pagos_2 as (select c.customer_id, concat(c.first_name, ' ', c.last_name) customer_name, 
	   						case
	   						when dh.horas > 23 then dh.dias + 2
	   						when dh.horas <= 23 and dh.horas > 0 then dh.dias + 1
	   						when dh.horas = 0 then dh.dias 
	   						end prom_dias_pago
					 from customer c inner join dias_horas dh on (c.customer_id = dh.customer_id)
					 order by c.customer_id),
					 
	media_dve as (select avg(prom_dias_pago) as media, stddev(prom_dias_pago) as desv_estandar 
				  from prom_pagos_2), 
				  
	datos_ajustados as (select pp.customer_id, pp.customer_name, ((prom_dias_pago - md.media)/md.desv_estandar) prom_ajuste
						from prom_pagos_2 pp , media_dve md
						order by prom_ajuste)
						
select prom_ajuste, 
	   case when prom_ajuste <= -1 then '[-\inf, -1]'
	   		when prom_ajuste > -1 and prom_ajuste <= -0.75 then '(-1, -0.75]'
	   		when prom_ajuste > -0.75 and prom_ajuste <= -0.5 then '(-0.75, -0.5]'
	   		when prom_ajuste > -0.5 and prom_ajuste <= -0.25 then '(-0.5, -0.25]'
	   		when prom_ajuste > -0.25 and prom_ajuste <= 0 then '(-0.25, 0]'
	   		when prom_ajuste > 0 and prom_ajuste <= 0.25 then '(0, 0.25]' 
	   		when prom_ajuste > 0.25 and prom_ajuste <= 0.5 then '(0.25, 0.5]' 
	   		when prom_ajuste > 0.5 and prom_ajuste <= 0.75 then '(0.5, 0.75]'
	   		when prom_ajuste > 0.75 and prom_ajuste <= 1 then '(0.75, 1]'
	   		when prom_ajuste > 1 then '(1, \inf]'
	   	end clase
from datos_ajustados
order by clase;

-- Agrupar a los datos por intervalos que particionen a (-\inf, \inf) 
-- De este último resultado podemos concluir que nuestros datos normalizados NO siguen una distribución nomal estándar
with pagos_clientes as (select c.customer_id, p.payment_date, row_number() over(order by c.customer_id, p.payment_date) as no_pago
						from customer c inner join payment p on(c.customer_id = p.customer_id)),
			
	fechas_pago as (select pc.customer_id, pc.payment_date primer_pago, pc_ini.payment_date segundo_pago
					from pagos_clientes pc left join pagos_clientes pc_ini 
					on (pc_ini.customer_id = pc.customer_id) and (pc_ini.no_pago = pc.no_pago + 1)),

	tiempos_pago as (select customer_id, (segundo_pago - primer_pago) diferencia_pagos
					 from fechas_pago
					 where (segundo_pago - primer_pago) is not null),
					
	prom_pagos as (select customer_id, avg(diferencia_pagos) tiempo_prom_pagos
				   from tiempos_pago tp 
				   group by customer_id 
				   order by customer_id),
				   
	dias_horas as (select customer_id, extract('days' from tiempo_prom_pagos) dias, extract('hours' from tiempo_prom_pagos) horas
				   from prom_pagos),
				   
	prom_pagos_2 as (select c.customer_id, concat(c.first_name, ' ', c.last_name) customer_name, 
	   						case
	   						when dh.horas > 23 then dh.dias + 2
	   						when dh.horas <= 23 and dh.horas > 0 then dh.dias + 1
	   						when dh.horas = 0 then dh.dias 
	   						end prom_dias_pago
					 from customer c inner join dias_horas dh on (c.customer_id = dh.customer_id)
					 order by c.customer_id),
					 
	media_dve as (select avg(prom_dias_pago) as media, stddev(prom_dias_pago) as desv_estandar 
				  from prom_pagos_2), 
				  
	datos_ajustados as (select pp.customer_id, pp.customer_name, ((prom_dias_pago - md.media)/md.desv_estandar) prom_ajuste
						from prom_pagos_2 pp , media_dve md
						order by prom_ajuste),
						
	intervalos as (select prom_ajuste, 
	   					  case when prom_ajuste <= -1 then '[-\inf, -1]'
	   						   when prom_ajuste > -1 and prom_ajuste <= -0.75 then '(-1, -0.75]'
	   						   when prom_ajuste > -0.75 and prom_ajuste <= -0.5 then '(-0.75, -0.5]'
	   						   when prom_ajuste > -0.5 and prom_ajuste <= -0.25 then '(-0.5, -0.25]'
	   						   when prom_ajuste > -0.25 and prom_ajuste <= 0 then '(-0.25, 0]'
	   						   when prom_ajuste > 0 and prom_ajuste <= 0.25 then '(0, 0.25]' 
	   						   when prom_ajuste > 0.25 and prom_ajuste <= 0.5 then '(0.25, 0.5]' 
	   						   when prom_ajuste > 0.5 and prom_ajuste <= 0.75 then '(0.5, 0.75]'
	   						   when prom_ajuste > 0.75 and prom_ajuste <= 1 then '(0.75, 1]'
	   						   when prom_ajuste > 1 then '(1, \inf]'
	   					  end clase
	   				from datos_ajustados
	   				order by clase)
	   				
select clase, count(prom_ajuste)
from intervalos
group by clase;


-- ¿Qué tanto difiere ese promedio del tiempo entre rentas por cliente?

-- Creación tabla de promedio rentas por cliente
with rentas_clientes as (select c.customer_id, r.rental_date, row_number() over(order by c.customer_id, r.rental_date) as no_renta
						 from customer c inner join rental r on(c.customer_id = r.customer_id)),
			
	fechas_renta as (select rc.customer_id, rc.rental_date primera_renta, rc_ini.rental_date segunda_renta
					from rentas_clientes rc left join rentas_clientes rc_ini 
					on (rc_ini.customer_id = rc.customer_id) and (rc_ini.no_renta = rc.no_renta + 1)),

	tiempos_renta as (select customer_id, (segunda_renta - primera_renta) diferencia_rentas
					 from fechas_renta
					 where (segunda_renta - primera_renta) is not null),
					
	prom_rentas as (select customer_id, avg(diferencia_rentas) tiempo_prom_rentas
				   from tiempos_renta tp 
				   group by customer_id 
				   order by customer_id),
				   
	dias_horas as (select customer_id, extract('days' from tiempo_prom_rentas) dias, extract('hours' from tiempo_prom_rentas) horas
				   from prom_rentas)

select c.customer_id, concat(c.first_name, ' ', c.last_name) customer_name, 
	   case
	   		when dh.horas > 23 then dh.dias + 2
	   		when dh.horas <= 23 and dh.horas > 0 then dh.dias + 1
	   		when dh.horas = 0 then dh.dias 
	   		end prom_dias_renta
from customer c inner join dias_horas dh on (c.customer_id = dh.customer_id)
order by c.customer_id;

-- QUERY FINAL
-- Comparación de promedio de rentas vs. promedio de pagos por cliente
with pagos_clientes as (select c.customer_id, p.payment_date, row_number() over(order by c.customer_id, p.payment_date) as no_pago
						from customer c inner join payment p on(c.customer_id = p.customer_id)),
			
	fechas_pago as (select pc.customer_id, pc.payment_date primer_pago, pc_ini.payment_date segundo_pago
					from pagos_clientes pc left join pagos_clientes pc_ini 
					on (pc_ini.customer_id = pc.customer_id) and (pc_ini.no_pago = pc.no_pago + 1)),

	tiempos_pago as (select customer_id, (segundo_pago - primer_pago) diferencia_pagos
					 from fechas_pago
					 where (segundo_pago - primer_pago) is not null),
					
	prom_pagos as (select customer_id, avg(diferencia_pagos) tiempo_prom_pagos
				   from tiempos_pago tp 
				   group by customer_id 
				   order by customer_id),
				   
	dias_horas_p as (select customer_id, extract('days' from tiempo_prom_pagos) dias, extract('hours' from tiempo_prom_pagos) horas
				   from prom_pagos), 
				   rentas_clientes as (select c.customer_id, r.rental_date, row_number() over(order by c.customer_id, r.rental_date) as no_renta
						 from customer c inner join rental r on(c.customer_id = r.customer_id)),
			
	fechas_renta as (select rc.customer_id, rc.rental_date primera_renta, rc_ini.rental_date segunda_renta
					from rentas_clientes rc left join rentas_clientes rc_ini 
					on (rc_ini.customer_id = rc.customer_id) and (rc_ini.no_renta = rc.no_renta + 1)),

	tiempos_renta as (select customer_id, (segunda_renta - primera_renta) diferencia_rentas
					 from fechas_renta
					 where (segunda_renta - primera_renta) is not null),
					
	prom_rentas as (select customer_id, avg(diferencia_rentas) tiempo_prom_rentas
				   from tiempos_renta tp 
				   group by customer_id 
				   order by customer_id),
				   
	dias_horas_r as (select customer_id, extract('days' from tiempo_prom_rentas) dias, extract('hours' from tiempo_prom_rentas) horas
				   from prom_rentas)

select c.customer_id, concat(c.first_name, ' ', c.last_name) customer_name, 
	   case
	   		when dhp.horas > 23 then dhp.dias + 2
	   		when dhp.horas <= 23 and dhp.horas > 0 then dhp.dias + 1
	   		when dhp.horas = 0 then dhp.dias 
	   		end prom_dias_pago,
	   	case
	   		when dhr.horas > 23 then dhr.dias + 2
	   		when dhr.horas <= 23 and dhr.horas > 0 then dhr.dias + 1
	   		when dhr.horas = 0 then dhr.dias 
	   		end prom_dias_renta
from customer c inner join dias_horas_p dhp on (c.customer_id = dhp.customer_id)
				inner join dias_horas_r dhr on (c.customer_id = dhr.customer_id)
order by c.customer_id;

 
