 show databases;
 use classicmodels;
 select * from customers;


select customernumber, customername, state, creditlimit 
from customers 
where state is not null and creditlimit between 50000 and 100000 
order by creditlimit desc;

select * from products;
select distinct productline from products;
select distinct productline from products where productline like "%cars%";


select * from orders;
select ordernumber, status, coalesce(comments, "-") as comments from orders where status = "shipped";

 
select * from employees;
select employeenumber, firstname, jobtitle,
case
when jobtitle = "president" then "P"
when jobtitle like "%sales manager%" then "SM"
when jobtitle = "sales rep" then "SR"
when jobtitle like "%vp%" then "VP"
else "unknown"
end as jobtitle from employees;


select * from payments;
select year(paymentdate) as paymentyear, min(amount) as minamount from payments group by paymentyear order by paymentyear;


select * from orders;
select year(orderdate) as year, 
concat("Q", quarter(orderdate)) as Quarter, 
count(distinct(customernumber)) as unique_customer,
count(*) as Total_order from orders group by year, quarter order by year, quarter;


select monthname(paymentdate) as Month, concat(format(sum(amount)/1000,0), "K") as Formatted_amount from 
payments group by month having sum(amount) between 500000 and 1000000 order by sum(amount) desc;



create table Journey (bus_id int not null, 
bus_name varchar(30) not null, 
source_station int not null, 
destination varchar(30) not null,
email varchar(30) unique);
desc journey;


create table vendor (vendor_id int unique not null,
vname varchar(30) not null,
email varchar(30) unique,
country varchar(30) default "N/A") ;
drop table vendor;
insert into vendor (vendor_id, vname, email) values(100, "alex", "alex@gmail.com"); 
select * from vendor;

 
create table movies (movie_id int unique not null, 
mname varchar(30) not null, 
release_year varchar(20) default "-",
casts varchar(30) not null,
gender enum("male", "female"), 
no_of_shows int check(no_of_shows>0)); 
desc movies;


create table suppliers (supplier_id int primary key auto_increment, supplier_name varchar(30),
location varchar(30));


create table product (product_id int primary key auto_increment, 
product_name varchar(30) unique not null, pdescription Varchar(30), supplier_id int,
foreign key (supplier_id ) references suppliers(supplier_id) on delete cascade on update cascade);


create table stock (id int primary key auto_increment, product_id int, 
foreign key(product_id) references product(product_id) on delete cascade on update cascade, 
balance_stock int); 


select * from employees;
select * from customers;
select 
e.employeeNumber , concat(e.firstname, " ", e.lastname) as Salesperson, 
count(distinct c.customernumber) as unique_customer from employees as e 
join customers as c on e.employeenumber = c.salesrepemployeenumber
group by e.employeenumber order by COUNT(DISTINCT c.customernumber) DESC; 


select * from customers;
select * from orders;
select * from orderdetails;
select * from products;
select c.customernumber, 
c.customername, p.productcode, p.productname, 
sum(o.quantityordered) as ordered_qty, 
p.quantityinstock as total_inventory, 
(p.quantityinstock - sum(o.quantityordered)) as left_qty 
from customers as c join orders as od on c.customernumber = od.customernumber
join orderdetails as o on o.ordernumber = od.ordernumber
join products as p on o.productcode = p.productcode
group by c.customernumber, c.customername, p.productCode, p.productName, p.quantityInStock 
order by c.customernumber;


create table laptop (laptop_name varchar(30));
create table colours (colour_name varchar(30));
insert into laptop (laptop_name) values ("Dell"), ("Mac"), ("Hp"), ("Lenovo");
select * from laptop;
insert into colours (colour_name) value ("Pink"), ("Yellow"), ("Silver"), ("Black");
select * from laptop cross join colours;
# after performing cross join the no of rows = 62


create table project (EmployeeID int, FullName varchar(30), Gender enum ("Female", "Male"), ManagerID int);
INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);
select * from project;
select m.fullname as Manager_name, 
e.fullname as Employee_name 
from Project as e
join Project as m ON e.ManagerID = m.EmployeeID;


create table Facility (Facility_ID int, Fname varchar(100), 
State varchar(100), Country varchar(100));
alter table Facility modify column Facility_ID int primary key not null;
alter table Facility add column City varchar(100) not null after Fname;
desc Facility;


create table University (ID int, Sname varchar(100));
insert into University (ID, Sname) VALUES (1, "       Pune          University     "), (2, "  Mumbai          University     "),
(3, "     Delhi   University     "),
(4, "Madras University"), (5, "Nagpur University");
select * from university;
SET SQL_SAFE_UPDATES = 0;
update university set Sname = trim(sname);
select * from university;
update university set Sname = "Pune University" where ID = 1;
update university set sname = "Mumbai University" where ID = 2;
update university set sname = "Delhi University" where ID = 3;


select * from product_status; 


call getcustomerlevel(103);


select * from customers;
select * from Payments;
call get_country_payments(2003, "France");


select * from orders;
select year(orderdate) as year, monthname(orderdate) as months, count(*) as total_orders,
concat(format;
 

create table emp_udf (emp_id int primary key auto_increment, ename varchar(100), DOB date);
INSERT INTO Emp_UDF(eName, DOB)
VALUES ("Piyush", "1990-03-30"), ("Aman", "1992-08-15"), ("Meena", "1998-07-28"), ("Ketan", "2000-11-21"), ("Sanjay", "1995-05-21");
select * from emp_udf;
select  calculateage(dob) as age from emp_udf;


select customernumber, customername from customers 
where customernumber not in (select customernumber from orders);


select c.customernumber, c.customername, count(o.ordernumber) as Total_orders
from Customers as c left join orders as o on c.customernumber = o.customernumber
group by c.customerNumber, c.customerName union select c.customernumber, c.customername, count(o.ordernumber) as Total_orders
from orders as o RIGHT JOIN Customers c ON c.customerNumber = o.customerNumber
GROUP BY c.customerNumber, c.customerName;


select orderNumber, MAX(quantityordered) AS quantity_ordered
from (select orderNumber, quantityOrdered, dense_rank() over (partition by ordernumber order by quantityordered DESC) AS quantityRank
FROM Orderdetails) ranked
WHERE quantityRank = 2
GROUP BY orderNumber;


Select min(product_count) as min_total, max(product_count) as max_total
from (select orderNumber, count(*) as product_count from Orderdetails group by orderNumber) 
as counts;


select productLine, count(*) as total from products
where buyPrice > (select avg(buyPrice) from products)
group by productLine;


CALL InsertEmpEH(1, 'John Doe', 'john.doe@example.com');


create table Emp_BIT (Ename varchar(255), Occupation varchar(255), Working_date DATE, Working_hours int);
INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  
SELECT * FROM EMP_BIT;
INSERT INTO EMP_BIT values ("Bella", "Data Analyst", "2020-10--05", -6);



