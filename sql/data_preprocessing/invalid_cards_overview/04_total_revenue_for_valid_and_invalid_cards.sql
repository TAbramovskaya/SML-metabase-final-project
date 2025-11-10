/*
 We calculate the total revenue for the invalid (null) cards and for the valid
 cards (in thousands).
 */

select
    to_char((sum(dr_croz) filter (where dr_bcdisc = 'NULL') / 1000), '9 999K') as null_revenue,
    to_char((sum(dr_croz) filter (where dr_bcdisc != 'NULL') / 1000), '9 999K')  as valid_revenue
from sales;

/*
 Result:
    +------------+-------------+
    |null_revenue|valid_revenue|
    +------------+-------------+
    | 7 273K     | 6 231K      |
    +------------+-------------+

 */