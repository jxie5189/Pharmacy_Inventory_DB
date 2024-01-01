# Fractional_Rec

Many of the inefficiencies involve managing the inventory, predicting prescriptions volume, actual pick up time, and the time lag of reimbursement. For example, one can ensure 100% fulfillment by overstocking, but that would only constrain cash reserve. On the flip side, an ‘on-order’ basis strategy would have each claim to be billed and then ordered from the wholesaler the next day. This would ensure only billed medications are ordered, but would  decrease customer satisfaction, because medications are always available the next day. And even when fill, not 100% of customers picks up their medication on day 1 or at all, leading to dead stock and reversed claims later on. 
 
Thus, I intend to create a program (call Fractional_Res) that will take an advantage of the fact that customer don’t always pick up on time and many of the those customers are on the same medication by creating a program that will track prescriptions that are processed daily while monitoring drug inventory level. This will ultimately allows the program to suggest an optimal inventory purchase rate. I believe by controlling the purchase rate, while not compromising customer satisfaction, will lead to a more successful pharmacy business model.

## SQL codes:
The program is written in PostgreSQL and broken down into different components inside SQL_codes folder. The All_tables.sql contains codes for all table and table sequence creation.

### Tables: 
PHARMACY, ACCOUNT, PHARMACIST_ACC, TECHNICIAN_ACC, DRUG, INVENTORY, PAYMENT, PATIENT, ENROLLMENT, PRESCRIBER, APPOINTMENT, PICKUP_PERSON, PRESCRIPTION, PRICE_CHANGE

Once tables are created, the All_indexes can be created for the tables.

### Triggers:
There are only 4 triggers for this program, price_change_trig and validate_****_npi_trg. The price_change_trig calls a price_change_fx() when there is an update on drug_price on the DRUG table. The price_change_fx() will insert a price_change_id, new price, old price, drug ndc, and date into the PRICE_CHANGE table. 

The validate_npi_trig is atually 3 separate triggers that utilizes the same validate_npi_fx() but on different call conditions. The validate_npi_fx() raises a exception prior to any table inseration/update and if it satisfies the condition that the npi is less than 10 digits. The validate_pharmacy_npi_trig calls validate_npi_fx() when evaluating a pharmacy npi, the validate_pharmacist_npi_trigg calls validate_npi_fx() when evaluating a pharmacist's npi, and validate_prescriber_npi_trig calls validate_npi_fx() when evaluating a prescriber's npi. 






 
