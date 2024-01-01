--QUERIES
--workque dashboard----------------------------------------------------------------------------------------------------------------
--useful for displaying all prescriptions that are billed but not yet signed 
select prescription_number,written_on, drug_name, current_quantity, quantity_dispense, is_rx_filled, pharmacist_signed
from prescription 
join drug on drug.ndc = prescription.ndc
join inventory on inventory.ndc = prescription.ndc
where pharmacist_signed is null
order by prescription_number;


--which pt had the most expensive medication in oct so far------------------------------------------------------------------------
select patient_first_name, patient_last_name, insurance_pbm,
		to_char(sum(quantity_dispense/drug_tradesize*drug_price), '$99,999.99') as total_cost,
		count(prescription.prescription_number) as Total_Rx,
		date_billed
from prescription
join drug on drug.ndc = prescription.ndc
join patient on patient.patient_id = prescription.patient_id
join payment on payment.payment_method_id = patient.payment_method_id
where date_billed > cast('01-oct-2022' as date)
group by patient.patient_id, payment.insurance_pbm , prescription.date_billed
order by total_cost desc;

--which pt had the most expensive medication thus far------------------------------------------------------------------------
select patient_first_name, patient_last_name, insurance_pbm,
		to_char(sum(quantity_dispense/drug_tradesize*drug_price), '$99,999.99') as total_cost,
		count(prescription.prescription_number) as Total_Rx
from prescription
join drug on drug.ndc = prescription.ndc
join patient on patient.patient_id = prescription.patient_id
join payment on payment.payment_method_id = patient.payment_method_id
group by patient.patient_id, payment.insurance_pbm 
order by total_cost desc;


--which pharmacist signed off on the most prescritption ------------------------------------------------------------------------
select count(prescription_number) as prescription_count, pharmacist_acc.account_first_name, pharmacist_acc.account_last_name
from prescription 
join drug on drug.ndc = prescription.ndc
join pharmacist_acc on pharmacist_acc.pharmacist_npi = prescription.pharmacist_signed
group by pharmacist_acc.account_first_name, pharmacist_acc.account_last_name; 

						
--which medication is below the reserved qty level and needs to be order and how much it will cost------------------------------------------------------------------------
--determins the qty to buy to fill the tobe_filled_qty with consideration of reserved_qty
--displays the drug, prescription number, and when it was billed -> will relate to the average pickup time for that person to determine when to purchase drug 		
select to_buy_table.drug_name,
		to_buy_table.prescription_number,
		to_buy_table.date_billed,
		to_buy_table.drug_strength,
		to_buy_table.current_quantity,
		to_buy_table.tobe_filled_quantity,
		to_buy_table.reserved_quantity,
		to_buy_table.buy_qty,
		ceil((buy_qty / drug.drug_tradesize)) as tradesize,
		to_char(ceil((buy_qty / drug.drug_tradesize)) * drug.drug_price, '$9,999.99') as tot_price
from(
	select prescription.prescription_number, prescription.date_billed ,drug.ndc ,drug_name, drug_strength, current_quantity,filled_quantity, tobe_filled_quantity, reserved_quantity,
		case 
			when current_quantity - tobe_filled_quantity < reserved_quantity then reserved_quantity+tobe_filled_quantity-current_quantity
			else 0
		end as buy_qty
	from drug
	join prescription on prescription.ndc = drug.ndc
	join inventory on inventory.ndc = drug.ndc 
	where written_on > cast('01-oct-2022' as date) ) to_buy_table
join drug on drug.ndc = to_buy_table.ndc
order by tot_price desc; 

select * from prescription;

--subquery potiion 
select prescription_number, drug.ndc ,drug_name, drug_strength, current_quantity,filled_quantity, tobe_filled_quantity, reserved_quantity, --prescription_number, date_billed,
	case 
		when current_quantity - tobe_filled_quantity < reserved_quantity then reserved_quantity+tobe_filled_quantity-current_quantity
		else 0
	end as buy_qty
from drug
	--join prescription on prescription.ndc = drug.ndc
join inventory on inventory.ndc = drug.ndc
join prescription on prescription.ndc = drug.ndc--to_buy_table


--average pickup times from before oct data per patient (part of patient table, insert via pickup_rx procedure)
select patient_first_name, patient_last_name, avg(pickup_date - written_on) as avg_pickupdays
from prescription 
join pickup_person on pickup_person.pickup_id = prescription.pickup_id
join patient on patient.patient_id = prescription.patient_id
where written_on < cast('01-oct-2022' as date)
group by patient_first_name, patient_last_name;

--average pickup times patient (part of patient table, insert via pickup_rx procedure)
select patient_first_name, patient_last_name, avg(pickup_date - written_on) as avg_pickupdays
from prescription 
join pickup_person on pickup_person.pickup_id = prescription.pickup_id
join patient on patient.patient_id = prescription.patient_id
group by patient_first_name, patient_last_name
order by avg_pickupdays desc;

--pt name vs rx written_date and pickupdate and diff_days
select patient_first_name, patient_last_name, written_on, pickup_date, (pickup_date - written_on) as diff_days
from prescription 
join pickup_person on pickup_person.pickup_id = prescription.pickup_id
join patient on patient.patient_id = prescription.patient_id
where written_on < cast('01-oct-2022' as date);



































