--STORED PROCEDURES
--PHARMACIST ACCOUNT Procedure ------------------------------------------------------------------------------------------ 
--creates PROCEDURE for pharmacist to ACCOUNT and PHARMACIST_ACCOUNT
create or replace procedure Add_Pharmacist_Acc(
								Account_UserName varchar,
								account_first_name varchar,
								account_last_name varchar,
								pharmacist_npi decimal,
								EncryptedPassword varchar,
								Is_Pharmacist_Acc boolean)
as 
$proc$
declare pharm_npi decimal(10); 
begin 

	pharm_npi := (select pharmacy_npi from pharmacy);

	insert into Account(Account_UserName,
					 account_first_name,
					 account_last_name,
					 pharmacy_npi,
					 EncryptedPassword,
					 Is_Pharmacist_Acc)
	values(Account_UserName, account_first_name, account_last_name, pharm_npi, EncryptedPassword, true);

	insert into Pharmacist_Acc(Account_username, pharmacist_npi, account_first_name, account_last_name)
	values(account_username, pharmacist_npi, account_first_name, account_last_name);

end;
$proc$ language plpgsql

 
--TECHNICIAN ACCOUNT CREATION------------------------------------------------------------------------------------------ 
--creates PROCEDURE for Technician to ACCOUNT and Technician_acc
create or replace procedure Add_Technician_Acc(
								Account_UserName varchar,
								account_first_name varchar,
								account_last_name varchar,
								EncryptedPassword varchar,
								Is_Technician_Acc boolean)
as 
$proc$
declare pharm_npi decimal(10);
begin 
	
	pharm_npi := (select pharmacy_npi from pharmacy);

	insert into Account(Account_UserName,
					 account_first_name,
					 account_last_name,
					 pharmacy_npi,
					 EncryptedPassword,
					 Is_Technician_Acc)
	values(Account_UserName, account_first_name, account_last_name, pharm_npi, EncryptedPassword, true);

	insert into technician_Acc(Account_username, account_first_name, account_last_name)
	values(account_username, account_first_name, account_last_name);

end;
$proc$ language plpgsql

--OTHER ACCOUNT CREATION------------------------------------------------------------------------------------------ 
--other non-pharmacist and non-technician account procedure
create or replace procedure Add_other_Acc(
								Account_UserName varchar,
								account_first_name varchar, 
								account_last_name varchar, 
								EncryptedPassword varchar,
								Is_other_Acc boolean)
as 
$proc$
declare pharm_npi decimal (10);
begin 

	pharm_npi := (select pharmacy_npi from pharmacy);

	insert into Account(Account_UserName,
					 account_first_name,
					 account_last_name,
					 pharmacy_npi,
					 EncryptedPassword,
					 Is_other_Acc)
	values(Account_UserName, account_first_name, account_last_name, pharm_npi, EncryptedPassword, true);

end;
$proc$ language plpgsql

--Prescriber Procedure Creation------------------------------------------------------------------------------------------------------------------  
--Procedure for inserting into Prescriber table 
create or replace procedure Add_Prescriber(Prescriber_npi decimal,
											Prescriber_first_name varchar,
											Prescriber_last_name varchar)
as 
$$
begin 
	insert into Prescriber(Prescriber_npi, Prescriber_first_name, Prescriber_last_name)
	values (Prescriber_npi, Prescriber_first_name, Prescriber_last_name);
end;
$$ language plpgsql; 

--Drug Table Procedure----------------------------------------------------------------------------------------------------------
--procedure for adding drugs into the drug table 
create or replace procedure Add_drug(ndc varchar,
									 drug_name varchar,
									 drug_strength varchar,
									 drug_price decimal,
									 drug_tradesize decimal,
									 drug_manufacturer varchar)
as 
$$
begin 

	insert into Drug(ndc, drug_name, drug_strength, drug_price, drug_tradesize, drug_manufacturer)
	values (ndc, drug_name, drug_strength, drug_price, drug_tradesize, drug_manufacturer);
	
end;
$$ language plpgsql; 


--Inventory table procedure----------------------------------------------------------------------------------------------------------------------------------------------------
--procedure for adding inventory for a particular drug 
create or replace procedure add_inventory(drug_ndc varchar,
								current_qty decimal,
								incoming_qty decimal,
								filled_qty decimal,
								Tobe_filled_qty decimal,
								reserved_qty decimal)
as
$$
declare pharm_npi decimal (10);
begin 
	
	pharm_npi := (select pharmacy_npi from pharmacy); 

	insert into inventory (Pharmacy_npi,
						NDC,
						Current_Quantity,
						Incoming_Quantity,
						Filled_Quantity,
						ToBe_Filled_Quantity,
						Reserved_Quantity)			
	values(pharm_npi, drug_ndc, current_qty, incoming_qty, filled_qty, tobe_filled_qty, reserved_qty);

end;
$$ language plpgsql; 


--Patient & Payment Procedure Creation------------------------------------------------------------------------------------------------------------------ 
--takes patient info and their insurance insrance and insert into patient and payment table 
create or replace procedure register_patient(Patient_last_name varchar,
											Patient_first_name varchar,
											Patient_DOB date, 
											Have_insurance boolean,
											insurance_id varchar,
											insurance_bin varchar,
											insurance_pcn varchar,
											insurance_group varchar,
											insurance_pbm varchar)

as 
$$
declare pharm_npi decimal(10);
begin 

	pharm_npi := (select pharmacy_npi from pharmacy);

	if have_insurance = false then
			insert into Patient(patient_id, payment_method_id, patient_last_name, patient_first_name, Patient_Dob, have_insurance)
			values (nextval('patient_seq'), (select payment_method_id from payment payment where is_cash = true), patient_last_name, Patient_first_name, patient_DOB, false);
	end if; 
	
	if have_insurance = true then
		insert into Payment(payment_method_id, is_cash, insurance_id, insurance_bin, insurance_pcn, insurance_group, insurance_pbm)
		values (nextval('payment_seq'), false, insurance_id, insurance_bin, insurance_pcn, insurance_group, insurance_pbm);
	
		insert into Patient(patient_id, payment_method_id, patient_last_name, patient_first_name, Patient_Dob, have_insurance)
		values (nextval('patient_seq'), currval('payment_seq'), patient_last_name, Patient_first_name, patient_DOB, have_insurance);
	end if; 

	insert into enrollment(pharmacy_npi, patient_id)
	values(pharm_npi, currval('Patient_seq'));

end;
$$ language plpgsql; 


--Prescription Procedure-----------------------------------------------------------------------------------
--procedure to record all the necessary information for a prescription 
--and it's assumed that once a prescription is added to the prescription table, the drug's tobe_filled is updated 
create or replace procedure Add_Prescription(
											prescribe_drug varchar,
											patient_lastname varchar, Patient_firstname varchar, patientdob date, 
											prescriber_lastname varchar, prescriber_firstname varchar,  
											pickup_id decimal,
											serial_number varchar,
											written_on date, 
											quantity_dispense decimal,
											date_billed date)  
as
$$
declare drug_ndc varchar(11);
declare pharm_npi decimal(10);
declare get_patient_id decimal(12);
declare get_prescriber_npi decimal(10);
begin 
	drug_ndc := (select ndc from drug where drug_name = prescribe_drug); 
	pharm_npi := (select pharmacy_npi from pharmacy); 
	get_patient_id := (select patient.patient_id from patient where patient.patient_last_name = patient_lastname 
																and patient.patient_first_name = patient_firstname
																and patient.patient_dob = patientdob); 
	get_prescriber_npi := (select prescriber.prescriber_npi from prescriber where prescriber.Prescriber_last_name = prescriber_lastname
																			and prescriber.prescriber_first_name = prescriber_firstname); 
												
	insert into prescription(
							Prescription_number,
							ndc,
							pharmacy_npi,
							patient_id,
							prescriber_npi,
							pickup_id, 
							serial_number,
							written_on,
							quantity_dispense,
							date_billed)						
	values (nextval('Prescription_seq'),
			drug_ndc,
			pharm_npi, 
			get_patient_id,
			get_prescriber_npi, 
			pickup_id,
			serial_number,
			written_on,
			quantity_dispense,
			date_billed); 	
		
	update inventory 
	set tobe_filled_quantity = (select tobe_filled_quantity from inventory where ndc = drug_ndc) + quantity_dispense 
	where ndc = drug_ndc;
		
end;
$$ language plpgsql; 


--verify Rx Procedure-----------------------------------------------------------------------------------
--procedure for pharmacist to verify a prescription, the pharmacist can choose to fill/not fill a prescription
--filled prescriptions will have their drug's tobe_filled qty AND current_qty decreased by the prescription's dispense_qty and their filled_qty increased
--if its not filled, then it is not updated and the tobe_filled and current_qty stays the same (filled prescription will take drugs from the total inventory vs. not filled)
create or replace procedure verify_rx(rx_number decimal,
												fill_rx boolean,
												rph_username varchar)
											
as 
$$
declare rph_npi decimal (12);
declare rx_ndc varchar(65);
declare rx_qty decimal(12,3); 
declare rx_curr_qty decimal(12,3);
begin 
	rph_npi := (select pharmacist_npi from pharmacist_acc where account_username = rph_username);
	rx_ndc := (select ndc from prescription where prescription_number = rx_number);
	rx_qty := (select quantity_dispense from prescription where prescription_number = rx_number);
	rx_curr_qty := 	(select CURRENT_QUANTITY from inventory where inventory.ndc = rx_ndc);

	update prescription 
	set signed = true, pharmacist_signed = rph_npi
	where prescription_number = rx_number;
	
	
	if fill_rx = true and rx_qty < rx_curr_qty then
	update inventory
	set  filled_quantity = (filled_quantity + rx_qty), tobe_filled_quantity = (tobe_filled_quantity - rx_qty), current_quantity = (current_quantity - rx_qty)
	where inventory.ndc = rx_ndc; 
	end if; 

	if fill_rx = true and rx_qty < rx_curr_qty then 
	update prescription
	set is_rx_filled = true 
	where prescription_number = rx_number; 
	end if; 

end;
$$ language plpgsql; 

select * from inventory;

--Pickup Rx Procedure-----------------------------------------------------------------------------------
--prescriptions that are pickedup are recorded with when it was picked up
--once pickedup, the pickup_id on the prescription will be updated and filled_qty will be lowered (b/c a picked up prescription leaves the pharmacy forever)
create or replace procedure pickup_rx(rx_number decimal, 
							pickup_date date)

as 
$$
begin 
	insert into pickup_person(pickup_id, pickup_date)
	values(nextval('pickup_person_seq'), pickup_date);
	
	update prescription 
	set pickup_id = currval('pickup_person_seq')
	where prescription_number = rx_number;

	update inventory 
	set filled_quantity = filled_quantity - (select quantity_dispense from prescription where prescription_number = rx_number)
	where ndc = (select ndc from prescription where prescription_number = rx_number); 

	update patient 
	set avg_pickuptime = (select avg(pickup_person.pickup_date - written_on) as avg_pickupdays 
							from prescription 
							join pickup_person on pickup_person.pickup_id = prescription.pickup_id
							join patient on patient.patient_id = prescription.patient_id
							where prescription.patient_id = (select prescription.patient_id from prescription where prescription_number = rx_number)
							group by prescription.patient_id)				
	where patient_id = (select patient_id from prescription where prescription_number = rx_number);

end;
$$ language plpgsql; 


