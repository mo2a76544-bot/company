create database hospital
go
use hospital
go
create schema model
go
CREATE TABLE Doctor (
    doctor_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    specialty VARCHAR(100),
    years_experience INT
);

CREATE TABLE Patient (
    UR_number INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(200),
    age INT,
    email VARCHAR(100),
    phone VARCHAR(20),
    medicare_number VARCHAR(50),
    primary_doctor_id INT,
    FOREIGN KEY (primary_doctor_id) REFERENCES Doctor(doctor_id)
);

CREATE TABLE PharmaCompany (
    company_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(200),
    phone VARCHAR(20)
);

CREATE TABLE Drug (
    drug_id INT PRIMARY KEY,
    trade_name VARCHAR(100) NOT NULL,
    drug_strength VARCHAR(50),
    company_id INT,
    FOREIGN KEY (company_id) REFERENCES PharmaCompany(company_id)
        ON DELETE CASCADE
);

CREATE TABLE Prescription (
    prescription_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    drug_id INT,
    date DATE,
    quantity INT,
    FOREIGN KEY (patient_id) REFERENCES Patient(UR_number),
    FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id),
    FOREIGN KEY (drug_id) REFERENCES Drug(drug_id)
);

SELECT * 
FROM Doctor;

SELECT * 
FROM Patient
ORDER BY age ASC;

SELECT *
FROM Patient
ORDER BY UR_number
OFFSET 4 ROWS FETCH NEXT 10 ROWS ONLY;

SELECT TOP 5 * 
FROM Doctor;

SELECT DISTINCT address
FROM Patient;

SELECT *
FROM Patient
WHERE age = 25;

SELECT *
FROM Patient
WHERE email IS NULL;

SELECT *
FROM Doctor
WHERE years_experience > 5
  AND specialty = 'Cardiology';

  SELECT *
FROM Doctor
WHERE specialty IN ('Dermatology', 'Oncology');

SELECT *
FROM Patient
WHERE age BETWEEN 18 AND 30;

SELECT *
FROM Doctor
WHERE name LIKE 'Dr.%';

SELECT name AS DoctorName,
       email AS DoctorEmail
FROM Doctor;

SELECT P.prescription_id,
       Pa.name AS patient_name,
       P.date,
       P.quantity
FROM Prescription P
JOIN Patient Pa ON P.patient_id = Pa.UR_number;

SELECT address AS city,
       COUNT(*) AS total_patients
FROM Patient
GROUP BY address;

SELECT address AS city,
       COUNT(*) AS total_patients
FROM Patient
GROUP BY address
HAVING COUNT(*) > 3;

SELECT address, age, COUNT(*) AS total
FROM Patient
GROUP BY GROUPING SETS (
    (address),
    (age)
);

SELECT address, age, COUNT(*) AS total
FROM Patient
GROUP BY CUBE (address, age);

SELECT address, COUNT(*) AS total
FROM Patient
GROUP BY ROLLUP (address);

SELECT *
FROM Patient Pa
WHERE EXISTS (
    SELECT 1
    FROM Prescription Pr
    WHERE Pr.patient_id = Pa.UR_number
);

SELECT name
FROM Doctor
UNION
SELECT name
FROM Patient;

WITH PatientDoctor AS (
    SELECT Pa.name AS patient_name,
           D.name AS doctor_name
    FROM Patient Pa
    JOIN Doctor D ON Pa.primary_doctor_id = D.doctor_id
)
SELECT * FROM PatientDoctor;

INSERT INTO Doctor (doctor_id, name, email, phone, specialty, years_experience)
VALUES (101, 'Dr. Ahmed Ali', 'ahmed@example.com', '0500000000', 'Cardiology', 10);

INSERT INTO Patient (UR_number, name, address, age, email, phone)
VALUES 
(201, 'Ali Hassan', 'Geelong', 22, NULL, '0400000001'),
(202, 'Mona Ibrahim', 'Melbourne', 30, 'mona@mail.com', '0400000002'),
(203, 'Sara Khaled', 'Geelong', 19, NULL, '0400000003');

UPDATE Doctor
SET phone = '0555555555'
WHERE doctor_id = 101;

UPDATE Pa
SET Pa.address = 'NewCity'
FROM Patient Pa
JOIN Prescription Pr ON Pa.UR_number = Pr.patient_id
WHERE Pr.doctor_id = 101;

DELETE FROM Patient
WHERE UR_number = 201;
BEGIN TRANSACTION;
INSERT INTO Doctor VALUES (102, 'Dr. Sara Noor', 'sara@mail.com', '0500001111', 'Oncology', 7);
INSERT INTO Patient VALUES (204, 'Hassan Ali', 'Geelong', 45, NULL, '0400000123', NULL);
COMMIT;

go
CREATE VIEW PatientDoctorView AS 
SELECT Pa.name AS patient_name,
       D.name AS doctor_name,
       Pa.address,
       D.specialty
FROM Patient Pa
JOIN Doctor D ON Pa.primary_doctor_id = D.doctor_id;
go

CREATE INDEX idx_patient_phone
ON Patient(phone);

BACKUP DATABASE HospitalDB
TO DISK = 'C:\Backup\HospitalDB.bak';
