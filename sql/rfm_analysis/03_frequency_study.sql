/*
 Let’s take a look at how the score boundaries for frequency were determined when dividing customers into three equal groups.
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
     frequency_scores as (select
                              barcode,
                              frequency,
                              ntile(3) over (order by frequency desc) as f_score
                          from rfm_base)
select
    f_score,
    count(barcode) as group_size,
    min(frequency) as min_frequency,
    max(frequency) as max_frequency
from frequency_scores
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

 When dividing customers into three equal groups, Group 1 ended up with customers whose visit frequency varied too widely. We do not have data on customer age to compare their behavior with publicly available statistics, but we can assume that pharmacies are mainly used by nearby residents of older age groups. For them, it is typical to visit a pharmacy several times per month.

 In most large cities, several pharmacies are located within walking distance. Choosing a pharmacy is therefore determined not only by lower prices on a broad assortment, but also by personal preference. Older customers tend to stick with familiar services rather than trying new ones; they may also prefer to discuss sensitive health-related questions with pharmacy staff they know, rather than going to a new location.

 Thus, it seems reasonable to shift the boundary for Groep 1 from 2 visits in six weeks to 4. We will also define Group 2 as customers who made 2 or 3 visits during this six-week period.
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
     frequency_scores as (select
                              barcode,
                              frequency,
                              case
                                  when frequency >= 4 then 1
                                  when frequency >= 2 then 2
                                  else 3
                                  end as f_score
                          from rfm_base)
select
    f_score,
    count(barcode) as group_size,
    min(frequency) as min_frequency,
    max(frequency) as max_frequency
from frequency_scores
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

 With this adjustment, it becomes clear that the target segment should not be Group 1 (we may assume these customers have a somewhat emotional or habitual attachment to this specific pharmacy), but rather Groups 2 and 3.
 */