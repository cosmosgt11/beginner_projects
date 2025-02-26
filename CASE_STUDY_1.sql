--FLO Verileri üzerinden yapýlan çalýþma.

SELECT * FROM FLO_DATA

--SORU 2: Kaç farklý müþterinin alýþveriþ yaptýðýný gösterecek sorguyu yazýnýz.
SELECT COUNT(DISTINCT(master_id)) CUSTOMER_COUNT FROM FLO_DATA

--SORU 3: Toplam yapýlan alýþveriþ sayýsý ve ciroyu getirecek sorguyu yazýnýz.
SELECT 
SUM(order_num_total_ever_offline + order_num_total_ever_online) TOTALSALE,
SUM(customer_value_total_ever_online + customer_value_total_ever_offline) TOTALVALUE
FROM FLO_DATA

--SORU 4: Alýþveriþ baþýna ortalama ciroyu getirecek sorguyu yazýnýz. 
SELECT (SUM(customer_value_total_ever_online + customer_value_total_ever_offline) /
SUM(order_num_total_ever_offline + order_num_total_ever_online)) PRICE_AVG
FROM FLO_DATA

--SORU 5: En son alýþveriþ yapýlan kanal (last_order_channel) üzerinden yapýlan alýþveriþlerin toplam ciro ve alýþveriþ sayýlarýný 
--        getirecek sorguyu yazýnýz.
SELECT last_order_channel,
SUM(customer_value_total_ever_online + customer_value_total_ever_offline) TOTALVALUE,
SUM(order_num_total_ever_offline + order_num_total_ever_online) TOTALSALE
FROM FLO_DATA
GROUP BY last_order_channel
ORDER BY 2

--SORU 6: Store type kýrýlýmýnda elde edilen toplam ciroyu getiren sorguyu yazýnýz. 
SELECT store_type,
SUM(customer_value_total_ever_online + customer_value_total_ever_offline) TOTALVALUE
FROM FLO_DATA
GROUP BY store_type
ORDER BY TOTALVALUE DESC

--SORU 7: Yýl kýrýlýmýnda alýþveriþ sayýlarýný getirecek sorguyu yazýnýz (Yýl olarak müþterinin ilk alýþveriþ tarihi 
--        (first_order_date) yýlýný baz alýnýz)
SELECT DATEPART(YEAR,first_order_date) YEARS,
SUM(order_num_total_ever_offline + order_num_total_ever_online) TOTALSALE
FROM FLO_DATA
GROUP BY DATEPART(YEAR,first_order_date)
ORDER BY 1

--SORU 8: En son alýþveriþ yapýlan kanal kýrýlýmýnda alýþveriþ baþýna ortalama ciroyu hesaplayacak sorguyu yazýnýz. 
SELECT last_order_channel,
(SUM(customer_value_total_ever_online + customer_value_total_ever_offline) /
SUM(order_num_total_ever_offline + order_num_total_ever_online)) PRICE_AVG
FROM FLO_DATA
GROUP BY last_order_channel

--SORU 9: Son 12 ayda en çok ilgi gören kategoriyi getiren sorguyu yazýnýz.
SELECT TOP 1 interested_in_categories_12,
COUNT(interested_in_categories_12) TOTALACCESS
FROM FLO_DATA
GROUP BY interested_in_categories_12
ORDER BY 2 DESC

--SORU 10: En çok tercih edilen store_type bilgisini getiren sorguyu yazýnýz.
SELECT TOP 1 store_type,
COUNT(store_type) MAXSTORE
FROM FLO_DATA
GROUP BY store_type

--SORU 11: En son alýþveriþ yapýlan kanal (last_order_channel) bazýnda, en çok ilgi gören kategoriyi ve bu kategoriden ne kadarlýk 
--         alýþveriþ yapýldýðýný getiren sorguyu yazýnýz.
SELECT TOP 1 last_order_channel,interested_in_categories_12,
COUNT(interested_in_categories_12) CATEGORYACCESS,
SUM(customer_value_total_ever_online + customer_value_total_ever_offline) TOTALVALUE
FROM FLO_DATA
GROUP BY last_order_channel,interested_in_categories_12
ORDER BY 3 DESC

--SORU 12: En çok alýþveriþ yapan kiþinin ID’ sini getiren sorguyu yazýnýz.
SELECT TOP 1 
	master_id
FROM FLO_DATA
GROUP BY master_id
ORDER BY SUM(order_num_total_ever_offline + order_num_total_ever_online) DESC

--SORU 13: En çok alýþveriþ yapan kiþinin alýþveriþ baþýna ortalama cirosunu ve 
--         alýþveriþ yapma gün ortalamasýný (alýþveriþ sýklýðýný) getiren sorguyu yazýnýz. 
SELECT TOP 1 master_id,
(SUM(customer_value_total_ever_online + customer_value_total_ever_offline) /
SUM(order_num_total_ever_offline + order_num_total_ever_online)) PRICE_AVG
FROM FLO_DATA
GROUP BY master_id
ORDER BY SUM(order_num_total_ever_offline + order_num_total_ever_online) DESC

--SORU 14: En çok alýþveriþ yapan (ciro bazýnda) ilk 100 kiþinin alýþveriþ yapma gün ortalamasýný 
--         (alýþveriþ sýklýðýný) getiren sorguyu yazýnýz. 
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

--SORU 15: En son alýþveriþ yapýlan kanal (last_order_channel) kýrýlýmýnda en çok alýþveriþ yapan müþteriyi getiren sorguyu yazýnýz.
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

-- SORU 16: En son alýþveriþ yapan kiþinin ID’ sini getiren sorguyu yazýnýz. 
--          (Max son tarihte birden fazla alýþveriþ yapan ID bulunmakta. Bunlarý da getiriniz.)
SELECT 
	master_id,
	last_order_date
FROM FLO_DATA
WHERE last_order_date = (SELECT MAX(last_order_date) FROM FLO_DATA)


