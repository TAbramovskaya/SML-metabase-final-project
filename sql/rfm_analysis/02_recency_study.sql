/*
 Let’s take a look at how the score boundaries for recency were determined when dividing customers into three equal groups.
 */

with regular_receipts as (select
                              dr_dat as purchase_date,
                              min(dr_bcdisc) as barcode,
                              dr_nchk as receipt_id,
                              round(sum(dr_kol * dr_croz - dr_sdisc)::numeric, 2) as receipt_total
                          from sales
                          group by dr_dat, dr_tim, dr_nchk, dr_ndoc, dr_apt, dr_kkm, dr_tabempl
                          having min(dr_bcdisc) not in
                                 ('200000000022', '200000000492', '200000000024', '200010000015', '200000000042',
                                  '200000000044', 'NULL')),
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
                        ntile(3) over (order by frequency desc) as f_score,
                        ntile(3) over (order by monetary desc) as m_score
                    from rfm_base)
select
    r_score,
    count(barcode) as group_size,
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
|1      |760       |0          |9          |
|2      |760       |9          |21         |
|3      |760       |21         |39         |
+-------+----------+-----------+-----------+

 One third of the users made their most recent purchase no more than 10 days before the final date in the dataset. We have a six-week observation window, during which more than two thirds of all customers made their last purchase in the second half of the period.
 */