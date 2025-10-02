-- Show all users
SELECT * FROM Users;

-- Show only Guests
SELECT username, email, phone 
FROM Users 
WHERE role = 'Guest';

-- Find staff with phone starting with '9876'
SELECT username, phone 
FROM Users 
WHERE phone LIKE '9876%';

-- Count how many Managers exist
SELECT COUNT(*) AS total_managers 
FROM Users 
WHERE role = 'Manager';
-----------------------------------------------------------------------------------------------------------------------------------------------
-- Show all guest details
SELECT * FROM Guest;

-- Guests living in Mumbai
SELECT name, phone 
FROM Guest 
WHERE address = 'Mumbai';

-- Count male and female guests
SELECT gender, COUNT(*) AS total 
FROM Guest 
GROUP BY gender;

-- Guests with Aadhar as ID proof
SELECT name, id_proof 
FROM Guest 
WHERE id_proof LIKE 'Aadhar%';

----------------------------------------------------------------------------------------------------------------------------------------------

-- Show all staff
SELECT * FROM Staff;

-- Staff earning more than 30,000
SELECT name, role, salary 
FROM Staff 
WHERE salary > 30000;

-- Total salary paid per role
SELECT role, SUM(salary) AS total_salary 
FROM Staff 
GROUP BY role;

-- Staff working night shift
SELECT name, role 
FROM Staff 
WHERE shift = 'Night';

-----------------------------------------------------------------------------------------------------------------------------------------------

-- Show all rooms
SELECT * FROM Rooms;

-- Available rooms only
SELECT room_number, room_type, price_per_night 
FROM Rooms 
WHERE status = 'Available';

-- Average price for each room type
SELECT room_type, AVG(price_per_night) AS avg_price 
FROM Rooms 
GROUP BY room_type;

-- Count rooms per status
SELECT status, COUNT(*) AS total 
FROM Rooms 
GROUP BY status;

-----------------------------------------------------------------------------------------------------------------------------------------------

-- Show all bookings
SELECT * FROM Booking;

-- Confirmed bookings only
SELECT booking_id, guest_id, room_id 
FROM Booking 
WHERE booking_status = 'Confirmed';

-- Number of guests booked per booking
SELECT booking_id, no_of_guests 
FROM Booking;

-- Count bookings per guest
SELECT guest_id, COUNT(*) AS total_bookings 
FROM Booking 
GROUP BY guest_id;

-----------------------------------------------------------------------------------------------------------------------------------------------

-- Show all payments
SELECT * FROM Payment;

-- Show failed payments
SELECT booking_id, amount, payment_mode 
FROM Payment 
WHERE payment_status = 'Failed';

-- Total paid amount
SELECT SUM(amount) AS total_paid 
FROM Payment 
WHERE payment_status = 'Paid';

-- Payments done via Card
SELECT payment_id, booking_id, amount 
FROM Payment 
WHERE payment_mode = 'Card';

-----------------------------------------------------------------------------------------------------------------------------------------------

-- Show all services
SELECT * FROM Service;

-- Services costing more than 1000
SELECT service_name, service_price 
FROM Service 
WHERE service_price > 1000;

-- Cheapest service
SELECT service_name, service_price 
FROM Service 
ORDER BY service_price ASC 
LIMIT 1;

-- Average service price
SELECT AVG(service_price) AS avg_price 
FROM Service;

------------------------------------------------------------------------------------------------------------------------------------------------

-- Show all booking-service details
SELECT * FROM Booking_Service;

-- Show all services taken in booking 1
SELECT booking_id, service_id, quantity 
FROM Booking_Service 
WHERE booking_id = 1;

-- Count how many services each booking took
SELECT booking_id, COUNT(*) AS total_services 
FROM Booking_Service 
GROUP BY booking_id;

-- Find bookings that took more than 1 service
SELECT booking_id, COUNT(*) AS service_count 
FROM Booking_Service 
GROUP BY booking_id 
HAVING service_count > 1;

-------------------------------------------------------------------------------------------------------------------------------------------------

-- Show all reviews
SELECT * FROM Reviews;

-- Show reviews with rating 5
SELECT guest_id, comments 
FROM Reviews 
WHERE rating = 5;

-- Average rating per guest
SELECT guest_id, AVG(rating) AS avg_rating 
FROM Reviews 
GROUP BY guest_id;

-- Highest rating given
SELECT MAX(rating) AS highest_rating 
FROM Reviews;