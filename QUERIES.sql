CREATE DATABASE IF NOT EXISTS hotel_management;
USE hotel_management;

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('Guest','Staff','Manager') NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15)
);
INSERT INTO Users (username, password, role, email, phone) VALUES
('john_doe', 'pass123', 'Guest', 'john@example.com', '9876543210'),
('anna_smith', 'secure456', 'Staff', 'anna@example.com', '9876500000'),
('raj_manager', 'admin789', 'Manager', 'raj@example.com', '9876400000'),
('maria_guest', 'guest111', 'Guest', 'maria@example.com', '9876001111'),
('sam_guest', 'guest222', 'Guest', 'sam@example.com', '9876002222'),
('rita_staff', 'staff333', 'Staff', 'rita@example.com', '9876003333'),
('dev_guest', 'guest444', 'Guest', 'dev@example.com', '9876004444'),
('meera_guest', 'guest555', 'Guest', 'meera@example.com', '9876005555'),
('alex_staff', 'staff666', 'Staff', 'alex@example.com', '9876006666'),
('sara_manager', 'manager777', 'Manager', 'sara@example.com', '9876007777');


CREATE TABLE Guest (
    guest_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE,
    name VARCHAR(100) NOT NULL,
    gender ENUM('Male','Female','Other'),
    phone VARCHAR(15),
    address VARCHAR(255),
    id_proof VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);
INSERT INTO Guest (user_id, name, gender, phone, address, id_proof) VALUES
(1, 'John Doe', 'Male', '9876543210', 'Delhi', 'Aadhar123'),
(4, 'Maria Gomez', 'Female', '9876001111', 'Mumbai', 'Passport555'),
(5, 'Sam Wilson', 'Male', '9876002222', 'Bangalore', 'DL999'),
(7, 'Dev Kumar', 'Male', '9876004444', 'Pune', 'PAN888'),
(8, 'Meera Shah', 'Female', '9876005555', 'Ahmedabad', 'Voter666');

CREATE TABLE Staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE,
    name VARCHAR(100) NOT NULL,
    role ENUM('Manager','Receptionist','Housekeeping','Chef') NOT NULL,
    phone VARCHAR(15),
    salary DECIMAL(10,2),
    shift VARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);
INSERT INTO Staff (user_id, name, role, phone, salary, shift) VALUES
(2, 'Anna Smith', 'Receptionist', '9876500000', 25000.00, 'Morning'),
(3, 'Raj Patel', 'Manager', '9876400000', 50000.00, 'Full-Day'),
(6, 'Rita Mehra', 'Housekeeping', '9876003333', 18000.00, 'Evening'),
(9, 'Alex Brown', 'Chef', '9876006666', 30000.00, 'Night'),
(10, 'Sara Khan', 'Manager', '9876007777', 55000.00, 'Full-Day');

CREATE TABLE Rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(10) UNIQUE NOT NULL,
    room_type ENUM('Single','Double','Deluxe','Suite') NOT NULL,
    price_per_night DECIMAL(8,2) NOT NULL,
    status ENUM('Available','Booked','Maintenance') DEFAULT 'Available'
);
INSERT INTO Rooms (room_number, room_type, price_per_night, status) VALUES
('101', 'Single', 1500.00, 'Available'),
('102', 'Double', 2500.00, 'Booked'),
('103', 'Deluxe', 3500.00, 'Available'),
('104', 'Suite', 6000.00, 'Maintenance'),
('105', 'Single', 1500.00, 'Booked'),
('106', 'Double', 2500.00, 'Available'),
('107', 'Deluxe', 3500.00, 'Booked'),
('108', 'Suite', 6000.00, 'Available'),
('109', 'Single', 1500.00, 'Available'),
('110', 'Double', 2500.00, 'Booked');

CREATE TABLE Booking (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    guest_id INT NOT NULL,
    room_id INT NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    no_of_guests INT NOT NULL,
    booking_status ENUM('Confirmed','Cancelled','Checked-Out') DEFAULT 'Confirmed',
    FOREIGN KEY (guest_id) REFERENCES Guest(guest_id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id) ON DELETE CASCADE
);
INSERT INTO Booking (guest_id, room_id, check_in_date, check_out_date, no_of_guests, booking_status) VALUES
(1, 102, '2025-09-01', '2025-09-05', 2, 'Confirmed'),
(2, 105, '2025-09-03', '2025-09-04', 1, 'Cancelled'),
(3, 107, '2025-09-10', '2025-09-15', 2, 'Confirmed'),
(4, 101, '2025-09-12', '2025-09-14', 1, 'Checked-Out'),
(5, 103, '2025-09-20', '2025-09-23', 3, 'Confirmed'),
(1, 106, '2025-09-25', '2025-09-28', 2, 'Confirmed'),
(2, 104, '2025-09-26', '2025-09-29', 1, 'Cancelled'),
(3, 108, '2025-09-27', '2025-09-30', 2, 'Confirmed'),
(4, 110, '2025-09-28', '2025-09-30', 1, 'Checked-Out'),
(5, 109, '2025-09-29', '2025-10-01', 2, 'Confirmed');

CREATE TABLE Payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT UNIQUE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL,
    payment_mode ENUM('Cash','Card','UPI','Online') NOT NULL,
    payment_status ENUM('Paid','Pending','Failed') DEFAULT 'Pending',
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id) ON DELETE CASCADE
);
INSERT INTO Payment (booking_id, amount, payment_date, payment_mode, payment_status) VALUES
(1, 10000.00, '2025-09-01', 'Card', 'Paid'),
(2, 2500.00, '2025-09-03', 'Cash', 'Failed'),
(3, 17500.00, '2025-09-10', 'UPI', 'Paid'),
(4, 3000.00, '2025-09-12', 'Online', 'Paid'),
(5, 10500.00, '2025-09-20', 'Card', 'Pending'),
(6, 7500.00, '2025-09-25', 'Cash', 'Paid'),
(7, 6000.00, '2025-09-26', 'UPI', 'Failed'),
(8, 12000.00, '2025-09-27', 'Online', 'Paid'),
(9, 5000.00, '2025-09-28', 'Card', 'Paid'),
(10, 3000.00, '2025-09-29', 'UPI', 'Pending');

CREATE TABLE Service (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    service_name VARCHAR(50) NOT NULL,
    service_price DECIMAL(8,2) NOT NULL
);
INSERT INTO Service (service_name, service_price) VALUES
('Room Cleaning', 500.00),
('Laundry', 300.00),
('Breakfast Buffet', 700.00),
('Spa Session', 2000.00),
('Gym Access', 1000.00),
('Airport Pickup', 1500.00),
('City Tour', 2500.00),
('Dinner Buffet', 1200.00),
('Swimming Pool', 800.00),
('WiFi', 200.00);

CREATE TABLE Booking_Service (
    id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    service_id INT NOT NULL,
    quantity INT DEFAULT 1,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES Service(service_id) ON DELETE CASCADE,
    UNIQUE (booking_id, service_id)
);
INSERT INTO Booking_Service (booking_id, service_id, quantity) VALUES
(1, 1, 1),
(1, 3, 2),
(2, 2, 1),
(3, 4, 1),
(4, 5, 1),
(5, 6, 1),
(6, 7, 2),
(7, 8, 1),
(8, 9, 1),
(9, 10, 1);

CREATE TABLE Reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    guest_id INT NOT NULL,
    booking_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    review_date DATE NOT NULL,
    FOREIGN KEY (guest_id) REFERENCES Guest(guest_id) ON DELETE CASCADE,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id) ON DELETE CASCADE
);
INSERT INTO Reviews (guest_id, booking_id, rating, comments, review_date) VALUES
(1, 1, 5, 'Amazing stay! Staff was friendly.', '2025-09-06'),
(2, 2, 2, 'Booking was cancelled. Disappointed.', '2025-09-05'),
(3, 3, 4, 'Good room but food was average.', '2025-09-16'),
(4, 4, 5, 'Loved the hospitality. Will return!', '2025-09-15'),
(5, 5, 3, 'Room was nice but AC not working.', '2025-09-24'),
(1, 6, 4, 'Second visit, good experience again.', '2025-09-29'),
(2, 7, 1, 'Terrible, booking failed.', '2025-09-30'),
(3, 8, 5, 'Awesome suite with sea view!', '2025-10-01'),
(4, 9, 4, 'Comfortable but noisy.', '2025-10-02'),
(5, 10, 5, 'Best stay so far!', '2025-10-03');
