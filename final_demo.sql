create database insurance_db;
use insurance_db;
drop table users;
 
CREATE TABLE users (
    userId INT AUTO_INCREMENT PRIMARY KEY,
    firstName VARCHAR(100) NOT NULL,
    lastName VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    userName VARCHAR(100) NOT NULL,
    password VARCHAR(100) NOT NULL,
    role VARCHAR(100) NOT NULL
);
INSERT INTO users (firstName, lastName, email, userName, password, role)
VALUES ('John', 'Doe', 'vaishu4724@gmail.com', 'johndoe', 'password123', 'customer');
 
INSERT INTO users (firstName, lastName, email, userName, password, role)
VALUES ('Jane', 'Smith', 'jane.smith@example.com', 'janesmith', 'securepass', 'admin');
INSERT INTO users (firstName, lastName, email, userName, password, role)
VALUES ('Alice', 'Johnson', 'alice.johnson@example.com', 'alicej', 'mysecret', 'customer');
INSERT INTO users (firstName, lastName, email, userName, password, role)
VALUES ('Bob', 'Brown', 'bob.brown@example.com', 'bobbrown', '123456', 'customer');
INSERT INTO users (firstName, lastName, email, userName, password, role)
VALUES ('Eva', 'Lee', 'eva.lee@example.com', 'evalee', 'evapass', 'customer');
 
select * from users;
 
drop table insurance;
 
create table insurance(
	planId int AUTO_INCREMENT PRIMARY KEY,
    planType  VARCHAR(100) UNIQUE
);
INSERT INTO insurance values(1,'life'),(2,'health'),(3,'vehicle'),(4,'home');

select * from insurance;
 
drop table policies;
 
CREATE TABLE policies (
    policyId INT AUTO_INCREMENT PRIMARY KEY,
    policyName VARCHAR(100) NOT NULL,
    planType VARCHAR(100) NOT NULL,
    description VARCHAR(150) NOT NULL,
    period VARCHAR(20) NOT NULL,
    FOREIGN KEY(planType) REFERENCES insurance(planType)
    
);
 
INSERT INTO policies (policyName, planType, description, period)
VALUES ('Life Insurance1', 'life', 'Provides coverage for the policyholder''s life', '5');
 
INSERT INTO policies (policyName, planType, description, period)
VALUES ('Life Insurance2', 'life', 'Provides coverage for the policyholder''s life', '6');
 
INSERT INTO policies (policyName, planType, description, period)
VALUES ('Health Insurance1', 'health', 'Covers medical expenses and treatments', '6');
 
INSERT INTO policies (policyName, planType, description, period)
VALUES ('Health Insurance2', 'health', 'Covers medical expenses and treatments', '10');
 
INSERT INTO policies (policyName, planType, description, period)
VALUES ('Auto Insurance', 'vehicle', 'Covers damages to vehicles in accidents', '12');
 
INSERT INTO policies (policyName, planType, description, period)
VALUES ('car Insurance', 'vehicle', 'Covers damages to vehicles in accidents', '6');
 
 
select * from policies;
 
drop table feedback;
 
CREATE TABLE feedback (
    feedbackId INT AUTO_INCREMENT PRIMARY KEY,
    customerName VARCHAR(100) NOT NULL,
    comments VARCHAR(1000) NOT NULL
);
 
INSERT INTO feedback (customerName, comments)
VALUES ('John Doe', 'The auto insurance claim process was smooth.');
INSERT INTO feedback (customerName, comments)
VALUES ('Jane Smith', 'The health insurance coverage met my needs.');
INSERT INTO feedback (customerName, comments)
VALUES ('Bob Brown', 'The life insurance policy provided peace of mind for my family.');
INSERT INTO feedback (customerName, comments)
VALUES ('Eva Lee', 'The travel insurance plan covered unexpected medical expenses.');
 
 
drop table appliedPolicy;
CREATE TABLE appliedPolicy (
    appliedPolicyId INT AUTO_INCREMENT PRIMARY KEY,
    policyName VARCHAR(100) NOT NULL,
    planType VARCHAR(100) NOT NULL,
    customerName VARCHAR(100) NOT NULL,
    userName VARCHAR(100),
    term INT NOT NULL,
    period INT NOT NULL,
    currentDate DATE NOT NULL,
    nextPaymentDate DATE NOT NULL,
    termAmount DECIMAL(9,2) NOT NULL,
    coverageAmount BIGINT NOT NULL,
    status VARCHAR(100) NOT NULL,
    FOREIGN KEY(planType) REFERENCES insurance(planType),
    FOREIGN KEY(userName) REFERENCES users(userName)
);
 
DELIMITER //
 
CREATE TRIGGER before_insert_appliedPolicy
BEFORE INSERT ON appliedPolicy
FOR EACH ROW
BEGIN
    -- Set the current date
    SET NEW.currentDate = CURDATE();
    -- Calculate the next payment date based on the term
    SET NEW.nextPaymentDate = DATE_ADD(NEW.currentDate, INTERVAL NEW.term MONTH);
    -- Calculate the term amount based on the term
    IF NEW.term = 6 THEN
        SET NEW.termAmount = (NEW.coverageAmount / NEW.period) * 2;
    ELSEIF NEW.term = 12 THEN
        SET NEW.termAmount = (NEW.coverageAmount / NEW.period);
    END IF;
    -- Set the status to 'inprogress'
    SET NEW.status = 'inprogress';
END //
 
DELIMITER ;
 
INSERT INTO appliedPolicy (policyName,planType, customerName, term, period, coverageAmount)
VALUES ('Life Insurance','life', 'John Doe', 6, 12, 100000);
 
INSERT INTO appliedPolicy (policyName,planType, customerName, term, period, coverageAmount)
VALUES ('Health Insurance','health', 'Jane Smith', 12, 12, 50000);
 
INSERT INTO appliedPolicy (policyName,planType, customerName, term, period, coverageAmount)
VALUES ('Auto Insurance','vehicle', 'Bob Brown', 6, 6, 30000);
 
INSERT INTO appliedPolicy (policyName,planType, customerName, term, period, coverageAmount)
VALUES ('Life Insurance2','life', 'Alice Johnson', 6, 6, 150000);
 
select * from appliedPolicy;
describe appliedPolicy;
UPDATE appliedPolicy
SET nextPaymentDate = CURDATE() + INTERVAL 1 DAY
WHERE appliedPolicyId = 5;

UPDATE appliedPolicy
SET tenure = CURDATE()+ INTERVAL 1 DAY
WHERE appliedPolicyId = 5;

UPDATE appliedPolicy
SET status ='accepted'
WHERE appliedPolicyId = 17;

SELECT * FROM AppliedPolicy;

SELECT * FROM AppliedPolicy a WHERE a.nextPaymentDate="2024-07-22";

 
ALTER TABLE appliedPolicy
ADD COLUMN incomeCertificate BLOB,
ADD COLUMN selfCancelledCheque BLOB,
ADD COLUMN communicationAddressProof BLOB,
ADD COLUMN birthCertificate BLOB,
ADD COLUMN photo BLOB,
ADD COLUMN signature BLOB;


ALTER TABLE appliedPolicy
ADD COLUMN tenure DATE;

DROP TRIGGER IF EXISTS before_insert_appliedPolicy;

DELIMITER //

CREATE TRIGGER before_insert_appliedPolicy
BEFORE INSERT ON appliedPolicy
FOR EACH ROW
BEGIN
    SET NEW.currentDate = CURDATE();
    SET NEW.nextPaymentDate = DATE_ADD(NEW.currentDate, INTERVAL NEW.term MONTH);
    IF NEW.term = 6 THEN
        SET NEW.termAmount = (NEW.coverageAmount / NEW.period) * 2;
    ELSEIF NEW.term = 12 THEN
        SET NEW.termAmount = (NEW.coverageAmount / NEW.period);
    END IF;
    SET NEW.status = 'inprogress';
    SET NEW.tenure = DATE_ADD(NEW.currentDate, INTERVAL NEW.period MONTH);
END //

DELIMITER ;

 
drop table Customer;
 
CREATE TABLE Customer (
    customerId INT AUTO_INCREMENT PRIMARY KEY,
    customerName VARCHAR(100) NOT NULL,
    occupation VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    zip INT NOT NULL,
    mobileNumber BIGINT NOT NULL,
    DOB1 DATE,
    nomineeName VARCHAR(100) NOT NULL,
    nomineeOccupation VARCHAR(100) NOT NULL,
    nomineeAddress VARCHAR(100) NOT NULL,
    nomineemobileNumber BIGINT NOT NULL,
    nomineeDOB DATE
    -- FOREIGN KEY (customerId ) REFERENCES users(userId)
);
 
INSERT INTO Customer (customerName, occupation, city, state, country, zip, mobileNumber, DOB1, nomineeName, nomineeOccupation, nomineeAddress, nomineemobileNumber, nomineeDOB)
VALUES ('Alice Johnson', 'Engineer', 'New York', 'NY', 'USA', 10001, 1234567890, '1990-05-15', 'Bob Johnson', 'Doctor', '123 Street, New York, NY, USA', 9876543210, '1960-01-01');
 
INSERT INTO Customer (customerName, occupation, city, state, country, zip, mobileNumber, DOB1, nomineeName, nomineeOccupation, nomineeAddress, nomineemobileNumber, nomineeDOB)
VALUES ('Michael Brown', 'Teacher', 'Los Angeles', 'CA', 'USA', 90001, 2234567890, '1985-08-25', 'Sara Brown', 'Nurse', '456 Avenue, Los Angeles, CA, USA', 8765432109, '1965-02-10');
 
INSERT INTO Customer (customerName, occupation, city, state, country, zip, mobileNumber, DOB1, nomineeName, nomineeOccupation, nomineeAddress, nomineemobileNumber, nomineeDOB)
VALUES ('Laura Smith', 'Artist', 'Chicago', 'IL', 'USA', 60601, 3234567890, '1975-12-30', 'John Smith', 'Lawyer', '789 Boulevard, Chicago, IL, USA', 7654321098, '1955-03-20');
 
INSERT INTO Customer (customerName, occupation, city, state, country, zip, mobileNumber, DOB1, nomineeName, nomineeOccupation, nomineeAddress, nomineemobileNumber, nomineeDOB)
VALUES ('David Wilson', 'Scientist', 'Houston', 'TX', 'USA', 77001, 4234567890, '1980-11-11', 'Emma Wilson', 'Engineer', '101 Circle, Houston, TX, USA', 6543210987, '1970-04-15');
 
INSERT INTO Customer (customerName, occupation, city, state, country, zip, mobileNumber, DOB1, nomineeName, nomineeOccupation, nomineeAddress, nomineemobileNumber, nomineeDOB)
VALUES ('Emma Martinez', 'Doctor', 'Phoenix', 'AZ', 'USA', 85001, 5234567890, '1995-07-05', 'Carlos Martinez', 'Scientist', '202 Lane, Phoenix, AZ, USA', 5432109876, '1975-05-25');
 
 
SELECT * from Customer;

CREATE TABLE life_insurance_policy (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    annualIncome VARCHAR(255),
    healthHistory TEXT,
    smokingStatus VARCHAR(50),
    hobbiesLifestyle TEXT,
    medicalExamDetails TEXT
);

CREATE TABLE home_insurance_policy (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    propertyAddress VARCHAR(255),
    yearBuilt INT,
    residenceType VARCHAR(50),
    squareFootage INT,
    securitySystems VARCHAR(50)
);

CREATE TABLE health_insurance_policy (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    heightWeight VARCHAR(255),
    existingConditions TEXT,
    primaryPhysician VARCHAR(255),
    medications TEXT,
    hospitalPreferences TEXT
);

CREATE TABLE vehicle_insurance_policy (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    vin VARCHAR(50),
    currentMileage INT,
    previousClaims TEXT,
    usageType VARCHAR(50),
    usageFrequency VARCHAR(50)
);

ALTER TABLE life_insurance_policy ADD COLUMN planId INT;
ALTER TABLE home_insurance_policy ADD COLUMN planId INT;
ALTER TABLE health_insurance_policy ADD COLUMN planId INT;
ALTER TABLE vehicle_insurance_policy ADD COLUMN planId INT;

ALTER TABLE vehicle_insurance_policy drop column planType;

ALTER TABLE life_insurance_policy ADD CONSTRAINT fk_planType_life FOREIGN KEY (planId) REFERENCES insurance(planId);
ALTER TABLE home_insurance_policy ADD CONSTRAINT fk_planType_home FOREIGN KEY (planId) REFERENCES insurance(planId);
ALTER TABLE health_insurance_policy ADD CONSTRAINT fk_planType_health FOREIGN KEY (planId) REFERENCES insurance(planId);
ALTER TABLE vehicle_insurance_policy ADD CONSTRAINT fk_planType_vehicle FOREIGN KEY (planId) REFERENCES insurance(planId);

DELIMITER //

CREATE TRIGGER before_insert_life_insurance_policy
BEFORE INSERT ON life_insurance_policy
FOR EACH ROW
BEGIN
    SET NEW.planId = 1;
END //

CREATE TRIGGER before_insert_home_insurance_policy
BEFORE INSERT ON home_insurance_policy
FOR EACH ROW
BEGIN
    SET NEW.planId = 4;
END //

CREATE TRIGGER before_insert_health_insurance_policy
BEFORE INSERT ON health_insurance_policy
FOR EACH ROW
BEGIN
    SET NEW.planId = 2; 
END //

CREATE TRIGGER before_insert_vehicle_insurance_policy
BEFORE INSERT ON vehicle_insurance_policy
FOR EACH ROW
BEGIN
    SET NEW.planId = 3; 
END //

DELIMITER ;



select * from life_insurance_policy;
select * from vehicle_insurance_policy;
drop table life_insurance_policy;
drop table home_insurance_policy;
drop table health_insurance_policy;
drop table vehicle_insurance_policy;

CREATE TABLE history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    appliedPolicyId INT,
    policyName VARCHAR(100),
    planType VARCHAR(100),
    customerName VARCHAR(100),
    userName VARCHAR(100),
    term INT,
    period INT,
    currentDate DATE,
    nextPaymentDate DATE,
    tenure DATE,
    coverageAmount DECIMAL(9,2),
    termAmount DECIMAL(9,2),
    status VARCHAR(100),
    emailSentDate DATE,
    FOREIGN KEY (appliedPolicyId) REFERENCES appliedPolicy(appliedPolicyId)
);

select * from history;