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

insert into users (full_name, email, address) values
	('nguyen van anh', 'anhnv@gmail.com', 'ha noi'),
	('tran thi binh', 'binhtt@gmail.com', 'da nang'),
	('le hoang cuong', 'cuonglh@gmail.com', 'tp hcm'),
	('pham minh duc', 'ducpm@gmail.com', 'hai phong'),
	('ngo thanh hoa', 'hoant@gmail.com', 'can tho'),
	('dang quang long', 'longdq@gmail.com', 'ha noi'),
	('vu duc nam', 'namvd@gmail.com', 'hue');

insert into categories (category_name) values
	('dien thoai'),
	('thoi trang'),
	('gia dung'),
	('phu kien');

insert into products (product_name, price, stock, category_id) values
	('iphone 15 pro', 25000000, 50, 1),
	('ipad air m2', 15000000, 30, 1),
	('samsung s24', 23000000, 40, 1),
	('ao so mi', 450000, 100, 2),
	('quan jean', 600000, 80, 2),
	('noi chien', 2500000, 20, 3),
	('may loc khi', 4000000, 15, 3),
	('chuot logitech', 1200000, 60, 4),
	('ban phim co', 1800000, 25, 4),
	('op lung', 500000, 200, 4);

insert into orders (user_id, order_date, status, shipping_address, total_money) values
	(1, '2024-03-01 10:00:00', 'delivered', 'ha noi', 26200000),
	(1, '2024-03-15 14:30:00', 'delivered', 'ha noi', 1200000),
	(2, '2024-03-10 09:15:00', 'pending', 'da nang', 15000000),
	(3, '2024-03-12 16:00:00', 'cancelled', 'tp hcm', 450000),
	(4, '2024-03-20 11:00:00', 'delivered', 'hai phong', 6500000),
	(6, '2024-03-22 08:00:00', 'shipping', 'ha noi', 23000000);

insert into order_details (order_id, product_id, quantity, unit_price) values
	(1, 1, 1, 25000000),
	(1, 8, 1, 1200000),
	(2, 8, 1, 1200000),
	(3, 2, 1, 15000000),
	(4, 4, 1, 450000),
	(5, 6, 1, 2500000),
	(5, 7, 1, 4000000),
	(6, 3, 1, 23000000);

select o.order_id, o.order_date, u.full_name, o.total_money
from orders as o
join users as u on o.user_id = u.user_id;

select * 
from products as p
join categories as c on p.category_id = c.category_id
where c.category_name = 'electronics';

select user_id, full_name, email from users;

select sum(total_money) from orders;

select p.product_id, p.product_name, sum(od.quantity) total_quantity
from order_details as od
join products as p on od.product_id = p.product_id
group by p.product_id;

select product_id
from order_details
group by product_id
order by sum(quantity) desc
limit 1;

select o.order_id, u.full_name, o.total_money, sum(od.quantity) total_items
from orders as o
join users as u on o.user_id = u.user_id
join order_details as od on o.order_id = od.order_id
group by o.order_id;

select * from products
where product_id not in (select product_id from order_details);

select u.user_id, u.full_name, count(o.order_id) total_orders
from users as u
join orders as o on u.user_id = o.user_id
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
from order_details as od
join products as p on od.product_id = p.product_id
join categories as c on p.category_id = c.category_id
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