-- Active: 1738835924810@@127.0.0.1@3306@dbs_project
SELECT b.*, u.* from borrowed bo
LEFT JOIN bookcopies bk ON bo.book_id = bk.book_id 
LEFT JOIN book b ON bk.ISBN = b.ISBN
LEFT JOIN users u ON bo.userId = u.userid;

-- 6.2 A table of all books that have been borrowed by a specific user
delimiter $$
CREATE FUNCTION amount_of_books_borrowed(vuserid VARCHAR(15))
RETURNS INT
BEGIN
    DECLARE book_count INT;
    SELECT COUNT(*) into book_count from borrowed where userId = vuserid; 
    
    RETURN book_count;
END $$
delimiter;

select name, amount_of_books_borrowed(userId) from users



CREATE FUNCTION has_unpaid_fine( vuserid VARCHAR(15) )
RETURNS INT
BEGIN
    DECLARE unpaid_fine INT;
    SELECT CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END INTO unpaid_fine
    FROM fine
    WHERE userId = vuserid AND paid = 0;
    RETURN unpaid_fine;
END;

CREATE TRIGGER Manual_Insert
    BEFORE INSERT
ON borrowed FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE 'HY000'
    SET MYSQL_ERRNO = 9998, MESSAGE_TEXT = 'Must use procedure InsertBorrowed';
END;

create Procedure InsertBorrowed
    (IN book_id int, IN userId int, IN borrowed_at TIMESTAMP, IN expiration_date TIMESTAMP, IN returned_at TIMESTAMP)
BEGIN 
    IF has_unpaid_fine(userID) THEN
        SIGNAL SQLSTATE "HY001"
        SET MYSQL_ERRNO = 9999, MESSAGE_TEXT = 'Cannot borrow book, has a fine';
    END IF;
    INSERT INTO Borrowed (book_id, userId, borrowed_at, expiration_date, returned_at)
    VALUES (book_id, userId, borrowed_at, expiration_date, returned_at);
END;


SELECT * FROM bookcopies;
SELECT * FROM book;

SET @isbn_to_delete = (SELECT ISBN FROM bookcopies WHERE book_id = 7);
DELETE FROM bookcopies WHERE book_id = 7;
DELETE FROM book 
WHERE ISBN = @isbn_to_delete 
AND NOT EXISTS (SELECT 1 FROM bookcopies WHERE ISBN = @isbn_to_delete);
SELECT * FROM bookcopies;
SELECT * FROM book;

UPDATE borrowed SET returned_at = '2023-01-01 00:00:00' 
WHERE book_id = 1 AND userId = 1;
SELECT * FROM borrowed;