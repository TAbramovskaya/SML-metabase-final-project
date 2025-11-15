with all_receipts as (select
                          dr_dat as purchase_date,
                          coalesce(min(dr_bcdisc) filter (where dr_bcdisc not in
                                                                ('200000000022', '200000000492', '200000000024',
                                                                 '200010000015', '200000000042', '200000000044',
                                                                 'NULL')),
                                   min(dr_bcdisc)) as barcode,
                          dr_nchk as receipt_id,
                          round(sum(dr_kol * dr_croz - dr_sdisc)::numeric, 2) as receipt_total
                      from sales
                      group by dr_dat, dr_tim, dr_nchk, dr_ndoc, dr_apt, dr_kkm, dr_tabempl),
     regular_receipts as (select *
                          from all_receipts
                          where barcode not in
                                ('200000000022', '200000000492', '200000000024', '200010000015',
                                 '200000000042', '200000000044', 'NULL')),
     rfm_base as (select
                      barcode,
                      '2022-06-09'::date - max(purchase_date) as recency,
                      count(receipt_id) as frequency,
                      sum(receipt_total) as monetary
                  from regular_receipts
                  group by barcode),
     rfm_scores as (select
                        barcode,
                        recency,
                        frequency,
                        monetary,
                        ntile(3) over (order by recency) as r_score,
                        case
                            when frequency >= 4 then 1
                            when frequency >= 2 then 2
                            else 3
                            end as f_score,
                        case
                            when monetary >= 4000 then 0
                            else ntile(3) over (partition by (monetary < 4000) order by monetary desc)
                            end as m_score
                    from rfm_base)
select
    barcode,
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
    count(barcode) as cohort_size,
    r_score::text || f_score::text || m_score::text as cohort_segment
from rfm_scores
group by r_score, f_score, m_score
order by  r_score, f_score, m_score;
/*
 Result:
+-----------+--------------+
|cohort_size|cohort_segment|
+-----------+--------------+
|41         |110           |
|54         |111           |
|9          |112           |
|33         |120           |
|161        |121           |
|101        |122           |
|29         |123           |
|7          |130           |
|71         |131           |
|99         |132           |
|157        |133           |
|6          |210           |
|21         |211           |
|3          |212           |
|27         |220           |
|125        |221           |
|98         |222           |
|30         |223           |
|8          |230           |
|94         |231           |
|153        |232           |
|197        |233           |
|1          |310           |
|4          |311           |
|1          |312           |
|5          |320           |
|53         |321           |
|40         |322           |
|11         |323           |
|14         |330           |
|132        |331           |
|210        |332           |
|290        |333           |
+-----------+--------------+

 */