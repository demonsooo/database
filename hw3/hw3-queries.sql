-- question 1
-- 137 rows
select distinct a.fname, a.lname, m.name, c.role 
from actor a, casts c, movie m, (
	select a.id as pid, m.id as mid, count(distinct c.role) as counts
	from a,c,m  
	where m.year = 2010 and a.id = c.pid and c.mid = m.id
	group by z.mid, a.pid
	having counts >= 5
) as qualified
where a.id = qialified.pid 
and m.id = qualified.mid
and a.id = c.pid
and m.id = c.mid;


-- question 2
-- 129 rows
select year, count(id) as counts
from movie m 
where m.id NOT IN(
	select distinct m.id 
	from movie m, casts c, actor a
	where m.id = c.mid and a.id = c.pid
	and upper(a.gender) = 'M' 
)
group by year
order by year;


-- question 3
-- 128 rows
select t.year, f.counts/t.total*100, t.total
from(
 select year, count(id) as counts
 from movie m 
 where m.id NOT IN(
  select distinct m.id 
  from movie m, casts c, actor a
  where m.id = c.mid and a.id = c.pid
  and upper(a.gender) = 'M' 
  group by m.id
 ) 
 group by year) as f,
(select m.year, count(*) as total
	from movie m
	group by year) as t
where f.year = t.year;


-- question 4
-- 1 row
-- Around the world in eighty days  1298
select m.name, count(distinct c.pid) as counts
from movie m, casts c
where m.id = c.mid
group by c.mid, m.name
having count(distinct c.pid) >= all(
	select count(distinct pid)
	from casts
	group by mid);



-- question 5
-- 1 row
-- 2000 ~ 2009 457481
select years.year, years.year + 9, count(m.id) as counts
from (select year from movie m group by year) as years, 
	movie m
where years.year <= m.year and years.year + 10 > m.year
group by years.year
having count(m.id) >= all (
	select count(m.id)
	from (select year from movie m group by year) years, 
    		movie m
  	where years.year <= m.year and years.year + 10 > m.year
  	group by years.year
);

--question 6
-- 1 row
-- 521876 counts
select count(distinct c.pid) as counts
from casts c, casts cKB1,  
	 (select distinct c.pid as id
 	from actor aKB0, casts c, casts cKB0
 	where aKB0.fname = 'Kevin' and aKB0.lname = 'Bacon'
 	and aKB0.id = cKB0.pid and c.mid = cKB0.mid) as aKB1
where aKB1.id = cKB1.pid
and c.mid = cKB1.mid
and c.pid NOT IN(
  select distinct c.pid as id
  from actor aKB0, casts c, casts cKB0
  where aKB0.fname = 'Kevin' and aKB0.lname = 'Bacon'
  and aKB0.id = cKB0.pid and c.mid = cKB0.mid);
  	
-- the azure server runs much faster than sqlite
-- but it's more picky on syntax than sqlite.
-- offering a DBMS as a service in public cloud is convenient for the users.
-- in addition, it saves a lot of resources because people 
-- who need to get access to the same DBMS
-- don't have to construct DBMS individually.
















