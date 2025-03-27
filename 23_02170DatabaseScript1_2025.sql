
drop DATABASE if exists library_db;
create database library_db;
use library_db;

DROP TABLE IF EXISTS fine;
DROP TABLE IF EXISTS borrowed;
DROP TABLE IF EXISTS genre;
DROP TABLE IF EXISTS bookcopies;
DROP TABLE IF EXISTS written;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS book;
DROP TABLE IF EXISTS author;

-- Table for books (overview of books)
CREATE TABLE book(
  ISBN VARCHAR(20) PRIMARY KEY NOT NULL UNIQUE,
  title VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  borrow_time INT,
  price INT
);

-- Table for book copies (individual physical copies of books)
CREATE TABLE bookcopies (
  book_id INT PRIMARY KEY AUTO_INCREMENT,
  ISBN VARCHAR(20) NOT NULL,
  FOREIGN KEY (ISBN) REFERENCES book(ISBN) ON DELETE CASCADE
);

-- Table for genres
CREATE TABLE genre (
  ISBN VARCHAR(20),
  genre VARCHAR(100),
  PRIMARY KEY (ISBN, genre),  -- Add a primary key to avoid duplicates
  FOREIGN KEY (ISBN) REFERENCES book(ISBN) ON DELETE CASCADE
);

-- Table for users
CREATE TABLE users (
  userid INT PRIMARY KEY AUTO_INCREMENT,
  cpr BIGINT,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL
);

-- Table for authors
CREATE TABLE author (
  author_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL
);

-- Table for borrowed books (using copy_id to track borrowed copies)
CREATE TABLE borrowed (
  book_id INT,
  userId INT,
  borrowed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  expiration_date TIMESTAMP,
  returned_at TIMESTAMP,
  PRIMARY KEY (book_id, userId, borrowed_at),
  FOREIGN KEY (book_id) REFERENCES bookcopies(book_id) ON DELETE CASCADE,
  FOREIGN KEY (userId) REFERENCES users(userid) ON DELETE CASCADE
);

-- Table for authorship (written)
CREATE TABLE written (
  authorId INT,
  ISBN VARCHAR(20),
  PRIMARY KEY (authorId, ISBN),
  FOREIGN KEY (authorId) REFERENCES author(author_id) ON DELETE CASCADE,
  FOREIGN KEY (ISBN) REFERENCES book(ISBN) ON DELETE CASCADE
);

-- Table for fines (copy_id used to track fines for borrowed books)
CREATE TABLE fine (
  book_id INT,  
  userId INT,
  borrowed_at TIMESTAMP,
  fine INT,
  paid BOOLEAN DEFAULT FALSE,
  PRIMARY KEY (book_id, userId, borrowed_at),
  FOREIGN KEY (book_id, userId, borrowed_at) REFERENCES borrowed(book_id, userId, borrowed_at) ON DELETE CASCADE
);


INSERT INTO book (ISBN, title, borrow_time, price)
VALUES
  ('978-0345391803', 'The Hitchhiker\'s Guide to the Galaxy', 14, 5),
  ('978-0132350884', 'Clean Code: A Handbook of Agile Software Craftsmanship', 21, 10),
  ('978-0451524935', '1984', 30, 8),
  ('978-0451530080', 'Brave New World', 14, 7),
  ('978-0735219090', 'The Pragmatic Programmer', 30, 12);

-- Populate `bookcopies` table (creating multiple copies of some books)
INSERT INTO bookcopies (ISBN)
VALUES
  ('978-0345391803'), -- Copy 1 of Hitchhiker's Guide
  ('978-0345391803'), -- Copy 2 of Hitchhiker's Guide
  ('978-0345391803'), -- Copy 3 of Hitchhiker's Guide
  ('978-0132350884'), -- Copy 1 of Clean Code
  ('978-0132350884'), -- Copy 2 of Clean Code
  ('978-0451524935'), -- Copy 1 of 1984
  ('978-0451530080'), -- Copy 1 of Brave New World
  ('978-0735219090'); -- Copy 1 of Pragmatic Programmer

-- Populate `genre` table
INSERT INTO genre (ISBN, genre)
VALUES
  ('978-0345391803', 'Science Fiction'),
  ('978-0132350884', 'Programming'),
  ('978-0451524935', 'Dystopian'),
  ('978-0451530080', 'Dystopian'),
  ('978-0735219090', 'Programming');

-- Populate `users` table
INSERT INTO users (cpr, name, email)
VALUES
  (1234567890, 'Alice Johnson', 'alice.johnson@example.com'),
  (2345678901, 'Bob Smith', 'bob.smith@example.com'),
  (3456789012, 'Charlie Brown', 'charlie.brown@example.com'),
  (4567890123, 'David Williams', 'david.williams@example.com'),
  (5678901234, 'Eva Roberts', 'eva.roberts@example.com');

-- Populate `author` table
INSERT INTO author (name)
VALUES
  ('Douglas Adams'),
  ('Robert C. Martin'),
  ('George Orwell'),
  ('Aldous Huxley'),
  ('Andrew Hunt');

-- Populate `written` table
INSERT INTO written (authorId, ISBN)
VALUES
  (1, '978-0345391803'),
  (2, '978-0132350884'),
  (3, '978-0451524935'),
  (4, '978-0451530080'),
  (5, '978-0735219090');

-- Populate `borrowed` table with correct book_id references from bookcopies
INSERT INTO borrowed (book_id, userId, borrowed_at, expiration_date, returned_at)
VALUES
  (1, 1, '2023-01-01 10:00:00', '2023-01-15 10:00:00', NULL),  -- First copy of Hitchhiker's Guide
  (2, 2, '2023-01-02 11:00:00', '2023-01-16 11:00:00', NULL),  -- Second copy of Hitchhiker's Guide
  (4, 2, '2023-01-03 11:00:00', '2023-01-24 11:00:00', NULL),  -- First copy of Clean Code
  (6, 3, '2023-01-04 12:00:00', '2023-02-03 12:00:00', NULL),  -- First copy of 1984
  (7, 4, '2023-01-05 13:00:00', '2023-01-19 13:00:00', NULL),  -- First copy of Brave New World
  (8, 5, '2023-01-06 14:00:00', '2023-02-05 14:00:00', NULL);  -- First copy of Pragmatic Programmer

-- Populate `fine` table with matching book_id, userId, and borrowed_at to match borrowed table
INSERT INTO fine (book_id, userId, borrowed_at, fine, paid)
VALUES
  (1, 1, '2023-01-01 10:00:00', 5, FALSE),
  (4, 2, '2023-01-03 11:00:00', 10, TRUE),
  (6, 3, '2023-01-04 12:00:00', 8, FALSE),
  (7, 4, '2023-01-05 13:00:00', 7, FALSE),
  (8, 5, '2023-01-06 14:00:00', 12, TRUE);
