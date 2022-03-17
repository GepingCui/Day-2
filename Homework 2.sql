USE AdventureWorks2019
GO

--1. How many products can you find in the Production.Product table?
SELECT COUNT(Distinct ProductID)AS 'Product Count'
FROM Production.Product

--2. Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. 
--The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
SELECT COUNT(Distinct ProductID)AS 'Product Count'
FROM Production.Product
WHERE ProductSubcategoryID is NOT Null

--3. How many Products reside in each SubCategory? 
--Write a query to display the results with the following titles: ProductSubcategoryID CountedProducts
SELECT ProductSubcategoryID,COUNT(Distinct ProductID)AS 'CountedProducts'
FROM Production.Product
WHERE ProductSubcategoryID is NOT Null
GROUP BY ProductSubcategoryID

--4. How many products that do not have a product subcategory?
SELECT COUNT(Distinct ProductID)AS 'Product Count'
FROM Production.Product
WHERE ProductSubcategoryID is Null

--5. Write a query to list the sum of products quantity in the Production.ProductInventory table.
SELECT SUM(Quantity)AS 'Product Quantity'
FROM Production.ProductInventory

--6. Write a query to list the sum of products in the Production.ProductInventory table 
--and LocationID set to 40 and limit the result to include just summarized quantities less than 100.
SELECT ProductID,SUM(Quantity)AS 'TheSum'
FROM Production.ProductInventory
WHERE LocationID=40
GROUP BY ProductID
HAVING SUM(Quantity)<100

--7. Write a query to list the sum of products with the shelf information in 
--the Production.ProductInventory table 
--and LocationID set to 40 and limit the result to include just summarized quantities less than 100

SELECT Shelf,ProductID,SUM(Quantity)AS 'TheSum'
FROM Production.ProductInventory
WHERE LocationID=40
GROUP BY Shelf,ProductID
HAVING SUM(Quantity)<100

--8. Write the query to list the average quantity for products where column LocationID has the value of 10 
--from the table Production.ProductInventory table.
SELECT AVG(Quantity)AS 'Average'
FROM Production.ProductInventory
WHERE LocationID=10

--9. Write query to see the average quantity  of  products by shelf  from the table Production.ProductInventory
SELECT ProductID,Shelf,AVG(Quantity)AS 'TheAvg'
FROM Production.ProductInventory
GROUP BY ProductID,Shelf

--10. Write query to see the average quantity  of  products by shelf 
--excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory
SELECT ProductID,Shelf,AVG(Quantity)AS 'TheAvg'
FROM Production.ProductInventory
WHERE Shelf !='N/A'
GROUP BY ProductID,Shelf

--11. List the members (rows) and average list price in the Production.Product table. 
--This should be grouped independently over the Color and the Class column. 
--Exclude the rows where Color or Class are null.
SELECT Color,Class, COUNT(ProductID)AS 'TheCount',  AVG(ListPrice) AS 'AvgPrice'
FROM Production.Product
WHERE (Color is NOT Null) AND (Class is NOT Null) 
GROUP BY Color, Class

--12. Write a query that lists the country and province names from person.CountryRegion and person.StateProvince tables. 
--Join them and produce a result set similar to the following: Country Province

SELECT A.Name AS 'Country',B.Name AS 'Province'
FROM Person.CountryRegion A
LEFT JOIN Person.StateProvince B ON A.CountryRegionCode=B.CountryRegionCode


--13. Write a query that lists the country and province names from person.CountryRegion and person.StateProvince tables 
--and list the countries filter them by Germany and Canada.
--Join them and produce a result set similar to the following.

SELECT A.Name AS 'Country',B.Name AS 'Province'
FROM Person.CountryRegion A
LEFT JOIN Person.StateProvince B ON A.CountryRegionCode=B.CountryRegionCode
WHERE A.Name IN ('Canada','Germany')


USE Northwind
GO

--14.  List all Products that has been sold at least once in last 25 years.
SELECT DISTINCT P.ProductName
FROM Products P
JOIN [Order Details] O ON P.ProductID=O.ProductID
JOIN Orders Q ON O.OrderID=Q.OrderID
WHERE Q.OrderDate > '1997-03-16'
ORDER BY P.ProductName

--15.  List top 5 locations (Zip Code) where the products sold most.
SELECT top 5 Q.ShipPostalCode,SUM(O.Quantity)AS 'Number Sold'
FROM [Order Details]O
JOIN Orders Q ON O.OrderID=Q.OrderID
WHERE Q.ShipPostalCode IS NOT NULL
GROUP BY Q.ShipPostalCode
ORDER BY SUM(O.Quantity) DESC

--16.  List top 5 locations (Zip Code) where the products sold most in last 25 years.
SELECT top 5 Q.ShipPostalCode,SUM(O.Quantity)AS 'Number Sold'
FROM [Order Details]O
JOIN Orders Q ON O.OrderID=Q.OrderID
WHERE (Q.ShipPostalCode IS NOT NULL) AND (Q.OrderDate > '1997-03-16')
GROUP BY Q.ShipPostalCode
ORDER BY SUM(O.Quantity) DESC

--17.   List all city names and number of customers in that city.
SELECT A.City, COUNT(A.CustomerID)AS 'number of customers'
FROM Customers A
GROUP BY A.City

--18.  List city names which have more than 2 customers, and number of customers in that city
SELECT A.City, COUNT(A.CustomerID)AS 'number of customers'
FROM Customers A
GROUP BY A.City
HAVING COUNT(A.CustomerID)>2

--19.  List the names of customers who placed orders after 1/1/98 with order date.
SELECT DISTINCT C.ContactName
FROM Orders Q
JOIN Customers C ON Q.CustomerID=C.CustomerID
WHERE Q.OrderDate > '1998-01-01'

--20.  List the names of all customers with most recent order dates
SELECT DISTINCT C.ContactName, MAX(Q.OrderDate) AS 'Most Recent Order Dates'
FROM Orders Q
JOIN Customers C ON Q.CustomerID=C.CustomerID
GROUP BY C.ContactName
ORDER BY MAX(Q.OrderDate)

--21.  Display the names of all customers  along with the  count of products they bought
SELECT C.ContactName,SUM(O.Quantity)AS 'Count of products bought'
FROM Products P
JOIN [Order Details] O ON P.ProductID=O.ProductID
JOIN Orders Q ON O.OrderID=Q.OrderID
JOIN Customers C ON Q.CustomerID=C.CustomerID
GROUP BY C.ContactName
ORDER BY C.ContactName

--22.  Display the customer ids who bought more than 100 Products with count of products.
SELECT C.CustomerID,SUM(O.Quantity)AS 'Product_Count'
FROM Products P
JOIN [Order Details] O ON P.ProductID=O.ProductID
JOIN Orders Q ON O.OrderID=Q.OrderID
JOIN Customers C ON Q.CustomerID=C.CustomerID
GROUP BY C.CustomerID
HAVING SUM(O.Quantity)>100
ORDER BY SUM(O.Quantity) DESC

--23.  List all of the possible ways that suppliers can ship their products. 
--Display the results as below: Supplier Company Name  Shipping Company Name
SELECT S.CompanyName AS 'Supplier Company Name',T.CompanyName AS 'Shipping Company Name'
FROM Suppliers S
CROSS JOIN Shippers T

--24.  Display the products order each day. Show Order date and Product Name.
SELECT DISTINCT Q.OrderDate, P.ProductName
FROM Products P
JOIN [Order Details] O ON P.ProductID=O.ProductID
JOIN Orders Q ON O.OrderID=Q.OrderID
ORDER BY Q.OrderDate

--25.  Displays pairs of employees who have the same job title.
SELECT (E.FirstName+' '+E.LastName) AS 'Employee 1',(A.FirstName+' '+A.LastName) AS 'Employee 2'
FROM Employees E
JOIN Employees A ON E.Title=A.Title
WHERE (E.FirstName+' '+E.LastName)!=(A.FirstName+' '+A.LastName) AND (E.FirstName<A.FirstName)
ORDER BY E.FirstName

--26.  Display all the Managers who have more than 2 employees reporting to them.
SELECT (B.FirstName+' '+B.LastName) AS Manager, count(B.EmployeeID)AS 'Number of Employees'
FROM Employees A
JOIN Employees B ON A.ReportsTo=B.EmployeeID
GROUP BY B.FirstName,B.LastName
HAVING count(B.EmployeeID)>2
ORDER BY count(B.EmployeeID)DESC

--27.  Display the customers and suppliers by city. 
--The results should have the following columns: City, Name, Contact Name, Type (Customer or Supplier)
SELECT C.City,C.CompanyName AS 'Name',C.ContactName AS 'Contact Name','Customer'AS 'Type'
FROM Customers C
UNION
SELECT S.City,S.CompanyName AS 'Name',S.ContactName AS 'Contact Name','Supplier'AS 'Type'
FROM Suppliers S