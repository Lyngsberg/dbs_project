-- Drop existing tables if they exist
DROP TABLE IF EXISTS fine;
DROP TABLE IF EXISTS borrowed;
DROP TABLE IF EXISTS genre;
DROP TABLE IF EXISTS bookcopies;
DROP TABLE IF EXISTS written;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS book;
DROP TABLE IF EXISTS author;

-- Table for books (overview of books)
CREATE TABLE book (
  ISBN VARCHAR(13) NOT NULL UNIQUE PRIMARY KEY,  -- ISBN as the primary key for the book
  title VARCHAR(255) NOT NULL,
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
CREATE TABLE bookcopies (
  book_id INT AUTO_INCREMENT,
  ISBN VARCHAR(13),
  PRIMARY KEY (book_id),
  FOREIGN KEY (ISBN) REFERENCES book(ISBN) ON DELETE CASCADE
);
-- Table for authors
CREATE TABLE author (
  author_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL
);
-- Table for borrowed books (using book_id to track borrowed copies)
CREATE TABLE borrowed (
  book_id INT,  -- book_id used here to track the copy being borrowed
  userId INT,
  borrowed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  expiration_date TIMESTAMP,
  returned_at TIMESTAMP,
  PRIMARY KEY (book_id, userId),
  FOREIGN KEY (book_id) REFERENCES bookcopies(book_id) ON DELETE CASCADE,
  FOREIGN KEY (userId) REFERENCES users(userid) ON DELETE CASCADE
);

-- Table for authorship (written)
CREATE TABLE written (
  authorId INT,
  ISBN VARCHAR(13),
  PRIMARY KEY (authorId, ISBN),
  FOREIGN KEY (authorId) REFERENCES author(author_id) ON DELETE CASCADE,
  FOREIGN KEY (ISBN) REFERENCES book(ISBN) ON DELETE CASCADE
);

-- Table for fines (book_id used to track fines for borrowed books)
CREATE TABLE fine (
  book_id INT,  -- book_id used to track fines
  userId INT,
  borrowed_at TIMESTAMP,
  fine INT,
  paid BOOLEAN DEFAULT FALSE,
  PRIMARY KEY (book_id, userId, borrowed_at),
  FOREIGN KEY (book_id) REFERENCES borrowed(book_id) ON DELETE CASCADE,
  FOREIGN KEY (userId) REFERENCES users(userid) ON DELETE CASCADE
);
