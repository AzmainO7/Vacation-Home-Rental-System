set verify off;

set serveroutput on;

--login
accept email char prompt "email: "

accept pass char prompt "pass: "

CREATE OR REPLACE TRIGGER REG_1 AFTER
    INSERT ON CUSTOMER
BEGIN
    DBMS_OUTPUT.PUT_LINE('reg completed');
END;
/

CREATE OR REPLACE PACKAGE PKG_USER AS

    PROCEDURE LOGIN(
        IN_EMAIL IN CUSTOMER.CUS_EMAIL%TYPE,
        IN_PASS IN CUSTOMER.CUS_PASS%TYPE
    );
END;
/

-- show ERRORS;

CREATE OR REPLACE PACKAGE BODY PKG_USER AS

    PROCEDURE LOGIN(
        IN_EMAIL IN CUSTOMER.CUS_EMAIL%TYPE,
        IN_PASS IN CUSTOMER.CUS_PASS%TYPE
    ) IS
        FLAG    INT:=0;
        NAME    CUSTOMER.CUS_NAME%TYPE;
        NOMATCH EXCEPTION;
    BEGIN
        SELECT
            COUNT(*) INTO FLAG
        FROM
            CUSTOMER
        WHERE
            CUS_EMAIL = IN_EMAIL
            AND CUS_PASS = IN_PASS;
        IF FLAG!=0 THEN
            SELECT
                CUS_NAME INTO NAME
            FROM
                CUSTOMER
            WHERE
                CUS_EMAIL = IN_EMAIL
                AND CUS_PASS = IN_PASS;
            DBMS_OUTPUT.PUT_LINE('Login done...welcome '
                                 || NAME);
        ELSE
            RAISE NOMATCH;
        END IF;
    EXCEPTION
        WHEN NOMATCH THEN
            DBMS_OUTPUT.PUT_LINE('No match found');
    END LOGIN;
END;
/

-- show ERRORS;

DECLARE
    EMAIL CUSTOMER.CUS_EMAIL%TYPE;
    PASS  CUSTOMER.CUS_PASS%TYPE;
BEGIN
    EMAIL:='&email';
    PASS:='&pass';
    PKG_USER.LOGIN(EMAIL, PASS);
END;
/

-- show errors;

SELECT
    *
FROM
    CUSTOMER;

-- @"C:\Users\Azmain\OneDrive\Documents\VS Code\DDS Lab\Airbnb\PROJECT_menu_package.sql"