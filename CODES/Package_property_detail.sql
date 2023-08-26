set verify off;

set serveroutput on;

accept IN_PID char prompt "Enter_property_id: "

CREATE OR REPLACE PACKAGE PKG_PROP_DETAIL AS

    PROCEDURE PROPERTY_DETAIL(
        PR_ID IN PROPERTY.PRP_ID%TYPE
    );
END;
/

--show ERRORS;

CREATE OR REPLACE PACKAGE BODY PKG_PROP_DETAIL AS

    PROCEDURE PROPERTY_DETAIL(
        PR_ID IN PROPERTY.PRP_ID%TYPE
    )IS
        PR_TITLE           PROPERTY.PRP_TITLE%TYPE;
        PR_PO_ID           PROPERTY.PO_ID%TYPE;
        PR_DESC            PROPERTY.PRP_DESC%TYPE;
        PR_ADDRESS         PROPERTY.PRP_ADDRESS%TYPE;
        PR_CITY            PROPERTY.CITY%TYPE;
        PR_ZIP_CODE        PROPERTY.ZIP_CODE%TYPE;
        PR_PRICE_PER_NIGHT PROPERTY.PRICE_PER_NIGHT%TYPE;
        PR_MAX_GUESTS      PROPERTY.MAX_GUESTS%TYPE;
        PR_PO_NAME         PROPERTYOWNER.PO_NAME%TYPE;
    BEGIN
        SELECT
            PRP_TITLE,
            PO_ID,
            PRP_DESC,
            PRP_ADDRESS,
            CITY,
            ZIP_CODE,
            PRICE_PER_NIGHT,
            MAX_GUESTS INTO PR_TITLE,
            PR_PO_ID,
            PR_DESC,
            PR_ADDRESS,
            PR_CITY,
            PR_ZIP_CODE,
            PR_PRICE_PER_NIGHT,
            PR_MAX_GUESTS
        FROM
            PROPERTY
        WHERE
            PRP_ID = PR_ID;
        SELECT
            PO_NAME INTO PR_PO_NAME
        FROM
            PROPERTYOWNER
        WHERE
            PO_ID = PR_PO_ID;
        DBMS_OUTPUT.PUT_LINE('============ PROPERTY DETAILS ============');
        DBMS_OUTPUT.PUT_LINE('=> Property ID: '
                             || PR_ID);
        DBMS_OUTPUT.PUT_LINE('=> Title: '
                             || PR_TITLE);
        DBMS_OUTPUT.PUT_LINE('=> Property Owner: '
                             || PR_PO_NAME);
        DBMS_OUTPUT.PUT_LINE('=> Description: '
                             || PR_DESC);
        DBMS_OUTPUT.PUT_LINE('=> Location: '
                             || PR_ADDRESS);
        DBMS_OUTPUT.PUT_LINE('=> City: '
                             || PR_CITY);
        DBMS_OUTPUT.PUT_LINE('=> Zip Code: '
                             || PR_ZIP_CODE);
        DBMS_OUTPUT.PUT_LINE('=> Price Per Night: '
                             || PR_PRICE_PER_NIGHT);
        DBMS_OUTPUT.PUT_LINE('=> Max No. of Guests: '
                             || PR_MAX_GUESTS);
        DBMS_OUTPUT.PUT_LINE('==========================================');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No property found');
    END PROPERTY_DETAIL;
END;
/

--show ERRORS;

DECLARE
    PR_ID PROPERTY.PRP_ID%TYPE;
BEGIN
    PR_ID := '&IN_PID';
    PKG_PROP_DETAIL.PROPERTY_DETAIL(PR_ID);
END;
/

--show ERRORS;