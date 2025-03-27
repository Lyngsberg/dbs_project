-- 6.1: A table of all borrowed books
-- Active: 1738836473627@@127.0.0.1@3306@db_project
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