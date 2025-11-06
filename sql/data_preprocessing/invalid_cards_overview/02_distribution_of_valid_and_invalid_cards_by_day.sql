/* 02 Distribution of users with valid and invalid cards by day
 Let’s look at the distribution of customers with invalid (null) cards and valid cards
 by day. Since we have no way to distinguish between invalid cards (it’s possible that
 some invalid transactions were made by the same person), we will also count valid
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

/*

 */