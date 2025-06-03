--- SQL Practice


--1. Tampilkan First_Name dan Last_Name dari tabel actor
SELECT a.first_name , a.last_name 
FROM Actor a

--2. Tampilkan gabungan First_Name dan Last_Name dengan huruf kecil dan nama kolom actor_name 
-- Gunakan Hint : || untuk menggabungkn 2 kolom. Contoh select a || b 
SELECT Lower (a.first_name || " " || a.last_name) 
FROM Actor a

--3. Kamu mengingat aktor dengan nama depan "JOE". Tampilkan actor_id, first_name dan Last_name orang tersebut
SELECT a.actor_id , a.first_name , a.last_name 
FROM Actor a
WHERE a.first_name = "JOE"

--4. Masih seperti sebelumnya, sekarang cari orang yang nama belakangnya mengendung kata "LI", tetapi coba urutkan
--  berdasarkan nama belakang. Jika ada orang dengan nama belakang sama, prioritaskan dengan nama depan.
SELECT a.actor_id , a.first_name , a.last_name 
FROM Actor a
WHERE a.last_name like "%LI%"
ORDER BY a.last_name , a.first_name 

--5.  Dengan fungsi IN di SQL, Tampilan ID negara Afganistan, Bangladesh, dan China
SELECT c.country_id , c.country 
FROM Country c
WHERE c.country  IN ('Afganistan', 'Bangladesh', 'China')

--6. Tampilkan semua nama belakang aktor dan juga hitung ada berapa banyak aktor dengan nama belakang tersebut.
SELECT a.last_name , COUNT (a.last_name )
FROM Actor a
GROUP BY a.last_name 

--7. Sama seperti nomor 6, akan tetapi sekarang buang nama belaang aktor yang hanya dimiliki 1 orang.
SELECT a.last_name , COUNT (a.last_name) as count_actor
FROM Actor a
GROUP BY a.last_name 
HAVING count_actor >1

--8. cari nama depan, nama belakang dan alamat dari setiap member. Gunakan tabel staff dan address.
SELECT s.first_name , s.last_name , address 
FROM staff s
LEFT JOIN address a  
ON s.address_id = a.address_id  

--9. Cari berapa banyak penjualan (amount) yang berhasil dibuat setiap staff_member pada bulan agustus 2005.
-- Gunakan tabel staff dan payment.
SELECT s.staff_id , Sum(amount)
FROM staff s Left JOIN payment p 
ON s.staff_id  = p.staff_id
WHERE p.payment_date >= "2005-08-01" and p.payment_date <="2005-09-01"
GROUP BY s.staff_id 

--10. Tampilkan judul film dan berapa banyak aktor yang ada di setiap film.
SELECT title, count(actor_id)
FROM film f inner join film_actor fa 
ON f.film_id = fa.film_id 
GROUP BY title 

--11. Cari informasi customer dan berapa  banyak biaya yang dikeluarkan oleh setip customer.
--   urutkan hasil pencarian berdasarkan nama belakang customer secara abjad.
SELECT c.customer_id ,last_name, sum(amount)
FROM customer c Left join payment p 
ON c.customer_id = p.payment_id 
GROUP BY c.customer_id 
ORDER BY last_name 

--12. Perusahaan ingin membuat marketing campaign melalui email di Kanada. 
--   Cari semua email yang berasal di Kanada. Gunakan CTE jika bisa
WITH  location_info AS (
	SELECT address_id, a.city_id, c.country_id, city, country
	FROM address a INNER JOIN city c ON a.address_id = c.city_id
	INNER JOIN  country c2 ON c.city_id = c2.country_id 
)
SELECT email 
FROM customer c 
WHERE address_id IN (SELECT address_id FROM location_info WHERE country = 'Canada')

--13. Tampilkan nama film yang paling sering disewa / dirental dan urutkan yang paaling populer.
SELECT f.title as film_title, COUNT (rental_id)
FROM rental r INNER JOIN inventory i ON r.inventory_id = i.inventory_id 
INNER JOIN film f ON f.film_id = i.film_id 
GROUP BY f.film_id 
ORDER BY count(rental_id) DESC 

--14. Buat query yang menunjukkan berapa banyak revenue (amount) yang diperoleh masing-masing toko.
SELECT s.store_id,sum(amount) AS total_revenue
FROM payment p INNER JOIN rental r ON p.rental_id = r.rental_id
INNER JOIN inventory i ON i.inventory_id = r.inventory_id
INNER JOIN store s ON s.store_id = i.store_id 
GROUP BY s.store_id 

--15. Carilah 5 genre film dengan gross revenue tertinggi, diurutkan dari yang paling laku terlebih dahulu.
--   Hint : Genre terdapat di tabel film_category
SELECT c.name as genre, SUM(amount) AS gross_revenue
FROM payment p LEFT JOIN rental r ON p.rental_id = r.rental_id 
LEFT JOIN inventory i ON i.inventory_id = r.inventory_id 
LEFT JOIN film f ON f.film_id = i.inventory_id 
LEFT JOIN film_category fc ON fc.film_id = i.film_id 
LEFT JOIN category c ON c.category_id = fc.category_id 
GROUP BY genre 
ORDER BY gross_revenue DESC 
LIMIT 5

