/*
 The discount amount is represented as a positive value, which is then subtracted from the cost of the items in the transaction. Therefore, the total cost of goods sold in a single transaction is calculated as: quantity sold × retail price – discount amount (DR_Kol × DR_CRoz – DR_SDisc). We will check whether all of these values are indeed positive.
 */

select
    dr_kol as quantity_sold,
    dr_sdisc as discount_amount,
    dr_bcdisc as discount_barcode
from sales
where dr_sdisc < 0
   or dr_kol < 0
   or dr_croz < 0
   or dr_czak < 0;

/*
 Result:
+-------------+---------------+----------------+
|quantity_sold|discount_amount|discount_barcode|
+-------------+---------------+----------------+
|1            |-0.01          |NULL            |
|-1           |-102           |NULL            |
|-1           |0              |NULL            |
|-1           |0              |NULL            |
|-1           |-470           |NULL            |
+-------------+---------------+----------------+

Among these orders, those with a negative quantity -1, the corresponding receipts consist of a single item, and the loyalty card is recorded as 'NULL'. In transactions with a positive quantity but a negative discount, barcode 200000000492 is used, which we exclude in our analysis (see [unusual_behavior_overview.md](unusual_behavior_overview.md)).

 */