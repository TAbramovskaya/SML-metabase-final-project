/*
 We are analyzing the data. Customers are tracked using their loyalty card numbers (sales.dr_bcdisc).
 Some cards are recorded as the string 'NULL'. Let’s find out how many such entries
 there are, how many purchases (receipts) are associated with them, and what
 contribution these users make to the total revenue for the analysis period.
 */

/*
 We calculate how many transactions correspond to null cards and how many to valid cards.
 */

select
    count(dr_bcdisc) filter (where dr_bcdisc = 'NULL') as null_card_names,
    count(dr_bcdisc) filter (where dr_bcdisc != 'NULL') as card_names
from sales;

/*
 We calculate how many receipt numbers correspond to null cards and how many correspond
 to valid cards.
 */

select
    count(distinct dr_nchk) filter (where dr_bcdisc = 'NULL') as null_card_names,
    count(distinct dr_nchk) filter (where dr_bcdisc != 'NULL') as null_card_names
from sales;

/*
 We calculate the total revenue for the null cards and for the valid cards.
 */

select
    sum(dr_croz) filter (where dr_bcdisc = 'NULL') as null_card_names,
    sum(dr_croz) filter (where dr_bcdisc != 'NULL') as null_card_names
from sales;

/*
 Let’s look at the distribution of customers with null cards and valid cards by day.
 */

select
    dr_dat,
    count(dr_bcdisc) filter (where dr_bcdisc = 'NULL') as null_card_numbers,
    count(dr_bcdisc) filter (where dr_bcdisc != 'NULL') as card_numbers
from sales
group by dr_dat
order by dr_dat;