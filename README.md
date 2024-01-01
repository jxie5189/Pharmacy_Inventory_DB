# Pharmacy_Inventory_DB

	Many of the inefficiencies involve managing the inventory, predicting prescriptions volume, actual pick up time, and the time lag of reimbursement. For example, one can ensure 100% fulfillment by overstocking, but that would only constrain cash reserve. On the flip side, an ‘on-order’ basis strategy would have each claim to be billed and then ordered from the wholesaler the next day. This would ensure only billed medications are ordered, but would  decrease customer satisfaction, because medications are always available the next day. And even when fill, not 100% of customers picks up their medication on day 1 or at all, leading to dead stock and reversed claims later on. 
	
	Thus, I intend to create a program (call Fractional_Res) that will take an advantage of the fact that customer don’t always pick up on time and many of the those customers are on the same medication by creating a program that will track prescriptions that are processed daily while monitoring drug inventory level. This will ultimately allows the program to suggest an optimal inventory purchase rate. I believe by controlling the purchase rate, while not compromising customer satisfaction, will lead to a more successful pharmacy business model. 
	
	I envision that this program to transform the pharmacy inventory system as a bank-style fraction reserve system, meaning there will be never be 100% fulfillment on day 1. Because not everyone picks up on time (on times as the day a prescription is billed) and many people are on the same medication, only a fraction of the same drug needs to be filled at all time. For example, if 10 orders for medication X were billed on day 1, and the pharmacy will carry only 8 bottles of medication X, then only 7 out of the 10 medication X order needs to be filled on day 1. The left over 1 bottle of medication will serve as a reserve for any walk-ins or if the remaining 3 out of 10 unfilled medication orders decides to show up. The missing 2 bottle needed to complete all 10 orders are will be ordered and filled from wholesaler over the next few days. This will eliminate the heavy cost needed to buy 10 bottles of Medication X at once and instead reserves the cash for other expenses. 

	While some people will evidently not pick up on the first day, there will be some people that will come and pick up. This program will set aside a percentage of billed quantity as a reserve. The reserve will stand by stock, not filled but can be filled. The total inventory would be the sum of the all filled orders and reserve stock. This sum will be initially less than the total quantity billed. The difference between the total quantity billed and the total inventory would be the amount needed to be ordered (from wholesaler) and filled. This amount will be spread over a designated number of days. 

	The program will require a login with a password and will operate simultaneously with the pharmacy’s main verification system. Once a prescription is billed, the program will be able to pull non-patient specific data out of the pharmacy’s main verification system. The program will only need certain information, such as the drug, drug identifier, the quantity billed, billed date, current inventory level, and basic insurance information. The program will keep a running total quantity of this billed medication as well as the current inventory level.	

	As the program continues to collect data, I might instill the ability to formulate a distribution curve of how often a certain medication gets pick up, and by using that information it will calculate an appropriate standard of deviation on the likelihood of something being picked up. This will leads to how much inventory should be purchased for the next day based on the likelihood of being pick up. This will also help to more accurate predict pick up patterns and shorten the duration between ordering the actual medication and receiving of payments. 
	
	Ideally, this program will be easy enough that anyone can use it. But I believe it is best reserved for the pharmacist, because there are some medication that would need to be ordered as soon as possible. As for common and regularly used medication, this program should provide easy understanding for any person designated as the purchaser.  

	There are significant portion of the program that I’m concern about. First is the ability to pull data out of the pharmacy’s main verification program. Not all pharmacy uses the same verification system. These programs are design to received electronic prescriptions from doctor office, allows pharmacist/technician to enter data entry, allows label printing, inventory management, and sometimes point of sale. Also, not all verification system is coupled with the point of sale system. The most difficult part of extracting data from the pharmacy verification system is being able to bypass the security features since the system does contain patient sensitive information. I hope that by designing the program to only extract non-patient specific information would facilitate this interaction. As an alternative, most verification system does provide file output functions and can deliver data in excel or csv format, that would be something to consider if the primary route fails. 

	My next concern is management and workflow implementation. For this program to work, everyone in the pharmacy would have to be engaged. Often times, inventory management, initial data entry, and account receivable/payable are not handled by the pharmacist. Data would need to be accurately entered into the verification system, and thus would need everyone in the workflow to understand the importance of accuracy. This new program can add new responsibilities and duties to current personnels.  
	
	Also, the pharmacy industry is heavy regulated by pharmacy benefit managers. There are probably certain rules that I am not aware of and therefore will have to re-mold this program as time progresses to compile with their rules.
