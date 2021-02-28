--TASK 6--
-- Please find out if some customer was referred by already existing customer
-- Return results in following format:
-- "Customer Last name Customer First name" "Last name First name of customer who recomended the new customer"

select cs_cs.last_name || ' ' || cs_cs.first_name as existing_customer
  ,cs_refby.last_name || ' ' || cs_refby.first_name as was_referred_by
from customers as cs_cs
  INNER join customers as cs_refby
    on cs_cs.referred_by_id = cs_refby.customer_id;