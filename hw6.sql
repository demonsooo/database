-- CSE 414
-- HW6
-- YIJIA LIU
-- 1238339

-- Problem 2
-- a
CREATE TABLE InsuranceCo (
	name varchar(30) primary key,
	phone int(15)
	unique (phone))

CREATE TABLE Vehicle(
	licencePlate varchar(10) primary key,
	year int,
	ssn int references Person(ssn))
	
CREATE TABLE Person(
	ssn int primary key,
	name varchar(30))
	
CREATE TABLE Car (
	make varchar(30),
	licencePlate varchar(10) references Vehicle(licencePlate))
	
CREATE TABLE Truck (
	capacity int,
	licencePlate varchar(10) references Vehicle(licencePlate))

CREATE TABLE Driver(
	licenceNo int primary key,
	ssn int references Person(ssn))	
	
CREATE TABLE nonProfessionalDriver(
	licenceNo int references Driver(licenceNo),
	ssn int references Driver(ssn))	
	
CREATE TABLE ProfessionalDriver(
	licenceNo int references Driver(licenceNo),
	medicalHistory text,
	ssn int references Driver(ssn))	

CREATE TABLE insures(
	maxLiability int,
	maxLossDamage int,
	licencePlate varchar(10) references Vehicle(licencePlate),
	name varchar(30) references InsuranceCo(name),
	primary key(licencePlate))
	
CREATE TABLE owns (
	licencePlate varchar(10) references Vehicle(licencePlate),
	ssn int references Person(ssn),
	unique(licencePlate))
		
CREATE TABLE drives (
	licencePlate varchar(10) references Car(licencePlate),
	licenceNo varchar(30) references nonProfessionalDriver(licenceNo))
		
CREATE TABLE operates (
	licencePlate varchar(10) references Trucks(licencePlate),
	licenceNo varchar(30) references  ProfessionalDriver(licenceNo),
	unique(licencePlate))	
	
-- b
-- the 'insures' relation represents this relationship. 
-- it represents that one vehicle is insured by at most one insuranceCo
-- and one insuranceCo could insure multiple vehicles. 
-- Therefore I put an unique constraint to each name, licencePlate pair

-- c
-- the 'operates' relationship has a multiple - to - one constraint 
-- while the 'drives' relationship does not.
-- so the 'operates' has a unique constraint on licencePlate

/*
Problem 4
a)
no functional dependency

b)
A --> B, B --> C, C --> D, D --> A

c)
A --> B, B --> A, C --> A, C --> D, D --> A	
*/


-- Problem 5
-- PART I
CREATE TABLE sales (
name varchar(10),
discount varchar(3),
month varchar(3),
price int,
primary key(name, discount, month, price));

.separator \t
	
.import 'mrFrumbleData.txt' sales

-- PART II
-- check name --> price
select name from sales
group by name
having count(distinct price) > 1;

-- check month --> discount
select month from sales 
group by month
having count(distinct discount) > 1;

-- check name, discount --> month
select name from sales
group by name, discount
having count(distinct month) > 1;

-- PART III
-- decompose 
-- R(n,d,m,p)
-- R1(n,p), R2(n,d,m)
-- R21(m,d), R22(m, n) 
CREATE TABLE nameprice (
name varchar(10) primary key,
price int check (price >= 0));

CREATE TABLE monthdis (
month varchar(3) primary key,
discount varchar(3) check (discount like '%');

CREATE TABLE namemonth (
name varchar(10) references nameprice(name),
month varchar(3) references monthdis(month),
primary key (name, month));


--PART IV
CREATE VIEW NP AS
select name, price from sales
group by name, price;

select * from NP;
/*

*/

CREATE VIEW MD AS
select month, discount from sales
group by month, discount;

select * from MD;
/*

*/

CREATE VIEW NM AS
select name, month from sales
group by name, month;

select * from NM;
/*

*/











	
	
	
	
	
	
	
	
	
	
	
	
	