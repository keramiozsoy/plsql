# plsql

plsql öğrenmeye çalışalım 

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
plsql çıktısını görmek için aşağıdaki komutunu vermeliyiz. Ardından çıktı gösteren bir block yazalım.
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

into kullanımı

-- sorguların sonucunu alıp kullanmak için kullanırız

```
NOT 
-- plsql içinde sql çalıştırıldığında dönen değeri tutacak bir yer yoktur.
-- Bu nedenle dönen değeri bir değişkene veya bir collection a atmalıyız ki kullanabilelim.
-- deneyip hatayı alalım.
```

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

## Konu 9

 kontrol yapıları

-- if elsif else

```
DECLARE
	ln_emp_count NUMBER ;
BEGIN
	
	SELECT count(*)
		INTO ln_emp_count
	FROM
	EMPLOYEES;
	
	IF  ln_emp_count < 20
		THEN
			dbms_output.put_line('20 den az çalısan var');
	ELSIF ln_emp_count BETWEEN 21 AND 50
		THEN
			dbms_output.put_line('20 ile 50 arasında çalışan var');
	ELSE
			dbms_output.put_line('50  den fazla çalışan var');
	END IF;
END;
```

## konu 10

-- CASE WHEN yapısı
-- hem plsql de hemde sql de case when yapısı mevcut. 
-- sql de case when
```
SELECT e.employee_id,
  CASE e.first_name 
       WHEN 'Steven' THEN 'user is GOOD'
       WHEN 'Neena' THEN 'user is BAD..'
       WHEN 'Lex' THEN 'user is AWESOME..'
       ELSE 'user UNKNOWN'
  END case_kolonu
FROM EMPLOYEES e ORDER BY e.EMPLOYEE_ID;
```
-- sql de decode
-- sadece sql de kullanıllr plsql de kullanılmaz. case when daha hızlı ve performanslıdır.
-- sadece eşitir işlemi yapılabilir ,büyük küçük gibi karşılaştırmalar yapılamaz.
```
SELECT e.employee_id,
  DECODE( e.first_name ,
        'Steven' , 'user is GOOD' ,
       	 'Neena' , 'user is BAD..' , 
       	 'Lex' , 'user is AWESOME..',
       	 'user UNKNOWN' ) case_kolonu
FROM EMPLOYEES e ORDER BY e.EMPLOYEE_ID;
```

-- plsql de case when
```
DECLARE
	ln_job_count NUMBER ;
	lv_result varchar(50);
BEGIN
	
	SELECT count(*)
		INTO ln_job_count
	FROM JOBS;
	
	
	lv_result := CASE 
			WHEN ln_job_count = 4 AND  ln_job_count <= 10--BETWEEN 4 AND 10	
				THEN '4 ile 10 tane iş var'
			ELSE '10  den fazla iş var'
			END;
	dbms_output.put_line(lv_result);
END;
```

## konu 11
* bir tavsiye loop içine insert update delete yazmaktan, fonksiyon çağırmaktan olabildiğince kaçmalıyız :)
* peki kullanmaktan kaçamadım o zaman ise döngü bir kere çalışacak şekilde tasarlamalıyız.
* döngü içinde döngü zaten hiç kullanmayın. 
* bir veriyi doldurmak istiyorsak mutlaka sql ile doldurmalıyız loop ile döngü doldurulursa performans kaybıdır.


## konu 11.1 döngüler
* loop konusu (TERCIH EDILEN)
* programlamada do..while gibi çalışır. 
* loop içinde sql yazılmaz... yazılabilir fakat best practice değildir.

```
DECLARE
	ln_result NUMBER DEFAULT 0;
BEGIN
	LOOP
			ln_result := ln_result + 1;
			BEGIN
				dbms_output.put_line(TO_CHAR(ln_result));
			END;
			
		EXIT WHEN ln_result = 5; -- loop tan çıkmak için kural
	END LOOP;
END;
```

-- while..loop konusu (EN AZ TERCIH EDILEN)
-- programlamada while gibi çalışır.

```
DECLARE
	ln_result NUMBER DEFAULT 0;
BEGIN
    WHILE ln_result > ' || SQL%ROWCOUNT);
    END IF;

   lb_cursor_status :=	SQL%ISOPEN;
	
   IF  sql%FOUND = lb_cursor_status
	THEN
		dbms_output.put_line('CURSOR ACIK');
	ELSIF sql%NOTFOUND = lb_cursor_status
		THEN
			dbms_output.put_line('CURSOR KAPALI');
   END IF;

END;

```

## 12 Explicit Cursor

-- implicit cursor kullanmak istemeyip kendimiz de cursor tanımlıyabiliyoruz.

-- Çıktı olarak sadece bir satır veri alabildik.
-- Çünkü cursor bir satırı temsil edebiliyordu :)

```
 DECLARE
 	CURSOR my_cursor
 	IS
 		SELECT * FROM DEPARTMENTS ORDER BY DEPARTMENT_ID DESC;
 	
 	dept_rec departments%ROWTYPE;
 
 BEGIN 
	 OPEN my_cursor;
			FETCH my_cursor INTO dept_rec;
			dbms_output.put_line(dept_rec.department_name);  
	 CLOSE my_cursor;
 END;
```


-- cursor açık mı kapalı mı öğrenelim.

```
 DECLARE
 	CURSOR my_cursor
 	IS
 		SELECT * FROM DEPARTMENTS ORDER BY DEPARTMENT_ID DESC;
 	
 	dept_rec departments%ROWTYPE;
 
 	lb_cursor_status BOOLEAN;
 BEGIN 
	 
			lb_cursor_status :=	my_cursor%ISOPEN;
			 
		 	IF  lb_cursor_status
				THEN
					dbms_output.put_line('KONTROL 1 - CURSOR ACIK');
			ELSE 
					dbms_output.put_line('KONTROL 1 - CURSOR KAPALI');
			END IF;
	 	
	 OPEN my_cursor;
					
			lb_cursor_status :=	my_cursor%ISOPEN;
	
			IF  lb_cursor_status
				THEN
						dbms_output.put_line('KONTROL 2 - CURSOR ACIK');
				ELSE
						dbms_output.put_line('KONTROL 2 - CURSOR KAPALI');
				END IF;
		
	 FETCH my_cursor INTO dept_rec;
		
			lb_cursor_status :=	my_cursor%ISOPEN;
	
				IF  lb_cursor_status
					THEN
						dbms_output.put_line('KONTROL 3 - CURSOR ACIK');
					ELSE
						dbms_output.put_line('KONTROL 3 - CURSOR KAPALI');
					END IF;
				
	 	dbms_output.put_line(dept_rec.department_name);
		
	 CLOSE my_cursor;
	
			lb_cursor_status :=	my_cursor%ISOPEN;
	
				IF  lb_cursor_status
					THEN
						dbms_output.put_line('KONTROL 4 - CURSOR ACIK');
					ELSE
						dbms_output.put_line('KONTROL 4 - CURSOR KAPALI');
					END IF;
	 END;
```


-- cursor dan tüm tablodaki veriyi alabilmek.

-- loop

```
 DECLARE
 	CURSOR my_cursor
 	IS
 		SELECT * FROM DEPARTMENTS ORDER BY DEPARTMENT_ID DESC;
 	
 	dept_rec departments%ROWTYPE; -- departments tablosundaki bir satıra karşılık gelen record tanımladık.
 
 BEGIN
	 OPEN my_cursor;
		LOOP	
			FETCH my_cursor INTO dept_rec;
		
			dbms_output.put_line(dept_rec.department_name);
			dbms_output.put_line(my_cursor%ROWCOUNT); --cursorun şuan kaçıncı elemanındayım.
			EXIT WHEN my_cursor%NOTFOUND; -- cursor da eleman kalmadığında otomatik loop dan çıkış yapıyoruz.
		END LOOP;
	 CLOSE my_cursor;
 END;
``` 


-- cursor dan tüm tablodaki veriyi alabilmek. (CURSOR HIZLI KULLANIM)
-- FOR
-- FETCH yok, OPEN yok , CLOSE yok 
```
DECLARE
 	CURSOR my_cursor
 	IS
 		SELECT * FROM DEPARTMENTS ORDER BY DEPARTMENT_ID DESC;
 
 BEGIN
	 FOR i_record IN my_cursor  -- oracle tarafından otomatik %ROWTYPE record oluşturulmuş olunur. 
	 LOOP
	 	dbms_output.put_line(i_record.department_name);
	 END LOOP;
 END;
```

-- cursor a parametre göndermek.
-- cursor kullanıldığında sadece sorgulanmış veriler doludur.
```
DECLARE
	CURSOR my_cursor(p_location_id number)
	IS
 		SELECT * FROM DEPARTMENTS
 		WHERE LOCATION_ID = p_location_id
 		ORDER BY DEPARTMENT_ID DESC;
BEGIN
	 FOR i_record IN my_cursor(1700) -- örnek olması için parametreyi elimle verdim. 
	 LOOP
	 	dbms_output.put_line(i_record.department_name);
	 END LOOP;
END;
```

-- select for update
-- tabloyu değil sadece kayıtları kilitler
```
SELECT * FROM DEPARTMENTS FOR UPDATE;  --WAIT 5  bekle  -- NOWAIT; bekleme
```

-- cursor where current of kullanımı
```
DECLARE
	CURSOR cur_department(p_location_id number)
	IS
 		SELECT * FROM DEPARTMENTS
 		WHERE LOCATION_ID = p_location_id
 		ORDER BY DEPARTMENT_ID DESC;
BEGIN
	 FOR i_rec IN cur_department(10) -- örnek olması için parametreyi elimle verdim.  
	 LOOP
		UPDATE DEPARTMENTS
		SET DEPARTMENT_NAME = 'DEPT_NAME_' || i_rec.department_id
		WHERE CURRENT OF cur_department; -- o cursor da bu update işlemini çalıştır. Eski bir kullanım artık tercih edilmiyor. 
	 END LOOP;
END;
```


## 13 procedure

-- veritabanında kod bloklarını tutmak istediğimizde kullanırız.
-- java dotnet gibi programlama dillerinde compile edilen kodlar 
-- file system üzerinde durmaktadır. fakat veritabanında bu şekilde değildir
-- precedure bir veritabanı nesnesi olduğundan doğrudan veritabanı üzerine tutulur.

select * from dba_user


