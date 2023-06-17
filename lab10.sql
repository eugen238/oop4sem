ALTER DATABASE OPEN;
--1 экви, композитное, по ссылке, по виртуальному столбцу
CREATE TABLE T_RANGE
(
    id NUMBER,
    value VARCHAR2(100)
)
PARTITION BY RANGE (id)
(
    PARTITION p1 VALUES LESS THAN (100),
    PARTITION p2 VALUES LESS THAN (200),
    PARTITION p3 VALUES LESS THAN (MAXVALUE)
);

--2
create table T_INTERVAL
(
   sales_id    number,
   sales_dt    date
)
partition by range (sales_dt)
                               
interval (numtoyminterval(1,'MONTH'))
(
   partition p0701 values less than (to_date('2007-02-01','yyyy-mm-dd'))
);


--3
CREATE TABLE T_HASH
(
    id NUMBER,
    value VARCHAR2(100),
    hash_key VARCHAR2(100)
)
PARTITION BY HASH (hash_key) PARTITIONS 3;

--4
CREATE TABLE T_LIST
(
    id NUMBER,
    value VARCHAR2(100),
    list_key CHAR(1)
)
PARTITION BY LIST (list_key)
(
    PARTITION p1 VALUES ('A'),
    PARTITION p2 VALUES ('B'),
    PARTITION p3 VALUES ('C')
);

--5
-- Для таблицы T_RANGE
INSERT INTO T_RANGE (ID, value) VALUES (50, 'John');
INSERT INTO T_RANGE (ID, value) VALUES (150, 'Alice');
INSERT INTO T_RANGE (ID, value) VALUES (250, 'Bob');

-- Для таблицы T_INTERVAL
INSERT INTO T_INTERVAL (sales_id,sales_dt)
VALUES (1, TO_DATE('2022-01-01', 'YYYY-MM-DD'));

INSERT INTO T_INTERVAL (sales_id,sales_dt)
VALUES (2, TO_DATE('2023-02-15', 'YYYY-MM-DD'));

INSERT INTO T_INTERVAL (sales_id,sales_dt)
VALUES (3, TO_DATE('2024-06-01', 'YYYY-MM-DD'));

-- Для таблицы T_HASH
INSERT INTO T_HASH (id, value, hash_key) VALUES (101, 'John', 'A');
INSERT INTO T_HASH (id, value, hash_key) VALUES (102, 'Alice', 'B');
INSERT INTO T_HASH (id, value, hash_key) VALUES (103, 'Bob', 'C');

-- Для таблицы T_LIST
INSERT INTO T_LIST (ID, value, list_key) VALUES (201, 'John', 'A');
INSERT INTO T_LIST (ID, value, list_key) VALUES (202, 'Alice', 'B');
INSERT INTO T_LIST (ID, value, list_key) VALUES (203, 'Bob', 'C');

-- Проверка размещения данных в секциях

-- Для таблицы T_RANGE
SELECT * FROM T_RANGE PARTITION (P1); 

SELECT * FROM T_RANGE PARTITION (P2); 

SELECT * FROM T_RANGE PARTITION (P3); 

-- Для таблицы T_INTERVAL
SELECT * FROM T_INTERVAL PARTITION (P1);

SELECT * FROM T_INTERVAL PARTITION (P2); 

SELECT * FROM T_INTERVAL PARTITION (P3); 

-- Для таблицы T_HASH
SELECT * FROM T_HASH PARTITION FOR (VALUE 'A'); 

SELECT * FROM T_HASH PARTITION FOR (VALUE 'B');
SELECT * FROM T_HASH PARTITION FOR (VALUE 'C'); 

-- Для таблицы T_LIST
SELECT * FROM T_LIST PARTITION (P1); 

SELECT * FROM T_LIST PARTITION (P2); 
SELECT * FROM T_LIST PARTITION (P3); 

SELECT * FROM T_LIST PARTITION (P4); 


--6
ALTER TABLE T_LIST ENABLE ROW MOVEMENT;



UPDATE T_RANGE SET ID = 120 WHERE ID = 55;



UPDATE T_INTERVAL SET sales_dt = TO_DATE('2022-02-02', 'YYYY-MM-DD') WHERE start_date = TO_DATE('2022-01-01', 'YYYY-MM-DD');


UPDATE T_HASH SET hash_key = 'B' WHERE hash_key = 'A';


UPDATE T_LIST SET list_key = 'C' WHERE list_key = 'A';

--7
ALTER TABLE T_RANGE MERGE PARTITIONS p1,p2
  INTO PARTITION p2;
  select * from user_tab_partitions where table_name = 'T_RANGE';
  
--8
alter table t_range SPLIT PARTITION p2 INTO
(
  PARTITION p1 values less than (100),
  PARTITION p2 
);

--9 
CREATE TABLE T_RANGE__
(
    id NUMBER,
    value VARCHAR2(100)
)
insert into t_range__ values (0,'qwe');

alter table t_range EXCHANGE PARTITION p1 WITH TABLE t_range__ WITHOUT VALIDATION;
select * from t_range partition (p1);

--10 
SELECT table_name
FROM all_tab_partitions

SELECT partition_name
FROM all_tab_partitions
WHERE table_name = 'T_RANGE';

SELECT *
FROM T_RANGE PARTITION (p1);

SELECT *
FROM T_RANGE PARTITION FOR(0);
