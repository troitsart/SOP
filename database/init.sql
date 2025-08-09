CREATE SCHEMA crew;

CREATE TABLE crew.employees (
    employee_id SERIAL PRIMARY KEY,
    passport_number VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    hire_date DATE NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    is_active BOOLEAN DEFAULT TRUE
);

CREATE SCHEMA passengers;

CREATE TABLE passengers.passengers (
    passenger_id SERIAL PRIMARY KEY,
    -- Персональные данные
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(10) CHECK (gender IN ('Male', 'Female', 'Other')),
    nationality VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20) NOT NULL,
    alternative_phone VARCHAR(20),
    address TEXT,
    emergency_contact_name VARCHAR(100),
    emergency_contact_phone VARCHAR(20),
    
    -- Документы
    passport_number VARCHAR(20) NOT NULL,
    passport_issuing_country VARCHAR(50) NOT NULL,
    passport_issue_date DATE NOT NULL,
    passport_expiry_date DATE NOT NULL,
    
    -- Визовая информация
    visa_number VARCHAR(30),
    visa_type VARCHAR(30),
    visa_issuing_country VARCHAR(50),
    visa_issue_date DATE,
    visa_expiry_date DATE);


INSERT INTO passengers.passengers (first_name, last_name,
                                   date_of_birth, gender, nationality, phone,
                                  passport_number, passport_issuing_country,
                                  passport_issue_date, passport_expiry_date)
VALUES ('ARTEM', 'TROITSKIY', '2003-04-25', 'Male', 'RUS', '+79660439888', '4521123456', 'Russia', '2023-08-07', '2033-09-01');


INSERT INTO passengers.passengers (first_name, last_name, date_of_birth, gender, nationality, phone, passport_number, passport_issuing_country, passport_issue_date, passport_expiry_date) VALUES
('IVAN', 'PETROV', '1990-05-15', 'Male', 'RUS', '+79161234567', '4511123456', 'Russia', '2022-01-10', '2032-01-10'),
('ELENA', 'SIDOROVA', '1985-08-22', 'Female', 'RUS', '+79162345678', '4512123456', 'Russia', '2021-11-15', '2031-11-15'),
('DMITRIY', 'SMIRNOV', '1978-03-30', 'Male', 'RUS', '+79163456789', '4513123456', 'Russia', '2020-05-20', '2030-05-20'),
('ANNA', 'IVANOVA', '1995-12-05', 'Female', 'RUS', '+79164567890', '4514123456', 'Russia', '2023-02-18', '2033-02-18'),
('ALEXEY', 'VOLKOV', '1982-07-19', 'Male', 'RUS', '+79165678901', '4515123456', 'Russia', '2021-09-25', '2031-09-25'),
('OLGA', 'KUZNETSOVA', '1993-09-12', 'Female', 'RUS', '+79166789012', '4516123456', 'Russia', '2022-06-30', '2032-06-30'),
('SERGEY', 'FEDOROV', '1975-11-28', 'Male', 'RUS', '+79167890123', '4517123456', 'Russia', '2020-12-05', '2030-12-05'),
('EKATERINA', 'MOROZOVA', '1988-04-17', 'Female', 'RUS', '+79168901234', '4518123456', 'Russia', '2023-03-22', '2033-03-22'),
('MIKHAIL', 'NIKOLAEV', '1991-06-08', 'Male', 'RUS', '+79169012345', '4519123456', 'Russia', '2021-07-14', '2031-07-14'),
('MARIA', 'PAVLOVA', '1987-02-14', 'Female', 'RUS', '+79160123456', '4520123456', 'Russia', '2022-10-09', '2032-10-09'),
('ANDREY', 'STEPANOV', '1979-10-31', 'Male', 'RUS', '+79161234567', '4522123456', 'Russia', '2020-08-12', '2030-08-12'),
('TATYANA', 'ORLOVA', '1994-07-23', 'Female', 'RUS', '+79162345678', '4523123456', 'Russia', '2023-01-05', '2033-01-05'),
('VLADIMIR', 'BORISOV', '1980-09-18', 'Male', 'RUS', '+79163456789', '4524123456', 'Russia', '2021-04-30', '2031-04-30'),
('IRINA', 'ZAYTSEVA', '1992-12-27', 'Female', 'RUS', '+79164567890', '4525123456', 'Russia', '2022-07-15', '2032-07-15'),
('NIKOLAY', 'MAKAROV', '1976-05-09', 'Male', 'RUS', '+79165678901', '4526123456', 'Russia', '2020-11-20', '2030-11-20'),
('SVETLANA', 'EGOROVA', '1989-08-03', 'Female', 'RUS', '+79166789012', '4527123456', 'Russia', '2023-05-10', '2033-05-10'),
('PAVEL', 'ANTONOV', '1983-01-26', 'Male', 'RUS', '+79167890123', '4528123456', 'Russia', '2021-12-01', '2031-12-01'),
('YULIA', 'SOKOLOVA', '1996-03-14', 'Female', 'RUS', '+79168901234', '4529123456', 'Russia', '2022-09-05', '2032-09-05'),
('ALEXANDER', 'MIKHAYLOV', '1977-07-07', 'Male', 'RUS', '+79169012345', '4530123456', 'Russia', '2020-10-15', '2030-10-15'),
('NATALIA', 'VASILYEVA', '1984-11-20', 'Female', 'RUS', '+79160123456', '4531123456', 'Russia', '2021-06-25', '2031-06-25');

CREATE SCHEMA flights;

CREATE TABLE flights.aircrafts (
    aircraft_id SERIAL PRIMARY KEY,
    registration_number VARCHAR(10) UNIQUE NOT NULL,
    model VARCHAR(50) NOT NULL,
    manufacturer VARCHAR(50) NOT NULL,
    year_of_manufacture INT,
    total_seats INT NOT NULL,
    seat_configuration JSONB,
    last_maintenance DATE,
    next_maintenance DATE,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE flights.flights (
    flight_id SERIAL PRIMARY KEY,
    
    -- Основная информация о рейсе
    flight_number VARCHAR(10) NOT NULL,
    airline_code VARCHAR(2) NOT NULL,
    iata_code VARCHAR(3) NOT NULL,
    icao_code VARCHAR(4) NOT NULL,
    
    -- Маршрут
    departure_airport VARCHAR(3) NOT NULL,
    arrival_airport VARCHAR(3) NOT NULL,
    intermediate_stops VARCHAR(3)[],
    
    -- Временные параметры
    scheduled_departure TIMESTAMP WITH TIME ZONE NOT NULL,
    scheduled_arrival TIMESTAMP WITH TIME ZONE NOT NULL,
    estimated_departure TIMESTAMP WITH TIME ZONE,
    estimated_arrival TIMESTAMP WITH TIME ZONE,
    actual_departure TIMESTAMP WITH TIME ZONE,
    actual_arrival TIMESTAMP WITH TIME ZONE,
    
    -- Статус рейса
    status VARCHAR(20) NOT NULL 
        CHECK (status IN ('Scheduled', 'Boarding', 'Departed', 'In Air', 
                        'Landed', 'Cancelled', 'Diverted', 'Delayed')),
    status_updated_at TIMESTAMP WITH TIME ZONE,
    
    -- Воздушное судно
    aircraft_id INT REFERENCES flights.aircrafts(aircraft_id),
    aircraft_registration VARCHAR(10),
    aircraft_type VARCHAR(50),
    
    -- Вместимость и загрузка
    total_seats INT NOT NULL,
    booked_seats INT DEFAULT 0,
    available_seats INT GENERATED ALWAYS AS (total_seats - booked_seats) STORED,
    
    -- Операционные данные
    gate_number VARCHAR(10),
    terminal VARCHAR(10),
    check_in_counter VARCHAR(20),
    baggage_claim VARCHAR(20),
    
    -- Метеоданные
    weather_conditions VARCHAR(50),
    visibility_km DECIMAL(5,2),
    
    -- Системная информация
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    version INTEGER DEFAULT 1
);




INSERT INTO flights.aircrafts (
    registration_number,
    model,
    manufacturer,
    year_of_manufacture,
    total_seats,
    seat_configuration,
    last_maintenance,
    next_maintenance,
    is_active
) VALUES
('RA-89012', 'Airbus A320-200', 'Airbus', 2018, 180,
 '{"economy": 150, "premium": 24, "business": 6}'::jsonb,
 '2023-10-15', '2024-01-15', true),

('VP-BRD', 'Boeing 737-800', 'Boeing', 2019, 189,
 '{"economy": 162, "premium": 21, "business": 6}'::jsonb,
 '2023-11-20', '2024-02-20', true),

('VQ-BAC', 'Sukhoi Superjet 100', 'Sukhoi', 2020, 98,
 '{"economy": 85, "business": 13}'::jsonb,
 '2023-12-05', '2024-03-05', true);



CREATE TABLE flights.bookings (
    booking_id SERIAL PRIMARY KEY,
    pnr VARCHAR(6) UNIQUE NOT NULL,  -- Пример: ABC123
    booking_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    passenger_ids INT[] NOT NULL,  -- Массив ID пассажиров
    flight_id INT NOT NULL REFERENCES flights.flights(flight_id),
    status VARCHAR(20) NOT NULL
        CHECK (status IN ('Confirmed', 'Cancelled', 'Ticketed', 'Waitlisted')),
    total_amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'RUB',
    contact_email VARCHAR(100),
    contact_phone VARCHAR(20) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


INSERT INTO flights.flights (
    flight_number,
    airline_code,
    iata_code,
    icao_code,
    departure_airport,
    arrival_airport,
    scheduled_departure,
    scheduled_arrival,
    aircraft_id,
    total_seats,
    status
) VALUES
('SU 1440', 'SU', 'SVO', 'AFL', 'SVO', 'LED', 
 '2023-12-15 08:00:00+03', '2023-12-15 09:30:00+03',
 (SELECT aircraft_id FROM flights.aircrafts WHERE registration_number = 'RA-89012' LIMIT 1),
 180, 'Scheduled'),

('SU 1702', 'SU', 'DME', 'AFL', 'DME', 'AER',
 '2023-12-15 10:20:00+03', '2023-12-15 13:05:00+03',
 (SELECT aircraft_id FROM flights.aircrafts WHERE registration_number = 'VP-BRD' LIMIT 1),
 189, 'Scheduled')
RETURNING flight_id, flight_number;




-- Бронирование 1: ARTEM TROITSKIY + один пассажир
INSERT INTO flights.bookings (
    pnr, passenger_ids, flight_id, status, total_amount, contact_phone
) VALUES (
    'ABC123',
    ARRAY[
        (SELECT passenger_id FROM passengers.passengers WHERE passport_number = '4521123456'),
        (SELECT passenger_id FROM passengers.passengers WHERE passport_number = '4511123456')
    ],
    (SELECT flight_id FROM flights.flights WHERE flight_number = 'SU 1440' LIMIT 1),
    'Confirmed',
    18500.00,
    '+79161234567'
);

-- Бронирование 2: Группа из 3 пассажиров
INSERT INTO flights.bookings (
    pnr, passenger_ids, flight_id, status, total_amount, contact_phone
) VALUES (
    'DEF456',
    ARRAY[
        (SELECT passenger_id FROM passengers.passengers WHERE passport_number = '4512123456'),
        (SELECT passenger_id FROM passengers.passengers WHERE passport_number = '4513123456'),
        (SELECT passenger_id FROM passengers.passengers WHERE passport_number = '4514123456')
    ],
    (SELECT flight_id FROM flights.flights WHERE flight_number = 'SU 1702' LIMIT 1),
    'Confirmed',
    42000.00,
    '+79162345678'
);

