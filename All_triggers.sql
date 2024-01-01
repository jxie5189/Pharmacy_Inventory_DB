
--Price change trigger						
create or replace function price_change_fx()
returns trigger language plpgsql
as $$
begin 
	insert into price_change(price_change_id, oldprice, newprice, ndc, changedate)
	values(nextval('price_change_seq'), old.drug_price, new.drug_price, new.ndc, current_date);
	
	return new;
end;
$$

create or replace trigger price_change_trg
before update of drug_price on drug
for each row 
execute procedure price_change_fx();

--price change demo
update drug
set drug_price = 99.85
where drug_name = 'diclofenac epolamine';

select * from price_change;



--validate npi-------------------------------------------------------------------------
create or replace function validate_npi_fx()
returns trigger language plpgsql 
as 
$$
begin 
	raise exception using message = 'NPI must be 10 digits of numbers';
end;
$$;

create or replace trigger validate_pharmacy_npi_trg
before update or insert on pharmacy 
for each row when (length (cast(new.pharmacy_npi as varchar)) < 10 )
execute procedure validate_npi_fx();

create or replace trigger validate_pharmacist_npi_trg
before update or insert on pharmacist_acc
for each row when (length (cast(new.pharmacist_npi as varchar)) <10)
execute procedure validate_npi_fx();

create or replace trigger validate_prescriber_npi_trg
before update or insert on prescriber
for each row when (length (cast(new.prescriber_npi as varchar)) <10)
execute procedure validate_npi_fx();














