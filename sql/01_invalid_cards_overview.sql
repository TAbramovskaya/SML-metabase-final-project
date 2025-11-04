/*
 We are analyzing the data. Customers are tracked using their loyalty card numbers (sales.dr_bcdisc).
 Some cards are recorded as the string 'NULL'. Let’s find out how many such entries
 there are, how many purchases (receipts) are associated with them, and what
 contribution these users make to the total revenue for the analysis period.
 */

/*
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
 We calculate how many receipt numbers (sales.dr_nchk) correspond to null cards and how
 many correspond to valid cards.
 */

select
    count(distinct dr_nchk) filter (where dr_bcdisc = 'NULL') as null_card_receipts,
    count(distinct dr_nchk) filter (where dr_bcdisc != 'NULL') as valid_cards_receipts
from sales;

/*
 We calculate the total revenue for the null cards and for the valid cards.
 */

select
    sum(dr_croz) filter (where dr_bcdisc = 'NULL') as null_cards_revenue,
    sum(dr_croz) filter (where dr_bcdisc != 'NULL') as valid_cards_revenue
from sales;

/*
 Let’s look at the distribution of customers with null cards and valid cards by day.
 */

select
    dr_dat,
    count(dr_bcdisc) filter (where dr_bcdisc = 'NULL') as null_cards,
    count(dr_bcdisc) filter (where dr_bcdisc != 'NULL') as valid_cards
from sales
group by dr_dat
order by dr_dat;