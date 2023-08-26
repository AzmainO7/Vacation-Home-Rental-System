set verify off;

set serveroutput on;

--reg
accept reg_name char prompt "reg_name: "

accept reg_email char prompt "reg_email: "

accept reg_pass char prompt "reg_pass: "

accept reg_age char prompt "reg_age: "

accept reg_address char prompt "reg_address: "

CREATE OR REPLACE TRIGGER REG_1 AFTER
    INSERT ON CUSTOMER
BEGIN
    DBMS_OUTPUT.PUT_LINE('reg completed');
END;
/

CREATE OR REPLACE PACKAGE PKG_USER AS

    PROCEDURE REGISTER_USER(
        IN_NAME IN CUSTOMER.CUS_NAME%TYPE,
        IN_EMAIL IN CUSTOMER.CUS_EMAIL%TYPE,
        IN_PASS IN CUSTOMER.CUS_PASS%TYPE,
        IN_AGE IN CUSTOMER.CUS_AGE%TYPE,
        IN_ADDRESS IN CUSTOMER.CUS_ADDRESS%TYPE
    );

    FUNCTION IS_VALID_PASSWORD(
        IN_PASS IN CUSTOMER.CUS_PASS%TYPE
    ) RETURN BOOLEAN;
END;
/

-- show ERRORS;

CREATE OR REPLACE PACKAGE BODY PKG_USER AS

    PROCEDURE REGISTER_USER(
        IN_NAME IN CUSTOMER.CUS_NAME%TYPE,
        IN_EMAIL IN CUSTOMER.CUS_EMAIL%TYPE,
        IN_PASS IN CUSTOMER.CUS_PASS%TYPE,
        IN_AGE IN CUSTOMER.CUS_AGE%TYPE,
        IN_ADDRESS IN CUSTOMER.CUS_ADDRESS%TYPE
    ) IS
        ROW_COUNT        INT;
 -- NAME_TOO_BIG EXCEPTION;
        INVALID_EMAIL EXCEPTION;
        INVALID_PASSWORD EXCEPTION;
    BEGIN
        SELECT
            COUNT(*) INTO ROW_COUNT
        FROM
            CUSTOMER;
 -- IF LENGTH(IN_NAME) > 50 THEN
 --     RAISE NAME_TOO_BIG;
        IF INSTR(IN_EMAIL, '@') = 0 THEN
            RAISE INVALID_EMAIL;
        ELSIF NOT IS_VALID_PASSWORD(IN_PASS) THEN
            RAISE INVALID_PASSWORD;
        ELSE
            INSERT INTO CUSTOMER VALUES (
                ROW_COUNT + 1,
                IN_NAME,
                IN_EMAIL,
                IN_PASS,
                IN_AGE,
                IN_ADDRESS
            );
            RETURN;
        END IF;
    EXCEPTION
 -- WHEN NAME_TOO_BIG THEN
 --     DBMS_OUTPUT.PUT_LINE('Name too big');
        WHEN INVALID_EMAIL THEN
            DBMS_OUTPUT.PUT_LINE('Invalid email format');
        WHEN INVALID_PASSWORD THEN
            DBMS_OUTPUT.PUT_LINE('Invalid password format');
    END REGISTER_USER;

    FUNCTION IS_VALID_PASSWORD(
        IN_PASS IN CUSTOMER.CUS_PASS%TYPE
    ) RETURN BOOLEAN IS
        HAS_UPPERCASE BOOLEAN := FALSE;
        HAS_LOWERCASE BOOLEAN := FALSE;
        HAS_DIGIT     BOOLEAN := FALSE;
    BEGIN
        FOR I IN 1..LENGTH(IN_PASS) LOOP
            IF SUBSTR(IN_PASS, I, 1) BETWEEN 'A' AND 'Z' THEN
                HAS_UPPERCASE := TRUE;
            ELSIF SUBSTR(IN_PASS, I, 1) BETWEEN 'a' AND 'z' THEN
                HAS_LOWERCASE := TRUE;
            ELSIF SUBSTR(IN_PASS, I, 1) BETWEEN '0' AND '9' THEN
                HAS_DIGIT := TRUE;
            END IF;
        END LOOP;
        RETURN HAS_UPPERCASE AND HAS_LOWERCASE AND HAS_DIGIT AND LENGTH(IN_PASS) >= 8;
    END IS_VALID_PASSWORD;
END;
/

-- show ERRORS;

DECLARE
    IN_NAME      CUSTOMER.CUS_NAME%TYPE;
    IN_EMAIL     CUSTOMER.CUS_EMAIL%TYPE;
    IN_PASS      CUSTOMER.CUS_PASS%TYPE;
    IN_AGE       CUSTOMER.CUS_AGE%TYPE;
    IN_ADDRESS   CUSTOMER.CUS_ADDRESS%TYPE;
    NAME_TOO_BIG EXCEPTION;
BEGIN
    BEGIN
        IN_NAME := '&reg_name';
 -- IF LENGTH(IN_NAME) > 20 THEN
 --     RAISE NAME_TOO_BIG;
 -- END IF;
        IN_EMAIL:='&reg_email';
        IN_PASS:='&reg_pass';
        IF LENGTH('&reg_age') > 0 THEN
            IN_AGE := TO_NUMBER('&reg_age');
        ELSE
            IN_AGE := NULL;
        END IF;
        IN_ADDRESS:='&reg_address';
        IF IN_NAME IS NOT NULL AND IN_EMAIL IS NOT NULL AND IN_PASS IS NOT NULL AND IN_AGE IS NOT NULL AND IN_ADDRESS IS NOT NULL THEN
            PKG_USER.REGISTER_USER(IN_NAME, IN_EMAIL, IN_PASS, IN_AGE, IN_ADDRESS);
        ELSE
            DBMS_OUTPUT.PUT_LINE('Please fill out all the information!!!');
        END IF;
    EXCEPTION
        WHEN VALUE_ERROR THEN
            DBMS_OUTPUT.PUT_LINE('Max input size limit crossed.');
    END;
END;
/

-- show errors;

SELECT
    *
FROM
    CUSTOMER;

-- @"C:\Users\Azmain\OneDrive\Documents\VS Code\DDS Lab\Airbnb\PROJECT_login_package.sql"