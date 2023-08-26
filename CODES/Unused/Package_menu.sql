-- Clear Screen;

CREATE OR REPLACE PACKAGE pkg_menu AS

    FUNCTION show_menu(uid IN Customer.cus_id%type)
    RETURN NUMBER;

    FUNCTION browse_properties(uid IN Customer.cus_id%type)
    RETURN NUMBER;

    FUNCTION property_details()
    RETURN 
    
END;
/
-- show ERRORS;

CREATE OR REPLACE PACKAGE BODY pkg_menu AS

    FUNCTION show_menu(
        uid IN Customer.cus_id%type
    )
    RETURN NUMBER
    IS
        choice int;
        invalid_choice EXCEPTION;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Enter Choice :');
        DBMS_OUTPUT.PUT_LINE('1. Browse Properties');
        DBMS_OUTPUT.PUT_LINE('2. Browse Bookings');
        DBMS_OUTPUT.PUT_LINE('3. Update Password');

        -- prompt input choice
        choice := 1;

        IF choice = 1 then
            browse_properties(uid);
            DBMS_OUTPUT.PUT_LINE('choice = 1');
        ELSIF choice = 2 then
            -- browse_bookings(uid);
            DBMS_OUTPUT.PUT_LINE('choice = 2');
        ELSIF choice = 3 then
            -- update_password(uid);
            DBMS_OUTPUT.PUT_LINE('choice = 3');
        ELSE
            RAISE invalid_choice;
        END IF;  
                
        RETURN 1;
    EXCEPTION
        WHEN invalid_choice THEN
            DBMS_OUTPUT.PUT_LINE('invalid choice');
            RETURN 0;
    END show_menu;

    FUNCTION browse_properties(
        uid IN Customer.cus_id%type
    )
    RETURN NUMBER
    IS
        choice int;
        count_pr int;
        avail int;
        sr_city Property.city%TYPE;
        sr_checkin Booking%.check_in%TYPE;
        sr_checkout Booking%.check_out%TYPE;
        invalid_choice EXCEPTION;
    BEGIN
        -- prompt search criteria
        FOR R IN (SELECT pk.prp_id, pk.prp_title, pk.price_per_night, pk.max_guests FROM Property pk
                INNER JOIN Booking bk ON pk.prp_id = bk.prp_id
                WHERE pk.city = sr_city AND bk.check_in >= sr_checkout AND bk.check_out <= sr_checkin) LOOP
                avail := R.prp_id;
            DBMS_OUTPUT.PUT_LINE(R.prp_id || ' ' || R.prp_title || ' ' || R.price_per_night || ' ' || R.max_guests);
        END LOOP;

        -- prompt input choice
        choice := 1;
        
        select COUNT(*) into count_pr from Property where prp_id = choice;
        IF count_pr IS NOT NULL then
            DBMS_OUTPUT.PUT_LINE('redirect to property details');
        ELSE
            RAISE invalid_choice;
        END IF;  
                
        RETURN 1;
    EXCEPTION
        WHEN invalid_choice THEN
            DBMS_OUTPUT.PUT_LINE('invalid choice');
            RETURN 0;
    END browse_properties;

END;
/
show ERRORS;

DECLARE
    in1 number;   
BEGIN
    in1 := pkg_menu.show_menu(1);
END;
/

select * from customer;