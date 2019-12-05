# plsql

plsql öğrenmeye çalışalım 

Plsql kısaltmasının açılımı şu şekildedir.

```
procedural language extension to structured query language
```


| Konu | Açıklama |
| --- | --- |
| Konu1 | Hazırlık |
| Konu2 | Değişken tanımlama ve ekrana yazdırma |
| Konu3 | Değişken isimlendirme standartı |
| Konu4 | Tablodaki kolon tipine göre dinamik değişken oluşturmak |
| Konu5 | Anonymous block nedir|
| Konu6 | into kullanımı |
| Konu7 | konu 6 silinecek | 
| Konu8 | çoklu into kullanımı | 
| Konu9 | kontrol yapıları - if else | 
| Konu10 | kontrol yapıları - case when |


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


## döngüler
* 11.1 loop konusu (TERCIH EDILEN)
* 11.2 programlamada do..while gibi çalışır. 
* 11.3 loop içinde sql yazılmaz... yazılabilir fakat best practice değildir.


* 11.1
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

* 11.2
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

* 11.3

	-- for..loop konusu  (EN COK TERCIH EDILEN)
	-- programlamada for gibi çalışır.
```	
DECLARE
	ln_result NUMBER DEFAULT 0;
BEGIN
	for i IN 1 .. 50  -- loop tan çıkmak için kural
	LOOP
			ln_result := ln_result + 1;
			BEGIN
				dbms_output.put_line(TO_CHAR(ln_result));
			END;
			
	END LOOP;
END;
```


-- konu 12
-- objectives 
-- karma veri tipleri
	-- ikiye ayrılır. 
		-- 12.1 record konusu  (tek satır)
		-- 12.2 collection konusu (arrays - çok satır)
			-- 12.2.1 associative arrays (index by tables)
				-- 12.2.1.1 INDEX BY TABLE  
				-- 12.2.1.2 INDEX BY TABLE OF RECORDS
			-- 12.2.2 nested table
			-- 12.2.3 varray 
-- 12.1 - record veri tipi kulanımı
-- tabloda bir satıra karşılık gelen değeri karşılıyoruz.
-- aklımızda olsun : ne zaman bir type oluşturulur hemen bir değişken oluşturup bağlamalıyız.
-- bir record hiç bir zaman döngü ile doldurulmamalıdır. sorgu çekilip doldurmak çok daha performans kazandırır.

```
DECLARE
	TYPE t_emp IS RECORD (
		employee_id NUMBER,
		employee_name VARCHAR2(100),
		hire_date DATE
	);

	t_blueprint t_emp;  -- kendimizin oluşturduğu tipi bir değişkene atadık.
	t_blueprint_2 t_emp;
BEGIN
	t_blueprint.employee_id := 100;
	t_blueprint.employee_name := 'test-test';
	t_blueprint.hire_date := SYSDATE;

	dbms_output.put_line(t_blueprint.employee_id || '-' || t_blueprint.employee_name || '-' || t_blueprint.hire_date);

	t_blueprint_2 := t_blueprint;
	t_blueprint_2.employee_name := 'prod-prod';

	dbms_output.put_line(t_blueprint_2.employee_id || '-' || t_blueprint_2.employee_name || '-' || t_blueprint_2.hire_date);
END;
```

--sorgudan gelen bir satıra karşılık gelen değeri karşılıyoruz.

```
DECLARE
	TYPE t_emp IS RECORD (
		employee_id NUMBER,
		employee_name VARCHAR2(100),
		hire_date DATE
	);

	t_blueprint t_emp;  -- kendimizin oluşturduğu tipi bir değişkene atadık.

BEGIN
	SELECT t.employee_id,t.FIRST_NAME ||'*'|| t.LAST_NAME,t.HIRE_DATE
		INTO t_blueprint
	FROM EMPLOYEES t
	WHERE t.employee_id = 100;
	
	dbms_output.put_line(t_blueprint.employee_id || '-' || t_blueprint.employee_name || '-' || t_blueprint.hire_date);
END;
```

-- tipleri dinamik olarak oluşturmak için tablodan okuyorum.

```
DECLARE
	t_blueprint employees%ROWTYPE; -- tablodaki kolonların tipleri ne ise otomatik alabildim.

BEGIN
	SELECT *
		INTO t_blueprint
	FROM EMPLOYEES t
	WHERE t.employee_id = 100;
	
	dbms_output.put_line(t_blueprint.employee_id || '-' || t_blueprint.first_name || '-' || t_blueprint.hire_date);
END;

```
-- bir tablodan diğerini oluşturmak  - veri aktarmak

```
  	CREATE TABLE employees_temp AS (SELECT *    FROM EMPLOYEES    WHERE 1 = 2 ); -- verileri taşımadık
	SELECT * FROM employees_temp;
  	
DECLARE
	l_emp employees%rowtype;  --record oluşturduk
BEGIN
	INSERT INTO employees_temp
		SELECT * FROM EMPLOYEES
		WHERE employee_id = 100;
	
--	burada bişey vardı ekleyeceğim.

	UPDATE EMPLOYEES_TEMP t
	SET ROW  = l_emp
	WHERE t.employee_id = 100;
	COMMIT;
END;

```
-- DAY 1 FINISH


-- konu 12.2.1
-- record veri tipinde tek satır tutabiliyorduk bunlarda çok satır tutabiliyoruz.
-- array kullanımı
-- bir array tanımlamak için 
	-- iki şekildedir. 
		-- 12.2.1.1 INDEX BY TABLE  
		-- 12.2.1.2 INDEX BY TABLE OF RECORDS

-- konu 12.2.1.1
-- index by table kullanımı

-- index by ile yazılan sayılar ram üzerinde saklanırlar.
-- index integer sayı olacak şekilde number tipinde veri tutan array tanımladık.
-- index kısmını index by number , index by varchar2(1000) şeklinde tanımlayabilirdik.

```
DECLARE	
	TYPE typ_employees IS TABLE OF NUMBER INDEX BY pls_integer;  --pls_integer hazır keyword.

	tbl_employees typ_employees;  -- ne zaman bir tip oluşturulmuş ise onu mutlaka bir değişkene atayalım :)

	l_employee_id NUMBER;
	l_count NUMBER;
BEGIN
	tbl_employees(1) := 100;
	tbl_employees(2) := 200;
	tbl_employees(3) := 300;
	tbl_employees(4) := 400;

	
	l_employee_id := tbl_employees(3);
	dbms_output.put_line(l_employee_id);
	dbms_output.put_line('Tablodaki eleman sayısı ' || tbl_employees.COUNT); 
END;
```

-- bir tablodaki bir satıra karşılık gelen tüm alanlarını türleriyle karşılayabilecek bir array oluşturup içine iki tane eleman ekledim.

```

DECLARE
	TYPE typ_employee IS TABLE OF employees%rowtype INDEX BY pls_integer;
	--TYPE typ_employee IS TABLE OF employees%rowtype INDEX BY varchar2(1000); -- bu sekilde olduğunda index harflerle tutuluyor.
	
	tbl_employees typ_employee;
BEGIN
	tbl_employees(1).employee_id := 100;
	tbl_employees(1).first_name := 'test name';
	tbl_employees(1).last_name := 'test lastname';
	tbl_employees(1).hire_date := SYSDATE;

	tbl_employees(2).first_name := 'test name2';
	tbl_employees(2).hire_date := SYSDATE;

	dbms_output.put_line(tbl_employees(2).hire_date);
	dbms_output.put_line('Tablodaki eleman sayısı ' || tbl_employees.COUNT);
END;

```

-- bir tablodaki tüm veriyi  TABLE OF INDEX e kopyalayıp kullanmak ve yazdırmak. 
```
DECLARE
	TYPE typ_employee IS TABLE OF employees%rowtype INDEX BY pls_integer;
	tbl_employees typ_employee;
BEGIN
	SELECT *
		BULK COLLECT INTO tbl_employees -- tüm veriyi performanslı şekilde almak BULK COLLECT, sadece * da olsa olurdu.
	FROM
	EMPLOYEES;
	
	dbms_output.put_line(tbl_employees(2).last_name);
	dbms_output.put_line(tbl_employees(33).first_name);

	dbms_output.put_line('array daki elemanın sayısı ' || tbl_employees.COUNT); -- index by table methods
	dbms_output.put_line('ilk elemanın indeksi  ' || tbl_employees.FIRST);
	dbms_output.put_line('ilk elemanın indeksi  ' || tbl_employees.LAST);
	dbms_output.put_line('3 nolu elemanın öncesindeki elemanın indeksi ' || tbl_employees.PRIOR(3));


	FOR i IN tbl_employees.FIRST..tbl_employees.LAST
	LOOP
		dbms_output.put_line(tbl_employees(i).FIRST_NAME || '--' || tbl_employees(i).LAST_NAME);
	END LOOP;
END;
```

-- konu 12.2.1.2
-- index by table of records kullanımı

-- 

-- önceki örneklerde array in tipi 
-- belirli bir alan NUMBER,VARCHAR gibi 
-- tablodan referans olan bir alan record employees.employee_id%type
-- veya tablonun bir satırını karşılayan  record employees%rowtype 
-- olabiliyordu.

--
 
-- bir array in tipi bir record olabilir. 
-- bu durum bize bir dizinin bir alanına bir tablodan çektiğimiz tüm veriyi atabilmeyi sağlar :)
```
DECLARE
	TYPE typ_my_record IS RECORD
	(
		alan1 DATE,
		alan2 NUMBER
	);
	-- verilerin tamamını alırken zaten indeksli index by terimini kullanmak gereksiz.
 TYPE tbl_my_records IS TABLE OF typ_my_record;
	
	l_tbl_my_array  tbl_my_records;
	
BEGIN
	SELECT k.hire_date, k.employee_id
		BULK COLLECT INTO l_tbl_my_array
	FROM 
	employees k;
END;
```

 -- record un record u 

```
DECLARE
 	--- TANIM1
	TYPE typ_my_record IS RECORD
	(
		alan1 DATE,
		alan2 NUMBER
	);
	
	TYPE tbl_my_records IS TABLE OF typ_my_record;
	
	l_my_table  tbl_my_records;
	---
	--- TANIM2
	TYPE typ_my_parent_record IS RECORD
	(
		alan1 varchar2(10),
		alan2_list tbl_my_records
	);

	l_my_parent_table typ_my_parent_record;
	---
BEGIN
	NULL;
END;
```

-- konu 12.2.2 nested table array
-- nested table, tablo içindeki tabloya verilen isimdir.
-- tabloda tüm veriler kullanılıyorsa bu rahatlıkla kullanılabilir.
-- INDEX BY yazılmıyor ise oracle kendisi index değeri verir. Yukarıda örneği mevcut.
-- örnek olarak bir record içinde bir record olabiliyordu. Bir tabloda olabilir :)
-- yani her recordun bir alanı farklı bir tablonun tamamı olabilir :)

-- bunun constructor kullanımı var anlatılabilir.
 
 ```
DECLARE  -- bu ornegi sil
	TYPE location_type IS TABLE OF LOCATIONS.CITY%TYPE;
	offices location_type;
	table_count NUMBER;
BEGIN
	offices := location_type('city1','city2','city3');
	
	FOR i IN 1..offices.COUNT
	LOOP
		dbms_output.put_line(offices(i));
	END LOOP;
END;

```

-- konu 12.2.3 varray
-- anlat 
-- nested array den farklı olarak sabit değerli olarak array oluşturulur.
-- Sonradan extend metodu ile array boyutu genişletilebiliyor.

```

DECLARE
	TYPE tbl_number IS VARRAY(3) OF NUMBER;
BEGIN
	NULL;
END;

```

-- konu 13 context switching
--- anlat





-- konu 14
-- cursors
-- SELECT sorgusu ile elde ettiğimiz veri kümesinin pointer yapısı yardımı ile erişilebilmesini sağlayan yapıdır.
-- Pointer yardımı ile küme içindeki değerleri tek tek dolaşıp erişmemizi sağlıyor.
-- NEDEN KULLANIRIZ : Bir sql çıktısındaki kayıtları tek tek dolaşıp işlem yapmak istediğimde kullanırım.
				-- ör birinci satırdaki kayıda şunu yap ikinciyi değişkene at  bunu yap gibi işlemler..	
				-- bir tablonun tüm verilerini tek seferde kullanmam gerekiyorsa 
				-- cursor kullanmak dogru değildir. insert as select vb işlemler ile tüm kayıt işini halledebiliriz.
-- bir cursor scope alanına göre  bir çok plsql içerisinde ortak kullanılabiliyor.kod akışını tek cursor ile halledbiliyoruz.  
					
-- 3 tip cursor vardır.
	-- Implicit Cursor 
	-- Explicit Cursor
	-- Ref Cursor sonraki konularda açıklanacak.

-- Implicit Cursor 
-- sql cümlesi çalıştırıldığında eğer explicit cursor yani bizim kendimizin tanımladığı cursor yoksa implicit cursor otomatik devreye girer.
-- plsql içinden sql çağırdığımızda plsql engine çalışır,sql engine çalışır ve sql engine den donen cevap plsql engine dönülür.
-- bu aradaki veri taşıma işlemini cursor ile yapıyoruz.
-- cursor bir veya birden fazla veriyi hafızada tutarak yorumlamamızı sağlar.

--  %ISOPEN 	--  implicit cursor da sql çalışması biter bitmez cursor kapandığı için bu değer hep false döner.
				--  Açık olmayan bir cursor FETCH edilirse hata alınacaktır. 
				--  Kapalı olmayan bir cursor açılmaya çalışılırsa hata alınacaktır.
				-- Hataları almamak için cursor açık mı kapalı mı kullanıp anlayabiliriz. :)
				
-- sql%found  -- veri varsa true    
			  -- blok içerisinde INSERT,UPDATE,DELETE bir veya birden fazla değer etkilenirse true,
			  -- SELECT INTO daki INTO ya değer gelirse true olur.
			  -- bir sonraki SELECT çalıştığında o SELECT deki değerlere göre yeni değeri alınır eskisi değeri silinir.
-- sql%notfound -- veri yoksa true

-- sql%rowcount  -- veri sayısı 
				-- FETCH etmeden sql%rowcount gözükmez. Her FETCH edildiğinde yeni kayıt çekiliyor.
				-- Bir tablodaki tüm kayıtları çektiğimizde kullandığımız editör bir kısmını getiriyor.
				-- Sebebi ise programlamdaki datatable işlemlerinde lazy load mantığı gibi çalışıyor olmasındandır.
				-- OCI (oracle call interface) bu işlemiin yapılmasını sağlar.

-- %rowtype   attribute  -- tablo veya view deki kolonun veri tipine erişmek için kullanılır.  -- employees%rowtype;
-- %type      attribute  -- bir kolonun tipine erişip kullanmak için  -- employees.last_name%type; 


```
SELECT * FROM DEPARTMENTS;
DECLARE
	lv_dept_name varchar2(100);
	ln_dept_id NUMBER;
	lb_cursor_status BOOLEAN;
BEGIN
	ln_dept_id := 10;
	
	SELECT d.department_name
		INTO lv_dept_name
	FROM DEPARTMENTS d
	WHERE d.department_id = ln_dept_id;

	IF sql%FOUND
		then
			dbms_output.put_line(lv_dept_name);
			dbms_output.put_line('kayit sayisi ->> ' || SQL%ROWCOUNT);
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
 --Explicit Cursor
 
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

SELECT * FROM DEPARTMENTS FOR UPDATE;--WAIT 5  bekle
									 -- NOWAIT; bekleme
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
	 FOR i_rec IN cur_department(10) -- örnek olması için para etreyi elimle verdim.  
	 LOOP
		UPDATE DEPARTMENTS
		SET DEPARTMENT_NAME = 'DEPT_NAME_' || i_rec.department_id
		WHERE CURRENT OF cur_department; -- o cursor da bu update işlemini çalıştır. Eski bir kullanım artık tercih edilmiyor. 
	 END LOOP;
END;

```



-- Ref Cursor
-- anlat
-- open fetch close yapmak zorundayız.
--- sys_refcursor https://stackoverflow.com/questions/18274258/cursor-for-loop-in-oracle

--- best practice kayıt bulundu bulunmadı diye SQL%notfound kullanılmaz. kayıt bulamazsa exceptiona düşyor
-- ordan sqlfound yapıyoruz. 


-- Bulk Collect Konusu
-- ForALL konusu -- for loop yaptıktan sonra tek tek kayıtları update etmek isteiğimizde, tek seferde kayıtlara ulaşıp yapabiliriz.
-- araştır.
-- https://www.guru99.com/pl-sql-bulk-collect.html


-- sqlj nedir ?
-- araştır
-- pre compiler kavramı
-- java içine sql yazılamıyormuş sqlj içine java yazıyorsunuz plsql yazıyorsunuz sqlj ile compile edince bize java kodunu export ediyormuş
-- proC
-- proFortran
-- proCobol



-- konu 15
-- exceptions

-- anonymous block içerisindeki iş mantığında bir hata oldu. Bu hatayı yakaladık ve konsola çıktı olarak verdik.
-- exception kısmını yazmadığımız zaman ki halini deyenip görebilirsiniz :)

```
DECLARE
	l_emp varchar2(100);
BEGIN
	SELECT first_name || ' '|| last_name
		INTO l_emp
	FROM employees
	WHERE employee_id = 5000; -- olmayan bir kayıt çağırdım

	dbms_output.put_line(l_emp);

	EXCEPTION 
		WHEN NO_DATA_FOUND 
			THEN 
				dbms_output.put_line(' HATA -- Boyle bir employee kaydı yok');
END;
```

-- bir insert atalım ve oluşan hatayı yakalayalım.
-- burada bir problem var. KONTROL 2 kısmından önce bir hata oluştu.
	-- bu nedenle anonymous block içindeki KONTROL 2 kısmı beklediğimiz gibi çalışmadı.
	
```
DECLARE
	l_emp varchar2(100);
BEGIN
	SELECT first_name || ' '|| last_name
		INTO l_emp
	FROM employees
	WHERE employee_id = 100; -- olan bir kayıt çağırdım.

	dbms_output.put_line(l_emp);
	dbms_output.put_line('KONTROL 1');

	INSERT INTO departments VALUES(10,'bolum 10',100,1700);  
	
	dbms_output.put_line('KONTROL 2'); -- buradaki kod önceki satırda kırıldı. bu satır yazılamadı.

	EXCEPTION 
		WHEN NO_DATA_FOUND 
			THEN 
				dbms_output.put_line(' HATA -- Boyle bir employee kaydı yok');
		WHEN DUP_VAL_ON_INDEX
			THEN
				dbms_output.put_line(' HATA -- boyle bir department kaydı var girilemez');

END;
```

-- iç içe anonymous block kullanarak bir önceki problemi çözmüyoruz fakat kodun kırılmasını engelliyebiliyoruz.
-- KONTROL 3 bölümü çalıştırılabiliyor. Çünkü iç içe anonymous block kullandık.

```
DECLARE
	l_emp varchar2(100);
BEGIN
	
	BEGIN
		SELECT first_name || ' '|| last_name
			INTO l_emp
		FROM employees
		WHERE employee_id = 100; -- olan bir kayıt çağırdım.
		
		dbms_output.put_line(l_emp);
		dbms_output.put_line('KONTROL 1');
		EXCEPTION 
				WHEN NO_DATA_FOUND 
					THEN 
						dbms_output.put_line(' HATA -- Boyle bir employee kaydı yok');
	END;
	BEGIN
		INSERT INTO departments VALUES(10,'bolum 10',100,1700);  
		
		dbms_output.put_line('KONTROL 2'); -- buradaki kod önceki satırda kırıldı. bu satır yazılamadı.
		EXCEPTION 	
			WHEN DUP_VAL_ON_INDEX
				THEN
					dbms_output.put_line(' HATA -- boyle bir department kaydı var girilemez');
	END;

	dbms_output.put_line('KONTROL 3'); -- buradaki kod yazılabildi.

END;

```

---- iç içe anonymous block larda exception kullanımı
-- 
-- bir anonymous block içerisinde bir oluşan hata,
--  o blok içinde yazılmış hatalardan biri değil ise 
-- kendisinden bir üst katmandaki anonymous block içerisinde aramaya başlar.
-- eger bulamaz ise yine bir üstekine bakar.
-- Burada dikkat edilmesi gereken kısım şudur. Bir üsteki bloğa kendi bloğunun end kısmından 
-- sonra gelen kısmı çalıştıracak şekilde gitmez. Direkt olarak exception bölümüne gider.
-- burada bir iş mantığınız var ise bu atlanmış olur.
-- exception bölümünde yakalandıktan sonra kod kaldığı yerden akışına devam eder.
-- çıktı şu şekildedir.  5. ve 6. satır atlanmıştır. :)  
		--1
		--2
		--3
		--4
		-- HATA -- Boyle bir employee kaydı yok
		--7
```
DECLARE
	l_emp varchar2(100);
BEGIN
	dbms_output.put_line('1');
	BEGIN
		dbms_output.put_line('2');
		BEGIN
			dbms_output.put_line('3');
			BEGIN
				dbms_output.put_line('4');
			
				SELECT first_name || ' '|| last_name
					INTO l_emp
				FROM employees
				WHERE employee_id = 5000; -- olmayan bir kayıt çağırdım.
				--WHERE employee_id = 100; -- olan bir kayıt çağırdım.
				
				dbms_output.put_line(l_emp);
			
				EXCEPTION 
				WHEN TOO_MANY_ROWS 
					THEN 
						dbms_output.put_line(' HATA -- Birden fazla kayıt geldi.');

			END block_four;
			dbms_output.put_line('5');
		END block_three;
		dbms_output.put_line('6');
		EXCEPTION 
			WHEN NO_DATA_FOUND 
				THEN 
					dbms_output.put_line(' HATA -- Boyle bir employee kaydı yok');
	END block_two;
	dbms_output.put_line('7');
END;
```
--- exception raise kullanımı
-- bu kullanım ile kodun akışını istediğimizde kırarız. 
-- beklediğim bir istisna durumunu kendim oluşturmuş oluyorum.
-- programada throw Exception(); gibi.

-- hatayı yakaladıktan sonra uygulamamız kaldığı yerden devam etsin 
```
DECLARE
	l_emp_count NUMBER;
	e_emp_count EXCEPTION;
BEGIN 
	BEGIN
		SELECT count(*)
			INTO l_emp_count
		FROM EMPLOYEES;
	
		dbms_output.put_line(l_emp_count);
	
		IF( l_emp_count > 100 ) 
		THEN 
			RAISE e_emp_count;
		END IF;
	
		dbms_output.put_line('Bu satir istisna firlatiğimiz için çalışmıyor.');
		
		EXCEPTION
			WHEN e_emp_count
				THEN dbms_output.put_line('e_emp_count istisnasına düstü');
	
		dbms_output.put_line('Bu satir istisna EXCEPTION bölümüne girdiği için çalışıyor.');
	END;
	dbms_output.put_line('En dışarıdaki anonymous block Bu satir istisna EXCEPTION bölümüne girdiği için çalışıyor.');
END;
```

-- hatayı yakaladıktan sonra birşey yapıp sonra tekrar hata fırlatılabilir.
```
DECLARE
	l_emp_count NUMBER;
	e_emp_count EXCEPTION;
BEGIN 
	BEGIN
		SELECT count(*)
			INTO l_emp_count
		FROM EMPLOYEES;
	
		dbms_output.put_line(l_emp_count);
	
		IF( l_emp_count > 100 ) 
		THEN 
			RAISE e_emp_count;
		END IF;
	
		dbms_output.put_line('Bu satir istisna firlatiğimiz için çalışmıyor.');
		
		EXCEPTION
			WHEN e_emp_count
				THEN dbms_output.put_line('e_emp_count istisnasına düstü');
				RAISE NO_DATA_FOUND; -- RAISE NO_DATA_FOUND; bu tipte bir üste fırlatır.
			
		dbms_output.put_line('Bu satir istisna EXCEPTION bölümünde RAISE; olduğundan çalışmıyor.');
	END;
	dbms_output.put_line('En dışarıdaki anonymous block Bu satir istisna EXCEPTION bölümünde RAISE; olduğundan çalışmıyor.');

	EXCEPTION
		WHEN NO_DATA_FOUND
			THEN dbms_output.put_line('Iceriden RAISE NO_DATA_FOUND seklinde fırlatıldıgi icin burası çalışıyor.');
END;
```


-- kodun akışını kırmak ve programın o hata sonrasında durmasını istiyorum. 
-- iç içe olan anonymous block ların içlerinde
--  exception when then mekanizması yazmak yerine en dıştakine hepsini yakalayabiliriz.


-- exception pragma
-- oluşmasını beklediğimiz bir istisnanın istediğimz bir hata kodu ile eşleştirilmesidir.
-- PRAGMA EXCEPTION_INIT ile oluşturuyoruz.
-- hatayı yakaladıktan sonra uygulamamız kaldığı yerden devam ediyor.
```
DECLARE
	e_ora_60 EXCEPTION;
	PRAGMA EXCEPTION_INIT (e_ora_60,-1400) ; -- e_ora_60 hatası oluştuğunda bu hata kodunu bas
BEGIN
		BEGIN
			INSERT INTO departments (department_id,department_name,manager_id,location_id)
			VALUES (260,NULL,NULL,NULL);
		
			EXCEPTION	
				WHEN e_ora_60
					THEN
						dbms_output.put_line('e_ora_60 BEKLEDIGIM HATA OLUSTUGUNDA BURAYA GIRER');
						dbms_output.put_line('SQLCODE -->> '|| SQLCODE || ' SQLERR -->> '|| SQLERRM || ' HATASI OLUSTU');
				WHEN OTHERS
					THEN -- when others kullanmamak en güzeli. eğer iç blocklarda bir yazarsa kod çalıştı zannedersin ama biri o hatayı yutmuş olur :)
						dbms_output.put_line('BASKA HATA OLUSTUGUNDA BURAYA GIRER');
						dbms_output.put_line('SQLCODE -->> '|| SQLCODE || ' SQLERR -->> '|| SQLERRM || ' HATASI OLUSTU');
		-- ÇIKTISI		
		--	e_ora_60 BEKLEDIGIM HATA OLUSTUGUNDA BURAYA GIRER
		--	SQLCODE -->> -1400 SQLERR -->> ORA-01400: cannot insert NULL into ("HR"."DEPARTMENTS"."DEPARTMENT_NAME") HATASI OLUSTU
		END;
		dbms_output.put_line('HATA OLUSTUKTAN SONRA YAKALANDI VE BURADAN DEVAM ETTI ');
END;
```
--
-- raise application error
-- PRAGMA EXCEPTION_INIT ile var olan bir kodu vermek istediğimiz isim ile eşleştiriyorduk.
-- Fakat burada belirlediğimiz hata mesajlarını oracle tarafından
--  belirlenen -20000 ile -21000 arasınaki sayılarına atama yaparak kullanabiliriz.
-- anonymous block içinden bu bloğu çağıran uygulamaya hata dönülmesi sağlanır. 

```
DECLARE
	l_test_no NUMBER DEFAULT 10;
BEGIN
	IF l_test_no < 11
		THEN 
			RAISE_APPLICATION_ERROR(-20008,'l_test_no 11 den kücüktür.');
	END IF;

	dbms_output.put_line('asdf');

	EXCEPTION 
		WHEN OTHERS
			THEN
				dbms_output.put_line(SQLCODE ||' ->> '|| SQLERRM);
-- çıktı			
--	-20008 ->> ORA-20008: l_test_no 11 den kücüktür.
END;

```



-- konu 16
-- ROLLBACK example ekle
-- 
-- konu 17 ve konu 18
-- fonksiyonlar ve prosedürler subprograms olarak değerlendirilirler
-- fonksiyonlar ve prosedürler anonymous block ların isim verilmiş halleri olarak karşımıza çıkar.
-- biraz karşılaştırma yapalım.
-- anonymous block 
	-- isimsiz plsql bloklarıdır.
	-- her çalıştırıldığında yeniden derlenir.
	-- veritabanında saklanmaz.
	-- diğer uygulamalardan çağırılamaz.
	-- değer dönemezler
	-- parametre alamazlar. 
-- fakat
-- subprograms (functions , procedures)
	-- isimlendirilmişlerdir.
	-- bir kez derlendikten sonra çalışmaya hazır.
	-- veritabanında saklanır.
	-- diğer uygulamalardan çağrılabilir.
	-- fonksiyon tipi değer dönmek zorundadır.
	-- parametre alabilirler
	
-- konu 17
-- functions 
-- function kullanırken insert update delete yazmamak lazım bu işlemleri procedure de yapmaliyiz.
```
CREATE OR REPLACE FUNCTION f_get_employee_info(p_employee_id IN NUMBER)
	RETURN VARCHAR2
	IS

	l_emp_info VARCHAR2 (1000);
BEGIN
	SELECT first_name ||'*'|| last_name
		INTO l_emp_info
	FROM EMPLOYEES
	WHERE employee_id = p_employee_id;

	RETURN l_emp_info;

	EXCEPTION
		WHEN NO_DATA_FOUND
			THEN
				l_emp_info := 'NOT_FOUND EMPLOYEE';
				RETURN l_emp_info;
END;

```
--
```

SELECT 	*
FROM user_objects
WHERE
	object_name
LIKE '%f_get_employee_info%';
--
DECLARE
	l_result_info varchar2(20);
BEGIN
	SELECT f_get_employee_info(1) 
		INTO l_result_info
	FROM dual	;

	dbms_output.put_line(l_result_info);

	l_result_info := f_get_employee_info(100);

	dbms_output.put_line(l_result_info);

END;
```

# 18 procedure 

-- procedure kullanımı
-- PROCEDURE bir OBJECT tipidir.

-- bu nedenle db de saklanır.

-- oluşturduğunuz prosedürlerin tamamına erişebilirsiniz.

--SELECT * FROM user_objects x WHERE x.object_type = 'PROCEDURE';

-- PROCEDURE neden kullanılır ?
-- farklı işlemleri mantıksal olarak toplayıp tek noktadan çalıştırmamızı sağlar.

CREATE OR REPLACE PROCEDURE prc_hello
AS 
	v_hello varchar2(20) := 'hello';
BEGIN
	DBMS_OUTPUT.put_line('hey ' || V_HELLO );
END;
/

--
BEGIN
	HR.PRC_HELLO();
END;

--veya

CALL HR.PRC_HELLO();
--veya 
SET serveroutput ON; 
-- açtıktan sonra 
EXECUTE HR.PRC_HELLO();
--veya 
EXEC HR.PRC_HELLO();

-- çağırabilirsiniz

