/*
 Recency (how recently a customer made a purchase).
 Since we are working with a limited dataset, we will treat the last day in the dataset
 as the zero point for recency. For each customer, we will determine the minimum number
 of days between their purchases and this date.
 We use smaller group number for more recent activity (any customer from Group 1 did
 his/her most recent purchase after any customer from Group 3).

 Frequency (how often they buy).
 As we observed during data preparation, multiple transactions on the same day are very
 rare. Therefore, we will measure purchase frequency based on the number of unique
 transactions, rather than the number of calendar days.
 We use smaller group number for higher frequency (Group 1 uses store more often than Group 3).

 Monetary value (how much they spend).
 Since all of the customers considered are participants in the loyalty program,
 discounts are applied to most purchases. We will calculate both the total spending
 before discount, and separately, the total discount amount.
 We use smaller group number for users with bigger purchases (Group 1 spends more than Group 3).
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
    card_number,
    recency,
    r_score,
    frequency,
    f_score,
    monetary,
    m_score
from rfm_scores
order by recency, frequency desc, monetary desc;


/*
select
    count(card_number) as cohort_size,
    r_score::text || f_score::text || m_score::text as cohort_segment
from rfm_scores
group by r_score, f_score, m_score
order by cohort_size desc;

 */