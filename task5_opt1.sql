--TASK 5--
-- Show all items from orders table which containt in their name 'ea' or start with 'Key'

select DISTINCT orders.item
from orders
where orders.item like '%ea%'
  or orders.item like 'Key%';