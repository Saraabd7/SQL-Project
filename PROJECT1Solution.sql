--Question1 
--1.1 Write a query that lists all Customers in either Paris or London. Include Customer ID, Company Name and all address fields.
SELECT * FROM Customers 
WHERE City = 'LONDON' OR City = 'PARIS'
--1.2 List all products stored in bottles.
SELECT * FROM Products
WHERE QuantityPerUnit LIKE '%Bottles'
--1.3 Repeat question above but add in the Supplier Name and Country.
SELECT * FROM  Products p
INNER JOIN (SELECT SupplierID, CompanyName, Country FROM Suppliers)s ON p.SupplierID = s.SupplierID
WHERE QuantityPerUnit LIKE '%Bottles'

SELECT * FROM Suppliers
--1.4 Write an SQL Statement that shows how many products there are in each category. Include Category Name in result set and list the highest number first.

SELECT c.CategoryID, c.CategoryName, COUNT(p.ProductName) AS 'Total Product' FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryID,c.CategoryName 
ORDER BY [Total Product] DESC;


--1.5 List all UK employees using concatenation to join their title of courtesy, first name and last name together. Also include their city of residence.
SELECT * FROM Employees
SELECT CONCAT(TitleOfCourtesy, FirstName, ' ', LastName) AS 'Name', City 
FROM Employees
WHERE Country LIKE '%UK'

--1.6 List Sales Totals for all Sales Regions (via the Territories table using 4 joins) with a Sales Total greater than 1,000,000. Use rounding or FORMAT to present the numbers. 

SELECT r.RegionDescription, ROUND(SUM(od.UnitPrice*od.Quantity), -5) AS 'Sales' FROM Region r
INNER JOIN Territories t ON r.RegionID=t.RegionID
INNER JOIN EmployeeTerritories et ON t.TerritoryID = et.TerritoryID
INNER JOIN Orders o ON et.EmployeeID=o.EmployeeID
INNER JOIN [Order Details] od ON o.OrderID=od.OrderID 
GROUP BY r.RegionID, R.RegionDescription 
ORDER BY Sales DESC

--1.7 Count how many Orders have a Freight amount greater than 100.00 and either USA or UK as Ship Country.
SELECT COUNT(OrderID)  AS 'Freight Count' FROM Orders
WHERE (ShipCountry = 'USA' OR ShipCountry = 'UK') AND Freight > 100.00


--1.8 Write an SQL Statement to identify the Order Number of the Order with the highest amount of discount applied to that order.

SELECT TOP 1 OrderID, MAX(Discount) AS 'Discount' 
FROM [Order Details] 
GROUP BY OrderID 
ORDER BY Discount DESC

--QUESTION2
-- 2.1 Write the correct SQL statement to create the following table:
/* 2.1 Write the correct SQL statement to create the following table:
Spartans Table – include details about all the Spartans on this course. Separate Title, First Name and Last Name into separate columns, and include University attended, course taken and mark achieved. Add any other columns you feel would be appropriate. 
IMPORTANT NOTE: For data protection reasons do NOT include date of birth in this exercise.
2.2 Write SQL statements to add the details of the Spartans in your course to the table you have created.
*/


CREATE TABLE Spartans(
    
      SeparateTitle VARCHAR (5),
      FirstName VARCHAR (10),
      LastName VARCHAR (20), 
      Age int,
      City VARCHAR (30),
      University VARCHAR (60),
      Course VARCHAR (255), 
      MarkAchived  int,
      );
     DROP TABLE Spartans;

    CREATE TABLE Spartans(
      SpartaID int IDENTITY (1,1),
      SeparateTitle VARCHAR (5),
      FirstName VARCHAR (10),
      LastName VARCHAR (20), 
      Age int,
      City VARCHAR (30),
      University VARCHAR (60),
      Course VARCHAR (255), 
      MarkAchived  VARCHAR (11),
      PRIMARY KEY (SpartaID)
      );
     INSERT INTO Spartans( SeparateTitle, FirstName, LastName, Age,  City, University, Course, MarkAchived
     
     )
VALUES
('Mr.','Abdullah','Ayyaz', '25', 'London', 'University of Westminster', 'Business Economics', '2:1'),
('Mr.', 'Kevin', 'Monteiro', '23', 'Kent', 'CASS', 'MTF', 'Pass'),
('Mr.', 'Ayman', 'Yousefi', '25', 'London', 'University of West London','Computer Science', '2:1'),
('Mr.', 'Zack', 'Davenport', '24', 'Purfleet', 'University of East Anglia','Film and Tv', '2:2'),
('Mr.', 'Elliot', 'Harris', '23', 'Essex', 'Canterbury Christ Church University', 'History', '2:2'),
('Miss', 'Sara', 'Abdrabu', '26', 'London', 'University of Westminster', 'Computer Networks with Security','Merit'),
('Mr.', 'James', 'Hovell', '24', 'Surrey', 'University of Portsmouth', 'Mathematics','2:1')

SELECT * FROM Spartans



--Question 3:
--3.1 List all Employees from the Employees table and who they report to. No Excel required. 
SELECT EmployeeID,
Title + ' ' + FirstName + ' ' + LastName AS 'EmployeeName',
ReportsTo FROM Employees;

--3.2 List all Suppliers with total sales over $10,000 in the Order Details table. Include the Company Name from the Suppliers Table and present as a bar chart as below:
SELECT s.SupplierID, s.CompanyName,
FORMAT(SUM(od.UnitPrice*od.Quantity*(1-od.Discount)), 'N', 'en-uk') AS 'Total Sales'
FROM (([Order Details] od
INNER JOIN Products p ON od.ProductID=p.ProductID)
INNER JOIN Suppliers s ON s.SupplierID=p.SupplierID)
GROUP BY s.SupplierID, s.CompanyName
HAVING SUM((od.UnitPrice*od.Quantity*(1-od.Discount)))>10000;

--3.3 List the Top 10 Customers YTD for the latest year in the Orders file. Based on total value of orders shipped. No Excel required. 
SELECT TOP 10 o.CustomerID, c.CompanyName,
ROUND(SUM(od.UnitPrice*od.Quantity*(1-od.Discount)),2) AS 'Total Value of Order Shipped',
YEAR(ShippedDate) AS 'Year'
FROM ((Orders o
INNER JOIN [Order Details] od ON o.OrderID=od.OrderID)
INNER JOIN Customers c ON c.CustomerID=o.CustomerID)
GROUP BY o.CustomerID, c.CompanyName, YEAR(ShippedDate) HAVING YEAR(ShippedDate) = (SELECT YEAR(MAX(ShippedDate)) 
FROM Orders)
ORDER BY [Total Value of Order Shipped] DESC;

--3.4 Plot the Average Ship Time by month for all data in the Orders Table using a line chart as below. 
SELECT MONTH(ShippedDate) AS 'Months',
AVG(DATEDIFF(DD,OrderDate,ShippedDate)) AS 'AVG Ship Time (Days)'
FROM Orders
GROUP BY MONTH(ShippedDate) HAVING AVG(DATEDIFF(DD,OrderDate,ShippedDate)) IS NOT NULL
ORDER BY [Months];

