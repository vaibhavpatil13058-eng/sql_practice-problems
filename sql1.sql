CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Country VARCHAR(100),
    DOB DATE
);

SELECT * FROM Authors;

CREATE TABLE Categories (
CategoryID INT PRIMARY KEY,
CategoryName VARCHAR(100) UNIQUE
);

SELECT * FROM Categories;

CREATE TABLE Books ( 
BookID INT PRIMARY KEY, 
Title VARCHAR(200) UNIQUE, 
AuthorID INT, 
CategoryID INT, 
Price DECIMAL(10,2) CHECK (Price > 0), 
Stock INT CHECK (Stock >= 0), 
PublishedYear YEAR DEFAULT (YEAR(CURDATE())), 
FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID), 
FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID) 
); 

SELECT * FROM Books;

CREATE TABLE Customers ( 
CustomerID INT PRIMARY KEY, 
Name VARCHAR(100) NOT NULL, 
Email VARCHAR(100) UNIQUE, 
Phone VARCHAR(10), 
Address VARCHAR(255) 
);

ALTER TABLE Customers ADD CONSTRAINT chk_phone CHECK (Phone REGEXP '^[789]'); 
ALTER TABLE Customers MODIFY Phone VARCHAR(10) NOT NULL; 
ALTER TABLE Customers ADD DateOfBirth DATE;

SELECT * FROM Customers;

CREATE TABLE Orders ( 
OrderID INT PRIMARY KEY, 
CustomerID INT, 
OrderDate DATE, 
Status VARCHAR(50) DEFAULT 'Pending', 
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) 
); 

SELECT * FROM Orders;

CREATE TABLE OrderDetails ( 
OrderID INT, 
BookID INT, 
Quantity INT CHECK (Quantity > 0), 
Price DECIMAL(10,2) CHECK (Price > 0.01), 
PRIMARY KEY (OrderID, BookID), 
FOREIGN KEY (OrderID) REFERENCES Orders(OrderID), 
FOREIGN KEY (BookID) REFERENCES Books(BookID) 
);

SELECT * FROM OrderDetails;

CREATE TABLE Payment ( 
PaymentID INT PRIMARY KEY, 
OrderID INT, 
Amount DECIMAL(10,2), 
PaymentDate DATE, 
Method VARCHAR(50) DEFAULT 'Cash', 
FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) 
);

SELECT * FROM Payment;

ALTER TABLE Books ADD ISBN VARCHAR(20); 

ALTER TABLE Books ADD CONSTRAINT uc_isbn UNIQUE (ISBN); 

ALTER TABLE Books MODIFY Stock TINYINT; 

ALTER TABLE Books RENAME COLUMN PublishedYear TO YearPublished; 

ALTER TABLE Customers DROP COLUMN DateOfBirth; 

ALTER TABLE Orders ADD DeliveryAgentID INT; 

ALTER TABLE Orders ADD CONSTRAINT fk_delivery FOREIGN KEY (DeliveryAgentID) 
REFERENCES DeliveryAgent(AgentID);

ALTER TABLE Orders DROP FOREIGN KEY fk_delivery; 

ALTER TABLE OrderDetails ADD Discount DECIMAL(5,2) DEFAULT 0; 

ALTER TABLE OrderDetails ALTER Discount DROP DEFAULT; 

ALTER TABLE Books DROP INDEX uc_isbn; 

ALTER TABLE Books 
DROP CHECK chk_price;
 
CREATE TABLE DeliveryAgents ( 
AgentID INT PRIMARY KEY, 
Name VARCHAR(100), 
Phone VARCHAR(10) UNIQUE, 
Region VARCHAR(10) DEFAULT 'North', 
CHECK (Region IN ('North', 'South', 'East', 'West')) 
);

SELECT * FROM DeliveryAgents;

ALTER TABLE DeliveryAgents ADD Email VARCHAR(100) UNIQUE; 

ALTER TABLE DeliveryAgents MODIFY Phone VARCHAR(10); 

ALTER TABLE DeliveryAgents DROP COLUMN Email;
 
RENAME TABLE DeliveryAgents TO DeliveryTeam;
 
ALTER TABLE DeliveryTeam RENAME COLUMN Region TO AssignedRegion;
 
TRUNCATE TABLE DeliveryTeam;
 
TRUNCATE TABLE Payments;
 
TRUNCATE TABLE OrderDetails;
 
DROP TABLE Payments;
 
DROP TABLE DeliveryTeam; 



RENAME TABLE Books TO BookInventory; 

RENAME TABLE Customers TO Clients; 

ALTER TABLE Clients RENAME COLUMN Name TO FullName; 

ALTER TABLE BookInventory RENAME COLUMN Title TO BookTitle; 

RENAME TABLE BookInventory TO Books; 

ALTER TABLE OrderDetails DROP FOREIGN KEY OrderDetails_ibfk_1; 

ALTER TABLE OrderDetails DROP FOREIGN KEY OrderDetails_ibfk_2; 


CREATE VIEW TopSellingBook AS 
SELECT B.BookID, B.Title, SUM(OD.Quantity) AS TotalSold 
FROM Books B 
JOIN OrderDetails OD ON B.BookID = OD.BookID 
GROUP BY B.BookID, B.Title 
ORDER BY TotalSold DESC; 

SELECT * FROM TopSellingBook;

ALTER TABLE Payments ALTER COLUMN Method SET DEFAULT 'Card'; 
CREATE TABLE OrderNotes ( 
NoteID INT PRIMARY KEY, 
Note TEXT NOT NULL 
); 

ALTER TABLE Books DROP INDEX uc_isbn; 

ALTER TABLE Books DROP CHECK chk_price;


CREATE TABLE ReturnRequests ( 
ReturnID INT PRIMARY KEY, 
OrderID INT, 
Reason VARCHAR(255), 
Status VARCHAR(50) DEFAULT 'Pending', 
FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) 
);

ALTER TABLE ReturnRequests ADD ReturnDate DATE;

ALTER TABLE ReturnRequests DROP COLUMN ReturnDate; 

ALTER TABLE ReturnRequests ADD CONSTRAINT fk_return_order FOREIGN KEY (OrderID) 
REFERENCES Orders(OrderID); 

ALTER TABLE ReturnRequests DROP FOREIGN KEY fk_return_order; 

CREATE TABLE Wishlists ( 
CustomerID INT, 
BookID INT, 
PRIMARY KEY (CustomerID, BookID), 
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID), 
FOREIGN KEY (BookID) REFERENCES Books(BookID) 
);

ALTER TABLE Wishlists ADD DateAdded DATE;

ALTER TABLE Wishlists DROP COLUMN DateAdded; 

RENAME TABLE Wishlists TO CustomerWishlists;
 
RENAME TABLE CustomerWishlists TO Wishlists;


DROP TABLE Books;

CREATE TABLE Books ( 
BookID INT PRIMARY KEY, 
Title VARCHAR(200) UNIQUE, 
AuthorID INT, 
CategoryID INT, 
Price DECIMAL(10,2) CHECK (Price > 0), 
Stock INT CHECK (Stock >= 0), 
PublishedYear YEAR DEFAULT (YEAR(CURDATE())), 
FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID), 
FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID) 
); 


ALTER TABLE Books ADD Edition VARCHAR(20) DEFAULT 'First'; 
ALTER TABLE Books MODIFY Edition VARCHAR(50); 
ALTER TABLE Books DROP COLUMN Edition;


CREATE TABLE DeliveryLogs ( 
LogID INT PRIMARY KEY, 
DeliveryAgentID INT, 
Date DATE, 
Status VARCHAR(20), 
FOREIGN KEY (DeliveryAgentID) REFERENCES DeliveryAgents(AgentID) 
);

ALTER TABLE DeliveryLogs ADD Comments TEXT;
ALTER TABLE DeliveryLogs DROP COLUMN Comments; 
ALTER TABLE DeliveryLogs ADD CONSTRAINT chk_status CHECK (Status IN ('Delivered', 
'Pending', 'Failed')); 
ALTER TABLE DeliveryLogs DROP CHECK chk_status; 

ALTER TABLE Books ADD Rating DECIMAL(2,1) CHECK (Rating BETWEEN 1 AND 5); 
ALTER TABLE Books MODIFY Rating DECIMAL(3,1); 
ALTER TABLE Books DROP COLUMN Rating;

CREATE TABLE BookReviews ( 
ReviewID INT PRIMARY KEY, 
BookID INT, 
CustomerID INT, 
ReviewText TEXT, 
FOREIGN KEY (BookID) REFERENCES Books(BookID), 
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) 
);

ALTER TABLE BookReviews ADD Stars INT CHECK (Stars BETWEEN 1 AND 5); 
ALTER TABLE BookReviews MODIFY Stars INT NULL; 
DROP TABLE BookReviews;

CREATE TABLE BookReviews ( 
ReviewID INT PRIMARY KEY, 
BookID INT, 
CustomerID INT, 
ReviewText TEXT, 
FOREIGN KEY (BookID) REFERENCES Books(BookID), 
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) 
);

ALTER TABLE BookReviews ADD CONSTRAINT fk_book FOREIGN KEY (BookID) REFERENCES 
Books(BookID); 

ALTER TABLE BookReviews ADD CONSTRAINT fk_customer FOREIGN KEY (CustomerID) 
REFERENCES Customers(CustomerID);
 
ALTER TABLE BookReviews DROP FOREIGN KEY fk_book;
 
ALTER TABLE BookReviews DROP FOREIGN KEY fk_customer; 

DROP TABLE BookReviews; 

CREATE TABLE Coupons ( 
CouponID INT PRIMARY KEY, 
Code VARCHAR(50) UNIQUE, 
Discount INT, 
ExpiryDate DATE 
);

ALTER TABLE Coupons ADD Status VARCHAR(20) DEFAULT 'Active'; 

ALTER TABLE Coupons ADD CONSTRAINT chk_discount CHECK (Discount BETWEEN 1 AND 
50);
 
ALTER TABLE Coupons DROP CHECK chk_discount; 

ALTER TABLE Coupons DROP COLUMN Status;