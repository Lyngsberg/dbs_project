-- Populate `book` table
INSERT INTO book (ISBN, title, borrow_time, price)
VALUES
  ('978-0345391803', 'The Hitchhiker\'s Guide to the Galaxy', 14, 5),
  ('978-0132350884', 'Clean Code: A Handbook of Agile Software Craftsmanship', 21, 10),
  ('978-0451524935', '1984', 30, 8),
  ('978-0451530080', 'Brave New World', 14, 7),
  ('978-0735219090', 'The Pragmatic Programmer', 30, 12);

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
-- Populate `borrowed` table
INSERT INTO borrowed (book_id, userId, borrowed_at, expiration_date, returned_at)
VALUES
  (1, 1, '2023-01-01 10:00:00', '2023-01-15 10:00:00', NULL),
  (2, 2, '2023-01-02 11:00:00', '2023-01-23 11:00:00', NULL),
  (3, 3, '2023-01-03 12:00:00', '2023-01-30 12:00:00', NULL),
  (4, 4, '2023-01-04 13:00:00', '2023-01-18 13:00:00', NULL),
  (5, 5, '2023-01-05 14:00:00', '2023-02-04 14:00:00', NULL);

-- Populate `fine` table
INSERT INTO fine (book_id, userId, borrowed_at, fine, paid)
VALUES
  (1, 1, '2023-01-01 10:00:00', 5, FALSE),
  (2, 2, '2023-01-02 11:00:00', 10, TRUE),
  (3, 3, '2023-01-03 12:00:00', 8, FALSE),
  (4, 4, '2023-01-04 13:00:00', 7, FALSE),
  (5, 5, '2023-01-05 14:00:00', 12, TRUE);
