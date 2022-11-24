-- Question 1
CREATE DATABASE Input;
CREATE TABLE Tree (Node int,
parent int);

USE Input;
INSERT INTO Tree values (5,8),(9,8),(4,5),(2,9),(1,5),(3,9),(8,null);
SELECT * FROM Tree;
SELECT Node,
CASE WHEN Tree.parent is null THEN "Root"
WHEN Tree.node IN (SELECT DISTINCT Parent FROM Tree) THEN "Inner"
ELSE "Leaf"END AS Type
FROM Tree ORDER BY Node;

#2nd method
SELECT Node,
CASE WHEN Tree.parent is null THEN "Root"
WHEN Tree.node NOT IN (SELECT DISTINCT Parent FROM Tree where Tree.parent is not null) THEN "Leaf"
ELSE "Inner" END AS Type
FROM Tree order by node;

-- Question 2
--  write a query to find the total amount recieved by each merchants via cash & online method.
CREATE TABLE Payments_data(
TRX_DATE date,
MERCHANT VARCHAR(255),
AMOUNT INT, 
PAYMENT_MODE VARCHAR(255)
);

INSERT INTO Payments_data VALUES
("2022-04-02",'MERCHANT_1',150,'CASH'),
("2022-04-02",'MERCHANT_1',500,'ONLINE'),
("2022-04-03",'MERCHANT_2',450,'ONLINE'),
("2022-04-03",'MERCHANT_1',100,'CASH'),
("2022-04-03",'MERCHANT_3',600,'CASH'),
("2022-04-05",'MERCHANT_5',200,'ONLINE'),
("2022-04-05",'MERCHANT_2',100,'ONLINE');


SELECT MERCHANT,
SUM(CASE WHEN PAYMENT_MODE ='CASH' THEN AMOUNT ELSE 0 END) AS cash_amount,
SUM( CASE WHEN PAYMENT_MODE ='ONLINE'THEN AMOUNT ELSE 0 END) AS online_amount
FROM payments_data
GROUP BY MERCHANT;

-- Question 3
-- Perform inner join operation for tableA & tableB usings columns colA & colB and
-- print count of total number of rows in the output. #null safe join operation

CREATE TABLE tableA (colA int );
insert into tableA values(1),(2),(1),(5),(null),(null);
CREATE TABLE tableB (colB int );
insert into tableB values(null),(2),(5),(5);

-- 1st method
SELECT * FROM tableA 
inner join tableB 
on tableA.colA <=> tableB.colB;

-- 2nd method
SELECT * FROM tableA 
inner join tableB 
on tableA.colA = tableB.colB
or (tableA.colA is null and tableB.colB is null);

-- Question 4
-- Remove all reversed number pairs from given table,keep only one (random )
CREATE TABLE NUMBER_PAIRS(A INT, B INT );
INSERT INTO NUMBER_PAIRS VALUES(1,2),(3,2),(2,4),(2,1),(5,6),(4,2);

1st method
select * from number_pairs;
select NP1.A,NP1.B from NUMBER_PAIRS NP1
LEFT JOIN NUMBER_PAIRS NP2
ON NP1.B = NP2.A and NP1.A = NP2.B
WHERE NP2.A IS NULL OR NP1.A >  NP2.A;

2nd method
SELECT * FROM number_pairs t1 WHERE
NOT EXISTS ( select * from number_pairs t2 
where t1.B = t2.A and t1.A = t2.B 
and t1.A > t2.A);

-- Question 5
-- Invert this table in columns student_id,english,science,maths 
create table marks_data (student_id int,`subject` varchar (255),marks int );  
insert into marks_data values (1001,'English',88),(1001,'Science',90),
(1001,'Maths',75),(1002,'English',70),(1002,'Science',80),(1002,'Maths',83);

 select * from marks_data;
 select student_id,
 sum(case when subject ='English' then marks else 0 end) as English,
 sum(case when subject = 'Science' then marks else 0 end) as Science,
 sum(case when subject = 'Maths' then marks else 0 end) as Maths
 from marks_data
 group by student_id;

-- Question 6
-- REMOVE ALL LOGICAL & DIRECT DUPLICATES FROM THE INPUT TABLE
create table Travel_Data(city1 varchar (255),city2 varchar(255),Price int);
insert into Travel_Data values('A','B',200),('A','C',300),('C','D',200),('A','B',200),('B','A',200);

select * from Travel_Data;
select t1.city1,t1.city2,t1.price from Travel_Data t1 left join travel_data t2 on t1.city2 = t2.city1 and 
t1.city1 = t2.city2 and t1.price = t2.price
where t2.city1 is null 
union 
select * from Travel_Data 
having count(*) >1;
;
select NP1.A,NP1.B from NUMBER_PAIRS NP1
LEFT JOIN NUMBER_PAIRS NP2
ON NP1.B = NP2.A and NP1.A = NP2.B
WHERE NP2.A IS NULL OR NP1.A > NP2.A;

-- Question 7
-- top 3 employee who have highest salary in each department
CREATE TABLE EMPLOYEE(employee_id int,employee_name varchar (255),
department_id int,employee_salary int );
insert into employee values(1,'Rowan Shepherd',1,1000 ),(2,'Rimsha Melendez',1,900),
 (3,'Tiah Sanford',1,900),(4,'Cayden Mcclure',1,700),(5,'Ellena Dyer',2,1200),
 (6,'Marcus Knox',2,800),(7,'Tashan Dalby',2,700),(8,'Arif Sutherland',2,500);

select * from employee;
with top3 as(
select *, dense_rank() over(partition by department_id order by employee_salary desc) as rn
from employee)
select * from top3 where rn<=3
;

-- Question 8
-- Calculate the avg required course gpa in each school year for each student
-- and find students who are qualified for the dean's list(gpa>=3.5 in each semester

create table gpa_history(student_id int,class_id int,school_year int,gpa int,isrequired bool);
insert into gpa_history values(1,1001,2018,4,True),
(1,2001,2018,3,True),(1,3004,2019,2,false),(1,4002,2019,4,True),
(2,2002,2018,4,True),(2,3001,2019,2,false),(3,1001,2018,2,True),
(3,2001,2018,4,True),(3,1001,2019,4,True);

select * from gpa_history;
select distinct(student_id),school_year,avg(gpa) over(partition by school_year ) as 'avg' from gpa_history
where gpa >=3.5; 

-- Question 9
-- find the total number of classes taken by each student(provide student id,
-- name and number of classes taken)
create table student(student_id int,student_name varchar(255));
create table class(student_id int,class_id int,semester varchar(255));
drop table class;
insert into class values(1,3001,'spring 2019'),(1,2001,'fall 2019'),
(2,1004,'spring 2019'),(2,3002,'fall 2019'),(3,2001,'fall 2018'),
(4,1001,'spring 2018'),(5,1001,'fall 2019');
insert into student values(1,'Eddie Rodgers'),(2,'Koa Larsen'),(5,'Zahrah Mathis'),
(6,'Ameer Silva');

select s.student_id,s.student_name,count(class_id) as num_of_classes
from student s left join class c on s.student_id = c.student_id
group by s.student_id ;

-- Question 10 (no table given in the pdf, not sure how to solve without data)
-- for the following relation schema:
-- find the names of all employees in the database who live in the same cities as the
-- companies for which they work.
-- find the names of all employees in the database who earn more than every
-- employee of 'small Bank Corporation'.Assume that all people work for at most one company

create table worker(emp_name varchar(255),street varchar(255),city varchar(255));
create table works(emp_name varchar(255),company_name varchar(255),salary int);
create table company(company_name varchar(255),city varchar(255));
create table manages(emp_name varchar(255),manager_name varchar(255));


-- Question 11
-- NUMBER OF USERS WHO PURCHASED PRODUCTS ON MULTIPLE DAYS(A USER CAN PURCHASE MULTIPLE PRODUCTS ON A SINGLE DAY)
create table input(transaction_id int,user_id varchar(255),transaction_date date,product_id varchar(255),quantity int);
insert into input values(1,'U1','2020-12-16','P1',2),(2,'U2','2020-12-16','P2',1),
(3,'U1','2020-12-16','P3',1),(4,'U4','2020-12-16','P4',4),
(5,'U2','2020-12-17','P5',3),(6,'U2','2020-12-17','P6',2),
(7,'U4','2020-12-18','P7',1),(8,'U3','2020-12-19','P8',2),
(9,'U3','2020-12-19','P9',8);

select * from input;
select count(*) as 'users' from (select user_id from input group by user_id
having count(distinct date(transaction_date)) >1) t;






