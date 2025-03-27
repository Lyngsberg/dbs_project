-- 6.1: A table of all borrowed books
-- Active: 1743060890162@@127.0.0.1@3306@library_db306@db_project
SELECT b.*, u.* from borrowed bo
LEFT JOIN bookcopies bk ON bo.book_id = bk.book_id 
LEFT JOIN book b ON bk.ISBN = b.ISBN
LEFT JOIN users u ON bo.userId = u.userid;


-- 6.2: A table of all users that have borrowed a specific book (ISBN)
select book.ISBN, book.title, users.name, users.email from book
left join bookcopies on book.ISBN = bookcopies.ISBN
left join borrowed on bookcopies.book_id = borrowed.book_id
left join users on borrowed.userId = users.userid
where book.ISBN = '978-0345391803';

-- 6.3 A table of the total unpaid fines for each user
select book.title, users.*, fine.* from users 
join fine on users.userid = fine.userid 
join bookcopies on fine.book_id = bookcopies.book_id 
join book on bookcopies.ISBN = book.ISBN
where fine.paid = 0;


-- Amount of books borrowed by a user
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