-- hw2-queries.sql
-- YIJIA LIU (#1238339)
-- CSE 414 HW2

/*
actor (id, fname, lname, gender)
movie (id, name, year)
directors (id, fname, lname)
casts (pid, mid, role)
movie_directors (did, mid)
genre (mid, genre)
*/

-- 1

select distinct x.fname, x.lname 
from actor x, movie y, casts z
where y.mname = 'Officer 444' and x.pid = z.pid and y.mid = z.mid;

-- 2
select distinct x.did, x.fname, x.lname, y.mname, y.myear
from directors x, movie y, movie_directors z, Genre gr
where gr.genre = 'Film-Noir'  and gr.mid = z.mid
and y.mid = z.mid and x.did = z.did and (y.myear % 4) = 0;

-- 3
select distinct x.fname, x.lname from actor x, movie y1, movie y2,
casts z1, casts z2
where 1900 > y1.myear and x.pid = z1.pid and z1.mid = y1.mid
and 2000 < y2.myear and x.pid = z2.pid and z2.mid = y2.mid;

-- investigate
select x.fname, x.lname, z2.role from actor x, movie y1, movie y2,
casts z1, casts z2
where 1900 > y1.myear and x.pid = z1.pid and z1.mid = y1.mid
and 2000 < y2.myear and x.pid = z2.pid and z2.mid = y2.mid
group by x.pid;
-- from the investigation, we can observe that the role played by those actors
-- are 'herself' or 'himself', which means they appear in the movies in memory of them
-- after their death


-- 4
select x.fname, x.lname, count(distinct y.mid) as counts 
from directors x, movie y, movie_directors z
where x.did = z.did and y.mid = z.mid
group by x.fname, x.lname
having counts > 500
order by counts desc;

-- 5
select x.fname, x.lname, count(distinct y.role) as counts
from actor x, casts y, movie z
where z.myear = 2010 and x.pid = y.pid and y.mid = z.mid
group by z.mid, x.pid
having counts >= 5;