-- Questions/Queries
use pizza_sales_1;
select * from orders;
select * from Orders_details;

-- 1. Retrieve the total number of orders placed.
select count(order_id) as total_orders from orders;

-- 2. Calculate the total revenue generated from pizza sales.
select round(sum(orders_details.quantity * pizzas.price),2) 
as total_sales
from orders_details
join pizzas
on pizzas.pizza_id = orders_details.pizza_id;

-- 3 Identify the highest-priced pizza.
select pizza_types.name, pizzas.price
from pizza_types
join pizzas
on pizzas.pizza_type_id = pizza_types.pizza_type_id
order by price desc
limit 1;


-- 4 Identify the most common pizza size ordered.
select 
count(orders_details.pizza_id), pizzas.size
from orders_details
join pizzas
on pizzas.pizza_id =orders_details.pizza_id
group by pizzas.size 
order by pizzas.size desc ;


-- 5 List the top 5 most ordered pizza types along with their quantities.
select sum(orders_details.quantity),pizza_types.name
from pizza_types
join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join orders_details
on orders_details.pizza_id = pizzas.pizza_id
group by pizza_types.name
order by sum(orders_details.quantity) desc
limit 5;


-- 6 Join the necessary tables to find the total quantity of each pizza category.
select pizza_types.category,
sum(orders_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join orders_details
on orders_details.pizza_id = pizzas.pizza_id
group by pizza_types.category
order by quantity desc;

-- 7 Determine the distribution of orders by hour of the day.
select pizza_types.name,
 sum(orders_details.quantity * pizzas.price) as revenue
 from pizza_types join pizzas
 on pizza_types.pizza_type_id = pizzas.pizza_type_id
 join orders_details
 on orders_details.pizza_id = pizzas.pizza_id
 group by pizza_types.name
 order by revenue desc;


-- 8 Determine the top 3 most ordered pizza types based on revenue.
select pizza_types.name,
sum(orders_details.quantity * pizzas.price) as revenue
from pizza_types join pizzas
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join orders_details
on orders_details.pizza_id = pizzas.pizza_id
group by pizza_types.name order by revenue desc limit 3;

-- 9 group order by date and calculate number of pizzas oredered per day
-- number of pizzas ordered per day
select round(avg(quantity),0) as avg_pizza_ord_per_day from
(select orders.order_date, sum(orders_details.quantity) 
as quantity 
from orders
join orders_details
on orders_details.order_id = orders.order_id
group by orders.order_date) as order_quantity;

-- 10 Analyze the cumulative revenue generated over time.
select round(sum(orders_details.quantity * pizzas.price),2) 
as total_sales
from orders_details
join pizzas
on pizzas.pizza_id = orders_details.pizza_id;




-- 11 Calculate the percentage contribution of each pizza type to total revenue.
SELECT 
    pizza_types.category,
    SUM(orders_details.quantity * pizzas.price) * 100 / (SELECT 
            ROUND(SUM(orders_details.quantity * pizzas.price),
                        2) AS total_sales
        FROM
            orders_details
                JOIN
            pizzas ON pizzas.pizza_id = orders_details.pizza_id) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue DESC;

-- 12 Determine the top 3 most ordered pizza types based on revenue for each pizza category;
select name, revenue from 
(select category, name, revenue, rank()
over(partition by category order by revenue desc) as rn
from
(select pizza_types.category, pizza_types.name,
sum((orders_details.quantity) * pizzas.price) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join
orders_details
on orders_details.pizza_id = pizzas.pizza_id
group by pizza_types.category, pizza_types.name) as a) as b
where rn <= 3;

