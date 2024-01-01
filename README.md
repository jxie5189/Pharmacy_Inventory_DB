# Fractional_Rec

Many of the inefficiencies involve managing the inventory, predicting prescriptions volume, actual pick up time, and the time lag of reimbursement. For example, one can ensure 100% fulfillment by overstocking, but that would only constrain cash reserve. On the flip side, an ‘on-order’ basis strategy would have each claim to be billed and then ordered from the wholesaler the next day. This would ensure only billed medications are ordered, but would  decrease customer satisfaction, because medications are always available the next day. And even when fill, not 100% of customers picks up their medication on day 1 or at all, leading to dead stock and reversed claims later on. 
 
Thus, I intend to create a program (call Fractional_Res) that will take an advantage of the fact that customer don’t always pick up on time and many of the those customers are on the same medication by creating a program that will track prescriptions that are processed daily while monitoring drug inventory level. This will ultimately allows the program to suggest an optimal inventory purchase rate. I believe by controlling the purchase rate, while not compromising customer satisfaction, will lead to a more successful pharmacy business model.

The original project 

The program is written in PostgreSQL and broken down into different components. 




 
