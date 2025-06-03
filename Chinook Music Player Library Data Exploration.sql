--1 Basic selection
SELECT email, phone 
FROM Customer c 

--2 menggunakan filter
SELECT FirstName, LastName, email
FROM Customer c 
WHERE  c.CountrY  != 'Brazil'

--3 Mengurutka data
SELECT FirstName, BirthDate
FROM Employee e 
ORDER BY BirthDate DESC 

--4 Limit 
SELECT *
FROM Employee e 
LIMIT 2

--5 Menggunakan Alias
SELECT FirstName as NamaDepan
FROM Employee

--Challenge
 --Buat query untuk mengambil nama depan, nama belakng customer
SELECT c.FirstName , c.LastName 
FROM Customer c  

--Buat query mengambil seluruh informasi karyawan yang title nya IT Staff
SELECT *
FROM Employee e 
WHERE Title = 'IT Staff'

-- Function
SELECT MAX (UnitPrice)
FROM Track t 

SELECT MIN (UnitPrice)
FROM Track t 

--Aggregation 
--Berapa rata-rata harga track yang dijual 
--per komposer
SELECT Composer, AVG(UnitPrice) as HargaRataan
FROM Track t 
GROUP BY Composer
ORDER BY 2

--Case when
SELECT
	customerID,	
	Country,
	CASE
		Country
	WHEN 'USA' THEN 'Domestic'
		ELSE 'Foreign'
	END AS CustomerGroup
FROM
	Customer c

-- Challenge
--Buat query yang menunjukkan banyaknya invoice berdasarkan BillingCountry
--Count
SELECT BillingCountry, Count(InvoiceID) AS Jumlah
FROM Invoice i 
GROUP BY BillingCountry

--Contoh pemakaian function Where dan Having
SELECT InvoiceID, SUM(Quantity)
FROM InvoiceLine il 
GROUP BY InvoiceID 

--kalau mau pakai where seperti ini
SELECT InvoiceID, SUM(Quantity)
FROM InvoiceLine il
WHERE 
GROUP BY InvoiceID 

--misalnya mau cari nilai yang nilai diatas 10
SELECT InvoiceID, SUM(Quantity)
FROM InvoiceLine il 
GROUP BY InvoiceID 
HAVING SUM(Quantity) > 10

--Kalau mau pakai alias spt ini
SELECT InvoiceID, SUM(Quantity) AS sum_qty
FROM InvoiceLine il 
GROUP BY InvoiceID 
HAVING sum_qty > 10

--Function dari Primary Key dan Foreign Key
--Contoh penggabungan 2 tabel
SELECT *
FROM Album alb INNER JOIN  Artist art 
	ON alb.ArtistID = art.ArtistID
WHERE art.Name = 'Aerosmith'

--Contoh penggabungan 3 tabel
SELECT *
FROM Track AS tr
	LEFT JOIN Album AS al ON tr.AlbumId =  al.AlbumId  
LEFT JOIN Artist ar ON ar.ArtistId = al.ArtistId 

--Practice Question 
--Buatlah Query yang menunjukkan InvoiceID + sales agent (employee)
--terurut berdasarkan nama agent (employee)
SELECT inv.InvoiceId, emp.FirstName 
FROM Invoice inv  
	LEFT JOIN Customer cus
	ON inv.CustomerId = cus.CustomerId 
	LEFT JOIN Employee emp
	ON cus.SupportRepId = emp.EmployeeId 
ORDER BY emp.FirstName 

-- Row Wise Table Combination: menggabungkan data berdasarkan baris
-- contoh kasus: Artist mengandung nama John
-- Tracknya mengandung nama hop
SELECT Name, "Artist" as Entity
FROM Artist a 
WHERE Name LIKE "%john%"
UNION 
SELECT Name, "Track" as Entity
FROM Track t 
WHERE Name LIKE "%hop%"
-- menggunakan UNION / INTERSECT / EXCEPT -> kolomnya harus sama

-- Challenge: tampilkan nama depan customer yang bukan nama depan employee
-- hint: gunakan except
SELECT FirstName FROM Customer c 
EXCEPT
SELECT FirstName FROM Employee e 

-- 5.4.7 CTE Subquery
-- Ambil semua track dengan genre rock
SELECT * FROM Track WHERE GenreID in
(SELECT GenreID
FROM Genre
WHERE Name = 'Rock'
)

-- Cari agent yang pernah melayani top 5 customer dengan total spending paling banyak

-- Pendekatan 1, Sub query
-- agen yang melayani top 5 customer di bawah
SELECT SupportRepId, top_spender.CustomerId
FROM Customer c 
RIGHT JOIN
-- Subquery = top 5 customer dengan spending terbanyak-- 
	(SELECT CustomerId, SUM(Total) as total_spending
	FROM Invoice i 
	GROUP BY CustomerId
	ORDER BY total_spending DESC 
	LIMIT 5) as top_spender
ON c.CustomerId = top_spender.CustomerId

-- Pendekatan 2, CTE
WITH top_spender AS(
	SELECT i.CustomerId, SUM(Total) AS total_spending
	FROM Invoice i 
	GROUP BY i.CustomerId 
	ORDER BY total_spending DESC 
	LIMIT 5
	)
SELECT SupportRepId, top_spender.CustomerId
FROM Customer c 
RIGHT JOIN top_spender ON c.CustomerId = top_spender.CustomerId

-- WHERE = filter ke kolom asli
-- HAVING = filter hasil agregasi (sum, avg, min, max, etc..)


-- Mencari judul lagu yang diawali dengan huruf 'g' dan nama composernya mengandung huruf 'a' 
SELECT name, composer
FROM Track t 
WHERE composer IS NOT NULL
AND name LIKE 'g%' OR composer LIKE '%a'
ORDER BY composer DESC

-- Mencari CustomerId dan negara asal customer beserta total dan rata-rata pembelian selama tahun 2011
SELECT 
CustomerId, 
BillingCountry, 
SUM(Total) AS total_pembelian,
AVG(Total) AS rata_pembelian
FROM Invoice i 
WHERE InvoiceDate <= '2011-12-31' AND InvoiceDate >= '2011-01-01'
GROUP BY 1,2
HAVING AVG(Total) > 5