CREATE DATABASE MasterPiece;
GO

USE MasterPiece;


-- Users Table
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(50) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Role NVARCHAR(20) CHECK (Role IN ('Admin', 'ShopOwner', 'Customer')) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE()
);


-- Shops Table
CREATE TABLE Shops (
    ShopID INT PRIMARY KEY IDENTITY(1,1),
    ShopName NVARCHAR(100) UNIQUE NOT NULL,
    OwnerID INT,
    Description NVARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (OwnerID) REFERENCES Users(UserID)
);

-- Categories Table
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(50) UNIQUE NOT NULL
);

-- Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
    Price DECIMAL(10, 2) NOT NULL,
    Stock INT DEFAULT 0,
    ShopID INT,
    CategoryID INT,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ShopID) REFERENCES Shops(ShopID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Offers Table
CREATE TABLE Offers (
    OfferID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT,
    DiscountPercentage DECIMAL(5, 2),
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT,
    OrderDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(50) CHECK (Status IN ('Pending', 'Completed', 'Cancelled')),
    FOREIGN KEY (CustomerID) REFERENCES Users(UserID)
);

-- OrderDetails Table
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT,
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Cart Table
CREATE TABLE Cart (
    CartID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT,
    ProductID INT,
    Quantity INT DEFAULT 1,
    AddedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Reviews Table
CREATE TABLE Reviews (
    ReviewID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT,
    UserID INT,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comment NVARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Wishlist Table (Many-to-Many Relationship 1)
CREATE TABLE Wishlist (
    WishlistID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT,
    ProductID INT,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- ShopCategories Table (Many-to-Many Relationship 2)
CREATE TABLE ShopCategories (
    ShopID INT,
    CategoryID INT,
    PRIMARY KEY (ShopID, CategoryID),
    FOREIGN KEY (ShopID) REFERENCES Shops(ShopID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Logs Table
CREATE TABLE Logs (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT,
    Action NVARCHAR(255),
    Timestamp DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Insert default categories
INSERT INTO Categories (CategoryName) VALUES ('Food'), ('Clothing'), ('Furniture');
