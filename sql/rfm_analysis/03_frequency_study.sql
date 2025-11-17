/*
 Let’s take a look at how the score boundaries for frequency were determined when dividing customers into three equal groups. A full explanation of how CTEs below are constructed can be found at the beginning of the sql/rfm_analysis/01_rfm_base.sql
 */

with internal_use_and_null as (select
                                   unnest(array ['200000000022', '200000000492', '200000000024',
                                       '200010000015', '200000000042', '200000000044', 'NULL']) as bad_bc),
     all_receipts as (select
                          dr_dat as purchase_date,
                          coalesce(min(dr_bcdisc)
                                   filter (where dr_bcdisc not in (select bad_bc from internal_use_and_null)),
                                   min(dr_bcdisc)) as barcode,
                          dr_nchk as receipt_id,
                          round(sum(dr_kol * dr_croz - dr_sdisc)::numeric, 2) as receipt_total,
                          count(*) as number_of_items
                      from sales
                      group by dr_dat, dr_tim, dr_nchk, dr_ndoc, dr_apt, dr_kkm, dr_tabempl),
     regular_receipts as (select *
                          from all_receipts
                          where barcode not in (select bad_bc from internal_use_and_null)),
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

 When dividing customers into three equal groups, Group 1 ended up with customers whose visit frequency varied too widely. We do not have data on customer age to compare their behavior with publicly available statistics, but we can assume that pharmacies are mainly used by nearby residents. In most large cities, several pharmacies are located within walking distance. Choosing a pharmacy is therefore determined not only by lower prices on a broad assortment, but also by personal preference. Older customers tend to stick with familiar services rather than trying new ones; they may also prefer to discuss sensitive health-related questions with pharmacy staff they know, rather than going to a new location.

 We also see that most customers visit the pharmacy once or twice. Given that our observation window is six weeks, we will treat Group 3 as customers who visited the pharmacy only once.

 We will assign customers who visit the pharmacy two or three times to Group 2 — these may be customers who take certain medications on a daily basis and therefore require regular pharmacy visits, or simply customers who already prefer our pharmacy when they need certain products.

 Group 1 will include customers with 4 to 6 visits — within a six-week period this corresponds to weekly pharmacy visits, which I would interpret as “regular customers.” These may be, for example, young parents (small children often require special medications or baby products available in pharmacies), as well as older customers who visit pharmacies several times a month.

 Finally, Group 0 includes customers with more than 7 visits (the median for this group is 9 visits). Such visitors — assuming they are genuine customers and not barcodes we could not classify as for internal use — could be habitual customers who show a level of emotional attachment to the store.

 */

with internal_use_and_null as (select
                                   unnest(array ['200000000022', '200000000492', '200000000024',
                                       '200010000015', '200000000042', '200000000044', 'NULL']) as bad_bc),
     all_receipts as (select
                          dr_dat as purchase_date,
                          coalesce(min(dr_bcdisc)
                                   filter (where dr_bcdisc not in (select bad_bc from internal_use_and_null)),
                                   min(dr_bcdisc)) as barcode,
                          dr_nchk as receipt_id,
                          round(sum(dr_kol * dr_croz - dr_sdisc)::numeric, 2) as receipt_total,
                          count(*) as number_of_items
                      from sales
                      group by dr_dat, dr_tim, dr_nchk, dr_ndoc, dr_apt, dr_kkm, dr_tabempl),
     regular_receipts as (select *
                          from all_receipts
                          where barcode not in (select bad_bc from internal_use_and_null)),
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
                                  when frequency >= 7 then 0
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
|0      |29        |7            |36           |
|1      |111       |4            |6            |
|2      |713       |2            |3            |
|3      |1432      |1            |1            |
+-------+----------+-------------+-------------+

 */