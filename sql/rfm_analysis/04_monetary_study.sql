/*
 Let’s take a look at how the score boundaries for monetary were determined when dividing customers into three equal groups.
 */

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
     monetary_scores as (select
                             barcode,
                             monetary,
                             ntile(3) over (order by monetary desc) as m_score
                         from rfm_base),
     median_val as (select
                        percentile_cont(0.5) within group (order by monetary) as median
                    from rfm_base)
select
    m_score,
    count(barcode) as group_size,
    min(monetary) as min_monetary,
    max(monetary) as max_monetary,
    median
from monetary_scores
cross join median_val
group by m_score, median
order by m_score;

/*
 Result:
+-------+----------+------------+------------+------+
|m_score|group_size|min_monetary|max_monetary|median|
+-------+----------+------------+------------+------+
|1      |762       |1123        |32058       |659   |
|2      |762       |389         |1122        |659   |
|3      |761       |24          |388         |659   |
+-------+----------+------------+------------+------+

 We are working with data that is three years old. We can see that the highest spending values differ from the median by two orders of magnitude. Let’s define Group 0 as customers who spent more than 4 000 rubles, and divide the remaining customers into three approximately equal groups.
 */

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
     monetary_scores as (select
                             barcode,
                             monetary,
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
    count(barcode) as group_size,
    min(monetary) as min_monetary,
    max(monetary) as max_monetary,
    median
from monetary_scores
cross join median_val
group by m_score, median
order by m_score;

/*
 Result:
+-------+----------+------------+------------+------+
|m_score|group_size|min_monetary|max_monetary|median|
+-------+----------+------------+------------+------+
|0      |142       |4028        |32058       |659   |
|1      |715       |966         |3979        |659   |
|2      |714       |363         |964         |659   |
|3      |714       |24          |363         |659   |
+-------+----------+------------+------------+------+

 */