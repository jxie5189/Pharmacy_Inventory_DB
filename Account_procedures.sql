--PHARMACIST ACCOUNT CREATION 
create or replace procedure Add_Pharmacist_Acc(
								Account_UserName varchar,
								pharmacy_npi decimal,
								pharmacist_npi decimal,
								EncryptedPassword varchar,
								Is_Pharmacist_Acc boolean)
as 
$proc$
begin 

	insert into Account(Account_UserName,
					 pharmacy_npi,
					 EncryptedPassword,
					 Is_Pharmacist_Acc)
	values(Account_UserName, pharmacy_npi, EncryptedPassword, true);

	insert into Pharmacist_Acc(Account_username,pharmacist_npi)
	values(account_username, pharmacist_npi);

end;
$proc$ language plpgsql

--TECHNICIAN ACCOUNT CREATION 
create or replace procedure Add_Technician_Acc(
								Account_UserName varchar,
								pharmacy_npi decimal,
								EncryptedPassword varchar,
								Is_Technician_Acc boolean)
as 
$proc$
begin 

	insert into Account(Account_UserName,
					 pharmacy_npi,
					 EncryptedPassword,
					 Is_Technician_Acc)
	values(Account_UserName, pharmacy_npi, EncryptedPassword, true);

	insert into technician_Acc(Account_username)
	values(account_username);

end;
$proc$ language plpgsql

--OTHER ACCOUNT CREATION 
create or replace procedure Add_other_Acc(
								Account_UserName varchar,
								pharmcacy_npi decimal,
								EncryptedPassword varchar,
								Is_other_Acc boolean)
as 
$proc$
begin 

	insert into Account(Account_UserName,
					 pharmacy_npi,
					 EncryptedPassword,
					 Is_other_Acc)
	values(Account_UserName, pharmacy_npi, EncryptedPassword, true);

end;
$proc$ language plpgsql


start transaction;
do
$$begin
call Add_Pharmacist_ACC('Mary_Lowe90', 1417429408, 1758648528,'ml4490', true);
end$$;
commit transaction;

start transaction;
do 
$$
begin 
	call add_technician_acc('Joe_Tech55', 1417429408, 'jt1234', true);
end
$$;
commit transaction; 

call add_technician_acc('Joe_Tech55', 1417429408, 'jt1234', true);

call add_other_acc('Carl_Saves', 1417429408, 'password123', true);


rollback; 








