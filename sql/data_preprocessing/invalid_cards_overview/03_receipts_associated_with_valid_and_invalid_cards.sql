/* 03 Receipts associated with valid and invalid cards
 We calculate how many receipts (sales.dr_nchk) correspond to invalid (null) cards
 and how many correspond to valid cards.
 */

select
    count(distinct dr_nchk) filter (where dr_bcdisc = 'NULL') as null_receipts,
    count(distinct dr_nchk) filter (where dr_bcdisc != 'NULL') as valid_receipts
from sales;

/*
 Result:
    +-------------+--------------+
    |null_receipts|valid_receipts|
    +-------------+--------------+
    |4951         |4045          |
    +-------------+--------------+
 */
