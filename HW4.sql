-- Shane Hauck & Caleb Way
-- HW 4 - Calculating GPA's

-- Create table that gives all letter grades a numeric GPA value
CREATE table gc(letter_grade char(2),  GPA float(2));
insert into gc values('A+', 4.00);
insert into gc values('A', 3.90);
insert into gc values('A-', 3.70);
insert into gc values('B+', 3.30);
insert into gc values('B', 3.00);
insert into gc values('B-', 2.70);
insert into gc values('C+', 2.30);
insert into gc values('C', 2.00);
insert into gc values('C-', 1.70);
insert into gc values('D+', 1.30);
insert into gc values('D', 1.00);
insert into gc values('D-', 0.70);
insert into gc values('F', 0.00);

-- GPA of Knutson
WITH
    t as (SELECT id FROM STUDENT WHERE name = 'Knutson'),
    s as (SELECT takes.grade, takes.course_id, takes.sec_id
          FROM takes, t
          WHERE takes.id = t.id),
    x as (SELECT credits, course.course_id
          FROM course, s
          WHERE course.course_id = s.course_id),
    y as (SELECT *,
                 gpa * credits as calc
          FROM s,
               gc,
               x
          WHERE s.grade = gc.letter_grade
            AND s.course_id = x.course_id
          GROUP BY s.course_id, s.sec_id, s.grade, gc.letter_grade, gc.GPA, x.credits, x.course_id)
SELECT
    round((sum(y.calc) / sum(x.credits)):: numeric, 2) as cum_gpa
FROM
    x,y;

-- Cumulative GPA for all students
WITH
    s as (SELECT id, name
          FROM student),
    t as (SELECT *
          FROM takes),
    c as (SELECT course_id, credits
          FROM course),
    x as (SELECT name, t.id, t.course_id, sec_id,
                 grade, credits,letter_grade, gpa,
                 GPA * credits as calc
          FROM s, t, c, gc
          WHERE s.id = t.id
            AND t.course_id = c.course_id
            AND t.grade = gc.letter_grade
          ORDER BY s.id)
SELECT
    name, id, round((sum(calc) / sum(credits)):: numeric, 2) as cum_gpa
FROM
    x
GROUP BY
    name, id
ORDER BY
    name;