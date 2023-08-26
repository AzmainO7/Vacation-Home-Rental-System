clear screen;

SET VERIFY OFF;
SET SERVEROUTPUT ON;

BEGIN
    FOR R IN (Select prp_id, prp_title, price_per_night, max_guests
            from PROPERTY) LOOP
        insert into PROPERTY_1@site1 values (
            R.prp_id, R.prp_title, R.price_per_night, R.max_guests
        );
    END LOOP;

    FOR R1 IN (Select prp_id, po_id, prp_desc, prp_address, city, zip_code
             from PROPERTY where city = 'Chittagong') LOOP
        insert into PROPERTY_2@site1 values (
            R1.prp_id, R1.po_id, R1.prp_desc, R1.prp_address, R1.city, R1.zip_code
        ); 
    END LOOP;

    -- FOR R IN (Select po.po_id, po.po_name, po.po_email, po.po_pass, po.po_nid, po.po_address 
    --         from PropertyOwner po 
    --         LEFT JOIN PROPERTY_2@site1 pr ON po.po_id = pr.po_id) LOOP
    --     insert into PropertyOwner_1@site1 values (
    --         R.po_id, R.po_name, R.po_email, R.po_pass, R.po_nid, R.po_address
    --     ); 
    -- END LOOP;

    -- FOR R IN (Select b.bk_id, b.po_id, b.prp_id, b.cus_id, b.check_in, b.check_out, b.pay_status, b.book_status 
    --         from BOOKING b 
    --         LEFT JOIN PROPERTY_2@site1 pr ON b.prp_id = pr.prp_id) LOOP
    --     insert into BOOKING_1@site1 values (
    --         R.bk_id, R.po_id, R.prp_id, R.cus_id, R.check_in, R.check_out, R.pay_status, R.book_status
    --     ); 
    -- END LOOP;

    -- FOR R IN (Select rv.review_id, rv.cus_id, rv.prp_id, rv.rating 
    --         from REVIEW rv 
    --         LEFT JOIN PROPERTY_2@site1 pr ON rv.prp_id = pr.prp_id) LOOP
    --     insert into REVIEW_1@site1 values (
    --         R.review_id, R.cus_id, R.prp_id, R.rating
    --     ); 
    -- END LOOP;

END;
/

commit;

SELECT * FROM PROPERTY_1@site1;
SELECT * FROM PROPERTY_2@site1;
SELECT * FROM BOOKING_1@site1;
SELECT * FROM PropertyOwner_1@site1;
SELECT * FROM REVIEW_1@site1;