
-- 6.1: A table of all borrowed books
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


-- returns amount user has yet to pay
CREATE FUNCTION has_unpaid_fine( vuserid VARCHAR(15) )
RETURNS INT
BEGIN
    DECLARE unpaid_fine INT;
    SELECT CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END INTO unpaid_fine
    FROM fine
    WHERE userId = vuserid AND paid = 0;
    RETURN unpaid_fine;
END;

-- checks for fine before borrowing
CREATE TRIGGER CheckBeforeInsertBorrowed
BEFORE INSERT ON borrowed
FOR EACH ROW
BEGIN
    DECLARE has_fine BOOLEAN;

    -- Check if the user has an unpaid fine
    SELECT has_unpaid_fine(NEW.userId) INTO has_fine;

    -- If the user has a fine, prevent the insertion
    IF has_fine THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot borrow book, has a fine';
    END IF;
END


CREATE PROCEDURE AddOverdueFines()
BEGIN
    INSERT INTO fine (book_id, userId, borrowed_at, fine, paid)
    SELECT 
        b.book_id, 
        b.userId, 
        b.borrowed_at, 
        bo.price,  
        FALSE      
    FROM borrowed b
    JOIN bookcopies bc ON b.book_id = bc.book_id  
    JOIN book bo ON bc.ISBN = bo.ISBN            
    LEFT JOIN fine f 
      ON b.book_id = f.book_id 
     AND b.userId = f.userId
     AND b.borrowed_at = f.borrowed_at
    WHERE b.returned_at IS NULL              
      AND b.expiration_date < NOW()         
      AND f.book_id IS NULL;                 
END





-- deletion and updating?
SET @isbn_to_delete = (SELECT ISBN FROM bookcopies WHERE book_id = 7);
DELETE FROM bookcopies WHERE book_id = 7;
DELETE FROM book 
WHERE ISBN = @isbn_to_delete 
AND NOT EXISTS (SELECT 1 FROM bookcopies WHERE ISBN = @isbn_to_delete);

-- return book?
UPDATE borrowed SET returned_at = '2023-01-01 00:00:00' 
WHERE book_id = 1 AND userId = 1;
