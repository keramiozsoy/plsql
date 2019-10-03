# plsql

Plsql kısaltmasının açılımı şu şekildedir.

```
procedural language extension to structured query language
```

## Konu 1

herhangi bir ismi olmayan begin ile başlayıp end ile biten yapılardır
sql bir dil değil motordur. veri manipulasyonu yapılır.
plsql bir dildir. uygulamalar geliştirilir.
sql ifadelerimiz sql motoruna plsql ifadelerimiz plsql motoruna gönderilerek çalıştırılır.

bu blok çalıştıktan sonra hiç bir yerde saklanmaz.
plsql çıktısını görmek için aşağıdaki komutunu veriyoruz.

-- çıktı gösteren bir block yazalım
```
SET serveroutput ON;

BEGIN
	dbms_output.put_line('plsql e baslangic yaptik.');
END;
```


## Konu 2 
degisken tanımlama ve deger atamak
DECLARE kısmında değişken tanımlama yapılır.
:= şeklinde deger atama yapıyoruz.

```
DECLARE
	l_emp_no NUMBER;  -- number da boyut vermek zorunlu değildir fakat verilebilir.  
	l_emp_name varchar2(50); -- varchar da boyut vermek zorundayız vermezsek otomatik boyutunu alır 4k
	l_emp_surname varchar2(30) DEFAULT 'STEVEN';  -- Oluştururken otomatik atama yapıldı.
	l_hire_date DATE DEFAULT sysdate; 
BEGIN
	dbms_output.put_line('-------');
	
	l_emp_no := 20;
	dbms_output.put_line(l_emp_no);  -- burada otomatik implicit converter çalıştır. to_char(l_emp_no) şeklinde yaptı.
	
	l_emp_name := 'DAVID';
 	dbms_output.put_line(l_emp_name);
 	
 	dbms_output.put_line(l_emp_surname);
 	
 	dbms_output.put_line(l_hire_date);
 	l_hire_date := TO_DATE('01.01.2018','dd.mm.yyyy');
 	dbms_output.put_line(l_hire_date);
END;
```

## Konu 3
  degisken isimlendirme standartı oluşturabiliririz.
```
 l_emp_no     -- l lokal değişken 
 lv_emp_name  -- l lokal , v varchar 
 ld_hire_date -- l lokal , d date
```
