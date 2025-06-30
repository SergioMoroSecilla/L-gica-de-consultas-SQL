--P.1-Esquema de la BBDD creado en archivo adjunto Esquema.png

--P.2-Nombres de todas las películas con una clasificación por edades de 'R'
SELECT FILM_ID, 
	TITLE, 
	RATING 
FROM FILM AS F 
WHERE RATING = 'R';

--P.3-Nombre de los actores que tengan un "actor_id" entre 30 y 40
SELECT ACTOR_ID,
		CONCAT(FIRST_NAME,' ',LAST_NAME) as "Actor name"
FROM ACTOR AS A
WHERE ACTOR_ID >=30 AND ACTOR_ID <=40;

--P.4-Películas cuyo idioma coincide con el idioma original.
SELECT FILM_ID, 
	TITLE,
	LANGUAGE_ID,
	ORIGINAL_LANGUAGE_ID 
FROM FILM AS F 
WHERE LANGUAGE_ID = ORIGINAL_LANGUAGE_ID ;

/*Hago un select mas genérico para ver porque no aparece ninguna pélicula. 
 * Al ejecutar consulta se puede ver que toda la columna original_language_id 
 * no tiene valores y todos los resgistros son NULL
 */
SELECT FILM_ID ,
		LANGUAGE_ID, 
		ORIGINAL_LANGUAGE_ID 
FROM FILM AS F ;

--P.5-Películas por duración de forma ascendente.
SELECT FILM_ID, 
	TITLE,
	LENGTH 
FROM FILM AS F 
order by LENGTH; --no marco "asc" porque por defecto ya me lo hace de manera ascendente

--P.6-Encuentra el nombre y apellido de los actores que tengan ‘Allenʼ en su apellido.
SELECT 
	ACTOR_ID ,
	CONCAT(FIRST_NAME,' ',LAST_NAME) 
FROM ACTOR AS A 
WHERE LAST_NAME = 'ALLEN';

/*--P.7-Encuentra la cantidad total de películas en cada clasificación de la tabla 
“filmˮ y muestra la clasificación junto con el recuento.*/
SELECT RATING, 
		count(RATING) as numero_peliculas
FROM FILM AS F
group by RATING 
order by numero_peliculas ;

/*--P.8-Encuentra el título de todas las películas que son ‘PG-13ʼ o tienen una 
duración mayor a 3 horas en la tabla film.*/
SELECT 	TITLE ,
		RATING ,
		LENGTH 
FROM FILM AS F 
WHERE RATING = 'PG-13' OR LENGTH > 270; 
--en la consulta no ha aparecido ninguna pélicula con duración mayor a 3 horas, por tanto todas son de rating PG-13

--P.9-Encuentra la variabilidad de lo que costaría reemplazar las películas.
SELECT ROUND(STDDEV("replacement_cost"), 2) as variabilidad_reemplazo_pelicula
FROM FILM AS F ;
--he redondeado el calculo de la variació dels coste de reemplazo respecto a la media a 2 decimales

--P.10-Encuentra la mayor y menor duración de una película de nuestra BBDD.
SELECT 	MIN(LENGTH) as minima_duracion,
		MAX(LENGTH) as maxima_duracion
FROM FILM AS F;


--P.11-Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
SELECT 	RENTAL_ID ,
		RENTAL_DATE 
FROM RENTAL AS R
order by RENTAL_DATE desc
limit 1
OFFSET 2;

/*--P.12-Encuentra el título de las películas en la tabla “filmˮ que no sean ni ‘NC- 17ʼ
  ni ‘Gʼ en cuanto a su clasificación.*/
SELECT FILM_ID ,
		TITLE ,
		RATING 
FROM FILM AS F 
WHERE RATING not in ('G', 'NC-17');	

/*--P.13-Encuentra el promedio de duración de las películas para cada
clasificación de la tabla film y muestra la clasificación junto con el
promedio de duración.*/
select
	RATING ,
	ROUND(AVG(LENGTH), 2) as duracion_media
FROM FILM AS F 
group by RATING;

/*--P.14-Encuentra el título de todas las películas que tengan una duración mayor
a 180 minutos.*/
SELECT 
	TITLE ,
	LENGTH 
FROM FILM AS F 
WHERE LENGTH > 180;

--P.15-¿Cuánto dinero ha generado en total la empresa?
SELECT SUM(AMOUNT) facturacion_total
FROM PAYMENT AS P ;

--P.16-Muestra los 10 clientes con mayor valor de id.
SELECT CUSTOMER_ID 
FROM CUSTOMER AS C
order by CUSTOMER_ID DESC 
LIMIT 10;

--P.17-Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’.
select F.TITLE ,
	CONCAT(A.FIRST_NAME,' ',A.LAST_NAME) as actor_name
FROM ACTOR AS A 
JOIN FILM_ACTOR AS FA on A.ACTOR_ID = FA.ACTOR_ID
JOIN FILM AS F on FA.FILM_ID = F.FILM_ID 
WHERE F.TITLE = 'EGG IGBY';

--P.18-Selecciona todos los nombres de las películas únicos.
SELECT DISTINCT (TITLE)
FROM FILM AS F ;
--Al no haber ningún titulo con valor NULL, el número de películas es igual a pedir todos los titulos de películas sin el DISTINCT.

--P.19-Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “film”
SELECT 	F.TITLE,
		F.LENGTH,
		C.NAME
FROM FILM AS F
JOIN FILM_CATEGORY AS FC on F.FILM_ID = FC.FILM_ID
JOIN CATEGORY AS C on FC.CATEGORY_ID = C.CATEGORY_ID
WHERE C.NAME = 'Comedy' and F.LENGTH > 180;

/*20. Encuentra las categorías de películas que tienen un promedio de
duración superior a 110 minutos y muestra el nombre de la categoría
junto con el promedio de duración.*/
SELECT 	C.NAME as category,
		ROUND(AVG(F.LENGTH), 2) as length_average
FROM FILM AS F
JOIN FILM_CATEGORY AS FC on F.FILM_ID = FC.FILM_ID
JOIN CATEGORY AS C on FC.CATEGORY_ID = C.CATEGORY_ID
GROUP BY C.NAME
HAVING AVG(F.LENGTH) > 110;

--21. ¿Cuál es la media de duración del alquiler de las películas?

SELECT AVG(R.RETURN_DATE  - R.RENTAL_DATE) as rental_duration
FROM RENTAL as R;
--A posteriori he visto que en tabla 'FILM' tenemos 'RENTAL_DURATION', por tanto la consulta sería...
SELECT AVG(F.RENTAL_DURATION) AS rental_duration
FROM FILM AS F 

--22. Crea una columna con el nombre y apellidos de todos los actores y actrices.
SELECT CONCAT(A.FIRST_NAME, ' ', A.LAST_NAME )
FROM ACTOR AS A;

--23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.
SELECT
  DATE_TRUNC('day', R.RENTAL_DATE) AS dia_alquile,
  COUNT(*)                         AS num_alquileres
FROM RENTAL AS R
GROUP BY DATE_TRUNC('day', R.RENTAL_DATE)
ORDER BY num_alquileres DESC;

--24. Encuentra las películas con una duración superior al promedio.
--CALCULO DE LA MEDIA DE DURACIÓN DE LAS PELICULAS DE LA BBDD
SELECT AVG(F.LENGTH)
FROM FILM AS F;
--CONSULTA
SELECT F.LENGTH,
		F.TITLE
FROM FILM AS F 
WHERE F.LENGTH > (SELECT AVG(LENGTH) FROM FILM)
ORDER BY F.LENGTH DESC;

--25. Averigua el número de alquileres registrados por mes.
--formula igual a las pregunta 23, modificando day por month
SELECT  DATE_TRUNC('MONTH', R.RENTAL_DATE) AS mes_alquiler,
  		COUNT(*) AS num_alquileres
FROM RENTAL AS R
GROUP BY DATE_TRUNC('MONTH', R.RENTAL_DATE)
ORDER BY num_alquileres;

--26. Encuentra el promedio, la desviación estándar y varianza del total pagado.
SELECT ROUND(AVG(AMOUNT), 2) as average, 
		ROUND(STDDEV(AMOUNT), 2) as standard_desviation, 
		ROUND(VARIANCE(AMOUNT), 2) as 
FROM PAYMENT AS P;

--27. ¿Qué películas se alquilan por encima del precio medio?
SELECT F.TITLE,
		P.AMOUNT
FROM FILM F
JOIN INVENTORY I ON F.FILM_ID = I.FILM_ID
JOIN RENTAL R ON I.INVENTORY_ID = R.INVENTORY_ID
JOIN PAYMENT P ON R.RENTAL_ID = P.RENTAL_ID 
WHERE P.AMOUNT > (SELECT AVG(AMOUNT) FROM PAYMENT)
ORDER BY P.AMOUNT DESC;

--28. Muestra el id de los actores que hayan participado en más de 40 películas.
SELECT A.ACTOR_ID,
		COUNT(FA.FILM_ID) as total_peliculas
FROM ACTOR AS A
JOIN FILM_ACTOR AS FA ON A.ACTOR_ID = FA.ACTOR_ID
GROUP BY A.ACTOR_ID 
HAVING COUNT(FA.FILM_ID) > 40
ORDER BY total_peliculas desc;

--29. Obtener todas las películas y, si están disponibles en el inventario,mostrar la cantidad disponible.

/*SELECT *
FROM INVENTORY AS I 

SELECT F.FILM_ID,
	F.TITLE,
	COUNT(I.INVENTORY_ID) AS inventory_available
FROM FILM AS F 
JOIN INVENTORY AS I ON F.FILM_ID = I.FILM_ID
LEFT JOIN RENTAL AS R ON I.INVENTORY_ID = R.INVENTORY_ID
WHERE R.RETURN_DATE  is not null
GROUP BY F.FILM_ID
ORDER BY F.FILM_ID;


SELECT F.FILM_ID,
	F.TITLE,
	COUNT(I.INVENTORY_ID) AS inventory_available
FROM FILM AS F 
JOIN INVENTORY AS I ON F.FILM_ID = I.FILM_ID
WHERE EXISTS (
	SELECT 1
    FROM INVENTORY AS I2  
    JOIN RENTAL AS R ON I2.INVENTORY_ID = R.INVENTORY_ID
    where R.RETURN_DATE is not NULL
)
GROUP BY F.FILM_ID
ORDER BY F.FILM_ID;*/

--30. Obtener los actores y el número de películas en las que ha actuado.
SELECT 	CONCAT(A.FIRST_NAME,' ',A.LAST_NAME) AS actor_name,
		COUNT(FA.FILM_ID) AS film_number
FROM ACTOR AS A 
JOIN FILM_ACTOR AS FA ON A.ACTOR_ID = FA.ACTOR_ID
GROUP BY A.ACTOR_ID
ORDER by film_number desc;

/*31. Obtener todas las películas y mostrar los actores que han actuado en
ellas, incluso si algunas películas no tienen actores asociados.*/
SELECT F.TITLE,
		CONCAT(A.FIRST_NAME,' ',A.LAST_NAME) AS actor_name
FROM FILM AS F 
LEFT JOIN FILM_ACTOR AS FA ON F.FILM_ID = FA.FILM_ID
LEFT JOIN ACTOR AS A ON FA.ACTOR_ID = A.ACTOR_ID
order by F.TITLE, actor_name;
--Marco un left join, para que se muestren películas incluso si no tienen actores asociados, como se pide.

/*32. Obtener todos los actores y mostrar las películas en las que han
actuado, incluso si algunos actores no han actuado en ninguna película.*/
SELECT A.ACTOR_ID,
		CONCAT(A.FIRST_NAME,' ',A.LAST_NAME) AS actor_name,
		F.TITLE
FROM ACTOR AS A 
LEFT JOIN FILM_ACTOR AS FA ON A.ACTOR_ID = FA.ACTOR_ID
LEFT JOIN FILM AS F ON FA.FILM_ID = F.FILM_ID 
ORDER BY A.ACTOR_ID, F.TITLE;

--33. Obtener todas las películas que tenemos y todos los registros de alquiler.
SELECT F.TITLE,
		COUNT(R.RENTAL_DATE) AS rental_register
FROM FILM AS F 
LEFT JOIN INVENTORY AS I ON F.FILM_ID = I.FILM_ID
LEFT JOIN RENTAL AS R ON I.INVENTORY_ID = R.INVENTORY_ID
GROUP BY F.TITLE
ORDER BY rental_register;
--volvemos a left join para no perder las películas que nunca se han alquilado.