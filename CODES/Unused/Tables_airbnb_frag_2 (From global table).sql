SET VERIFY OFF;
SET SERVEROUTPUT ON;

BEGIN
    FOR R IN (Select prp_id, prp_title, price_per_night, max_guests from PROPERTY) LOOP
        insert into PROPERTY_1@site2 values (
            R.prp_id, R.prp_title, R.price_per_night, R.max_guests
        );
    END LOOP;

    FOR R IN (Select prp_id, po_id, prp_desc, prp_address, city, zip_code from PROPERTY where c_location = 'Sylhet') LOOP
        insert into PROPERTY_3@site2 values (
            R.prp_id, R.po_id, R.prp_desc, R.prp_address, R.city, R.zip_code
        ); 
    END LOOP;

    FOR R IN (Select * from BOOKING b LEFT JOIN PROPERTY_3 p ON b.prp_id = p.prp_id) LOOP
        insert into BOOKING_2@site2 values (
            R.bk_id, R.po_id, R.prp_id, R.cus_id, R.check_in, R.check_out, R.pay_status, R.book_status
        ); 
    END LOOP; 

    FOR R IN (Select * from PropertyOwner po LEFT JOIN PROPERTY_3 p ON po.po_id = p.po_id) LOOP
        insert into PropertyOwner_2@site2 values (
            R.bk_id, R.po_id, R.prp_id, R.cus_id, R.check_in, R.check_out, R.pay_status, R.book_status
        ); 
    END LOOP;

    FOR R IN (Select * from REVIEW r LEFT JOIN PROPERTY_3 p ON r.prp_id = p.prp_id) LOOP
        insert into REVIEW_2@site2 values (
            R.review_id, R.po_id, R.prp_id, R.cus_id, R.check_in, R.check_out, R.pay_status, R.book_status
        ); 
    END LOOP;

END;
/