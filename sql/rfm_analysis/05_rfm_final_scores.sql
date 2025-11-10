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
                      round(sum(dr_croz * dr_kol - dr_sdisc)::numeric, 0) as monetary
                  from regular_transactions
                  group by dr_bcdisc),
     rfm_scores as (select
                        card_number,
                        recency,
                        frequency,
                        monetary,
                        ntile(3) over (order by recency asc) as r_score,
                        case
                            when frequency >= 4 then 1
                            when frequency >= 2 then 2
                            else 3
                        end as f_score,
                        case
                            when monetary >= 4000 then 0
                            else ntile(3) over (partition by (monetary < 4000) order by monetary desc)
                        end as m_score
                    from rfm_base),
     median_val as (select
                        percentile_cont(0.5) within group (order by monetary) as median
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
order by  r_score, f_score, m_score;

 Result:
    +-----------+--------------+
    |cohort_size|cohort_segment|
    +-----------+--------------+
    |39         |110           |
    |54         |111           |
    |9          |112           |
    |33         |120           |
    |163        |121           |
    |101        |122           |
    |28         |123           |
    |7          |130           |
    |71         |131           |
    |99         |132           |
    |158        |133           |
    |7          |210           |
    |22         |211           |
    |3          |212           |
    |27         |220           |
    |123        |221           |
    |99         |222           |
    |29         |223           |
    |8          |230           |
    |93         |231           |
    |154        |232           |
    |197        |233           |
    |1          |310           |
    |4          |311           |
    |1          |312           |
    |5          |320           |
    |53         |321           |
    |39         |322           |
    |13         |323           |
    |14         |330           |
    |132        |331           |
    |210        |332           |
    |289        |333           |
    +-----------+--------------+

 */