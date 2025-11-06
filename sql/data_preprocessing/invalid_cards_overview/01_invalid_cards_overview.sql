/* 01 Share of valid and invalid cards
 We calculate how many transactions correspond to null cards and how many to valid cards.
 Let’s also make sure that all cards are either marked with the string 'NULL' or have
 some other string value, and that there are no SQL nulls among them.
 */

select
    count(*) filter (where dr_bcdisc is null) as sql_nulls,
    count(*) filter (where dr_bcdisc = 'NULL') as null_strings,
    count(*) filter (where dr_bcdisc != 'NULL' and dr_bcdisc is not null) as other
from sales;

/* 02
 We calculate how many receipt numbers (sales.dr_nchk) correspond to null cards and how
 many correspond to valid cards.
 */

select
    count(distinct dr_nchk) filter (where dr_bcdisc = 'NULL') as null_card_receipts,
    count(distinct dr_nchk) filter (where dr_bcdisc != 'NULL') as valid_cards_receipts
from sales;

/* 03
 We calculate the total revenue for the null cards and for the valid cards.
 */

select
    sum(dr_croz) filter (where dr_bcdisc = 'NULL') as null_cards_revenue,
    sum(dr_croz) filter (where dr_bcdisc != 'NULL') as valid_cards_revenue
from sales;

/* 04 Distribution of users with valid and invalid cards by day
 Let’s look at the distribution of customers with null cards and valid cards by day.
 Since we have no way to distinguish between invalid cards (it’s possible that some
 invalid transactions were made by the same person), we will also count valid
 cards not by the number of unique customers per day, but by the number of purchases
 made with a valid card per day.
 */

select
    dr_dat,
    count(dr_bcdisc) filter (where dr_bcdisc = 'NULL') as null_cards,
    count(dr_bcdisc) filter (where dr_bcdisc != 'NULL') as valid_cards
from sales
group by dr_dat
order by dr_dat;