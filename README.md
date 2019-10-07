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

## Konu 4
 Tablodaki alanların tipini bilmeden değişken oluşturmak
 Tablodaki alanın tipi ne ise değişkenin tipi otomatik o yapılmış oluyor.
 Tablodaki alan tipleri var, degisken tipleri var. Bu ikisi aynı olabilir.
 
``` 
DECLARE
	ln_emp_no employees.employee_id%TYPE;
	ld_hire_date employees.hire_date%TYPE;
BEGIN
	dbms_output.put_line('----');
	ln_emp_no := 11;
	ld_hire_date := SYSDATE;

	dbms_output.put_line(ln_emp_no);
	dbms_output.put_line(ld_hire_date);
END;
```

## Konu 5

anonymous block içinde block kullanımı
istenildigi kadar iç içe kullanılabilir.

```
DECLARE
	l_var_1 NUMBER DEFAULT 10;
	l_var_2 NUMBER DEFAULT 20;
	l_result NUMBER;
BEGIN
	dbms_output.put_line(' ----- ');
	l_result := l_var_1 * l_var_2;
	dbms_output.put_line(l_result);
	DECLARE
		l_var_3 NUMBER DEFAULT 30;
	BEGIN
		dbms_output.put_line(l_var_3);
	END ;

END isim_verdim_adi_dis_blok_olsun;
```


## Konu 6 
-- into kullanımı

-- sorguların sonucunu alıp kullanmak için kullanırız

-- NOT 
-- plsql içinde sql çalıştırıldığında dönen değeri tutacak bir yer yoktur.
-- Bu nedenle dönen değeri bir değişkene veya bir collection a atmalıyız ki kullanabilelim.
-- deneyip hatayı alalım.
```
BEGIN
	SELECT * FROM DEPARTMENTS;
END;
```


## Konu 7
into kullanımı

```
CREATE SEQUENCE testseq;

SELECT * FROM DEPARTMENTS;


DECLARE 
	dept_no DEPARTMENTS.department_id%TYPE;
BEGIN
	SELECT testseq.nextval 
		INTO dept_no
	FROM dual;
	
	dbms_output.put_line('---');
	dbms_output.put_line(dept_no);
END;

DROP SEQUENCE testseq;
```

## Konu 8

Tek kayıt veya tek alan getiren sorguların sonucunu bir değişkene atayabiliyoruz.Çok kayıt gelirse hata alırız.

```
DECLARE
	v_1 NUMBER;
	v_2 NUMBER;
	v_3 NUMBER;
BEGIN
	SELECT 1,2,3
	   INTO v_1,v_2,v_3
	FROM dual;

	dbms_output.put_line(v_1 ||'-'|| v_2 ||'-'||v_3 );
END;

```
