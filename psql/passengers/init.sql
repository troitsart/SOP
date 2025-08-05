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
