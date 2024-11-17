--Identify users who started a session and places an order on the same day for these users, calculate the total number of orders and the total order value for that day.

CREATE TABLE dbo.users(UserId INT PRIMARY KEY,UserName VARCHAR(200));

CREATE TABLE dbo.user_sessions(SessionId INT PRIMARY KEY,UserId INT,SessionDate DATETIME);

CREATE TABLE order_summary (order_id INT PRIMARY KEY,UserId INT,order_value INT,order_date DATETIME);

INSERT INTO users(UserId,UserName) VALUES  
(1,'Guna'),
(2,'Arun'),
(3,'Hari'),
(4,'Mani'),
(5,'Joe')

INSERT INTO order_summary (order_id, UserId, order_value, order_date) 
VALUES (1, 1, 152, '2023-01-01'),
(2, 2, 485, '2023-01-02'),
(3, 3, 398, '2023-01-05'),
(4, 3, 320, '2023-01-05'),
(5, 4, 156, '2023-01-03'),
(6, 4, 121, '2023-01-03'),
(7, 5, 238, '2023-01-04'),
(8, 5, 70, '2023-01-04'),
(9, 3, 152, '2023-01-05'),
(10, 5, 171, '2023-01-04');

INSERT INTO user_sessions(SessionId, UserId, SessionDate) 
VALUES (1, 1, '2023-01-01'),
(2, 2, '2023-01-02'),
(3, 3, '2023-01-05'),
(4, 3, '2023-01-05'),
(5, 4, '2023-01-03'),
(6, 4, '2023-01-03'),
(7, 5, '2023-01-04'),
(8, 5, '2023-01-04'),
(9, 3, '2023-01-05'),
(10, 5, '2023-01-04');

select * from dbo.user_sessions
select * from dbo.users
select * from dbo.order_summary

SELECT S.USERID,u.UserName, S.SessionDate,COUNT(O.ORDER_ID) AS TOTAL_ORDERS, SUM(O.ORDER_VALUE) AS TOTAL_ORDER_VALUE
FROM user_sessions S
JOIN ORDER_SUMMARY O
ON S.USERID = O.USERID
AND S.SessionDate=O.ORDER_DATE
JOIN users u
on u.UserId=s.UserId
GROUP BY S.USERID,S.SessionDate,u.UserName
HAVING COUNT(O.ORDER_ID) >0


