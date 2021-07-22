-- remove any exiting tables
-- drop table if exists customer;
-- drop table if exists addresses;
-- drop table if exists address_Type;
-- drop table if exists delivery_Status_Code;
-- drop table if exists delivery;
-- drop table if exists applied_Coupon;
-- drop table if exists coupon;
-- drop table if exists product_Order;
-- drop table if exists order;
-- drop table if exists order_Status_Code;
-- drop table if exists oroduct_Seller;
-- drop table if exists seller;
-- drop table if exists customer_Product_Reviews;
-- drop table if exists product_Discount_Coupon;
-- drop table if exists product_Details;
-- drop table if exists customer_Address;
-- drop table if exists product_Features;
-- drop table if exists customer_Payment_Modes;
-- drop table if exists product_Type; 
-- drop table if exists product;

-- Tables

create table customer (
    customer_id varchar(30) PRIMARY KEY,
    first_name varchar(30),
    last_name varchar(30),
    contact_no varchar(15),
    email_id varchar(30)
);

create table addresses (
    addesses_id varchar(30) PRIMARY KEY,
    flat_no int,
    building_no varchar(30),
    locality varchar(30),
    street_name varchar(30),
    city varchar(30),
    district varchar(30),
    _state varchar(30),
    pincode int
);

create table address_Type (
    address_type_code varchar(30) PRIMARY KEY,
    address_type varchar(30)
);

create table customer_Address (
    address_type_code varchar(30) references Address_Type(address_type_code) ON DELETE CASCADE ON UPDATE CASCADE,
    customer_id varchar(30) references Customer(customer_id) ON DELETE CASCADE ON UPDATE CASCADE,
    address_id varchar(30) references Addresses(address_id) ON DELETE CASCADE ON UPDATE CASCADE,
    constraint customer_address PRIMARY KEY (address_type_code, customer_id, address_id)
);

create table payments_Mode (
    payment_mode_code varchar(30) PRIMARY KEY,
    payment_method_description text,
    discount_provided_by_partner_bank int check (discount_provided_by_partner_bank>=1 AND discount_provided_by_partner_bank<=99)
);

create table customer_Payment_Modes (
    customer_payment_mode_id varchar(30) PRIMARY KEY,
    customer_id varchar(30) references customer(customer_id) ON DELETE CASCADE ON UPDATE CASCADE,
    payment_method_code varchar(30) references payments_Mode(payment_mode_code) ON DELETE CASCADE ON UPDATE CASCADE,
    card_number varchar(30),
    card_expiry_date date,
    card_holder_name varchar(30)
);

create table product_Type (
    product_type varchar(30) PRIMARY KEY,
    product_category varchar(30)

);

create table product (
    product_id varchar(30) PRIMARY KEY,
    product_name varchar(50),
    product_type varchar(30) references Product_Type(product_type) ON DELETE CASCADE ON UPDATE CASCADE
);

create table product_Features (
    product_feature_id varchar(30) PRIMARY KEY,
    product_feature_name varchar(50),
    product_feature_description text
);


create table product_Details (
    product_id varchar(30) references Product(product_id) ON DELETE CASCADE ON UPDATE CASCADE,
    product_feature_id varchar(30) references Product_Features(product_feature_id) ON DELETE CASCADE ON UPDATE CASCADE,
    values text,
    stock int,
    constraint product_detail PRIMARY KEY(product_id, product_feature_id)
);

create table product_Discount_Coupon (
    product_discount_coupon_code varchar(30) PRIMARY KEY,
    discount int check (discount>=1 AND discount<=99),
    vaild_from timestamp,
    vaild_upto timestamp,
    min_order_amount float check (min_order_amount>10),
    max_order_amount float check (min_order_amount>100 AND max_order_amount<20000),
    product_id varchar(30) references Product(product_id) ON DELETE CASCADE ON UPDATE CASCADE
);

create table customer_Product_Reviews (
    customer_id varchar(30) references Customer(customer_id) ON DELETE CASCADE ON UPDATE CASCADE,
    product_id varchar(30) references Product(product_id) ON DELETE CASCADE ON UPDATE CASCADE,
    ratings int check (ratings>=0 AND ratings<=5),
    product_review text,
    time_stamp timestamp
);

create table seller (
    seller_id varchar(30) PRIMARY KEY,
    seller_name varchar(40),
    seller_contact_no varchar(40),
    seller_email_id varchar(30),
    seller_address_id varchar(30) references Addresses(addesses_id) ON DELETE CASCADE ON UPDATE CASCADE
);



create table product_Seller (
    product_id varchar(30) references Product(product_id) ON DELETE CASCADE ON UPDATE CASCADE,
    seller_id varchar(30) references Seller(seller_id) ON DELETE CASCADE ON UPDATE CASCADE,
    constraint product_seller PRIMARY KEY(product_id, seller_id)  
);

create table order_Status_Code (
    order_status_code varchar(30) PRIMARY KEY,
    description text
);

create table customer_Order (
    order_id varchar(30) PRIMARY KEY,
    customer_id varchar(30) references Customer(customer_id) ON DELETE CASCADE ON UPDATE CASCADE,
    order_timestamp timestamp,
    customer_payment_mode_id varchar(30) references Customer_Payment_Modes(customer_payment_mode_id) ON DELETE CASCADE ON UPDATE CASCADE,
    order_status_code varchar(30) references Order_Status_Code(order_status_code) ON DELETE CASCADE ON UPDATE CASCADE,
    order_placed_timestamp timestamp,
    payment_option varchar(30),
    Total_amount float check(Total_amount>=1)
);

create table customer_Cart (
    customer_id varchar(30) references customer(customer_id) ON DELETE CASCADE ON UPDATE CASCADE,
    product_id varchar(30) references Product(product_id) ON DELETE CASCADE ON UPDATE CASCADE,
    quantity int DEFAULT 1,
    constraint product_customer_pk PRIMARY KEY (product_id,customer_id)
);

create table product_Order (
    order_id varchar(30) references customer_Order(order_id) ON DELETE CASCADE ON UPDATE CASCADE,
    product_id varchar(30) references Product(product_id) ON DELETE CASCADE ON UPDATE CASCADE,
    quantity int DEFAULT 1,
    constraint product_order_pk PRIMARY KEY (order_id,product_id)
);


create table order_Discount_Coupon (
    order_discount_coupon_code varchar(30) PRIMARY KEY,
    discount int check (discount>=1 AND discount<=99),
    vaild_from timestamp,
    vaild_upto timestamp,
    min_order_amount float check (min_order_amount>10),
    max_order_amount float check (min_order_amount>100 AND max_order_amount<20000),
    order_id varchar(30) references customer_Order(order_id) ON DELETE CASCADE ON UPDATE CASCADE
);



create table delivery_Status_Code (
    delivered_status_code varchar(30) PRIMARY KEY, 
    delivery_status_description text
);

create table delivery (
    order_id varchar(30) references customer_Order(order_id) ON DELETE CASCADE ON UPDATE CASCADE,
    delivery_status_code varchar(30) references delivery_status_code(delivered_status_code) ON DELETE CASCADE ON UPDATE CASCADE,
    expected_delivery_date date,
    delivery_start_date date,
    delivered_on timestamp,
    constraint delivery_order_pk PRIMARY KEY(order_id,delivery_status_code)
);




