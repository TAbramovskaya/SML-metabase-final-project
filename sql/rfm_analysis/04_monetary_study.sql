/*
 Let’s take a look at how the score boundaries for monetary were determined when dividing
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
                      sum(dr_croz * dr_kol) as monetary,
                      sum(dr_sdisc) as total_discount,
                      sum(dr_croz * dr_kol - dr_sdisc) as total_discounted,
                      sum(dr_sdisc) / sum(dr_croz * dr_kol) as percent
                  from regular_transactions
                  group by dr_bcdisc),
     rfm_scores as (select
                        card_number,
                        recency,
                        frequency,
                        monetary,
                        ntile(3) over (order by recency asc) as r_score,
                        ntile(3) over (order by frequency desc) as f_score,
                        ntile(3) over (order by monetary desc) as m_score
                    from rfm_base),
     median_val as (select
                        percentile_cont(0.5) within group (order by monetary) as median
                    from rfm_base)
select
    m_score,
    count(card_number) as group_size,
    min(monetary) as min_monetary,
    max(monetary) as max_monetary,
    median
from rfm_scores
cross join median_val
group by m_score, median
order by m_score;

/*
 Result:
    +-------+----------+------------+------------+------+
    |m_score|group_size|min_monetary|max_monetary|median|
    +-------+----------+------------+------------+------+
    |1      |762       |1181        |33739       |684   |
    |2      |762       |408         |1179        |684   |
    |3      |761       |23          |408         |684   |
    +-------+----------+------------+------------+------+
 We are working with data that is three years old. We can see that the highest
 spending values differ from the median by two orders of magnitude.
 Let’s define Group 0 as customers who spent more than 4 000 rubles, and divide
 the remaining customers into three approximately equal groups.
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
                        ntile(3) over (order by recency asc) as r_score,
                        ntile(3) over (order by frequency desc) as f_score,
                        case
                            when monetary >= 4000 then 0
                            else ntile(3) over (partition by (monetary < 4000) order by monetary desc)
                        end as m_score
                    from rfm_base),
     median_val as (select
                        percentile_cont(0.5) within group (order by monetary) as median
                    from rfm_base)
select
    m_score,
    count(card_number) as group_size,
    min(monetary) as min_monetary,
    max(monetary) as max_monetary,
    median
from rfm_scores
cross join median_val
group by m_score, median
order by m_score;

/*
 Result:
    +-------+----------+------------+------------+------+
    |m_score|group_size|min_monetary|max_monetary|median|
    +-------+----------+------------+------------+------+
    |0      |141       |4010        |32058       |652   |
    |1      |715       |959         |3979        |652   |
    |2      |715       |361         |957         |652   |
    |3      |714       |22          |359         |652   |
    +-------+----------+------------+------------+------+

 */