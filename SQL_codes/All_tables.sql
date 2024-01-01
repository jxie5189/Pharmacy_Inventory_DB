--TABLES
--Replace this with your table creations.
--Pharmacy creation-------------------------------- 
drop table pharmacy; 
create table PHARMACY(PHARMACY_NPI DECIMAL (10) primary key,
						Pharmacy_name varchar(65),
						pharmacy_address varchar(65)); 

--Account creation
drop table account; 
create table Account(Account_UserName varchar(65) primary key,
					 Account_First_Name varchar(65) not null,
					 Account_Last_Name varchar(65) not null,
					 pharmacy_npi decimal(10),
					 encryptedpassword varchar(65),
					 is_pharmacist_acc boolean,
					 is_technician_acc boolean,
					 is_other_acc boolean); 
alter table account 
add constraint Account_fk
foreign key (pharmacy_npi) references pharmacy(pharmacy_npi); 

--subAccount Creation 
drop table pharmacist_acc; 
create table Pharmacist_Acc(Account_UserName varchar(65) primary key,
							Pharmacist_NPI decimal(10) unique not null,
							Account_First_Name varchar(65) not null,
							Account_Last_Name varchar (65) not null, 
							foreign key (Account_UserName) references Account(Account_UserName)); 

drop table Technician_Acc;
create table Technician_Acc(Account_UserName varchar(65) primary key,
							Account_First_Name varchar(65) not null,
							Account_Last_Name varchar (65) not null, 
							foreign key (Account_Username) references Account(Account_userName)); 
						

--Drug table creation 
drop table Drug; 
create table Drug(NDC varchar(11) primary key,
				  Drug_Name varchar(255) not null,
				  Drug_Strength varchar(65) not null,
				  Drug_Price Decimal(12,2) not null,
				  Drug_Tradesize Decimal(12,3) not null,
				  Drug_Manufacturer varchar(65) not null);
				 
alter table drug
add constraint checkNDC
check(ndc not like '%[^0-9]%');

select * from drug;

--Inventory table creation 
drop table Inventory; 
create table Inventory(Pharmacy_npi decimal(10) not null,
						NDC varchar(11) not null,
						Current_Quantity decimal(12,3) not null,
						Incoming_Quantity decimal (12,3),
						Filled_Quantity decimal(12,3),
						ToBe_Filled_Quantity decimal(12,3),
						Reserved_Quantity decimal(12,3),
						foreign key (pharmacy_npi) references pharmacy(pharmacy_npi),
						foreign key (NDC) references Drug(NDC),
						primary key(pharmacy_npi, NDC)); 
					
select * from inventory;
						
--Insurance table creation 
drop table payment; 
drop sequence payment_seq; 
create table payment(payment_method_id decimal(12) primary key,
						is_cash boolean not null,
						Insurance_ID varchar(65),
						Insurance_Bin varchar(20),
						Insurance_PCN varchar(65), --can be null
						Insurance_Group varchar(65), --can be null
						Insurance_PBM varchar(65));

select * from payment;					

--Patient table creation 									
drop table Patient;
drop sequence Patient_seq; 
create table Patient(Patient_ID decimal(12) primary key,
					 payment_method_id decimal(12),--can be null
					 Patient_Last_Name varchar(65) not null,
					 Patient_First_Name varchar(65) not null,
					 Patient_DOB date not null,
					 Have_Insurance boolean not null,
					 avg_pickuptime decimal (12), 
					 foreign key (payment_method_id) references payment(payment_method_id)); 

select * from patient; 

--create enrollment 
drop table Enrollment; 
create table Enrollment(pharmacy_npi decimal(10) not null,
						patient_ID decimal(12) not null,
						foreign key (pharmacy_npi) references pharmacy(pharmacy_npi),
						foreign key (patient_id) references patient(patient_id),
						primary key(pharmacy_npi, patient_id));
--Prescriber Table
drop table Prescriber;  
create table Prescriber(Prescriber_NPI decimal(10) primary key,
						Prescriber_Last_Name varchar(65) not null,
						Prescriber_First_Name varchar(65) not null);

--Appointment table creation 
drop table Appointment;
create table Appointment(patient_ID decimal(12) not null,
					prescriber_npi decimal(10) not null,
					appointment_date date,
					foreign key (patient_id) references patient(patient_id),
					foreign key (prescriber_npi) references prescriber(prescriber_npi),
					primary key(patient_id, prescriber_npi, appointment_date));

--Pickup Person creation
drop table Pickup_person; 
drop sequence pickup_person_seq; 
create table Pickup_Person(pickup_id decimal (12) primary key,
							pickup_date date);


--create prescription table
drop table prescription;
drop sequence prescription_seq;
create table Prescription(Prescription_number decimal(12) primary key,
							ndc varchar(11),
							pharmacy_npi decimal(10),
							patient_id decimal(12),
							prescriber_npi decimal(10),
							pickup_id decimal(12), 
							serial_number varchar(9),
							written_on date,
							quantity_dispense decimal(12,3),
							date_billed date,
							is_Rx_filled boolean,
							signed boolean,
							Pharmacist_signed decimal(10),
							foreign key (ndc) references drug(ndc),
							foreign key (pharmacy_npi) references pharmacy(pharmacy_npi),
							foreign key (patient_id) references patient(patient_id),
							foreign key (prescriber_npi) references prescriber(prescriber_npi),
							foreign key (pickup_id) references pickup_person(pickup_id),
							foreign key (pharmacist_signed) references pharmacist_acc(pharmacist_npi)
							);

						
--price change table--------------------------------------------------------------------------
drop table price_change;
drop sequence price_change_id; 
create table price_change(price_change_id decimal(12),
							oldprice decimal(12,2) not null,
							newprice decimal(12,2) not null,
							ndc varchar(11) not null,
							ChangeDate date not null,
							foreign key (ndc) references drug(ndc));
						
--SEQUENCES
--Replace this with your sequence creations.
--sequences
create sequence payment_seq; 
create sequence Patient_seq; 
create sequence pickup_person_seq; 
create sequence prescription_seq; 
create sequence price_change_seq; 





























