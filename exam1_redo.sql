-- ED: OK, 1/2 points back

CREATE view shauc19_q11 as
WITH t as (SELECT sno, -- get weights of all shipments
                  shipments.pno,
                  weight * quantity as weight
           FROM parts,
                shipments),
    s as (SELECT max(weight) -- find the maximum weight value
          FROM t)
SELECT sno, pno, weight -- get the shipping number, parts number and weight of heaviest shipment
FROM t, s
WHERE s.max = t.weight;



CREATE view shauc19_q12 as
WITH
    t as (SELECT city, -- get number of shipments for each supplier city
                 count(*) as count
          FROM shipments,
               suppliers
          where shipments.sno = suppliers.sno
          group by city),
    s as (SELECT max(count) as count -- find the maximum value of shipments for each supplier city
          FROM t)
SELECT city -- select the supplier city that has the maximum value of shipments
FROM t, s
WHERE t.count = s.count;