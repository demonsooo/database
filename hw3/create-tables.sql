-- create-tables.sql
-- YIJIA LIU (#1238339)
-- CSE 414 HW2

sqlite3 hw2db

.header on
.mode column
.nullvalue NULL
PRAGMA foreign_keys=ON;

create table actor (pid int primary key, fname varchar(30), lname varchar(30), 
gender varchar(1));
create table movie (mid int primary key, mname varchar(150), myear int);
create table directors (did int primary key, fname varchar(30), lname varchar(30));
create table casts (pid int, mid int, role varchar(50), foreign key(pid) references actor(pid), foreign key(mid) references movie(mid));
create table movie_directors (did int, mid int, foreign key(did) references directors(did), foreign key(mid) references movie(mid));
create table Genre(mid int, genre varchar(50));

.import actor.txt actor
.import movie.txt movie
.import directors.txt directors
.import casts.txt casts
.import movie_directors.txt movie_directors
.import genre.txt Genre
