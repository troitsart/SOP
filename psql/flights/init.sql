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
