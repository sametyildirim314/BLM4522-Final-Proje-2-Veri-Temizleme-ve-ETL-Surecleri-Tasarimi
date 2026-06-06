


-- 4. ADIM: VERİ KALİTESİ RAPORU

-- PDF İsteri: Veri kalitesi raporlarının oluşturulması
SELECT 'Toplam İşlenen Müşteri' AS Metrik, COUNT(*) AS Deger FROM dbo.Hedef_TemizMusteri
UNION ALL
SELECT 'Eksik veya Geçersiz E-posta Sayısı', COUNT(*) FROM dbo.Hedef_TemizMusteri WHERE Eposta_Durumu IN ('EKSİK VERİ', 'GEÇERSİZ FORMAT')
UNION ALL
SELECT 'Telefon Bilgisi Olmayanlar', COUNT(*) FROM dbo.Hedef_TemizMusteri WHERE Telefon_Temiz = 'BİLİNMİYOR';
GO