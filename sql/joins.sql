-- INNER JOIN: shows only valid borrowing transactions
SELECT 
    m.member_name,
    b.title,
    br.borrow_date
FROM borrowings br
INNER JOIN members m ON br.member_id = m.member_id
INNER JOIN books b ON br.book_id = b.book_id;
USE school_library;
-- LEFT JOIN: shows all members, including those with no borrowings
SELECT 
    m.member_name,
    br.borrowing_id
FROM members m
LEFT JOIN borrowings br
ON m.member_id = br.member_id;

-- RIGHT JOIN: shows all books, even if they were never borrowed
SELECT 
    b.title,
    br.borrowing_id
FROM borrowings br
RIGHT JOIN books b
ON br.book_id = b.book_id;

-- FULL OUTER JOIN simulation using UNION
SELECT m.member_name, b.title
FROM members m
LEFT JOIN borrowings br ON m.member_id = br.member_id
LEFT JOIN books b ON br.book_id = b.book_id

UNION

SELECT m.member_name, b.title
FROM books b
LEFT JOIN borrowings br ON b.book_id = br.book_id
LEFT JOIN members m ON br.member_id = m.member_id;

-- SELF JOIN: compares members of the same type
SELECT 
    m1.member_name AS Member_One,
    m2.member_name AS Member_Two,
    m1.member_type
FROM members m1
INNER JOIN members m2
ON m1.member_type = m2.member_type
AND m1.member_id <> m2.member_id;
