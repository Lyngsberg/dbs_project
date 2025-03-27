SELECT b.*, u.* from borrowed bo
LEFT JOIN bookcopies bk ON bo.book_id = bk.book_id 
LEFT JOIN book b ON bk.ISBN = b.ISBN
LEFT JOIN users u ON bo.userId = u.userid;

SELECT b.*, u.* from borrowed bo
LEFT JOIN bookcopies bk ON bo.book_id = bk.book_id
LEFT JOIN book b ON bk.ISBN = b.ISBN
LEFT JOIN users u ON bo.userId = u.userid
WHERE bo.borrowed_at > '2023-01-01 00:00:00'
GROUP BY bo.userId
HAVING COUNT(*) > 1;

SELECT b.*, u.* from borrowed bo
LEFT JOIN bookcopies bk ON bo.book_id = bk.book_id
LEFT JOIN book b ON bk.ISBN = b.ISBN
LEFT JOIN users u ON bo.userId = u.userid
WHERE bo.borrowed_at > '2023-01-01 00:00:00'
GROUP BY bo.userId
HAVING COUNT(*) > 1
UNION
SELECT b.*, u.* from borrowed bo
LEFT JOIN bookcopies bk ON bo.book_id = bk.book_id
LEFT JOIN book b ON bk.ISBN = b.ISBN
LEFT JOIN users u ON bo.userId = u.userid
WHERE bo.borrowed_at > '2023-01-01 00:00:00'
GROUP BY bo.userId
HAVING COUNT(*) > 1;


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
        SET MYSQL_ERRNO = 9999, MESSAGE_TEXT = "Cannot borrow a book, has a fine";
    END IF;
END;