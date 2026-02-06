-- Ranking books based on borrowing frequency

SELECT
    title,
    total_borrowed,
    ROW_NUMBER() OVER (ORDER BY total_borrowed DESC) AS row_num,
    RANK() OVER (ORDER BY total_borrowed DESC) AS rank_num,
    DENSE_RANK() OVER (ORDER BY total_borrowed DESC) AS dense_rank_num,
    PERCENT_RANK() OVER (ORDER BY total_borrowed DESC) AS percent_ran
FROM (
    SELECT
        b.title,
        COUNT(br.borrowing_id) AS total_borrowed
    FROM books b
    LEFT JOIN borrowings br ON b.book_id = br.book_id
    GROUP BY b.title
) AS book_counts;

-- Running total of borrowings over time
SELECT 
    borrow_date,
    COUNT(borrowing_id) AS daily_borrowings,
    SUM(COUNT(borrowing_id)) OVER (
        ORDER BY borrow_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM borrowings
GROUP BY borrow_date;

-- Compare daily borrowings with previous day
SELECT 
    borrow_date,
    COUNT(borrowing_id) AS daily_borrowings,
    LAG(COUNT(borrowing_id)) OVER (ORDER BY borrow_date) AS previous_day,
    COUNT(borrowing_id) - LAG(COUNT(borrowing_id)) 
        OVER (ORDER BY borrow_date) AS daily_change
FROM borrowings
GROUP BY borrow_date;

-- Customer segmentation based on borrowing activity
SELECT 
    m.member_name,
    COUNT(br.borrowing_id) AS total_borrowed,
    NTILE(4) OVER (ORDER BY COUNT(br.borrowing_id) DESC) AS quartile_group,
    CUME_DIST() OVER (ORDER BY COUNT(br.borrowing_id) DESC) AS cumulative_distribution
FROM members m
LEFT JOIN borrowings br ON m.member_id = br.member_id
GROUP BY m.member_name;
