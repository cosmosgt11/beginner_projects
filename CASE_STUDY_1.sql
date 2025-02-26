--FLO Verileri �zerinden yap�lan �al��ma.

SELECT * FROM FLO_DATA

--SORU 2: Ka� farkl� m��terinin al��veri� yapt���n� g�sterecek sorguyu yaz�n�z.
SELECT COUNT(DISTINCT(master_id)) CUSTOMER_COUNT FROM FLO_DATA

--SORU 3: Toplam yap�lan al��veri� say�s� ve ciroyu getirecek sorguyu yaz�n�z.
SELECT 
SUM(order_num_total_ever_offline + order_num_total_ever_online) TOTALSALE,
SUM(customer_value_total_ever_online + customer_value_total_ever_offline) TOTALVALUE
FROM FLO_DATA

--SORU 4: Al��veri� ba��na ortalama ciroyu getirecek sorguyu yaz�n�z. 
SELECT (SUM(customer_value_total_ever_online + customer_value_total_ever_offline) /
SUM(order_num_total_ever_offline + order_num_total_ever_online)) PRICE_AVG
FROM FLO_DATA

--SORU 5: En son al��veri� yap�lan kanal (last_order_channel) �zerinden yap�lan al��veri�lerin toplam ciro ve al��veri� say�lar�n� 
--        getirecek sorguyu yaz�n�z.
SELECT last_order_channel,
SUM(customer_value_total_ever_online + customer_value_total_ever_offline) TOTALVALUE,
SUM(order_num_total_ever_offline + order_num_total_ever_online) TOTALSALE
FROM FLO_DATA
GROUP BY last_order_channel
ORDER BY 2

--SORU 6: Store type k�r�l�m�nda elde edilen toplam ciroyu getiren sorguyu yaz�n�z. 
SELECT store_type,
SUM(customer_value_total_ever_online + customer_value_total_ever_offline) TOTALVALUE
FROM FLO_DATA
GROUP BY store_type
ORDER BY TOTALVALUE DESC

--SORU 7: Y�l k�r�l�m�nda al��veri� say�lar�n� getirecek sorguyu yaz�n�z (Y�l olarak m��terinin ilk al��veri� tarihi 
--        (first_order_date) y�l�n� baz al�n�z)
SELECT DATEPART(YEAR,first_order_date) YEARS,
SUM(order_num_total_ever_offline + order_num_total_ever_online) TOTALSALE
FROM FLO_DATA
GROUP BY DATEPART(YEAR,first_order_date)
ORDER BY 1

--SORU 8: En son al��veri� yap�lan kanal k�r�l�m�nda al��veri� ba��na ortalama ciroyu hesaplayacak sorguyu yaz�n�z. 
SELECT last_order_channel,
(SUM(customer_value_total_ever_online + customer_value_total_ever_offline) /
SUM(order_num_total_ever_offline + order_num_total_ever_online)) PRICE_AVG
FROM FLO_DATA
GROUP BY last_order_channel

--SORU 9: Son 12 ayda en �ok ilgi g�ren kategoriyi getiren sorguyu yaz�n�z.
SELECT TOP 1 interested_in_categories_12,
COUNT(interested_in_categories_12) TOTALACCESS
FROM FLO_DATA
GROUP BY interested_in_categories_12
ORDER BY 2 DESC

--SORU 10: En �ok tercih edilen store_type bilgisini getiren sorguyu yaz�n�z.
SELECT TOP 1 store_type,
COUNT(store_type) MAXSTORE
FROM FLO_DATA
GROUP BY store_type

--SORU 11: En son al��veri� yap�lan kanal (last_order_channel) baz�nda, en �ok ilgi g�ren kategoriyi ve bu kategoriden ne kadarl�k 
--         al��veri� yap�ld���n� getiren sorguyu yaz�n�z.
SELECT TOP 1 last_order_channel,interested_in_categories_12,
COUNT(interested_in_categories_12) CATEGORYACCESS,
SUM(customer_value_total_ever_online + customer_value_total_ever_offline) TOTALVALUE
FROM FLO_DATA
GROUP BY last_order_channel,interested_in_categories_12
ORDER BY 3 DESC

--SORU 12: En �ok al��veri� yapan ki�inin ID� sini getiren sorguyu yaz�n�z.
SELECT TOP 1 
	master_id
FROM FLO_DATA
GROUP BY master_id
ORDER BY SUM(order_num_total_ever_offline + order_num_total_ever_online) DESC

--SORU 13: En �ok al��veri� yapan ki�inin al��veri� ba��na ortalama cirosunu ve 
--         al��veri� yapma g�n ortalamas�n� (al��veri� s�kl���n�) getiren sorguyu yaz�n�z. 
SELECT TOP 1 master_id,
(SUM(customer_value_total_ever_online + customer_value_total_ever_offline) /
SUM(order_num_total_ever_offline + order_num_total_ever_online)) PRICE_AVG
FROM FLO_DATA
GROUP BY master_id
ORDER BY SUM(order_num_total_ever_offline + order_num_total_ever_online) DESC

--SORU 14: En �ok al��veri� yapan (ciro baz�nda) ilk 100 ki�inin al��veri� yapma g�n ortalamas�n� 
--         (al��veri� s�kl���n�) getiren sorguyu yaz�n�z. 
SELECT 
	D.master_id,
	D.TOPLAM_CIRO,
	D.TOPLAM_SIPARIS_SAYISI,
	(D.TOPLAM_CIRO / D.TOPLAM_SIPARIS_SAYISI) SIPARIS_BASINA_ORT
	DATEDIFF(DAY,first_order_date,last_order_date) ILK_VS_SON_GUN_FARKI
	(DATEDIFF(DAY,first_order_date,last_order_date) / D.TOPLAM_SIPARIS_SAYISI) GUN_ORT
FROM
	(
	SELECT TOP 100 
		master_id,
		first_order_date,
		last_order_date,
		SUM(customer_value_total_ever_online + customer_value_total_ever_offline) TOPLAM_CIRO,
		SUM(order_num_total_ever_offline + order_num_total_ever_online) TOPLAM_SIPARIS_SAYISI
	FROM FLO_DATA
	GROUP BY master_id,first_order_date,last_order_date
	ORDER BY TOPLAM_CIRO DESC 
	) D;

--SORU 15: En son al��veri� yap�lan kanal (last_order_channel) k�r�l�m�nda en �ok al��veri� yapan m��teriyi getiren sorguyu yaz�n�z.
SELECT DISTINCT last_order_channel,
	( 
	SELECT TOP 1
		master_id
	FROM FLO_DATA WHERE last_order_channel=F.last_order_channel
	GROUP BY master_id
	ORDER BY SUM(customer_value_total_ever_online + customer_value_total_ever_offline) DESC) EN_COK_ALISVERIS_YAPAN,
	( 
	SELECT TOP 1 
		SUM(customer_value_total_ever_online + customer_value_total_ever_offline)
	FROM FLO_DATA WHERE last_order_channel=F.last_order_channel
	GROUP BY master_id
	ORDER BY SUM(customer_value_total_ever_online + customer_value_total_ever_offline) DESC
	) CIRO
FROM FLO_DATA F;

-- SORU 16: En son al��veri� yapan ki�inin ID� sini getiren sorguyu yaz�n�z. 
--          (Max son tarihte birden fazla al��veri� yapan ID bulunmakta. Bunlar� da getiriniz.)
SELECT 
	master_id,
	last_order_date
FROM FLO_DATA
WHERE last_order_date = (SELECT MAX(last_order_date) FROM FLO_DATA)


