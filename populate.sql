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
