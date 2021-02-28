--TASK 3-	
-- As you found out, there are some duplicated order which are incorrect, adjust query from previous task so it does following:
-- Show first name, last name, email, order id and item - COMMENT: same instructions as task2
-- Does not show duplicates. - COMMENT: my solution of task2 already shows each duplicated order only once with the number of occurrences indicated in number_of_records column
-- Order result by customer last name - COMMENT: one small amendment in the ORDER clause

select cs.first_name
  ,cs.last_name
  ,cn.email
  ,od_count.order_id
  ,od_count.item
  ,od_count.number_of_records
from (select od.customer_id
      ,od.order_id
      ,od.item
      ,COUNT(od.order_currency) as number_of_records
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
 order by cs.last_name;
 