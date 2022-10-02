-- ED: Good
CREATE view shauc19_q10  as
WITH
    t as(
        SELECT
            pno
        FROM
            parts
        WHERE
            pname = 'Bolt'
    ),
    s as (SELECT sno, quantity
          FROM shipments,
               t
          WHERE t.pno = shipments.pno)
SELECT
    s.sno, sname, quantity
FROM
    s, suppliers
WHERE
    s.sno = suppliers.sno;

-- ED: OK now pick out the max row   -6
CREATE view shauc19_q11 as
SELECT
    sno, shipments.pno, max(weight) * quantity as weight
FROM
    parts, shipments
group by shipments.pno, sno, quantity;

-- ED: ON the right track. Gives the wrong answer. Hint: use HAVING -6
CREATE view shauc19_q12 as
WITH
    t as (SELECT city,
                 count(*) as count
          FROM shipments,
               parts
          where shipments.pno = parts.pno
          group by city),
    s as (SELECT max(count) as count
          FROM t)
SELECT
    city
FROM
    t, s
WHERE
    t.count = s.count;