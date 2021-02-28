--TASK 1--
--Write query which will match contacts and orders to our customers

--COMMENT
-- - The instructions are quite vague, but I assume we would like to see all customers we have regardless of whether they made 
-- an order or not, resp. regardless of whether they have a contact record or not, hence the joins are both LEFT (OUTER) joins

--OPTION 1 
-- - using * syntax for contacts and orders tables

select cs.customer_id
  ,cs.last_name
  ,cs.first_name
  ,cn.*
  ,od.*
from customers as cs
  LEFT join contacts as cn
    on cs.customer_id = cn.customer_id
  LEFT join orders as od
    on cs.customer_id = od.customer_id;