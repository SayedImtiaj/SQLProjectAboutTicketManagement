INSERT INTO user_login (user_id, user_password, first_name, last_name, sign_up_on, email_id)
VALUES(1, 'password123', 'Asif', 'Tomal', '2023-01-01', 'asif@gmail.com'),
      (2, 'securepass', 'Imtiaj', 'Alam', '2023-02-15', 'tasif@gmail.com'),
      (3, 'secretword', 'Emon', 'Ahamed', '2023-03-10', 'emon@gmail.com');

INSERT INTO passenger (passenger_id, user_password, first_name, last_name, sign_up_on, email_id,contact)
VALUES
    (1, 'password123', 'Asif', 'Tomal', '2023-01-01', 'asif@gmail.com','01726776216'),
    (2, 'securepass', 'Imtiaj', 'Alam', '2023-02-15', 'tasif@gmail.com','0182365478'),
    (3, 'secretword', 'Emon', 'Ahamed', '2023-03-10', 'emon@gmail.com','01654789321');

INSERT INTO train_type (train_type_id, train_type, coaches_count, passenger_strength, train_count)
VALUES
    (1, 'Express', '10', '500', '2023-11-12'),
    (2, 'Local', '5', '200', '2023-11-15');

-- Insert into stations
INSERT INTO stations (station_id, station_name, city, state)
VALUES
    (1, 'Station A', 'City A', 'State A'),
    (2, 'Station B', 'City B', 'State B'),
    (3, 'Station C', 'City C', 'State C');

-- Insert into train_detailses
INSERT INTO train_detailses (train_id, train_type_id, source_station_id, destination_station_id, journey_id, duration_minutes, journey_start, passenger_strength)
VALUES
    (1, 1, 1, 3, 101, 120, '2023-11-20 08:00:00', 400),
    (2, 2, 2, 1, 102, 90, '2023-11-22 10:30:00', 150);

-- Insert into journey
INSERT INTO journey (journey_id, passenger_id, booking_id, payment_id, payment_status, paid_on, booking_status, seat_alloted)
VALUES
    (101, 1, 'BK101', 'PAY101', 'Paid', '2023-11-18 15:00:00', 'Confirmed', 'A12'),
    (102, 2, 'BK102', 'PAY102', 'Pending', NULL, 'Booked', NULL);

-- Insert into train_routes
INSERT INTO train_routes (row_id, route_id, station_id, order_number, halt_duration_minutes, estimated_arrival, estimated_departure)
VALUES
    (1, 1, 1, 1, 10, '08:00:00', '08:10:00'),
    (2, 1, 2, 2, 5, '09:00:00', '09:05:00'),
    (3, 1, 3, 3, 10, '10:30:00', '10:40:00'),
    (4, 2, 2, 1, 5, '10:00:00', '10:05:00'),
    (5, 2, 1, 2, 10, '11:30:00', '11:40:00');