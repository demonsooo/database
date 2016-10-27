--CSE 414 HW1
--YIJIA LIU (1238339)


.header on
.mode column
.nullvalue NULL

-- PART 1
create table R (Avalue int primary key, Bvalue int);

insert into R values(2,4);
insert into R values(1,1);
insert into R values(3,2);


select * from R;


insert into R values('5','2');
/*
I didn't get an error message because sqlite doesn't specify the type to a column, 
it just specify the type to the value. Therefore the sqlite would try to convert 
the String into int.
*/


select Avalue from R;

select Avalue from R where Avalue <= Bvalue;


-- PART 2
create table MyRestaurants (name varchar(20) primary key, type varchar(20), 
		distance int, LVdate varchar(20), like int);

-- PART 3
insert into MyRestaurants values('pinkdoor', 'italian', 5, '2014-7-8', 1);
insert into MyRestaurants values('portageBay', 'brunch', 0.2, '2014-2-3', 1);
insert into MyRestaurants values('cedars', 'mediterranean',0.2 ,null, null);
insert into MyRestaurants values('udon', 'japanese',0.2 ,'2015-2-3', 1); 
insert into MyRestaurants values('campus teriyaki', 'japanese',0.3 ,'2013-6-9', 0);


-- PART 4
select * from MyRestaurants;


-- PART 5
-- a
.separator ','
select * from MyRestaurants;

-- b
.separator '|'
.mode list
select * from MyRestaurants;

-- c
.mode column
.width 15
select * from MyRestaurants;

-- not printing headers
.header off;
-- printing headers
.header off;


-- PART 6
select name,  replace(replace(like, '1', 'I liked it'), '0', 'I hate it') preference
		from MyRestaurants;

-- PART 7
select name from MyRestaurants where LVdate < DATE('now', '-3 month') and like = 1;


