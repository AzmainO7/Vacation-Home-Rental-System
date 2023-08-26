CLEAR SCREEN;

DROP TABLE Customer_1 CASCADE CONSTRAINTS;
DROP TABLE PropertyOwner_1 CASCADE CONSTRAINTS;
DROP TABLE Property_1 CASCADE CONSTRAINTS;
DROP TABLE Property_2 CASCADE CONSTRAINTS;
DROP TABLE Booking_1 CASCADE CONSTRAINTS;
DROP TABLE Review_1 CASCADE CONSTRAINTS;

CREATE TABLE Customer_1(
    cus_id int not null,
    cus_name varchar2(10) not null,
    cus_email varchar2(15) not null,
    cus_pass varchar2(10) not null,
    cus_age int not null,
    cus_address varchar2(10) not null,
    PRIMARY KEY(cus_id)
);

CREATE TABLE PropertyOwner_1(
    po_id int not null,
    po_name varchar2(5) not null,
    po_email varchar2(15) not null,
    po_pass varchar2(5) not null,
    po_nid int not null,
    po_address varchar2(5) not null,
    PRIMARY KEY(po_id)
);


CREATE TABLE Property_1(
    prp_id int not null,
    prp_title varchar2(10) not null,
	price_per_night int not null,
    max_guests varchar2(5) not null,
    --amenities varchar2(100) not null,
    PRIMARY KEY(prp_id)
);


CREATE TABLE Property_2(
    prp_id int not null,
    po_id int not null,
    prp_desc varchar2(5) not null,
    prp_address varchar2(5) not null,
    city varchar2(10) not null,
    zip_code varchar2(5) not null,
    PRIMARY KEY(prp_id),
    FOREIGN KEY(po_id) REFERENCES PropertyOwner_1(po_id)
);

CREATE TABLE Booking_1(
    bk_id int not null,
	po_id int not null,
	prp_id int not null,
	cus_id int not null,
	check_in date not null,
	check_out date not null,
	--total_price int not null,??????????
	pay_status VARCHAR2(5) not null,
	book_status VARCHAR2(5) not null,
    PRIMARY KEY(bk_id),
	FOREIGN KEY(cus_id) REFERENCES Customer_1(cus_id),
    FOREIGN KEY(po_id) REFERENCES PropertyOwner_1(po_id),
	FOREIGN KEY(prp_id) REFERENCES Property_2(prp_id)
);

CREATE TABLE Review_1(
    review_id int not null,
	cus_id int not null,
	prp_id int not null,
    rating int not null,
    --review_date date not null,
    PRIMARY KEY(review_id),
    FOREIGN KEY(cus_id) REFERENCES Customer_1(cus_id),
	FOREIGN KEY(prp_id) REFERENCES Property_2(prp_id)
);

--COMMIT;
--CLEAR SCREEN;


INSERT INTO Customer_1 VALUES (1,'A','a@gmail.com','123',20,'Dhaka');
INSERT INTO Customer_1 VALUES (2,'B','b@gmail.com','123',25,'Dhaka');


INSERT INTO PropertyOwner_1 VALUES (1,'POwnA','poa@gmail.com','123',19024,'Dhaka');
INSERT INTO PropertyOwner_1 VALUES (2,'POwnB','pobb@gmail.com','123',19027,'Dhaka');

INSERT INTO Property_1 VALUES (1,'ptitel1', 1000, 5);
INSERT INTO Property_1 VALUES (2,'ptitel2', 1000, 5);

INSERT INTO Property_2 VALUES (1,2,'pdes1','padd1','cityctg1', '2071');
INSERT INTO Property_2 VALUES (2,2,'pdes2','padd2','cityctg2', '2072');


INSERT INTO Booking_1 VALUES (1, 2, 2, 1, DATE '2023-08-16', DATE '2023-06-18', 'done', 'done');

INSERT INTO Review_1 VALUES (1, 1, 2, 5);

COMMIT;