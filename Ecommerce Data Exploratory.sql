-- 1.	Cari produk dengan msrp paling tinggi 
-- Jangan hanya menunjukkan harga, tapi infokan juga tentang produknya apa
SELECT *
FROM products p
WHERE msrp = (SELECT MAX(msrp) FROM products p);
-- jawaban: Alpine Renault 1300 dengan MSRP


-- 2. Carilah sales_rep_employee_number dengan banyak customer > 3
SELECT c.sales_rep_employee_number , e.first_name , e.last_name , COUNT(customer_number) as total_cust
FROM employees e 
INNER JOIN customers c ON c.sales_rep_employee_number = e.employee_number 
GROUP BY c.sales_rep_employee_number 
HAVING total_cust>3
ORDER BY total_cust DESC


-- 3.	Kota mana yang memiliki banyak order tertinggi?
-- HINT : Gunakan count(distinct nama_kolom) untuk agregasi menghitung 
SELECT c.city , COUNT(DISTINCT o.order_number) as total_order
FROM orders o 
INNER JOIN customers c ON c.customer_number = o.customer_number 
GROUP BY c.city 
ORDER BY total_order DESC 


-- 4. menghitung rataan basket size di setiap kota
-- hitung dulu basket size tiap transaksi 
-- baru dihitung AVG basket size tiap city

-- di bawah ini untuk basket size value (qty x price) --
WITH total_basket_size as (
	SELECT o.order_number, cus.city, od.quantity_ordered*od.price_each as basket_size
	FROM orderdetails od 
	INNER JOIN orders o ON od.order_number = o.order_number
	INNER JOIN customers cus ON o.customer_number = cus.customer_number
	GROUP BY o.order_number, cus.city
		)
SELECT city, AVG(basket_size) as avg_basket_size_value
FROM total_basket_size
GROUP BY city
	

-- di bawah ini untuk basket size unit (total qty saja) --
WITH total_basket_size as (
	SELECT o.order_number, cus.city, SUM(od.quantity_ordered) as basket_size
	FROM orderdetails od 
	INNER JOIN orders o ON od.order_number = o.order_number
	INNER JOIN customers cus ON o.customer_number = cus.customer_number
	GROUP BY o.order_number, cus.city
		)
SELECT city, AVG(basket_size) as avg_basket_size_unit
FROM total_basket_size
GROUP BY city
	
-- WITH untuk cari total basket size per city
	SELECT o.order_number, cus.city, od.quantity_ordered*od.price_each as basket_size, od.quantity_ordered , od.price_each 
	FROM orderdetails od 
	INNER JOIN orders o ON od.order_number = o.order_number
	INNER JOIN customers cus ON o.customer_number = cus.customer_number
	GROUP BY o.order_number, cus.city
	
