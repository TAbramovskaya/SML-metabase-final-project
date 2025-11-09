/*
 The discount amount is represented as a positive value, which is then subtracted
from the cost of the items in the transaction. Therefore, the total cost of goods
sold in a single transaction is calculated as:
quantity sold × retail price – discount amount (DR_Kol × DR_CRoz – DR_SDisc).
We will check whether all of these values are indeed positive.
 */

select
    dr_kol as quantity_sold,
    dr_croz as retail_price,
    dr_czak as wholesale_price,
    dr_sdisc as discount_amount,
    dr_cdisc as discount_code,
    dr_bcdisc as discount_barcode
from sales
where dr_sdisc < 0
   or dr_kol < 0
   or dr_croz < 0
   or dr_czak < 0;

/*
 Result:
    +-------------+------------+---------------+---------------+-------------+----------------+
    |quantity_sold|retail_price|wholesale_price|discount_amount|discount_code|discount_barcode|
    +-------------+------------+---------------+---------------+-------------+----------------+
    |1            |2           |1.15           |-0.01          |NULL         |NULL            |
    |-1           |853         |613.29         |-102           |NULL         |NULL            |
    |-1           |722         |534.35         |0              |NULL         |NULL            |
    |-1           |1848        |1420.85        |0              |NULL         |NULL            |
    |-1           |4702        |3432           |-470           |NULL         |NULL            |
    +-------------+------------+---------------+---------------+-------------+----------------+

 As we can see, all negative values occur only for invalid cards. The number of these
 transactions is also very small.

 */