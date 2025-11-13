/*
 Among the valid cards, a few stand out due to anomalous behavior. Specifically, they account for a very large number of transactions and/or transactions are conducted across a large number of different pharmacies. The study period is approximately six weeks. Let’s limit the number of pharmacy visits per customer to 12 during this period and see the results.
 */

with valid_transactions as (select *
                            from sales
                            where dr_bcdisc != 'NULL')
select
        row_number()
        over (order by count(distinct (dr_dat, dr_tim, dr_nchk, dr_ndoc, dr_apt, dr_kkm, dr_tabempl)) desc) as rank,
        count(distinct (dr_dat, dr_tim, dr_nchk, dr_ndoc, dr_apt, dr_kkm, dr_tabempl)) as receipts,
        dr_bcdisc as card,
        count(distinct dr_apt) as stores
from valid_transactions
group by dr_bcdisc
order by receipts desc
limit 15;

/*
 Result:
+----+--------+------------+------+
|rank|receipts|card        |stores|
+----+--------+------------+------+
|1   |2000    |200000000022|1     |
|2   |1032    |200000000492|7     |
|3   |527     |200000000024|7     |
|4   |82      |200010000015|8     |
|5   |73      |200000000042|8     |
|6   |47      |200000000044|6     |
|7   |36      |200010018869|1     |
|8   |34      |200010020088|1     |
|9   |24      |200010011985|1     |
|10  |19      |200010020276|1     |
|11  |18      |200010027390|1     |
|12  |17      |200010020302|1     |
|13  |14      |200010018361|1     |
|14  |13      |200010009969|1     |
|15  |13      |200010022842|1     |
+----+--------+------------+------+


 Card 200000000022 accounts for more than a quarter of all receipts. The top six cards with the highest number of receipts together accumulate over half of all receipts.
 */

select
    count(*) as num_transactions,
    count(distinct (dr_dat, dr_tim, dr_nchk, dr_ndoc, dr_apt, dr_kkm, dr_tabempl)) as num_receipts
from sales
where dr_bcdisc in
      ('200000000022', '200000000492', '200000000024', '200010000015', '200000000042', '200000000044');

/*
 Result:
    +----------------+------------+
    |num_transactions|num_receipts|
    +----------------+------------+
    |8194            |3734        |
    +----------------+------------+

 We highlight the first six cards.
 The card with id=1 has an abnormally large number of unique receipts over the incomplete six-week period (all of them at a single store): 2000 transactions totaling 1 529 558.10R. Cards with ids 2 through 6 have fewer transactions, but purchases were made at different pharmacies. For example, for the second card, 200000000492, there were 957 transactions totaling 839,869.77 rubles, and transactions were conducted at multiple pharmacies on each working day.
 */

with daily_card_usage as (select
                              dr_dat as transaction_date,
                              count(distinct
                                    (dr_dat, dr_tim, dr_nchk, dr_ndoc, dr_apt, dr_kkm, dr_tabempl)) as receipts,
                              count(distinct dr_apt) as stores
                          from sales
                          where dr_bcdisc = '200000000492'
                          group by dr_dat)
select
    count(distinct transaction_date) as num_active_days,
    min(receipts) as min_recipts_daily,
    round(avg(receipts), 1) as avg_recipts_daily,
    max(receipts) as max_recipts_daily,
    min(stores) as min_dist_stores_daily
from daily_card_usage;

/*
 Result:
    For card number 200000000492
+---------------+-----------------+-----------------+-----------------+---------------------+
|num_active_days|min_recipts_daily|avg_recipts_daily|max_recipts_daily|min_dist_stores_daily|
+---------------+-----------------+-----------------+-----------------+---------------------+
|39             |14               |26.5             |35               |4                    |
+---------------+-----------------+-----------------+-----------------+---------------------+

 Similar behavior is observed up to the third card 200000000024, for which there were 504 transactions totaling 204 067 rubles, and the result of an analogous query would be as follows.
    +---------------+-----------------+-----------------+-----------------+---------------------+
    |num_active_days|min_recipts_daily|avg_recipts_daily|max_recipts_daily|min_dist_stores_daily|
    +---------------+-----------------+-----------------+-----------------+---------------------+
    |20             |15               |26.4             |50               |5                    |
    +---------------+-----------------+-----------------+-----------------+---------------------+

 I am not inclined to consider such behavior typical of a regular customer. I assume that these cards may be used by pharmacy employees to process orders placed by phone, for example.

 For cards with ids 4 through 6, such diversity of pharmacies in a single day is not observed (ranging from one to four per day), and the number of unique receipts per day also decreases (from one to, rarely, six). However, over the entire period, these cards are still recorded at a large number of different pharmacies, and the total value of all purchases during the period remains very high.

 I would assume that such behavior could be observed from social workers who assist individuals with limited mobility in making the necessary purchases for them.

 Starting from card ID 7 and onward, we observe significantly greater consistency in the  number of different pharmacies visited. In this case, the frequency of pharmacy visits can still be high (for some customers, we even see daily visits), but in my
 opinion, such behavior falls within the expected pattern of an ordinary customer.

 */

with regular_transactions as (select
                                  count(distinct
                                        (dr_dat, dr_tim, dr_nchk, dr_ndoc, dr_apt, dr_kkm, dr_tabempl)) as receipts,
                                  round(sum(dr_croz * dr_kol - dr_sdisc)::numeric, 2) as total_purchase_value,
                                  dr_bcdisc as card,
                                  count(distinct dr_apt) as stores
                              from sales
                              where dr_bcdisc not in
                                    ('200000000022', '200000000492', '200000000024', '200010000015', '200000000042',
                                     '200000000044', 'NULL')
                              group by dr_bcdisc)
select *
from regular_transactions
order by receipts desc;

/*
 Result:
+--------+--------------------+------------+------+
|receipts|total_purchase_value|card        |stores|
+--------+--------------------+------------+------+
|36      |13965               |200010018869|1     |
|34      |22012               |200010020088|1     |
|24      |11059               |200010011985|1     |
|19      |9515                |200010020276|1     |
|18      |12635               |200010027390|1     |
|17      |8565                |200010020302|1     |
|14      |6980                |200010018361|1     |
|13      |18057               |200010022842|1     |
|13      |8430                |200010009969|1     |
|11      |9114                |200010002315|1     |
...

 Thus, we exclude from the analysis cards ('200000000022', '200000000492', '200000000024', '200010000015', '200000000042', '200000000044').
 */