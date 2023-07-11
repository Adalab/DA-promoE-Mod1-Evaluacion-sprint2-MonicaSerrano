/*EVALUACION SQL MODULO 1 SPRINT 2*/

/*Selecciona todos los campos de los productos, que pertenezcan a los proveedores con códigos: 1, 3, 7, 8 y 9, que tengan stock en el almacén, y al mismo tiempo que sus 
precios unitarios estén entre 50 y 100. Por último, ordena los resultados por código de proveedor de forma ascendente.*/

SELECT *
FROM `products`
WHERE `supplier_id` IN (1,3,7,8,9) AND `units_in_stock` > 0 AND `unit_price` BETWEEN 50 AND 100
ORDER BY `supplier_id`;

-- No se puede utilizar un BETWEEN en `supplier_id` porque no es un rango.

/*Devuelve el nombre y apellidos y el id de los empleados con códigos entre el 3 y el 6, además que hayan vendido a clientes que tengan códigos que comiencen con las letras 
de la A hasta la G. Por último, en esta búsqueda queremos filtrar solo por aquellos envíos que la fecha de pedido este comprendida entre el 22 y el 31 de Diciembre de 
cualquier año.*/

SELECT DISTINCT `employees`.`first_name`,`employees`.`last_name`,`employees`.`employee_id`
FROM `employees`
INNER JOIN `orders` ON `employees`.`employee_id` = `orders`.`employee_id`
WHERE `orders`.`employee_id` IN (3,4,5,6) AND `orders`.`customer_id` REGEXP '^[A-G]' AND MONTH(`orders`.`order_date`) = 12 AND DAY(`orders`.`order_date`) BETWEEN 22 AND 31;

-- Se podría utilizar un rango en `orders`.`employee_id` pero se ha puesto así para mostrar las diferentes formas de hacerlo ya que en DAY se ha utilizar un BETWEEN.

/*Calcula el precio de venta de cada pedido una vez aplicado el descuento. Muestra el id del la orden, el id del producto, el nombre del producto, el precio unitario, la 
cantidad, el descuento y el precio de venta después de haber aplicado el descuento.*/

SELECT `order_details`.*,`products`.`product_name`,(`order_details`.`unit_price`* `order_details`.`quantity` * (1 - `order_details`.`discount`)) AS `precio_venta`
FROM `order_details`
INNER JOIN `products` ON `products`.`product_id` = `order_details`.`product_id`;

-- Se ha entendido en este ejercicio como el precio de venta de cada producto dentro de cada pedido teniendo en cuenta el precio, la cantidad y el descuento.

/*Usando una subconsulta, muestra los productos cuyos precios estén por encima del precio medio total de los productos de la BBDD.*/

SELECT *
FROM `products`
WHERE `unit_price` >(
SELECT AVG(`unit_price`)
FROM `products`);

/*¿Qué productos ha vendido cada empleado y cuál es la cantidad vendida de cada uno de ellos?*/

SELECT `orders`.`employee_id`, `products`.`product_name`,SUM(`order_details`.`quantity`)
FROM `order_details`
INNER JOIN `orders` ON `orders`.`order_id` = `order_details`.`order_id`
INNER JOIN `products` ON `products`.`product_id` = `order_details`.`product_id`
GROUP BY `orders`.`employee_id`, `products`.`product_name`;

-- En este caso se muestra la cantidad que ha vendido cada id_empleado de cada producto.

/*Basándonos en la query anterior, ¿qué empleado es el que vende más productos? Soluciona este ejercicio con una subquery*/

SELECT `subquery`.`empleado`
FROM
(SELECT `orders`.`employee_id` AS `empleado`,SUM(`order_details`.`quantity`) AS `cantidad`
FROM `order_details`
INNER JOIN `orders` ON `orders`.`order_id` = `order_details`.`order_id`
INNER JOIN `products` ON `products`.`product_id` = `order_details`.`product_id`
GROUP BY `orders`.`employee_id`) AS `subquery`
ORDER BY `subquery`.`cantidad` DESC
LIMIT 1;

/*Se ha modificado ligeramente la query anterior para que no haga esa división por producto sino simplemente por empleado para que salga la cantitad total de productos
que ha vendido cada empleado*/

/*BONUS ¿Podríais solucionar este mismo ejercicio con una CTE?*/

WITH `empleado_productos` AS (SELECT `orders`.`employee_id` AS `empleado`,SUM(`order_details`.`quantity`) AS `cantidad`
FROM `order_details`
INNER JOIN `orders` ON `orders`.`order_id` = `order_details`.`order_id`
INNER JOIN `products` ON `products`.`product_id` = `order_details`.`product_id`
GROUP BY `orders`.`employee_id`)

SELECT `empleado`
FROM `empleado_productos`
ORDER BY `cantidad` DESC
LIMIT 1;
