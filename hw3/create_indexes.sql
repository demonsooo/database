-- create-indexes.sql
-- YIJIA LIU (#1238339)
-- CSE 414 HW2

--in order to speed up the query 1, 2, 4
create index did_mid on movie_directors(did,mid);

--in order to speed up the query 1, 3, 5
create index pid_mid on casts(pid);

--in order to speed up the query 1, 3, 5
create index c_mid on casts(mid);

--in order to speed up the query 5
create index pid_role on casts(pid, role);

--in order to speed up the query 2, 3, 5
create index year_mid on movie(myear, mid);

--in order to speed up the query 1
create index m_name on movie(mname);

--in order to speed up the query 2
create index g_gr on Genre(genre);

--in order to speed up the query 2
create index g_mid on Genre(mid);

--in order to speed up the query 4
create index dname on directors(fname, lname);

--in order to speed up the query 5
create index aname on actor(fname, lname);
