-- Active: 1742461234055@@127.0.0.1@3306@libraryDB
-- Table for books
DROP TABLE IF EXISTS book;
DROP TABLE IF EXISTS genre;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS author;
DROP TABLE IF EXISTS borrowed;
DROP TABLE IF EXISTS written;
DROP TABLE IF EXISTS fine;


CREATE TABLE book (
  bookID INT PRIMARY KEY,
  ISBN VARCHAR(13) NOT NULL UNIQUE,  
  title VARCHAR(255) NOT NULL,
  author VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  borrow_time INT,
  fine INT
);

-- Table for genres
CREATE TABLE genre (
  ISBN VARCHAR(13),
  genre VARCHAR(100),
  PRIMARY KEY (ISBN, genre),  -- Add a primary key to avoid duplicates
  FOREIGN KEY (ISBN) REFERENCES book(ISBN) ON DELETE CASCADE
);

-- Table for users
CREATE TABLE users (
  userid INT PRIMARY KEY AUTO_INCREMENT,
  cpr INT,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL
);

-- Table for authors
CREATE TABLE author (
  author_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL
);

-- Table for borrowed books
CREATE TABLE borrowed (
  bookId INT,
  userId INT,
  borrowed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  expiration_date TIMESTAMP,
  returned_at TIMESTAMP,
  PRIMARY KEY (bookId, userId),
  FOREIGN KEY (bookId) REFERENCES book(bookID) ON DELETE CASCADE,
  FOREIGN KEY (userId) REFERENCES users(cpr) ON DELETE CASCADE
);

-- Table for authorship (written)
CREATE TABLE written (
  authorId INT,
  ISBN VARCHAR(13),
  PRIMARY KEY (authorId, ISBN),
  FOREIGN KEY (authorId) REFERENCES author(author_id) ON DELETE CASCADE,
  FOREIGN KEY (ISBN) REFERENCES book(ISBN) ON DELETE CASCADE
);

-- Table for fines
CREATE TABLE fine (
  bookId INT,
  userId INT,
  borrowed_at TIMESTAMP,
  fine INT,
  paid BOOLEAN DEFAULT FALSE,
  PRIMARY KEY (bookId, userId),
  FOREIGN KEY (bookId) REFERENCES book(bookID) ON DELETE CASCADE,
  FOREIGN KEY (userId) REFERENCES users(userid) ON DELETE CASCADE
);
