--TASK 2--
-- There is  suspision that some orders were wrongly inserted more times. Check if there are any duplicated orders. 
-- If so, return duplicates with the following details:
-- first name, last name, email, order id and item

--COMMENTS
-- - subquery "od_count" for identification of the duplicated records in orders table beforehand
-- - "number_of_occurrences" column shows how many times the unique record occurred 
-- - "od_count" subquery is then joined with customers and contacts tables, because we need columns from them, too (as per the instructions)
-- - I assume we would also like to know about duplicated orders that were made by "customer_ids" which might potentially not have
-- any records in "contacts" or "customers" tables, too. Hence the two JOINS are LEFT (OUTER) JOINs.

select cs.first_name
  ,cs.last_name
  ,cn.email
  ,od_count.order_id
  ,od_count.item
  ,od_count.number_of_occurrences
from (select od.customer_id
      ,od.order_id
      ,od.item
      ,COUNT(od.order_currency) as number_of_occurrences
    from orders as od
    group by od.customer_id
      ,od.order_id
      ,od.item
      ,od.order_value
      ,od.order_currency
      ,od.order_date
    having count(od.order_currency) > 1) as od_count
  left outer join customers as cs
    on od_count.customer_id = cs.customer_id
  left outer join contacts as cn
    on od_count.customer_id = cn.customer_id
order by od_count.number_of_occurrences desc;
 