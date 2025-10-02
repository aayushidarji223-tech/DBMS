-- Count users by role
SELECT role, COUNT(*) AS total_users
FROM Users
GROUP BY role;

-- Find roles having more than 2 users
SELECT role, COUNT(*) AS total_users
FROM Users
GROUP BY role
HAVING COUNT(*) > 2;

-- Show Guests with their Guest details (JOIN with Guest)
SELECT U.username, G.name, G.address
FROM Users U
INNER JOIN Guest G ON U.user_id = G.user_id;

-- Show all users with staff info if available (LEFT JOIN)
SELECT U.username, S.role, S.salary
FROM Users U
LEFT JOIN Staff S ON U.user_id = S.user_id;

-- Nested: Find users who are also Managers
SELECT username
FROM Users
WHERE user_id IN (SELECT user_id FROM Staff WHERE role = 'Manager');
--------------------------------------------------------------------------------------------------------------------------------------------
-- Count guests by gender
SELECT gender, COUNT(*) AS total
FROM Guest
GROUP BY gender;

-- Guests who have bookings more than 1
SELECT G.name, COUNT(B.booking_id) AS total_bookings
FROM Guest G
INNER JOIN Booking B ON G.guest_id = B.guest_id
GROUP BY G.guest_id
HAVING COUNT(B.booking_id) > 1;

-- Guests and their reviews (JOIN with Reviews)
SELECT G.name, R.rating, R.comments
FROM Guest G
INNER JOIN Reviews R ON G.guest_id = R.guest_id;

-- Show all guests and bookings (LEFT JOIN)
SELECT G.name, B.booking_id, B.booking_status
FROM Guest G
LEFT JOIN Booking B ON G.guest_id = B.guest_id;

-- Nested: Guests who never booked any room
SELECT name
FROM Guest
WHERE guest_id NOT IN (SELECT guest_id FROM Booking);
----------------------------------------------------------------------------------------------------------------------------------------------
-- Total salary by role
SELECT role, SUM(salary) AS total_salary
FROM Staff
GROUP BY role;

-- Roles with average salary > 30000
SELECT role, AVG(salary) AS avg_salary
FROM Staff
GROUP BY role
HAVING AVG(salary) > 30000;

-- Join Staff with Users
SELECT U.username, S.role, S.salary
FROM Staff S
INNER JOIN Users U ON S.user_id = U.user_id;

-- Left join Staff with Bookings handled (assuming Manager can be linked)
SELECT S.name, B.booking_id
FROM Staff S
LEFT JOIN Booking B ON S.role = 'Manager';

-- Nested: Staff who earn more than average salary
SELECT name, salary
FROM Staff
WHERE salary > (SELECT AVG(salary) FROM Staff);
---------------------------------------------------------------------------------------------------------------------------------------------
-- Average price per room type
SELECT room_type, AVG(price_per_night) AS avg_price
FROM Rooms
GROUP BY room_type;

-- Room types having more than 2 rooms
SELECT room_type, COUNT(*) AS total
FROM Rooms
GROUP BY room_type
HAVING COUNT(*) > 2;

-- Join Rooms with Bookings
SELECT R.room_number, B.booking_id, B.booking_status
FROM Rooms R
INNER JOIN Booking B ON R.room_id = B.room_id;

-- Left join Rooms with Bookings (to see unbooked rooms)
SELECT R.room_number, B.booking_id
FROM Rooms R
LEFT JOIN Booking B ON R.room_id = B.room_id;

-- Nested: Rooms never booked
SELECT room_number
FROM Rooms
WHERE room_id NOT IN (SELECT room_id FROM Booking);
-----------------------------------------------------------------------------------------------------------------------------------------------
-- Count bookings per status
SELECT booking_status, COUNT(*) AS total
FROM Booking
GROUP BY booking_status;

-- Guests having more than 1 confirmed booking
SELECT guest_id, COUNT(*) AS confirmed_bookings
FROM Booking
WHERE booking_status = 'Confirmed'
GROUP BY guest_id
HAVING COUNT(*) > 1;

-- Join Bookings with Payments
SELECT B.booking_id, B.booking_status, P.payment_status
FROM Booking B
INNER JOIN Payment P ON B.booking_id = P.booking_id;

-- Left join Bookings with Reviews
SELECT B.booking_id, R.rating
FROM Booking B
LEFT JOIN Reviews R ON B.booking_id = R.booking_id;

-- Nested: Find bookings with amount > average payment
SELECT booking_id
FROM Booking
WHERE booking_id IN (
    SELECT booking_id FROM Payment 
    WHERE amount > (SELECT AVG(amount) FROM Payment)
);
----------------------------------------------------------------------------------------------------------------------------------------------------
-- Total payment by mode
SELECT payment_mode, SUM(amount) AS total_amount
FROM Payment
GROUP BY payment_mode;

-- Payment modes with more than 2 successful transactions
SELECT payment_mode, COUNT(*) AS total_success
FROM Payment
WHERE payment_status = 'Paid'
GROUP BY payment_mode
HAVING COUNT(*) > 2;

-- Join Payment with Booking
SELECT P.payment_id, B.booking_id, P.amount, B.booking_status
FROM Payment P
INNER JOIN Booking B ON P.booking_id = B.booking_id;

-- Left join Payment with Booking to see all bookings
SELECT B.booking_id, P.amount
FROM Booking B
LEFT JOIN Payment P ON B.booking_id = P.booking_id;

-- Nested: Payments higher than average amount
SELECT payment_id, amount
FROM Payment
WHERE amount > (SELECT AVG(amount) FROM Payment);
------------------------------------------------------------------------------------------------------------------------------------------------
-- Count services by price category
SELECT CASE 
         WHEN service_price < 1000 THEN 'Low Cost'
         WHEN service_price BETWEEN 1000 AND 2000 THEN 'Medium Cost'
         ELSE 'High Cost'
       END AS category, COUNT(*) AS total
FROM Service
GROUP BY category;

-- Services with avg price > 1000
SELECT service_name, service_price
FROM Service
WHERE service_price > (SELECT AVG(service_price) FROM Service);

-- Join Service with Booking_Service
SELECT S.service_name, BS.booking_id, BS.quantity
FROM Service S
INNER JOIN Booking_Service BS ON S.service_id = BS.service_id;

-- Left join Service with Booking_Service
SELECT S.service_name, BS.booking_id
FROM Service S
LEFT JOIN Booking_Service BS ON S.service_id = BS.service_id;
-----------------------------------------------------------------------------------------------------------------------------------------------
-- Count services per booking
SELECT booking_id, COUNT(*) AS total_services
FROM Booking_Service
GROUP BY booking_id;

-- Bookings that used more than 1 service
SELECT booking_id, COUNT(*) AS total_services
FROM Booking_Service
GROUP BY booking_id
HAVING COUNT(*) > 1;

-- Join Booking_Service with Service
SELECT BS.booking_id, S.service_name, BS.quantity
FROM Booking_Service BS
INNER JOIN Service S ON BS.service_id = S.service_id;

-- Left join Booking with Booking_Service
SELECT B.booking_id, BS.service_id
FROM Booking B
LEFT JOIN Booking_Service BS ON B.booking_id = BS.booking_id;

-- Nested: Find booking with max services
SELECT booking_id
FROM Booking_Service
GROUP BY booking_id
HAVING COUNT(*) = (
    SELECT MAX(service_count)
    FROM (SELECT COUNT(*) AS service_count
          FROM Booking_Service
          GROUP BY booking_id) AS temp
);
-------------------------------------------------------------------------------------------------------------------------------------------------
-- Average rating per guest
SELECT guest_id, AVG(rating) AS avg_rating
FROM Reviews
GROUP BY guest_id;

-- Guests who gave more than 1 review
SELECT guest_id, COUNT(*) AS total_reviews
FROM Reviews
GROUP BY guest_id
HAVING COUNT(*) > 1;

-- Join Reviews with Booking
SELECT R.review_id, B.booking_id, R.rating, R.comments
FROM Reviews R
INNER JOIN Booking B ON R.booking_id = B.booking_id;

-- Left join Reviews with Guest
SELECT G.name, R.rating, R.comments
FROM Guest G
LEFT JOIN Reviews R ON G.guest_id = R.guest_id;

-- Nested: Highest rated guest
SELECT guest_id
FROM Reviews
WHERE rating = (SELECT MAX(rating) FROM Reviews);
----------------------------------------------------------------------------------------------------------------------------------------------------
