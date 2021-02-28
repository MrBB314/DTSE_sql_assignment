--TASK 1--
--Write query which will match contacts and orders to our customers

--OPTION 3
-- - added DISTINCT, which removed some duplicated rows

select distinct cs.customer_id
  ,cs.last_name
  ,cs.first_name
  ,cn.address
  ,cn.city
  ,cn.phone_number
  ,cn.email
  ,od.order_id
  ,od.item
  ,od.order_value
  ,od.order_currency
  ,od.order_date
from customers as cs
  LEFT outer join contacts as cn
    on cs.customer_id = cn.customer_id
  left outer join orders as od
    on cs.customer_id = od.customer_id;