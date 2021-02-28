--TASK 4--
--Our company distinguishes orders to sizes by value like so:
--order with value less or equal to 25 euro is marked as SMALL
--order with value more than 25 euro but less or equal to 100 euro is marked as MEDIUM
--order with value more than 100 euro is marked as BIG
--Write query which shows only three columns: full_name (first and last name divided by space), order_id and order_size
--Make sure the duplicated values are not shown

--COMMENT
-- - potential duplicates in "orders" are removed in the "od" subquery
-- - if there was an order which was made by an unknown "customer_id", 
-- the query would include the order anyway (because LEFT (OUTER) JOIN is used)

select cs.first_name || ' ' || cs.last_name as full_name
  ,od.order_id
  ,case when od.order_value <= 25 then 'SMALL'
    when 25 < od.order_value and od.order_value <= 100 then 'MEDIUM'
    when 100 < od.order_value then 'BIG'
    else 'ERROR!!'
  end as order_size
from (select distinct * from orders) as od
  left outer join customers as cs
    on od.customer_id = cs.customer_id;
 