

-- 3. ADIM: ETL SÜRECİ (TRANSFORM & LOAD)


INSERT INTO dbo.Hedef_TemizMusteri (ID, AdSoyad_Temiz, Telefon_Temiz, Eposta_Durumu)
SELECT 
    ID,
    -- 1. İsim Temizleme: Sağ/sol boşlukları al ve tamamen BÜYÜK harf yap
    UPPER(LTRIM(RTRIM(AdSoyad))) AS AdSoyad_Temiz,
    
    -- 2. Telefon Temizleme: Tire ve boşlukları sil, NULL ise standart metin yaz
    ISNULL(REPLACE(REPLACE(Telefon, ' ', ''), '-', ''), 'BİLİNMİYOR') AS Telefon_Temiz,
    
    -- 3. E-posta Kontrolü: @ yoksa veya NULL ise hata etiketle, yoksa küçük harf yap
    CASE 
        WHEN Eposta IS NULL THEN 'EKSİK VERİ'
        WHEN Eposta NOT LIKE '%@%' THEN 'GEÇERSİZ FORMAT'
        ELSE LOWER(Eposta)
    END AS Eposta_Durumu
FROM dbo.Kaynak_Musteri;
GO

-- Temizlenmiş veriyi ekranda görelim:
SELECT * FROM dbo.Hedef_TemizMusteri;
GO