select * from Student_tb1 order by Stud_id;

select * from Course_tb1 order by course_id;

select * from Student_fees_tb1;

select * from Student_BKP order by Stud_id;

select * from Student_HIST order by Stud_id;

set pagesize 100;
set line  200;

show errors 

Set serveroutput ON;


Update Student_fees_tb1 set Balance_fees = 0, fees_paid = 11292 Where Stud_id = 42;


Doubts:

Q.1 Why dclaraton is not allowd?


CREATE OR REPLACE TRIGGER Stud_feeTri
BEFORE INSERT
ON Student_tb1 FOR EACH ROW
Declare
X Number;
BEGIN
select Course_Fees into X from courses_tbl where course_id = :new.Stud_Standard_id;
INSERT INTO Student_fees_tb1 VALUES(:new.Stud_id, :new.Stud_name , X , 0 , X);

END;
/ 