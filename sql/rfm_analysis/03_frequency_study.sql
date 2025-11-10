/*
 Let’s take a look at how the score boundaries for frequency were determined when dividing
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
                        ntile(3) over (order by recency) as r_score,
                        ntile(3) over (order by frequency desc) as f_score,
                        ntile(3) over (order by monetary desc) as m_score
                    from rfm_base)
select
    f_score,
    count(card_number) as group_size,
    min(frequency) as min_frequency,
    max(frequency) as max_frequency
from rfm_scores
group by f_score
order by f_score;

/*
 Result:
    +-------+----------+-------------+-------------+
    |f_score|group_size|min_frequency|max_frequency|
    +-------+----------+-------------+-------------+
    |1      |762       |2            |36           |
    |2      |762       |1            |2            |
    |3      |761       |1            |1            |
    +-------+----------+-------------+-------------+
 When dividing customers into three equal groups, Group 1 ended up with customers whose
 visit frequency varied too widely. We do not have data on customer age to compare their
 behavior with publicly available statistics, but we can assume that pharmacies are
 mainly used by nearby residents of older age groups. For them, it is typical to visit
 a pharmacy several times per month.

 In most large cities, several pharmacies are located within walking distance. Choosing
 a pharmacy is therefore determined not only by lower prices on a broad assortment,
 but also by personal preference. Older customers tend to stick with familiar services
 rather than trying new ones; they may also prefer to discuss sensitive health-related
 questions with pharmacy staff they know, rather than going to a new location.

 Thus, it seems reasonable to shift the boundary for Groep 1 from 2 visits in six weeks
 to 4. We will also define Group 2 as customers who made 2 or 3 visits during this six-week
 period.
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
                        case
                            when frequency >= 4 then 1
                            when frequency >= 2 then 2
                            else 3
                        end as f_score,
                        ntile(3) over (order by monetary desc) as m_score
                    from rfm_base)
select
    f_score,
    count(card_number) as group_size,
    min(frequency) as min_frequency,
    max(frequency) as max_frequency
from rfm_scores
group by f_score
order by f_score;

/*
 Result:
    +-------+----------+-------------+-------------+
    |f_score|group_size|min_frequency|max_frequency|
    +-------+----------+-------------+-------------+
    |1      |140       |4            |36           |
    |2      |713       |2            |3            |
    |3      |1432      |1            |1            |
    +-------+----------+-------------+-------------+
 With this adjustment, it becomes clear that the target segment should not be Group 1
 (we may assume these customers have a somewhat emotional or habitual attachment to
 this specific pharmacy), but rather Groups 2 and 3.
 */