

set GLOBAL local_infile=1;

SET SQL_SAFE_UPDATES = 0;

create table employees(
ID INT,
NAME VARCHAR(200),
DEP_ID INT,
SALARY INT
);

CREATE TABLE department(
ID INT,
DEP_NAME VARCHAR(200)
);

INSERT INTO employees(ID,NAME,DEP_ID,SALARY) VALUES (1,'PAVI','2',3000),(2,'GUNA','2',4000),(3,'ARUN','2',1000);
INSERT INTO employees(ID,NAME,DEP_ID,SALARY) VALUES (4,'PRIYA','1',10000),(5,'JHON','1',90000);
INSERT INTO employees(ID,NAME,DEP_ID,SALARY) VALUES (6,'JOE','3',8900),(7,'RAJA','3',3000),(8,'ARUN','3',10000);
INSERT INTO employees(ID,NAME,DEP_ID,SALARY) VALUES (9,'MOHAN','5',8900)

INSERT INTO department(ID,DEP_NAME) VALUES(1,'HR'),(2,'IT'),(3,'SUPPORT'),('4','NON-IT'),(5,'DEV');

SELECT * FROM department;
SELECT * FROM employees;

-- Without join - The employee and department details are in the same table.

SELECT EmpID,Name, DEP_ID, salary
FROM (
    SELECT DEP_ID, salary,name,id as EmpID,
           ROW_NUMBER() OVER (PARTITION BY DEP_ID ORDER BY salary DESC) AS rank1
    FROM employees
) AS ranked_salaries
WHERE rank1 = 2;

-- With join – Employee and department details are in separate tables.

with temp as(
    SELECT DEP.ID AS DEP_ID, salary,name,EMP.id as EmpID,DEP.DEP_NAME,
           ROW_NUMBER() OVER (PARTITION BY DEP_ID,DEP_NAME ORDER BY salary DESC) AS rank1
    FROM employees EMP
    JOIN department DEP ON DEP.ID=DEP_ID 
)
select DEP_ID,EmpID,NAME,DEP_NAME,salary FROM temp WHERE RANK1=2;

-- Display 0 if there are no employees in one or more departments

with temp as(
    SELECT DEP.ID AS DEP_ID, salary,name,EMP.id as EmpID,DEP.DEP_NAME,
           ROW_NUMBER() OVER (PARTITION BY DEP_ID,DEP_NAME ORDER BY salary DESC) AS rank1
    FROM department DEP
    LEFT JOIN employees EMP ON DEP.ID=DEP_ID 
)
select DEP_ID,DEP_NAME,IFNULL(salary,0) AS salary FROM temp WHERE RANK1=2 OR (IFNULL(EmpID,0)=0 AND RANK1=1);

-- Display the highest salary if there is no second-highest salary.

with temp as(
    SELECT DEP.ID AS DEP_ID, salary,name,EMP.id as EmpID,DEP.DEP_NAME,
           ROW_NUMBER() OVER (PARTITION BY DEP_ID,DEP_NAME ORDER BY salary DESC) AS rank1
    FROM department DEP
	JOIN employees EMP ON DEP.ID=DEP_ID 
)
select DEP_ID,EmpID,NAME,DEP_NAME,salary FROM temp where RANK1=2  OR (rank1 = 1 AND NOT EXISTS (
        SELECT 1 
        FROM temp t2 
        WHERE t2.DEP_ID = temp.DEP_ID AND t2.rank1 = 2
    ));
 
-- Find the count of rows from table1 and table2 using INNER JOIN, LEFT JOIN, and RIGHT JOIN.

create table table1(
id int,
name varchar(200)
);

create table table2(
id int,
MARK INT
);

DELETE FROM table1;
DELETE FROM TABLE2;

insert into table1 values(1,'GUNA'),(1,'GUNA'),(2,'ARUN'),(3,'PAVI'),(4,'JEMA');
insert into table2 values(1,30),(1,30),(1,30),(3,70),(2,50),(2,50),(3,70),(6,90),(7,90);

SELECT * FROM table1;
SELECT * FROM TABLE2;

SELECT COUNT(*)  FROM
TABLE1
INNER JOIN TABLE2 ON TABLE1.ID=TABLE2.ID;

SELECT COUNT(*)  FROM
TABLE1
left JOIN TABLE2 ON TABLE1.ID=TABLE2.ID;

SELECT COUNT(*)  FROM
TABLE1
right JOIN TABLE2 ON TABLE1.ID=TABLE2.ID;

-- Find employees who earn more than their managers

drop table employees_details ;
CREATE TABLE employees_details (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name   VARCHAR(50),
    manager_id INT,
    salary DECIMAL(10, 2)
);

INSERT INTO employees_details (employee_id, first_name, last_name, manager_id, salary) VALUES
(1, 'Alice', 'Smith', NULL, 90000.00),  -- Alice is the top manager
(2, 'Bob', 'Johnson', 1, 95000.00),     -- Bob reports to Alice
(3, 'Charlie', 'Williams', 1, 75000.00),-- Charlie reports to Alice
(4, 'David', 'Brown', 2, 70000.00),     -- David reports to Bob
(5, 'Eva', 'Davis', 2, 65000.00),       -- Eva reports to Bob
(6, 'Frank', 'Garcia', 3, 60000.00),    -- Frank reports to Charlie
(7, 'Grace', 'Martinez', 3, 90000.00);  -- Grace reports to Charlie

select * from employees_details;

SELECT e.employee_id,e.first_name,e.last_name, e.salary AS employee_salary, m.salary AS manager_salary
FROM employees_details e
JOIN employees_details m ON e.manager_id = m.employee_id
WHERE e.salary > m.salary;
