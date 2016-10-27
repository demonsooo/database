/*
 CSE 414 HW7
 YIJIA LIU 1238339
 */
CREATE TABLE Plans (
id int primary key,
name varchar(15),
maxMovie int);

CREATE TABLE Customer (
id int primary key,
login varchar(20),
password varchar(20),
fname varchar(20),
lname varchar(20),
pid int references Plans(id),
unique(login));

CREATE TABLE Rental (
mid int,
cid int references Customer(id),
status varchar(10),
outdate varchar(20),
primary key(mid, cid, outdate));

create index planid on Plans(id);
create index customerid on Customer(id);

insert into Plans values(01, 'lite', 1);
insert into Plans values(02, 'basic', 2);
insert into Plans values(03, 'plus', 3);
insert into Plans values(04, 'deluxe', 4);
insert into Plans values(05, 'premium', 5);
insert into Plans values(06, 'super', 6);
insert into Plans values(07, 'addicted', 8);
insert into Plans values(08, 'professional', 10);

insert into Customer values (001, 'abc', '123', 'Amy', 'Gee', 01);
insert into Customer values (002, 'asd', 'sdf', 'Brian', 'Parker', 04);
insert into Customer values (003, 'qwe', 'wer', 'Cate', 'Porter', 02);
insert into Customer values (004, 'zxc', 'xcv', 'Diana', 'Young', 02);
insert into Customer values (005, 'mnb', 'nbv', 'Ester', 'Chen', 03);
insert into Customer values (006, 'lkj', 'poi', 'Finn', 'Zhao', 02);
insert into Customer values (007, 'poi', 'oiu', 'Gary', 'Douglas', 04);
insert into Customer values (008, 'zaq', 'plm', 'Helen', 'Wang', 01);

insert into Rental values (1517926 , 001 , 'closed' , getdate());
insert into Rental values (107448, 003, 'closed', getdate());
insert into Rental values (141877, 003, 'closed', getdate());
insert into Rental values (166994, 004, 'closed', getdate());
insert into Rental values (167917, 002, 'closed', getdate());
insert into Rental values (32573, 002, 'open', getdate());
insert into Rental values (196668, 003, 'open', getdate());
insert into Rental values (224787, 001, 'open', getdate());