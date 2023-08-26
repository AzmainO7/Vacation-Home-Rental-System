set verify off;
set serveroutput on;


--reg
accept reg_name char prompt "reg_name: "
accept reg_email char prompt "reg_email: "
accept reg_pass char prompt "reg_pass: "
accept reg_age char prompt "reg_age: "
accept reg_address char prompt "reg_address: "


--login
accept email char prompt "email: "
accept pass char  prompt "pass: "



create or replace trigger reg_1
after insert 
on Customer_1
BEGIN
	dbms_output.put_line('reg completed');
end;
/

CREATE OR REPLACE PACKAGE pkg_user AS

    PROCEDURE register_user(
        in_name IN Customer_1.cus_name%TYPE,
        in_email IN Customer_1.cus_email%TYPE,
        in_pass IN Customer_1.cus_pass%TYPE,
        in_age IN Customer_1.cus_age%TYPE,
        in_address IN Customer_1.cus_address%TYPE
    );

    PROCEDURE login(
        in_email in Customer_1.cus_email%type,
        in_pass in Customer_1.cus_pass%type
    );

END;
/
 show ERRORS;

CREATE OR REPLACE PACKAGE BODY pkg_user AS

    PROCEDURE register_user(
        in_name IN Customer_1.cus_name%TYPE,
        in_email IN Customer_1.cus_email%TYPE,
        in_pass IN Customer_1.cus_pass%TYPE,
        in_age IN Customer_1.cus_age%TYPE,
        in_address IN Customer_1.cus_address%TYPE
    )
    IS
        row_count int;
        name_too_big EXCEPTION;
        invalid_email EXCEPTION;
        invalid_password EXCEPTION;
        has_uppercase BOOLEAN := FALSE;
        has_lowercase BOOLEAN := FALSE;
        has_digit BOOLEAN := FALSE;
    BEGIN
        SELECT count(*) into row_count from Customer_1@site2;
        IF LENGTH(in_name) > 10 THEN
            RAISE name_too_big;
        ELSIF INSTR(in_email, '@') = 0 THEN
            RAISE invalid_email;
        ELSE
            FOR i IN 1..LENGTH(in_pass) LOOP
                IF SUBSTR(in_pass, i, 1) BETWEEN 'A' AND 'Z' THEN
                    has_uppercase := TRUE;
                ELSIF SUBSTR(in_pass, i, 1) BETWEEN 'a' AND 'z' THEN
                    has_lowercase := TRUE;
                ELSIF SUBSTR(in_pass, i, 1) BETWEEN '0' AND '9' THEN
                    has_digit := TRUE;
                END IF;

                IF has_uppercase AND has_lowercase AND has_digit AND LENGTH(in_pass) >= 8 THEN
                    INSERT INTO Customer_1@site2
                    VALUES (row_count + 1, in_name, in_email, in_pass, in_age, in_address);
                    RETURN;
                END IF;
            END LOOP;
            RAISE invalid_password;
        END IF;
        
    EXCEPTION
        WHEN name_too_big THEN
            DBMS_OUTPUT.PUT_LINE('Name too big');
        WHEN invalid_email THEN
            DBMS_OUTPUT.PUT_LINE('Invalid email format');
        WHEN invalid_password THEN
            DBMS_OUTPUT.PUT_LINE('Invalid password format');
    END register_user;

    PROCEDURE login(
        in_email in Customer_1.cus_email%type,
        in_pass in Customer_1.cus_pass%type
    )
    IS
    flag int:=0;
    name Customer_1.cus_name%type;
    nomatch EXCEPTION;
    BEGIN
        select count(*) into flag from Customer_1@site2 where cus_email = in_email and cus_pass = in_pass;
        if flag!=0 THEN	
            select cus_name into name from Customer_1@site2 where cus_email = in_email and cus_pass = in_pass;
            DBMS_OUTPUT.PUT_LINE('Login done...welcome '|| name);
        ELSE
            raise nomatch;
        end if;
        
        EXCEPTION
            when nomatch THEN
                DBMS_OUTPUT.PUT_LINE('No match found');
    end login;

END;
/
-- show ERRORS;

DECLARE
    in_name Customer_1.cus_name%TYPE ;
    in_email Customer_1.cus_email%TYPE ;
    in_pass Customer_1.cus_pass%TYPE ;
    in_age Customer_1.cus_age%TYPE ;
    in_address Customer_1.cus_address%TYPE;
	
	email Customer_1.cus_email%type;
	pass Customer_1.cus_pass%type;
	
	
    
BEGIN
    --pkg_user.register_user(in_name, in_email, in_pass, in_age, in_address);
    --pkg_user.login('a@gmail.com', '123');
	
	
	
	
	begin
		in_name := '&reg_name' ;
		in_email:='&reg_email';
		in_pass:='&reg_pass';
		in_age:=&reg_age ;
		in_address:='&reg_address';
		if in_name is not null and in_email is not null and in_pass is not null and in_age is not null 
		and in_address is not null then
			pkg_user.register_user(in_name, in_email, in_pass, in_age, in_address);
		ELSE
			DBMS_OUTPUT.PUT_LINE('Not all input entered');
		end if;
	end;
	
	
	begin
		email:='&email';
		pass:='&pass';
		pkg_user.login(email, pass);
	end;
	
	
	
END;
/
show errors;

select * from Customer_1@site2;