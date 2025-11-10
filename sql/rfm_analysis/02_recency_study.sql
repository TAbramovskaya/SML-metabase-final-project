/*
 Let’s take a look at how the score boundaries for recency were determined when dividing
 customers into three equal groups.
 */

with regular_transactions as (select *
                              from sales
                              where dr_bcdisc != 'NULL'
                                and dr_bcdisc not in
                                    ('200000000022', '200000000492', '200000000024', '200010000015', '200000000042',
                                     '200000000044')),
     rfm_base as (select
                      dr_bcdisc as card_number,
                      '2022-06-09'::date - max(dr_dat) as recency,
                      count(distinct dr_nchk) as frequency,
                      round(sum(dr_croz * dr_kol  - dr_sdisc)::numeric, 0) as monetary
                  from regular_transactions
                  group by dr_bcdisc),
     rfm_scores as (select
                        card_number,
                        recency,
                        frequency,
                        monetary,
                        ntile(3) over (order by recency) as r_score,
                        ntile(3) over (order by frequency desc) as f_score,
                        ntile(3) over (order by monetary desc) as m_score
                    from rfm_base)
select
    r_score,
    count(card_number) as group_size,
    min(recency) as min_recency,
    max(recency) as max_recency
from rfm_scores
group by r_score
order by r_score;

/*
 Result:
    +-------+----------+-----------+-----------+
    |r_score|group_size|min_recency|max_recency|
    +-------+----------+-----------+-----------+
    |1      |762       |0          |9          |
    |2      |762       |9          |21         |
    |3      |761       |21         |39         |
    +-------+----------+-----------+-----------+
 One third of the users made their most recent purchase no more than 10 days before
 the final date in the dataset. We have a six-week observation window, during which
 more than two thirds of all customers made their last purchase in the second half
 of the period.
 */