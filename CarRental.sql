create database CarRental;
use CarRental;
create table Customer (
CustomerName varchar(20) primary key,
CustomerID int,
CustomerAddress varchar(150),
CustomerPhoneNumber int,
CustomerEmail varchar(75)
);
ALTER TABLE Customer MODIFY CustomerPhoneNumber VARCHAR(15);
insert into Customer (CustomerName, CustomerID, CustomerAddress, CustomerPhoneNumber, CustomerEmail)
values ( 'Omer Omeredin', 1, '11235 oak leaf dr', '2407227724', 'omeromeredin@gmail.com');
insert into Customer (CustomerName, CustomerID, CustomerAddress, CustomerPhoneNumber, CustomerEmail)
values ( 'John Abraham', 2, '11250 University Blvd', '2403825971', 'johnabraham@gmail.com');
insert into Customer (CustomerName, CustomerID, CustomerAddress, CustomerPhoneNumber, CustomerEmail)
values ( 'Joseph Murray', 3, '1690 Georgetown Rd', '20205483726', 'josephmurray@gmail.com');
insert into Customer (CustomerName, CustomerID, CustomerAddress, CustomerPhoneNumber, CustomerEmail)
values ( 'George Morgan', 4, '11200 oak leaf dr', '2408174592', 'georgemorgan@gmail.com');
create table Location (
LocationName varchar(50) primary key,
LocationAddress varchar(150),
NumberofCars int 
);
insert into Location (LocationName, LocationAddress, NumberofCars)
values ('Dulles', '1 Saarinen Cir', 219);
insert into Location (LocationName, LocationAddress, NumberofCars)
values ('BWI', '7050 Friendship Rd', 301);
insert into Location (LocationName, LocationAddress, NumberofCars)
values ('New York', '8500 Essington Ave', 375);
insert into Location (LocationName, LocationAddress, NumberofCars)
values ('Newark', '3 Brewster Rd', 322);
create Table Reservations (
ReservationID int primary key,
CustomerID int,
CarID int,
PickupDay varchar(30),
PickupTime varchar(30),
DropoffDay varchar(30),
DropoffTime varchar(30),
RentalPrice float(10)
);
insert into Reservations (ReservationID, CustomerID, CarID, PickupDay, PickupTime, DropoffDay, DropoffTime, RentalPrice)
values (1, 3, 2, 'July 1', '7:30 pm', 'July 5', '10:30 am', 210.00 );
insert into Reservations (ReservationID, CustomerID, CarID, PickupDay, PickupTime, DropoffDay, DropoffTime, RentalPrice)
values (2, 1, 2, 'June 30', '1:00 pm', 'July 6', '1:00 am', 495.00 );
update Reservations
set CarID = 1
where ReservationID = 2;
insert into Reservations (ReservationID, CustomerID, CarID, PickupDay, PickupTime, DropoffDay, DropoffTime, RentalPrice)
values (3, 2, 3, 'June 29', '3:00 pm', 'July 2', '1:00 am', 185.00 );
insert into Reservations (ReservationID, CustomerID, CarID, PickupDay, PickupTime, DropoffDay, DropoffTime, RentalPrice)
values (4, 4, 4, 'June 30', '6:30 pm', 'July 7', '5:00 am', 650.00 );
create table Car (
CarID int primary key,
LicensePlateNumber varchar(8),
LicensePlateState varchar(15),
Year int,
Make varchar(15),
Model varchar(15),
Color varchar(10),
LocationName varchar(50),
OdometerReading int,
RentalStatus varchar(3)
);
ALTER TABLE Car MODIFY OdometerReading int;
insert into Car ( CarID, LicensePlateNumber, LicensePlateState, Year, Make, Model, LocationName, OdometerReading, RentalStatus)
values (1, '8VS7439', 'Maryland', 2022, 'Chrysler', 'Pacifica', 'Newark', 26000, 'Yes');
insert into Car ( CarID, LicensePlateNumber, LicensePlateState, Year, Make, Model, LocationName, OdometerReading, RentalStatus)
values (2, '6ES8294', 'Virginia', 2022, 'Toyota', 'Corolla', 'BWI', 33000, 'Yes');
insert into Car ( CarID, LicensePlateNumber, LicensePlateState, Year, Make, Model, LocationName, OdometerReading, RentalStatus)
values (3, '2DZ2936', 'Pennsylvania', 2023, 'Toyota', 'RAV4', 'Philadelphia', 12000, 'No');
insert into Car ( CarID, LicensePlateNumber, LicensePlateState, Year, Make, Model, LocationName, OdometerReading, RentalStatus)
values (4, '5CE2856', 'Maryland', 2021, 'Ford', 'Transit van', 'Dulles', 21000, 'Yes');
select * 
from Car 
where LocationName = 'Newark';
select avg(RentalPrice) as averagevalue
from Reservations;
SELECT ReservationID, SUM(RentalPrice) AS TotalAmount
FROM Reservations
GROUP BY ReservationID
HAVING COUNT(ReservationID) >= 1
ORDER BY TotalAmount DESC;
select ReservationID
from Reservations 
where CarID in
(select CarID
from Car
where OdometerReading > 25000);
select CustomerID from Customer
Union all
select LocationName from Location;
select *
from Car;
insert into Location (LocationName, LocationAddress, NumberofCars)
select distinct LocationName, LocationAddress, NumberofCars
from Location
where NumberofCars < 290;
select Reservations.ReservationID
from Reservations, Car
where Car.CarID = Reservations.CarID;
DELETE Reservations, Car
FROM Reservations
INNER JOIN Car ON Reservations.CarID = Car.CarID
WHERE Car.CarID = 1;
update Location
set NumberofCars = 400
where LocationName = 'Dulles';
select *
from Location;
create view Reservation as
select ReservationID, CustomerID, CarID, RentalPrice
from Reservations;
select *
from Reservation;
DELIMITER $$
CREATE TRIGGER referential_integrity
BEFORE delete ON Customer
FOR EACH ROW
BEGIN
    delete from Customer where CustomerID = old.CustomerID;
END;
$$
DELIMITER $$
create trigger attribute_domain
before insert on Reservations
for each row
begin
declare counting int;
set counting = 0;
select count(*) into counting from CustomerID where ReservationID = new.ReservationID;
if counting = 0 then
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = ' Inval11.10, Continue-Trigger Exercises on
Referential Integrity, Domain Attribute Checking, Business Rue';
END IF;
END;
$$
DELIMITER $$
create trigger database_log
after insert on Customer
for each row
begin
insert into Reservations values (concat('customer has been added by',current_user(), 'on', current_date()));
END;
$$
DELIMITER $$
CREATE TRIGGER gather_statistics
AFTER UPDATE ON Location
FOR EACH ROW
BEGIN
    INSERT INTO Location (LocationName, LocationAddress, NumberofCars)
    VALUES (
        CASE
            WHEN INSERTING THEN 'INSERT'
            WHEN UPDATING THEN 'UPDATE'
            WHEN DELETING THEN 'DELETE'
        END,
        'TableName',
        CURRENT_TIMESTAMP
    );
END;
$$