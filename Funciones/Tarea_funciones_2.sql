
-- TAREA 2

-- Determinar las medidas de los contenedores cicl�ndricos y el n�mero de ocntenedores por tienda
-- para guardar todos los discos 

-- DATOS A CONSIDERAR
-- Medidas por caja: 20cm x 13.5cm x 1.5cm
-- Medidas contenedores individuales: 30cm x 21cm x 8cm -> 5040cm^3
-- Peso m�ximo por contenedor: 50 kg
-- Peso por pel�cula: 500g 

-- �Cu�ntos pel�culas hay por tienda?
select store_id, count(inventory_id) film_count
from inventory
group by store_id;

-- Calcular el n�mero de pel�culas que podemos almacenar por contenedor dada la restricci�n de peso m�ximo
select (50 * 1000)/500 as max_no_films;

-- Calcular el n�mero de contenedores que necesitamos para cada tienda
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

-- Las estructuras cil�ndricas propuestas tendr�n las siguientes caracter�sticas: 

-- Ser�n de forma "tipo dona", es decir, la estructura estar� hueca. 
-- El volumen de cada contenedor estar� dado por el �rea entre dos c�rculos C1, C2, con respectivos 
-- radios r1, r2 tales que r1 < r2, multiplicada por la altura h. 
-- Cada contenedor tendr� 10 pisos, y cada piso tendr� una capacidad de 10 pel�culas. As�, cada contenedor
-- satisfacir� la capacidad m�xima de 100 pel�culas. 
-- Las pel�culas ir�n acomodadas sobre su costado, por lo que la altura de cada piso hj > 21cm, j = 1,...,10 ,
-- mientras que la distancia entre el contorno circular exterior y el interior, r2-r1 > 30. 
-- Finalmente pediremos que la longitud del lado del dec�gono inscrito en C2, l2 > 8 y que
-- el lado del dec�gono que tiene circunsinscrito a C1, l1 > 8.
-- Para mayor claridad ver los diagramas en la carpeta del repositorio. 

-- Con estas especificaciones aseguramos que las cajas entren en el copartimiento, que se
-- respeten las medidas para la extracci�n de �stas y se reduce el material necesario para
-- la construcci�n de cada contenedor (dado que es hueco).

-- A continuaci�n verificaremos que las siguientes medidas para cada contenedor cumplen con todas
-- las restricciones descritas anteriormente. 

-- Dado que r1 corresponde al apotema de un dec�gono regular de lado l1 sobre el cual est� circunscrito C1, 
-- tomando l1 = 9 > 8 resulta que
-- r1 = 9 / (2*tan(180�/10)) = 9 / (2*tan((180/10)*(\pi/180))) 
-- Observaci�n: no tomamos r = 8 ya que estamos considerando que el grosor de las separaciones entre cada caj�n es de 0.5,
-- pero restando este cent�metro extra, el espacio del caj�n tiene un ancho de 8cm
-- Adem�s, decidimos redondear el radio interior r1 para fines de simplicidad en los c�lculos y la construcci�n
-- de los contenedores
select round((9 / (2*tan((180/10)*(pi()/180))))) r1

-- Por semejanza de tri�ngulos r1/(30+r1) = ((4^2 + r1^2)^(1/2))/r2
-- Nuevamente redondeamos el radio exterior r2
with radio_interior as (select round((9 / (2*tan((180/10)*(pi()/180))))) r1)

select ri.r1, round(((sqrt(power(4,2) + power(ri.r1, 2))*(30 + ri.r1))/ri.r1)) as r2
from radio_interior ri

-- Habiendo calculado ambos radios, procedemos a calcular el �rea de los cilindros interiores y exteriores 
-- generados por C1, C2 respectivamente, dada la altura h = sum(hj) = 22*10
-- Aqu� se tiene que considerar nuevamente el grosor de la separaci�n entre los pisos que ser� de 1cm, hj=(21+1)
-- Recordemos que el volumen de un cilindro est� dado por \pi*r^2*h
with radio_interior as (select round((9 / (2*tan((180/10)*(pi()/180))))) r1),

	 radio_exterior as (select round(((sqrt(power(4,2) + power(ri.r1, 2))*(30 + ri.r1))/ri.r1)) r2
	 					from radio_interior ri),
	 altura as (select 22*10 h)

select round((pi()*power(ri.r1,2)*a.h)::numeric, 2) volumen_interior, round((pi()*power(re.r2,2)*a.h)::numeric, 2) volumen_exterior
from radio_interior ri, radio_exterior re, altura a

-- Finalmente hacemos la resta del volumen_exterior - volumen_interior para determinar el volumen total de nuestro contenedor
-- (esto ya considera el hoyo del contenedor). 
-- Adem�s, agregamos columnas con las medidas de los radios y altura para mejor legibilidad
with radio_interior as (select round((9 / (2*tan((180/10)*(pi()/180))))) r1),

	 radio_exterior as (select round(((sqrt(power(4,2) + power(ri.r1, 2))*(30 + ri.r1))/ri.r1)) r2
	 					from radio_interior ri),
	 altura as (select 22*10 h),
	 
	 volumenes as (select round((pi()*power(ri.r1,2)*a.h)::numeric, 2) volumen_interior, 
	 					  round((pi()*power(re.r2,2)*a.h)::numeric, 2) volumen_exterior
	 			   from radio_interior ri, radio_exterior re, altura a)

select ri.r1, re.r2, a.h, (v.volumen_exterior - v.volumen_interior) as volumen_total
from radio_interior ri, radio_exterior re, altura a, volumenes v




