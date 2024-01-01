--INDEXES
--Replace this with your index creations.
--INDEX CREATION
create index payment_method_id_idx 
on patient(payment_method_id);

create index prescription_ndc_idx
on prescription(ndc); 

create index pharmacy_npi 
on prescription(pharmacy_npi);

create index pickup_id_idx
on prescription(pickup_id);

create index pharmacist_signed_idx
on prescription(pharmacist_signed);

create index pharmacy_npi_idx
on inventory(pharmacy_npi);

create unique index ndc_idx
on inventory(ndc);

create unique index enrollment_patient_id_idx
on enrollment(patient_id);

create index patient_id_idx
on appointment(patient_id);

create index prescriber_npi_idx
on appointment(prescriber_npi); 

create index date_billed_idx
on prescription(date_billed);

create index written_on_idx
on prescription(written_on); 

create index account_pharmacy_npi_idx 
on account(pharmacy_npi);

create index Price_change_NDC_idx
on price_change(ndc); 

