/*
 We are analyzing the data. Customers are tracked using their loyalty card numbers
 (sales.dr_bcdisc). Some cards are recorded as the string 'NULL'. Let’s find out
 how many such entries there are, how many purchases (receipts) are associated with them,
 and what contribution these users make to the total revenue for the analysis period.

 We calculate how many transactions correspond to null cards and how many to valid cards.
 Let’s also make sure that all cards are either marked with the string 'NULL' or have
 some other string value, and that there are no SQL nulls among them.
 */

select
    count(*) filter (where dr_bcdisc is null) as sql_nulls,
    count(*) filter (where dr_bcdisc = 'NULL') as null_strings,
    count(*) filter (where dr_bcdisc != 'NULL' and dr_bcdisc is not null) as other
from sales;

/*
 Result:
    +---------+------------+-----+
    |sql_nulls|null_strings|other|
    +---------+------------+-----+
    |0        |27192       |17936|
    +---------+------------+-----+

 About two-thirds of the transactions were made using invalid loyalty cards. We will
 treat these transactions as purchases made without participation in the loyalty
 program and exclude them from the RFM analysis; however, we will analyze them separately.
 */