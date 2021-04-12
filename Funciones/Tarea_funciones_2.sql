
-- TAREA 2

-- Determinar las medidas de los contenedores ciclíndricos y el número de ocntenedores por tienda
-- para guardar todos los discos 

-- DATOS A CONSIDERAR
-- Medidas por caja: 20cm x 13.5cm x 1.5cm
-- Medidas contenedores individuales: 30cm x 21cm x 8cm -> 5040cm^3
-- Peso máximo por contenedor: 50 kg
-- Peso por película: 500g 

-- ¿Cuántos películas hay por tienda?
select store_id, count(inventory_id) film_count
from inventory
group by store_id;

-- Calcular el número de películas que podemos almacenar por contenedor dada la restricción de peso máximo
select (50 * 1000)/500 as max_no_films;

-- Calcular el número de contenedores que necesitamos para cada tienda
with films_per_store as (select store_id, count(inventory_id) film_count
						 from inventory
						 group by store_id), 
						 
	 max_films as (select ((50 * 1000)/500)::float as max_no_films)
	 
select fps.store_id, 
	   case when (fps.film_count / max_no_films)/(trunc(fps.film_count / max_no_films)) != 1 
	   		then trunc(fps.film_count / max_no_films) + 1
	   		when (fps.film_count / max_no_films)/(trunc(fps.film_count / max_no_films)) = 1 
	   		then trunc(fps.film_count / max_no_films)
	   end max_film_ps
from films_per_store fps, max_films mx
order by fps.store_id;

-- Las estructuras cilíndricas propuestas tendrán las siguientes características: 

-- Serán de forma "tipo dona", es decir, la estructura estará hueca. 
-- El volumen de cada contenedor estará dado por el área entre dos círculos C1, C2, con respectivos 
-- radios r1, r2 tales que r1 < r2, multiplicada por la altura h. 
-- Cada contenedor tendrá 10 pisos, y cada piso tendrá una capacidad de 10 películas. Así, cada contenedor
-- satisfacirá la capacidad máxima de 100 películas. 
-- Las películas irán acomodadas sobre su costado, por lo que la altura de cada piso hj > 21cm, j = 1,...,10 ,
-- mientras que la distancia entre el contorno circular exterior y el interior, r2-r1 > 30. 
-- Finalmente pediremos que la longitud del lado del decágono inscrito en C2, l2 > 8 y que
-- el lado del decágono que tiene circunsinscrito a C1, l1 > 8.
-- Para mayor claridad ver los diagramas en la carpeta del repositorio. 

-- Con estas especificaciones aseguramos que las cajas entren en el copartimiento, que se
-- respeten las medidas para la extracción de éstas y se reduce el material necesario para
-- la construcción de cada contenedor (dado que es hueco).

-- A continuación verificaremos que las siguientes medidas para cada contenedor cumplen con todas
-- las restricciones descritas anteriormente. 

-- Dado que r1 corresponde al apotema de un decágono regular de lado l1 sobre el cual está circunscrito C1, 
-- tomando l1 = 9 > 8 resulta que
-- r1 = 9 / (2*tan(180°/10)) = 9 / (2*tan((180/10)*(\pi/180))) 
-- Observación: no tomamos r = 8 ya que estamos considerando que el grosor de las separaciones entre cada cajón es de 0.5,
-- pero restando este centímetro extra, el espacio del cajón tiene un ancho de 8cm
-- Además, decidimos redondear el radio interior r1 para fines de simplicidad en los cálculos y la construcción
-- de los contenedores
select round((9 / (2*tan((180/10)*(pi()/180))))) r1

-- Por semejanza de triángulos r1/(30+r1) = ((4^2 + r1^2)^(1/2))/r2
-- Nuevamente redondeamos el radio exterior r2
with radio_interior as (select round((9 / (2*tan((180/10)*(pi()/180))))) r1)

select ri.r1, round(((sqrt(power(4,2) + power(ri.r1, 2))*(30 + ri.r1))/ri.r1)) as r2
from radio_interior ri

-- Habiendo calculado ambos radios, procedemos a calcular el área de los cilindros interiores y exteriores 
-- generados por C1, C2 respectivamente, dada la altura h = sum(hj) = 22*10
-- Aquí se tiene que considerar nuevamente el grosor de la separación entre los pisos que será de 1cm, hj=(21+1)
-- Recordemos que el volumen de un cilindro está dado por \pi*r^2*h
with radio_interior as (select round((9 / (2*tan((180/10)*(pi()/180))))) r1),

	 radio_exterior as (select round(((sqrt(power(4,2) + power(ri.r1, 2))*(30 + ri.r1))/ri.r1)) r2
	 					from radio_interior ri),
	 altura as (select 22*10 h)

select round((pi()*power(ri.r1,2)*a.h)::numeric, 2) volumen_interior, round((pi()*power(re.r2,2)*a.h)::numeric, 2) volumen_exterior
from radio_interior ri, radio_exterior re, altura a

-- Finalmente hacemos la resta del volumen_exterior - volumen_interior para determinar el volumen total de nuestro contenedor
-- (esto ya considera el hoyo del contenedor). 
-- Además, agregamos columnas con las medidas de los radios y altura para mejor legibilidad
with radio_interior as (select round((9 / (2*tan((180/10)*(pi()/180))))) r1),

	 radio_exterior as (select round(((sqrt(power(4,2) + power(ri.r1, 2))*(30 + ri.r1))/ri.r1)) r2
	 					from radio_interior ri),
	 altura as (select 22*10 h),
	 
	 volumenes as (select round((pi()*power(ri.r1,2)*a.h)::numeric, 2) volumen_interior, 
	 					  round((pi()*power(re.r2,2)*a.h)::numeric, 2) volumen_exterior
	 			   from radio_interior ri, radio_exterior re, altura a)

select ri.r1, re.r2, a.h, (v.volumen_exterior - v.volumen_interior) as volumen_total
from radio_interior ri, radio_exterior re, altura a, volumenes v




