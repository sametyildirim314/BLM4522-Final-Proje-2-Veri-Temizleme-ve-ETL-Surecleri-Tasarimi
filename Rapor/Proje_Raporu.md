**Ders:** Ağ Tabanlı Paralel Dağıtım Sistemleri  
**Proje No:** 5   
**Veritabanı Ortamı:** Microsoft SQL Server (SSMS)  

---

## 1. Projenin Amacı ve Kapsamı
Bu çalışmanın amacı, büyük veri kümelerinin sisteme entegre edilmeden önce temizlenmesi, dönüştürülmesi ve standartlaştırılmasıdır[cite: 53, 54]. ETL (Extract, Transform, Load) mimarisi kullanılarak, dış kaynaklardan gelen tutarsız veriler izole edilmiş ve veri tabanının yapısal kalitesi (Data Integrity) güvence altına alınmıştır[cite: 55].

## 2. Mimari ve Uygulama Adımları

### Adım 1: Extract (Veri Çıkarma ve Hatalı Veri Simülasyonu)
Dış kaynakları simüle etmek amacıyla `Kaynak_Musteri` adında bir tablo oluşturulmuştur. Bu tabloya bilinçli olarak şu hataları barındıran veriler eklenmiştir[cite: 55]:
* **AdSoyad:** Başında ve sonunda gereksiz boşluklar (Whitespace) barındıran, küçük/büyük harf karmaşası olan kayıtlar.
* **Telefon:** İçerisinde harf, tire (-) veya boşluk bulunan standardize edilmemiş numaralar.
* **E-posta:** İçerisinde `@` işareti bulunmayan geçersiz formatlar veya tamamen boş (NULL) bırakılmış alanlar.

### Adım 2: Transform (Veri Dönüştürme ve Standartlaştırma)
Sisteme aktarım yapılmadan önce T-SQL string manipülasyon fonksiyonları kullanılarak dönüşüm (Transformation) kuralları uygulanmıştır[cite: 56, 57]:
* **İsim Standartlaştırma:** `LTRIM` ve `RTRIM` fonksiyonları ile sağ/sol boşluklar silinmiş, `UPPER` fonksiyonu ile tüm isimler büyük harf formatına çevrilmiştir.
* **Telefon Temizleme:** `REPLACE` fonksiyonu iç içe kullanılarak numaralardaki tire ve boşluklar temizlenmiş, sadece rakam kalması sağlanmıştır. Eksik numaralar `ISNULL` ile 'BİLİNMİYOR' olarak etiketlenmiştir.
* **E-posta Doğrulama:** `CASE WHEN` yapısı kullanılarak verinin içinde `%@%` deseni (pattern) aranmıştır. Kurala uymayanlar 'GEÇERSİZ FORMAT', boş olanlar 'EKSİK VERİ' olarak etiketlenirken, geçerli olanlar `LOWER` ile küçük harfe çevrilmiştir.

### Adım 3: Load (Hedef Sisteme Yükleme)
Dönüşüm işlemleri biten veriler, sistemde asıl kullanılacak olan `Hedef_TemizMusteri` tablosuna `INSERT INTO ... SELECT` yöntemiyle tek bir transaction bloğu halinde (Bulk Load) yüklenmiştir[cite: 58].

### Adım 4: Veri Kalitesi Raporlaması
ETL süreci tamamlandıktan sonra, yöneticileri bilgilendirmek amacıyla bir Veri Kalite Raporu (Data Quality Report) oluşturulmuştur[cite: 58]. `UNION ALL` kullanılarak elde edilen bu raporda;
* Toplam işlenen müşteri sayısı,
* Eksik veya geçersiz e-posta adresi sayısı,
* Telefon bilgisi bulunmayan kayıtların toplamı sayısal metrikler halinde sunulmuştur.

---

## 3. Sonuç
Geliştirilen bu ETL süreci sayesinde, sisteme girebilecek olan hatalı verilerin (Dirty Data) önüne geçilmiştir. SQL tabanlı veri temizleme teknikleri kullanılarak veri bütünlüğü sağlanmış ve ileriye dönük yaşanabilecek olası raporlama hataları engellenmiştir.