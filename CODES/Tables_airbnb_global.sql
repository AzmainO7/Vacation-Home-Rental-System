CLEAR SCREEN;

DROP TABLE Customer CASCADE CONSTRAINTS;
DROP TABLE PropertyOwner CASCADE CONSTRAINTS;
DROP TABLE Property CASCADE CONSTRAINTS;
DROP TABLE Booking CASCADE CONSTRAINTS;
DROP TABLE Review CASCADE CONSTRAINTS;

CREATE TABLE Customer(
    cus_id int not null,
    cus_name varchar2(20) not null,
    cus_email varchar2(20) not null,
    cus_pass varchar2(15) not null,
    cus_age int not null,
    cus_address varchar2(20) not null,
    PRIMARY KEY(cus_id)
);

CREATE TABLE PropertyOwner(
    po_id int not null,
    po_name varchar2(5) not null,
    po_email varchar2(15) not null,
    po_pass varchar2(5) not null,
    po_nid int not null,
    po_address varchar2(5) not null,
    PRIMARY KEY(po_id)
);

CREATE TABLE Property(
    prp_id int not null,
    po_id int not null,
    prp_title varchar2(5) not null,
    prp_desc varchar2(5) not null,
    prp_address varchar2(20) not null,
    city varchar2(10) not null,
    zip_code varchar2(5) not null,
    price_per_night numeric(20,2) not null,
    max_guests varchar2(5) not null,
    --amenities varchar2(100) not null,
    PRIMARY KEY(prp_id),
    FOREIGN KEY(po_id) REFERENCES PropertyOwner(po_id)
);

CREATE TABLE Booking(
    bk_id int not null,
	po_id int not null,
	prp_id int not null,
	cus_id int not null,
	check_in date not null,
	check_out date not null,
	total_price numeric(20,2) not null,
	pay_status VARCHAR2(10) not null,
	book_status VARCHAR2(10) not null,
    PRIMARY KEY(bk_id),
	FOREIGN KEY(cus_id) REFERENCES Customer(cus_id),
    FOREIGN KEY(po_id) REFERENCES PropertyOwner(po_id)
);

CREATE TABLE Review(
    review_id int not null,
	cus_id int not null,
	prp_id int not null,
    rating int not null,
    --review_date date not null,
    PRIMARY KEY(review_id),
    FOREIGN KEY(cus_id) REFERENCES Customer(cus_id),
	FOREIGN KEY(prp_id) REFERENCES Property(prp_id)
);

--CLEAR SCREEN;

INSERT INTO Customer VALUES (1,'A','a@gmail.com','123',20,'Dhaka');
INSERT INTO Customer VALUES (2,'B','b@gmail.com','123',25,'Dhaka');

INSERT INTO PropertyOwner VALUES (1,'POwnA','poa@gmail.com','123',19024,'Dhaka');
INSERT INTO PropertyOwner VALUES (2,'POwnB','pobb@gmail.com','123',19027,'Dhaka');

INSERT INTO Property VALUES (1,2,'abc','xyz','Sylhet','Sylhet', '207', 1000, 5);
INSERT INTO Property VALUES (2,2,'abc','xyz','Chittagong','Chittagong', '210', 1200, 2);

INSERT INTO Booking VALUES (1, 2, 2, 1, DATE '2023-08-16', DATE '2023-06-18', 2500.00,'done', 'done');

INSERT INTO Review VALUES (1, 1, 1, 5);

COMMIT;

SELECT * FROM Customer;
SELECT * FROM PropertyOwner;
SELECT * FROM Property;
SELECT * FROM Booking;
SELECT * FROM Review;
