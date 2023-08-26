set verify off;

set serveroutput on;

accept in_pid char prompt "Property_id: "

accept in_email char prompt "User Email: "

accept in_cin char prompt "Checkin_time: "

accept in_cout char prompt "Checkout_time: "

accept in_guest char prompt "Total_guests: "

CREATE OR REPLACE PACKAGE PKG_BOOK AS

    PROCEDURE BOOK_PROPERTY(
        IN_PID IN PROPERTY.PRP_ID%TYPE,
        IN_EMAIL IN PROPERTYOWNER.PO_EMAIL%TYPE,
        IN_CIN IN BOOKING.CHECK_IN%TYPE,
        IN_COUT IN BOOKING.CHECK_OUT%TYPE,
        IN_GUEST IN PROPERTY.MAX_GUESTS%TYPE
    );

    FUNCTION CALCULATE_DISCOUNT(
        IN_PID IN PROPERTY.PRP_ID%TYPE,
        IN_GUEST IN PROPERTY.MAX_GUESTS%TYPE,
        DISCOUNT_AMOUNT OUT NUMBER
    )RETURN BOOKING.TOTAL_PRICE%TYPE;
END;
/

-- show ERRORS;

CREATE OR REPLACE PACKAGE BODY PKG_BOOK AS

    PROCEDURE BOOK_PROPERTY(
        IN_PID IN PROPERTY.PRP_ID%TYPE,
        IN_EMAIL IN PROPERTYOWNER.PO_EMAIL%TYPE,
        IN_CIN IN BOOKING.CHECK_IN%TYPE,
        IN_COUT IN BOOKING.CHECK_OUT%TYPE,
        IN_GUEST IN PROPERTY.MAX_GUESTS%TYPE
    )IS
        ROW_COUNT       INT;
        OWN_ID          PROPERTYOWNER.PO_ID%TYPE;
        CUST_ID         PROPERTYOWNER.PO_ID%TYPE;
        TOTAL_PRICE     BOOKING.TOTAL_PRICE%TYPE;
        NUM_DAYS        NUMBER;
        DISCOUNT_AMOUNT NUMBER;
 -- NO_PROP_FOUND EXCEPTION;
    BEGIN
        SELECT
            COUNT(*)+1 INTO ROW_COUNT
        FROM
            BOOKING;
        SELECT
            PO_ID INTO OWN_ID
        FROM
            PROPERTY
        WHERE
            PRP_ID = IN_PID;
        SELECT
            CUS_ID INTO CUST_ID
        FROM
            CUSTOMER
        WHERE
            CUS_EMAIL = IN_EMAIL;
        TOTAL_PRICE := CALCULATE_DISCOUNT(IN_PID, IN_GUEST, DISCOUNT_AMOUNT);
        NUM_DAYS := IN_COUT - IN_CIN;
        TOTAL_PRICE := TOTAL_PRICE * NUM_DAYS;
        INSERT INTO BOOKING VALUES (
            ROW_COUNT,
            OWN_ID,
            IN_PID,
            CUST_ID,
            IN_CIN,
            IN_COUT,
            TOTAL_PRICE,
            'Unpaid',
            'Active'
        );
        DBMS_OUTPUT.PUT_LINE('==========================================');
        DBMS_OUTPUT.PUT_LINE('Amount To Pay: '
                             || TOTAL_PRICE );
        DBMS_OUTPUT.PUT_LINE('Nights Booked: '
                             || NUM_DAYS );
        DBMS_OUTPUT.PUT_LINE('Discount: '
                             || DISCOUNT_AMOUNT );
        DBMS_OUTPUT.PUT_LINE('Insert Booking ID: '
                             || ROW_COUNT
                             || ' to Complete Payment');
        DBMS_OUTPUT.PUT_LINE('==========================================');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No data found');
    END BOOK_PROPERTY;

    FUNCTION CALCULATE_DISCOUNT(
        IN_PID IN PROPERTY.PRP_ID%TYPE,
        IN_GUEST IN PROPERTY.MAX_GUESTS%TYPE,
        DISCOUNT_AMOUNT OUT NUMBER
    ) RETURN BOOKING.TOTAL_PRICE%TYPE IS
        TOTAL_PRICE BOOKING.TOTAL_PRICE%TYPE;
        PRICE_PP    PROPERTY.PRICE_PER_NIGHT%TYPE;
    BEGIN
        SELECT
            PRICE_PER_NIGHT INTO PRICE_PP
        FROM
            PROPERTY
        WHERE
            PRP_ID = IN_PID;
        IF IN_GUEST = 3 THEN
            DISCOUNT_AMOUNT := PRICE_PP * 0.05;
            TOTAL_PRICE := PRICE_PP * 0.95;
        ELSIF IN_GUEST = 4 THEN
            DISCOUNT_AMOUNT := PRICE_PP * 0.10;
            TOTAL_PRICE := PRICE_PP * 0.90;
        ELSIF IN_GUEST = 5 THEN
            DISCOUNT_AMOUNT := PRICE_PP * 0.15;
            TOTAL_PRICE := PRICE_PP * 0.85;
        ELSIF IN_GUEST > 5 THEN
            DISCOUNT_AMOUNT := PRICE_PP * 0.20;
            TOTAL_PRICE := PRICE_PP * 0.80;
        ELSE
            DISCOUNT_AMOUNT := 0;
            TOTAL_PRICE := PRICE_PP;
        END IF;
        RETURN TOTAL_PRICE;
    END CALCULATE_DISCOUNT;
END;
/

-- show ERRORS;

DECLARE
    IN_PID   PROPERTY.PRP_ID%TYPE;
    IN_EMAIL PROPERTYOWNER.PO_EMAIL%TYPE;
    IN_CIN   BOOKING.CHECK_IN%TYPE;
    IN_COUT  BOOKING.CHECK_OUT%TYPE;
    IN_GUEST PROPERTY.MAX_GUESTS%TYPE;
BEGIN
    IN_PID := '&in_pid';
    IN_EMAIL := '&in_email';
    IN_CIN := TO_DATE('&in_cin', 'YYYY-MM-DD');
    IN_COUT := TO_DATE('&in_cout', 'YYYY-MM-DD');
    IN_GUEST := '&in_guest';
    PKG_BOOK.BOOK_PROPERTY(IN_PID, IN_EMAIL, IN_CIN, IN_COUT, IN_GUEST);
END;
/

SELECT
    *
FROM
    BOOKING;

--show ERRORS;