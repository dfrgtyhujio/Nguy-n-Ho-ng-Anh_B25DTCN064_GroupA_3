create database rikkei_store;
use rikkei_store;

create table users(
  user_id int auto_increment primary key,
  full_name varchar(100),
  email varchar(100),
  address varchar(255)
);

create table categories(
  category_id int auto_increment primary key,
  category_name varchar(100)
);

create table products(
  product_id int auto_increment primary key,
  product_name varchar(100),
  price decimal(10,2),
  stock int,
  category_id int,
  foreign key (category_id) references categories(category_id)
);

create table orders(
  order_id int auto_increment primary key,
  user_id int,
  order_date datetime,
  status varchar(20),
  shipping_address varchar(255),
  total_money decimal(10,2),
  foreign key (user_id) references users(user_id)
);

create table order_details(
  order_detail_id int auto_increment primary key,
  order_id int,
  product_id int,
  quantity int,
  unit_price decimal(10,2),
  foreign key (order_id) references orders(order_id),
  foreign key (product_id) references products(product_id)
);

insert into users(full_name,email,address) values
	('a','a@gmail.com','hn'),
	('b','b@gmail.com','hcm'),
	('c','c@gmail.com','dn'),
	('d','d@gmail.com','hp'),
	('e','e@gmail.com','ct');

insert into categories(category_name) values
	('electronics'),
    ('fashion');

insert into products(product_name,price,stock,category_id) values
	('phone',1000,10,1),
	('laptop',2000,5,1),
	('shirt',50,20,2),
	('tv',1500,3,1),
	('shoes',80,15,2);

insert into orders(user_id,order_date,status,shipping_address,total_money) values
	(1,now(),'paid','hn',2000),
	(2,now(),'paid','hcm',1000),
	(3,now(),'pending','dn',50),
	(1,now(),'cancelled','hn',80),
	(4,now(),'paid','hp',1500);

insert into order_details(order_id,product_id,quantity,unit_price) values
	(1,1,2,1000),
	(2,1,1,1000),
	(3,3,1,50),
	(4,5,1,80),
	(5,4,1,1500);

select o.order_id, o.order_date, u.full_name, o.total_money
from orders o
join users u on o.user_id = u.user_id;

select * 
from products p
join categories c on p.category_id = c.category_id
where c.category_name = 'electronics';

select user_id, full_name, email from users;

select sum(total_money) from orders;

select p.product_id, p.product_name, sum(od.quantity) total_quantity
from order_details od
join products p on od.product_id = p.product_id
group by p.product_id;

select product_id
from order_details
group by product_id
order by sum(quantity) desc
limit 1;

select o.order_id, u.full_name, o.total_money, sum(od.quantity) total_items
from orders o
join users u on o.user_id = u.user_id
join order_details od on o.order_id = od.order_id
group by o.order_id;

select * from products
where product_id not in (select product_id from order_details);

select u.user_id, u.full_name, count(o.order_id) total_orders
from users u
join orders o on u.user_id = o.user_id
group by u.user_id;

select * from products
where price > (select avg(price) from products);

select user_id
from orders
group by user_id
having sum(total_money) >
(
  select avg(total_spent)
  from (
    select sum(total_money) total_spent
    from orders
    group by user_id
  ) t
);

select * from orders
order by total_money desc
limit 1;

select c.category_name, sum(od.quantity * od.unit_price) revenue
from order_details od
join products p on od.product_id = p.product_id
join categories c on p.category_id = c.category_id
group by c.category_id
order by revenue desc
limit 1;

select product_id, sum(quantity) total_quantity
from order_details
group by product_id
order by total_quantity desc, product_id asc
limit 3;

select * from users
where user_id not in (select user_id from orders);