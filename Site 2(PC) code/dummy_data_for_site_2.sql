clear screen;
DROP TABLE money;

CREATE TABLE money(
	Fid int, 
	fName varchar2(30), 
	deptid int,
	PRIMARY KEY(Fid));
 
insert into money values(1, 'Abdullah', 1); 
insert into money values(2, 'Rahmatullah', 1); 
insert into money values(3, 'Shariful Islam', 2); 
insert into money values(4, 'Zobair', 3);  

commit;

select * from money;