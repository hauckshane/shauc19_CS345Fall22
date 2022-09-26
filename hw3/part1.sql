-- Shane Hauck
-- HW 3 - chapter 3 University DB Queries
-- 9/14/22


-- Good Shane.

-- Part 1

-- 3.11 Write the following queries in SQL, using the university schema.
-- 	a. Find the ID and name of each student who has taken at least one Comp.
-- 	   Sci. course; make sure there are no duplicate names in the result.
-- ED: Good Shane
select count(*) from (WITH
	t as (SELECT course_id 
		FROM course 
		WHERE dept_name = 'Comp. Sci.') 
SELECT 
	DISTINCT student.id, student.name 
FROM 
	takes, student, t 
WHERE 
	t.course_id = takes.course_id AND 
	student.id = takes.id) as T;

--	b. Find the ID and name of each student who has not taken any course
--	   offered before 2017.
insert into student values('12345', 'Gatorade', 'Math', 5);
insert into course values('999', 'blah', 'Math', 1);
insert into section values('999', '1', 'Fall', '2018', 'Power', '972', 'D');
insert into takes values('12345', '999', '1', 'Fall', '2018', 'A');

WITH 
	t as (SELECT DISTINCT course_id, year 
		FROM section 
		WHERE year < 2017) 
SELECT 
	DISTINCT student.id, student.name 
FROM 
	takes, student, t 
WHERE 
	t.course_id <> takes.course_id AND 
	student.id = takes.id AND 
	takes.year >= 2017;

delete from takes where id = '12345';
delete from section where year = '2018';
delete from course where course_id = '999';
delete from student where id = '12345';

--	c. For each department, find the maximum salary of instructors in that department.
--	   You may assume that every department has at least one instructor.
SELECT 
	dept_name, max(salary) 
FROM 
	instructor 
GROUP BY 
	dept_name;

--	d. Find the lowest, across all departments, of the per-department maximum
--	   salary computed by the preceding query.
-- ED: Good
WITH 
	t as (SELECT dept_name, max(salary) 
		FROM instructor 
		GROUP BY dept_name) 
SELECT 
	min(max) 
FROM
	t;

-- 3.12 Write the SQL statements using the university schema to perform the following operations:
--	a. Create a new course “CS-001”, titled “Weekly Seminar”, with 0 credits.
-- insert into course values('CS-001', 'Weekly Seminar', 'Comp. Sci.', 0);
-- ERROR:  new row for relation "course" violates check constraint "course_credits_check"
ALTER TABLE course DROP Constraint course_credits_check;
ALTER TABLE course ADD CONSTRAINT course_credits_check CHECK (credits >= 0::numeric);
insert into course values('CS-001', 'Weekly Seminar', 'Comp. Sci.', 0);

--	b. Create a section of this course in Fall 2017, with sec id of 1, and with the
--	   location of this section not yet specified.
insert into section values('CS-001', '1', 'Fall', '2017', null, null, null);

--	c. Enroll every student in the Comp. Sci. department in the above section.
insert into 
	takes 
SELECT 
	ID, 'CS-001', '1', 'Fall', '2017' 
FROM 
	student 
WHERE
	dept_name = 'Comp. Sci.';

--	d. Delete enrollments in the above section where the student’s ID is 12345.
insert into student values('12345', 'Gatorade', 'Comp. Sci.', 5);
insert into takes values('12345', 'CS-001', '1', 'Fall', '2017', 'A');
DELETE FROM 
	takes 
WHERE
	id = '12345' AND 
	course_id = 'CS-001' AND 
	sec_id = '1' AND 
	semester = 'Fall' AND 
	year = '2017';

--	e. Delete the course CS-001. What will happen if you run this delete statement
--	   without first deleting offerings (sections) of this course?
DELETE FROM course WHERE course_id = 'CS-001';
-- when this is done before deleting the offerings of this course it automatically also 
-- deletes the offerings of the course without having 

--	f. Delete all takes tuples corresponding to any section of any course with
--	   the word “advanced” as a part of the title; ignore case when matching the
--	   word with the title
insert into student values('12345', 'Gatorade', 'Math', 5);
insert into course values('999', 'advanced stuff', 'Math', 1);
insert into section values('999', '1', 'Fall', '2018', 'Power', '972', 'D');
insert into takes values('12345', '999', '1', 'Fall', '2018', 'A');

DELETE FROM 
	takes 
WHERE 
	course_id in (SELECT course_id 
			FROM course 
			WHERE title LIKE 'advanced%');

-- 3.24 Using the university schema, write an SQL query to find the name and ID of
-- those Accounting students advised by an instructor in the Physics department.
WITH
    i as (SELECT id FROM instructor WHERE dept_name = 'Physics'),
    s as (SELECT id FROM student where dept_name = 'Accounting')
SELECT
    student.name, student.id
FROM
    advisor, i, s, student
WHERE
    advisor.i_id = i.id AND
    advisor.s_id = s.id AND
    student.id = s.id;

-- 3.25 Using the university schema, write an SQL query to find the names of those
-- departments whose budget is higher than that of Philosophy. List them in alphabetic order.
insert into department values('Philosophy', 'Chandler', 500000);

WITH
    t as (SELECT budget
          FROM department
          WHERE dept_name = 'Philosophy')
SELECT
    department.dept_name
FROM
    department, t
WHERE
    department.budget > t.budget
ORDER BY
    department.dept_name;

-- 3.26 Using the university schema, use SQL to do the following: For each student who
-- has retaken a course at least twice (i.e., the student has taken the course at least
-- three times), show the course ID and the student’s ID.
-- Please display your results in order of course ID and do not display duplicate rows.
SELECT
    course_id, id
FROM
    takes
GROUP BY
    course_id, id
HAVING
    count(*) > 1
ORDER BY
    course_id;

-- 3.27 Using the university schema, write an SQL query to find the IDs of those students
-- who have retaken at least three distinct courses at least once (i.e, the student has taken the course at least two times).
-- Ed: Good.
WITH
    t as (SELECT course_id,
                 id
          FROM takes
          GROUP BY course_id, id
          HAVING count(*) > 1
          ORDER BY course_id)
SELECT
    t.id
FROM
    t
GROUP BY
    t.id
HAVING
    count(t.id) > 2;
