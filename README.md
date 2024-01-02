# Fractional_Rec

Many of the inefficiencies involve managing the inventory, predicting prescriptions volume, actual pick up time, and the time lag of reimbursement. For example, one can ensure 100% fulfillment by overstocking, but that would only constrain cash reserve. On the flip side, an ‘on-order’ basis strategy would have each claim to be billed and then ordered from the wholesaler the next day. This would ensure only billed medications are ordered, but would  decrease customer satisfaction, because medications are always available the next day. And even when fill, not 100% of customers picks up their medication on day 1 or at all, leading to dead stock and reversed claims later on. 
 
Thus, I intend to create a program (call Fractional_Res) that will take an advantage of the fact that customer don’t always pick up on time and many of the those customers are on the same medication by creating a program that will track prescriptions that are processed daily while monitoring drug inventory level. This will ultimately allows the program to suggest an optimal inventory purchase rate. I believe by controlling the purchase rate, while not compromising customer satisfaction, will lead to a more successful pharmacy business model.

## SQL codes:
The program is written in PostgreSQL and broken down into different components inside SQL_codes folder. The All_tables.sql contains codes for all table and table sequence creation.

### Tables: 
- PHARMACY
- ACCOUNT
- PHARMACIST_ACC
- TECHNICIAN_ACC
- DRUG
- INVENTORY
- PAYMENT
- PATIENT
- ENROLLMENT
- PRESCRIBER
- APPOINTMENT
- PICKUP_PERSON
- PRESCRIPTION
- PRICE_CHANGE

Once tables are created, the All_indexes can be created for the tables.

### Triggers:
There are only 4 triggers for this program in the All_triggers.sql, price_change_trig and validate_****_npi_trg. The price_change_trig calls a price_change_fx() when there is an update on drug_price on the DRUG table. The price_change_fx() will insert a price_change_id, new price, old price, drug ndc, and date into the PRICE_CHANGE table. 

The validate_npi_trig is atually 3 separate triggers that utilizes the same validate_npi_fx() but on different call conditions. The validate_npi_fx() raises a exception prior to any table inseration/update and if it satisfies the condition that the npi is less than 10 digits. The validate_pharmacy_npi_trig calls validate_npi_fx() when evaluating a pharmacy npi, the validate_pharmacist_npi_trigg calls validate_npi_fx() when evaluating a pharmacist's npi, and validate_prescriber_npi_trig calls validate_npi_fx() when evaluating a prescriber's npi. 

### Procedures:
All procedures are stored in All_procedures.sql file. 

**Add_Pharmacist_Acc, Add_Technician_Acc, Add_other_Acc, Add_Prescriber, Add_drug**, and **add_inventory** all takes input information and adds to their respective table to faciliate table population. 

The **register_patient** procedure takes patient related information and assess if the patient carries any insurance. The procedure contains 2 if statements: 

- if have_insurance is false, then patient information is inserted into PATIENT table with their payment_method_id as cash (using a subquery ['select payment_method_id from payment where is_cash=True']).
- if have_insurance is true, then the patient's insurance information is inserted into the PAYMENT table and patient information is inserted into the PATIENT table.

All patient information is then inserted into the ENROLLMENT table. 

The **Add_Prescription** procedure takes the input prescription information and utilizes subqueries to obtain referenced entries from other tables to insert into the PRESCRIPTION table and then subsequently updates the INVENTORY table. Drug_ndc, pharm_npi, get_patient_id, get_prescriber_npi are declared variables and obtained from table DRUG, PHARMACY, PATIENT, and PRESCRIBER respectively. After insertion into PRESCRIPTION table, the tobe_filled_quantity in the INVENTORY table is updated with a running count. 

The **verify_rx** procedure allows a pharmacist to fill/not fill a prescription by allowing the pharmacist to pass a boolean *fill_rx* into the procedure. This procedure also provides as a signals for if a prescription has been seen and checked by a pharmacist or not. rph_npi, rx_ndc, rx_qty, and rx_curr_qty are declared variables that references from table PHARMACIST_ACC, PRESCRIPTION, PRESCRIPTION, INVENTORY, respectively using queries. The procedure updates a prescription by setting the *sign* attribute as true and *pharmacist_signed* as the rph_npi. If the boolean *fill_rx* is true **AND** the prescription quantity (rx_qty) is less than current drug quantity (rx_curr_number), then 2 things will follow:
1. update the inventory of the prescription ndc (rx_ndc) in the INVENTORY table with the following:
   - filled_quantity is updated with current filled_quantity + prescription quantity (rx_qty)
   - tobe_filled_quantity is updated with current tobe_filled_quantity - rx_qty
   - current_quantity is updated with current_quantity - rx_qty
2. update the prescription and set is_rx_filled to be true  

The **pickup_rx** procedure indicates the final sale of a prescription and the finalizes the deduction from the inventory. The procedure updates 3 different tables (PRESCRIPTION, INVENTORY, PATIENT) and inserts into the PICKUP_PERSON table. The pickup_id in the PRESCRIPTION table is updated, the filled_quantity from the INVENTORY table is updated (via subquery to obtain the quantity_dispensed), and the avg_pickuptime in the PATIENT table is updated. The avg_pickuptime is calculated thru a subquery of the average *pickup_date* - *written_on* from PRESCRIPTION table joined PICKUP_PERSON join PATIENT. 














 
