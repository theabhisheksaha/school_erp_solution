create table Student_tb1
(
Stud_id Number, Stud_name Varchar2(100) Not Null, Stud_address Varchar2(1000),
Stud_contact_no Number,  
Stud_Standard_id Number FOREIGN KEY refernces  courses_tbl(course_id),
Stud_div Char, 
Parent_name Varchar2(100),
P_contact_no Number,
P_office_add Varchar2(1000),
P_Mobile_no Number,
P_email_id varchar2(300)

);

ALTER TABLE Student_tb1
ADD CONSTRAINT fk_std_id  FOREIGN KEY (Stud_Standard_id)
  REFERENCES Course_tb1(course_id);

  

CREATE TABLE Student_BKP
  AS (SELECT *
      FROM Student_tb1 WHERE 1=2);

	  
CREATE TABLE Student_HIST
  AS (SELECT *
      FROM Student_tb1 WHERE 1=2);
	  
	  
create sequence stud_id;

select stud_id.nextval from dual;



create table Course_tb1
(
Course_id Number PRIMARY KEY , Course_name Varchar2(100) Not Null, Course_Type Varchar2(100), 
Course_Div Char, 
Course_Fees Number
);



  INSERT INTO Course_tb1 
  VALUES (100, 'Engineering', 'Degree', 'D',112793);


    INSERT INTO Course_tb1 
  VALUES (101, 'Pharmacy', 'Degree', 'D',11743);

  



---------------------insert student from table ------------------


	CREATE OR REPLACE PROCEDURE insertDBUSER(
			p_Stud_name IN Student_tb1.Stud_name%TYPE,
			p_Stud_address IN Student_tb1.Stud_address%TYPE,
			p_Stud_contact_no IN Student_tb1.Stud_contact_no%TYPE,
			p_Stud_Standard_id IN Student_tb1.Stud_Standard_id%TYPE,
			p_Stud_div IN Student_tb1.Stud_div%TYPE,
			p_Parent_name  IN Student_tb1.Parent_name%TYPE,
			p_P_contact_no  IN Student_tb1.P_contact_no%TYPE,
			p_P_office_add IN Student_tb1.P_office_add%TYPE,
			p_P_Mobile_no  IN Student_tb1.P_Mobile_no%TYPE,
			p_P_email_id  IN Student_tb1.P_email_id%TYPE
			)
			
		   IS
	BEGIN

	  INSERT INTO Student_tb1 
	  VALUES (stud_id.nextval, p_Stud_name , p_Stud_address, p_Stud_contact_no, 
	  p_Stud_Standard_id ,p_Stud_div, p_Parent_name, p_P_contact_no, p_P_office_add , p_P_Mobile_no, p_P_email_id );

	  COMMIT;

	END;
	/

set serveroutput ON;


  INSERT INTO Student_tb1 
  VALUES (stud_id.nextval, 'Umesh', 'kalyan-421103', 8796503625, '100', 'D', 'Suresh', 9322751997, 'Mulund', 7219145981, 'suresh.parwani@gmail.com' );

  
exec insertDBUSER('Manohar', 'kalyan-421103', 8796503625, '100', 'D', 'Suresh',9322751997, 'Mulund', 7219145981, 'suresh.parwani@gmail.com' );




---------Delete student from table ------------------


CREATE OR REPLACE PROCEDURE DeleteDBUSER(
	   p_Stud_id IN Student_tb1.Stud_id%TYPE
	  )
IS
X Number(4);
Y Number(10);
BEGIN
  
  SELECT count(*) into X FROM Student_tb1 where Stud_id = p_Stud_id;
  
  
  
  
  If X > 0 THEN
    
	SELECT Balance_fees into Y FROM Student_fees_tb1 where Stud_id = p_Stud_id;
	IF Y =0 THEN
   
		Delete from Student_tb1 where  Stud_id = p_Stud_id;
		dbms_output.put_line('Student with Stud_id ' || p_Stud_id || 'succesfully Deleted');
		COMMIT;
		
	else
		dbms_output.put_line('Student with Stud_id ' || p_Stud_id || ' has Balanced Fees of Rs.' || Y );
	
	end if;
 else
	dbms_output.put_line('Student with Stud_id ' || p_Stud_id || 'not exist');
 
 end if;
 END;
/

exec DeleteDBUSER(41); 


-----check NUMBER FUNCTION--------

CREATE FUNCTION is_number (p_string IN VARCHAR2)
   RETURN INT
IS
   v_new_num NUMBER;
BEGIN
   v_new_num := TO_NUMBER(p_string);
   RETURN 1;
EXCEPTION
WHEN VALUE_ERROR THEN
   RETURN 0;
END is_number;





------PROCEDURE TO BE CALLED BY Search FUNCTIONAlITY-------------------------

CREATE OR REPLACE PROCEDURE SearchDBUSER(
			p_strng  IN Varchar2,
			p_Stud_id OUT Student_tb1.Stud_id%TYPE,
			p_Stud_name OUT Student_tb1.Stud_name%TYPE,
			p_Stud_address OUT Student_tb1.Stud_address%TYPE,
			p_Stud_contact_no OUT Student_tb1.Stud_contact_no%TYPE,
			p_Stud_Standard_id OUT Student_tb1.Stud_Standard_id%TYPE,
			p_Stud_div OUT Student_tb1.Stud_div%TYPE
			)
		
IS
X Number(4);
Y NUMBER(4);
BEGIN
  
  
  X := is_number(p_strng);
  
  If X = 1 THEN
  
  
  SELECT count(*) into Y FROM Student_tb1 where Stud_id = TO_NUMBER(p_strng);
	  if Y > 0 THEN
		
	  SELECT Stud_id, Stud_name, Stud_address, Stud_contact_no, Stud_Standard_id, Stud_div 
	  into  p_Stud_id,p_Stud_name, p_Stud_address, p_Stud_contact_no, p_Stud_Standard_id, p_Stud_div 
	  FROM Student_tb1 
	  where Stud_id = TO_NUMBER(p_strng);
	  
	  else
	  
	  dbms_output.put_line('Student with Stud_id ' || p_strng || ' is not found');

	  end if;
	  
  
  elsif X = 0 THEN
  
 
	SELECT count(*) into Y FROM Student_tb1 where Stud_name = p_strng;
 
		if Y > 0 THEN
			
		SELECT Stud_id, Stud_name, Stud_address, Stud_contact_no, Stud_Standard_id, Stud_div 
		 into  p_Stud_id,p_Stud_name, p_Stud_address, p_Stud_contact_no, p_Stud_Standard_id, p_Stud_div 
		 FROM Student_tb1 
		 where Stud_name = p_strng;
			  
		  else
		  
		  dbms_output.put_line('Student with Stud_name ' || p_strng || ' is not found');

		  end if;
		  
	 
 end if;
 
END;
/



EXEC SearchDBUSER('umesh', p_Stud_id, p_Stud_name, p_Stud_address, p_Stud_contact_no, p_Stud_Standard_id, p_Stud_div);
 
------------Search FUNCTIONAlITY-------------------------

 
CREATE OR REPLACE PROCEDURE getDetails(
			p_strng  IN Varchar2
)
IS
  			p_Stud_id Student_tb1.Stud_id%TYPE;
			p_Stud_name Student_tb1.Stud_name%TYPE;
			p_Stud_address Student_tb1.Stud_address%TYPE;
			p_Stud_contact_no Student_tb1.Stud_contact_no%TYPE;
			p_Stud_Standard_id Student_tb1.Stud_Standard_id%TYPE;
			p_Stud_div Student_tb1.Stud_div%TYPE;

BEGIN
    SearchDBUSER(p_strng, p_Stud_id, p_Stud_name, p_Stud_address, p_Stud_contact_no, p_Stud_Standard_id, p_Stud_div);
	DBMS_OUTPUT.PUT_LINE('ID :  ' || p_Stud_id);
	DBMS_OUTPUT.PUT_LINE('Name :  ' || p_Stud_name);
	DBMS_OUTPUT.PUT_LINE('Address :  ' || p_Stud_address);
	DBMS_OUTPUT.PUT_LINE('Contact :  ' || p_Stud_contact_no);
	DBMS_OUTPUT.PUT_LINE('Standard :  ' || p_Stud_Standard_id);
	DBMS_OUTPUT.PUT_LINE('Div :  ' || p_Stud_div);
	
	
END;
/


Exec getDetails('Umesh');     OR   Exec getDetails('5');    




--------------------Edit Student Details ------------------
 
CREATE OR REPLACE PROCEDURE EditDBUSER(
	   
			p_Stud_id IN Student_tb1.Stud_id%TYPE,
			p_Stud_name IN Student_tb1.Stud_name%TYPE,
			p_Stud_address IN Student_tb1.Stud_address%TYPE,
			p_Stud_contact_no IN Student_tb1.Stud_contact_no%TYPE,
			p_Stud_Standard_id IN Student_tb1.Stud_Standard_id%TYPE,
			p_Stud_div IN Student_tb1.Stud_div%TYPE,
			p_Parent_name  IN Student_tb1.Parent_name%TYPE,
			p_P_contact_no  IN Student_tb1.P_contact_no%TYPE,
			p_P_office_add IN Student_tb1.P_office_add%TYPE,
			p_P_Mobile_no  IN Student_tb1.P_Mobile_no%TYPE,
			p_P_email_id  IN Student_tb1.P_email_id%TYPE
			)
	  
IS
X Number(4);
Y NUMBER(4);
Z NUMBER(4);
abc EXCEPTION;   --  usr defined  EXCEPTION For Class update
BEGIN


  SELECT count(*) into X FROM Student_tb1 where Stud_id = p_Stud_id;
  
  If X > 0 THEN
  
	   SELECT Stud_Standard_id into Y FROM Student_tb1 where Stud_id = p_Stud_id;
	   
	   Z := p_Stud_Standard_id - Y;
	 
	  IF Z > 1 THEN
		Raise abc;	   
	   end if;   
	Update Student_tb1 set Stud_name = p_Stud_name, Stud_address = p_Stud_address, Stud_contact_no = p_Stud_contact_no ,
	Stud_Standard_id = p_Stud_Standard_id , Stud_div = p_Stud_div , Parent_name = p_Parent_name , P_contact_no = p_P_contact_no, 
	P_office_add = p_P_office_add, P_Mobile_no =  p_P_Mobile_no, P_email_id = p_P_email_id where  Stud_id = p_Stud_id;
	  
	dbms_output.put_line('Student with Stud_id ' || p_Stud_id || ' succesfully updated');
	   
	COMMIT;
  else
	dbms_output.put_line('Student with Stud_id ' || p_Stud_id || ' Not found');
  end if;
  
  EXCEPTION when abc THEN
  dbms_output.put_line('Invalid update of Class');
END;
/




exec EditDBUSER(7,'Manohar', 'kalyan-421103', 9623210903, '101', 'D', 'Suresh',9322751997, 'Mulund', 7219145981, 'suresh.parwani@gmail.com' );
 

 
  


------ TRIGGER FOR Populating Student_BKP ------------


CREATE OR REPLACE TRIGGER DataMir
BEFORE INSERT
ON Student_tb1 FOR EACH ROW
BEGIN

INSERT INTO Student_BKP VALUES(:new.Stud_id, :new.Stud_name , :new.Stud_address, :new.Stud_contact_no, 
:new.Stud_Standard_id, :new.Stud_div, :new.Parent_name , :new.P_contact_no , :new.P_office_add,
 :new.P_Mobile_no , :new.P_email_id );

END;
/ 




------Student_fees_tb1 -----------

create table Student_fees_tb1
(
Stud_id Number , Stud_name Varchar2(100) Not Null,
Total_fees Number, fees_paid Number, Balance_fees Number
);



------ TRIGGER FOR Populating Student_fees_tb1 ------------

CREATE OR REPLACE TRIGGER Stud_feeTri
BEFORE INSERT
ON Student_tb1 FOR EACH ROW
BEGIN
INSERT INTO Student_fees_tb1 VALUES(:new.Stud_id, :new.Stud_name , 11292 , 0 , 11292);

END;
/ 


------ TRIGGER FOR Populating Student_HIST ------------

CREATE OR REPLACE TRIGGER Stud_RecyTrg
BEFORE Delete
ON Student_tb1 FOR EACH ROW
BEGIN
INSERT INTO Student_HIST VALUES(:old.Stud_id, :old.Stud_name , :old.Stud_address, :old.Stud_contact_no, 
:old.Stud_Standard_id, :old.Stud_div, :old.Parent_name , :old.P_contact_no , :old.P_office_add,
 :old.P_Mobile_no , :old.P_email_id );
END;
/ 

INSERT INTO Student_tb1 
VALUES (stud_id.nextval, 'Ram', 'ulhas-421003', 8989898989, '100', 'A', 'ajay', 9322751997, 'Thane', 7219145981, 'Ram.motwani@gmail.com' );


exec DeleteDBUSER(42); 

Update Student_fees_tb1 set Balance_fees = 0, fees_paid = 11292 Where Stud_id = 42;






















