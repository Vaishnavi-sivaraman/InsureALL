create table productLineMsrp as
select sum(msrp),productLine from products group by productLine;
create database practice;
use practice;

CREATE TABLE studentsSectionWise(
studentId INT,
studentName VARCHAR(100),
sectionName VARCHAR(50),
studentMarks INT 
);

INSERT INTO studentsSectionWise
VALUES (1, 'Geek1','A',461),
(1, 'Geek2','B',401),
(1, 'Geek3','C',340),
(2, 'Geek4','A',446),
(2, 'Geek5','B',361),
(2, 'Geek6','C',495),
(3, 'Geek7','A',436),
(3, 'Geek8','B',367),
(3, 'Geek9','C',498),
(4, 'Geek10','A',206),
(4, 'Geek11','B',365),
(4, 'Geek12','C',485),
(5, 'Geek13','A',446),
(5, 'Geek14','B',368),
 (5, 'Geek15','C',295),
 (6, 'Geek16','C',495);
 
 select * from studentsSectionWise;
 
 select *, row_number() over(order by studentMarks desc) as rank_number from studentsSectionWise;

 select *, avg(studentMarks) over(partition by sectionName) as avg_mark from studentsSectionWise;
 select *,first_value(studentName) over(partition by sectionName order by studentMarks) as low_mark from studentsSectionWise;

 
 select *,row_number() over(partition by sectionName order by studentMarks desc) as rank_number from studentsSectionWise;
 
 select *,row_number() over(partition by sectionName order by studentMarks desc) as rank_number from studentsSectionWise;
 
 with topTwoRankers as(
  select *,row_number() over(partition by sectionName order by studentMarks desc) as rank_number from studentsSectionWise
) 
select * from topTwoRankers where rank_number<=2;

select row_number() over(order by msrp) as row_num,productLIne,msrp from products order by msrp;
select count(*) from products;

-- RANK

CREATE TABLE geek_demo (Name VARCHAR(10) );
INSERT INTO geek_demo (Name)
VALUES ('A'), ('B'), ('B'), ('C'), ('C'), ('D'), ('E');
SELECT * FROM geek_demo;

select name,row_number() over(order by name ) as rank_no from geek_demo; 
select name,rank() over(order by name ) as rank_no from geek_demo;


create table employee(
emp_id int,
emp_name varchar(20),
dept_name varchar(20),
salary int
);

INSERT INTO employee (emp_id, emp_name, dept_name, salary) VALUES (1, 'John Doe', 'HR', 50000);
INSERT INTO employee (emp_id, emp_name, dept_name, salary) VALUES (2, 'Jane Smith', 'Finance', 60000);
INSERT INTO employee (emp_id, emp_name, dept_name, salary) VALUES (3, 'Alice Johnson', 'IT', 70000);
INSERT INTO employee (emp_id, emp_name, dept_name, salary) VALUES (4, 'Bob Brown', 'Marketing', 55000);
INSERT INTO employee (emp_id, emp_name, dept_name, salary) VALUES (5, 'Charlie Davis', 'Sales', 65000);

select max(salary) as max_salary from employee;

select max(salary) as max_salary from employee group by dept_name;

select e.*, 
max(salary) over() as max_salary
from employee e;

select e.*, 
max(salary) over(partition by dept_name) as max_salary
from employee e;

select e.*,row_number() over() as rn from employee e;

INSERT INTO employee (emp_id, emp_name, dept_name, salary) VALUES (6, 'Charlie Davis', 'Sales', 65000);
INSERT INTO employee (emp_id, emp_name, dept_name, salary) VALUES (7, 'Charlie Davis', 'Sales', 75000);
INSERT INTO employee (emp_id, emp_name, dept_name, salary) VALUES (7, 'Charlie Davis', 'Sales', 55000);

select e.*,row_number() over(partition by dept_name order by emp_id) as rn from employee e;

select * from( select e.*,row_number() over(partition by dept_name order by emp_id) as rn from employee e) x
where x.rn<3;

select e.*, row_number() over(partition by dept_name order by salary desc) as rnk from employee e;
select e.*, rank() over(partition by dept_name order by salary desc) as rnk from employee e;

select * from (select e.*, rank() over(partition by dept_name order by salary desc) as rnk from employee e
) x where x.rnk<4;

select e.*, rank() over(partition by dept_name order by salary desc) as rnk,
dense_rank() over(partition by dept_name order by salary desc) as dense_rnk
 from employee e;
 
select e.* , lag(salary) over(partition by dept_name order by salary) as prev_emp_salary
from employee e;

select e.*,lag(salary,2,0) over(partition by dept_name order by salary) as prev_emp_salary from employee e;
-- 2 is previous 2, 0 is for instead of null

select e.* , lag(salary) over(partition by dept_name order by salary) as prev_emp_salary,
lead(salary) over(partition by dept_name order by salary) as next_emp_salary
from employee e;

select e.* ,
lag(salary) over(partition by dept_name order by emp_id) as prev_emp_salary,
case when e.salary>lag(salary) over(partition by dept_name order by emp_id) then 'Higher than previous employee'
	when e.salary=lag(salary) over(partition by dept_name order by emp_id) then 'same than previous employee'
	when e.salary<lag(salary) over(partition by dept_name order by emp_id) then 'lower than previous employee'
    end sal_range
from employee e;

select * from product;
CREATE TABLE product (
    product_category VARCHAR(25),
    brand VARCHAR(25),
    product_name VARCHAR(25),
    price INT
);

-- Insert statements:
INSERT INTO product (product_category, brand, product_name, price)
VALUES ('Electronics', 'Samsung', 'Smartphone', 500);

INSERT INTO product (product_category, brand, product_name, price)
VALUES ('Clothing', 'Nike', 'Sneakers', 100);

INSERT INTO product (product_category, brand, product_name, price)
VALUES ('Home Appliances', 'LG', 'Refrigerator', 800);

INSERT INTO product (product_category, brand, product_name, price)
VALUES ('Beauty', 'L\'Oreal', 'Shampoo', 10);

INSERT INTO product (product_category, brand, product_name, price)
VALUES ('Books', 'Penguin', 'Novel', 20);

select *,
first_value(product_name) over(partition by product_category order by price desc) as most_exp_product
from product;

select *,
first_value(product_name) over(partition by product_category order by price desc) as most_exp_product,
last_value(product_name) over(partition by product_category order by price desc) as least_exp_product
from product;

-- frames are subset of partition
-- default frame calss used in sql is---->range between unbounded preceding and current row 

select *,
first_value(product_name)
	over(partition by product_category order by price desc) as most_exp_product,
last_value(product_name)
	over(partition by product_category order by price desc
    range between unbounded preceding and unbounded following) as least_exp_product
from product;

-- rows and range difference
select *,
first_value(product_name)
	over(partition by product_category order by price desc) as most_exp_product,
last_value(product_name)
	over(partition by product_category order by price desc
    rows between unbounded preceding and unbounded following) as least_exp_product
from product;

select *,
first_value(product_name)
	over(partition by product_category order by price desc) as most_exp_product,
last_value(product_name)
	over(partition by product_category order by price desc
    rows between 2 preceding and 2 following) as least_exp_product
from product;


-- N th value
-- write query to display the second most expensive product under each category

select *,
first_value(product_name) over w as most_exp_product,
last_value(product_name) over w as least_exp_product,
nth_value(product_name,2) over w as second_most_exp_product
from product
window w as (partition by product_category order by price desc
		range between unbounded preceding and unbounded following);
        

-- NTILE
-- write a query to segregate all the expensive phones, mid range phones and the cheaper phones

-- basically create buckets, like segregate data such a way that one bucket will contain the expensive phones, another buckets
-- will contain the mid range phone and so on forth on


select product_name,
case when x.buckets=1 then 'Expensive product'
	when x.buckets=2 then 'Mid range product'
    when x.buckets=3 then 'cheaper products' 
    END Novel_category
from (select *,
ntile(3) over(order by price desc)	as buckets
from product
where product_name='Novel') x;


-- cume_dist  (cumulative distribution)
-- Query to fetch all products which are constitutuing the first 30%
-- of the data in products table based on price

-- select *,
-- cume_dist() over(order by price desc) as cume_distribution,
-- round(cume_dist() over (order by price desc) :: numeric * 100,2) as cume_dist_percentage
-- from product;

percent rank
formual=current row-1/total number of row-1
query to identify how much percentage more expensive is "Galaxy z fold 3" when compared to allthe products 


select *,
percent_rank() over(order by price)	as percentage_rank,
round(percent_rank() over(order by price):: numeric *100,2) as per_rank
from product;

select product_name,per_rank
from(select *,
percent_rank() over(order by price)	as percentage_rank,
round(percent_rank() over(order by price):: numeric *100,2) as per_rank
from product) x
where x.product_name='novel';