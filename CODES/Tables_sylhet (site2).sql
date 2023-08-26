CLEAR SCREEN;

DROP TABLE Customer_2 CASCADE CONSTRAINTS;
DROP TABLE PropertyOwner_2 CASCADE CONSTRAINTS;
DROP TABLE Property_1 CASCADE CONSTRAINTS;
DROP TABLE Property_3 CASCADE CONSTRAINTS;
DROP TABLE Booking_2 CASCADE CONSTRAINTS;
DROP TABLE Review_2 CASCADE CONSTRAINTS;

CREATE TABLE Customer_2(
    cus_id int not null,
    cus_name varchar2(10) not null,
    cus_email varchar2(15) not null,
    cus_pass varchar2(10) not null,
    cus_age int not null,
    cus_address varchar2(10) not null,
    PRIMARY KEY(cus_id)
);

CREATE TABLE PropertyOwner_2(
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


CREATE TABLE Property_3(
    prp_id int not null,
    po_id int not null,
    prp_desc varchar2(5) not null,
    prp_address varchar2(5) not null,
    city varchar2(10) not null,
    zip_code varchar2(5) not null,
    PRIMARY KEY(prp_id),
    FOREIGN KEY(po_id) REFERENCES PropertyOwner_2(po_id)
);

CREATE TABLE Booking_2(
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
	FOREIGN KEY(cus_id) REFERENCES Customer_2(cus_id),
    FOREIGN KEY(po_id) REFERENCES PropertyOwner_2(po_id),
	FOREIGN KEY(prp_id) REFERENCES Property_3(prp_id)
);


CREATE TABLE Review_2(
    review_id int not null,
	cus_id int not null,
	prp_id int not null,
    rating int not null,
    --review_date date not null,
    PRIMARY KEY(review_id),
    FOREIGN KEY(cus_id) REFERENCES Customer_2(cus_id),
	FOREIGN KEY(prp_id) REFERENCES Property_3(prp_id)
);

--COMMIT;
--CLEAR SCREEN;

INSERT INTO Customer_2 VALUES (3,'C','c@gmail.com','123',22,'Dhaka');
INSERT INTO Customer_2 VALUES (4,'D','d@gmail.com','123',21,'Dhaka');


INSERT INTO PropertyOwner_2 VALUES (3,'POwnc','poc@gmail.com','123',234,'Dhaka');
INSERT INTO PropertyOwner_2 VALUES (4,'POwnd','pobd@gmail.com','123',245,'Dhaka');

INSERT INTO Property_1 VALUES (3,'ptitel3', 1000, 5);
INSERT INTO Property_1 VALUES (4,'ptitel4', 1000, 5);

INSERT INTO Property_3 VALUES (3,3,'pdes3','padd3','citysyl3', '2071');
INSERT INTO Property_3 VALUES (4,3,'pdes4','padd4','citysyl4', '2072');


INSERT INTO Booking_2 VALUES (3, 3, 3, 3, DATE '2023-08-16', DATE '2023-06-18', 'done', 'done');

INSERT INTO Review_2 VALUES (3, 3, 3, 3);



