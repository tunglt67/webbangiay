use master
go
IF EXISTS ( SELECT name
                FROM sys.databases
                WHERE name = N'webbangiay' )
    DROP DATABASE webbangiay
create database webbangiay
go
use webbangiay
go
create table Brands(
	brand_id UNIQUEIDENTIFIER primary key default newid(),
	brand_name nvarchar(100) not null default '',
	created_at datetime,
	updated_at datetime
);
go
create table Categories(
	category_id UNIQUEIDENTIFIER primary key default newid(),
	category_name nvarchar(100) not null default '',
	created_at datetime,
	updated_at datetime
);
go
create table Products(
	product_id UNIQUEIDENTIFIER primary key default newid(),
	product_name nvarchar(100) not null default '',
	brand_id UNIQUEIDENTIFIER,
	category_id UNIQUEIDENTIFIER,
	created_at datetime,
	updated_at datetime
);
go
create table Colors(
	color_id UNIQUEIDENTIFIER primary key default newid(),
	color_name nvarchar(100) not null default '',
	created_at datetime,
	updated_at datetime
);
go
create table Sizes(
	size_id UNIQUEIDENTIFIER primary key default newid(),
	size_value nvarchar(100) not null default '',
	created_at datetime,
	updated_at datetime
);
go
create table Product_detail(
	product_detail_id UNIQUEIDENTIFIER primary key default newid(),
	product_id UNIQUEIDENTIFIER,
	color_id UNIQUEIDENTIFIER,
	size_id UNIQUEIDENTIFIER,
	price float check(price >= 0),
	total_price decimal(20,0) check(total_price >= 0), 
	quantity int,
	[description] nvarchar(255) default '',
	image_url nvarchar(100) default '',
	created_at datetime,
	updated_at datetime
);
go
create table Discounts(
	discount_id UNIQUEIDENTIFIER primary key default newid(),
	product_detail_id UNIQUEIDENTIFIER,
	discount_amount float,
	[start_date] date,
	end_date date,
	created_at datetime,
	updated_at datetime
);
go
create table Reviews (
	review_id UNIQUEIDENTIFIER primary key default newid(),
	customer_id UNIQUEIDENTIFIER,
	product_detail_id UNIQUEIDENTIFIER,
	rating int check(rating >=1 and rating <= 5),
	comment text default '',
	created_at datetime,
	updated_at datetime
);
go
create table Customers (
	customer_id UNIQUEIDENTIFIER primary key default newid(),
	email nvarchar(100) default '',
	[password] nvarchar(100) not null,
	full_name nvarchar(100) default '',
	[address] nvarchar(100) default '',
	phone_number nvarchar(15),
	image_url nvarchar(100),
	created_at datetime,
	updated_at datetime
);
go
create table Addresses (
	address_id UNIQUEIDENTIFIER primary key default newid(),
	customer_id UNIQUEIDENTIFIER,
	address_line nvarchar(100) default '',
	city nvarchar(100) default '',
	country nvarchar(100) default '',
	created_at datetime,
	updated_at datetime
);
go
create table Carts (
	cart_id UNIQUEIDENTIFIER primary key default newid(),
	customer_id UNIQUEIDENTIFIER,
	created_at datetime,
	updated_at datetime
);
go
create table Cart_Items (
	cart_item_id UNIQUEIDENTIFIER primary key default newid(),
	cart_id UNIQUEIDENTIFIER,
	product_detail_id UNIQUEIDENTIFIER,
	quantity int,
	price decimal(20,0) check(price >= 0),
	created_at datetime,
	updated_at datetime
);
go
create table Roles (
	role_id UNIQUEIDENTIFIER primary key default newid(),
	role_name nvarchar(100),
	created_at datetime,
	updated_at datetime
);
go
create table Staffs (
	staff_id UNIQUEIDENTIFIER primary key default newid(),
	role_id UNIQUEIDENTIFIER,
	[card_id] nvarchar(50) default '', -- chứng minh nhân dân
	email nvarchar(100) not null,
	[password] nvarchar(100) not null,
	full_name nvarchar(100) default '',
	image_url nvarchar(10) default '',
	created_at datetime,
	updated_at datetime
);
go
create table Invoices (
	invoices_id UNIQUEIDENTIFIER primary key default newid(),
	staff_id UNIQUEIDENTIFIER,
	customer_id UNIQUEIDENTIFIER,
	total_amount decimal(20,0),
	payment_status int default 0,
	created_at datetime,
	updated_at datetime
);
go
create table Invoices_detail (
	invoices_id UNIQUEIDENTIFIER,
	product_detail_id UNIQUEIDENTIFIER,
	quantity int,
	price decimal(20,0),
	created_at datetime,
	updated_at datetime
);
go
-- Tạo mối quan hệ
-- Product - Brands
ALTER TABLE Products ADD FOREIGN KEY (brand_id) REFERENCES Brands(brand_id)
-- Product - Categories
ALTER TABLE Products ADD FOREIGN KEY (category_id) REFERENCES Categories(category_id)

--Product_detail - Product
ALTER TABLE Product_detail ADD FOREIGN KEY (product_id) REFERENCES Products(product_id)
--Product_detail - Colors
ALTER TABLE Product_detail ADD FOREIGN KEY (color_id) REFERENCES Colors(color_id)
--Product_detail - Sizes
ALTER TABLE Product_detail ADD FOREIGN KEY (size_id) REFERENCES Sizes(size_id)

--Discounts - Product_detail
ALTER TABLE Discounts ADD FOREIGN KEY (product_detail_id) REFERENCES Product_detail(product_detail_id)

--Addresses - Users
ALTER TABLE Addresses ADD FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)

--Invoices_detail - Product_detail
ALTER TABLE Invoices_detail ADD FOREIGN KEY (product_detail_id) REFERENCES Product_detail(product_detail_id)
--Invoices_detail - Invoices
ALTER TABLE Invoices_detail ADD FOREIGN KEY (invoices_id) REFERENCES Invoices(invoices_id)

--Invoices - Users
ALTER TABLE Invoices ADD FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
--Invoices - Staffs
ALTER TABLE Invoices ADD FOREIGN KEY (staff_id) REFERENCES Staffs(staff_id)

--Staffs - Roles
ALTER TABLE Staffs ADD FOREIGN KEY (role_id) REFERENCES Roles(role_id)

--Carts - Customers
ALTER TABLE Carts ADD FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)

-- Cart-Items - Carts
ALTER TABLE Cart_Items ADD FOREIGN KEY (cart_id) REFERENCES Carts(cart_id)
ALTER TABLE Cart_Items ADD FOREIGN KEY (product_detail_id) REFERENCES product_detail(product_detail_id)

--Reviews - Customers
ALTER TABLE Reviews ADD FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
ALTER TABLE Reviews ADD FOREIGN KEY (product_detail_id) REFERENCES Product_detail(product_detail_id)