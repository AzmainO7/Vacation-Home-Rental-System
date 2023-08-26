Clear Screen;

set verify off;

set serveroutput on;

accept checkin char prompt "checkin_time: "

accept checkout char prompt "checkout_time: "

CREATE OR REPLACE PACKAGE PKG_SEARCH_PROP AS

    PROCEDURE BROWSE_PROPERTIES(
        C_IN IN BOOKING.CHECK_IN%TYPE,
        C_OUT IN BOOKING.CHECK_OUT%TYPE
    );
END;
/

-- show ERRORS;

CREATE OR REPLACE PACKAGE BODY PKG_SEARCH_PROP AS

    PROCEDURE BROWSE_PROPERTIES(
        C_IN IN BOOKING.CHECK_IN%TYPE,
        C_OUT IN BOOKING.CHECK_OUT%TYPE
    )IS
        AVAIL         INT;
        NO_PROP_FOUND EXCEPTION;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('==========================================');
        FOR R IN (
            SELECT
                PK.PRP_ID,
                PK.PRP_TITLE,
                PK.PRICE_PER_NIGHT,
                PK.MAX_GUESTS
            FROM
                PROPERTY PK
            WHERE
                PK.PRP_ID NOT IN (
                    SELECT
                        BK.PRP_ID
                    FROM
                        BOOKING  BK
                    WHERE
                        BK.CHECK_IN <= C_OUT
                        AND BK.CHECK_OUT >= C_IN
                )
        ) LOOP
            AVAIL := R.PRP_ID;
            DBMS_OUTPUT.PUT_LINE('=> '
                                 || 'Property ID: '
                                 || R.PRP_ID);
            DBMS_OUTPUT.PUT_LINE('=> '
                                 || 'Property Name: '
                                 || R.PRP_TITLE);
            DBMS_OUTPUT.PUT_LINE('=> '
                                 || 'Price Per Night: '
                                 || R.PRICE_PER_NIGHT);
            DBMS_OUTPUT.PUT_LINE('=> '
                                 || 'Max No. of Guests: '
                                 || R.MAX_GUESTS);
            DBMS_OUTPUT.PUT_LINE('==========================================');
        END LOOP;
        IF AVAIL IS NULL THEN
            RAISE NO_PROP_FOUND;
        END IF;
    EXCEPTION
        WHEN NO_PROP_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No property found');
    END BROWSE_PROPERTIES;
END;
/

-- show ERRORS;

DECLARE
    C_IN  BOOKING.CHECK_IN%TYPE;
    C_OUT BOOKING.CHECK_OUT%TYPE;
BEGIN
    C_IN := TO_DATE('&checkin', 'YYYY-MM-DD');
    C_OUT := TO_DATE('&checkout', 'YYYY-MM-DD');
    PKG_SEARCH_PROP.BROWSE_PROPERTIES(C_IN, C_OUT);
END;
/

-- show ERRORS;