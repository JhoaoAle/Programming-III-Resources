%A continuacion se presenta una serie de predicados que corresponden a rutas 
%entre diferentes ciudades, junto con el costo de la gasolina requerida para realizar el viaje, 
%en dólares:


/*v1:
conexion(vancouver, edmonton, 16).
conexion(vancouver, calgary, 13).
conexion(vancouver, seattle, 8).
conexion(seattle, portland, 6).
conexion(portland, sanfrancisco, 10).
conexion(sanfrancisco, losangeles, 12).
conexion(losangeles, phoenix, 9).
conexion(phoenix, denver, 14).
conexion(denver, calgary, 18).
conexion(calgary, edmonton, 4).
conexion(portland, losangeles, 15).
conexion(edmonton, portland, 6).

v2:
seattle portland 6
portland sanfrancisco 10

phoenix denver 14
denver calgary 18
calgary edmonton 4

edmonton portland 6
https://csacademy.com/app/graph_editor/
*/
conexion(seattle, portland, 6).
conexion(portland, sanfrancisco, 10).
conexion(phoenix, denver, 14).
conexion(denver, calgary, 18).
conexion(calgary, edmonton, 4).
conexion(edmonton, portland, 6).
/* 
1. Definir el predicado conexion_directa/2 
que sea verdadero si existen ciudades conectadas directamente, independiente de
la dirección de la ruta.
*/

/*
2. Definir el predicado ruta/2 
que sea verdadero si existe un camino (directo o indirecto) entre dos ciudades,
respetando las direcciones existentes.
*/

/*
3. Definir el predicado ruta_distancia/3 
que calcule la distancia total entre dos ciudades.
*/

/* Realizar las consultas que respondan las siguientes preguntas:
 * 1- ¿Existe conexión entre seattle y vancouver?
 * 2- ¿Con qué nodo esta conectado edmonton y cuál es el costo de cada conexión?
 * 3- ¿Es posible viajar desde losangeles a denver?
 * 4- ¿Cuáles son los costos posibles de viajar de portland a calgary?
 */


% Direct connection rule
ruta(X, Y) :- 
    conexion(X, Y, _).

% Indirect connection rule 
ruta(X, Y) :-
	conexion(X,Z,_),
    ruta(Z,Y),
    !.

/*
 * 2- Definir el predicado es_triangular/1 que sea verdadero si un número 
N dado es un número triangular, empleando recursividad
Un número triangular es aquel que cumple con la propiedad de construir un
triángulo

Ejemplo: 1 - *
3-
 *
 **
 
 6-
 *
 **
 ***
 
 10-
 *
 **
 ***
 ****
 
 Pista: Se puede utilizar un predicado aux/2.
 * /